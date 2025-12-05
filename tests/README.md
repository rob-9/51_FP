# Function Tests

This directory contains minimal test files for each implemented function.

## How to Run Tests

### 1. checkColors Test
```bash
# In MARS:
# 1. Open test_checkColors.asm
# 2. Assemble and run
# Expected output:
#   0x0000fa35 0x00000004  (valid colors)
#   0x0000ffff 0x000000ff  (invalid colors)
```

### 2. setCell Test
```bash
# In MARS:
# 1. Open test_setCell.asm  
# 2. Assemble and run
# Expected output (return codes):
#   0  (success - set cell [2,1] = '4')
#   0  (success - clear cell [3,3])
#   0  (success - change color only [2,1])
#   -1 (error - invalid row)
#   -1 (error - invalid value)
```

### 3. Visual Testing with MARS Sudoku Tool
For setCell visual verification:
1. Open test_setCell.asm in MARS
2. Go to Tools → ICS51 SudokuBoard
3. Assemble and run the test
4. Click "Connect to MIPS" in the Sudoku window
5. You should see:
   - Cell [2,1] shows '4' with bright green background
   - Cell [3,3] shows empty with white background
   - Cell [2,1] color changes to bright red on cyan

## Test Structure
Each test file includes:
- Minimal test cases covering success and error paths
- Clear expected outputs
- Simple integer printing for verification
- Proper function call setup (stack management for checkColors)

## Adding New Function Tests
When implementing new functions:
1. Create `test_[functionName].asm` in this directory
2. Include minimal success/failure test cases
3. Print return values for verification
4. Update this README with expected outputs