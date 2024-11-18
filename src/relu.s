.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             

loop_start:
    # TODO: Add your own implementation
    bge t1, a1, done      # If t1 >= a1, we are done
    lw t2, 0(a0)          # Load array element into t2
    bge t2, zero, skip    # If t2 >= 0, skip modification

    # If t2 < 0, set it to 0 (ReLU operation)
    sw zero, 0(a0)        # Store 0 back into the array

skip:
    addi t1, t1, 1        # Increment the loop counter
    addi a0, a0, 4        # Move to the next element (4 bytes per int)
    j loop_start              # Repeat for next element

error:
    li a0, 36          
    j exit

done:
    jr ra          