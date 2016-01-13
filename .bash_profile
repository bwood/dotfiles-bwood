# Homebrew: make sure /usr/local/bin is before /usr/bin
export PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:~/bin:~/bin/drush:~/bin/utility:/usr/local/bin/git:~/workspace/scripts:/Applications/acquia-drupal/mysql/bin:/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH:/Users/bwood/pear/bin

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export EMAIL_WORK=bwood@berkeley.edu

# istdrupal console
export ISTDRUPAL_TERMINUS=~/bin/terminus-093
export ISTDRUPAL_TERMINUS_DEV_PATH="/Users/bwood/code/php/cli"
export ISTDRUPAL_TERMINUS_DEV="1"
export VCR_CASSETTE_PATH="/Users/bwood/code/php/istdrupal/tests/fixtures"


# Ruby rbenv installed with brew
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Finished adapting your PATH environment variable for use with MacPorts.
export EDITOR=/usr/bin/emacs
export VISUAL="emacs -q"
export TERM="xterm-color"

# istdrupal app
export TERMINUS_ISTDRUPAL=~/bin/terminus-081


# Git prompt
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1
source ~/.git-prompt.sh

# Custom bash prompt via kirsle.net/wizards/ps1.html
#export PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\[$(tput setaf 3)\]\u\[$(tput setaf 7)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 7)\]\W\[$(tput setaf 4)\]\\$ \[$(tput sgr0)\]"
PROMPT_COMMAND='__git_ps1 "\u@mbp \W" "\\\$ "'


#aliases
alias ll="ls -laFG"
alias php3=/Applications/acquia-drupal/php5_3/bin/php
# alias php4=/usr/bin/php

##############
## Terminus ##
##############

terminus-dashboard() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass a site shortname as the first argument, for example: openberkeley-ob"
    return
  fi
  terminus site dashboard --yes --site=$SITE 
}

alias tdash=terminus-dashboard

terminus-site-wake() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass a site shortname as the first argument, for example: openberkeley-ob"
    return
  fi
  terminus site wake --site=$SITE --env=dev
  terminus site wake --site=$SITE --env=test
}

alias tsite-wake=terminus-site-wake
alias tsw=terminus-site-wake

###########
## Drush ##
###########
. ~/bin/drush/drush.complete.sh
# https://drupal.org/node/877916#comment-4286400
drush() { 
  if [[ $@ == "help" ]]; then 
    command drush help < /dev/null | less
  else 
    command drush --strict=0 "$@"
  fi 
}

#Installing sites
drush-site-install() {
  MYALIAS=$1
  if [ x$MYALIAS = x ]; then
    echo "Must pass a drush alias as the first argument, for example: @mytest.dev"
    return
  fi

  if [[ $MYALIAS =~ @pantheon ]];then 
     echo "*** Pantheon ***"
     echo $MYALIAS
     echo "Are you sure about this?"
  fi 
   
  # default profile is openberkeley, or pass your own
  if [ x$2 = x ]; then
    PROFILE="openberkeley"
  else
    PROFILE=$2
  fi
  
  SITEEMAIL=bwood+01@berkeley.edu
  drush $MYALIAS --notify site-install $PROFILE \
  --site-mail=$SITEEMAIL --site-name="Test Site" \
  --account-mail=$SITEEMAIL --account-name=ucbadmin \
  install_configure_form.update_status_module='array(FALSE,FALSE)' \
  openberkeley_add_admin_form.cas_name=213108,304629,248324,267087
}
# To get pathologic paths working try adding
#install_configure_form.openberkeley_wysiwyg_override_pathologic_paths='this
#that' \


alias dsi=drush-site-install

# Adding users/roles
drush-users-roles() {
  MYALIAS=$1
  if [ x$MYALIAS = x ]; then
    echo "Must pass a drush alias as the first argument, for example: @mytest.dev"
    return
  fi
  drush $MYALIAS ucrt builder --mail=bwood+1@berkeley.edu --password=t
  drush $MYALIAS ucrt editor --mail=bwood+2@berkeley.edu --password=t
  drush $MYALIAS ucrt contributor --mail=bwood+3@berkeley.edu --password=t
  drush $MYALIAS urol contributor --mail=bwood+3@berkeley.edu
  drush $MYALIAS urol editor --mail=bwood+2@berkeley.edu
  drush $MYALIAS urol builder --mail=bwood+1@berkeley.edu
}

alias dur=drush-users-roles

# Toggle pantheon aliases to use drush7 on the remote
drush-script-switch () {

  if [ ! -e ~/.drush/pantheon.aliases.drushrc.php ]; then
    echo "~/.drush/pantheon.aliases.drushrc.php doesn't exist."
    return
  fi

  if [ ! -s ~/.drush/pantheon.aliases.drushrc.php ]; then
    echo "~/drush/pantheon.aliases.drushrc.php is empty."
    return
  fi

  if [ "$1" = "show" ]; then
    grep -m1 '%drush-script' ~/.drush/pantheon.aliases.drushrc.php
    return
  elif [ -n "$1" ] && [ "$1" -eq "7" ]; then 
    TO="drush7"
  else 
    TO="drush"
  fi 
  sed -i -e "s/'%drush-script'.*$/'%drush-script' => '$TO',/g" ~/.drush/pantheon.aliases.drushrc.php 
  grep -m1 '%drush-script' ~/.drush/pantheon.aliases.drushrc.php
}

alias dss=drush-script-switch

drush-self-alias () {
  ALIAS_FILE=~/.drush/aliases.drushrc.php
  SELF_ALIAS=$1
  if [ x$SELF_ALIAS = x ]; then
    echo "First argument should be the name of the alias."
    echo "cd into the \$DRUPAL_ROOT of the site, then run"
    echo "  dsa mysite"
    echo "This will append an alias to $ALIAS_FILE."
    return
  fi

  if [ $(grep -c "\$aliases\[['\"]$SELF_ALIAS['\"]\]" ~/.drush/aliases.drushrc.php) -gt 0 ]; then
    echo "You already have an alias called $SELF_ALIAS"  
    return
  fi

  # it'd be nice not to repeat the command
  #SELF_ALIAS_CMD=drush sa @self --alias-name=$SELF_ALIAS --full --with-db 2>&1
  #SELF_ALIAS_OUT=$($SELF_ALIAS_CMD)

  SELF_ALIAS_OUT=$(drush sa @self --alias-name=$SELF_ALIAS --full --with-db 2>&1)

  if [[ "$SELF_ALIAS_OUT" =~ "Not found: @self" ]]; then
    echo "You need to cd into the \$DRUPAL_ROOT of the site for which you are creating an alias."
    return
  fi
  
  # if you 'echo $SELF_ALIAS_OUT >> ...' you lcdose the nice formatting
  drush sa @self --alias-name=$SELF_ALIAS --full --with-db >> $ALIAS_FILE
  echo "Added alias: "
  tail -21 $ALIAS_FILE
  drush cc drush
}

alias dsa=drush-self-alias

# terminus convenience
alias tal="terminus auth login $EMAIL_WORK"
#source /Users/bwood/bin/terminus-completion.bash

# Allow php debugging from CLI
export XDEBUG_CONFIG="idekey=PHPSTORM"  

#########
## GIT ##
#########
#completion
source ~/.git-completion.sh

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


export PATH="$PATH:/Applications/DevDesktop/drush"
