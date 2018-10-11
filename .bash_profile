# Homebrew: make sure /usr/local/bin is before /usr/bin so that things like brew-installed git take precedence over Apple-installed programs
export PATH="/usr/local/opt/php@5.6/sbin:/usr/local/opt/php@5.6/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/opt/coreutils/libexec/gnubin:$HOME/.composer/vendor/bin:/usr/local/sbin:/usr/local/opt/python/libexec/bin:/Users/bwood/Library/Python/3.7/bin:$PATH"
# PATH: /Users/bwood/Library/Python/3.7/bin is for awscli

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# istdrupal_ops development
export ISTDRUPAL_VCR_CASSETTE_PATH=/Users/bwood/code/drupal/istdrupal_ops/pantheon/tests/fixtures

# wps console development
export WPS_VCR_CASSETTE_PATH="/Users/bwood/code/php/WpsConsole/tests/fixtures"
export WPS_BIN_DIR=builds

# istdrupal_ops development
export ISTDRUPAL_OPS_BIN_DIR=builds

# Ruby rbenv installed with brew
# enabling this overrides openssl and gives me an insecure version!
#export RBENV_ROOT=/usr/local/var/rbenv
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Finished adapting your PATH environment variable for use with MacPorts.
export EDITOR="/usr/local/bin/emacs-orig -q -nw"
export VISUAL="emacs-orig"
export TERM="xterm-color"

# istdrupal app
export TERMINUS_ISTDRUPAL=$HOME/bin/terminus-0133

# Install new bash prompt
# Git prompt
#export GIT_PS1_SHOWSTASHSTATE=1
#export GIT_PS1_SHOWUNTRACKEDFILES=1
#export GIT_PS1_SHOWCOLORHINTS=1
#source ~/.git-prompt.sh
# Custom bash prompt via kirsle.net/wizards/ps1.html
#export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\[$(tput setaf 3)\]\u\[$(tput setaf 7)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 7)\]\W\[$(tput setaf 4)\]\\$ \[$(tput sgr0)\]"
#PROMPT_COMMAND='__git_ps1 "\u@mbp \W" "\\\$ "'

# Display the current php version in the iTerm title bar
echo -e "\033];" $(php -v | awk 'NR == 1 {print $1 " " $2}') "\007"

#aliases
alias ll="ls -laFG"

# PHP Aliases 
# disable xdebug per https://getcomposer.org/doc/articles/troubleshooting.md#xdebug-impact-on-composer
# Load xdebug Zend extension with php command
# alias php5='php -dzend_extension="/usr/local/opt/php56-xdebug/xdebug.so"'
# alias php7='php -dzend_extension="/usr/local/opt/php71-xdebug/xdebug.so"'
# PHPUnit needs xdebug for coverage. In this case, just make an alias with php command prefix.
alias phpunit='php $(which phpunit)'
# alias brew-php-switcher="brew-php-switcher -s"
# alias phpswitch="brew-php-switcher -s"

##############
## Terminus ##
##############
. ~/.bash_terminus.sh

##############################
## IST Web Platform Scripts ##
##############################
. ~/.bash_webplatform.sh

# Allow php debugging from CLI
export XDEBUG_CONFIG="idekey=PHPSTORM"  

#########
## GIT ##
#########
# bash-git-prompt
# https://github.com/magicmonty/bash-git-prompt
if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
  source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi
# Set config variables first
# GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_SHOW_UPSTREAM=1
#GIT_PROMPT_THEME=Evermeet
GIT_PROMPT_THEME=Custom
GIT_PROMPT_THEME_FILE=$HOME/.git-prompt-colors.sh

#completion
#source ~/.git-completion.sh

# https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh

#git aliases
alias g='git status'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gca='git commit -v -a'
alias gd='git diff --color'
alias gco='git checkout' #switch to different branch
alias gcob='git checkout -b' #create a new branch
alias gl='git pull'
alias gp='git push'
alias gb='git branch' #show branches
alias gbva='git branch -va' #show branches - verbose/all (incl remote)
alias gbd='git branch -d' #delete branch for cleanup
alias gbD='git branch -D' #abandon branch
# "git branch recent" show branches ordered by most recent commits.
alias gbr='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r'
alias git-branch-recent=gbr
alias glg='git log'
alias glgp='git log --pretty=format:"%h - %an, %ar : %s"'
alias gi='git init'
alias gm='git merge'
alias gr='git remote -v'
alias grso='git remote show origin' #show remote-local tracking
alias gfup='git fetch upstream'
alias gst='git stash'
alias gsta='git stash apply'
alias gstl='git stash list'
alias gstd='git stash drop'
alias gstp='git stash pop' #apply stash and drop from stack (gsa + gsd)

#commit pending changes and quote all args as message
gg() {
  git commit -v -a -m "$*"
}

#git push to a specific origin branch; -u flag to set upstream
gpob() {
  if [ -z "$1" ]
  then
    echo "Needs one parameter: branch name"
  else
    git push -u origin $1
  fi
}



alias codercs='phpcs --standard=/Users/bwood/.drush/coder/coder_sniffer/Drupal/ruleset.xml --extensions=php,module,inc,install,test,profile,theme'


# If you commonly get a gateway timeout when running 'terminus sites aliases',
# set this to "1" to avoid this problem. 
# export ISTDRUPAL_ALIAS_TIMEOUT=1 
 
# Docker
# Connect to an image
docker-connect () {
  docker run -it $1 bash -il
}
# "docker connect image" dci
alias dci=docker-connect

# Headless chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# by default sudo to bwood_admin
alias sudo='sudo -u bwood_admin'

# brew: bash-completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# this should come last
# https://github.com/bamarni/symfony-console-autocomplete#prerequisites
# enable symfony console app command completion
# eval "$(symfony-autocomplete)"
source ~/.terminus-autocomplete

