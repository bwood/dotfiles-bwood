##############
## Terminus ##
##############

# Show time for terminus commands
# alias terminus='time terminus'

# Globals
# if you need to customize consider a symlink to this location
ISTDRUPAL_NEW_SITE=$HOME/bin/istdrupal-new-site.php
CLONE_PATH=$HOME/Sites/pantheon

_terminus-hostname() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "terminus-hostname Must pass a site shortname as the first argument, for example: site-name"
    exit 1
  fi

  ENV=$2
  if [ x$ENV = x ]; then
    echo "terminus-hostname: Must pass an environment as the second argument."
    exit 1
  fi

  TYPE=$3
  if [ x$TYPE = x ]; then
    echo "terminus-hostname: Must pass server type as the third argument."
    exit 1
  fi

  ID=$(terminus site:info --field=id $SITE)
  HOSTNAME=""
  if [ -n "$ID" ]; then 
    HOSTNAME="$ENV.$ID@$TYPE.$ENV.$ID.drush.in"
  else 
    echo ""
    echo "Site '$SITE' not found."
  fi
}

_terminus-validate-site () {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site from which you want to validate."
    echo ""
    return
  fi

  terminus site:info $SITE &>/dev/null
  local STATUS=$?
  echo $STATUS
}

terminus-site-connection-info () {
  SITE=$1
  FIELD=$2
  ENV=$3
  if [ -z "$ENV" ]; then
    ENV="dev"
  fi 

 
  if [ "x$SITE" == "x" ] || [ "x$FIELD" == "x" ]; then
    echo "USAGE:

terminus-site-connection-info site-shortname command field

Open a mysql connection to a site.

  site-shortname: REQUIRED: If your site is dev-example.pantheon.io
                  this would be \"example\" .

  field:          E.g. \"git_command\", \"mysql_command\"

  environment     Defaults to \"dev\"
"
    return
  fi

  terminus connection:info $SITE.$ENV --field=$FIELD
}
alias tsci=terminus-site-connection-info

terminus-sql-cli() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "USAGE:

terminus-sql-cli site-shortname environment

Open a mysql connection to a site.

  site-shortname: REQUIRED: If your site is dev-example.pantheon.io
                  this would be \"example\" .

  environment:    Defaults to \"dev\".
"
    return
  fi

  ENV=$2
  if [ -z "$ENV" ]; then
    ENV="dev"
  fi 

  if [ "$ENV" != "live" ]; then
    terminus env:wake $SITE.$ENV
  fi

  if [[ $(mysql --version) =~ 'MariaDB' ]];then
    OPTIONS='--ssl'
  else
    OPTIONS='--ssl-mode=VERIFY_IDENTITY'
  fi 

  $(terminus-site-connection-info $SITE mysql_command $ENV) -A $OPTIONS
}
alias tsqlc=terminus-sql-cli
alias tsql=terminus-sql-cli

terminus-site-wake() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass a site shortname as the first argument, for example: site-name"
    return
  fi
  ENV=$2
  if [ x$ENV = x ]; then
    terminus env:wake $SITE.dev
    terminus env:wake $SITE.test
  else  
    terminus env:wake $SITE.$ENV
  fi

}

alias tsite-wake=terminus-site-wake
alias tsw=terminus-site-wake

terminus-mysql-dump() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "USAGE:

terminus-mysql-dump <site-shortname> <table> <environment>

Dump a mysql table on for a site.

  site-shortname: REQUIRED: If your site is dev-example.pantheon.io
                  this would be \"example\" .

  table:          Name of the table. Leave blank for whole db.

  environment:    Defaults to \"dev\".


"
    return
  fi

  TABLE=$2

  ENV=$3
  if [ -z "$ENV" ]; then
    ENV="dev"
  fi 

  if [ "$ENV" != "live" ]; then
    terminus-site-wake $SITE $ENV
  fi

  CMD=$(terminus-site-connection-info $SITE mysql_command $ENV)
  CMD="${CMD/mysql /mysqldump }"
  $CMD  --ssl $TABLE
}
alias tmd=terminus-mysql-dump

terminus-sftp() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "USAGE:

terminus-sftp site-shortname

Make an sftp connection to a site.

  site-shortname: REQUIRED: If your site is dev-example.pantheon.io
                  this would be \"example\" .

  environment:    Defaults to \"dev\".
