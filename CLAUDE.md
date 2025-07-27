# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AutoGen is a framework for creating multi-agent AI applications that can act autonomously or work alongside humans. The repository contains implementations in both Python and .NET with a layered, extensible architecture.

### Repository Structure

- `python/` - Python implementation with workspace-based package management via `uv`
- `dotnet/` - .NET implementation with MSBuild project structure
- `docs/` - Documentation and design specifications
- `protos/` - Protocol buffer definitions for cross-language communication

## Common Development Commands

### Python Development

All Python commands should be run from the `python/` directory:

```bash
# Setup virtual environment with all dependencies
uv sync --all-extras
source .venv/bin/activate

# Format code
poe format

# Lint code
poe lint

# Type checking
poe mypy
poe pyright

# Run tests
poe test

# Run all checks (format, lint, mypy, pyright, test, docs checks)
poe check

# Documentation
poe docs-build    # Build documentation
poe docs-serve    # Auto-rebuild and serve docs locally
poe docs-clean    # Clean docs build directory
```

### .NET Development

All .NET commands should be run from the `dotnet/` directory:

```bash
# Build entire solution
dotnet build

# Run tests
dotnet test

# Build specific project
dotnet build src/AutoGen.Core/

# Run specific test project
dotnet test test/AutoGen.Tests/
```

## Architecture Overview

AutoGen uses a layered architecture with event-driven programming model:

### Core Architecture Layers

1. **Core API** (`autogen-core`, `Microsoft.AutoGen.Core`) - Event-driven agents, message passing, local/distributed runtime
2. **AgentChat API** (`autogen-agentchat`) - High-level API for rapid prototyping, built on Core API
3. **Extensions API** (`autogen-ext`) - LLM clients, code execution, and other capabilities

### Key Architectural Concepts

- **Event-Driven Model**: Agents subscribe to CloudEvents and publish events for communication
- **Agent Identity**: Agents identified by `(type, key)` tuples and activated on-demand
- **Topics System**: Uses `TopicId` with type/source components for message routing
- **Cross-Language Support**: gRPC enables Python/.NET interoperability
- **Distributed Options**: From single-process to fully distributed with Orleans/service mesh

### Python Package Structure

- `autogen-core`: Core runtime, agents, models, tools
- `autogen-agentchat`: Multi-agent workflows and chat patterns  
- `autogen-ext`: LLM integrations (OpenAI, Azure, Anthropic, etc.)
- `autogen-studio`: Web-based no-code GUI
- `agbench`: Benchmarking suite

### .NET Package Structure

**Legacy (AutoGen.*)**: 
- `AutoGen.Core`: Core abstractions and middleware
- `AutoGen.OpenAI`, `AutoGen.Anthropic`: LLM integrations
- `AutoGen.SemanticKernel`: Semantic Kernel integration

**Modern (Microsoft.AutoGen.*)**:
- `Microsoft.AutoGen.Core`: Event-driven core runtime
- `Microsoft.AutoGen.Contracts`: Agent interfaces and types
- `Microsoft.AutoGen.Core.Grpc`: gRPC runtime implementation

## Testing Patterns

### Python Testing
- Use `pytest` with fixtures for setup
- Mock external dependencies (no real API calls)
- Use `ReplayChatCompletionClient` for model client testing
- Skip tests requiring external services with `pytest.mark.skipif`

### .NET Testing
- Use xUnit with FluentAssertions
- Approval tests for complex output validation
- Mock dependencies with Moq

## Key Development Guidelines

### Code Conventions
- Follow existing code style and patterns in each language
- Check package dependencies exist before using new libraries
- Use workspace/solution-level dependency management
- Follow security best practices (no secrets in code/commits)

### Protocol Buffers
Generate protocol buffer code with:
```bash
# Python (from python/ directory)
poe gen-proto

# .NET (handled automatically in build)
```

### Documentation Standards
- Use Google-style docstrings in Python with Sphinx RST formatting
- Include Args, Returns, Raises, and Examples sections
- Reference classes/methods with `:class:`, `:meth:`, `:func:` directives
- Use `.. code-block:: python` for examples (validated by pyright)

## Common Troubleshooting

### Python Issues
- Run `uv sync --all-extras` after pulling changes to update dependencies
- Use virtual environment before running any commands
- Check `pyproject.toml` for package-specific task definitions

### .NET Issues  
- Ensure `dotnet build` succeeds before running tests
- Check `Directory.Build.props` for solution-wide settings
- Use `dotnet clean` if encountering build cache issues

### Cross-Platform Development
- Both platforms support Windows, macOS, and Linux
- gRPC enables seamless Python/.NET agent communication
- Use appropriate package managers (`uv` for Python, NuGet for .NET)