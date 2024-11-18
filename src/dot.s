.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
    mv t4, x0
    mv t3, t1
mul_loop1:
    beq t3, x0, mul_done1
    add t4, t4, a3
    addi t3, t3, -1
    j mul_loop1

mul_done1:
    mv t2, t4

    # mul t2, t1, a3
    slli t2, t2, 2
    add t2, a0, t2
    lw t2, 0(t2)

    mv t5, x0
    mv t3, t1
mul_loop2:
    beq t3, x0, mul_done2
    add t5, t5, a4
    addi t3, t3, -1
    j mul_loop2

mul_done2:
    mv t4, t5

    # mul t4, t1, a4
    slli t4, t4, 2
    add t4, a1, t4
    lw t4, 0(t4)

    # mul t6, t2, t4
    li t6, 0
    li t3, 0
    bltz t2, t2_neg
    j t2_checked
t2_neg:
    sub t2, x0, t2
    li t3, 1
t2_checked:
    bltz t4, t4_neg
    j t4_checked
t4_neg:
    sub t4, x0, t4
    xori t3, t3, 1
t4_checked:
    li t5, 0
mul_t2_t4_loop:
    beq t5, t4, mul_done3
    add t6, t6, t2
    addi t5, t5, 1
    j mul_t2_t4_loop
mul_done3:
    beq t3, x0, mul_end
    sub t6, x0, t6
mul_end:
    add t0, t0, t6
    addi t1, t1, 1
    j loop_start
    
loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

