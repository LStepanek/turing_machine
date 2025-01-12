###############################################################################
###############################################################################
###############################################################################

addingTuringMachine <- function(
    
    input_tape,
    states_and_transitions
    
){
    
    # '''
    # This Turing machine adds a finite number of binary integers on an
    # infinite tape "input_tape". Each pair of neighboring integers is
    # separated by a single hash "#" symbol. The state transitions and rules
    # for the Turing machine are stored in the "states_and_transitions"
    # matrix.
    # 
    # The "input_tape" should follow the format below,
    # 
    #    "#...##<first binary integer>#<second binary integer>##...#" .
    #
    # Parameters:
    # -- input_tape: A string representing the infinite tape with binary
    #                integers and '#' separators.
    # -- states_and_transitions: A matrix defining the Turing machine's
    #                states and transitions.
    #                Each row should specify:
    #                -- current_state: The current state of the machine.
    #                -- read_symbol: The symbol under the tape head.
    #                -- written_symbol: The symbol to write at the tape head's
    #                   current position.
    #                -- next_state: The state to transition to after the
    #                   current step.
    #                -- move: The direction to move the tape head ("R" for
    #                   right, "L" for left).
    #
    # Returns:
    # -- A string representing the final state of the tape after all
    #    computations.
    #
    # Assumptions:
    # -- The tape contains valid binary integers separated by "#" symbols,
    #    with sufficiently long sequences of "#" symbols at the start and end
    #    of the tape to serve as boundaries.
    # -- The "states_and_transitions" matrix is correctly defined and
    #    deterministic.
    # -- The machine halts when it reaches the "halt" state.
    # '''
    
    my_tape <- strsplit(
        input_tape,
        split = ""
    )[[1]]
    
    # initialize the tape head position to the first binary digit
    my_index <- min(which(my_tape %in% c("0", "1")))
    
    # set the initial state
    my_state <- "move_right_to_first_end"
    
    # continue processing until the machine reaches the "halt" state
    while(
        my_state != "halt"
    ){
        current_state <- my_state
        read_symbol <- my_tape[my_index]
        
        # update the tape with the written symbol from the transition rules
        my_tape[my_index] <- states_and_transitions[
            states_and_transitions[, "current_state"] == current_state &
            states_and_transitions[, "read_symbol"] == read_symbol,
            "written_symbol"
        ]
        
        # transition to the next state
        my_state <- states_and_transitions[
            states_and_transitions[, "current_state"] == current_state &
            states_and_transitions[, "read_symbol"] == read_symbol,
            "next_state"
        ]
        
        # update the tape head position based on the movement rule
        my_index <- my_index + if(
            states_and_transitions[
                states_and_transitions[, "current_state"] == current_state &
                states_and_transitions[, "read_symbol"] == read_symbol,
                "move"
            ] == "R"
        ){
            + 1
        }else{
            - 1
        }
    }
    
    # return the final tape as a single string
    return(
        paste(
            my_tape,
            collapse = ""
        )
    )
    
}

addingTuringMachineStepByStep <- function(
    
    input_tape,
    states_and_transitions
    
){
    
    # '''
    # Simulates the execution of a Turing machine step-by-step to add a finite
    # number of binary integers on a single 'infinite' tape.
    # 
    # Description:
    # The input tape ("input_tape") contains binary integers separated by
    # a single "#" symbol, with sufficient padding of "#" symbols at the start
    # and end of the tape. The Turing machine reads the tape, processes
    # transitions defined in `states_and_transitions`, and prints each step of
    # the computation to the console.
    # 
    # Parameters:
    # -- input_tape: A string representing the infinite tape with binary
    #                integers and `#` separators. It should follow the format
    #                below,
    # 
    #            "#...##<first binary integer>#<second binary integer>##...#".
    # 
    # -- states_and_transitions: A matrix defining the Turing machine's state
    #                transitions. Each row must include the following columns:
    #                -- current_state: The current state of the Turing
    #                   machine.
    #                -- read_symbol: The symbol currently under the tape head.
    #                -- written_symbol: The symbol to write at the current
    #                   position.
    #                -- next_state: The state to transition to after the
    #                   current step.
    #                -- move: The direction to move the tape head ("R" for
    #                   right, "L" for left).
    # 
    # Returns:
    # -- The function does not return a value but prints the following to the
    #    console for each step:
    #    -- The current state of the Turing machine.
    #    -- The position of the tape head, indicated by a line of underscores
    #       (`_`) with a `v` symbol directly below the current position.
    #    -- The current contents of the tape.
    # 
    # Assumptions:
    # -- The input tape contains valid binary integers separated by "#"
    #    symbols, with sufficiently long sequences of "#" symbols at the start
    #    and end to serve as boundaries.
    # -- The "states_and_transitions" matrix is deterministic and correctly
    #    defined, ensuring that every state-symbol combination leads to
    #    a valid transition.
    # -- The Turing machine halts when it reaches the "halt" state.
    # '''
    
    my_tape <- strsplit(
        input_tape,
        split = ""
    )[[1]]
    
    # initialize the tape head position to the first binary digit
    my_index <- min(which(my_tape %in% c("0", "1")))
    
    # set the initial state
    my_state <- "move_right_to_first_end"
    
    # set the initial step
    my_step <- 1
    
    # continue processing until the machine reaches the "halt" state
    while(
        my_state != "halt"
    ){
        current_state <- my_state
        read_symbol <- my_tape[my_index]
        
        # indicate the current program step, current state of the machine
        # and curent tape posisiton, and print this to the console
        my_tape_head_position <- rep("_", length = length(my_tape))
        my_tape_head_position[my_index] <- "v"
        
        cat("\n")
        cat(
            paste("step : ", my_step, sep = "")
        )
        cat("\n")
        cat(
            paste("state: ", my_state, sep = "")
        )
        cat("\n")
        cat(
            paste(
                my_tape_head_position,
                collapse = ""
            )
        )
        cat("\n")
        cat(
            paste(
                my_tape,
                collapse = ""
            )
        )
        cat("\n")
        
        # update the tape with the written symbol from the transition rules
        my_tape[my_index] <- states_and_transitions[
            states_and_transitions[, "current_state"] == current_state &
            states_and_transitions[, "read_symbol"] == read_symbol,
            "written_symbol"
        ]
        
        # transition to the next state
        my_state <- states_and_transitions[
            states_and_transitions[, "current_state"] == current_state &
            states_and_transitions[, "read_symbol"] == read_symbol,
            "next_state"
        ]
        
        # update the tape head position based on the movement rule
        my_index <- my_index + if(
            states_and_transitions[
                states_and_transitions[, "current_state"] == current_state &
                states_and_transitions[, "read_symbol"] == read_symbol,
                "move"
            ] == "R"
        ){
            + 1
        }else{
            - 1
        }
        
        my_step <- my_step + 1
    }
    
}


###############################################################################
###############################################################################
###############################################################################





