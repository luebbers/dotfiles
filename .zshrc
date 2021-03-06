# Path to your oh-my-zsh installation.
export ZSH=/$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="nicoulaj"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# source local per-host config
if [ -e $HOME/.localsetup ]; then
   source $HOME/.localsetup
fi

export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=$LANG

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR=vim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Tmux aliases
if [ ! -z $TMUXCONF ]; then
   alias tmux="tmux -2 -f $TMUXCONF"
else
   alias tmux="tmux -2"
fi
alias tm="tmux"
alias ta="tmux attach -t"
alias tra="tmux attach"             # reattach to last session
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"

# disable flow control (I want to use CTRL-S for other things)
stty -ixon

# fix dircolors for solarized dark
eval `dircolors ~/.dircolors-dark`

# don't share history between shells
unsetopt sharehistory

# set mc solarized theme
export MC_SKIN=$HOME/.mc/solarized.ini

# save (possibly changed) DISPLAY variable for use with tmux
echo $DISPLAY > $HOME/.display
alias ud="export DISPLAY=\$(cat $HOME/.display)"

# import autoenv-zsh
source ~/.dotfiles/lib/zsh-autoenv/autoenv.zsh

# If not root or other environment where we don't want this, check for
# existing tmux sessions If one exists, offer to attach, otherwise offer to
# create new.
if [ -z "$TMUX" -a "$SSH_CONNECTION" != "" ]; then      # only try this outside of a tmux session and via SSH
   TSESS=`tmux list-sessions`
   if [ $? -ne 0 ]; then     # no sessions
      echo -n "No tmux sessions running, creating one in "
      KEY=0
      for i in 3 2 1 ; do
         echo -n "$i..."
         if read -k -r -s -t 0.5 a; then
            KEY=1
            break;
         fi
      done
      if [ $KEY -eq 0 ]; then
         tmux
      else
         echo "aborted."
      fi
   else
      if [ `echo $TSESS | wc -l` -gt 1 ]; then    # more than one session
         if [ `echo $TSESS | wc -l` -gt 10 ]; then # more than ten sessions
            echo "More than ten sessions running, please handle that yourself:"
            echo $TSESS
         else                                     # less than ten sessions
            echo "Multiple tmux sessions running:"
            echo "$TSESS"
            echo -n "Choose one to reattach to: [ENTER to cancel] "
            read REPLY
            if [ ! -z "$REPLY" ]; then
               ta $REPLY
            fi
         fi
      else
         echo -n "Reattaching to running tmux session in "
         KEY=0
         for i in 3 2 1 ; do
            echo -n "$i..."
            if read -k -r -s -t 0.5 a; then
               KEY=1
               break;
            fi
         done
         if [ $KEY -eq 0 ]; then
            tra
         else
            echo "aborted."
         fi
      fi
   fi
fi

