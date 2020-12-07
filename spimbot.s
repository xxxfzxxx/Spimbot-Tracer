.data
# syscall constants
PRINT_STRING             = 4
PRINT_CHAR               = 11
PRINT_INT                = 1

# memory-mapped I/O
VELOCITY                 = 0xffff0010
ANGLE                    = 0xffff0014
ANGLE_CONTROL            = 0xffff0018

BOT_X                    = 0xffff0020
BOT_Y                    = 0xffff0024

TIMER                    = 0xffff001c

REQUEST_PUZZLE           = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION          = 0xffff00d4  ## Puzzle

BONK_INT_MASK            = 0x1000
BONK_ACK                 = 0xffff0060

TIMER_INT_MASK           = 0x8000      
TIMER_ACK                = 0xffff006c 

REQUEST_PUZZLE_INT_MASK  = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK       = 0xffff00d8  ## Puzzle

PICKUP                   = 0xffff00f4

SPAWN_MINIBOT            = 0xffff00dc
SELECT_MINIBOT_IN_REGION = 0xffff00e0
SELECT_MINIBOT_BY_ID     = 0xffff2004
SELECT_IDLE_MINIBOTS     = 0xffff00e4
SET_TARGET_TILE          = 0xffff00e8
BUILD_SILO               = 0xffff2000

GET_MAP                  = 0xffff00f0
GET_PUZZLE_CNT           = 0xffff2008
GET_KERNEL_LOCATIONS     = 0xffff200c
GET_NUM_KERNELS          = 0xffff2010

GET_MINIBOT_INFO         = 0xffff2014

### Bot global control
moving:                 .word 0         # bot moving: 0 not moving, 1 moving
# ul 12 elements 
bump_return_spots_ul:   .byte 3  3  5  5  7  8  5  10 11 10 12 14 13 13 15 13 5 17 7  19 17 17 10 17
# (3 ,3 ),(5 ,5 ),(7 ,8 ),(5 ,10),(11,10),(12,14),(13,13),(15,13),(5 ,17),(7 ,19),(17,17),(10,17)
# bl 4 elements 
bump_return_spots_bl:   .byte 16 20 6  24 9  28 17 27
# (16,20),(6 ,24),(9 ,28),(17,27)
# ur 4 elements 
bump_return_spots_ur:   .byte 23 19 33 17 30 11 22 12
# (23,19),(33,17),(30,11),(22,12)
# br 12 elements 
bump_return_spots_br:   .byte 36 36 34 34 32 31 34 29 28 29 27 25 26 26 24 26 34 22 32 20 22 22 29 22
# (36,36),(34,34),(32,31),(34,29),(28,29),(27,25),(26,26),(24,26),(34,22),(32,20),(22,22),(29,22)
last_moving_time:       .word 0
move_to:                .byte -1 -1
last_bump:              .byte -1 -1
num_kernels:            .word 0 0
### Bot global control

### Minibot control
silo_status:            .byte 0
silo_position:          .byte 7  19
silo_position_two_byte: .word 0x1307
silo_position_on_map:   .word 0
select_region:          .word 0x06120814
minibot_info:           .word 0
                        .word 0:12
bot_estimate_move_time: .word 0:6
current_checking_idx:   .word 0
### Minibot control

### Arctan
three:                  .float 3.0
five:                   .float 5.0
PI:                     .float 3.141592
F180:                   .float 180.0
### Arctan

### Euclidean_dist
dist_multiplier:        .float 1000.0
### Euclidean_dist

### Domino code map
### Domino code map

### Puzzle
GRIDSIZE = 8
solve_flag:             .byte 1
has_puzzle:             .word 0                         
puzzle:                 .half 0:2000             
heap:                   .half 0:2000
max_dots_storage:       .word 0
#### Puzzle

### Domino code map
max_dot_6:              .byte 1  2  3  4  5  6
                        .byte 2  8  9  10 11 12
                        .byte 3  9  15 16 17 18
                        .byte 4  10 16 22 23 24
                        .byte 5  11 17 23 29 30
                        .byte 6  12 18 24 30 36
max_dot_7:              .byte 1  2  3  4  5  6  7
                        .byte 2  9  10 11 12 13 14
                        .byte 3  10 17 18 19 20 21
                        .byte 4  11 18 25 26 27 28
                        .byte 5  12 19 26 33 34 35
                        .byte 6  13 20 27 34 41 42
                        .byte 7  14 21 28 35 42 49
max_dot_8:              .byte 1  2  3  4  5  6  7  8
                        .byte 2  10 11 12 13 14 15 16
                        .byte 3  11 19 20 21 22 23 24
                        .byte 4  12 20 28 29 30 31 32
                        .byte 5  13 21 29 37 38 39 40
                        .byte 6  14 22 30 38 46 47 48
                        .byte 7  15 23 31 39 47 55 56
                        .byte 8  16 24 32 40 48 56 64
### Domino code map

#### Maps
original_map:           .byte 0:1600
floor_indices:          .word 0:3200 
kernel_locations:       .word 0
                        .byte 0:1600
