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
### Bot global control

### Arctan
three:                  .float 3.0
five:                   .float 5.0
PI:                     .float 3.141592
F180:                   .float 180.0
### Arctan

### Euclidean_dist
dist_multiplier:        .float 8000.0
### Euclidean_dist

### Puzzle
GRIDSIZE = 8
requested_puzzle:       .word 0
has_puzzle:             .word 0                         
puzzle:                 .half 0:2000             
heap:                   .half 0:2000
#### Puzzle

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
        la      $s0, has_puzzle         # &has_puzzle
        la      $s1, requested_puzzle   # &requested_puzzle
        #       $s2                     # number of Puzzlecoins
        li      $s3, 5                  # pick up radius
        la      $t0, original_map
        sw      $t0, GET_MAP($zero)
        # li      $t0, 10
        # sw      $t0, VELOCITY($zero)    # full speed

infinite:
        lw      $t0, 0($s0)     # has_puzzle
        lw      $t1, 0($s1)     # requested_puzzle

        bne     $t0, $zero, have_puzzle
        bne     $t1, $zero, idling
# If have 20 or more Puzzlecoins, stop solving
        bge     $s2, 10, idling
# No puzzle currently, requesting...
# has_puzzle = 0  requested_puzzle = 0
        la      $t0, puzzle
        sw      $t0, REQUEST_PUZZLE($zero)
        sw      $sp, 0($s1)     # requested_puzzle = 1
        j       idling
# Spare, idling...
# has_puzzle = 0  requested_puzzle = 1
idling:
# Moving?
        la      $t0, moving
        lw      $t0, 0($t0)
        bne     $t0, $zero, bot_moving
# Not moving
# Pickup Nearby Kernels
        la      $t9, kernel_locations   # &kernel_locations
        sw      $t9, GET_KERNEL_LOCATIONS($zero)
        add     $t9, $t9, 4
        lw      $t0, BOT_X($zero)       # X_coord
        div     $t0, $t0, 8
        lw      $t1, BOT_Y($zero)       # Y_coord
        div     $t1, $t1, 8
init_topleft_x:
        sub     $t2, $t0, $s3           # topleft_x 
        bge     $t2, $zero, init_topleft_y
        li      $t2, 0
init_topleft_y:
        sub     $t3, $t1, $s3           # topleft_y 
        bge     $t3, $zero, init_bottomright_x
        li      $t3, 0
init_bottomright_x:
        add     $t4, $t0, $s3           # bottomright_x 
        ble     $t4, 39, init_bottomright_y
        li      $t4, 39
init_bottomright_y:
        add     $t5, $t1, $s3           # bottomright_y 
        ble     $t5, 39, end_init
        li      $t5, 39
end_init:

        move    $t1, $t3        # j     from topleft_y to bottomright_y
        li      $t6, 0          # 40 * j
find_for_out:
        bge     $t1, $t5, find_end_for_out
        move    $t0, $t2        # i     from topleft_x to bottomright_y
find_for_in:
        bge     $t0, $t4, find_end_for_in
        add     $t7, $t6, $t0   # 40 * j + i
        add     $t7, $t7, $t9   # &kernel_locations[40 * j + i]
        lbu     $t7, 0($t7)
        beq     $t7, 0, no_kernel
# Kernel Detected
        lw      $a0, BOT_X($zero)       # bot X_coord
        lw      $a1, BOT_Y($zero)       # bot Y_coord
        mul     $a2, $t0, 8            
        add     $a2, $a2, 4             # target X_coord
        mul     $a3, $t1, 8            
        add     $a3, $a3, 4             # target Y_coord
        sub     $a0, $a2, $a0
        sub     $a1, $a3, $a1
        jal     sb_arctan               # calculate angle
        sw      $v0, ANGLE($zero)
        li      $v0, 1                  # absolute
        sw      $v0, ANGLE_CONTROL($zero)
        sub     $a0, $t0, $t2
        sub     $a1, $t1, $t3
        jal     euclidean_dist
        lw      $t0, TIMER($zero)       # get current time
        add     $t0, $v0, $t0           # estimated moving time
        sw      $t0, TIMER($zero)       # set timer interrupt
        li      $t0, 10
        sw      $t0, VELOCITY($zero)    # full speed
        la      $t0, moving
        sw      $sp, 0($t0)             # moving = 1
        li      $s3, 5                  # reset searching radius
        j       find_end_for_out
no_kernel:
        add     $t0, $t0, 1
        j       find_for_in
