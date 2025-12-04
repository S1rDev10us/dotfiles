{
  writeShellScriptBin,
  ncurses,
}:
writeShellScriptBin "isolate_command" ''
  ${ncurses}/bin/tput smcup
  ${ncurses}/bin/clear


  function trap_exit() {
      ${ncurses}/bin/tput rmcup

      echo "Exited due to user input" | tee -a isolated.log

      set -e
      exit 1
  }
  trap 'trap_exit' INT

  eval "set -e; ''$1" 2>&1 | tee isolated.log
  exit_code=''${PIPESTATUS[0]}


  ${ncurses}/bin/tput rmcup
  trap - INT

  exit $exit_code
''
