#!/bin/bash

# GPIO line numbers for motion detectors
line1=91
line2=92

# Webpage file path
webpage_file="index.html"

# Previous state variables
previous_state1=0
previous_state2=0

# Git configuration
GITHUB_PAGES_REPO="https://github.com/tweaker109/occupation_status.git"
GIT_USERNAME="tweaker109"
GIT_EMAIL="tweaker109@github.com"

# Main loop to monitor motion detectors
while true; do
  # Read the current state of motion detector 1
  current_state1=$(gpio read ${line1})

  # Read the current state of motion detector 2
  current_state2=$(gpio read ${line2})

  # Check if the states of the motion detectors have changed
  if [[ ${current_state1} -ne ${previous_state1} || ${current_state2} -ne ${previous_state2} ]]; then
    # Increase or decrease the numeric value based on the order of motion detector triggers
    if [[ ${current_state1} -eq 1 && ${current_state2} -eq 0 ]]; then
      sed -i 's/<div class="number">[0-9]\+/<div class="number">INCREMENTED_VALUE/' ${webpage_file}
    elif [[ ${current_state1} -eq 0 && ${current_state2} -eq 1 ]]; then
      sed -i 's/<div class="number">[0-9]\+/<div class="number">DECREMENTED_VALUE/' ${webpage_file}
    fi

    # Commit and push changes to the GitHub Pages repository
    git -C /github.com/tweaker109/occuption_status/ add ${webpage_file}
    git -C /github.com/tweaker109/occuption_status/ commit -m "Update webpage"
    git -C /github.com/tweaker109/occuption_status/ push origin master

    # Update the previous state variables
    previous_state1=${current_state1}
    previous_state2=${current_state2}
  fi

  # Sleep for a short duration before checking again
  sleep 0.1
done
