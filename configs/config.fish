if status is-interactive
    # Commands to run in interactive sessions can go here

# Maintenance Alias
alias maintain="yay -Syu && yay -Scc"
alias update="yay -Syu"
alias clean-cache="yay -Scc"
alias clean-orphans="yay -Qttdq | yay -Rns -"
alias packages="yay -Qq"

# Operations Alias
alias ls="ls -lah --color=always"
alias install="yay -S"
alias remove="yay -Rns"
alias force-remove="yay -Rdd"
alias search-local="yay -Qi"
alias search-repo="yay -Si"
alias edit="sudo nano"
alias delete="sudo rm -rf"
alias clear="clear && neofetch"
alias restart="source ~/.config/fish/config.fish"

# Git
alias update-alibi="cd ~/Repositories/alibi;git pull;cd"
alias update-personal="cd ~/Repositories/personal;git pull;cd"

neofetch

end
