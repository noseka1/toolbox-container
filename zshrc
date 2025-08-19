# These key bindings were created based on the /etc/zsh/zshrc in Debian 13
# It fixes the BackSpace, Del, Home, End, ... keyboard bindings

bindkey -M emacs "^?" backward-delete-char
bindkey -M emacs "^[[1~" beginning-of-line
bindkey -M emacs "^[[H" beginning-of-line
bindkey -M emacs "^[[4~" end-of-line
bindkey -M emacs "^[[F" end-of-line
bindkey -M emacs "^[[2~" overwrite-mode
bindkey -M emacs "^[[3~" delete-char
bindkey -M emacs "^[[A" up-line-or-history
bindkey -M emacs "^[[B" down-line-or-history
bindkey -M emacs "^[[D" backward-char
bindkey -M emacs "^[[C" forward-char