"
    return
  fi

  ENV=$2
  if [ -z "$ENV" ]; then
    ENV="dev"
  fi 

  # TODO use terminus-site-connection-info()
  _terminus-hostname "$SITE" $ENV "appserver"

  if [ -n "$HOSTNAME" ]; then
    CMD="sftp -o Port=2222 $HOSTNAME"
    echo $CMD
    $CMD
  fi
}

alias tsftp=terminus-sftp

terminus-logs() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "USAGE:

terminus-logs site-shortname

Gets the logs for the site 

  site-shortname: REQUIRED: If your site is dev-example.pantheon.io
                  this would be "example" 

  env:            dev, test, live
"
    return
  fi

  if [ x$2 = x ]; then
    ENV='dev'
  else 
    ENV=$2
  fi

  DIR="/tmp"


  SFTP_CMDS="cd logs
  lcd $DIR/$SITE.$ENV
  mget *.log"

#  mget php*
#  get nginx-access.log"

  _terminus-hostname "$SITE" "$ENV" "appserver"

  if [ -n "$HOSTNAME" ]; then
    # if the log directory exists delete it
    if [ ! -d "$DIR/$SITE.$ENV" ]; then
      mkdir "$DIR/$SITE.$ENV"
    fi

    echo ""
    echo "Connecting to $SITE..."
    CMD="sftp -o Port=2222 $HOSTNAME"
    echo "$SFTP_CMDS" | $CMD

    echo ""
    echo "Logs downloaded to $DIR/$SITE.$ENV"
    echo ""
    cd "$DIR/$SITE.$ENV"
    ls -l
  fi
}

alias tlogs=terminus-logs

terminus-git-clone() {
  USAGE="
terminus-git-clone $SITE_NAME $DEPTH $FRESH $LOCATION

Required:

$SITE_NAME       Pantheon shortname for the site

Optional:

$DEPTH           Value for --depth= for git clone.
                 Default: 1

$FRESH           If \"1\" delete and reclone the repo. Otherwise
                 'git pull' to get the latest.

$LOCATION        Full path to where you want to clone this.
                 Default: ~/Sites/pantheon
"

  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass a site shortname as the first argument, for example: site-name"
    return
  fi

  DEPTH=$2
  if [ -z $DEPTH ]; then
    # default
    DEPTH=1
  fi

  FRESH=$3

  LOCATION=$4
  if [ -z $LOCATION ]; then

    if [ -z $CLONE_PATH ]; then
    echo "Please add 
  export CLONE_PATH=/path/to/site/clones
to your ~/.bash_profile."
    return
    fi

    LOCATION=$CLONE_PATH
  fi

  if [ ! -d "$LOCATION" ]; then
    echo "Error: Not a directory: $LOCATION"
    return    
  fi


  cd $LOCATION
  
if [ "$FRESH" == "1" ]; then
    if [ -d "$SITE" ]; then
      echo "Removing and re-cloning $SITE..."
      rm -rf $SITE
    fi
  elif [ -d "$SITE" ]; then
    echo "You already cloned $SITE. Doing a git pull..." 
    cd $SITE
    git pull
    return
  fi

  echo ""
  echo "Git cloning $SITE with --depth=$DEPTH" 
  X="$(terminus-site-connection-info $SITE git_command dev) --depth=$DEPTH"
  echo $X
  $X
  cd $LOCATION/$SITE
}

alias tgc=terminus-git-clone


terminus-dashboard() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass a site shortname as the first argument, for example: site-name"
    return
  fi
  terminus dashboard:view --yes $SITE.dev
}

alias tdash=terminus-dashboard

alias tal="terminus auth:login --email $EMAIL_WORK"
#source /Users/bwood/bin/terminus-completion.bash

terminus-cache-clear () {
  $TERMINUS cli cache-clear
  $TERMINUS auth login $EMAIL_WORK
  $TERMINUS sites list |head -3 # warm the terminus cache
}

alias tcc=terminus-cache-clear


terminus-deploy-code() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site."
    return
  fi

  ENV=$2
  if [ x$ENV = x ]; then
    echo "Must pass the target environment. (If \"live\" code will also be deployed to \"test.\")"
    return
  fi
  
  if [ "$ENV" == "test" ]; then
    ENVS=( test )
  elif  [ "$ENV" == "live" ]; then
    ENVS=( test live )
  else
    echo "The second argument must be \"test\" or \"live\""
    return
  fi

  for TO_ENV in "${ENVS[@]}"; do
    echo ""
    echo "$SITE: Deploying code to $TO_ENV."
    $TERMINUS site deploy --site=$SITE --env=$TO_ENV --note="Deployed via bash $FUNCNAME()."
  done
  
}

