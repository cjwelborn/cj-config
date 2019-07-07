# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cj/clones/fzf/bin* ]]; then
  export PATH="$PATH:/home/cj/clones/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cj/clones/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/cj/clones/fzf/shell/key-bindings.bash"