left_map_coordinate:    .byte 0  0  1  0  2  0  3  0  4  0
                        .byte 0  1  1  1  2  1  3  1  4  1
                        .byte 0  2  1  2  2  2  3  2  4  2
                        .byte 0  3  1  3  2  3  3  3  4  3  5  3
                        .byte 0  4  1  4  2  4  3  4  4  4  5  4  6  4
                        .byte 3  5  4  5  5  5  6  5  7  5  8  5  9  5  10 5  11 5  12 5  13 5
                        .byte 4  6  5  6  6  6  7  6  8  6  9  6  10 6  11 6  12 6  13 6
                        .byte 5  7  6  7  7  7  8  7  9  7  10 7  11 7  12 7  13 7
                        .byte 6  8  7  8  8  8  9  8  10 8
                        .byte 7  9  8  9  9  9  10 9  11 9
                        .byte 8  10 9  10 10 10 11 10 12 10
                        .byte 9  11 10 11 11 11 12 11 13 11
                        .byte 10 12 11 12 12 12 13 12
                        .byte 11 13 12 13 13 13
                        .byte 12 14 13 14
                        .byte 10 15 11 15 12 15 13 15
                        .byte 8  16 9  16 10 16 11 16 12 16 13 16
                        .byte 7  17 8  17 9  17 10 17 11 17 12 17 13 17
                        .byte 7  18 8  18 9  18 10 18 11 18 12 18 13 18
                        .byte 7  19 8  19 9  19 10 19 11 19 12 19 13 19
                        .byte 7  20 8  20 9  20 10 20 11 20 12 20 13 20
                        .byte 7  21 8  21 9  21 10 21 11 21 12 21 13 21
                        .byte 7  22 8  22 9  22 10 22 11 22 12 22 13 22
                        .byte 8  23 9  23 10 23 11 23 12 23 13 23
                        .byte 10 24 11 24 12 24 13 24
                        .byte 10 25 11 25 12 25 13 25
                        .byte 10 26 11 26 12 26 13 26
                        .byte 10 27 11 27 12 27 13 27
                        .byte 10 28 11 28 12 28 13 28
                        .byte 8  29 9  29 10 29 11 29 12 29 13 29
                        .byte 6  30 7  30 8  30 9  30 10 30 11 30 12 30 13 30
                        .byte 5  31 6  31 7  31 8  31 9  31 10 31 11 31 12 31 13 31
                        .byte 5  32 6  32 7  32 8  32 9  32 10 32 11 32 12 32 13 32
                        .byte 5  33 6  33 7  33 8  33 9  33 10 33 11 33 12 33 13 33
                        .byte 5  34 6  34 7  34 8  34 9  34 10 34 11 34 12 34 13 34
                        .byte 5  35 6  35 7  35 8  35 9  35 10 35 11 35 12 35 13 35
                        .byte 6  36 7  36 8  36 9  36 10 36 11 36 12 36 13 36
                        .byte 8  37 9  37 10 37 11 37 12 37 13 37
                        .byte -1
# (0 ,0 ),(1 ,0 ),(2 ,0 ),(3 ,0 ),(4 ,0 ),
# (0 ,1 ),(1 ,1 ),(2 ,1 ),(3 ,1 ),(4 ,1 ),
# (0 ,2 ),(1 ,2 ),(2 ,2 ),(3 ,2 ),(4 ,2 ),
# (0 ,3 ),(1 ,3 ),(2 ,3 ),(3 ,3 ),(4 ,3 ),(5 ,3 ),
# (0 ,4 ),(1 ,4 ),(2 ,4 ),(3 ,4 ),(4 ,4 ),(5 ,4 ),(6 ,4 ),
# (3 ,5 ),(4 ,5 ),(5 ,5 ),(6 ,5 ),(7 ,5 ),(8 ,5 ),(9 ,5 ),(10,5 ),(11,5 ),(12,5 ),(13,5 ),
# (4 ,6 ),(5 ,6 ),(6 ,6 ),(7 ,6 ),(8 ,6 ),(9 ,6 ),(10,6 ),(11,6 ),(12,6 ),(13,6 ),
# (5 ,7 ),(6 ,7 ),(7 ,7 ),(8 ,7 ),(9 ,7 ),(10,7 ),(11,7 ),(12,7 ),(13,7 ),
# (6 ,8 ),(7 ,8 ),(8 ,8 ),(9 ,8 ),(10,8 ),
# (7 ,9 ),(8 ,9 ),(9 ,9 ),(10,9 ),(11,9 ),
# (8 ,10),(9 ,10),(10,10),(11,10),(12,10),
# (9 ,11),(10,11),(11,11),(12,11),(13,11),
# (10,12),(11,12),(12,12),(13,12),
# (11,13),(12,13),(13,13),
# (12,14),(13,14),
# (10,15),(11,15),(12,15),(13,15),
# (8 ,16),(9 ,16),(10,16),(11,16),(12,16),(13,16),
# (7 ,17),(8 ,17),(9 ,17),(10,17),(11,17),(12,17),(13,17),
# (7 ,18),(8 ,18),(9 ,18),(10,18),(11,18),(12,18),(13,18),
# (7 ,19),(8 ,19),(9 ,19),(10,19),(11,19),(12,19),(13,19),
# (7 ,20),(8 ,20),(9 ,20),(10,20),(11,20),(12,20),(13,20),
# (7 ,21),(8 ,21),(9 ,21),(10,21),(11,21),(12,21),(13,21),
# (7 ,22),(8 ,22),(9 ,22),(10,22),(11,22),(12,22),(13,22),
# (8 ,23),(9 ,23),(10,23),(11,23),(12,23),(13,23),
# (10,24),(11,24),(12,24),(13,24),
# (10,25),(11,25),(12,25),(13,25),
# (10,26),(11,26),(12,26),(13,26),
# (10,27),(11,27),(12,27),(13,27),
# (10,28),(11,28),(12,28),(13,28),
# (8 ,29),(9 ,29),(10,29),(11,29),(12,29),(13,29),
# (6 ,30),(7 ,30),(8 ,30),(9 ,30),(10,30),(11,30),(12,30),(13,30),
# (5 ,31),(6 ,31),(7 ,31),(8 ,31),(9 ,31),(10,31),(11,31),(12,31),(13,31),
# (5 ,32),(6 ,32),(7 ,32),(8 ,32),(9 ,32),(10,32),(11,32),(12,32),(13,32),
# (5 ,33),(6 ,33),(7 ,33),(8 ,33),(9 ,33),(10,33),(11,33),(12,33),(13,33),
# (5 ,34),(6 ,34),(7 ,34),(8 ,34),(9 ,34),(10,34),(11,34),(12,34),(13,34),
# (5 ,35),(6 ,35),(7 ,35),(8 ,35),(9 ,35),(10,35),(11,35),(12,35),(13,35),
# (6 ,36),(7 ,36),(8 ,36),(9 ,36),(10,36),(11,36),(12,36),(13,36),
# (8 ,37),(9 ,37),(10,37),(11,37),(12,37),(13,37)
#### Maps

