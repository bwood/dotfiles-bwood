# https://github.com/bwood/lando_notify_wrapper
#export LW_LANDO_REAL_PATH=/usr/local/bin/lando


# Installing sites
lando-drupal-site-install() {
lando drupal site:install standard \
--langcode="en" \
--db-host="database" \
--db-type=mysql \
--db-name=drupal8 \
--db-user=drupal8 \
--db-pass=drupal8 \
--db-port=3306 \
--account-name=admin 
}
alias ldsi=lando-drupal-site-install

# Deprecated. Use 'wps lando:init'
lando-openberkeley-site-install () {

    if [[ "$1" == "-h" || "$1" == "--help" ]];then
	echo "USAGE:

$FUNCNAME [site name] [email for user1] [admin CAS UIDs comma-separated]

Optionally omit arguments to be prompted.

Optionally add argument values to your ~/.env per code comments.
"
    return 0
    fi

    if [ "x$USER1_ACCT_NAME" == "x" ];then
	echo "Please install the latest .env code which defines USER1_ACCT_NAME, 
or add this environment variable some other way."
	return 1
    fi
    
    if [ "x$1" == "x" ];then
	echo "Enter the name for your site:"
	read SITE_NAME
    else
	SITE_NAME=$1
    fi

    if [ "x$2" == "x" ];then
	# Add EMAIL_DEV to your ~/.env
	if [ "x$EMAIL_DEV" == "x" ];then
	    echo "Enter the administrator email to use with this site:"
	    read SITE_EMAIL
	else
	    SITE_EMAIL=$EMAIL_DEV
	fi
    else
	SITE_EMAIL=$2
    fi

    if [ "x$3" == "x" ];then
	# ADD comma-separated CAS UIDs to SITE_ADMINS
	if [ "x$SITE_ADMINS" == "x" ];then
	    echo "Enter comma-separated CAS UIDs for admins:"
	    read SITE_ADMINS
    	fi
    else
	SITE_ADMINS=$3
    fi

    # Hopefully you've installed Lando...

  lando drush -y site-install  openberkeley \
  --site-mail=$SITE_EMAIL --site-name="$SITE_NAME" \
  --account-mail=$SITE_EMAIL --account-name=$USER1_ACCT_NAME \
  update_status_module='array\(FALSE,FALSE\)' \
  openberkeley_add_admin_form.cas_name=$SITE_ADMINS

}
 
alias lobsi=lando-openberkeley-site-install

alias lando-url='lando info -p $[0].urls[2]'
alias lurl=lando-url
alias lando-urls='lando info -p $[0].urls'
alias lurls=lando-urls
