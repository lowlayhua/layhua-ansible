### BASK COMMAND LOGGING ###

# SETUP - This runs when bash starts (including su/sudo)
WHOAMI=`who am i`
LOG_NAME=`echo $WHOAMI | awk '{ print $1 }'`
SOURCE=`echo $WHOAMI | awk '{ print $NF }' | sed 's/(//g' | sed 's/)//g'`
SESSION=`ps t | grep -v PID | head -n 1 | awk '{print $1}'`
FACILITY='authpriv.notice'

# Log the login only on first login (if SESSION matches the process id of the current bash process)
# not when the user sudos or su's
if [ "$SESSION" == "$$" ]; then
  logger -p $FACILITY -t "bashlog" User $LOG_NAME login from $SOURCE session: $SESSION
fi

#Run this each time a command is run
function history_to_syslog
{
  [ -n "$COMP_LINE" ] && return                      # do nothing if completing
  [ "$BASH_COMMAND" == "$PROMPT_COMMAND" ] && return # do nothing if generating a new prompt

  declare cmd
  declare cmd_id
  declare p_dir

  cmd=$(history 1)
  cmd=$(echo $cmd | awk '{print substr($0, index($0, $2))}')
  p_dir=$(pwd)

  if [ -n "$cmd" ]; then
    logger -p $FACILITY -t bashlog -- REMOTE = $SOURCE,  SESSION = $SESSION, USER = $LOG_NAME,  PWD = $p_dir, CMD = "${cmd}"
  fi
}

trap history_to_syslog DEBUG || EXIT

