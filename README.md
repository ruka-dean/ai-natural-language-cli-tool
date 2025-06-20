# AI Command Line Helper

A zsh command line assistant that leverages Ollama and local language models to generate terminal commands from natural language prompts. It includes command history context and confirmation prompts for safe execution.

## Features

- 🤖 **Natural Language to Commands**: Convert plain English requests to terminal commands
- 📚 **Context Aware**: Uses your recent command history for better suggestions
- ✅ **Safe Execution**: Always asks for confirmation before running commands
- 🔧 **Configurable Models**: Use any Ollama model, with llama3.2 as default
- 🎨 **Colorized Output**: Beautiful, easy-to-read terminal interface
- ⚡ **Multiple Usage Modes**: Run directly or source for persistent `ai` function
- 🧠 **Smart Model Detection**: Only treats first argument as model if it exists in Ollama
- 🛡️ **Robust Error Handling**: Handles missing Ollama, no history, network issues
- 🔄 **Multi-Command Support**: Generates and executes multiple commands for complex tasks
- 🎯 **Flexible Execution**: Choose to run all commands, step through individually, or skip
- ⏭️ **Interactive Mode**: Execute all commands with option to skip individual ones
- 📜 **History Integration**: All executed commands are added to zsh history for easy access
- 🧠 **Output Context**: Recent command outputs are captured and used as context for follow-up requests
- 🔄 **Conversational Workflow**: Ask follow-up questions about previous command results

## Prerequisites

