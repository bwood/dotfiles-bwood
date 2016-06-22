updates-done () {
  cd $HOME/logs
  # Fragile: What if step_16 is removed, or there is a step 17. Improve the logging.
  echo 'Sites that have finished:'
  echo '-------------------------'
  grep '===> step_16' *.log  -l |sed 's/_updates.*//'
  echo ""
}

updates-overrides () {
  if [ -z "$1" ]; then
    ENV='LIVE'
  else
    ENV=$(echo $1 | awk '{print toupper($0)}')
  fi

  echo "Sites with overrides in $ENV:"
  echo '-----------------------------'
  grep 'END: $ENV: Features and customizations' -B10 ~/logs/*.log |grep 'Overridden features detected.' |sed 's/_updates.*//'
  echo ""
}

updates-report () {
  updates-done
  updates-overrides live
  # updates-overrides test 
  # updates-overrides dev
}