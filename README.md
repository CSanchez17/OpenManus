# OpenManus Fork

> This is a fork of the original [OpenManus project](https://github.com/mannaandpoem/OpenManus).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A fork of OpenManus focusing on [your specific focus/improvements].

## Installation

### Using Python venv (Recommended)

1. Create and activate a virtual environment:

```bash
python -m venv .venv
# On Windows:
.venv\Scripts\activate
# On Unix/macOS:
# source .venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

## Configuration

1. Create a `config.toml` file in the `config` directory:

```bash
cp config/config.example.toml config/config.toml
```

2. Edit `config/config.toml` to add your API keys and customize settings:

```toml
[llm]
model = "gpt-4o"
base_url = "https://api.openai.com/v1"
api_key = "sk-..."  # Replace with your actual API key
max_tokens = 4096
temperature = 0.0
```

## Quick Start

Run OpenManus:

```bash
python main.py
```

## Changes from Original

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and changes.

## Original Project Attribution

This project is based on the original [OpenManus](https://github.com/mannaandpoem/OpenManus) by [@Xinbin Liang](https://github.com/mannaandpoem), [@Jinyu Xiang](https://github.com/XiangJinyu), and team.

## License

MIT License - See [LICENSE](LICENSE) file for details.
