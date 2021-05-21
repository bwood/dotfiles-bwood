ssh-ec2 () {
aws --region us-east-2 ec2 describe-instances --query 'Reservations[*].Instances[*].{id:InstanceId,state:State.Name,key:KeyName,IP:PublicIpAddress}'
}

wlogs-env() {

  if [ -z "$WPS_AWS_REGION" ]; then
   echo "What region?"
   read region
  else
   region="$WPS_AWS_REGION"
  fi

  if [ -z "$WPS_AWS_ENV" ]; then
   echo "What environment?"
   read env
  else
   env="$WPS_AWS_ENV"
  fi

}

wlogs-get() {

  wlogs-env
  # start: default 1d
  start=${1:-1d}

  dir="/tmp/awslogs"
  if [ ! -d "$dir" ];then
    mkdir $dir
  fi

  awslogs get --aws-region="$region" /${env}/wpsconsole --start="$start" --timestamp > ${dir}/${region}_${env}.txt
}

wlogsq () {
  wlogs-env
  search="$1"
  fields="$2"
  grep -E "${search}" $dir/${region}_${env}.txt | cut -d ' ' $fields |sort
}

# Dispaly all begin and end entries in a logfile.
wlogs-be () {
  wlogs-env
  wlogsq $region $env "Begin update:apply" "-f3-"
  wlogsq $region $env "End update:apply" "-f3-"
}

# Display all errors in a logfile.
wlogs-err () {
  wlogs-env
  wlogsq $region $env "\[error\]" "-f3-"
}

# Display log events for one or more runs for site.
# Write logfiles for each run.
wlogs-site () {
  wlogs-env
  site="$1"
  dir="/tmp/awslogs"

  streams=$(cat ${dir}/${region}_${env}.txt | cut -d ' ' -f2,4 |grep '\ \[' | grep -vE '\[\d{4}-\d{2}-\d{2}'|grep $site |cut -d ' ' -f1 |uniq)

  for stream in ${streams[@]}; do
      echo ""
      site_start=$(grep $stream ${dir}/${region}_${env}.txt | cut -d ' ' -f3 | head -1)
      logname=${site}_${site_start}_${region}_${env}
      grep $stream ${dir}/${region}_${env}.txt | cut -d ' ' -f3- > ${dir}/${logname}.txt
      cat ${dir}/${logname}.txt
  done
}
