#!/usr/bin/env bash

# Copyright 2021 The Clusternet Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
CODEGEN_PKG=${CODEGEN_PKG:-$(
  cd "${SCRIPT_ROOT}"
  go mod vendor
  ls -d -1 ./vendor/k8s.io/code-generator
)}

bash "${CODEGEN_PKG}/kube_codegen.sh" all \
  github.com/clusternet/clusternet/pkg/generated \
  github.com/clusternet/clusternet/pkg/apis \
  "apps:v1alpha1 clusters:v1beta1 proxies:v1alpha1" \
  --output-base "$(dirname "${BASH_SOURCE[0]}")/../../../.." \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate.go.txt"

bash "${CODEGEN_PKG}/kube_codegen.sh" "deepcopy,defaulter,conversion,openapi" \
  github.com/clusternet/clusternet/pkg/generated \
  github.com/clusternet/clusternet/pkg/apis github.com/clusternet/clusternet/pkg/apis \
  "proxies:v1alpha1" \
  --output-base "$(dirname "${BASH_SOURCE[0]}")/../../../.." \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate.go.txt"
