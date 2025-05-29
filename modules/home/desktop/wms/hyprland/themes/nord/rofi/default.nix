{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  xdg.configFile."rofi/config.rasi".text = ''
    /**
    * Nordic rofi theme
    * Adapted by undiabler <undiabler@gmail.com>
    *
    * Nord Color palette imported from https://www.nordtheme.com/
    *
    */


    * {
      nord0: #2e3440;
      nord1: #3b4252;
      nord2: #434c5e;
      nord3: #4c566a;

      nord4: #d8dee9;
      nord5: #e5e9f0;
      nord6: #eceff4;

      nord7: #8fbcbb;
      nord8: #88c0d0;
      nord9: #81a1c1;
      nord10: #5e81ac;
      nord11: #bf616a;

      nord12: #d08770;
      nord13: #ebcb8b;
      nord14: #a3be8c;
      nord15: #b48ead;

        foreground:  @nord9;
        backlight:   #ccffeedd;
        background-color:  transparent;
        
        highlight:     underline bold #eceff4;

        transparent: rgba(46,52,64,0);

        normal-background: var(background);
        normal-foreground: var(foreground);
        alternate-normal-background: var(background);
        alternate-normal-foreground: var(foreground);
        selected-normal-background: var(nord8);
        selected-normal-foreground: var(background);
    
        active-background: var(background);
        active-foreground: var(nord10);
        alternate-active-background: var(background);
        alternate-active-foreground: var(nord10);
        selected-active-background: var(nord10);
        selected-active-foreground: var(background);
    
        urgent-background: var(background);
        urgent-foreground: var(nord11);
        alternate-urgent-background: var(background);
        alternate-urgent-foreground: var(nord11);
        selected-urgent-background: var(nord11);
        selected-urgent-foreground: var(background);
    }

    window {
        width: 40%;
        location: center;
        anchor:   center;
        transparency: "screenshot";
        padding: 10px;
        border:  0px;
        border-radius: 6px;

        background-color: @transparent;
        spacing: 0;
        children:  [mainbox];
        orientation: horizontal;
    }

    mainbox {
        spacing: 0;
        children: [ inputbar, message, listview ];
    }

    message {
        color: @nord0;
        padding: 5;
        border-color: @foreground;
        border:  0px 2px 2px 2px;
        background-color: @nord7;
    }

    inputbar {
        color: @nord6;
        padding: 11px;
        background-color: #3b4252;

        border: 1px;
        border-radius:  6px 6px 0px 0px;
        border-color: @nord10;
    }

    entry, prompt, case-indicator {
        text-font: inherit;
        text-color:inherit;
    }

    prompt {
        margin: 0px 1em 0em 0em ;
    }

    listview {
        lines: 6;
        columns: 2;
        padding: 8px;
        border-radius: 0px 0px 6px 6px;
        border-color: @nord10;
        border: 0px 1px 1px 1px;
        background-color: rgba(46,52,64,0.9);
        dynamic: false;
    }

    element {
    padding: 2px 2px 2px 7px;
    spacing: 5px;
    border:  0;
    cursor:  pointer;
    }
    element normal.normal {
        background-color: var(normal-background);
        text-color: var(normal-foreground);
    }
    element normal.urgent {
        background-color: var(urgent-background);
        text-color: var(urgent-foreground);
    }
    element normal.active {
        background-color: var(active-background);
        text-color: var(active-foreground);
    }
    element selected.normal {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }
    element selected.urgent {
        background-color: var(selected-urgent-background);
        text-color: var(selected-urgent-foreground);
    }
    element selected.active {
        background-color: var(selected-active-background);
        text-color: var(selected-active-foreground);
    }
    element alternate.normal {
        background-color: var(alternate-normal-background);
        text-color: var(alternate-normal-foreground);
    }
    element alternate.urgent {
        background-color: var(alternate-urgent-background);
        text-color: var(alternate-urgent-foreground);
    }
    element alternate.active {
        background-color: var(alternate-active-background);
        text-color: var(alternate-active-foreground);
    }
    element-text {
        background-color: rgba(0, 0, 0, 0%);
        text-color: inherit;
        highlight: inherit;
        cursor: inherit;
    }

    button {
        spacing: 0;
        text-color: var(normal-foreground);
        cursor: pointer;
    }
    button selected {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }

    textbox {
        padding: 8px;
        border-radius: 6px 6px 6px 6px;
        border-color: @nord10;
        border: 1px 1px 1px 1px;
        background-color: rgba(46,52,64,0.9);
        dynamic: true;
        text-color: @backlight;
    }
    configuration {
        font: "Envy Code R 10";
        line-margin: 10;

        display-ssh:    "";
        display-run:    "";
        display-drun:   "";
        display-window: "";
        display-combi:  "";
        show-icons:     true;
        kb-custom-1: "Alt+a";
    }
    
  '';
}
