{ config, pkgs, ... }:

{
  security.polkit.enable = true;

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
