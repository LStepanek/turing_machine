###############################################################################
###############################################################################
###############################################################################

decimalToBinary <- function(x){
    
    # '''
    # Converts a decimal integer to its binary representation.
    #
    # Args:
    #   x: A positive decimal integer.
    #
    # Returns:
    #   A binary number representing the input decimal integer.
    # '''
    
    my_output <- ""
    
    for(
        i in c(floor(log2(x)):0)
    ){
        my_output <- paste(
            my_output,
            as.character(x %/% (2 ^ i)),
            sep = ""
        )
        x <- x %% (2 ^ i)
    }
    
    return(
        as.numeric(
            my_output
        )
    )
    
}

binaryToDecimal <- function(x){
    
    # '''
    # Converts a binary number to its decimal representation.
    #
    # Args:
    #   x: A binary number provided as a numeric or character string.
    #
    # Returns:
    #   A decimal number (numeric) representing the input binary number.
    # '''
    
    x <- as.character(x)
    my_output <- 0
    
    for(
        i in 0:(nchar(x) - 1)
    ){
        my_output <- my_output + (2 ^ i) * as.numeric(
            substr(x, nchar(x) - i, nchar(x) - i)
        )
    }
    
    return(
        my_output
    )
    
}

getMyInputTape <- function(
    
    my_binary_numbers,
    total_length = 80
    
){
    
    # '''
    # Generates an input tape for a Turing machine.
    #
    # Args:
    #   my_binary_numbers: A vector of binary numbers to be placed on the
    #                      tape. Each binary number will be separated by a "#"
    #                      symbol.
    #   total_length:      The total length of the tape, including the
    #                      padding "#" symbols at the beginning and end of the
    #                      tape. Defaults to 80.
    #
    # Returns:
    #   A string representing the input tape, where the binary numbers are
    #   separated by "#", and the tape is padded with "#" symbols at the start
    #   and end to achieve the specified total length.
    #
    # Assumptions:
    #   -- The input binary numbers are valid and provided as numeric or
    #      character strings.
    #   -- The specified total length is sufficient to accommodate the binary
    #      numbers and separators.
    #
    # Notes:
    #   -- If the total length is insufficient, the function may produce
    #      an invalid tape.
    # '''
    
    my_output <- paste(
        my_binary_numbers,
        collapse = "#"
    )
    
    my_output <- paste(
        paste(
            rep(
                "#",
                ceiling((total_length - nchar(my_output)) / 2)
            ),
            collapse = ""
        ),
        my_output,
        paste(
            rep(
                "#",
                floor((total_length - nchar(my_output)) / 2)
            ),
            collapse = ""
        ),
        sep = ""
    )
    
    return(
        my_output
    )
    
}


## ----------------------------------------------------------------------------

options(scipen = 999)

closeAllConnections()

if(
    file.exists("unit_tests.txt")
){
    invisible(
        file.remove("unit_tests.txt")
    )
}

n <- 100

for(
    i in c(1:n)
){
    
    {
        set.seed(i)
        my_decimal_numbers <- sample(
            x = c(1:100),
            size = sample(x = c(1:8), size = 1),
            replace = TRUE
        )
    }
    
    my_binary_numbers <- unlist(
        lapply(
            my_decimal_numbers,
            decimalToBinary
        )
    )
    
    my_input_tape <- getMyInputTape(
        my_binary_numbers = unlist(
            lapply(
                my_decimal_numbers,
                decimalToBinary
            )
        ),
        total_length = 80
    )
    
    my_output_tape <- addingTuringMachine(
        input_tape = my_input_tape,
        states_and_transitions = states_and_transitions
    )
    
    
    ## ------------------------------------------------------------------------
    
    sink(
        file = "unit_tests.txt",
        append = TRUE
    )
    
    cat(
        paste(
            "====================",
            "====================",
            "====================",
            "====================\n",
            sep = ""
        )
    )
    cat(
        paste(
            "////////////////////",
            "////////////////////",
            "////////////////////",
            "////////////////////\n",
            sep = ""
        )
    )
    cat(
        paste(
            "////////////////////",
            "////////////////////",
            "////////////////////",
            "////////////////////\n",
            sep = ""
        )
    )
    cat(
        paste(
            "////////////////////",
            "////////////////////",
            "////////////////////",
            "////////////////////\n",
            sep = ""
        )
    )
    cat(
        paste(
            "====================",
            "====================",
            "====================",
            "====================\n",
            sep = ""
        )
    )
    
    cat("\n")
    cat(
        paste(
            "unit test i = ",
            i,
            " out of n = ",
            n,
            sep = ""
        )
    )
    cat("\n")
    cat("\n")
    
    cat("numbers in decimal:")
    cat("\n")
    cat(
        paste(
            my_decimal_numbers,
            collapse = " + "
        )
    )
    cat("\n")
    cat("    ")
    cat(" = ")
    cat(sum(my_decimal_numbers))
    
    cat("\n")
    cat("\n")
    
    cat("numbers in binary:")
    cat("\n")
    cat(
        paste(
            my_binary_numbers,
            collapse = " + "
        )
    )
    cat("\n")
    cat("    ")
    cat(" = ")
    cat(decimalToBinary(sum(my_decimal_numbers)))
    
    cat("\n")
    cat("\n")
    
    cat("tape on input:")
    cat("\n")
    cat(
        my_input_tape
    )
    
    cat("\n")
    cat("\n")
    
    cat("the same tape on output:")
    cat("\n")
    cat(
        my_output_tape
    )
    
    cat("\n")
    cat("\n")
    
    cat(
        paste(
            "status: ",
            if(
                sum(
                    my_decimal_numbers
                ) == binaryToDecimal(
                    as.numeric(
                        gsub("#", "", my_output_tape)
                    )
                )
            ){
                "correct ✓"
            }else{
                "incorrect !!!"
            },
            sep = ""
        )
    )
    
    cat("\n")
    cat("\n")
    cat("\n")
    
    sink()
    
    
    ## log messages -----------------------------------------------------------
    
    closeAllConnections()
    
    flush.console()
    cat(
        paste(
            "unit test i = ",
            i,
            " out of n = ",
            n,
            " done",
            sep = ""
        )
    )
    cat("\n")
    
    
    ## ------------------------------------------------------------------------
    
}


###############################################################################
###############################################################################
###############################################################################





