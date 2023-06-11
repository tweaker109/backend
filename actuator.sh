#!/bin/bash

GPIO_PIN1=91
GPIO_PIN2=92
HTML_FILE="/path/to/your/webpage.html"
GITHUB_PAGES_REPO="https://github.com/tweaker109/occupation_status.git"
GIT_USERNAME="your_username"
GIT_EMAIL="your_email@example.com"

# Read the current state of the GPIO pin
read_pin_state() {
  local pin=$1
  cat /sys/class/gpio/gpio${pin}/value
}

# Modify the HTML file with the updated number
update_webpage() {
  local new_number=$1
  sed -i "s/<div class=\"number\">[0-9]\+<\/div>/<div class=\"number\">${new_number}<\/div>/" "${HTML_FILE}"
}

# Initialize the GPIO pins
for pin in ${GPIO_PIN1} ${GPIO_PIN2}; do
  echo ${pin} > /sys/class/gpio/export
  echo "in" > /sys/class/gpio/gpio${pin}/direction
done

# Read the initial states of the pins
previous_state1=$(read_pin_state ${GPIO_PIN1})
previous_state2=$(read_pin_state ${GPIO_PIN2})

# Initial number
number=0

# Continuously monitor the pin states and update the webpage
while true; do
  current_state1=$(read_pin_state ${GPIO_PIN1})
  current_state2=$(read_pin_state ${GPIO_PIN2})

  # If both motion detectors are triggered
  if [[ "${current_state1}" == "1" && "${current_state2}" == "1" ]]; then
    # Increase the number by 1
    number=$((number + 1))
    
    # Update the webpage with the new number
    update_webpage ${number}
    
    # Commit and push the changes to the GitHub Pages repository
    cd "$(dirname "${HTML_FILE}")"
    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git add "${HTML_FILE}"
    git commit -m "Update webpage with new number"
    git push "${GITHUB_PAGES_REPO}"
  
  # If only motion detector on line 91 is triggered
  elif [[ "${current_state1}" == "1" && "${current_state2}" == "0" ]]; then
    # Decrease the number by 1
    number=$((number - 1))
    
    # Update the webpage with the new number
    update_webpage ${number}
    
    # Commit and push the changes to the GitHub Pages repository
    cd "$(dirname "${HTML_FILE}")"
    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git add "${HTML_FILE}"
    git commit -m "Update webpage with new number"
    git push "${GITHUB_PAGES_REPO}"
  
  # If only motion detector on line 92 is triggered
  elif [[ "${current_state1}" == "0" && "${current_state2}" == "1" ]]; then
    # Increase the number by 1
    number=$((number + 1))
    
    # Update the webpage with the new number
    update_webpage ${number}
    
    # Commit and push the changes to the GitHub Pages repository
    cd "$(dirname "${HTML_FILE}")"
    git config user.name "${GIT_USERNAME}"
    git config user.email "${GIT_EMAIL}"
    git add "${HTML_FILE}"
    git commit -m "Update webpage with new number"
    git push "${GITHUB_PAGES_REPO}"
  fi
  
  # Update the previous
previous_state1=${current_state1}
previous_state2=${current_state2}
sleep 0.1
done