- macOS (tested) or other Unix-like system
- [Ollama](https://ollama.ai) installed and running
- zsh shell
- At least one language model downloaded (e.g., llama3.2)

## Quick Start

1. **Install Ollama** (if not already installed):
   ```bash
   brew install ollama
   # or visit https://ollama.ai
   ```

2. **Download a model** (if not already done):
   ```bash
   ollama pull llama3.2
   ```

3. **Start Ollama service**:
   ```bash
   ollama serve
   ```

4. **Install the AI helper**:
   ```bash
   ./install.sh
   ```

5. **Start using it**:
   ```bash
   ai kill the process using port 8080
   ai find all .js files modified today
   ai show disk usage for current directory
   ```

## Installation

### Automatic Installation

Run the installation script:

```bash
git clone <this-repo>
cd ollama_commandline_assitant
./install.sh
```

The installer will:
- Check for Ollama installation
- Optionally download llama3.2 model
- Install the script to your PATH
- Optionally add the `ai` function to your `.zshrc` (recommended for full history integration)

### Manual Installation

1. Copy `ai-helper` to a directory in your PATH:
   ```bash
   cp ai-helper ~/.local/bin/
   chmod +x ~/.local/bin/ai-helper
   ```

2. (Optional) Add to your `.zshrc` for the `ai` function:
   ```bash
   echo "source ~/.local/bin/ai-helper" >> ~/.zshrc
   source ~/.zshrc
   ```

## Usage

### Direct Command Execution

```bash
# Basic usage with default model
ai-helper kill the process using port 8080

# Specify a different model
ai-helper llama3.1 find all docker containers

# More examples
ai-helper compress this directory into a tar.gz file
ai-helper show me the top 10 largest files in /var/log
```

### Using the `ai` Function (after sourcing)

```bash
# After running the installer or sourcing the script
ai kill the process using port 8080
ai llama3.1 find all .js files modified in last 24 hours
ai show git status and recent commits
ai clear context  # Clear command output history
```

### Example Session

```bash
$ ai kill the process using port 8080
Using model: llama3.2
Prompt: kill the process using port 8080

Generating command(s)...
Generated command(s):
1. lsof -ti:8080 | xargs kill -9

Execute this command? [y/N]: y
Executing...
```

## Configuration

### Environment Variables

- **OLLAMA_MODEL**: Set the default model
  ```bash
  export OLLAMA_MODEL=llama3.1
  ```

### Available Models

List available models:
```bash
ollama list
```

Download new models:
```bash
ollama pull codellama
ollama pull mistral
ollama pull llama3.1
```

## How It Works

1. **Context Collection**: Gathers your recent command history (last 10 commands) and recent command outputs (last 5 commands)
2. **Prompt Engineering**: Creates a specialized prompt for command generation including previous outputs
3. **AI Generation**: Sends the request to your chosen Ollama model with full context
4. **Command Parsing**: Cleans and formats the AI response, separating multiple commands
5. **User Confirmation**: Shows all commands and asks for execution preference
6. **Safe Execution**: Runs commands only after user approval with chosen execution mode
7. **Output Capture**: Captures command output and stores it for future context

## Safety Features

- **Always asks for confirmation** before executing any command
- **Filters command history** to avoid including previous AI helper calls
- **Error handling** for Ollama connectivity issues
- **Command validation** and cleanup to remove formatting artifacts

## Examples

| Natural Language Request | Generated Command |
|--------------------------|-------------------|
| "kill the process using port 8080" | `lsof -ti:8080 \| xargs kill -9` |
| "find all .js files modified today" | `find . -name "*.js" -mtime -1` |
| "show disk usage for current directory" | `du -sh .` |
| "list all docker containers" | `docker ps -a` |
| "compress this directory" | `tar -czf archive.tar.gz .` |
| "show git log last 5 commits" | `git log --oneline -5` |

### Multi-Command Examples

| Natural Language Request | Generated Commands |
|--------------------------|-------------------|
| "create a backup directory and copy all .txt files to it" | `mkdir backup`<br>`cp *.txt backup/` |
| "install a package and check its version" | `npm install express`<br>`npm list express` |
| "stop docker containers and clean up" | `docker stop $(docker ps -q)`<br>`docker system prune -f` |

## Multi-Command Execution

When the AI generates multiple commands for complex tasks, you'll see execution options:

```bash
$ ai create a new directory called test-dir and list its contents
Using model: llama3.2
Prompt: create a new directory called test-dir and list its contents

Generating command(s)...
Generated command(s):
1. mkdir test-dir
2. ls -l test-dir

Multiple commands detected. Choose an option:
  [a] Execute all commands in sequence
  [i] Execute all commands with option to skip individual commands
  [s] Execute commands one by one (with individual confirmation)
  [n] Don't execute any commands

Your choice [a/i/s/N]:
```

### Execution Options

- **[a] All commands**: Executes all commands in sequence, stopping if any command fails
- **[i] Interactive all**: Executes all commands but asks before each one with option to skip
  - `[Y]` - Execute this command (default)
  - `[n]` - Skip this command and continue with the next
  - `[q]` - Quit and stop executing remaining commands
  - If a command fails, asks whether to continue with remaining commands
- **[s] Step-by-step**: Shows each command individually and asks for confirmation
  - `[y]` - Execute this command
  - `[N]` - Skip this command
  - `[q]` - Quit and stop executing remaining commands
- **[n] No execution**: Don't execute any commands (default)

## History Integration

All commands executed through the AI helper are automatically added to your zsh history, making them easily accessible:

**Note**: History integration works best when the script is sourced (using the `ai` command). When run directly with `./ai-helper`, executed commands may not be added to the parent shell's history due to subprocess limitations.

### Accessing Executed Commands

- **Up Arrow Key**: Navigate through executed commands just like normal terminal commands
- **History Command**: See all executed commands with `history`
- **Search History**: Use `Ctrl+R` to search through executed commands
- **Repeat Commands**: Use `!!` for last command or `!command` to repeat specific commands

### Example Workflow

```bash
$ ai create backup directory and copy files
# ... executes: mkdir backup && cp *.txt backup/

$ ↑ (up arrow) 
$ cp *.txt backup/  # Shows the actual executed command

$ history | tail -5
 1234  ai create backup directory and copy files
 1235  mkdir backup
 1236  cp *.txt backup/
```

This means you can:
- Re-run individual commands without re-asking the AI
- Build upon previously generated commands
- Learn from the AI's command suggestions
- Access commands in scripts or other contexts

## Output Context & Conversational Workflow

The AI helper now captures the output of executed commands and uses it as context for follow-up requests. This enables powerful conversational workflows where you can ask questions about previous results.

### How It Works

- **Output Capture**: All command outputs are automatically captured (up to 1000 characters per command)
- **Context Storage**: Recent command outputs (last 5 commands) are stored and included in AI requests
- **Intelligent Reference**: The AI can reference specific files, processes, or information from previous outputs
- **Context Management**: Use `ai clear context` to reset the output history when starting fresh

### Example Conversational Workflows

#### File Analysis Workflow
```bash
$ ai list all files in current directory
# Output: ai-helper, config.example, install.sh, README.md, test.sh

$ ai show details of the README file from the previous output
# AI knows to use: cat README.md

$ ai count the number of lines in that file
# AI knows to use: wc -l README.md

$ ai find the largest file from the first listing
# AI references the original ls output to identify the largest file
```

#### Process Management Workflow
```bash
$ ai show all running python processes
# Output: Shows PID, command details, etc.

$ ai kill the process with the highest memory usage from that list
# AI analyzes the previous output to identify the specific PID

$ ai verify that process was terminated
# AI checks if the process is still running
```

#### Docker Workflow
```bash
$ ai list all docker containers
# Shows container IDs, names, status, etc.

$ ai stop the container that was created most recently from that list
# AI identifies the newest container from the previous output

$ ai check the logs of that container before it was stopped
# AI remembers which container was stopped
```

#### Git Analysis Workflow
```bash
$ ai show git status
# Shows modified files, branch info, etc.

$ ai add only the modified JavaScript files from that status
# AI identifies .js files from the git status output

$ ai show the diff for those files before committing
# AI knows which files were just added
```

### Context Management

- **Automatic**: Context is maintained across commands in the same session
- **Limited Storage**: Only the last 5 command outputs are kept to avoid overwhelming the AI
- **Clear Context**: Use `ai clear context` to start fresh when switching topics
- **Truncation**: Long outputs (>1000 chars) are automatically truncated

### Benefits

- **Reduced Repetition**: No need to re-specify file names, IDs, or paths
- **Intelligent Follow-up**: Ask natural follow-up questions about results
- **Complex Workflows**: Build multi-step processes with contextual awareness
- **Learning Aid**: See how the AI connects information across commands

## Testing

Run the test suite to verify everything is working:

```bash
./test.sh
```

The test script will check:
- Script executability
- Help output
- Ollama availability and service status
- Available models
- zsh compatibility
- Sourcing functionality

## Troubleshooting

### Ollama Not Found
```bash
# Install Ollama
brew install ollama
# or visit https://ollama.ai
```

### Ollama Service Not Running
```bash
ollama serve
```

### Model Not Available
```bash
ollama pull llama3.2
```

### Permission Issues
```bash
chmod +x ai-helper
# or
chmod +x ~/.local/bin/ai-helper
```

### PATH Issues
Add to your `.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Advanced Usage

### Custom System Prompts

The tool uses a carefully crafted system prompt optimized for command generation. The prompt includes:
- Context about the operating system (macOS/darwin)
- Recent command history
- Instructions for clean command output
- Support for multi-command sequences
- Safety guidelines

### Model Selection

You can use any Ollama model:
```bash
ai codellama optimize this python script for performance
ai mistral show me network connections
ai llama3.1:70b complex database query to find duplicates
```

### Smart Model Detection

The tool intelligently detects if the first argument is a valid Ollama model:
- If the first argument matches a model in `ollama list`, it's used as the model
- Otherwise, the entire input is treated as the prompt
- This prevents common words like "list", "show", "find" from being mistaken as models

### Multi-Command Parsing

The tool can handle commands separated by:
- **Newlines**: Each line is treated as a separate command
- **Semicolons**: Commands on the same line separated by `;`
- **Mixed**: Combination of both formats

### Integration with Other Tools

The AI helper works well with:
- Git workflows (clone, commit, push sequences)
- Docker operations (build, run, cleanup)
- File management (create, copy, organize)
- System administration (install, configure, monitor)
- Development tasks (setup, test, deploy)

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License - feel free to modify and distribute.

## Acknowledgments

- [Ollama](https://ollama.ai) for providing the local AI infrastructure
- The open-source LLM community for the amazing models