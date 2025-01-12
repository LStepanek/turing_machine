###############################################################################
###############################################################################
###############################################################################

myTuringMachineEncoder <- function(
    
    states_and_transitions
    
){
    
    # '''
    # Encodes a Turing machine's state transitions into a compressed string
    # format.
    # 
    # Args:
    #   states_and_transitions: A data frame or matrix containing the Turing
    #                           machine's state transition rules. Each row
    #                           represents a transition and must include the
    #                           following columns:
    #     -- current_state: The current state of the Turing machine.
    #     -- read_symbol: The symbol read at the tape head.
    #     -- next_state: The state to transition to.
    #     -- written_symbol: The symbol to write at the current tape position.
    #     -- move: The direction to move the tape head ("R" for right, "L" for
    #        left).
    # 
    # Returns:
    #   A list containing:
    #     - encoded_states_and_transitions: A single string representing all
    #       transitions, where:
    #         -- Each transition is encoded as a 5-tuple:
    #            
    #           (current_state, read_symbol, next_state, written_symbol, move)
    #  
    #         -- Each unique state, symbol, or move is encoded as a sequence
    #            of 0's.
    #         -- Commas (`,`) between tuple elements are encoded as a single
    #            `1`.
    #         -- Each transition is concatenated, separated by two consecutive
    #            `1`s (`11`).
    #         -- The string is bounded by a leading and trailing triplet of
    #            1's (`111`).
    #     -- dictionary: A data frame mapping each unique value (state,
    #        symbol, or move) to its encoded representation.
    # 
    # Example:
    #   Given a transition matrix:
    #      current_state | read_symbol | next_state  | written_symbol | move
    #      --------------|-------------|-------------|----------------|-----
    #      move_right    | 0           | halt        | 1              | R
    # 
    #   The function might encode it as:
    #     encoded_states_and_transitions = "0100100010000100000"
    #     dictionary = 
    #        value          encoded_value
    #      ------------------------------
    #      move_right       0
    #      0                00
    #      halt             000
    #      1                0000
    #      R                00000
    # 
    # Notes:
    #   -- Each state, symbol, and move is uniquely represented using this
    #      encoding.
    #   -- Useful for compressing Turing machine configurations into compact
    #      string representations for storage or transmission.
    #   -- Assumes the input matrix contains valid and unique transitions.
    # '''
    
    my_unique_values <- c(
        unique(
            c(
                states_and_transitions[
                    ,
                    "current_state"
                ],
                states_and_transitions[
                    ,
                    "next_state"
                ]
            )
        ),
        unique(
            c(
                states_and_transitions[
                    ,
                    "read_symbol"
                ],
                states_and_transitions[
                    ,
                    "written_symbol"
                ]
            )
        ),
        unique(
            states_and_transitions[
                ,
                "move"
            ]
        )
    )
    
    my_dictionary <- data.frame(
        "value" = my_unique_values,
        "encoded_value" = unlist(
            lapply(
                my_unique_values,
                function(i){
                    paste(
                        rep(
                            "0",
                            length = which(my_unique_values == i)
                        ),
                        collapse = ""
                    )
                }
            )
        ),
        stringsAsFactors = FALSE
    )
    
    my_encoded_matrix <- NULL
    
    for(
        i in 1:dim(states_and_transitions)[1]
    ){
        
        my_row <- NULL
        
        for(
            j in 1:length(states_and_transitions[i, ])
        ){
            
            my_row <- c(
                
                my_row,
                my_dictionary[
                    which(
                        my_dictionary[, "value"] ==
                            states_and_transitions[i, j]
                    ),
                    "encoded_value"
                ]
                
            )
            
        }
        
        my_encoded_matrix <- c(
            
            my_encoded_matrix,
            paste(
                my_row,
                collapse = "1"
            )
            
        )
        
    }
    
    return(
        list(
            "encoded_states_and_transitions" = paste(
                "111",
                paste(
                    my_encoded_matrix,
                    collapse = "11"
                ),
                "111",
                sep = ""
            ),
            "dictionary" = my_dictionary
        )
    )
    
}

