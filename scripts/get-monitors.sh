#!/bin/sh

# Obtener información de los monitores con hyprctl
hyprctl monitors -j | jq -r '.[] | 
  "monitor=" + .name + "," + 
  (.width|tostring) + "x" + (.height|tostring) + "," +
  (.x|tostring) + "x" + (.y|tostring) + ",1" + 
  ",transform," + (.transform|tostring) + 
  "\nworkspace = " + (.id|tostring) + ", monitor:" + .name'
