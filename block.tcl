#!/usr/bin/wish

package require Tk

wm title . "Blockchain demo"

grid [ttk::label .block-label -text Block:] -column 0 -row 0 -sticky news
grid [ttk::entry .block -textvariable block] -column 1 -row 0 -sticky news
grid [ttk::label .nonce-label -text Nonce:] -column 0 -row 1 -sticky news
grid [ttk::entry .nonce -textvariable nonce] -column 1 -row 1 -sticky news
grid [ttk::label .data-label -text Data:] -column 0 -row 2 -sticky news
grid [tk::text .data -width 100 -height 10] -column 1 -row 2 -sticky news
grid [ttk::label .hash-label -text Hash:] -column 0 -row 3 -sticky news
grid [ttk::entry .hash -textvariable hash] -column 1 -row 3 -sticky news
.hash state readonly
grid [ttk::label .difficulty-label -text Difficulty:] -column 0 -row 4 -sticky news
grid [ttk::spinbox .difficulty -textvariable difficulty -from 1 -to 4 -increment 1] -column 1 -row 4 -sticky news
.difficulty state readonly
grid [ttk::button .button -text Mine -command mine] -column 0 -row 5 -sticky news

grid columnconfigure . 1 -weight 1
grid rowconfigure . 2 -weight 1

set nonce 1
set block 1
set difficulty 2

proc mine {} {
    global nonce
    global difficulty
    set zeros [string repeat "0" $difficulty]
    set data [string trim [.data get 1.0 end]]
    set hash [calc_hash "$data$nonce"];
    while {![string match "$zeros*" $hash ]} {
        incr nonce
        set hash [calc_hash "$data$nonce"]; # 
    }
    .hash state !readonly
    .hash delete 0 end
    .hash insert 0 $hash
    .hash state readonly
}

proc calc_hash {s} {
    set output [exec echo -n $s | sha256sum]
    return [string trim [lindex [split $output -] 0]]; # 
}

foreach w [winfo children .] {grid configure $w -padx 5 -pady 5}

