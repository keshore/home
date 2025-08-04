alias ll='ls -ltr'
alias git_log='git log --graph --abbrev-commit'

if [ ! -x "$(which tree)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

which kubectl >/dev/null 2>&1 && {
    mkdir -p $HOME/.kube
    [ ! -f $HOME/.kube/kubectl_completion.sh ] && kubectl completion bash > $HOME/.kube/kubectl_completion.sh
    source $HOME/.kube/kubectl_completion.sh
}

which helm >/dev/null 2>&1 && {
    [ ! -f $HOME/.kube/helm_completion.sh ] && helm completion bash > $HOME/.kube/helm_completion.sh
    source $HOME/.kube/helm_completion.sh
}

which git >/dev/null 2>&1 && {
    [ ! -f $HOME/.git-completion.bash ] && curl -o $HOME/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    source $HOME/.git-completion.bash
}

function parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function cd() {
    builtin cd "$@" || return
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate 2>/dev/null
    fi
    
    if [ -f requirements.txt ]; then
        echo "Switching to Python virtual environment..."
        if [ -f .venv/bin/activate ] ;then
            source .venv/bin/activate
        else
            echo "Creating virtual environment..."
            python3 -m venv .venv
        fi
        source .venv/bin/activate
    fi

    if [ -f .env ] ; then
        echo "Loading environment variables from .env file..."
        source .env
    fi
}

cat<<-EOF

  Welcome Back, $(whoami)!

  System Uptime: $(uptime)
  Total Disk Space: $(df -h / | awk 'NR==2{print $2}')
  Used Disk Space: $(df -h / | awk 'NR==2{print $3}')
  Free Disk Space: $(df -h / | awk 'NR==2{print $4}')
  Number of Users Logged In: $(who | wc -l)
  Current User's Shell: $SHELL
  Current User's OS: $(uname -o)
  Current User's Kernel Version: $(uname -r)
  Current User's Architecture: $(uname -m)
  Current User's Public IP Address: $(curl -s ifconfig.me)
  All Known Ips: $(ifconfig | grep "inet " | awk '{ print $2 }' | tr '\n' ',')

EOF

export PS1='\n\[\e]0;[$(date "+%Y%m%d %H:%M:%S")] \u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[0;32m\][$(date "+%Y%m%d %H:%M:%S")]\[\033[0;31m\] \u@\h\[\033[01;34m\]:\[\033[01;34m\]\w\[\033[00m\] $(parse_git_branch)\n --> '
