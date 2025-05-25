{ config, pkgs, ... }: {
  systemd.user.services.polkit-pantheon-authentication-agent-1 = {
    Unit = {
      Description = "Pantheon Polkit Authentication Agent";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
