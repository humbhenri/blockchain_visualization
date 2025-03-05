#!/usr/bin/wish

package require Tk

wm title . "Blockchain demo"

grid [ttk::label .data-label -text Data:] -column 0 -row 0 -sticky news
grid [tk::text .data -width 100 -height 10] -column 1 -row 0 -sticky news
grid [ttk::label .hash-label -text Hash:] -column 0 -row 1 -sticky news
grid [ttk::entry .hash -textvariable hash] -column 1 -row 1 -sticky news

grid columnconfigure . 1 -weight 1
grid rowconfigure . 0 -weight 1

bind .data <KeyRelease> calculateHash

proc calculateHash {} {
    set data [string trim [.data get 1.0 end]]
    set output [exec echo -n $data | sha256sum]
    set hash [string trim [lindex [split $output -] 0]]
    .hash delete 0 end
    .hash insert 0 $hash
}

calculateHash

foreach w [winfo children .] {grid configure $w -padx 5 -pady 5}