alias tdcode=terminus-deploy-code

terminus-deploy-content() {
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site."
    return
  fi

  ENV=$2
  if [ x$ENV = x ]; then
    echo "Must pass the target environment. (If \"live\" code will also be deployed to \"test.\")"
    return
  fi
  
  if [ "$ENV" == "test" ]; then
    ENVS=( test )
  elif  [ "$ENV" == "live" ]; then
    ENVS=( test live )
  else
    echo "The second argument must be \"test\" or \"live\""
    return
  fi
  for TO_ENV in "${ENVS[@]}"; do
    echo ""
    echo "$SITE: Deploying content to $TO_ENV."
    $TERMINUS site clone-content --from-env=dev --to-env=$TO_ENV --site=$SITE --yes
  done

}

alias tdcontent=terminus-deploy-content

terminus-backup-site-envs() {
  USAGE="
terminus-backup-site-envs SITE ENV ELEMENT

Required:

SITE:      Site name

ENV:       if 'dev' backs up dev
           if 'test' backups dev and test
           if 'live' backs up dev, test and live

Optional:

ELEMENT:   [code|files|db|all]
           Default: all

"
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site."
    echo $USAGE
    return
  fi

  ENV=$2
  if [ x$ENV = x ]; then
    echo "Must pass the target environment. (If \"live\" code will also be deployed to \"test.\")"
    echo $USAGE
    return
  fi

  ELEMENT=$3
  if [ -z $ELEMENT ]; then
    ELEMENT=all
  fi
  
  if [ "$ENV" == "dev" ]; then
    ENVS=( dev )
  elif [ "$ENV" == "test" ]; then
    ENVS=( dev test )
  elif  [ "$ENV" == "live" ]; then
    ENVS=( dev test live )
  else
    echo "The third argument must be \"dev,\" \"test\" or \"live\""
    echo $USAGE
    return
  fi

  for ITEM in "${ENVS[@]}"; do
    echo ""
    echo "$SITE: Backing up $ITEM element=$ELEMENT."
    $TERMINUS site backups create --site=$SITE --env=$ITEM --element=$ELEMENT
  done

}

