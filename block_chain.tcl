#!/usr/bin/wish

package require Tk
package require sha256

wm title . "Blockchain demo"

ttk::style configure My.TLabelframe_block1.TLabelframe -background lightblue
ttk::style configure My.TLabelframe_block1.TLabelframe.Label -background lightblue
ttk::style configure My.TLabelframe_block2.TLabelframe -background lightblue
ttk::style configure My.TLabelframe_block2.TLabelframe.Label -background lightblue
ttk::style configure My.TLabelframe_block3.TLabelframe -background lightblue
ttk::style configure My.TLabelframe_block3.TLabelframe.Label -background lightblue


grid [ttk::labelframe .block1 -text "Block 1" -style My.TLabelframe_block1.TLabelframe] -sticky news
grid [ttk::labelframe .block2 -text "Block 2" -style My.TLabelframe_block2.TLabelframe] -sticky news
grid [ttk::labelframe .block3 -text "Block 3" -style My.TLabelframe_block3.TLabelframe] -sticky news
grid rowconfigure . 0 -weight 1
grid rowconfigure . 1 -weight 1
grid rowconfigure . 2 -weight 1
grid columnconfigure . 0 -weight 1
grid columnconfigure . 1 -weight 1
grid columnconfigure . 2 -weight 1

foreach {block number} {
    block1 1
    block2 2
    block3 3
} {
    grid [ttk::label .$block.block-label -text Block:] -column 0 -row 0 -sticky news
    grid [ttk::entry .$block.block -textvariable block$block] -column 1 -row 0 -sticky news
    grid [ttk::label .$block.nonce-label -text Nonce:] -column 0 -row 1 -sticky news
    grid [ttk::entry .$block.nonce -textvariable nonce$block] -column 1 -row 1 -sticky news
    .$block.nonce state readonly
    grid [ttk::label .$block.data-label -text Data:] -column 0 -row 2 -sticky news
    grid [tk::text .$block.data -width 100 -height 10] -column 1 -row 2 -sticky news
    grid [ttk::label .$block.hash-label -text Hash:] -column 0 -row 3 -sticky news
    grid [ttk::entry .$block.hash -textvariable hash$block] -column 1 -row 3 -sticky news
    .$block.hash state readonly
    grid [ttk::label .$block.difficulty-label -text Difficulty:] -column 0 -row 4 -sticky news
    grid [ttk::spinbox .$block.difficulty -textvariable difficulty$block -from 1 -to 4 -increment 1] -column 1 -row 4 -sticky news
    .$block.difficulty state readonly
    grid [ttk::label .$block.time -text sec] -column 1 -row 5 -sticky news
    grid [ttk::button .$block.button -text Mine] -column 0 -row 5 -sticky news
    

    grid columnconfigure .$block 1 -weight 1
    grid rowconfigure .$block 2 -weight 1

    set block$block $number
    set nonce$block 1
    set difficulty$block 1

    .$block.button configure -command "mine $block"

    bind .$block.data <<Modified>> "data_changed $block"
}

proc data_changed {block} {
    set data [string trim [.$block.data get 1.0 end]]
    set hash [hash_data $data]
    replace_entry .$block.hash $hash
    .$block.data edit modified 0
    change_color $block red
}

proc change_color {block color} {
    ttk::style configure My.TLabelframe_$block.TLabelframe -background $color
    ttk::style configure My.TLabelframe_$block.TLabelframe.Label -background $color
}


proc mine {block} {
    set data [string trim [.$block.data get 1.0 end]]
    set t0 [clock clicks -millisec]
    set nonce [.$block.nonce get]
    
    while 1 {
        set hash [hash_data $data$nonce]
        puts "nonce = $nonce, hash = $hash"
        if [solution_found $hash $block] {
            break
        }
        incr nonce        
    }
    
    set timespent "[expr {([clock clicks -millisec]-$t0)/1000.}] sec"
    .$block.time configure -text $timespent; # 
    puts "timespent = $timespent"
    replace_entry .$block.hash $hash
    replace_entry .$block.nonce $nonce
    change_color $block lightgreen
}

proc replace_entry {entry text} {
    $entry state !readonly
    $entry delete 0 end
    $entry insert 0 $text
    $entry state readonly
}

proc solution_found {hash block} {
    set difficulty [.$block.difficulty get]
    puts "difficulty = $difficulty"
    puts "block = $block"
    set zeros [string repeat "0" $difficulty]; 
    return [string match "$zeros*" $hash]
}

proc hash_data {data} {
    set output [sha2::sha256 $data]
    return [string trim [lindex [split $output -] 0]];
}


foreach w [winfo children .] {grid configure $w -padx 5 -pady 5}
