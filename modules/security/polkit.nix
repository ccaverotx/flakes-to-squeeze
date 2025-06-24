{ config, pkgs, ... }:

{
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  systemd.user.services.polkit-agent = {
    description = "Polkit GNOME Agent (usado en Sway)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  environment.etc."polkit-1/rules.d/99-nopasswd-vscode.rules".text = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("wheel") &&
        action.id == "org.freedesktop.policykit.exec"
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
