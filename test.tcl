package require Tk

# Create the main window
set main [toplevel .main]
wm title $main "Form with Grid"

# Create a 2x2 grid
grid [label $main.dataLabel -text "Data"] -row 0 -column 0 -sticky w
grid [text $main.dataText -width 20 -height 5] -row 0 -column 1 -sticky we

grid [label $main.hashLabel -text "Hash"] -row 1 -column 0 -sticky w
grid [entry $main.hashEntry -width 20] -row 1 -column 1 -sticky we

# Configure the grid to expand properly
grid columnconfigure $main 1 -weight 1
grid rowconfigure $main 0 -weight 1
grid rowconfigure $main 1 -weight 1

# Start the Tk event loop
tkwait window $main
