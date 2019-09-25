#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This function checks to make sure that every
# shebang has a '- e' flag, which causes it
# to exit on error

# find_files is a helper to exclude .git directories and match only regular
# files to avoid double-processing symlinks.
find_files() {
  local pth="$1"
  shift
  find "${pth}" '(' -path '*/.git' -o -path '*/.terraform' ')' \
    -prune -o -type f "$@"
}

# Create a temporary file in the auto-cleaned up directory while avoiding
# overwriting TMPDIR for other processes.
# shellcheck disable=SC2120 # (Arguments may be passed, e.g. maketemp -d)
maketemp() {
  TMPDIR="${DELETE_AT_EXIT}" mktemp "$@"
}


# Compatibility with both GNU and BSD style xargs.
compat_xargs() {
  local compat=() rval
  # Test if xargs is GNU or BSD style.  GNU xargs will succeed with status 0
  # when given --no-run-if-empty and no input on STDIN.  BSD xargs will fail and
  # exit status non-zero If xargs fails, assume it is BSD style and proceed.
  # stderr is silently redirected to avoid console log spam.
  if xargs --no-run-if-empty </dev/null 2>/dev/null; then
    compat=("--no-run-if-empty")
  fi
  xargs "${compat[@]}" "$@"
  rval="$?"
  if [[ -z "${NOWARN:-}" ]] && [[ "${rval}" -gt 0 ]]; then
    echo "Warning: compat_xargs $* failed with exit code ${rval}" >&2
  fi
  return "${rval}"
}

# This function makes sure that the required files for
# releasing to OSS are present
function basefiles() {
  local fn required_files="LICENSE README.md"
  echo "Checking for required files ${required_files}"
  for fn in ${required_files}; do
    test -f "${fn}" || echo "Missing required file ${fn}"
  done
}

function check_bash() {
find . -name "*.sh" | while IFS= read -d '' -r file;
do
  if [[ "$file" != *"bash -e"* ]];
  then
    echo "$file is missing shebang with -e";
    exit 1;
  fi;
done;
}

# This function makes sure that the required files for
# releasing to OSS are present
function basefiles() {
  echo "Checking for required files"
  test -f LICENSE || echo "Missing LICENSE"
  test -f README.md || echo "Missing README.md"
}

# This function runs 'terraform validate' against all
# files ending in '.tf'

function check_terraform() {
  local rval=125
  # fmt is before validate for faster feedback, validate requires terraform
  # init which takes time.
  echo "Running terraform fmt"
  find_files . -name "*.tf" -exec terraform fmt  -check=true -write=false {} \;
  rval="$?"
  if [[ "${rval}" -gt 0 ]]; then
    echo "Error: terraform fmt failed with exit code ${rval}" >&2
    echo "Check the output for diffs and correct using terraform fmt <dir>" >&2
    return "${rval}"
  fi
  echo "Running terraform validate"
  local DIRS_TF=""
  local BASEPATH=""
  BASEPATH="$(pwd)"
  DIRS_TF=$(find_files . -not -path "./test/fixtures/shared/*" -name "*.tf" -print0 | compat_xargs -0 -n1 dirname | sort -u)
  for  DIR_TF in $DIRS_TF
    do
      # shellcheck disable=SC2164
      cd "$DIR_TF"
      terraform init && terraform validate && rm -rf .terraform
      # shellcheck disable=SC2164
      cd "$BASEPATH"
    done
}

# This function runs 'go fmt' and 'go vet' on every file
# that ends in '.go'
function golang() {
  echo "Running go fmt and go vet"
  find . -name "*.go" -exec go fmt {} \;
  find . -name "*.go" -exec go vet {} \;
}

# This function runs the flake8 linter on every file
# ending in '.py'
function check_python() {
  echo "Running flake8"
  find . -name "*.py" -exec flake8 {} \;
}

# This function runs the shellcheck linter on every
# file ending in '.sh'
function check_shell() {
  echo "Running shellcheck"
  find . -name "*.sh" -exec shellcheck -x {} \;
}

# This function makes sure that there is no trailing whitespace
# in any files in the project.
# There are some exclusions
function check_trailing_whitespace() {
  echo "The following lines have trailing whitespace"
  grep -r '[[:blank:]]$' --exclude-dir=".terraform" --exclude-dir=".kitchen" --exclude="*.png" --exclude="*.pyc" --exclude-dir=".git" .
  rc=$?
  if [ $rc = 0 ]; then
    exit 1
  fi
}

function generate_docs() {
  echo "Generating markdown docs with terraform-docs"
  local pth helper_dir rval
  helper_dir="$(pwd)/helpers"
  while read -r pth; do
    if [[ -e "${pth}/README.md" ]]; then
      (cd "${pth}" || return 3; "${helper_dir}"/terraform_docs .;)
      rval="$?"
      if [[ "${rval}" -gt 0 ]]; then
        echo "Error: terraform_docs in ${pth} exit code: ${rval}" >&2
        return "${rval}"
      fi
    else
      echo "Skipping ${pth} because README.md does not exist."
    fi
  done < <(find_files . -name '*.tf' -print0 \
    | compat_xargs -0 -n1 dirname \
    | sort -u)
}


function prepare_test_variables() {
  echo "Preparing terraform.tfvars files for integration tests"
  #shellcheck disable=2044
  for i in $(find ./test/fixtures -type f -name terraform.tfvars.sample); do
    destination=${i/%.sample/}
    if [ ! -f "${destination}" ]; then
      cp "${i}" "${destination}"
      echo "${destination} has been created. Please edit it to reflect your GCP configuration."
    fi
  done
}

function check_headers() {
  echo "Checking file headers"
  # Use the exclusion behavior of find_files
  find_files . -print0 \
    | compat_xargs -0 test/verify_boilerplate.py
}