.text
main:
# Construct interrupt mask
	li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	          # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	mtc0    $t4, $12

# Fill in your code here
        li      $s0, 0                  # number of Puzzlecoins
    # Checking nearby kernels should not be performed more than once in 16000 cycles
        lw      $s1, TIMER($zero)       # last check time
        # s2
        li      $s3, 1                  # searching radius
        la      $t0, original_map
        sw      $t0, GET_MAP($zero)

# Initialize silo_position_on_map
        la      $t0, silo_position
        lb      $t1, 0($t0)
        lb      $t2, 1($t0)
        mul     $t2, $t2, 40
        add     $t1, $t1, $t2           # silo position offset
        la      $t0, original_map
        add     $t1, $t1, $t0           # silo position respective to map
        la      $t0, silo_position_on_map
        sw      $t1, 0($t0)

# Request initial puzzle
        la      $t0, puzzle            
        sw      $t0, REQUEST_PUZZLE($zero)

# Initial movement to center of the map
        li      $t0, 45
        sw      $t0, ANGLE($zero)
        li      $t0, 1                  # absolute
        sw      $t0, ANGLE_CONTROL($zero)
        li      $t0, 10
        sw      $t0, VELOCITY($zero)
        lw      $t0, TIMER($zero)       # get current time
        add     $t0, $t0, 260215        # estimated moving time
        sw      $t0, TIMER($zero)       # set timer interrupt
        li      $t0, 1
        la      $t1, moving
        sw      $t0, 0($t1)             # moving = 1

infinite:
        la      $t0, solve_flag
        lb      $t0, 0($t0)
# Is solve_flag true?
        bne     $t0, $zero, should_solve
    # should not solve at this time
        j       idling
should_solve:
# If have more than or equal to 2 puzzlecoins, stop solving and place a minibot
        blt     $s0, 2, attempt_solve_puzzle 
        la      $t0, num_kernels
        sw      $t0, GET_NUM_KERNELS($zero)
        lw      $t0, 0($t0)     # number of kernels currently have
        blt     $t0, 2, idling 
    # have more than or equal to 2 puzzlecoins  
        li      $t0, 1
        sw      $t0, SPAWN_MINIBOT($zero)
        sub     $s0, $s0, 2
        la      $t0, minibot_info
        sw      $t0, GET_MINIBOT_INFO($zero)
        lw      $t1, 0($t0)     # number of minibots currently have
# Are there totoal 5 minibots?
        blt     $t1, 5, minibot_not_enough
        la      $t2, solve_flag
        sb      $zero, 0($t2)
minibot_not_enough:
        sub     $a0, $t1, 1     # index (0-indexed)
        la      $t0, silo_position
        lb      $a1, 0($t0)     # target X
        lb      $a2, 1($t0)     # target Y
        jal     minibot_move_to_destination
        j       idling
attempt_solve_puzzle:
        la      $t0, has_puzzle
        lw      $t0, 0($t0)             # has_puzzle
    # If have puzzle currently, solve the puzzle
        bne     $t0, $zero, have_puzzle 
# Do not have puzzles to solve, switching to other tasks...
    # has_puzzle = 0  
idling:
# Is there a destination stored in move_to?
        la      $t0, move_to
        lb      $a0, 0($t0)             # move_to X
        blt     $a0, $zero, no_specified_destination
        lb      $a1, 1($t0)             # move_to Y
        jal     move_to_destination
    # reset move_to
        la      $t0, move_to
        li      $t1, -1
        sb      $t1, 0($t0)             # move_to X
        sb      $t1, 1($t0)             # move_to Y
        j       bot_moving
no_specified_destination:
# Moving?
        la      $t0, moving
        lw      $t0, 0($t0)
        bne     $t0, $zero, bot_moving
# Not moving
# Is the time since last moving is more than 200000 cycles?
        la      $t0, last_moving_time
        lw      $t0, 0($t0)             # last moving time
        lw      $t1, TIMER($zero)       # current time
        sub     $t1, $t1, $t0
        blt     $t1, 200000, not_enough_delay_since_bump
    # has more than 200000 cycles that is not moving, try to move to the center of the map
        li      $t0, 19
        la      $t1, move_to
        sb      $t0, 0($t1)
        sb      $t0, 1($t1)
        j       idling
not_enough_delay_since_bump:
# Checking Nearby Kernels
        la      $t9, kernel_locations   # &kernel_locations
        sw      $t9, GET_KERNEL_LOCATIONS($zero)
        add     $t9, $t9, 4
        lw      $t0, BOT_X($zero)       # X_coord
        div     $t0, $t0, 8
        lw      $t1, BOT_Y($zero)       # Y_coord
        div     $t1, $t1, 8
    # Search radius stored in $s3
        sub     $t2, $t0, $s3           # topleft_x 
        sub     $t3, $t1, $s3           # topleft_y 
        add     $t4, $t0, $s3           # bottomright_x 
        add     $t5, $t1, $s3           # bottomright_y 

# Top loop
# x - from x_min to x_max - 1 (inclusive)
# y - y_min
top_loop:
        blt     $t3, $zero, top_end_for
