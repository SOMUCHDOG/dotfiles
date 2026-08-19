# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="crunch"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git jsontools)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export VISUAL='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="eza --color=always --icons=always -a --group-directories-first -s name $argv"
alias oo="cd \"$HOME/documents/Obsidian Vault/\" && nvim ."
alias zshrc="nvim ~/.zshrc"


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(fzf --zsh)"
export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$PATH:$HOME/Projects/admin-cli"
alias cobra="cobra-cli"

[[ -s "/Users/casey/.gvm/scripts/gvm" ]] && source "/Users/casey/.gvm/scripts/gvm"

# Flatten and rename audio samples
# Usage: flatten-samples [source_dir] [output_dir] [--dry-run]
flatten-samples() {
    local src_dir="${1:-.}"
    local output_dir="${2:-./flattened_samples}"
    local dry_run=false

    # Check for dry-run flag
    for arg in "$@"; do
        if [[ "$arg" == "--dry-run" ]]; then
            dry_run=true
        fi
    done

    # Create output directory if not dry run
    if [[ "$dry_run" == false ]] && [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
    fi

    count=0
    skipped=0

    echo "Flattening samples from: $src_dir"
    echo "Output directory: $output_dir"
    if [[ "$dry_run" == true ]]; then
        echo "DRY RUN - No files will be moved"
    fi
    echo "---"

    # Find all audio files and process them
    while IFS= read -r -d '' file; do
        local filepath="$file"
        local filename=$(basename "$file")
        local ext="${filename##*.}"
        local name="${filename%.*}"

        # Determine if loop or one-shot
        local type="loop"
        if [[ "$filepath" == *oneshot* || "$filepath" == *one_shot* || "$filepath" == *one-shot* ]] || [[ "$name" == *oneshot* || "$name" == *one_shot* || "$name" == *one-shot* ]]; then
            type="oneshot"
        fi

        # Extract BPM (look for numbers between 60-200)
        local bpm=""
        if [[ "$name" =~ ([_-]|^)([0-9]{2,3})([_-]|bpm|BPM) ]]; then
            local potential_bpm="${match[2]}"
            if [[ "$potential_bpm" -ge 60 ]] && [[ "$potential_bpm" -le 200 ]]; then
                bpm="${potential_bpm}"
            fi
        fi

        # Extract key (musical key notation)
        local key=""
        if [[ "$name" =~ ([A-G][#b]?(maj|min|m|M))([_-]|$) ]]; then
            key="${match[1]}"
        fi

        # Determine category from path and filename
        local category=""
        local lower_path=$(echo "$filepath" | tr '[:upper:]' '[:lower:]')
        local lower_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

        # Prioritized category detection
        if [[ "$lower_path" == *drum* || "$lower_path" == *perc* || "$lower_path" == *break* ]] || [[ "$lower_name" == *drum* || "$lower_name" == *perc* || "$lower_name" == *break* ]]; then
            category="drum"
        elif [[ "$lower_path" == *bass* ]] || [[ "$lower_name" == *bass* ]]; then
            category="bass"
        elif [[ "$lower_path" == *guitar* ]] || [[ "$lower_name" == *guitar* ]]; then
            category="guitar"
        elif [[ "$lower_path" == *synth* ]] || [[ "$lower_name" == *synth* ]]; then
            category="synth"
        elif [[ "$lower_path" == *vocal* ]] || [[ "$lower_name" == *vocal* ]]; then
            category="vocal"
        elif [[ "$lower_path" == *piano* || "$lower_path" == *keys* ]] || [[ "$lower_name" == *piano* || "$lower_name" == *keys* ]]; then
            category="keys"
        elif [[ "$lower_path" == *horn* || "$lower_path" == *brass* || "$lower_path" == *trumpet* ]] || [[ "$lower_name" == *horn* || "$lower_name" == *brass* || "$lower_name" == *trumpet* ]]; then
            category="brass"
        elif [[ "$lower_path" == *string* ]] || [[ "$lower_name" == *string* ]]; then
            category="strings"
        elif [[ "$lower_path" == *fx* || "$lower_path" == *transition* ]] || [[ "$lower_name" == *fx* || "$lower_name" == *transition* ]]; then
            category="fx"
        elif [[ "$lower_path" == *melodic* || "$lower_path" == *music* || "$lower_path" == *song* ]] || [[ "$lower_name" == *melodic* || "$lower_name" == *music* || "$lower_name" == *song* ]]; then
            category="melodic"
        else
            category="other"
        fi

        # Clean up description
        # Remove common prefixes, BPM, key, and underscores/dashes
        local description="$name"

        # Remove common vendor prefixes (2-6 uppercase letters followed by underscore)
        description=$(echo "$description" | sed -E 's/^[A-Z_]{2,15}_//')

        # Remove BPM
        if [[ -n "$bpm" ]]; then
            description=$(echo "$description" | sed -E "s/[_-]?${bpm}[_-]?([bB][pP][mM])?[_-]?//g")
        fi

        # Remove key
        if [[ -n "$key" ]]; then
            description=$(echo "$description" | sed -E "s/[_-]?${key}[_-]?//g")
        fi

        # Remove type indicators
        description=$(echo "$description" | sed -E 's/[_-]?(loop|oneshot|one_shot|one-shot)[_-]?//gi')

        # Remove category if present
        description=$(echo "$description" | sed -E "s/[_-]?${category}[_-]?//gi")

        # Clean up multiple underscores/dashes and trim
        description=$(echo "$description" | sed -E 's/[_-]+/_/g' | sed -E 's/^[_-]+|[_-]+$//')

        # Convert to lowercase for consistency
        description=$(echo "$description" | tr '[:upper:]' '[:lower:]')

        # Limit description length
        if [[ ${#description} -gt 40 ]]; then
            description="${description:0:40}"
        fi

        # Build new filename: [type]_[category]_[description]_[bpm]_[key].ext
        local new_name="${type}_${category}"

        if [[ -n "$description" ]]; then
            new_name="${new_name}_${description}"
        fi

        if [[ -n "$bpm" ]]; then
            new_name="${new_name}_${bpm}"
        fi

        if [[ -n "$key" ]]; then
            new_name="${new_name}_${key}"
        fi

        new_name="${new_name}.${ext}"

        # Handle duplicates by appending a number
        local final_path="${output_dir}/${new_name}"
        local counter=1
        while [[ -f "$final_path" ]] && [[ "$dry_run" == false ]]; do
            local base="${new_name%.*}"
            final_path="${output_dir}/${base}_${counter}.${ext}"
            ((counter++))
        done

        if [[ "$dry_run" == true ]]; then
            echo "$filename"
            echo "  -> $new_name"
            ((count++))
        else
            # Copy file to new location with new name
            cp "$file" "$final_path"
            if [[ $? -eq 0 ]]; then
                echo "✓ $new_name"
                ((count++))
            else
                echo "✗ Failed: $filename"
                ((skipped++))
            fi
        fi
    done < <(find "$src_dir" -type f \( -iname "*.wav" -o -iname "*.mp3" -o -iname "*.aif" -o -iname "*.aiff" -o -iname "*.flac" \) -print0)

    echo "---"
    echo "Processed: $count files"
    if [[ $skipped -gt 0 ]]; then
        echo "Skipped: $skipped files"
    fi
    if [[ "$dry_run" == false ]]; then
        echo "Output: $output_dir"
    fi
}
export PATH="$HOME/.local/bin:$PATH"
