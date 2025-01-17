#!/bin/bash
# Copyright (c) 2023-2024, NVIDIA CORPORATION

set -euo pipefail

rapids-logger "Download Wheel"
RAPIDS_PY_CUDA_SUFFIX="$(rapids-wheel-ctk-name-gen ${RAPIDS_CUDA_VERSION})"
RAPIDS_PY_WHEEL_NAME="pynvjitlink_${RAPIDS_PY_CUDA_SUFFIX}" rapids-download-wheels-from-s3 ./dist/

# This is the version of the suffix with a preceding hyphen. It's used
# everywhere except in the final wheel name.
PACKAGE_CUDA_SUFFIX="-${RAPIDS_PY_CUDA_SUFFIX}"

rapids-logger "Install wheel"
pip install --find-links ./dist pynvjitlink${PACKAGE_CUDA_SUFFIX}

rapids-logger "Build Tests"
pushd test_binary_generation
make
popd

rapids-logger "Run Tests"
pip install pytest
pytest pynvjitlink/tests
