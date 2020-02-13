show-function () {
  if [ "x$1" == "x" ]; then
      echo "To show a bash function:" 
      echo "  show-function functino-name"
      return 1
  fi

  set | awk "/^$1/,/^}/"
}
alias sf=show-function
alias bash-function=show-function

is-numeric () {
    re='^[0-9]+$'
    if [[ $1 =~ $re ]] ; then
        echo 1
    else
	echo 0
    fi
}

ldaps () {
  if [ "x$LDAP_GUEST_OU_BIND_PW" == "x" ]; then
      echo "Please run:" 
      echo "  source ~/.env"
      return 1
  fi

  NUMBER1=$(is-numeric $1)

  if [ "$#" -eq 1 ]; then
      if [ $NUMBER1 -eq 1 ]; then
        echo "searching for UID:"
	ldapsearch -Z -x -h ldap.berkeley.edu -p 389 -D uid=webplatform,ou=applications,dc=berkeley,dc=edu -w $LDAP_GUEST_OU_BIND_PW -LLL "(uid=$1)"
      else
        echo "searching for email:"
	ldapsearch -Z -x -h ldap.berkeley.edu -p 389 -D uid=webplatform,ou=applications,dc=berkeley,dc=edu -w $LDAP_GUEST_OU_BIND_PW -LLL "(mail=$1)"

      fi
  elif [ "$#" -eq 2 ]; then
      NUMBER2=$(is-numeric $2)
      if [[ $NUMBER1 -eq 0 && $NUMBER2 -eq 0 ]]; then
      echo "searching for first and lastname:"
	ldapsearch -Z -x -h ldap.berkeley.edu -p 389 -D uid=webplatform,ou=applications,dc=berkeley,dc=edu -w $LDAP_GUEST_OU_BIND_PW -LLL "(&(givenname=$1)(sn=$2))"
      fi
  fi
}



alias fix-cas-cert='drush vset cas_cert /usr/local/share/certs/cacert.pem'

fix-lockr() {
  if [ "x$LDAP_GUEST_OU_BIND_PW" == "x" ]; then
      echo "Please run:" 
      echo "  source ~/.env"
      return 1
  fi

  if [ "x$1" == "x" ]; then
    echo "USAGE:"
    echo "fix-lockr [site.env]"
    return 1
  fi

  terminus remote:drush $1 -- key-save ldap_guests_ou $LDAP_GUEST_OU_BIND_PW --label='LDAP password for Guest OU bind' --key-provider=lockr --key-type=authentication --overwrite -y
}

find-symlinks () {
  ls -lR $1 | grep ^l
}

dig-ucb-ns () {
  IFS=',' read -r -a NAMES <<< "$1"
  # These are the "recursive" name s
  NAMESERVERS=( 128.32.206.9 128.32.206.12 128.32.136.9 128.32.136.12 )  

  for NAME in "${NAMES[@]}"; do
    for NS in "${NAMESERVERS[@]}"; do
        echo ""
        echo "Querying nameserver $NS:"
        dig @$NS $NAME +short
    done
  done
  echo ""
}

show-cert() {
    HOST=$1
    if [ x$HOST = x ]; then
	echo "Pass the hostname without the ';https://'"
	exit 1
    fi
  curl -vvI https://$HOST 2>&1 |grep -A6 "Server certificate"
}
alias curl-cert=show-cert

show-redirects() {
    URL=$1
    if [ x$URL = x]; then
	echo "Pass the url including protocol for which you want to check redirects."
	exit 1
    fi
    curl -sLD - $URL -o /dev/null -w '%{url_effective}'
    echo ""
}
alias curl-redirects=show-redirects

new-site() {

  SITE=$1
  if [ x$SITE = x ]; then
    echo "new-site Must pass a site shortname as the first argument, for example: site-name"
    exit 1
  fi

  PROD_ORG=$2
  if [ x$PROD_ORG = x ]; then
    TEST_ORG='-T'
  else
    TEST_ORG=""
  fi

  php ~/bin/istdrupal-new-site.php --site=$SITE --site-friendly=$SITE --site-mail=bwood+01@berkeley.edu --user1-mail=bwood+02@berkeley.edu -y $TEST_ORG

}

# useful on the machine that runs updates
upgrades-done () {
  cd $HOME/logs
  grep -l "SCRIPT END TIME:" *.log | sed -e 's/_.*/.pantheon.berkeley.edu/g' -e 's/^/http://test-/g'
}

date-to-unixtime () {
    USAGE="${FUNCNAME[0]} 'MM/DD/YYYY HH:mm:ss'"
    if [ "x$1" == "x" ]; then
	echo $USAGE
	return 1
    fi


    re='[0-9]{2}\/[0-9]{2}\/[0-9]{4}\ [0-9]{2}:[0-9]{2}:[0-9]{2}'
    if [[ ! "$1" =~ $re ]] ; then
        echo "ERROR: Wrong date format: $1"
	echo $USAGE
	return 1
    fi
    
    gdate "+%s" -d "$1"
}

unixtime-to-date () {
    gdate "+%m/%d/%Y %X" -d "@$1"
}

###########
## Drush ##
###########

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
  drush -y $MYALIAS cas-user-create 300861
  drush -y $MYALIAS cas-user-create 300862
  drush -y $MYALIAS cas-user-create 300863
  drush -y $MYALIAS urol contributor --name=300861
  drush -y $MYALIAS urol editor --name=300862
  drush -y $MYALIAS urol builder --name=300863
}
alias dur=drush-users-roles

