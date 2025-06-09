# GVM - Go Version Manager

Simple shell script to install specific Go versions on Linux.

## Installation

```bash
curl -O https://raw.githubusercontent.com/gokpm/gvm/main/gvm.sh
chmod +x gvm.sh
sudo cp gvm.sh /usr/local/bin/gvm
```

## Usage

```bash
# Install Go version
sudo gvm 1.24.4

# Add to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify
go version
```

## What it does

- Removes old Go installation
- Downloads specified Go version from go.dev
- Extracts to `/usr/local/go`
- Cleans up temporary files

## Requirements

- Linux system
- sudo privileges  
- wget or curl

## Examples

```bash
sudo gvm 1.24.4
sudo gvm 1.23.6
sudo gvm 1.21.12
```

## Troubleshooting

**Permission denied**: Use `sudo gvm <version>`

**Command not found**: Make sure `/usr/local/bin` is in your PATH

**Go not found**: Add `export PATH=$PATH:/usr/local/go/bin` to `~/.bashrc`