clone-content-between-sites() {
  SOURCE=$1
  if [ x$SOURCE = x ]; then
    echo "Must pass the site shortname of the SOURCE site FROM which to which you want to clone."
    return
  fi

  # Validate the site
  VALID=$(_terminus-validate-site $SOURCE)
  if [ "$VALID" != "0" ]; then
    echo "$SOURCE not found.  If name is correct try '$TERMINUS sites list'."
    return
  fi

 TARGET=$2
  if [ x$TARGET = x ]; then
    echo "Must pass the site shortname of the TARGET site TO which you want to clone."
    return
  fi

  # Validate the site
  VALID=$(_terminus-validate-site $TARGET)
  if [ "$VALID" != "0" ]; then
    echo "$TARGET not found.  If name is correct try '$TERMINUS sites list'."
    return
  fi

 ELEMENTS=$3
  if [ x$ELEMENTS = x ]; then
    echo "Must pass the (comma-separated) elements that you want to clone. (E.g. \"files,database\")"
    return
  fi

  # replace the ',' with a space and evaluate the string with in '()' to create an array.  Yea bash. :-/
  ELEMENTS=(${ELEMENTS//,/ })

  ENV=$4
  if [ x$ENV = x ]; then
    echo "Must pass the enviornment from which to copy conten from the source site"
    return
  fi

  DB_TASKS=0

  for ELEMENT in "${ELEMENTS[@]}"; do
    if [ "$ELEMENT" == "database" ]; then
      DB_TASKS=1
    fi 
    echo "Cloning $ELEMENT $SOURCE --> $TARGET"
    $TERMINUS site import-content --site=$TARGET --url=$($TERMINUS site backups get --site=$SOURCE --env=$ENV --element=$ELEMENT --latest) --element=$ELEMENT
  done

  if [ "$DB_TASKS" -eq "1" ]; then 

    # clear caches
    echo ""
    echo "Clearing caches on $TARGET."
    echo ""
    $TERMINUS site clear-cache --site=$TARGET --env=dev

    # update pathologic
    echo ""
    echo "Updating pathologic paths on $TARGET."
    echo ""
    NEW="http://dev-$TARGET.pantheon.berkeley.edu/
http://test-$TARGET.pantheon.berkeley.edu/
http://live-$TARGET.pantheon.berkeley.edu/
http://dev-$TARGET.pantheonsite.io/
http://test-$TARGET.pantheonsite.io/
http://live-$TARGET.pantheonsite.io/
http://$TARGET.berkeley.edu
http://$TARGET.localhost"

    EXISTING=$($TERMINUS drush "vget openberkeley_wysiwyg_override_pathologic_paths" --site=$SOURCE --env=$ENV 2>/dev/null)
    # Strip out varilable name
    EXISTING=${EXISTING/openberkeley_wysiwyg_override_pathologic_paths: /}
    # //\" = replace all instances of "
    EXISTING=${EXISTING//\"/}
    UPDATED_PATHS="$EXISTING
$NEW
"
    $TERMINUS drush "vset openberkeley_wysiwyg_override_pathologic_paths '$UPDATED_PATHS'" --site=$TARGET --env=dev

  fi

  # disable SMTP (until we have a better solution)
    echo ""
    echo "Disabling SMTP so mail isn't inadvertently sent from this site."
    echo ""
    $TERMINUS drush --site=$TARGET --env=dev "vset smtp_host 'NOEMAIL-FROM-CLONED-SITE.berkeley.edu'"

  # since SMTP isn't enabled on some sites also remove the user emails
    echo ""
    echo "Remove user emails."
    echo ""
    $TERMINUS drush --site=$TARGET --env=dev "sqlq \"update users set mail='' where uid <> 0\""

}

reset-repo-to-tag() {

  USAGE="
reset-repo-to-tag $SITE $TAG

$SITE      Pantheon short name for the site

$TAG       A valid tag in the repository.
           e.g: 7.x-0.7.2
"

  if [ -z $CLONE_PATH ]; then
    echo "Please add 
  export CLONE_PATH=/path/to/site/clones
to your ~/.env file."
    return
  fi

  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site."
    echo ""
    echo "$USAGE"
    return
  fi

  TAG=$2
  if [ x$TAG = x ]; then
    echo "Must indicate tag to which you want to reset."
    echo ""
    echo "$USAGE"
    return
  fi

  SITE_PATH="$CLONE_PATH/$SITE"
  if [ ! -d "$SITE_PATH" ]; then
    echo "Error: $SITE_PATH is not a directory."
    return
  fi

  # cd into the repo
  cd $SITE_PATH

  echo "'git rev-list -n 1 $TAG'"
  git rev-list -n 1 "$TAG"
  if [ $? -ne 0 ]; then
    echo ""
    echo "Error: $TAG not found in site repo ($SITE_PATH)."
    return
  fi

  SHA=$(git rev-list -n 1 "$TAG")
  echo ""
  echo "Resetting the repository to $TAG and forcing a git push..."
  echo "($TAG = $SHA)"
  git reset --hard $SHA
  git push -f
  echo ""
}

terminus-clone-site() {
  # Other users need to customize ISTDRUPAL_NEW_SITE at top of file

  USAGE="USAGE:
terminus-clone-site SOURCE_SITE TARGET_SITE ENV TAG [UCB]

Required Arguments: 

SORUCE_SITE:  Pantheon short name for source site

TARGET_SITE:  Pantheon short name for target site

ENV:          Environment to which to deploy the target site.

Optional Arguments:

TAG:          Git tag for reset --hard and git push -f
              Nothing will be done if omitted.

UCB:                  UCB will put the target site in the live organization.
                        If not present, will put target site in the test org.

"


  if [ -z $CLONE_PATH ]; then
    echo "Please add 
  export CLONE_PATH=/path/to/site/clones
to your ~/.env file."
    return
  fi

  if [ -z $ISTDRUPAL_MACHINE ]; then
    echo "Please add 
  export ISTDRUPAL_MACHINE=example@example.com
to your ~/.env file."
    return
  fi

  FROM_SITE=$1
  if [ x$FROM_SITE = x ]; then
    echo "Must pass the site shortname of the site from which you want to clone."
    echo ""
    echo "$USAGE"
    return
  fi

  # Validate the site
  VALID=$(_terminus-validate-site $FROM_SITE)
  if [ "$VALID" != "0" ]; then
    echo "$FROM_SITE  not found.  If name is correct try '$TERMINUS sites list'."
    return
  fi

  TO_SITE=$2
  if [ x$TO_SITE = x ]; then
    echo "Must pass the site shortname of the site to which you want to clone."
    echo ""
    echo "$USAGE"
    return
  fi

  ENV=$3
  if [ x$ENV = x ]; then
    echo "Must indicate the environment to which you want to deploy on the target site."
    echo ""
    echo "$USAGE"
    return
  fi

  if [ -z $ISTDRUPAL_ORG ] || [ -z $ISTDRUPAL_UPSTREAM ]; then
    echo "Error: both ISTDRUPAL_ORG and ISTDRUPAL_UPSTREAM must be defined in your environment."
    return
  fi

  # Create a basic target site
  CMD="$TERMINUS --yes sites create --site=$TO_SITE --name=$TO_SITE --label=$TO_SITE --upstream=$ISTDRUPAL_UPSTREAM --org=$ISTDRUPAL_TEST_ORG"
  echo ""
  echo "Creating site $TO_SITE"
  echo $CMD
  $CMD

  # Was the site created or did something fail
  VALID=$(_terminus-validate-site $TO_SITE)
  if [ "$VALID" != "0" ]; then
    echo "$TO_SITE  not found.  Running '$TERMINUS sites list'..."
    $TERMINUS sites list
    VALID2=$(_terminus-validate-site $TO_SITE)
    if [ "$VALID2" != "0" ]; then
      echo "$TO_SITE STILL not found.  Aborting."
      return
    fi
  fi

  # This argument puts the site in the real organization. Else it's put in the test organization.
  LIVE_ORG=$5
  if [[ -n $LIVE_ORG  && "$LIVE_ORG" == "UCB" ]]; then
    echo ""
    echo "Moving site to main organization."
    # add main org
    CMD="$TERMINUS site organizations add --site=$TO_SITE --org=$ISTDRUPAL_ORG --role=admin"
    echo $CMD
    $CMD    
    # set instrument
    CMD="$TERMINUS site set-instrument --instrument=$ISTDRUPAL_INSTRUMENT --site=$TO_SITE"
    echo $CMD
    $CMD
    # remove test org
    CMD="$TERMINUS site organizations remove --site=$TO_SITE --org=$ISTDRUPAL_TEST_ORG"
    echo $CMD
    $CMD
  fi

  # Add team member
  echo ""
  echo "Adding team members $ISTDRUPAL_MACHINE, $EMAIL_WORK"
  $TERMINUS site team add-member --member=$ISTDRUPAL_MACHINE --role=admin --site=$TO_SITE
  $TERMINUS site team add-member --member=$EMAIL_WORK --role=admin --site=$TO_SITE

  # clone the sites down
  echo "Creating git clones..."
  terminus-git-clone $FROM_SITE 100

  # We always want to get this fresh, so rm -rf if it exists
  terminus-git-clone $TO_SITE 100 1

  # Reset and git push -f, if desired
  TAG=$4
  if [ -n $TAG ]; then
    reset-repo-to-tag $TO_SITE $TAG
  fi

  # copy over custom data in sites/all/modules
  CUSTOMIZATIONS=$(ls -1 $CLONE_PATH/$FROM_SITE/sites/all/modules | wc -l)
  if [ $CUSTOMIZATIONS -gt 1 ]; then
    echo "Found customizations in $CLONE_PATH/$FROM_SITE/sites/all/modules. Copying..."
    cp -r  $CLONE_PATH/$FROM_SITE/sites/all/modules/*  $CLONE_PATH/$TO_SITE/sites/all/modules
    echo "Adding customizations and pushing to git remote..."
    cd $CLONE_PATH/$TO_SITE
    # git pull #erroring.  just cloned the site, so should be ok
    git add -A > /dev/null
    git commit -m "Adding customizations from $CLONE_PATH/$FROM_SITE/sites/all/modules" > /dev/null
    git push
  fi

  # Deploy code to environments
  terminus-deploy-code $TO_SITE $ENV

  # Clone the db and files from the source to the target site
  clone-content-between-sites $FROM_SITE $TO_SITE "database,files" $ENV
  terminus-deploy-content $TO_SITE $ENV

  echo "Site created:"
  echo "http://dev-$TO_SITE.pantheon.berkeley.edu"
  echo "http://test-$TO_SITE.pantheon.berkeley.edu"
  echo "http://live-$TO_SITE.pantheon.berkeley.edu"
  echo ""
  echo "Site dashboard url:"
  echo $($TERMINUS site dashboard --site=$TO_SITE --env=dev --print)

  # take backups
  echo "Creating initial backups of site environments"
  terminus-backup-site-envs $TO_SITE $ENV

  # Tag the site on the dashbaord.
  if [[ "$TO_SITE" =~ "upgrade-testing" ]];then
    echo ""
    echo "Since this is an upgrade-testing site, we will add the 'Upgrade Testing' tag."
    $TERMINUS site tags add --tag='Upgrade Testing' --site=$TO_SITE --org=$($TERMINUS site info --site=$TO_SITE --field=holder_id)
  fi

  echo "Done."

}

alias tcsite=terminus-clone-site


# Resetting a cloned site to an older commit and then using 'git push -f' is 
# problematic when you try to deploy between environments.  It's cleaner to 
# blow away the clone and start fresh.
############
# WARNING!!! Be very careful when editing this. Potential for disaster.  Runs 'site delete --force'
############
terminus-reset-cloned-site () {
  USAGE="USAGE:

terminus-reset-cloned-site upgrade-testing-example-site live -y

Required:

  site_name     Pantheon shortname of site to delete and re-clone.
                (Will refuse to delete sites without \"upgrade-testing\" 
                in their name.)

  environment   The environment to which to deploy the clone. 
                Values other than [dev|test|live] will fail.

Optional:

  tag           Git tag to which to reset the repository and git push -f.

  -y            Skip confirmation before site deletion. 
                Not using getopts. This needs to be the 3rd argument.

"
  SITE=$1
  if [ x$SITE = x ]; then
    echo "Must pass the site shortname of the site from which you want to clone."
    echo ""
    echo "$USAGE"
    return
  fi

  ENV=$2
  if [ x$ENV = x ]; then
    echo "Must indicate the environment to which you want to deploy on the target site."
    echo ""
    echo "$USAGE"
    return
  fi

  TAG=$3

  CONFIRM=$4

  if [[ ! "$SITE" =~ "upgrade-testing" ]];then
    echo "I only work on 'upgrade-testing' sites. Aborting."
    return
  fi

  # Validate the site
  VALID=$(_terminus-validate-site $SITE)
  if [ "$VALID" != "0" ]; then
    echo "$SITE not found.  If name is correct try '$TERMINUS sites list'."
    return
  fi

  if [ -z $CONFIRM ]; then
    echo "Are you sure you want to DELETE and recreate $SITE? (y/n)"
    read CONFIRM
    # Prepend a dash to make it look like an option
    CONFIRM="-$CONFIRM"
  fi

  if [ "$CONFIRM" != "-y" ]; then 
    echo "Aborting."
    return
  fi

  # WARNING!!!
  echo "Deleting $SITE..."
  $TERMINUS site delete --force --site=$SITE

  # Remove the git working copy
  # if this dir is the user's pwd the rm will work and the user will be in a ghost directory 
  # after the subshell for the script exits.
  echo "Preparing to remove $CLONE_PATH/$SITE."
  if [[ -n "$CLONE_PATH"  &&  -d "$CLONE_PATH/$SITE"  &&  -d "$CLONE_PATH/$SITE/.git" ]]; then
    # make sure that the subshell's pwd is not this dir
    cd $HOME
    rm -rf "$CLONE_PATH/$SITE"
  else 
    echo "Error: Not safe to remove this directory."
    return
  fi 
  
  # replace the 'upgrade-testing-' substring with null
  FROM_SITE="${SITE/upgrade-testing-/}"
  echo "Re-cloning $FROM_SITE --> $SITE..."
  terminus-clone-site $FROM_SITE $SITE $ENV $TAG

}


# We get gateway timeouts using '$TERMINUS sites aliases' with individual accounts.
# This workaround gets the aliases for the machine user account which is a team member
# on fewer sites.
terminus-managed-site-aliases () {
if [ -z "ISTDRUPAL_MACHINE" ]; then
  echo "Please set the correct value:"
  echo "  export ISTDRUPAL_MACHINE="
  return
fi

if [ -z "$EMAIL_WORK" ]; then
  echo "Please set the correct value:"
  echo "  export EMAIL_WORK="
  return
fi

LOCATION=$HOME/.drush/ms.aliases.drushrc.php
terminus auth:login --email $ISTDRUPAL_MACHINE 
terminus aliases --location=$LOCATION
terminus auth:login --email $EMAIL_WORK
echo "Managed site aliases refreshed: $LOCATION"
}

alias tms-aliases=terminus-managed-site-aliases
alias tmsa=terminus-managed-site-aliases
