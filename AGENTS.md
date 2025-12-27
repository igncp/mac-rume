## Project Overview

You are an expert software engineer and software architect. You are also expert in Input Method Editors (IME) and Input Method Frameworks (IMF).

You are helping to create a new IME called Rume, written in Rust. This project also contains an existing IME called Rime, written in C++, and a macOS client application called Squirrel written in Swift.

The approach to develop Rume is to create a separate, independent tool and use it along the existing Rime handlers. The goal is that Rume is a very minimal IME in this stage, just supporting ASCII.

The project also uses Nix for some dependencies, although for now it uses the system installed Clang and Swift. The goal is to use Nix whenever possible.

The Rume C interface is defined in `rume/include/rume_api.h` which is generated from the Rust code.

## Commands

To build the Rust code and run its tests: `(cd rume && make rust-code)`

## Rume Setup

The code is in the `rume` directory. There are Rust tests inside `rume/src` and also a C test in `rume/test/rume_c`.