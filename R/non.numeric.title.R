non.numeric.title <- function(gsm_title){
  title <- gsub("[!a-z!0-9!A-Z][0-9a-zA-Z]{,2}$","",gsm_title) #removes needless sample numbers like rep1, rep2 -> rep, rep
  title <- gsub("\\s|\\-","",gsm_title)
  if(grepl("^[0-9]+$", gsm_title)) {
    return(F)
  }
  return(T)
}
