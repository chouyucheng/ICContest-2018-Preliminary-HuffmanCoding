# 2018 IC Design Contest Preliminary - Huffman Coding

## Directory Tree - Main Folder & Files
![file_pic](img/file_pic.png) run_nc.sh -- Run function simulation<br>
![file_pic](img/file_pic.png) run_nc_post.sh -- Run timing simulation<br>
![dir_pic](img/dir_pic.png) dc -- Design Compiler Relate<br>
> ![file_pic](img/file_pic.png) .synopsys_dc.setup -- Set Design Compiler's parameter<br>
![file_pic](img/file_pic.png) DC_syn.tcl -- Script for Design Compiler<br>
![file_pic](img/file_pic.png) huffman.sdc -- Constraint file<br>
![file_pic](img/file_pic.png) huffman_syn.v -- Netlist from Design Compiler<br>

![dir_pic](img/dir_pic.png) doc -- Related documents<br>
> ![file_pic](img/file_pic.png) B_ICC2018_priliminary_grad_cell_based.pdf -- Problem Description<br>

![dir_pic](img/dir_pic.png) sim --Ncverilog Relate<br>
> ![file_pic](img/file_pic.png) pre_sim.f -- Script for function simulation<br>
![file_pic](img/file_pic.png) post_sim.f -- Script for timing simulation<br>
![file_pic](img/file_pic.png) pattern1.dat -- Test data 1<br>
![file_pic](img/file_pic.png) pattern2.dat --Test data 2<br>
![file_pic](img/file_pic.png) pattern3.dat --Test data 3<br>
![file_pic](img/file_pic.png) golden1.dat -- Answer data 1<br>
![file_pic](img/file_pic.png) golden2.dat -- Answer data 2<br>
![file_pic](img/file_pic.png) golden3.dat -- Answer data 3<br>

![dir_pic](img/dir_pic.png) src -- Source code<br>
> ![file_pic](img/file_pic.png) huffman.v -- Main module<br>
![file_pic](img/file_pic.png) tb.v -- Testfixture<br>

## Finite State Machine
FSM in huffman.v<br>
![FSM](https://g.gravizo.com/svg?@startuml;skinparam%20state%20{;%20%20StartColor%20MediumBlue;%20%20EndColor%20Red;};[*]-left-%3E%20LOAD_NT%20:%20gray_valid%20=%201;note%20top%20of%20LOAD_NT%20:%20Count%20the%20amount%20of\neach%20different%20data.;LOAD_NT%20-left-%3E%20LOAD_LIST%20:%20gray_valid%20=%200;LOAD_LIST%20-left-%3E%20SORTING%20:%20cnt%20=%205;note%20top%20of%20LOAD_LIST%20:%205%20datas%20need%206%20cycles%20to%20write\ninto%20Regfile.;SORTING%20--%3E%20BUILD_TREE%20:%20Sort%20done;note%20top%20of%20SORTING%20:%20Selection%20sort;BUILD_TREE%20-right-%3E%20READ_TREE%20:%20Tree%20is%20built;BUILD_TREE%20--%3E%20SORTING%20:%20Tree%20isn%27t%20built;note%20bottom%20of%20BUILD_TREE%20:%20Building%20tree%20for%20READ_TREE%20state\nto%20generate%20huffman%20code.;READ_TREE%20-right-%3E%20DONE%20:%20done;note%20bottom%20of%20READ_TREE%20:%20Generate%20huffman%20code.;DONE%20-right-%3E%20[*];@enduml;)

<!--
https://g.gravizo.com/#converter
@startuml
skinparam state {
  StartColor MediumBlue
  EndColor Red
}

[*] --\> LOAD_NT : gray_valid = 1
note right of LOAD_NT : Count the amount of\neach different data.

LOAD_NT --\> LOAD_LIST : gray_valid = 0
LOAD_LIST --\> SORTING : cnt = 5
note right of LOAD_LIST : 5 datas need 6 cycles to write\ninto Regfile.

SORTING --\> BUILD_TREE : Sort done
note right of SORTING : Selection sort

BUILD_TREE --\>  READ_TREE : Tree is built
BUILD_TREE --\> SORTING : Tree isn't built
note right of BUILD_TREE : Building tree for READ_TREE state\nto generate huffman code.

READ_TREE --\> [*] : done
note right of READ_TREE : Generate huffman code.

@enduml

version 2
@startuml
skinparam state {
  StartColor MediumBlue
  EndColor Red
}
[*]-left-\> LOAD_NT : gray_valid = 1
note top of LOAD_NT : Count the amount of\neach different data.

LOAD_NT -left-\> LOAD_LIST : gray_valid = 0
LOAD_LIST -left-\> SORTING : cnt = 5
note top of LOAD_LIST : 5 datas need 6 cycles to write\ninto Regfile.

SORTING --\> BUILD_TREE : Sort done
note top of SORTING : Selection sort

BUILD_TREE -right-\> READ_TREE : Tree is built
BUILD_TREE --\> SORTING : Tree isn't built
note bottom of BUILD_TREE : Building tree for READ_TREE state\nto generate huffman code.

READ_TREE -right-\> DONE : done
note bottom of READ_TREE : Generate huffman code.

DONE -right-\> [*]

@enduml
        
-->        

## AUTHORS
[Yu-Cheng Chou](https://github.com/chouyucheng/)
