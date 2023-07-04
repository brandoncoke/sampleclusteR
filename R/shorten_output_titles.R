shorten_output_titles= function(output_title){
  #output_title= as.character(unlist(output_title))
  #output_title= tolower(output_title)
  output_title= gsub("_VS_", "_vs_", output_title)
  output_title= unlist(strsplit(output_title, "_vs_"))
  ori_titles= output_title
  first_parts_of_strings= substr(output_title, 1, 49)
  i=49
  #keep gsubbing until unique strings identified
  while(first_parts_of_strings[1] == first_parts_of_strings[2]
        & i <= max(nchar(ori_titles))){
    first_parts_of_strings= substr(output_title, 1, i)
    i=i+1
  }
  return(paste0(first_parts_of_strings, collapse = "_vs_"))
}