# x_min greater than or equal to 0
        li      $t0, 0                
        blt     $t2, $zero, top_loop_x_min_invaild
        move    $t0, $t2
# x_max less than or equal to 39
top_loop_x_min_invaild:
        li      $t1, 39
        bge     $t4, $t1, top_loop_x_max_invaild
        move    $t1, $t4
top_loop_x_max_invaild:

        mul     $t6, $t3, 40
        add     $t6, $t6, $t0
        add     $t6, $t6, $t9
top_for:
        bge     $t0, $t1, top_end_for
        lbu     $t7, 0($t6)
        beq     $t7, $zero, top_not_detected
        move    $t1, $t3
        j       detected
top_not_detected:
        add     $t0, $t0, 1
        add     $t6, $t6, 1
        j       top_for
top_end_for:
        
# Right loop
# x - x_max
# y - from y_min to y_max - 1 (inclusive)
rgt_loop:
        bgt     $t4, 39, rgt_end_for
# y_min greater than or equal to 0
        li      $t0, 0
        blt     $t3, $zero, rgt_loop_y_min_invaild
        move    $t0, $t3
rgt_loop_y_min_invaild:
# y_max less than or equal to 39
        li      $t1, 39
        bge     $t5, $t1, rgt_loop_y_max_invaild
        move    $t1, $t5
rgt_loop_y_max_invaild:

        mul     $t6, $t0, 40
        add     $t6, $t6, $t4
        add     $t6, $t6, $t9
rgt_for:
        bge     $t0, $t1, rgt_end_for
        lbu     $t7, 0($t6)
        beq     $t7, $zero, rgt_not_detected
        move    $t1, $t0
        move    $t0, $t4
        j       detected
rgt_not_detected:
        add     $t0, $t0, 1
        add     $t6, $t6, 40
        j       rgt_for
rgt_end_for:
        
# Bottom loop
# x - from x_max to x_min + 1 (inclusive)
# y - y_max
btm_loop:
        bgt     $t5, 39, btm_end_for
# x_min greater than or equal to 0
        li      $t0, 0
        blt     $t2, $zero, btm_loop_x_min_invaild
        move    $t0, $t2
btm_loop_x_min_invaild:
# x_max less than or equal to 39
        li      $t1, 39
        bge     $t4, $t1, btm_loop_x_max_invaild
        move    $t1, $t4
btm_loop_x_max_invaild:

        mul     $t6, $t5, 40
        add     $t6, $t6, $t1
        add     $t6, $t6, $t9
btm_for:
        ble     $t1, $t0, btm_end_for
        lbu     $t7, 0($t6)
        beq     $t7, $zero, btm_not_detected
        move    $t0, $t1
        move    $t1, $t5
        j       detected
btm_not_detected:
        sub     $t1, $t1, 1
        sub     $t6, $t6, 1
        j       btm_for
btm_end_for:

# Left loop
# x - x_min
# y - from y_max to y_min + 1 (inclusive)
lft_loop:
        blt     $t2, $zero, lft_end_for
# y_min greater than or equal to 0
        li      $t0, 0
        blt     $t3, $zero, lft_loop_y_min_invaild
        move    $t0, $t3
lft_loop_y_min_invaild:
# y_max less than or equal to 39
        li      $t1, 39
        bge     $t5, $t1, lft_loop_y_max_invaild
        move    $t1, $t5
lft_loop_y_max_invaild:

        mul     $t6, $t1, 40
        add     $t6, $t6, $t2
        add     $t6, $t6, $t9
lft_for:
        ble     $t1, $t0, lft_end_for
        lbu     $t7, 0($t6)
        beq     $t7, $zero, lft_not_detected
        move    $t0, $t2
        j       detected
lft_not_detected:
        sub     $t1, $t1, 1
        sub     $t6, $t6, 40
        j       lft_for
lft_end_for:

# No kernels detected within radius, increase radius of search
        add     $s3, $s3, 1
# Searching radius greater than 8, reduced to 1
        blt     $s3, 8, radius_acceptable
        li      $s3, 1
radius_acceptable:
        j       others
# Kernel Detected, moving to destination...
detected:
        li      $s3, 1                  # reset searching radius
        move    $a0, $t0
        move    $a1, $t1
        jal     move_to_destination
        j       bot_moving
# Have unsolved puzzle, solving...
    # has_puzzle = 1 
have_puzzle:
        la      $a0, puzzle
        la      $a1, heap
        la      $t0, has_puzzle
        sw      $zero, 0($t0)   # has_puzzle = 0
        jal     slow_solve_dominosa
# Puzzle solved, submitting...
        la      $t0, heap
        sw      $t0, SUBMIT_SOLUTION($zero)
        add     $s0, $s0, 1     # puzzlecoins + 1
        la      $t0, puzzle     # request another puzzle
        sw      $t0, REQUEST_PUZZLE($zero)
        j       others
# Moving 
bot_moving:
# Other event
others:
        la      $t0, silo_status
        lb      $t0, 0($t0)
        bne     $t0, $zero, silo_already_built
        la      $t0, minibot_info
        sw      $t0, GET_MINIBOT_INFO($zero)
        lw      $t1, 0($t0)     # number of minibots currently have
