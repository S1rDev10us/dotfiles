{lib, ...}: {
  # default = true;
  options = with lib.types; {
    workspaces = lib.mkOption {
      default = [];
      type = attrsOf (listOf singleLineStr);
    };
  };

  config.workspaces = {
    web = ["firefox"];
    communications = ["firefox-comms" "discord" "thunderbird" "signal" "Element"];
    notes = ["obsidian" "Logseq" "superProductivity"];
    # Not including KeePassXC because I want to not include the popups,
    # which requires a special per-wm rule
    PWM = [];
  };
}
