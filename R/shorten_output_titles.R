#output_title= output_titles[1]
shorten_output_titles= function(output_title){
  output_title= gsub("_VS_", "_vs_", output_title) #if VS upper case- strsplt lacks ignore.case
  output_title_split= unlist(strsplit(output_title, "_vs_"))
  control_words= unlist(strsplit(output_title_split[1], "_"))
  treated_words= unlist(strsplit(output_title_split[2], "_"))

  i= 1
  i_max= max(c(
    nchar(control_words),
    nchar(treated_words)
  ))
  i= 1
  new_output_title= ""
  while(nchar(new_output_title) < 100 & i < i_max){
    new_control_title= control_words[1:i]
    new_control_title= new_control_title[!is.na(new_control_title)]
    new_treated_title= treated_words[1:i]
    new_treated_title= new_treated_title[!is.na(new_control_title)]
    new_output_title= paste0(
      paste0(new_control_title, collapse= "_"),
      "_vs_",
      paste0(new_treated_title, collapse= "_")
      , collapse= "_")
    i= i+1
  }

  return(new_output_title)
}