# Are there totoal 3 minibots and the silo is not built yet?
        blt     $t1, 3, silo_unable_to_be_built
        la      $t2, original_map
        sw      $t2, GET_MAP($zero)
        la      $t2, silo_position_on_map
        lw      $t2, 0($t2)
        lbu     $t2, 0($t2)
        beq     $t2, 2, silo_already_built
        la      $t2, num_kernels        # check if there is enough kernels
        sw      $t2, GET_NUM_KERNELS($zero)
        lw      $t2, 0($t2)     # number of kernels currently have
        blt     $t2, 10, silo_unable_to_be_built 
    # there is no silo but the building condition is met, build a silo
        la      $t2, select_region
        lw      $t2, 0($t2)
        sw      $t2, SELECT_MINIBOT_IN_REGION($zero)
        la      $t2, silo_position_two_byte
        lw      $t2, 0($t2)
        sw      $t2, BUILD_SILO($zero)
        la      $t2, original_map
        sw      $t2, GET_MAP($zero)
        la      $t2, silo_position_on_map
        lw      $t2, 0($t2)
        lbu     $t2, 0($t2)
        bne     $t2, 2, silo_unable_to_be_built
        la      $t0, silo_status
        sb      $sp, 0($t0)
silo_already_built:
        la      $t0, current_checking_idx
        lw      $t0, 0($t0)
        mul     $t1, $t0, 2
        la      $t2, left_map_coordinate
        add     $t1, $t1, $t2   # current checking pointer
        la      $t2, minibot_info
        sw      $t2, GET_MINIBOT_INFO($zero)
        lw      $t3, 0($t2)     # number of bots potentially waiting
#         bge     $t3, 3, no_need_for_suppliment
#     # has less than 3 bots, switch the solve_flag to true
#         la      $t4, solve_flag
#         li      $t5, 1
#         sb      $t5, 0($t4)
# no_need_for_suppliment:
        add     $t2, $t2, 4     # pointer to the first minibot struct
        la      $t4, bot_estimate_move_time     # pointer to the first minibot estimated moving time
        la      $t5, kernel_locations           # kernel map
        sw      $t5, GET_KERNEL_LOCATIONS($zero)
        add     $t5, $t5, 4
bot_checking_start: 
        lb      $a1, 0($t1)     # current checking X
        blt     $a1, $zero, checking_restart
        lb      $a2, 1($t1)     # current checking Y
        mul     $t6, $a2, 40
        add     $t6, $t6, $a1
        add     $t6, $t6, $t5   # pointer to current checking tile
        lb      $t6, 0($t6)     # current kernel number on this tile
        beq     $t6, $zero, check_next_tile
    # has kernel on current tile, loop through bots to find a suitable bot
        li      $a0, 0
not_searching_loop:
        bge     $a0, $t3, no_bot_availble
        mul     $t7, $t0, 4
        add     $t7, $t7, $t4
        lw      $t7, 0($t7)
        lw      $t8, TIMER($zero)
        sub     $t7, $t8, $t7   # current time - estimated moving time
        blt     $t7, $zero, time_not_enough 
        jal     minibot_move_to_destination
        add     $t0, $t0, 1
        add     $t1, $t1, 2
        j       bot_checking_start
time_not_enough:
        add     $a0, $a0, 1
        j       not_searching_loop
no_bot_availble:
        la      $a3, current_checking_idx
        add     $t0, $t0, 1
        sw      $t0, 0($a3)
        j       checking_end
check_next_tile:
        add     $t0, $t0, 1
        add     $t1, $t1, 2
        j       bot_checking_start
checking_restart:
        la      $t0, current_checking_idx
        sw      $zero, 0($t0)
checking_end:
silo_unable_to_be_built:

        j       infinite        # Don't remove this! If this is removed, then your code will not be graded!!!

        
#------------------------------------------------------------------------------
# minibot_move_to_destination
# $a0 - the index of the minibot (0-indexed)
# $a1 - destination X
# $a2 - destination Y
# time delay = (delta_x + delta_y) * 10000
minibot_move_to_destination:
        la      $a3, minibot_info
        sw      $a3, GET_MINIBOT_INFO($zero)
        lw      $v0, 0($a3)     # ONLY FOR CHECKING
        add     $a3, $a3, 4     # pointer to the first minibot struct
        mul     $v0, $a0, 8     # offset in minibot array
        add     $a3, $a3, $v0   # pointer to current minibot struct
        lb      $v0, 5($a3)
        sub     $v0, $a1, $v0
        bgt     $v0, $zero, first_argument_vaild 
        sub     $v0, $zero, $v0
first_argument_vaild:
        lb      $v1, 6($a3)
        sub     $v1, $a2, $v1
        bgt     $v1, $zero, second_argument_vaild 
        sub     $v1, $zero, $v1
second_argument_vaild:
        add     $v1, $v1, $v0   # delta_x + delta_y
        mul     $v1, $v1, 10000
        lw      $a3, 0($a3)     # ID of the minibot
        sw      $a3, SELECT_MINIBOT_BY_ID($zero)
        sll     $a2, $a2, 8
        or      $a2, $a2, $a1
        sw      $a2, SET_TARGET_TILE($zero)
        mul     $a2, $a0, 4
        la      $a3, bot_estimate_move_time
        add     $a3, $a3, $a2
        lw      $a2, TIMER($zero)
        add     $a2, $a2, $v1
        sw      $a2, 0($a3)
        jr      $ra
# minibot_move_to_destination END
#------------------------------------------------------------------------------
# move_to_destination - move the bot to destination
# $a0 - target x
# $a1 - target y
move_to_destination:
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)

        mul     $a2, $a0, 8            
        add     $a2, $a2, 4             # target X_coord
        mul     $a3, $a1, 8            
        add     $a3, $a3, 4             # target Y_coord
        lw      $a0, BOT_X($zero)       # bot X_coord
        lw      $a1, BOT_Y($zero)       # bot Y_coord
        sub     $a0, $a2, $a0
        sub     $a1, $a3, $a1
        jal     sb_arctan               # calculate angle
        sw      $v0, ANGLE($zero)
        li      $v0, 1                  # absolute
        sw      $v0, ANGLE_CONTROL($zero)
        jal     euclidean_dist
        lw      $t0, TIMER($zero)       # get current time
        add     $t0, $v0, $t0           # estimated moving time
        sw      $t0, TIMER($zero)       # set timer interrupt
        li      $t0, 10
        sw      $t0, VELOCITY($zero)    # full speed
        la      $t0, moving
        sw      $sp, 0($t0)             # moving = 1

        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra
