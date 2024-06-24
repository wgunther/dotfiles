alias nvim=~/.local/nvim
alias gs=~/.local/gs
alias vim=nvim
alias gcplogin="gcloud auth application-default login"
alias xl='git --no-pager log --oneline --graph --decorate `git branch | tr -d " *" | awk "{ print \\"master~1..\\"\\$0 }"`'
alias xl=~/.local/xl

alias pull_dotfiles="(cd /workspaces/.codespaces/.persistedshare/dotfiles; git pull)"
alias cdb="cd /workspaces/$(echo $GITHUB_REPOSITORY | cut -d'/' -f2)"



# Git Aliases
git config --global alias.undo 'reset --soft HEAD^'
# Do --update-refs by default on rebases.
git config --global --add --bool rebase.updateRefs true

git config --global alias.amend 'commit --amend  --no-edit'

# nvim as default editor
git config --global core.editor ~/.local/nvim
gh config set editor ~/.local/nvim

export LS_COLORS='di=1;32:ln=1;30;47:so=30;45:pi=30;45:ex=1;31:bd=30;46:cd=30;46:su=30'
export LS_COLORS="${LS_COLORS};41:sg=30;41:tw=30;41:ow=30;41:*.rpm=1;31:*.deb=1;31"
export LSCOLORS=CxahafafBxagagabababab
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit
