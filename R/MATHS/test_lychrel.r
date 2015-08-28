## Take a number and do 'revert and add' until you get a palindrome number
## Some code taken from http://stackoverflow.com/questions/19764244/how-can-we-split-an-integer-number-into-a-vector-of-its-constituent-digits-in-r
## TODO: implement some efficient big number handling.
## The objective is to run at least a million iterations on 196
Lychrel <- function(x, itLimit = 1E+7){ ## play until find a palindrome
  splitDigits <- function(n) as.numeric(strsplit(as.character(n), "")[[1]]) ## get the digits
  collapseDigits <- function(v) as.numeric(paste(v, collapse = "")) ## get the number back
  doIter <- function(input){ ## input is a number
    revinput <- rev(splitDigits(input))
    reverseinput <- collapseDigits(revinput)
    output <- input + reverseinput
    return(list(digits = length(splitDigits(output)), result = output))
  }
  testPalindrome <- function(n) identical(splitDigits(n), rev(splitDigits(n)))
  steps <- 0
  res <- list(result = x, digits = length(splitDigits(x)))
  digis <- res$digits
  while(!testPalindrome(res$result)){
    steps <- steps + 1
    res <- doIter(res$result)
    digis <- res$digits
    if(steps%%(itLimit/10)==0) cat("Done ", steps, "iterations already!",
                                   "currently in", digis, "digits \n")
    if(steps > itLimit) break()
  }
  return(list(result = res$result,
              digits = digis,
              Nsteps = steps))
}
##
Lychrel(32)
Lychrel(59)
Lychrel(89)
Lychrel(44)
Lychrel(196) ## fails miserably see TODO