# END move_to_destination
#------------------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# use $a2, $a3 as temp register
# the magnitude of $a0 and $a1 is not changed during the process
# returns the arctangent
sb_arctan:
        li      $v0, 0          # angle = 0
        abs     $a2, $a0        # get absolute values
        abs     $a3, $a1        
        ble     $a3, $a2, no_TURN_90
        move    $a2, $a1        # int temp = y
        neg     $a1, $a0        # y = -x
        move    $a0, $a2        # x = temp
        li      $v0, 90         # angle = 90
no_TURN_90:
        bgez    $a0, pos_x      # skip if x >= 0
        add     $v0, $v0, 180   # angle += 180
pos_x:
        mtc1    $a0, $f0         
        mtc1    $a1, $f1        
        cvt.s.w $f0, $f0        # convert from ints to floats
        cvt.s.w $f1, $f1
        div.s   $f0, $f1, $f0   # float v = (float) y / (float) x
        mul.s   $f1, $f0, $f0   # v ** 2
        mul.s   $f2, $f1, $f0   # v ** 3
        l.s     $f3, three      # load 3.0
        div.s   $f3, $f2, $f3   # v ** 3 / 3
        sub.s   $f6, $f0, $f3   # v - v ** 3 / 3
        mul.s   $f4, $f1, $f2   # v ** 5
        l.s     $f5, five       # load 5.0
        div.s   $f5, $f4, $f5   # v ** 5 / 5
        add.s   $f6, $f6, $f5   # value = v - v ** 3 / 3 + v ** 5 / 5
        l.s     $f8, PI         # load PI
        div.s   $f6, $f6, $f8   # value / PI
        l.s     $f7, F180       # load 180.0
        mul.s   $f6, $f6, $f7   # 180.0 * value / PI
        cvt.w.s $f6, $f6        # convert theta back to integer
        mfc1    $a2, $f6
        add     $v0, $v0, $a2   # angle += theta
        jr      $ra

# END sb_arctan
#------------------------------------------------------------------------------
# euclidean_dist - computes sqrt(x^2 + y^2) * dist_multiplier
# $a0 - x
# $a1 - y
# use $a2, $a3 as temp register
# returns the distance * dist_multiplier
euclidean_dist:
        mul     $a0, $a0, $a0   # x ** 2
        mul     $a1, $a1, $a1   # y ** 2
        add     $v0, $a0, $a1   # x ** 2 + y ** 2
        mtc1    $v0, $f0        # convert from ints to floats
        cvt.s.w $f0, $f0        # float(x ** 2 + y ** 2)
        sqrt.s  $f0, $f0        # sqrt(float(x ** 2 + y ** 2))
        l.s     $f1, dist_multiplier    # load dist_multiplier
        mul.s   $f0, $f0, $f1   # sqrt(float(x ** 2 + y ** 2)) * dist_multiplier
        cvt.w.s $f0, $f0        # convert distance * dist_multiplier back to integer
        mfc1    $v0, $f0
        jr      $ra

# END euclidean_dist
#------------------------------------------------------------------------------
# SLOW SOLVE DOMINOSA

# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
solve:
        lw      $t0, 4($a0)             # puzzle->num_cols
        lw      $t1, 0($a0)             # puzzle->num_rows
#     if (row >= num_rows || col >= num_cols) { return 1; }
        sge     $t2, $a2, $t1
        sge     $t3, $a3, $t0
        or      $t2, $t2, $t3
        beq     $t2, 0, solve_not_base
        li      $v0, 1
        jr      $ra

solve_not_base:
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
        mul     $t1, $a2, $t0           # row * num_cols
        add     $t1, $a3, $t1           # row * num_cols + col
        add     $t1, $a1, $t1           # &solution[row * num_cols + col]
        lb      $t1, 0($t1)             # solution[row * num_cols + col]
        beq     $t1, 0, solve_not_solved

        add     $t2, $a3, 1             # col + 1
        blt     $t2, $t0, vaild1
        li      $t2, 0
        add     $a2, $a2, 1
vaild1:
        move    $a3, $t2
        sub     $sp, $sp, 4
        sw      $ra, 0($sp)
        jal     solve
        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra

solve_not_solved:
        sub     $sp, $sp, 84
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)
        sw      $s7, 32($sp)
        la      $t0, max_dots_storage
        lw      $t0, 0($t0)
        sw      $t0, 80($sp)
        
        move    $s0, $a0                # puzzle
        move    $s1, $a1                # solution
        move    $s2, $a2                # row
        move    $s3, $a3                # col

#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     unsigned char* dominos_used = puzzle->dominos_used;
        lw      $s4, 0($s0)             # puzzle->num_rows
        lw      $s5, 4($s0)             # puzzle->num_cols
        lw      $s6, 8($s0)             # puzzle->max_dots
        la      $s7, 268($s0)           # puzzle->dominos_used

