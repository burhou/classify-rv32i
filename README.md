# RISC-V Absolute Value Function

## Functionality
### `abs`
- **Operation**: 
  - If the integer is negative, its sign is inverted using the `neg` instruction.
  - If the integer is already non-negative, no changes are made.
- **Input**: 
  - `a0`: A pointer to an integer in memory.
- **Output**: 
  - The operation modifies the value at the pointer address directly in memory.

### How It Works
1. The integer is loaded from memory into the `t0` register.
2. A conditional branch (`bge`) checks whether the integer is non-negative:
   - If yes, the program jumps to the `done` label, skipping further processing.
   - If no, the integer is negated using the `neg` instruction and written back to memory using `sw`.
3. The program returns to the caller with the `jr` instruction.

## Challenges and Solutions
### Challenge 1: Handling Pointer Dereferencing
- **Issue**: Correctly loading and modifying the value at the memory address pointed to by `a0`.
- **Solution**: Used the `sw` instruction to store the modified value back into memory.

## Conclusion
This project implements a RISC-V assembly function named `abs` that converts an integer to its absolute value. The operation modifies the original value in memory via pointer dereferencing.

# RISC-V Argmax Function

## Functionality
### `argmax`
- **Purpose**: Identifies the index of the first maximum value in an array.
- **Inputs**: 
  - `a0`: Pointer to the first element of the array.
  - `a1`: Number of elements in the array.
- **Output**: 
  - `a0`: 0-based index of the first occurrence of the maximum value.
- **Error Handling**: 
  - If the array length (`a1`) is less than 1, the program terminates with an exit code of `36`.

### How It Works
1. **Initialization**: 
   - `t0` stores the maximum value, initialized to the first array element.
   - `t1` stores the index of the maximum value, initialized to 0.
   - `t2` acts as a loop counter, starting at 1 (for the second element onward).
2. **Iterative Comparison**:
   - The function iterates through the array using `lw` to load elements.
   - If a new maximum is found (`t3 > t0`), the maximum value (`t0`) and its index (`t1`) are updated.
   - Ties are ignored, keeping the smallest index for the maximum value.
3. **Loop Termination**:
   - The loop ends when all elements have been scanned (`t2 >= a1`).
4. **Error Handling**:
   - If `a1 < 1`, the program jumps to `handle_error` and exits with a code of `36`.

## Challenges and Solutions
### Challenge 1: Iterating Through an Array
- **Issue**: Correctly traversing the array and maintaining accurate pointer arithmetic.
- **Solution**: Used `addi` to increment the pointer (`a0`) by 4 bytes (size of an integer).

### Challenge 2: Comparing Values
- **Issue**: Efficiently determining when to update the maximum value and its index.
- **Solution**: Employed `blt` and `mv` instructions to conditionally update the maximum value and its index.

### Challenge 3: Ensuring Accurate Loop Control
- **Issue**: Properly controlling the loop counter and ensuring loop termination.
- **Solution**: Used `bge` to compare the loop counter (`t2`) with the array length (`a1`), and jumped to `loop_end` when complete.

## Conclusion
This project implements a RISC-V assembly function `argmax` that scans an integer array to find the position of the first occurrence of its maximum value. The function ensures efficiency while adhering to RISC-V conventions.

# RISC-V Strided Dot Product Function

## Functionality
### `dot`
- **Purpose**: Computes the dot product of two arrays using the formula:
  \[
  \text{result} = \sum_{i=0}^{\text{element_count}-1} \text{arr0}[i \times \text{stride0}] \times \text{arr1}[i \times \text{stride1}]
  \]
- **Inputs**: 
  - `a0`: Pointer to the first array.
  - `a1`: Pointer to the second array.
  - `a2`: Number of elements to process.
  - `a3`: Stride for the first array.
  - `a4`: Stride for the second array.
- **Output**:
  - `a0`: Resulting dot product value.
