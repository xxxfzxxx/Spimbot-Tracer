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

### Bot global control
moving:                 .word 0         # bot moving: 0 not moving, 1 moving
bump_return_spots_lft:  .byte 3  3  5  5  7  8  12 12 12 14 15 13 19 10 7  19 7  24 9  28 16 28
# (3 ,3 ),(5 ,5 ),(7 ,8 ),(12,12),(12,14),(15,13),(19,10),(7 ,19),(7 ,24),(9 ,28),(16,28)
bump_return_spots_rgt:  .byte 36 36 34 34 32 31 27 27 27 25 24 26 20 29 32 20 32 15 30 11 23 11
# (36,36),(34,34),(32,31),(27,27),(27,25),(24,26),(20,29),(32,20),(32,15),(30,11),(23,11)
hot_spots_lft:          .byte 3 3 17 19 6 27
hot_spots_rgt:
move_to:                .byte -1 -1
### Bot global control

### Minibot control
silo_status:            .byte 0
silo_position:          .byte 7 8
minibot_info:           .word 0
                        .word 0:12
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
        lw      $s2, TIMER($zero)       # last move time
        li      $s3, 1                  # searching radius
        la      $t0, original_map
        sw      $t0, GET_MAP($zero)

# Request initial puzzle
        la      $t0, puzzle            
        sw      $t0, REQUEST_PUZZLE($zero)

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
        la      $t0, has_puzzle
        lw      $t0, 0($t0)             # has_puzzle
    # If have more than 4 puzzlecoins, stop solving
        bge     $s0, 4, idling         
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
no_enough_delay_since_bump:
# Moving?
        la      $t0, moving
        lw      $t0, 0($t0)
        bne     $t0, $zero, bot_moving
# Not moving
        lw      $t0, TIMER($zero)       # current time
        sub     $t1, $t0, $s2
    # check if the bot has moved in last 120000 cycles
        #blt     $t1, 120000, 
        sub     $t1, $t0, $s1
    # within 16000 cycles of another check, should not duplicate checking process
        blt     $t1, 16000, no_checking        
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
        add     $s0, $s0, 1     # number of puzzle solved + 1
        la      $t0, puzzle     # request another puzzle
        sw      $t0, REQUEST_PUZZLE($zero)
        j       others
# Within 16000 cycles of another ckeck
no_checking:
# Moving 
bot_moving:
# Other event
others:
        j       infinite        # Don't remove this! If this is removed, then your code will not be graded!!!

        
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
query_saving_space:     .word 6
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

# Reflection on bumping into a wall
#         lw      $v0, ANGLE($zero)       # get current angle
#         lw      $s0, BOT_X($zero)       # current X
#         lw      $s1, BOT_Y($zero)       # current Y
#         rem     $s0, $s0, 8     # local X
#         rem     $s1, $s1, 8     # local Y
#         add     $s2, $s0, $s1   # x + y
#         beq     $s2, 7, turn_around
#         beq     $s0, $s1, turn_around
#         slt     $s2, $s2, 8     # x + y < 7
#         slt     $s3, $s0, $s1   # x < y
#         xor     $s1, $s2, $s3 
#         li      $s0, 180
#         beq     $s1, $zero, vertical_barrier 
#         li      $s0, 360
# vertical_barrier:
#         bge     $v0, $zero, non_negative_orientation 
#         add     $v0, $v0, 360
# non_negative_orientation:
#         sub     $v0, $s0, $v0
#         sw      $v0, ANGLE($zero)
#         li      $a0, 1   
#         sw      $a0, ANGLE_CONTROL($zero)       # absolute
#         j       adjustment_end

# turn_around:
#         li      $v0, 180
#         sw      $v0, ANGLE($zero)
#         sw      $zero, ANGLE_CONTROL($zero)     # relative
#         j       adjustment_end

# adjustment_end:
#         lw      $v0, TIMER($zero)
#         add     $v0, $v0, 4000
#         sw      $v0, TIMER($zero)       # register a timer interrupt
#         li      $v0, 10
#         sw      $v0, VELOCITY($zero)    # full speed
#         la      $a0, moving
#         li      $v0, 1
#         sw      $v0, 0($a0)           # moving = 1

query_start:
        lw      $s0, BOT_X($zero)
        div     $s0, $s0, 8     # current X
        lw      $s1, BOT_Y($zero)
        div     $s1, $s1, 8     # current Y
        li      $s4, 0          # nearest spot idx
        li      $s5, 10000      # nearest spot distance
        bgt     $s0, 19, rgt_query    
# On the left side of the map (x <= 19)
lft_query:
        la      $a0, bump_return_spots_lft
        li      $v0, 0
lft_query_for:
        bge     $v0, 9, lft_query_end_for
        lbu     $s2, 0($a0)
        lbu     $s3, 1($a0)
        sub     $s2, $s2, $s0   # delta_x
        mul     $s2, $s2, $s2   # delta_x ** 2
        sub     $s3, $s3, $s1   # delta_y
        mul     $s3, $s3, $s3   # delta_y ** 2
        add     $s2, $s2, $s3   # delta_x ** 2 + delta_y ** 2
        bge     $s2, $s5, lft_larger
        move    $s4, $v0
        move    $s5, $s2
lft_larger:
        add     $a0, $a0, 2
        add     $v0, $v0, 1
        j       lft_query_for
lft_query_end_for:
        mul     $s4, $s4, 2
        la      $a0, bump_return_spots_lft     
        add     $a0, $a0, $s4
        lbu     $s0, 0($a0)
        lbu     $s1, 1($a0)
        la      $a0, move_to
        sb      $s0, 0($a0)     # X destination
        sb      $s1, 1($a0)     # Y destination
        j       end_query

# On the right side of the map (x > 19)
rgt_query:
        la      $a0, bump_return_spots_rgt
        li      $v0, 0
rgt_query_for:
        bge     $v0, 9, rgt_query_end_for
        lbu     $s2, 0($a0)
        lbu     $s3, 1($a0)
        sub     $s2, $s2, $s0   # delta_x
        mul     $s2, $s2, $s2   # delta_x ** 2
        sub     $s3, $s3, $s1   # delta_y
        mul     $s3, $s3, $s3   # delta_y ** 2
        add     $s2, $s2, $s3   # delta_x ** 2 + delta_y ** 2
        bge     $s2, $s5, rgt_larger
        move    $s4, $v0        
        move    $s5, $s2
rgt_larger:
        add     $a0, $a0, 2
        add     $v0, $v0, 1
        j       rgt_query_for
rgt_query_end_for:
        mul     $s4, $s4, 2
        la      $a0, bump_return_spots_rgt
        add     $a0, $a0, $s4
        lbu     $s0, 0($a0)
        lbu     $s1, 1($a0)
        la      $a0, move_to
        sb      $s0, 0($a0)     # X destination
        sb      $s1, 1($a0)     # Y destination

end_query:
        la      $v0, query_saving_space # restore register values
        lw      $s0, 0($v0)
        lw      $s1, 4($v0)
        lw      $s2, 8($v0)
        lw      $s3, 12($v0)
        lw      $s4, 16($v0)
        lw      $s5, 20($v0)
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
