# **Turing machine simulator**

This repository contains an implementation of a Turing machine simulator, designed as a demonstration of computational concepts in the course **KIP/XTILO: Computability and Complexity**. The project includes scripts for encoding and decoding Turing machine states and transitions, running the Turing machine with predefined configurations, and executing unit tests to ensure its correctness.

**Key Feature**: This Turing machine can perform the addition of a finite number of binary integers on a single tape, separated by `#` symbols. 

---

## **Getting Started**

### **Prerequisites**
Ensure that you have the following installed:
- **R**: A working R interpreter.

---

### **Installation**

1. Clone this repository:
   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```
   Or download it locally.

2. Run the `__main__.R` script to execute the Turing machine:
   ```r
   source("__main__.R")
   ```

3. The script will automatically load the following components:
   - **State transitions**:
     ```r
     source("states_and_transitions.R")
     ```
   - **Turing machine logic**:
     ```r
     source("turing_machine.R")
     ```
   - **Unit tests**:
     ```r
     source("unit_tests.R")
     ```
   - **Encoder and decoder**:
     ```r
     source("encoder_and_decoder.R")
     ```

---

### **High-level summary**

This Turing machine operates as follows:

1. **Identify Two Integers**:
   - The machine scans the tape to locate two binary integers separated by a `#`.

2. **Perform Subtraction and Addition**:
   - The second binary integer is decremented by one in binary (subtraction).
   - The result is added to the first binary integer using binary addition with carry.

3. **Create Helper Symbol `c`**:
   - After performing the subtraction, the machine writes the helper symbol `c` to separate the first binary integer from the rest of the tape.
   - The `c` symbol acts as a temporary marker while the machine shifts the digits of the first binary integer toward the second integer.

4. **Shift the First Integer**:
   - The machine shifts the digits of the current first binary integer toward the second integer, from left to right.
   - The process continues until the two integers are separated by the helper symbol `c`.

5. **Replace Helper Symbol `c` with `#`**:
   - Once all digits of the first binary integer are shifted, the helper symbol `c` is replaced with `#`.
   - The process repeats, treating the two combined integers as the new "first" and "second" integers.

6. **Create Helper Symbol `b`**:
   - During the shifting process, the machine writes the helper symbol `b` to temporarily mark the boundary of the current first integer being shifted.
   - This symbol is replaced by `#` once the shifting is complete.

7. **Use of `h` for Last Two Integers**:
   - The helper symbol `h` is introduced only when the machine determines that only the last two binary integers remain on the tape.
   - These last two integers are summed up directly.

8. **Clean Up Intermediate Symbols**:
   - After completing the summation, the intermediate symbol `b` is replaced by `#`.
   - Any other helper symbols (`c` or `h`) are cleaned up.

9. **Halting Condition**:
   - The machine halts after the final summation of the last two integers and cleanup is complete.


---

### **Turing machine operation detailed description**

<p align="center">
    <img
        src = "https://raw.githubusercontent.com/LStepanek/turing_machine/refs/heads/main/turing_machine_flow_chart.png?token=GHSAT0AAAAAAC4RMRL6QDHICNUFHSFOAR7KZ4B5UZA"
        style = "height:900px;"
    >
</p>


1. **State: `move_right_to_first_end`**
   - The machine scans right through `0`s and `1`s in the first binary integer.
   - Upon encountering `#`, transitions to `move_right_to_second_end`.

2. **State: `move_right_to_second_end`**
   - The machine continues scanning right through the `0`s and `1`s of the second binary integer.
   - Upon encountering another `#`, transitions to `check_if_then_halt`.

3. **State: `check_if_then_halt`**
   - Determines whether it is processing the last two integers:
     - If a `0` or `1` is read, transitions to `go_back_and_write_hash`.
     - If a `#` is read, transitions to `go_back_and_write_halt`.

4. **State: `go_back_and_write_hash`**
   - Writes the helper symbol `c` to separate the first integer from the rest.
   - Moves left and transitions to `subtract_one_from_second`.

5. **State: `go_back_and_write_halt`**
   - Writes the helper symbol `h` to indicate the last two integers.
   - Moves left and transitions to `subtract_one_from_second`.

6. **State: `subtract_one_from_second`**
   - Decrements the second binary integer:
     - Writes `1` for `0`, moves left.
     - Writes `0` for `1`, transitions to `move_left_to_first_end`.
     - If `#` is encountered, transitions to `clean_up`.

7. **State: `move_left_to_first_end`**
   - Moves left through the first binary integer.
   - Upon encountering `#`, transitions to `add_one_to_first`.

8. **State: `add_one_to_first`**
   - Adds the carry from subtraction to the first binary integer:
     - Writes `1` for `0`, transitions to `move_right_to_first_end`.
     - Writes `0` for `1`, continues left.
     - Writes `1` for `#`, transitions to `move_right_to_first_end`.

9. **State: `clean_up`**
   - Removes intermediate symbols:
     - If `c` is read, transitions to `move_left_and_reach_digits`.
     - If `h` is read, transitions to `move_one_step_to_right_and_halt`.

10. **State: `move_left_and_reach_digits`**
    - Moves left through digits and `#`.
    - Upon encountering a `0` or `1`, transitions to `continue_to_leftmost_digit`.

11. **State: `continue_to_leftmost_digit`**
    - Moves left until it finds the leftmost digit of the current first integer.
    - Upon encountering `#`, transitions to `move_right_and_reach_c`.

12. **State: `move_right_and_reach_c`**
    - Moves right to locate the helper symbol `c`.
    - Upon finding `c`, transitions to `move_left_to_first_end_and_start_shifting`.

13. **State: `move_left_to_first_end_and_start_shifting`**
    - Begins shifting the first binary integer toward the second:
      - If `b` is read, transitions to `move_right_reach_c_and_replace_it_by_hash`.
      - If `0`, transitions to `move_right_and_shift_zero`.
      - If `1`, transitions to `move_right_and_shift_one`.

14. **State: `move_right_reach_c_and_replace_it_by_hash`**
    - Replaces `c` with `#` and transitions to `move_left_and_reach_leftmost_digit`.

15. **State: `move_left_and_reach_leftmost_digit`**
    - Moves left through digits and `#` to reach the leftmost digit of the next integer.
    - Upon encountering a `0` or `1`, transitions to `continue_to_leftmost_digit`.

16. **State: `move_right_and_shift_zero`**
    - Moves right, shifting a `0` to the second binary integer.
    - Transitions to `turn_left_and_shift_zero`.

17. **State: `move_right_and_shift_one`**
    - Moves right, shifting a `1` to the second binary integer.
    - Transitions to `turn_left_and_shift_one`.

18. **State: `turn_left_and_shift_zero`**
    - Moves left to return to the first integer.
    - Upon encountering `#`, transitions to `move_left_to_first_end_and_start_shifting`.

19. **State: `turn_left_and_shift_one`**
    - Moves left to return to the first integer.
    - Upon encountering `#`, transitions to `move_left_to_first_end_and_start_shifting`.

20. **State: `move_one_step_to_right_and_halt`**
    - Moves one step to the right after summing the last two integers.
    - Replaces `b` with `#` and transitions to `halt`.

21. **State: `halt`**
    - The machine halts, leaving the final sum on the tape.

---