- **Error Handling**:
  - Exits with code `36` if `element_count` is less than 1.
  - Exits with code `37` if any stride is less than 1.

### How It Works
1. **Initialization**:
   - Validates input arguments using conditional branches (`blt`).
   - Initializes the accumulator (`t0`) and the loop counter (`t1`).

2. **Array Element Access**:
   - Iteratively calculates the memory offsets for the current elements of `arr0` and `arr1` based on their strides.
   - Loads the values from memory using `lw`.

3. **Element Multiplication**:
   - Multiplies the two elements, handling potential sign adjustments to ensure accurate multiplication results without relying on hardware multiplication instructions.

4. **Accumulation**:
   - Adds the product of the current elements to the running total in `t0`.

5. **Loop Termination**:
   - Continues the loop until all elements have been processed (`t1 >= a2`).

6. **Error Handling**:
   - Ensures that the `element_count` and strides are positive; otherwise, exits with an appropriate error code.

## Challenges and Solutions
### Challenge 1: Strided Memory Access
- **Issue**: Correctly calculating the memory address for elements based on strides.
- **Solution**: Used loop-based arithmetic to compute the effective offset for both arrays, ensuring accurate indexing even with varying strides.

### Challenge 2: Multiplication Without Hardware Support
- **Issue**: Handling signed integer multiplication without direct hardware instructions.
- **Solution**: Implemented a manual multiplication loop, accounting for the signs of operands and adjusting the result appropriately.

### Challenge 3: Handling Signed Multiplication 
- **Issue**: When multiplying signed integers, the result's sign must align with multiplication rules. Using a manual addition-based approach can lead to incorrect calculations without proper handling of signs.
- **Solution**: By determining the signs of the input values, convert them to absolute values for computation, and apply the correct sign to the final result. The sign determination can be efficiently achieved using a simple XOR operation (^):

## Conclusion
This project implements a RISC-V assembly function `dot` to compute the dot product of two integer arrays with configurable strides. It handles error cases robustly, ensuring valid input preconditions.

# RISC-V Matrix Multiplication Implementation

## Functionality
### `matmul`
- **Purpose**: Computes the product of two matrices:
  \[
  D = M0 \times M1
  \]
  Where:
  - `M0` is a \((\text{rows0} \times \text{cols0})\) matrix.
  - `M1` is a \((\text{rows1} \times \text{cols1})\) matrix.
  - `D` is the resulting \((\text{rows0} \times \text{cols1})\) matrix.

- **Inputs**: 
  - `a0`: Pointer to the first matrix (`M0`).
  - `a1`: Number of rows in `M0`.
  - `a2`: Number of columns in `M0`.
  - `a3`: Pointer to the second matrix (`M1`).
  - `a4`: Number of rows in `M1`.
  - `a5`: Number of columns in `M1`.
  - `a6`: Pointer to the output matrix (`D`).

- **Output**: The resulting matrix is stored at the memory location pointed to by `a6`.

- **Error Handling**:
  - Ensures positive dimensions for all matrices.
  - Verifies that the number of columns in `M0` equals the number of rows in `M1` (required for multiplication).
  - Exits with code `38` if any validation check fails.

### How It Works
1. **Input Validation**:
   - Ensures that all matrix dimensions are positive.
   - Checks compatibility for multiplication using the condition \(\text{cols0} = \text{rows1}\).

2. **Outer Loop**:
   - Iterates over the rows of `M0`.

3. **Inner Loop**:
   - Iterates over the columns of `M1`.

4. **Dot Product Calculation**:
   - For each position \((i, j)\) in the result matrix, computes the dot product of the \(i\)-th row of `M0` and the \(j\)-th column of `M1` using the `dot` subroutine.
   - Writes the computed value to the corresponding position in `D`.

5. **Memory Management**:
   - Uses a stack frame to save and restore registers for nested subroutine calls.

6. **Error Handling**:
   - Jumps to the `error` label if validation checks fail, exiting the program with an error code.