myTuringMachineDecoder <- function(
    
    encoded_states_and_transitions,
    dictionary
    
){
    
    # '''
    # Decodes a Turing machine's state transitions from a compressed string
    # format.
    # 
    # Args:
    #   encoded_states_and_transitions: A string or vector of strings
    #                                   representing the encoded transitions.
    #                                   Each transition is encoded as
    #                                   a sequence of 0's and 1's, where:
    #     -- 1's represent separators between elements of the 5-tuple.
    #     -- Sequences of 0's represent unique values (states, symbols,
    #        or moves).
    #     -- Transitions are separated by two consecutive 1's ("11").
    #     -- The string is bounded by a leading and trailing triplet of 1's
    #        ("111").
    #   dictionary: A data frame mapping encoded sequences of 0's to their
    #               original values. Must contain the following columns:
    #     -- `encoded_value`: The sequence of 0's representing each value.
    #     -- `value`: The original state, symbol, or move.
    # 
    # Returns:
    #   A data frame with the decoded Turing machine state transitions. The
    #   data frame contains the following columns:
    #     -- `current_state`: The original current state.
    #     -- `read_symbol`: The symbol read at the tape head.
    #     -- `next_state`: The state to transition to.
    #     -- `written_symbol`: The symbol to write at the current tape
    #         position.
    #     -- `move`: The direction to move the tape head ("R" for right,
    #         "L" for left).
    # 
    # Example:
    #   Given:
    #     encoded_states_and_transitions = "010010001000010000011"
    #     dictionary = 
    #        value          encoded_value
    #      ------------------------------
    #      move_right       0
    #      0                00
    #      halt             000
    #      1                0000
    #      R                00000
    # 
    #   The function decodes the string into:
    #      current_state | read_symbol | next_state  | written_symbol | move
    #      --------------|-------------|-------------|----------------|-----
    #      move_right    | 0           | halt        | 1              | R
    # 
    # Notes:
    #   -- Assumes the `encoded_states_and_transitions` follows the same
    #      encoding logic as the output of `myTuringMachineEncoder`.
    #   -- The dictionary must contain all encoded values to ensure proper
    #      decoding.
    # '''
    
    encoded_states_and_transitions <- gsub(
        "^111",
        "",
        encoded_states_and_transitions
    )
    
    encoded_states_and_transitions <- gsub(
        "111$",
        "",
        encoded_states_and_transitions
    )
    
    my_encoded_transitions <- strsplit(
        encoded_states_and_transitions,
        split = "11"
    )[[1]]
    
    my_decoded_states_and_transitions <- NULL
    
    for(
        i in 1:length(my_encoded_transitions)
    ){
        
        my_values <- strsplit(
            my_encoded_transitions[i],
            split = "1"
        )[[1]]
        
        my_decoded_values <- NULL
        
        for(
            j in 1:length(my_values)
        ){
            
            my_decoded_values <- c(
                
                my_decoded_values,
                dictionary[
                    which(
                        dictionary[, "encoded_value"] == my_values[j]
                    ),
                    "value"
                ]
                
            )
            
        }
        
        my_decoded_states_and_transitions <- rbind(
            
            my_decoded_states_and_transitions,
            my_decoded_values
            
        )
        
    }
    
    colnames(my_decoded_states_and_transitions) <- c(
        "current_state",
        "read_symbol",
        "next_state",
        "written_symbol",
        "move"
    )
    
    rownames(my_decoded_states_and_transitions) <- as.character(
        1:dim(my_decoded_states_and_transitions)[1]
    )
    
    return(
        data.frame(
            my_decoded_states_and_transitions,
            stringsAsFactors = FALSE
        )
    )
    
}


## ----------------------------------------------------------------------------

## I am saving my encoded Turing machine
writeLines(
    con = "encoded_turing_machine.txt",
    text = myTuringMachineEncoder(
        states_and_transitions
    )[["encoded_states_and_transitions"]]
)
write.table(
    x = myTuringMachineEncoder(
        states_and_transitions
    )[["dictionary"]],
    file = "dictionary.txt",
    sep = ",",
    row.names = FALSE,
    quote = FALSE
)

## I am loading the encoded Turing machine and trying to decode it
my_encoded_turing_machine <- readLines(
    con = "encoded_turing_machine.txt"
)
my_dictionary <- read.table(
    file = "dictionary.txt",
    header = TRUE,
    sep = ",",
    colClasses = "character",
    comment.char = ""
)

my_decoded_turing_machine <- myTuringMachineDecoder(
    encoded_states_and_transitions = my_encoded_turing_machine,
    dictionary = my_dictionary
)

## I am saving my decoded Turing machine's states and transitions
write.table(
    x= my_decoded_turing_machine,
    file = "decoded_turing_machine.txt",
    sep = ",",
    row.names = FALSE,
    quote = FALSE
)

## I am checking whether the decoded(encoded(machine)) is the same as the
## the original machine
all(my_decoded_turing_machine == states_and_transitions)
# TRUE


###############################################################################
###############################################################################
###############################################################################





