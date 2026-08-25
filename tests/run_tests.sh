#!/bin/bash
set -e

# Get repository root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${ROOT_DIR}"

echo "=================================================="
echo "  Running odit Automated Test Suite               "
echo "=================================================="

# Check if Odin compiler is available
if ! command -v odin &> /dev/null; then
    echo "[-] Error: 'odin' compiler not found in PATH." >&2
    exit 1
fi

echo "[*] Odin compiler: $(odin version)"

# Check if libgit2 static library is built
if [ ! -f "${ROOT_DIR}/libs/build/libgit2.a" ]; then
    echo "[*] Static library libs/build/libgit2.a not found. Building with CMake..."
    cd "${ROOT_DIR}/libs"
    cmake -B build -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTS=OFF -DBUILD_CLI=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    cmake --build build -j"$(nproc)"
    cd "${ROOT_DIR}"
fi

echo "[+] Static library verified: libs/build/libgit2.a ($(du -h libs/build/libgit2.a | cut -f1))"
echo "[*] Compiling and running tests..."
echo ""

odin test tests -all-packages "$@"

echo ""
echo "=================================================="
echo "  All tests executed successfully!                "
echo "=================================================="
