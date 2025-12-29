## Project Overview

You are an expert software engineer and software architect. You are also expert in Input Method Editors (IME) and Input Method Frameworks (IMF).

You are helping to create a new IME called Rume, written in Rust. This project also contains an existing IME called Rime, written in C++, and a macOS client application called Squirrel written in Swift.

The approach to develop Rume is to create a separate, independent tool and use it along the existing Rime handlers. The goal is that Rume is a very minimal IME in this stage, just supporting ASCII.

The project also uses Nix for most of its dependencies, although for now it uses the system installed Clang and Swift. The goal is to use Nix whenever possible. Nix dependencies are automatically available in the shell via `direnv` (e.g. `cargo` or `make`).

The Rume C interface is defined in `rume/include/rume_api.h` which is generated from the Rust code.

## Commands

To build the Rume Rust code and run its tests and clippy checks: `(cd rume && make librume)`. Whenever making changes in the Rume code, run `(cd rume && make librume)` which is quick and would print any Clippy and tests issues. It will also run the C test. Make sure the command exits successfully. To build the Rume Extension (a Rime dependency, it is code which was originally written in C++ but is now rewritten in Rust), use: `(cd rume && make deps)`.

Whenever making changes, you should format the code with the project standards. Run `bash scripts/format-lint.sh` which quickly formats the code and displays linting issues if any. You should fix any linting errors printed. If the error is about files changed and not committed by git (last check in the script), consider it as fixed.

To test that the project still compiles from scratch, the current script is `bash scripts/local_setup_scratch.sh`. However you should rarely run this, only when finishing a long task which you want to manually test.

## Rume Setup

The code is in the `rume` directory. There are Rust tests inside `rume/src` and also a C test in `rume/test/rume_c`.

In the root directory there is a `flake.nix` file which is the main configuration for building the different tools in the project.

## Rime Setup

The previous C++ code for Rime is also in the `rume` directory, in `rume/src`. All files with the `.cc` extension are from Rime. If you change Rime files, you should run `make -C rume release`. The generated Rime binaries are in `rume/build/bin`.

## Build Setup

You will be using the Zsh shell when running commands. If you make changes in any Bash script or in any `Makefile`, and this change introductes new libraries, even if assumed that it would be available in macOS systems, make sure it is available in the Nix derivations and shells using those files. The Nix files are in `flake.nix` and in the `nix` directory.

Because the project is using submodules, when building a derivation you have to pass this option. For example: `nix build '.?submodules=1#rume'`.