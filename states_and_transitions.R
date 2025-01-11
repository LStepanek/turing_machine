###############################################################################
###############################################################################
###############################################################################

states_and_transitions <- data.frame(
    rbind(
        # [move_right_to_first_end]
        # move right to the end of the first binary integer
        c(
            "current_state"  = "move_right_to_first_end",
            "read_symbol"    = "0",
            "next_state"     = "move_right_to_first_end",
            "written_symbol" = "0",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_to_first_end",
            "read_symbol"    = "1",
            "next_state"     = "move_right_to_first_end",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_to_first_end",
            "read_symbol"    = "#",
            "next_state"     = "move_right_to_second_end",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        # [move_right_to_second_end]
        # move right to the end of the second binary integer
        c(
            "current_state"  = "move_right_to_second_end",
            "read_symbol"    = "0",
            "next_state"     = "move_right_to_second_end",
            "written_symbol" = "0",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_to_second_end",
            "read_symbol"    = "1",
            "next_state"     = "move_right_to_second_end",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_to_second_end",
            "read_symbol"    = "#",
            "next_state"     =  "check_if_then_halt",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_to_second_end",
            "read_symbol"    = "c",
            "next_state"     = "subtract_one_from_second",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_right_to_second_end",
            "read_symbol"    = "h",
            "next_state"     = "subtract_one_from_second",
            "written_symbol" = "h",
            "move"           = "L"
        ),
        # [check_if_then_halt]
        # check whether the machine halts after the summation of the two
        # integers
        c(
            "current_state"  = "check_if_then_halt",
            "read_symbol"    = "0",
            "next_state"     = "go_back_and_write_hash",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "check_if_then_halt",
            "read_symbol"    = "1",
            "next_state"     = "go_back_and_write_hash",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "check_if_then_halt",
            "read_symbol"    = "#",
            "next_state"     = "go_back_and_write_halt",
            "written_symbol" = "#",
            "move"           = "L"
        ),
        # [go_back_and_write_continue]
        c(
            "current_state"  = "go_back_and_write_hash",
            "read_symbol"    = "#",
            "next_state"     = "subtract_one_from_second",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        # [go_back_and_write_halt]
        c(
            "current_state"  = "go_back_and_write_halt",
            "read_symbol"    = "#",
            "next_state"     = "subtract_one_from_second",
            "written_symbol" = "h",
            "move"           = "L"
        ),
        # [subtract_one_from_second]
        # subtract one in binary way from the second binary integer
        c(
            "current_state"  = "subtract_one_from_second",
            "read_symbol"    = "0",
            "next_state"     = "subtract_one_from_second",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "subtract_one_from_second",
            "read_symbol"    = "1",
            "next_state"     = "move_left_to_first_end",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "subtract_one_from_second",
            "read_symbol"    = "#",
            "next_state"     = "clean_up",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        # [move_left_to_first_end]
        # move left to the end of the first binary integer
        c(
            "current_state"  = "move_left_to_first_end",
            "read_symbol"    = "0",
            "next_state"     = "move_left_to_first_end",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_to_first_end",
            "read_symbol"    = "1",
            "next_state"     = "move_left_to_first_end",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_to_first_end",
            "read_symbol"    = "#",
            "next_state"     = "add_one_to_first",
            "written_symbol" = "#",
            "move"           = "L"
        ),
        # [add_one_to_first]
        # add one in binary way to the first binary integer
        c(
            "current_state"  = "add_one_to_first",
            "read_symbol"    = "0",
            "next_state"     = "move_right_to_first_end",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "add_one_to_first",
            "read_symbol"    = "1",
            "next_state"     = "add_one_to_first",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "add_one_to_first",
            "read_symbol"    = "#",
            "next_state"     = "move_right_to_first_end",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        # [clean_up]
        c(
            "current_state"  = "clean_up",
            "read_symbol"    = "0",
            "next_state"     = "clean_up",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "clean_up",
            "read_symbol"    = "1",
            "next_state"     = "clean_up",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "clean_up",
            "read_symbol"    = "#",
            "next_state"     = "clean_up",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "clean_up",
            "read_symbol"    = "c",
            "next_state"     = "move_left_and_reach_digits",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        c(
            "current_state"  = "clean_up",
            "read_symbol"    = "h",
            "next_state"     = "move_one_step_to_right_and_halt",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        # [move_left_and_reach_digits]
        c(
            "current_state"  = "move_left_and_reach_digits",
            "read_symbol"    = "0",
            "next_state"     = "continue_to_leftmost_digit",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_and_reach_digits",
            "read_symbol"    = "1",
            "next_state"     = "continue_to_leftmost_digit",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_and_reach_digits",
            "read_symbol"    = "#",
            "next_state"     = "move_left_and_reach_digits",
            "written_symbol" = "#",
            "move"           = "L"
        ),
        # [continue_to_leftmost_digit]
        c(
            "current_state"  = "continue_to_leftmost_digit",
            "read_symbol"    = "0",
            "next_state"     = "continue_to_leftmost_digit",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "continue_to_leftmost_digit",
            "read_symbol"    = "1",
            "next_state"     = "continue_to_leftmost_digit",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "continue_to_leftmost_digit",
            "read_symbol"    = "#",
            "next_state"     = "move_right_and_reach_c",
            "written_symbol" = "b",
            "move"           = "R"
        ),
        # [move_right_and_reach_c]
        c(
            "current_state"  = "move_right_and_reach_c",
            "read_symbol"    = "0",
            "next_state"     = "move_right_and_reach_c",
            "written_symbol" = "0",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_and_reach_c",
            "read_symbol"    = "1",
            "next_state"     = "move_right_and_reach_c",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_and_reach_c",
            "read_symbol"    = "#",
            "next_state"     = "move_right_and_reach_c",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_and_reach_c",
            "read_symbol"    = "c",
            "next_state"     = "move_left_to_first_end_and_start_shifting",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        # [move_left_to_first_end_and_start_shifting]
        # move left to the end of the current first integer and start
        # shifting its digits from the back
        c(
            "current_state"  = "move_left_to_first_end_and_start_shifting",
            "read_symbol"    = "#",
            "next_state"     = "move_left_to_first_end_and_start_shifting",
            "written_symbol" = "#",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_to_first_end_and_start_shifting",
            "read_symbol"    = "0",
            "next_state"     = "move_right_and_shift_zero",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_left_to_first_end_and_start_shifting",
            "read_symbol"    = "1",
            "next_state"     = "move_right_and_shift_one",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_left_to_first_end_and_start_shifting",
            "read_symbol"    = "b",
            "next_state"     = "move_right_reach_c_and_replace_it_by_hash",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        # [move_right_reach_c_and_replace_it_by_hash]
        c(
            "current_state"  = "move_right_reach_c_and_replace_it_by_hash",
            "read_symbol"    = "0",
            "next_state"     = "move_right_reach_c_and_replace_it_by_hash",
            "written_symbol" = "0",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_reach_c_and_replace_it_by_hash",
            "read_symbol"    = "1",
            "next_state"     = "move_right_reach_c_and_replace_it_by_hash",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_reach_c_and_replace_it_by_hash",
            "read_symbol"    = "#",
            "next_state"     = "move_right_reach_c_and_replace_it_by_hash",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_reach_c_and_replace_it_by_hash",
            "read_symbol"    = "c",
            "next_state"     = "move_left_and_reach_leftmost_digit",
            "written_symbol" = "#",
            "move"           = "L"
        ),
        # [move_left_and_reach_leftmost_digit]
        c(
            "current_state"  = "move_left_and_reach_leftmost_digit",
            "read_symbol"    = "0",
            "next_state"     = "move_left_and_reach_leftmost_digit",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_and_reach_leftmost_digit",
            "read_symbol"    = "1",
            "next_state"     = "move_left_and_reach_leftmost_digit",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_left_and_reach_leftmost_digit",
            "read_symbol"    = "#",
            "next_state"     = "move_right_to_first_end",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        # [move_right_and_shift_zero]
        c(
            "current_state"  = "move_right_and_shift_zero",
            "read_symbol"    = "#",
            "next_state"     = "move_right_and_shift_zero",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_and_shift_zero",
            "read_symbol"    = "0",
            "next_state"     = "turn_left_and_shift_zero",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_right_and_shift_zero",
            "read_symbol"    = "1",
            "next_state"     = "turn_left_and_shift_zero",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_right_and_shift_zero",
            "read_symbol"    = "c",
            "next_state"     = "turn_left_and_shift_zero",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        # [move_right_and_shift_one]
        c(
            "current_state"  = "move_right_and_shift_one",
            "read_symbol"    = "#",
            "next_state"     = "move_right_and_shift_one",
            "written_symbol" = "#",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_right_and_shift_one",
            "read_symbol"    = "0",
            "next_state"     = "turn_left_and_shift_one",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_right_and_shift_one",
            "read_symbol"    = "1",
            "next_state"     = "turn_left_and_shift_one",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        c(
            "current_state"  = "move_right_and_shift_one",
            "read_symbol"    = "c",
            "next_state"     = "turn_left_and_shift_one",
            "written_symbol" = "c",
            "move"           = "L"
        ),
        # [turn_left_and_shift_zero]
        c(
            "current_state"  = "turn_left_and_shift_zero",
            "read_symbol"    = "#",
            "next_state"     = "move_left_to_first_end_and_start_shifting",
            "written_symbol" = "0",
            "move"           = "L"
        ),
        # [turn_left_and_shift_one]
        c(
            "current_state"  = "turn_left_and_shift_one",
            "read_symbol"    = "#",
            "next_state"     = "move_left_to_first_end_and_start_shifting",
            "written_symbol" = "1",
            "move"           = "L"
        ),
        # [move_one_step_to_right_and_halt]
        c(
            "current_state"  = "move_one_step_to_right_and_halt",
            "read_symbol"    = "0",
            "next_state"     = "halt",
            "written_symbol" = "0",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_one_step_to_right_and_halt",
            "read_symbol"    = "1",
            "next_state"     = "halt",
            "written_symbol" = "1",
            "move"           = "R"
        ),
        c(
            "current_state"  = "move_one_step_to_right_and_halt",
            "read_symbol"    = "#",
            "next_state"     = "halt",
            "written_symbol" = "#",
            "move"           = "R"
        )
    ),
    stringsAsFactors = FALSE
)


###############################################################################
###############################################################################
###############################################################################