## Challenges and Solutions
### Challenge 1: Efficient Memory Access
- **Issue**: Accessing specific rows and columns in memory for matrix elements.
- **Solution**: Calculated offsets dynamically using `slli` and pointer arithmetic to ensure correct access patterns.

### Challenge 2: Nested Loops and Register Usage
- **Issue**: Managing nested loops for iterating over rows and columns while avoiding register conflicts.
- **Solution**: Utilized stack-based register saving/restoring to preserve intermediate values across subroutine calls.

## Conclusion
This project implements a RISC-V assembly function `matmul` to perform matrix multiplication. It takes two input matrices, computes their product, and stores the result in a specified memory location. The implementation handles matrix validation and error scenarios gracefully, ensuring correct input dimensions for multiplication.

# RISC-V ReLU (Rectified Linear Unit) Implementation

## Functionality
### `relu`
- **Purpose**: Performs in-place ReLU activation on an array:
  \[
  x = \max(0, x) \quad \text{for each element } x \text{ in the array.}
  \]

- **Inputs**:
  - `a0`: Pointer to the integer array.
  - `a1`: Number of elements in the array.

- **Output**: The input array is modified directly, with all negative values replaced by zero.

- **Validation**:
  - Ensures that the array length (`a1`) is at least 1.
  - Exits with code `36` if validation fails.

### How It Works
1. **Validation**:
   - Ensures the array is non-empty by checking if `a1` (number of elements) is at least 1. If not, it exits with an error.

2. **Element-wise Processing**:
   - Iterates over each element of the array.
   - Compares the value of each element with `0`. If it is negative, it sets the element to `0`.

3. **In-place Modification**:
   - Uses the array pointer (`a0`) to directly modify the input array in memory.

4. **Loop**:
   - Uses a counter (`t1`) to track the current element and advances the pointer (`a0`) to the next array element.

## Challenges and Solutions
### Challenge 1: In-place Modification
- **Issue**: ReLU needs to modify the input array directly without using additional memory.
- **Solution**: The function processes elements in-place by iterating through the array and using memory operations (`lw` and `sw`) for updates.

### Challenge 2: Negative Value Handling
- **Issue**: Identifying and replacing only negative values efficiently.
- **Solution**: Used a branch instruction (`bge`) to skip modification for non-negative values, ensuring minimal performance overhead.

### Challenge 3: Loop Control
- **Issue**: Iterating over an array of unknown length and ensuring proper termination.
- **Solution**: Employed a counter (`t1`) and a loop condition (`bge`) to iterate until all elements are processed.

## Conclusion
The `relu` function implements the Rectified Linear Unit (ReLU) operation for an integer array in RISC-V assembly. This function applies the ReLU transformation element-wise, replacing all negative values in the array with zero.

# RISC-V Multiplication of read_matrix.s, write_matrix.s,and classify.s(Manual Implementation)

## Functionality
### Manual Multiplication (`mul_loop1`)
- **Purpose**: Computes the product of two integers (`t0` and `t1`) without relying on the `mul` instruction.
- **Algorithm**: Uses repeated addition to calculate the product:
  \[
  \text{product} = \sum_{i=1}^{t1} t0
  \]

- **Inputs**:
  - `t0`: Multiplicand (first number to multiply).
  - `t1`: Multiplier (number of times `t0` is added).

- **Output**:
  - `a0`: Result of the multiplication.

- **How It Works**:
  1. Initializes an accumulator (`t2`) to `0`.
  2. Repeatedly adds `t0` to `t2` for `t1` iterations.
  3. The loop decrements `t3` (a copy of `t1`) with each iteration until it reaches `0`.
  4. Stores the result in `a0`.

## Conclusion
This segment of code implements integer multiplication using an iterative addition loop, replacing the built-in `mul` instruction in RISC-V. This low-level implementation provides insight into how multiplication can be performed manually in assembly when hardware multiplication is unavailable or restricted.