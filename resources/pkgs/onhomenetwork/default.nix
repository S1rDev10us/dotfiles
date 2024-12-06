{
  writeShellScriptBin,
  networkmanager,
}:
writeShellScriptBin "onhomenetwork.bash" ''
  set -e
  SSID=$(${networkmanager}/bin/nmcli -t -f device,name connection show --active | grep '^wlo1' | cut -d: -f2)
  SSID_SHA=$(echo $SSID | sha256sum)

  echo SSID: $SSID

  if [ ! -f ~/.home_ssid_sha ]; then
    echo "WARNING, HOME SSID NOT SET"
    exit 1
  fi

  HOME_SSID_SHA=$(cat ~/.home_ssid_sha)

  ON_HOME_NETWORK=$( [ "\"$SSID_SHA\"" = "\"$HOME_SSID_SHA\"" ]; echo $?)

  exit $ON_HOME_NETWORK
''
