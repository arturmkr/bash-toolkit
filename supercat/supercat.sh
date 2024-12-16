#!/usr/bin/env bash
set -euo pipefail

# Defaults
RECURSIVE="off"
HIDDEN="off"
TYPES=""
DIR=""

print_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [DIRECTORY]

Options:
  -r, --recursive         Enable recursion into subdirectories (default off)
  -H, --hidden            Include hidden files and directories (default off)
  -t, --types EXTENSIONS  Comma-separated list of file extensions (e.g. py,txt)
                          If not provided, all file types are included.
  -h, --help              Show this help message

If DIRECTORY is not specified, the current directory (.) will be used.

Examples:
  $(basename "$0")
  $(basename "$0") ./mydir
  $(basename "$0") -r -H -t py,txt ./mydir
  $(basename "$0") --recursive --hidden --types=py,txt ./mydir
  $(basename "$0") ./mydir -rH --types py,txt

Short flags can be combined:
  $(basename "$0") -rH -t py,txt ./mydir
EOF
}

ARGS=("$@")
i=0
while [[ $i -lt ${#ARGS[@]} ]]; do
    arg="${ARGS[$i]}"
    case "$arg" in
        -h|--help)
            print_help
            exit 0
            ;;
        -r|--recursive)
            RECURSIVE="on"
            ;;
        -H|--hidden)
            HIDDEN="on"
            ;;
        -t)
            i=$((i+1))
            if [[ $i -ge ${#ARGS[@]} ]]; then
                echo "Error: -t requires an argument."
                exit 1
            fi
            TYPES="${ARGS[$i]}"
            ;;
        --types)
            # Next argument is types
            i=$((i+1))
            if [[ $i -ge ${#ARGS[@]} ]]; then
                echo "Error: --types requires an argument."
                exit 1
            fi
            TYPES="${ARGS[$i]}"
            ;;
        --types=*)
            # Extract types from --types=ext
            TYPES="${arg#--types=}"
            ;;
        -[rHt][rHt]*)
            # Handle combined short flags like -rH or -rHt
            combined="${arg#-}"
            # We'll parse them char by char
            len=${#combined}
            j=0
            while (( j < len )); do
                c="${combined:j:1}"
                case "$c" in
                    r)
                        RECURSIVE="on"
                        ;;
                    H)
                        HIDDEN="on"
                        ;;
                    t)
                        # -t must be last if combined because it needs an argument
                        if (( j < len-1 )); then
                            echo "Error: -t must be last in a combined set as it requires an argument."
                            exit 1
                        fi
                        i=$((i+1))
                        if (( i >= ${#ARGS[@]} )); then
                            echo "Error: -t requires an argument."
                            exit 1
                        fi
                        TYPES="${ARGS[$i]}"
                        ;;
                    *)
                        echo "Error: Unknown short option -$c"
                        exit 1
                        ;;
                esac
                j=$((j+1))
            done
            ;;
        -*)
            echo "Error: Unknown option $arg"
            exit 1
            ;;
        *)
            # This should be the directory
            if [[ -n "$DIR" ]]; then
                echo "Error: Multiple directories specified: '$DIR' and '$arg'"
                exit 1
            fi
            DIR="$arg"
            ;;
    esac
    i=$((i+1))
done

# If no directory specified, use current directory
if [[ -z "$DIR" ]]; then
    DIR="."
fi

if [[ ! -d "$DIR" ]]; then
    echo "Error: $DIR is not a directory."
    exit 1
fi

# Build find command
find_cmd=(find "$DIR")

# Handle recursion
if [[ "$RECURSIVE" == "off" ]]; then
    find_cmd+=(-maxdepth 1)
fi

# Handle hidden
if [[ "$HIDDEN" == "off" ]]; then
    find_cmd+=(-not -path '*/.*')
fi

find_cmd+=(-type f)

if [[ -n "$TYPES" ]]; then
    IFS=',' read -ra EXT_ARR <<< "$TYPES"
    find_cmd+=("(")
    first=true
    for ext in "${EXT_ARR[@]}"; do
        if $first; then
            find_cmd+=(-iname "*.$ext")
            first=false
        else
            find_cmd+=(-o -iname "*.$ext")
        fi
    done
    find_cmd+=(")")
fi

file_count=0
while IFS= read -r file; do
    echo "----------"
    echo "$file"
    cat "$file"
    echo
    file_count=$((file_count+1))
done < <("${find_cmd[@]}")

echo "----------"
echo "Total files: $file_count"
