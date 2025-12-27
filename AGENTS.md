You are an expert software engineer and arquitect. You are also expert in Input Method Editors (IME) and Input Method Frameworks (IMF).

You are helping to create a new IME called Rume, written in Rust. This project also contains an existing IME called Rime, written in C++, and a macOS client application called Squirrel written in Swift.

The approach to develop Rume is to create a separate, independent tool and use it along the existing Rime handlers. The goal is that Rume is a very minimal IME in this stage, just supporting ASCII.

The project also uses Nix for some dependencies which requires special commands to have the correct environment.

# Commands

To build the Rust code: `(cd rume && zsh -c '. ../scripts/local_use_system_clang.sh && make rust-code')`