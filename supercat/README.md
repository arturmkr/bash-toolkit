# Supercat

A versatile alternative to `cat` for displaying the contents of multiple files with advanced features:

- **Recursion**: Display contents of files in subdirectories.
- **Hidden files**: Include hidden files and directories.
- **File type filtering**: Only display files with specified extensions.
- **Neat formatting**: Separator lines and total file count displayed.

#### Usage:

```bash
supercat [OPTIONS] [DIRECTORY]
```

**Options:**

- `-r, --recursive`        Enable recursion into subdirectories (default off).
- `-H, --hidden`           Include hidden files and directories (default off).
- `-t, --types EXTENSIONS` Comma-separated list of file extensions (e.g., py,txt). If not provided, all files are displayed.
- `-h, --help`             Show help message.

**Examples:**

- Default behavior (current directory, no recursion, no hidden files):
  ```bash
  supercat
  ```

- Recursively include hidden `.sh` files in the `scripts/` folder:
  ```bash
  supercat -rH -t sh ./scripts
  ```

- Long options example:
  ```bash
  supercat --recursive --hidden --types=py,txt ./mydir
  ```

- More examples:
  ```bash
  supercat ./path
  supercat -r -H --types py,txt ./path
  supercat --recursive --hidden --types=py,txt ./path
  supercat -H -r -t py,txt ./path
  supercat ./path -rH -t py,txt ./path
  ```
---

## Installation

### Local Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/bash-toolbelt.git
   cd bash-toolbelt
   ```

2. Make the desired utility executable and move it to a directory in your `PATH` (e.g., `~/bin`):
   ```bash
   chmod +x supercat.sh
   mkdir -p ~/bin
   cp supercat.sh ~/bin/supercat
   ```

3. Ensure `~/bin` is in your `PATH`. Add this to your shell configuration file (`~/.bashrc` or `~/.zshrc`):
   ```bash
   export PATH="$HOME/bin:$PATH"
   ```
4. Then reload your shell:
   ```bash
   source ~/.bashrc
   ```
    or:
   ```bash
   source ~/.zshrc
   ```

### Verification

Run `supercat` from any location:
```bash
supercat -h
```