#!/bin/bash

# Go Version Installer Script
# Usage: sudo ./gvm.sh <version>
# Example: sudo ./gvm.sh 1.24.4

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if version argument is provided
if [ $# -eq 0 ]; then
    print_error "Please provide Go version as argument"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.24"
    exit 1
fi

GO_VERSION="$1"
DOWNLOAD_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_FILE="go${GO_VERSION}.linux-amd64.tar.gz"
INSTALL_DIR="/usr/local"

print_info "Starting Go ${GO_VERSION} installation..."
print_info "Download URL: ${DOWNLOAD_URL}"

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    print_warning "This script requires root privileges to install to /usr/local"
    print_info "Please run with sudo: sudo $0 $1"
    exit 1
fi

# Create temporary directory for download
TEMP_DIR=$(mktemp -d)
DOWNLOAD_PATH="$TEMP_DIR/$DOWNLOAD_FILE"

# Set up trap to clean up on exit (success or failure)
cleanup() {
    print_info "Cleaning up temporary files..."
    rm -f "$DOWNLOAD_PATH" 2>/dev/null || true
    rm -rf "$TEMP_DIR" 2>/dev/null || true
}
trap cleanup EXIT

cd "$TEMP_DIR"
print_info "Working in temporary directory: $TEMP_DIR"

# Download Go
print_info "Downloading Go ${GO_VERSION}..."
if command -v wget >/dev/null 2>&1; then
    wget -O "$DOWNLOAD_FILE" "$DOWNLOAD_URL"
elif command -v curl >/dev/null 2>&1; then
    curl -L -o "$DOWNLOAD_FILE" "$DOWNLOAD_URL"
else
    print_error "Neither wget nor curl is available. Please install one of them."
    exit 1
fi

# Verify download
if [ ! -f "$DOWNLOAD_FILE" ]; then
    print_error "Download failed. File not found."
    exit 1
fi

print_success "Download completed"

# Remove any existing Go installation
print_info "Removing any existing Go installation..."
rm -rf /usr/local/go 2>/dev/null || true
print_success "Old Go installation removed (if any existed)"

# Extract to /usr/local
print_info "Extracting Go to ${INSTALL_DIR}..."
tar -C /usr/local -xzf "$DOWNLOAD_FILE"
print_success "Go extracted successfully"

# Delete the tar file
print_info "Deleting downloaded tar file..."
rm -f "$DOWNLOAD_FILE"
print_success "Tar file deleted"

# Set proper permissions
chmod -R 755 /usr/local/go
print_success "Permissions set"

# Clean up temporary directory
cd /
rm -rf "$TEMP_DIR"
print_success "Temporary files cleaned up"

# Check if Go is in PATH
print_info "Checking Go installation..."
if /usr/local/go/bin/go version >/dev/null 2>&1; then
    INSTALLED_VERSION=$(/usr/local/go/bin/go version)
    print_success "Go installed successfully: $INSTALLED_VERSION"
else
    print_error "Go installation verification failed"
    exit 1
fi

# PATH setup reminder
echo
print_info "Installation complete!"
print_warning "Make sure to add Go to your PATH if not already done:"
echo "export PATH=\$PATH:/usr/local/go/bin"
echo
print_info "Add the above line to your ~/.bashrc or ~/.profile"
print_info "Then run: source ~/.bashrc"
echo
print_info "Verify installation with: go version"
