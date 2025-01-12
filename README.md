# **Turing machine simulator**

This repository contains an implementation of a Turing machine simulator, designed as a demonstration of computational concepts in the course [**KIP/XTILO Computability and Complexity**](https://sites.google.com/view/7tilo-xtilo). The project includes scripts for encoding and decoding Turing machine states and transitions, running the Turing machine with predefined configurations, and executing unit tests to ensure its correctness.

**Key Feature**: This Turing machine can perform the addition of a finite number of binary integers on a single tape, separated by `#` symbols. 


---

## Table of Contents

1. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
2. [High-level Summary](#high-level-summary)
3. [States](#states)
4. [Alphabet](#alphabet)
5. [Turing Machine Operations' Detailed Description](#turing-machine-operations-detailed-description)
6. [Pseudocode](#pseudocode)
7. [Unit Tests](#unit-tests)
8. [Step-by-step simulation](#step-by-step-simulation)
9. [Sources](#sources)

---


## **Getting Started**

### **Prerequisites**
Ensure that you have the following installed:
- **R**: A working R interpreter.

---

### **Installation**

1. Clone this repository:
   ```bash
   $ git clone git://github.com/LStepanek/turing_machine.git
   ```
   Or simply download it as a ZIP file and extract it locally.

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
   - **Step-by-step simulation**:
     ```r
     source("step_by_step_simulation.R")
     ```
   - **Encoder and decoder**:
     ```r
     source("encoder_and_decoder.R")
     ```

---

## **High-level summary**

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

## **States**

The Turing machine has the following 20 states:

1. `move_right_to_first_end`
2. `move_right_to_second_end`
3. `check_if_then_halt`
4. `go_back_and_write_hash`
5. `go_back_and_write_halt`
6. `subtract_one_from_second`
7. `move_left_to_first_end`
8. `add_one_to_first`
9. `clean_up`
10. `move_left_and_reach_digits`
11. `continue_to_leftmost_digit`
12. `move_right_and_reach_c`
13. `move_left_to_first_end_and_start_shifting`
14. `move_right_reach_c_and_replace_it_by_hash`
15. `move_left_and_reach_leftmost_digit`
16. `move_right_and_shift_zero`
17. `move_right_and_shift_one`
18. `turn_left_and_shift_zero`
19. `turn_left_and_shift_one`
20. `move_one_step_to_right_and_halt`

---

## **Alphabet**

The Turing machine uses the following symbols in its tape alphabet:

1. `0` – Binary digit (given by the tape)
2. `1` – Binary digit (given by the tape)
3. `#` – Separator between binary integers (given by the tape)
4. `c` – Helper symbol used during intermediate processing (introduced by the machine)
5. `b` – Helper symbol marking boundaries of shifted integers (introduced by the machine)
6. `h` – Helper symbol for the last two integers (introduced by the machine)

**Note**: The first three symbols (`0`, `1`, `#`) are part of the input tape, while the remaining symbols (`c`, `b`, `h`) are generated by the Turing machine during computation.

---

## **Turing machine operations' detailed description**

<p align="center">
    <img
        src = "https://github.com/LStepanek/turing_machine/blob/main/turing_machine_flow_chart.png?raw=true"
        style = "height:800px;"
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
## **Pseudocode**

<p align="center">
    <img
        src = "https://raw.githubusercontent.com/LStepanek/turing_machine/refs/heads/main/turing_machine_simplified_pseudocode.png?raw=true"
        style = "height:1000px;"
    >
</p>

Algorithm `TuringMachineAddition`

**Input:** A tape containing binary integers separated by `#` symbols.

**Output:** A tape with the final sum of all binary integers in binary form, padded by `#`.

1. **Initialize**
   - Set the current state to `move_right_to_first_end`.
   - Place the tape head at the first binary digit (`0` or `1`).

2. **Process Binary Integers**
   WHILE `current_state` ≠ "halt":
      SWITCH (`current_state`):
      
      **Case: `move_right_to_first_end`**
      - Move right through `0`s and `1`s until a `#` is encountered.
      - Transition to `move_right_to_second_end`.

      **Case: `move_right_to_second_end`**
      - Move right through the second binary integer.
      - IF another `#` is encountered:
        - Transition to `check_if_then_halt`.
      - ELSE IF `c` or `h` is encountered:
        - Transition to `subtract_one_from_second`.

      **Case: `check_if_then_halt`**
      - IF not the last two integers:
        - Write `c` and transition to `go_back_and_write_hash`.
      - ELSE:
        - Write `h` and transition to `go_back_and_write_halt`.

3. **Subtraction**
   **Case: `subtract_one_from_second`**
   - Decrement the second binary integer:
     - Replace `0` with `1`, move left.
     - Replace `1` with `0`, transition to `move_left_to_first_end`.
     - IF `#` is encountered, transition to `clean_up`.

4. **Addition**
   **Case: `move_left_to_first_end`**
   - Move left through the first binary integer.
   - Upon encountering `#`, transition to `add_one_to_first`.

   **Case: `add_one_to_first`**
   - Add binary digits with carry:
     - Replace `0` with `1`, transition to `move_right_to_first_end`.
     - Replace `1` with `0`, continue left.
     - Replace `#` with `1`, transition to `move_right_to_first_end`.

5. **Cleanup and Repeat**
   **Case: `clean_up`**
   - Replace intermediate symbols:
     - IF `c`, transition to `move_left_and_reach_digits`.
     - IF `h`, transition to `move_one_step_to_right_and_halt`.

6. **Final Shifting**
   **Case: `move_left_to_first_end_and_start_shifting`**
   - Shift digits of the first integer to the second:
     - IF `b`, transition to `move_right_reach_c_and_replace_it_by_hash`.

   **Case: `move_right_and_shift_zero`**
   - Shift a `0` and transition to `turn_left_and_shift_zero`.

   **Case: `move_right_and_shift_one`**
   - Shift a `1` and transition to `turn_left_and_shift_one`.

7. **Final Summation and Halt**
   **Case: `move_one_step_to_right_and_halt`**
   - Replace `b` with `#` and transition to `halt`.

8. **End**
   - The tape now contains the final sum of all integers.



---

## **Unit tests**

```r
================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 1 out of n = 100

numbers in decimal:
68
     = 68

numbers in binary:
1000100
     = 1000100

tape on input:
#####################################1000100####################################

the same tape on output:
#####################################1000100####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 2 out of n = 100

numbers in decimal:
79 + 70 + 6 + 32 + 8
     = 195

numbers in binary:
1001111 + 1000110 + 110 + 100000 + 1000
     = 11000011

tape on input:
#########################1001111#1000110#110#100000#1000########################

the same tape on output:
###########################################11000011#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 3 out of n = 100

numbers in decimal:
58 + 12 + 36 + 58 + 95
     = 259

numbers in binary:
111010 + 1100 + 100100 + 111010 + 1011111
     = 100000011

tape on input:
########################111010#1100#100100#111010#1011111#######################

the same tape on output:
########################################100000011###############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 4 out of n = 100

numbers in decimal:
75 + 51 + 3 + 71 + 44 + 58 + 51 + 56
     = 409

numbers in binary:
1001011 + 110011 + 11 + 1000111 + 101100 + 111010 + 110011 + 111000
     = 110011001

tape on input:
##############1001011#110011#11#1000111#101100#111010#110011#111000#############

the same tape on output:
###################################################110011001####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 5 out of n = 100

numbers in decimal:
57 + 79
     = 136

numbers in binary:
111001 + 1001111
     = 10001000

tape on input:
#################################111001#1001111#################################

the same tape on output:
###############################10001000#########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 6 out of n = 100

numbers in decimal:
10 + 45 + 78 + 56 + 100
     = 289

numbers in binary:
1010 + 101101 + 1001110 + 111000 + 1100100
     = 100100001

tape on input:
#######################1010#101101#1001110#111000#1100100#######################

the same tape on output:
########################################100100001###############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 7 out of n = 100

numbers in decimal:
83 + 31
     = 114

numbers in binary:
1010011 + 11111
     = 1110010

tape on input:
##################################1010011#11111#################################

the same tape on output:
##################################1110010#######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 8 out of n = 100

numbers in decimal:
52 + 55 + 98 + 79 + 12 + 42 + 1 + 93
     = 432

numbers in binary:
110100 + 110111 + 1100010 + 1001111 + 1100 + 101010 + 1 + 1011101
     = 110110000

tape on input:
###############110100#110111#1100010#1001111#1100#101010#1#1011101##############

the same tape on output:
#################################################110110000######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 9 out of n = 100

numbers in decimal:
53 + 6 + 59
     = 118

numbers in binary:
110101 + 110 + 111011
     = 1110110

tape on input:
################################110101#110#111011###############################

the same tape on output:
###################################1110110######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 10 out of n = 100

numbers in decimal:
9 + 74 + 76
     = 159

numbers in binary:
1001 + 1001010 + 1001100
     = 10011111

tape on input:
##############################1001#1001010#1001100##############################

the same tape on output:
##################################10011111######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 11 out of n = 100

numbers in decimal:
34 + 56
     = 90

numbers in binary:
100010 + 111000
     = 1011010

tape on input:
##################################100010#111000#################################

the same tape on output:
#################################1011010########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 12 out of n = 100

numbers in decimal:
90 + 80
     = 170

numbers in binary:
1011010 + 1010000
     = 10101010

tape on input:
#################################1011010#1010000################################

the same tape on output:
################################10101010########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 13 out of n = 100

numbers in decimal:
3 + 64 + 74 + 77 + 6 + 48 + 22 + 4
     = 298

numbers in binary:
11 + 1000000 + 1001010 + 1001101 + 110 + 110000 + 10110 + 100
     = 100101010

tape on input:
#################11#1000000#1001010#1001101#110#110000#10110#100################

the same tape on output:
###################################################100101010####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 14 out of n = 100

numbers in decimal:
73
     = 73

numbers in binary:
1001001
     = 1001001

tape on input:
#####################################1001001####################################

the same tape on output:
#####################################1001001####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 15 out of n = 100

numbers in decimal:
34 + 38 + 49 + 5 + 89
     = 215

numbers in binary:
100010 + 100110 + 110001 + 101 + 1011001
     = 11010111

tape on input:
########################100010#100110#110001#101#1011001########################

the same tape on output:
########################################11010111################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 16 out of n = 100

numbers in decimal:
59
     = 59

numbers in binary:
111011
     = 111011

tape on input:
#####################################111011#####################################

the same tape on output:
#####################################111011#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 17 out of n = 100

numbers in decimal:
97 + 94
     = 191

numbers in binary:
1100001 + 1011110
     = 10111111

tape on input:
#################################1100001#1011110################################

the same tape on output:
################################10111111########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 18 out of n = 100

numbers in decimal:
80 + 65
     = 145

numbers in binary:
1010000 + 1000001
     = 10010001

tape on input:
#################################1010000#1000001################################

the same tape on output:
################################10010001########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 19 out of n = 100

numbers in decimal:
54 + 3 + 5 + 82 + 57
     = 201

numbers in binary:
110110 + 11 + 101 + 1010010 + 111001
     = 11001001

tape on input:
##########################110110#11#101#1010010#111001##########################

the same tape on output:
#######################################11001001#################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 20 out of n = 100

numbers in decimal:
63 + 2 + 98 + 29 + 94 + 62
     = 348

numbers in binary:
111111 + 10 + 1100010 + 11101 + 1011110 + 111110
     = 101011100

tape on input:
#####################111111#10#1100010#11101#1011110#111110#####################

the same tape on output:
###########################################101011100############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 21 out of n = 100

numbers in decimal:
33 + 3 + 57 + 42 + 47 + 16 + 21
     = 219

numbers in binary:
100001 + 11 + 111001 + 101010 + 101111 + 10000 + 10101
     = 11011011

tape on input:
###################100001#11#111001#101010#101111#10000#10101###################

the same tape on output:
###############################################11011011#########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 22 out of n = 100

numbers in decimal:
9 + 88 + 74 + 94 + 44 + 59
     = 368

numbers in binary:
1001 + 1011000 + 1001010 + 1011110 + 101100 + 111011
     = 101110000

tape on input:
###################1001#1011000#1001010#1011110#101100#111011###################

the same tape on output:
#############################################101110000##########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 23 out of n = 100

numbers in decimal:
28 + 72 + 43 + 45 + 34
     = 222

numbers in binary:
11100 + 1001000 + 101011 + 101101 + 100010
     = 11011110

tape on input:
#######################11100#1001000#101011#101101#100010#######################

the same tape on output:
##########################################11011110##############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 24 out of n = 100

numbers in decimal:
19 + 72 + 87 + 34 + 35 + 29 + 10
     = 286

numbers in binary:
10011 + 1001000 + 1010111 + 100010 + 100011 + 11101 + 1010
     = 100011110

tape on input:
#################10011#1001000#1010111#100010#100011#11101#1010#################

the same tape on output:
#################################################100011110######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 25 out of n = 100

numbers in decimal:
93 + 24 + 60 + 89 + 49 + 72 + 26
     = 413

numbers in binary:
1011101 + 11000 + 111100 + 1011001 + 110001 + 1001000 + 11010
     = 110011101

tape on input:
################1011101#11000#111100#1011001#110001#1001000#11010###############

the same tape on output:
##################################################110011101#####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 26 out of n = 100

numbers in decimal:
28 + 95 + 72 + 43 + 51 + 41 + 71 + 86
     = 487

numbers in binary:
11100 + 1011111 + 1001000 + 101011 + 110011 + 101001 + 1000111 + 1010110
     = 111100111

tape on input:
###########11100#1011111#1001000#101011#110011#101001#1000111#1010110###########

the same tape on output:
####################################################111100111###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 27 out of n = 100

numbers in decimal:
54 + 73 + 83 + 16 + 33
     = 259

numbers in binary:
110110 + 1001001 + 1010011 + 10000 + 100001
     = 100000011

tape on input:
#######################110110#1001001#1010011#10000#100001######################

the same tape on output:
##########################################100000011#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 28 out of n = 100

numbers in decimal:
32
     = 32

numbers in binary:
100000
     = 100000

tape on input:
#####################################100000#####################################

the same tape on output:
#####################################100000#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 29 out of n = 100

numbers in decimal:
44 + 90 + 66 + 85 + 3
     = 288

numbers in binary:
101100 + 1011010 + 1000010 + 1010101 + 11
     = 100100000

tape on input:
########################101100#1011010#1000010#1010101#11#######################

the same tape on output:
#############################################100100000##########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 30 out of n = 100

numbers in decimal:
50 + 46
     = 96

numbers in binary:
110010 + 101110
     = 1100000

tape on input:
##################################110010#101110#################################

the same tape on output:
#################################1100000########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 31 out of n = 100

numbers in decimal:
49 + 75 + 40 + 90 + 64
     = 318

numbers in binary:
110001 + 1001011 + 101000 + 1011010 + 1000000
     = 100111110

tape on input:
######################110001#1001011#101000#1011010#1000000#####################

the same tape on output:
##########################################100111110#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 32 out of n = 100

numbers in decimal:
70 + 11 + 20 + 73 + 33 + 27 + 70
     = 304

numbers in binary:
1000110 + 1011 + 10100 + 1001001 + 100001 + 11011 + 1000110
     = 100110000

tape on input:
#################1000110#1011#10100#1001001#100001#11011#1000110################

the same tape on output:
###############################################100110000########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 33 out of n = 100

numbers in decimal:
8 + 86
     = 94

numbers in binary:
1000 + 1010110
     = 1011110

tape on input:
##################################1000#1010110##################################

the same tape on output:
###############################1011110##########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 34 out of n = 100

numbers in decimal:
33 + 9 + 10 + 50 + 8
     = 110

numbers in binary:
100001 + 1001 + 1010 + 110010 + 1000
     = 1101110

tape on input:
##########################100001#1001#1010#110010#1000##########################

the same tape on output:
##########################################1101110###############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 35 out of n = 100

numbers in decimal:
70 + 8
     = 78

numbers in binary:
1000110 + 1000
     = 1001110

tape on input:
##################################1000110#1000##################################

the same tape on output:
##################################1001110#######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 36 out of n = 100

numbers in decimal:
99 + 36 + 25 + 23 + 74
     = 257

numbers in binary:
1100011 + 100100 + 11001 + 10111 + 1001010
     = 100000001

tape on input:
#######################1100011#100100#11001#10111#1001010#######################

the same tape on output:
########################################100000001###############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 37 out of n = 100

numbers in decimal:
47 + 24 + 50 + 3 + 36 + 41
     = 201

numbers in binary:
101111 + 11000 + 110010 + 11 + 100100 + 101001
     = 11001001

tape on input:
######################101111#11000#110010#11#100100#101001######################

the same tape on output:
###########################################11001001#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 38 out of n = 100

numbers in decimal:
49
     = 49

numbers in binary:
110001
     = 110001

tape on input:
#####################################110001#####################################

the same tape on output:
#####################################110001#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 39 out of n = 100

numbers in decimal:
83
     = 83

numbers in binary:
1010011
     = 1010011

tape on input:
#####################################1010011####################################

the same tape on output:
#####################################1010011####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 40 out of n = 100

numbers in decimal:
44 + 46 + 18 + 27 + 66 + 56 + 45 + 30
     = 332

numbers in binary:
101100 + 101110 + 10010 + 11011 + 1000010 + 111000 + 101101 + 11110
     = 101001100

tape on input:
##############101100#101110#10010#11011#1000010#111000#101101#11110#############

the same tape on output:
####################################################101001100###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 41 out of n = 100

numbers in decimal:
35 + 5 + 96 + 72 + 58 + 29 + 70 + 22
     = 387

numbers in binary:
100011 + 101 + 1100000 + 1001000 + 111010 + 11101 + 1000110 + 10110
     = 110000011

tape on input:
##############100011#101#1100000#1001000#111010#11101#1000110#10110#############

the same tape on output:
####################################################110000011###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 42 out of n = 100

numbers in decimal:
65
     = 65

numbers in binary:
1000001
     = 1000001

tape on input:
#####################################1000001####################################

the same tape on output:
#####################################1000001####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 43 out of n = 100

numbers in decimal:
40 + 68 + 21 + 66
     = 195

numbers in binary:
101000 + 1000100 + 10101 + 1000010
     = 11000011

tape on input:
##########################101000#1000100#10101#1000010##########################

the same tape on output:
######################################11000011##################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 44 out of n = 100

numbers in decimal:
33
     = 33

numbers in binary:
100001
     = 100001

tape on input:
#####################################100001#####################################

the same tape on output:
#####################################100001#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 45 out of n = 100

numbers in decimal:
75 + 46 + 96 + 39 + 58
     = 314

numbers in binary:
1001011 + 101110 + 1100000 + 100111 + 111010
     = 100111010

tape on input:
######################1001011#101110#1100000#100111#111010######################

the same tape on output:
##########################################100111010#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 46 out of n = 100

numbers in decimal:
78 + 1
     = 79

numbers in binary:
1001110 + 1
     = 1001111

tape on input:
####################################1001110#1###################################

the same tape on output:
####################################1001111#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 47 out of n = 100

numbers in decimal:
57 + 15 + 84
     = 156

numbers in binary:
111001 + 1111 + 1010100
     = 10011100

tape on input:
###############################111001#1111#1010100##############################

the same tape on output:
##################################10011100######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 48 out of n = 100

numbers in decimal:
42 + 51 + 25 + 73 + 37
     = 228

numbers in binary:
101010 + 110011 + 11001 + 1001001 + 100101
     = 11100100

tape on input:
#######################101010#110011#11001#1001001#100101#######################

the same tape on output:
##########################################11100100##############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 49 out of n = 100

numbers in decimal:
19 + 89 + 59 + 32 + 26 + 75 + 47
     = 347

numbers in binary:
10011 + 1011001 + 111011 + 100000 + 11010 + 1001011 + 101111
     = 101011011

tape on input:
################10011#1011001#111011#100000#11010#1001011#101111################

the same tape on output:
################################################101011011#######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 50 out of n = 100

numbers in decimal:
11 + 52 + 95 + 95 + 46 + 67 + 8 + 16
     = 390

numbers in binary:
1011 + 110100 + 1011111 + 1011111 + 101110 + 1000011 + 1000 + 10000
     = 110000110

tape on input:
##############1011#110100#1011111#1011111#101110#1000011#1000#10000#############

the same tape on output:
####################################################110000110###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 51 out of n = 100

numbers in decimal:
83 + 93 + 46 + 29 + 91 + 21 + 66
     = 429

numbers in binary:
1010011 + 1011101 + 101110 + 11101 + 1011011 + 10101 + 1000010
     = 110101101

tape on input:
###############1010011#1011101#101110#11101#1011011#10101#1000010###############

the same tape on output:
################################################110101101#######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 52 out of n = 100

numbers in decimal:
82 + 51 + 83
     = 216

numbers in binary:
1010010 + 110011 + 1010011
     = 11011000

tape on input:
#############################1010010#110011#1010011#############################

the same tape on output:
###################################11011000#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 53 out of n = 100

numbers in decimal:
67 + 44 + 72 + 41 + 88 + 45
     = 357

numbers in binary:
1000011 + 101100 + 1001000 + 101001 + 1011000 + 101101
     = 101100101

tape on input:
##################1000011#101100#1001000#101001#1011000#101101##################

the same tape on output:
##############################################101100101#########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 54 out of n = 100

numbers in decimal:
95 + 7 + 94 + 18 + 35 + 13 + 86 + 57
     = 405

numbers in binary:
1011111 + 111 + 1011110 + 10010 + 100011 + 1101 + 1010110 + 111001
     = 110010101

tape on input:
##############1011111#111#1011110#10010#100011#1101#1010110#111001##############

the same tape on output:
##################################################110010101#####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 55 out of n = 100

numbers in decimal:
90 + 35 + 1 + 44 + 76 + 50
     = 296

numbers in binary:
1011010 + 100011 + 1 + 101100 + 1001100 + 110010
     = 100101000

tape on input:
#####################1011010#100011#1#101100#1001100#110010#####################

the same tape on output:
###########################################100101000############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 56 out of n = 100

numbers in decimal:
32
     = 32

numbers in binary:
100000
     = 100000

tape on input:
#####################################100000#####################################

the same tape on output:
#####################################100000#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 57 out of n = 100

numbers in decimal:
81 + 100
     = 181

numbers in binary:
1010001 + 1100100
     = 10110101

tape on input:
#################################1010001#1100100################################

the same tape on output:
################################10110101########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 58 out of n = 100

numbers in decimal:
29 + 22 + 66
     = 117

numbers in binary:
11101 + 10110 + 1000010
     = 1110101

tape on input:
###############################11101#10110#1000010##############################

the same tape on output:
###################################1110101######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 59 out of n = 100

numbers in decimal:
89 + 39 + 85
     = 213

numbers in binary:
1011001 + 100111 + 1010101
     = 11010101

tape on input:
#############################1011001#100111#1010101#############################

the same tape on output:
###################################11010101#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 60 out of n = 100

numbers in decimal:
80 + 2 + 37
     = 119

numbers in binary:
1010000 + 10 + 100101
     = 1110111

tape on input:
################################1010000#10#100101###############################

the same tape on output:
###################################1110111######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 61 out of n = 100

numbers in decimal:
71 + 23 + 42 + 20
     = 156

numbers in binary:
1000111 + 10111 + 101010 + 10100
     = 10011100

tape on input:
###########################1000111#10111#101010#10100###########################

the same tape on output:
#######################################10011100#################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 62 out of n = 100

numbers in decimal:
22 + 43 + 69 + 47
     = 181

numbers in binary:
10110 + 101011 + 1000101 + 101111
     = 10110101

tape on input:
###########################10110#101011#1000101#101111##########################

the same tape on output:
#######################################10110101#################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 63 out of n = 100

numbers in decimal:
42 + 81 + 5
     = 128

numbers in binary:
101010 + 1010001 + 101
     = 10000000

tape on input:
###############################101010#1010001#101###############################

the same tape on output:
#####################################10000000###################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 64 out of n = 100

numbers in decimal:
68 + 27 + 69 + 1 + 85 + 54 + 68 + 13
     = 385

numbers in binary:
1000100 + 11011 + 1000101 + 1 + 1010101 + 110110 + 1000100 + 1101
     = 110000001

tape on input:
###############1000100#11011#1000101#1#1010101#110110#1000100#1101##############

the same tape on output:
####################################################110000001###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 65 out of n = 100

numbers in decimal:
35 + 47 + 24 + 95 + 2 + 86
     = 289

numbers in binary:
100011 + 101111 + 11000 + 1011111 + 10 + 1010110
     = 100100001

tape on input:
#####################100011#101111#11000#1011111#10#1010110#####################

the same tape on output:
##########################################100100001#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 66 out of n = 100

numbers in decimal:
68 + 26 + 29 + 47 + 95
     = 265

numbers in binary:
1000100 + 11010 + 11101 + 101111 + 1011111
     = 100001001

tape on input:
#######################1000100#11010#11101#101111#1011111#######################

the same tape on output:
########################################100001001###############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 67 out of n = 100

numbers in decimal:
43 + 84 + 97 + 78 + 71 + 33 + 94
     = 500

numbers in binary:
101011 + 1010100 + 1100001 + 1001110 + 1000111 + 100001 + 1011110
     = 111110100

tape on input:
##############101011#1010100#1100001#1001110#1000111#100001#1011110#############

the same tape on output:
##################################################111110100#####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 68 out of n = 100

numbers in decimal:
69 + 5 + 19 + 71
     = 164

numbers in binary:
1000101 + 101 + 10011 + 1000111
     = 10100100

tape on input:
############################1000101#101#10011#1000111###########################

the same tape on output:
#####################################10100100###################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 69 out of n = 100

numbers in decimal:
81 + 91 + 2 + 77 + 39 + 39 + 6 + 93
     = 428

numbers in binary:
1010001 + 1011011 + 10 + 1001101 + 100111 + 100111 + 110 + 1011101
     = 110101100

tape on input:
##############1010001#1011011#10#1001101#100111#100111#110#1011101##############

the same tape on output:
#################################################110101100######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 70 out of n = 100

numbers in decimal:
70 + 61 + 24
     = 155

numbers in binary:
1000110 + 111101 + 11000
     = 10011011

tape on input:
##############################1000110#111101#11000##############################

the same tape on output:
####################################10011011####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 71 out of n = 100

numbers in decimal:
28 + 79 + 48
     = 155

numbers in binary:
11100 + 1001111 + 110000
     = 10011011

tape on input:
##############################11100#1001111#110000##############################

the same tape on output:
###################################10011011#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 72 out of n = 100

numbers in decimal:
13 + 3 + 55 + 5 + 26
     = 102

numbers in binary:
1101 + 11 + 110111 + 101 + 11010
     = 1100110

tape on input:
############################1101#11#110111#101#11010############################

the same tape on output:
#######################################1100110##################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 73 out of n = 100

numbers in decimal:
71 + 88 + 17 + 47 + 7
     = 230

numbers in binary:
1000111 + 1011000 + 10001 + 101111 + 111
     = 11100110

tape on input:
########################1000111#1011000#10001#101111#111########################

the same tape on output:
############################################11100110############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 74 out of n = 100

numbers in decimal:
98 + 47
     = 145

numbers in binary:
1100010 + 101111
     = 10010001

tape on input:
#################################1100010#101111#################################

the same tape on output:
################################10010001########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 75 out of n = 100

numbers in decimal:
40 + 25 + 21 + 75 + 30 + 89 + 80 + 56
     = 416

numbers in binary:
101000 + 11001 + 10101 + 1001011 + 11110 + 1011001 + 1010000 + 111000
     = 110100000

tape on input:
#############101000#11001#10101#1001011#11110#1011001#1010000#111000############

the same tape on output:
####################################################110100000###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 76 out of n = 100

numbers in decimal:
1 + 28 + 50 + 74 + 16
     = 169

numbers in binary:
1 + 11100 + 110010 + 1001010 + 10000
     = 10101001

tape on input:
##########################1#11100#110010#1001010#10000##########################

the same tape on output:
########################################10101001################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 77 out of n = 100

numbers in decimal:
45 + 69
     = 114

numbers in binary:
101101 + 1000101
     = 1110010

tape on input:
#################################101101#1000101#################################

the same tape on output:
################################1110010#########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 78 out of n = 100

numbers in decimal:
78 + 20 + 79 + 92 + 8 + 34 + 86
     = 397

numbers in binary:
1001110 + 10100 + 1001111 + 1011100 + 1000 + 100010 + 1010110
     = 110001101

tape on input:
################1001110#10100#1001111#1011100#1000#100010#1010110###############

the same tape on output:
################################################110001101#######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 79 out of n = 100

numbers in decimal:
63 + 3 + 24 + 55 + 22 + 3
     = 170

numbers in binary:
111111 + 11 + 11000 + 110111 + 10110 + 11
     = 10101010

tape on input:
#########################111111#11#11000#110111#10110#11########################

the same tape on output:
#############################################10101010###########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 80 out of n = 100

numbers in decimal:
43 + 31 + 65
     = 139

numbers in binary:
101011 + 11111 + 1000001
     = 10001011

tape on input:
##############################101011#11111#1000001##############################

the same tape on output:
##################################10001011######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 81 out of n = 100

numbers in decimal:
99 + 25 + 86 + 12
     = 222

numbers in binary:
1100011 + 11001 + 1010110 + 1100
     = 11011110

tape on input:
###########################1100011#11001#1010110#1100###########################

the same tape on output:
########################################11011110################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 82 out of n = 100

numbers in decimal:
3 + 99 + 91 + 14 + 14 + 43 + 52 + 40
     = 356

numbers in binary:
11 + 1100011 + 1011011 + 1110 + 1110 + 101011 + 110100 + 101000
     = 101100100

tape on input:
################11#1100011#1011011#1110#1110#101011#110100#101000###############

the same tape on output:
#################################################101100100######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 83 out of n = 100

numbers in decimal:
26
     = 26

numbers in binary:
11010
     = 11010

tape on input:
######################################11010#####################################

the same tape on output:
######################################11010#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 84 out of n = 100

numbers in decimal:
19 + 22 + 89 + 54 + 12 + 85
     = 281

numbers in binary:
10011 + 10110 + 1011001 + 110110 + 1100 + 1010101
     = 100011001

tape on input:
#####################10011#10110#1011001#110110#1100#1010101####################

the same tape on output:
###########################################100011001############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 85 out of n = 100

numbers in decimal:
19
     = 19

numbers in binary:
10011
     = 10011

tape on input:
######################################10011#####################################

the same tape on output:
######################################10011#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 86 out of n = 100

numbers in decimal:
29 + 1 + 29
     = 59

numbers in binary:
11101 + 1 + 11101
     = 111011

tape on input:
##################################11101#1#11101#################################

the same tape on output:
###################################111011#######################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 87 out of n = 100

numbers in decimal:
26 + 95 + 16 + 87 + 75 + 27
     = 326

numbers in binary:
11010 + 1011111 + 10000 + 1010111 + 1001011 + 11011
     = 101000110

tape on input:
####################11010#1011111#10000#1010111#1001011#11011###################

the same tape on output:
##############################################101000110#########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 88 out of n = 100

numbers in decimal:
77 + 54 + 19 + 98 + 81 + 29 + 89
     = 447

numbers in binary:
1001101 + 110110 + 10011 + 1100010 + 1010001 + 11101 + 1011001
     = 110111111

tape on input:
###############1001101#110110#10011#1100010#1010001#11101#1011001###############

the same tape on output:
################################################110111111#######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 89 out of n = 100

numbers in decimal:
87 + 52 + 31 + 71 + 15
     = 256

numbers in binary:
1010111 + 110100 + 11111 + 1000111 + 1111
     = 100000000

tape on input:
########################1010111#110100#11111#1000111#1111#######################

the same tape on output:
###########################################100000000############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 90 out of n = 100

numbers in decimal:
20 + 34 + 58 + 55 + 81 + 79 + 69 + 82
     = 478

numbers in binary:
10100 + 100010 + 111010 + 110111 + 1010001 + 1001111 + 1000101 + 1010010
     = 111011110

tape on input:
###########10100#100010#111010#110111#1010001#1001111#1000101#1010010###########

the same tape on output:
####################################################111011110###################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 91 out of n = 100

numbers in decimal:
16 + 51 + 6 + 40 + 52
     = 165

numbers in binary:
10000 + 110011 + 110 + 101000 + 110100
     = 10100101

tape on input:
#########################10000#110011#110#101000#110100#########################

the same tape on output:
########################################10100101################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 92 out of n = 100

numbers in decimal:
66 + 55
     = 121

numbers in binary:
1000010 + 110111
     = 1111001

tape on input:
#################################1000010#110111#################################

the same tape on output:
#################################1111001########################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 93 out of n = 100

numbers in decimal:
45
     = 45

numbers in binary:
101101
     = 101101

tape on input:
#####################################101101#####################################

the same tape on output:
#####################################101101#####################################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 94 out of n = 100

numbers in decimal:
66 + 44 + 45 + 71 + 20 + 23 + 22 + 36
     = 327

numbers in binary:
1000010 + 101100 + 101101 + 1000111 + 10100 + 10111 + 10110 + 100100
     = 101000111

tape on input:
#############1000010#101100#101101#1000111#10100#10111#10110#100100#############

the same tape on output:
###################################################101000111####################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 95 out of n = 100

numbers in decimal:
24 + 9 + 40 + 28 + 67 + 81 + 81
     = 330

numbers in binary:
11000 + 1001 + 101000 + 11100 + 1000011 + 1010001 + 1010001
     = 101001010

tape on input:
#################11000#1001#101000#11100#1000011#1010001#1010001################

the same tape on output:
###############################################101001010########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 96 out of n = 100

numbers in decimal:
1 + 40 + 47 + 63 + 13 + 57 + 60
     = 281

numbers in binary:
1 + 101000 + 101111 + 111111 + 1101 + 111001 + 111100
     = 100011001

tape on input:
####################1#101000#101111#111111#1101#111001#111100###################

the same tape on output:
#############################################100011001##########################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 97 out of n = 100

numbers in decimal:
25 + 8 + 93 + 1 + 38 + 65 + 29 + 57
     = 316

numbers in binary:
11001 + 1000 + 1011101 + 1 + 100110 + 1000001 + 11101 + 111001
     = 100111100

tape on input:
################11001#1000#1011101#1#100110#1000001#11101#111001################

the same tape on output:
################################################100111100#######################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 98 out of n = 100

numbers in decimal:
34 + 29 + 6 + 93 + 15 + 77
     = 254

numbers in binary:
100010 + 11101 + 110 + 1011101 + 1111 + 1001101
     = 11111110

tape on input:
######################100010#11101#110#1011101#1111#1001101#####################

the same tape on output:
###########################################11111110#############################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 99 out of n = 100

numbers in decimal:
33 + 44 + 22 + 99 + 62 + 98 + 32 + 13
     = 403

numbers in binary:
100001 + 101100 + 10110 + 1100011 + 111110 + 1100010 + 100000 + 1101
     = 110010011

tape on input:
#############100001#101100#10110#1100011#111110#1100010#100000#1101#############

the same tape on output:
#####################################################110010011##################

status: correct ✓


================================================================================
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
================================================================================

unit test i = 100 out of n = 100

numbers in decimal:
89 + 78
     = 167

numbers in binary:
1011001 + 1001110
     = 10100111

tape on input:
#################################1011001#1001110################################

the same tape on output:
################################10100111########################################

status: correct ✓

   
```



---

## **Step-by-step simulation**

The script `step_by_step_simulation.R` uses the `addingTuringMachineStepByStep()` function to simulate the Turing machine's step-by-step analysis of the following input tape,

`###################################101#10#110###################################`.

This simulation demonstrates the Turing machine's ability to process and add binary integers while displaying each computational step in the console. The function prints the following details to the console for each step:
 - The current step of the program and current state of the Turing machine.
 - The position of the tape head, indicated by a line of underscores (`_`) with a `v` symbol directly above the current position of the head.
 - The current contents of the tape, showing how it evolves during computation.

```text
step : 1
state: move_right_to_first_end
___________________________________v____________________________________________
###################################101#10#110###################################

step : 2
state: move_right_to_first_end
____________________________________v___________________________________________
###################################101#10#110###################################

step : 3
state: move_right_to_first_end
_____________________________________v__________________________________________
###################################101#10#110###################################

step : 4
state: move_right_to_first_end
______________________________________v_________________________________________
###################################101#10#110###################################

step : 5
state: move_right_to_second_end
_______________________________________v________________________________________
###################################101#10#110###################################

step : 6
state: move_right_to_second_end
________________________________________v_______________________________________
###################################101#10#110###################################

step : 7
state: move_right_to_second_end
_________________________________________v______________________________________
###################################101#10#110###################################

step : 8
state: check_if_then_halt
__________________________________________v_____________________________________
###################################101#10#110###################################

step : 9
state: go_back_and_write_hash
_________________________________________v______________________________________
###################################101#10#110###################################

step : 10
state: subtract_one_from_second
________________________________________v_______________________________________
###################################101#10c110###################################

step : 11
state: subtract_one_from_second
_______________________________________v________________________________________
###################################101#11c110###################################

step : 12
state: move_left_to_first_end
______________________________________v_________________________________________
###################################101#01c110###################################

step : 13
state: add_one_to_first
_____________________________________v__________________________________________
###################################101#01c110###################################

step : 14
state: add_one_to_first
____________________________________v___________________________________________
###################################100#01c110###################################

step : 15
state: move_right_to_first_end
_____________________________________v__________________________________________
###################################110#01c110###################################

step : 16
state: move_right_to_first_end
______________________________________v_________________________________________
###################################110#01c110###################################

step : 17
state: move_right_to_second_end
_______________________________________v________________________________________
###################################110#01c110###################################

step : 18
state: move_right_to_second_end
________________________________________v_______________________________________
###################################110#01c110###################################

step : 19
state: move_right_to_second_end
_________________________________________v______________________________________
###################################110#01c110###################################

step : 20
state: subtract_one_from_second
________________________________________v_______________________________________
###################################110#01c110###################################

step : 21
state: move_left_to_first_end
_______________________________________v________________________________________
###################################110#00c110###################################

step : 22
state: move_left_to_first_end
______________________________________v_________________________________________
###################################110#00c110###################################

step : 23
state: add_one_to_first
_____________________________________v__________________________________________
###################################110#00c110###################################

step : 24
state: move_right_to_first_end
______________________________________v_________________________________________
###################################111#00c110###################################

step : 25
state: move_right_to_second_end
_______________________________________v________________________________________
###################################111#00c110###################################

step : 26
state: move_right_to_second_end
________________________________________v_______________________________________
###################################111#00c110###################################

step : 27
state: move_right_to_second_end
_________________________________________v______________________________________
###################################111#00c110###################################

step : 28
state: subtract_one_from_second
________________________________________v_______________________________________
###################################111#00c110###################################

step : 29
state: subtract_one_from_second
_______________________________________v________________________________________
###################################111#01c110###################################

step : 30
state: subtract_one_from_second
______________________________________v_________________________________________
###################################111#11c110###################################

step : 31
state: clean_up
_______________________________________v________________________________________
###################################111#11c110###################################

step : 32
state: clean_up
________________________________________v_______________________________________
###################################111##1c110###################################

step : 33
state: clean_up
_________________________________________v______________________________________
###################################111###c110###################################

step : 34
state: move_left_and_reach_digits
________________________________________v_______________________________________
###################################111###c110###################################

step : 35
state: move_left_and_reach_digits
_______________________________________v________________________________________
###################################111###c110###################################

step : 36
state: move_left_and_reach_digits
______________________________________v_________________________________________
###################################111###c110###################################

step : 37
state: move_left_and_reach_digits
_____________________________________v__________________________________________
###################################111###c110###################################

step : 38
state: continue_to_leftmost_digit
____________________________________v___________________________________________
###################################111###c110###################################

step : 39
state: continue_to_leftmost_digit
___________________________________v____________________________________________
###################################111###c110###################################

step : 40
state: continue_to_leftmost_digit
__________________________________v_____________________________________________
###################################111###c110###################################

step : 41
state: move_right_and_reach_c
___________________________________v____________________________________________
##################################b111###c110###################################

step : 42
state: move_right_and_reach_c
____________________________________v___________________________________________
##################################b111###c110###################################

step : 43
state: move_right_and_reach_c
_____________________________________v__________________________________________
##################################b111###c110###################################

step : 44
state: move_right_and_reach_c
______________________________________v_________________________________________
##################################b111###c110###################################

step : 45
state: move_right_and_reach_c
_______________________________________v________________________________________
##################################b111###c110###################################

step : 46
state: move_right_and_reach_c
________________________________________v_______________________________________
##################################b111###c110###################################

step : 47
state: move_right_and_reach_c
_________________________________________v______________________________________
##################################b111###c110###################################

step : 48
state: move_left_to_first_end_and_start_shifting
________________________________________v_______________________________________
##################################b111###c110###################################

step : 49
state: move_left_to_first_end_and_start_shifting
_______________________________________v________________________________________
##################################b111###c110###################################

step : 50
state: move_left_to_first_end_and_start_shifting
______________________________________v_________________________________________
##################################b111###c110###################################

step : 51
state: move_left_to_first_end_and_start_shifting
_____________________________________v__________________________________________
##################################b111###c110###################################

step : 52
state: move_right_and_shift_one
______________________________________v_________________________________________
##################################b11####c110###################################

step : 53
state: move_right_and_shift_one
_______________________________________v________________________________________
##################################b11####c110###################################

step : 54
state: move_right_and_shift_one
________________________________________v_______________________________________
##################################b11####c110###################################

step : 55
state: move_right_and_shift_one
_________________________________________v______________________________________
##################################b11####c110###################################

step : 56
state: turn_left_and_shift_one
________________________________________v_______________________________________
##################################b11####c110###################################

step : 57
state: move_left_to_first_end_and_start_shifting
_______________________________________v________________________________________
##################################b11###1c110###################################

step : 58
state: move_left_to_first_end_and_start_shifting
______________________________________v_________________________________________
##################################b11###1c110###################################

step : 59
state: move_left_to_first_end_and_start_shifting
_____________________________________v__________________________________________
##################################b11###1c110###################################

step : 60
state: move_left_to_first_end_and_start_shifting
____________________________________v___________________________________________
##################################b11###1c110###################################

step : 61
state: move_right_and_shift_one
_____________________________________v__________________________________________
##################################b1####1c110###################################

step : 62
state: move_right_and_shift_one
______________________________________v_________________________________________
##################################b1####1c110###################################

step : 63
state: move_right_and_shift_one
_______________________________________v________________________________________
##################################b1####1c110###################################

step : 64
state: move_right_and_shift_one
________________________________________v_______________________________________
##################################b1####1c110###################################

step : 65
state: turn_left_and_shift_one
_______________________________________v________________________________________
##################################b1####1c110###################################

step : 66
state: move_left_to_first_end_and_start_shifting
______________________________________v_________________________________________
##################################b1###11c110###################################

step : 67
state: move_left_to_first_end_and_start_shifting
_____________________________________v__________________________________________
##################################b1###11c110###################################

step : 68
state: move_left_to_first_end_and_start_shifting
____________________________________v___________________________________________
##################################b1###11c110###################################

step : 69
state: move_left_to_first_end_and_start_shifting
___________________________________v____________________________________________
##################################b1###11c110###################################

step : 70
state: move_right_and_shift_one
____________________________________v___________________________________________
##################################b####11c110###################################

step : 71
state: move_right_and_shift_one
_____________________________________v__________________________________________
##################################b####11c110###################################

step : 72
state: move_right_and_shift_one
______________________________________v_________________________________________
##################################b####11c110###################################

step : 73
state: move_right_and_shift_one
_______________________________________v________________________________________
##################################b####11c110###################################

step : 74
state: turn_left_and_shift_one
______________________________________v_________________________________________
##################################b####11c110###################################

step : 75
state: move_left_to_first_end_and_start_shifting
_____________________________________v__________________________________________
##################################b###111c110###################################

step : 76
state: move_left_to_first_end_and_start_shifting
____________________________________v___________________________________________
##################################b###111c110###################################

step : 77
state: move_left_to_first_end_and_start_shifting
___________________________________v____________________________________________
##################################b###111c110###################################

step : 78
state: move_left_to_first_end_and_start_shifting
__________________________________v_____________________________________________
##################################b###111c110###################################

step : 79
state: move_right_reach_c_and_replace_it_by_hash
___________________________________v____________________________________________
######################################111c110###################################

step : 80
state: move_right_reach_c_and_replace_it_by_hash
____________________________________v___________________________________________
######################################111c110###################################

step : 81
state: move_right_reach_c_and_replace_it_by_hash
_____________________________________v__________________________________________
######################################111c110###################################

step : 82
state: move_right_reach_c_and_replace_it_by_hash
______________________________________v_________________________________________
######################################111c110###################################

step : 83
state: move_right_reach_c_and_replace_it_by_hash
_______________________________________v________________________________________
######################################111c110###################################

step : 84
state: move_right_reach_c_and_replace_it_by_hash
________________________________________v_______________________________________
######################################111c110###################################

step : 85
state: move_right_reach_c_and_replace_it_by_hash
_________________________________________v______________________________________
######################################111c110###################################

step : 86
state: move_left_and_reach_leftmost_digit
________________________________________v_______________________________________
######################################111#110###################################

step : 87
state: move_left_and_reach_leftmost_digit
_______________________________________v________________________________________
######################################111#110###################################

step : 88
state: move_left_and_reach_leftmost_digit
______________________________________v_________________________________________
######################################111#110###################################

step : 89
state: move_left_and_reach_leftmost_digit
_____________________________________v__________________________________________
######################################111#110###################################

step : 90
state: move_right_to_first_end
______________________________________v_________________________________________
######################################111#110###################################

step : 91
state: move_right_to_first_end
_______________________________________v________________________________________
######################################111#110###################################

step : 92
state: move_right_to_first_end
________________________________________v_______________________________________
######################################111#110###################################

step : 93
state: move_right_to_first_end
_________________________________________v______________________________________
######################################111#110###################################

step : 94
state: move_right_to_second_end
__________________________________________v_____________________________________
######################################111#110###################################

step : 95
state: move_right_to_second_end
___________________________________________v____________________________________
######################################111#110###################################

step : 96
state: move_right_to_second_end
____________________________________________v___________________________________
######################################111#110###################################

step : 97
state: move_right_to_second_end
_____________________________________________v__________________________________
######################################111#110###################################

step : 98
state: check_if_then_halt
______________________________________________v_________________________________
######################################111#110###################################

step : 99
state: go_back_and_write_halt
_____________________________________________v__________________________________
######################################111#110###################################

step : 100
state: subtract_one_from_second
____________________________________________v___________________________________
######################################111#110h##################################

step : 101
state: subtract_one_from_second
___________________________________________v____________________________________
######################################111#111h##################################

step : 102
state: move_left_to_first_end
__________________________________________v_____________________________________
######################################111#101h##################################

step : 103
state: move_left_to_first_end
_________________________________________v______________________________________
######################################111#101h##################################

step : 104
state: add_one_to_first
________________________________________v_______________________________________
######################################111#101h##################################

step : 105
state: add_one_to_first
_______________________________________v________________________________________
######################################110#101h##################################

step : 106
state: add_one_to_first
______________________________________v_________________________________________
######################################100#101h##################################

step : 107
state: add_one_to_first
_____________________________________v__________________________________________
######################################000#101h##################################

step : 108
state: move_right_to_first_end
______________________________________v_________________________________________
#####################################1000#101h##################################

step : 109
state: move_right_to_first_end
_______________________________________v________________________________________
#####################################1000#101h##################################

step : 110
state: move_right_to_first_end
________________________________________v_______________________________________
#####################################1000#101h##################################

step : 111
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1000#101h##################################

step : 112
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1000#101h##################################

step : 113
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1000#101h##################################

step : 114
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1000#101h##################################

step : 115
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1000#101h##################################

step : 116
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1000#101h##################################

step : 117
state: move_left_to_first_end
___________________________________________v____________________________________
#####################################1000#100h##################################

step : 118
state: move_left_to_first_end
__________________________________________v_____________________________________
#####################################1000#100h##################################

step : 119
state: move_left_to_first_end
_________________________________________v______________________________________
#####################################1000#100h##################################

step : 120
state: add_one_to_first
________________________________________v_______________________________________
#####################################1000#100h##################################

step : 121
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1001#100h##################################

step : 122
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1001#100h##################################

step : 123
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1001#100h##################################

step : 124
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1001#100h##################################

step : 125
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1001#100h##################################

step : 126
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1001#100h##################################

step : 127
state: subtract_one_from_second
___________________________________________v____________________________________
#####################################1001#101h##################################

step : 128
state: subtract_one_from_second
__________________________________________v_____________________________________
#####################################1001#111h##################################

step : 129
state: move_left_to_first_end
_________________________________________v______________________________________
#####################################1001#011h##################################

step : 130
state: add_one_to_first
________________________________________v_______________________________________
#####################################1001#011h##################################

step : 131
state: add_one_to_first
_______________________________________v________________________________________
#####################################1000#011h##################################

step : 132
state: move_right_to_first_end
________________________________________v_______________________________________
#####################################1010#011h##################################

step : 133
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1010#011h##################################

step : 134
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1010#011h##################################

step : 135
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1010#011h##################################

step : 136
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1010#011h##################################

step : 137
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1010#011h##################################

step : 138
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1010#011h##################################

step : 139
state: move_left_to_first_end
___________________________________________v____________________________________
#####################################1010#010h##################################

step : 140
state: move_left_to_first_end
__________________________________________v_____________________________________
#####################################1010#010h##################################

step : 141
state: move_left_to_first_end
_________________________________________v______________________________________
#####################################1010#010h##################################

step : 142
state: add_one_to_first
________________________________________v_______________________________________
#####################################1010#010h##################################

step : 143
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1011#010h##################################

step : 144
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1011#010h##################################

step : 145
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1011#010h##################################

step : 146
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1011#010h##################################

step : 147
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1011#010h##################################

step : 148
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1011#010h##################################

step : 149
state: subtract_one_from_second
___________________________________________v____________________________________
#####################################1011#011h##################################

step : 150
state: move_left_to_first_end
__________________________________________v_____________________________________
#####################################1011#001h##################################

step : 151
state: move_left_to_first_end
_________________________________________v______________________________________
#####################################1011#001h##################################

step : 152
state: add_one_to_first
________________________________________v_______________________________________
#####################################1011#001h##################################

step : 153
state: add_one_to_first
_______________________________________v________________________________________
#####################################1010#001h##################################

step : 154
state: add_one_to_first
______________________________________v_________________________________________
#####################################1000#001h##################################

step : 155
state: move_right_to_first_end
_______________________________________v________________________________________
#####################################1100#001h##################################

step : 156
state: move_right_to_first_end
________________________________________v_______________________________________
#####################################1100#001h##################################

step : 157
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1100#001h##################################

step : 158
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1100#001h##################################

step : 159
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1100#001h##################################

step : 160
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1100#001h##################################

step : 161
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1100#001h##################################

step : 162
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1100#001h##################################

step : 163
state: move_left_to_first_end
___________________________________________v____________________________________
#####################################1100#000h##################################

step : 164
state: move_left_to_first_end
__________________________________________v_____________________________________
#####################################1100#000h##################################

step : 165
state: move_left_to_first_end
_________________________________________v______________________________________
#####################################1100#000h##################################

step : 166
state: add_one_to_first
________________________________________v_______________________________________
#####################################1100#000h##################################

step : 167
state: move_right_to_first_end
_________________________________________v______________________________________
#####################################1101#000h##################################

step : 168
state: move_right_to_second_end
__________________________________________v_____________________________________
#####################################1101#000h##################################

step : 169
state: move_right_to_second_end
___________________________________________v____________________________________
#####################################1101#000h##################################

step : 170
state: move_right_to_second_end
____________________________________________v___________________________________
#####################################1101#000h##################################

step : 171
state: move_right_to_second_end
_____________________________________________v__________________________________
#####################################1101#000h##################################

step : 172
state: subtract_one_from_second
____________________________________________v___________________________________
#####################################1101#000h##################################

step : 173
state: subtract_one_from_second
___________________________________________v____________________________________
#####################################1101#001h##################################

step : 174
state: subtract_one_from_second
__________________________________________v_____________________________________
#####################################1101#011h##################################

step : 175
state: subtract_one_from_second
_________________________________________v______________________________________
#####################################1101#111h##################################

step : 176
state: clean_up
__________________________________________v_____________________________________
#####################################1101#111h##################################

step : 177
state: clean_up
___________________________________________v____________________________________
#####################################1101##11h##################################

step : 178
state: clean_up
____________________________________________v___________________________________
#####################################1101###1h##################################

step : 179
state: clean_up
_____________________________________________v__________________________________
#####################################1101####h##################################

step : 180
state: move_one_step_to_right_and_halt
______________________________________________v_________________________________
#####################################1101#######################################

```


---

## **Sources**

- The implementation of the Turing machine for adding binary integers is partially inspired by a discussion on [Stack Overflow](https://stackoverflow.com/questions/59045832/turing-machine-for-addition-and-comparison-of-binary-numbers). This provided the foundational logic for the summation of two integers using a Turing machine.

- The approach of **shifting the first binary integer toward the second integer**, performing the summation, and then recursively repeating the process for newly defined pairs of integers is my own independent logic. While I do not claim to have invented this method, I developed it independently as part of this implementation.