# Compute:
# - next_row (Done below)
# - next_col (Done below)
        mul     $t0, $s2, $s5
        add     $t0, $t0, $s3           # row * num_cols + col
        add     $t1, $t0, $s5           # (row + 1) * num_cols + col
        add     $t2, $t0, 1             # row * num_cols + (col + 1)

        la      $t3, 12($s0)            # puzzle->board
        add     $t4, $t3, $t0
        lbu     $t9, 0($t4)
        mul     $t9, $t9, $s6
        sw      $t9, 44($sp)            # puzzle->board[row * num_cols + col] * max_dots
        add     $t4, $t3, $t1
        lbu     $t9, 0($t4)
        sw      $t9, 48($sp)            # puzzle->board[(row + 1) * num_cols + col]
        add     $t4, $t3, $t2
        lbu     $t9, 0($t4)
        sw      $t9, 52($sp)            # puzzle->board[row * num_cols + (col + 1)]

        # solution addresses
        add     $t9, $s1, $t0
        sw      $t9, 56($sp)            # &solution[row * num_cols + col]
        add     $t9, $a1, $t1
        sw      $t9, 60($sp)            # &solution[(row + 1) * num_cols + col]
        add     $t9, $a1, $t2
        sw      $t9, 64($sp)            # &solution[row * num_cols + (col + 1)]


        #     int next_row = ((col == num_cols - 1) ? row + 1 : row);
        #     int next_col = (col + 1) % num_cols;
        move    $v0, $s2                # row
        add     $v1, $s3, 1             # col + 1
        blt     $v1, $s5, vaild2        
        li      $v1, 0
        add     $v0, $v0, 1
vaild2:
        sw      $v0, 36($sp)
        sw      $v1, 40($sp)

#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
        lw      $t9, 44($sp)            # puzzle->board[row * num_cols + col] * max_dots

#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
        sub     $t5, $s4, 1
        bge     $s2, $t5, end_vert

        lw      $t0, 60($sp)
        lbu     $t8, 0($t0)             # solution[(row + 1) * num_cols + col]
        bne     $t8, 0, end_vert 

#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
        lw      $a0, 80($sp)
        add     $a0, $a0, $t9
        lw      $a1, 48($sp)
        add     $a0, $a0, $a1
        lbu     $v0, 0($a0)
        sw      $v0, 68($sp)

#         if (dominos_used[domino_code] == 0) {
        add     $t0, $s7, $v0
        lbu     $t1, 0($t0)
        bne     $t1, 0, end_vert

#             dominos_used[domino_code] = 1;
        li      $t1, 1
        sb      $t1, 0($t0)

#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
        lw      $t0, 56($sp)
        sb      $v0, 0($t0)
        lw      $t0, 60($sp)
        sb      $v0, 0($t0)

        
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
        move    $a0, $s0
        move    $a1, $s1
        lw      $a2, 36($sp)
        lw      $a3, 40($sp)
        jal     solve
        beq     $v0, 0, end_vert_if
        
        li      $v0, 1
        j       solve_end
end_vert_if:

#             dominos_used[domino_code] = 0;
        lw      $v0, 68($sp)            # domino_code
        add     $t0, $v0, $s7
        sb      $zero, 0($t0)
        
#             solution[row * num_cols + col] = 0;
        lw      $t0, 56($sp)
        sb      $zero, 0($t0)
#             solution[(row + 1) * num_cols + col] = 0;
        lw      $t0, 60($sp)
        sb      $zero, 0($t0)
#         }
#     }

end_vert:

#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
        sub     $t5, $s5, 1
        bge     $s3, $t5, ret_0
        lw      $t0, 64($sp)
        lbu     $t1, 0($t0)             # solution[row * num_cols + (col + 1)]
        bne     $t1, 0, ret_0

#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
        lw      $a1, 44($sp)            # puzzle->board[row * num_cols + col]
        lw      $a0, 80($sp)
        add     $a0, $a0, $a1
        lw      $a1, 52($sp)
        add     $a0, $a0, $a1
        lbu     $v0, 0($a0)
        sw      $v0, 68($sp)

#         if (dominos_used[domino_code] == 0) {
        add     $t0, $s7, $v0
        lbu     $t1, 0($t0)
        bne     $t1, 0, ret_0
        
#             dominos_used[domino_code] = 1;
        li      $t1, 1
        sb      $t1, 0($t0)

#             solution[row * num_cols + col] = domino_code;
        lw      $t0, 56($sp)
        sb      $v0, 0($t0)
#             solution[row * num_cols + (col + 1)] = domino_code;
        lw      $t0, 64($sp)
        sb      $v0, 0($t0)
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
        move    $a0, $s0
        move    $a1, $s1
        lw      $a2, 36($sp)
        lw      $a3, 40($sp)
        jal     solve
        beq     $v0, 0, end_horz_if
        
        li      $v0, 1
        j       solve_end
end_horz_if:



#             dominos_used[domino_code] = 0;
        lw      $v0, 68($sp) # domino_code
        add     $t0, $s7, $v0 
        sb      $zero, 0($t0)
        
#             solution[row * num_cols + col] = 0;
        lw      $t0, 56($sp)
        sb      $zero, 0($t0)
#             solution[row * num_cols + (col + 1)] = 0;
        lw      $t0, 64($sp)
        sb      $zero, 0($t0)
#         }
#     }
#     return 0;
# }
ret_0:
        li      $v0, 0

solve_end:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        lw      $s6, 28($sp)
        lw      $s7, 32($sp)
        add     $sp, $sp, 84
        jr      $ra



# // zero out an array with given number of elements
# void zero(int num_elements, unsigned char* array) {
#     for (int i = 0; i < num_elements; i++) {
#         array[i] = 0;
#     }
# }
zero:
        li      $t0, 0          # i = 0
zero_loop:
        bge     $t0, $a0, zero_end_loop
        add     $t1, $a1, $t0
        sb      $zero, 0($t1)
        add     $t0, $t0, 1
        j       zero_loop
zero_end_loop:
        jr      $ra




# // the slow solve entry function,
# // solution will appear in solution array
# // return value shows if the dominosa is solved or not
# int slow_solve_dominosa(dominosa_question* puzzle, unsigned char* solution) {
#     zero(puzzle->num_rows * puzzle->num_cols, solution);
#     zero(MAX_MAXDOTS * MAX_MAXDOTS, dominos_used);
#     return solve(puzzle, solution, 0, 0);
# }
# // end of solution
# /*** end of the solution to the puzzle ***/
slow_solve_dominosa:
        sub     $sp, $sp, 16
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)

        move    $s0, $a0
        move    $s1, $a1



