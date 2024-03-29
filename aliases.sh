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