# Adding users/roles without cas
drush-users-roles-nocas() {
  MYALIAS=$1
  drush $MYALIAS ucrt builder --mail=bwood+10@berkeley.edu --password=t
  drush $MYALIAS ucrt editor --mail=bwood+20@berkeley.edu --password=t
  drush $MYALIAS ucrt contributor --mail=bwood+30@berkeley.edu --password=t
  drush $MYALIAS urol contributor --mail=bwood+30@berkeley.edu
  drush $MYALIAS urol editor --mail=bwood+20@berkeley.edu
  drush $MYALIAS urol builder --mail=bwood+10@berkeley.edu
}
alias dur-nocas=drush-users-roles-nocas

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

php-switch () {
    VER=''
    NEWPATH=''
    
    if [ x$1 = x ]; then
	echo "Switch to a new php version."
	echo ""
	echo "USAGE:"
	echo ""
	echo "${FUNCNAME[0]} 71"
	echo "   or"
        echo "${FUNCNAME[0]} 7.1"
	return 0
    fi

    IN=$1
    # Best practise is to put the regular expression to match against into a variable. This is to avoid shell parsing errors on otherwise valid regular expressions.
    RE='^[0-9]+\.[0-9]+$'
    if [[ "$IN" =~ $RE ]]; then
	VER=$IN
    else
	if [ ${#IN} -lt 3 ]; then
	    VER="$(echo $IN | cut -c1-1).$(echo $IN | cut -c2-2)"
	else
	    echo "Please separate your numbers with a dot."
	    return 1
	fi
    fi
    
    NEWPATH=$(echo $PATH |sed -E "s/php@[0-9]+\.[0-9]+/php@$VER/g")
    PATHS=$(ECHO $NEWPATH | tr ':' "\n")
    RE2='php@[0-9]+\.[0-9]+\/bin$'
    for ITEM in $PATHS; do
	if [[ $ITEM =~ $RE2 ]]; then
	    PHP="$ITEM/php"
	    if [ -x $PHP ]; then
		export PATH=$NEWPATH
		echo "New PHP version is:"
		echo ""
		$PHP --version
		echo ""
		echo "This php version is only set in the current terminal session."	       
		break
	    else
		echo "$PHP is not an executable file. Aborting."
		return 1
	    fi
	fi
    done

    # update the php version in the item title bar so you can verify your PHP version with a quick glance.  Often I switch versions in a session and then I forget.
    echo -e "\033];" $(php -v | awk 'NR == 1 {print $1 " " $2}') "\007"
}
alias phps=php-switch


###################
# WPS Development #
###################
wpsv-scripts-dir () {
  if [ -n "$WPS_VCR_BASE_PATH" ]; then
    cd ${WPS_VCR_BASE_PATH}/scripts
  elif [ -d "${PWD}/scripts" ]; then
    cd scripts
  else
    echo "Please set or cd to WPS_VCR_BASE_PATH before proceeding."
    return 1
  fi
}

wpsv-base() {
  wpsv-scripts-dir
  ../bin/robo wps:vcr "'$*'"
  cd ..
}

wpsv() {
  wpsv-base $*
  # sourcing this file makes the variable changes stick in your environment.  
 source $HOME/.wps/vcr_env.sh
}

wpsv-dev-base() {
  wpsv-scripts-dir
  ../bin/robo wps:vcr --dev "'$*'"
  cd ..
}

wpsvd() {
  wpsv-dev-base $*
  source $HOME/.wps/vcr_env.sh
}

wpsv-list() {
  wpsv-scripts-dir
  ../bin/robo wps:vcr --env
  cd ..
}
alias wpsvl=wpsv-list

wpsv-unset() {
  unset WPS_VCR_MODE
  unset TERMINUS_VCR_MODE
  wpsv-list
}
alias wpsvu=wpsv-unset


wpsv-none() {
  export WPS_VCR_MODE=none
  export TERMINUS_VCR_MODE=none
  wpsv-list
}
alias wpsvn=wpsv-none

wpsv-episodes() {
  export WPS_VCR_MODE=new_episodes
  export TERMINUS_VCR_MODE=new_episodes
  wpsv-list
}
alias wpsve=wpsv-episodes

wpsv-path() {
  unset WPS_VCR_BASE_PATH
  # Since you're moving the fixture path, you probably want new episodes
  export WPS_VCR_MODE=new_episodes
  wpsv-list
}
alias wpsvp=wpsv-path

# wps Docker aliases #
#
# OPTIONS:
# -d                    Use the wps-dev docker image.
# -s                    Open a shell on the docker container.
# -t                    Run a terminus command.
# -h                    Display this help text.
# -D                    Display debug messages.

WPS_BASE_DIR=/Users/bwood/code/php/WpsConsole-docker
alias wps="$WPS_BASE_DIR/bin/wps-docker.sh"
alias wpsd="$WPS_BASE_DIR/bin/wps-docker.sh -d"
alias wpss="$WPS_BASE_DIR/bin/wps-docker.sh -s"
alias wpsds="$WPS_BASE_DIR/bin/wps-docker.sh -d -s"
alias wpst="$WPS_BASE_DIR/bin/wps-docker.sh -t"
alias wpsdt="$WPS_BASE_DIR/bin/wps-docker.sh -d -t"