#     zero(puzzle->num_rows * puzzle->num_cols, solution);
        lw      $t0, 0($s0)
        lw      $t1, 4($s0)
        mul     $a0, $t0, $t1
        jal     zero

#     zero(MAX_MAXDOTS * MAX_MAXDOTS + 1, dominos_used);
        li      $a0, 226
        la      $a1, 268($s0)
        jal     zero
        
#     zero(puzzle->num_rows * puzzle->num_cols, solution);

#     return solve(puzzle, solution, 0, 0);
        move    $a0, $s0
        move    $a1, $s1
        li      $a2, 0
        li      $a3, 0
        jal     solve

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        add     $sp, $sp, 16

        jr      $ra
# END SLOW SOLVE DOMINOSA
#------------------------------------------------------------------------------

.kdata
chunkIH:                .word 2
query_saving_space:     .word 7
non_intrpt_str:         .asciiz "Non-interrupt exception\n"
unhandled_str:          .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        la      $v0, query_saving_space # save some register value to get some space
        sw      $s0, 0($v0)
        sw      $s1, 4($v0)
        sw      $s2, 8($v0)
        sw      $s3, 12($v0)
        sw      $s4, 16($v0)
        sw      $s5, 20($v0)
        sw      $s6, 24($v0)

query_start:
        lw      $s0, BOT_X($zero)
        div     $s0, $s0, 8     # current X
        lw      $s1, BOT_Y($zero)
        div     $s1, $s1, 8     # current Y
        la      $v0, last_bump
        lb      $s2, 0($v0)     # last bonk X
        lb      $s3, 1($v0)     # last bonk Y
        sb      $s0, 0($v0)     # renew last bonk X
        sb      $s1, 1($v0)     # renew last bonk Y
        seq     $s4, $s0, $s2
        seq     $s5, $s0, $s2
        and     $s4, $s4, $s5
        beq     $s4, $zero, new_bonk_position
# bonk on the same position as before
        # li      $s0, 19
        # la      $a0, move_to
        # sb      $s0, 0($a0)     # X destination
        # sb      $s0, 1($a0)     # Y destination
        # j       end_bonk_process
new_bonk_position:
        li      $s4, 0          # nearest spot idx
        li      $s5, 10000      # nearest spot distance
        bgt     $s0, 19, rgt_query    
# On the left side of the map (x <= 19)
lft_query:
        bgt     $s1, 19, bl_query
# On the upper-left side of the map (x <= 19 && y <= 19)
ul_query:
        la      $a0, bump_return_spots_ul
        li      $s6, 12         # search length = 12
        j       start_query
# On the bottom-left side of the map (x <= 19 && y > 19)
bl_query:
        la      $a0, bump_return_spots_bl
        li      $s6, 4         # search length = 4
        j       start_query
# On the right side of the map (x > 19)
rgt_query:
        bgt     $s1, 19, br_query
# On the upper-right side of the map (x > 19 && y <= 19)
ur_query:
        la      $a0, bump_return_spots_ur
        li      $s6, 4         # search length = 4
        j       start_query
# On the bottom-right side of the map (x > 19 && y > 19)
br_query:
        la      $a0, bump_return_spots_br
        li      $s6, 12         # search length = 12
        
start_query:
        li      $v0, 0
query_for:
        bge     $v0, $s6, query_end_for
        lbu     $s2, 0($a0)
        lbu     $s3, 1($a0)
        sub     $s2, $s2, $s0   # delta_x
        mul     $s2, $s2, $s2   # delta_x ** 2
        sub     $s3, $s3, $s1   # delta_y
        mul     $s3, $s3, $s3   # delta_y ** 2
        add     $s2, $s2, $s3   # delta_x ** 2 + delta_y ** 2
        bge     $s2, $s5, larger
        move    $s4, $v0
        move    $s5, $s2
larger:
        add     $a0, $a0, 2
        add     $v0, $v0, 1
        j       query_for
query_end_for:
        nop
        sub     $s4, $s6, $s4
        sub     $a0, $a0, $s4
        sub     $a0, $a0, $s4  
        lbu     $s0, 0($a0)
        lbu     $s1, 1($a0)
        la      $a0, move_to
        sb      $s0, 0($a0)     # X destination
        sb      $s1, 1($a0)     # Y destination

end_bonk_process:
        la      $v0, query_saving_space # restore register values
        lw      $s0, 0($v0)
        lw      $s1, 4($v0)
        lw      $s2, 8($v0)
        lw      $s3, 12($v0)
        lw      $s4, 16($v0)
        lw      $s5, 20($v0)
        lw      $s6, 24($v0)
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        la      $a0, has_puzzle
        sw      $sp, 0($a0)             # has_puzzle = 1
        
        la      $a0, puzzle
        lw      $a0, 8($a0)             # puzzle->max_dots

        la      $v0, max_dot_8
        bne     $a0, 6, other_choice
        la      $v0, max_dot_6
other_choice:
        bne     $a0, 7, end_map
        la      $v0, max_dot_7
end_map:
        la      $a0, max_dots_storage
        sw      $v0, 0($a0)

        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        sw      $zero, VELOCITY($zero)  # Stop moving
        sw      $sp, PICKUP($zero)      # Pickup kernels on current tile
        la      $a0, moving
        sw      $zero, 0($a0)           # moving = 0
        la      $a0, last_moving_time
        lw      $v0, TIMER($zero)       
        sw      $v0, 0($a0)             # record last moving time
        j       interrupt_dispatch

non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