find_end_for_in:
        add     $t1, $t1, 1
        add     $t6, $t6, 40
        j       find_for_out
find_end_for_out:
        add     $s3, $s3, 1
        ble     $s3, 10, maximum_radius_end_if
        li      $s3, 10
maximum_radius_end_if:
        j       infinite
# Have unsolved puzzle, solving...
# has_puzzle = 1  requested_puzzle = 1
have_puzzle:
        la      $a0, puzzle
        la      $a1, heap
        sw      $zero, 0($s0)   # has_puzzle = 0
        sw      $zero, 0($s1)   # requested_puzzle = 0
        jal     slow_solve_dominosa
# Puzzle solved, submitting...
        la      $t0, heap
        sw      $t0, SUBMIT_SOLUTION($zero)
        add     $s2, $s2, 1

# Moving
bot_moving:

        j       infinite        # Don't remove this! If this is removed, then your code will not be graded!!!

        
#------------------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# use $a2, $a3 as temp register
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

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
encode_domino:
        bge     $a0, $a1, encode_domino_greater_row

        mul     $v0, $a0, $a2           # col * max_dots
        add     $v0, $v0, $a1           # col * max_dots + row
        add     $v0, $v0, 1             # col * max_dots + row + 1
        j       encode_domino_end
encode_domino_greater_row:
        mul     $v0, $a1, $a2           # row * max_dots
        add     $v0, $v0, $a0           # row * max_dots + col
        add     $v0, $v0, 1             # col * max_dots + row + 1
encode_domino_end:
        jr      $ra

# -------------------------------------------------------------------------
next:
        # $a0 = row
        # $a1 = col
        # $a2 = num_cols
        # $v0 = next_row
        # $v1 = next_col

        #     int next_row = ((col == num_cols - 1) ? row + 1 : row);
        move    $v0, $a0
        sub     $t0, $a2, 1
        bne     $a1, $t0, next_col
        add     $v0, $v0, 1
next_col:
        #     int next_col = (col + 1) % num_cols;
        add     $t1, $a1, 1
        rem     $v1, $t1, $a2

        jr      $ra




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
        sub     $sp, $sp, 80
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)
        sw      $s5, 24($sp)
        sw      $s6, 28($sp)
        sw      $s7, 32($sp)
        
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
        add     $t1, $s2, 1
        mul     $t1, $t1, $s5
        add     $t1, $t1, $s3           # (row + 1) * num_cols + col
        mul     $t2, $s2, $s5
        add     $t2, $t2, $s3
        add     $t2, $t2, 1             # row * num_cols + (col + 1)

        la      $t3, 12($s0)            # puzzle->board
        add     $t4, $t3, $t0
        lbu     $t9, 0($t4)
        sw      $t9, 44($sp)            # puzzle->board[row * num_cols + col]
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
        move    $a0, $s2
        move    $a1, $s3
        move    $a2, $s5
        jal     next
        sw      $v0, 36($sp)
        sw      $v1, 40($sp)


#     if (row >= num_rows || col >= num_cols) { return 1; }
        sge     $t0, $s2, $s4
        sge     $t1, $s3, $s5
        or      $t0, $t0, $t1
        beq     $t0, 0, solve_not_base

        li      $v0, 1
        j       solve_end
solve_not_base:

#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
        lw      $t0, 56($sp)
        lb      $t0, 0($t0)
        beq     $t0, 0, solve_not_solved

        move    $a0, $s0
        move    $a1, $s1
        move    $a2, $v0
        move    $a3, $v1
        jal     solve
        j       solve_end

solve_not_solved:
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
        lw      $t9, 44($sp)            # puzzle->board[row * num_cols + col]

#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
        sub     $t5, $s4, 1
        bge     $s2, $t5, end_vert

        lw      $t0, 60($sp)
        lbu     $t8, 0($t0)             # solution[(row + 1) * num_cols + col]
        bne     $t8, 0, end_vert 

#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
        move    $a0, $t9
        lw      $a1, 48($sp)
        move    $a2, $s6
        jal     encode_domino
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
        lw      $a0, 44($sp)            # puzzle->board[row * num_cols + col]
        lw      $a1, 52($sp)
        move    $a2, $s6
        jal     encode_domino
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
        add     $sp, $sp, 80
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
chunkIH:    .space 8  
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
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
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        la      $a0, has_puzzle
        sw      $sp, 0($a0)             # has_puzzle = 1
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
