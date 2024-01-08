# Code-Server Docker Image
This repository contains a Dockerfile for building a code-server image with pre-installed extensions.

## Overview
The Dockerfile is based on the latest version of the codercom/code-server image. It includes additional utilities and a set of Visual Studio Code extensions that are installed during the build process.

## Features
Based on codercom/code-server:latest.

Additional utilities installed: jq, xz-utils.

Nix package manager installed.

Pre-installed Visual Studio Code extensions for various languages and tools, including Go, Python, Rust, Nix, Kubernetes, Docker, ShellCheck, TOML, YAML, Terraform, and more.

Additional extensions for Markdown editing and other productivity tools.
