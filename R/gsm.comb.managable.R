gsm.comb.managable= function(title, words_only= F){
  ori_title= title
  title= gsub("^    ", "", title) #could while loop the substr(title, 1, 1) != " "- too slow need to bool check every cycle not practical for 100s of samples
  title= gsub("^   ", "", title)
  title= gsub("^ ", "", title)
  title= gsub("[(]|[)]", "", title, ignore.case = T)
  title= gsub("biological replicate", "", title, ignore.case= T)
  title= gsub("rep.[0-9]$|rep.[0-9][0-9]$|rep.[0-9][0-9][0-9]$","",title) #bodge dealing with rep [0-9] sometimes appended to samples- no good for clustering.
  title= gsub("rep[0-9]$|rep[0-9][0-9]$|rep[0-9][0-9][0-9]$","",title)
  title= gsub("replicate.[0-9][0-9]|replicate.[0-9]|replicate[0-9]", "",title, ignore.case = T) #removing replicate sample numbers- complicates clustering
  title= gsub("sample.[0-9][0-9]|sample.[0-9]|sample[0-9]", "",title, ignore.case = T)
  title= gsub("patient.[0-9][0-9]|patient.[0-9]|patient[0-9]", "",title, ignore.case = T)
  title= gsub("project.[0-9][0-9]|project.[0-9]|project[0-9]", "",title, ignore.case = T)
  title= gsub("replica.[0-9]|replica[0-9]|replicate.[0-9]|replicate[0-9]|", "", title, ignore.case = T)
  title= gsub("replica.[a-z]|replica[a-z]|replicate.[a-z]|replicate[a-z]", "", title, ignore.case = T)
  title= gsub("replicate", "", title, ignore.case = T)
  title= gsub(" [0-9a-zA-Z]$", "", title)
  title= gsub("day ", "day_", title, ignore.case = T) #bodgy but deals with the gsub below
  title= gsub(" [0-9] | [0-9]$", "", title)
  title= gsub(" [0-9][0-9] | [0-9][0-9]$", "", title)
  title= gsub(" [0-9][0-9][0-9] |[0-9][0-9][0-9]$", "", title)
  title= gsub(" [0-9][0-9][0-9][0-9] |[0-9][0-9][0-9][0-9]$", "", title)
  title= gsub("_[0-9a-zA-Z]$", "", title)
  title= gsub("_[0-9]$", "", title)
  title= gsub("_[0-9][0-9]$", "", title)
  title= gsub("_[0-9][0-9][0-9]$", "", title)
  title= gsub("_[0-9][0-9][0-9][0-9]$", "", title)
  title= gsub("[\\(I\\)]", "", title)
  title= gsub("[\\(II\\)]", "", title) #thanks GSE13763... roman numerals for the sample title
  title= gsub("mir-", "mir", title, ignore.case = T)
  title= gsub(" -[0-9][0-9]$", "", title)
  title= gsub(" -[0-9]$", "", title)
  title= gsub("[0-9][0-9]st", "", title)
  title= gsub("[0-9]st", "", title)
  title= gsub("2nd", "", title)
  title= gsub("[0-9]2nd", "", title)
  title= gsub("[0-9]3rd", "", title)
  title= gsub("3rd", "", title)
  title= gsub("exp[0-9]$|exp[0-9][0-9]$|exp[0-9][0-9][0-9]$", "", title)
  title= gsub("_", " ", title)
  title= gsub("  $", "", title)
  title= gsub(" $", "", title)
  title= gsub("expt[0-9]|expt.[0-9]", "", title, ignore.case = T)
  title= gsub("cell[.]line", "", title, ignore.case = T)
  title= gsub("cellline", "", title, ignore.case = T)
  title= gsub("^[0-9] |^[0-9][0-9] |^[0-9][0-9][0-9] ", "", title, ignore.case = T)
  title= gsub("^    ", "", title)
  title= gsub("^   ", "", title)
  title= gsub("^ ", "", title)
  title= gsub("-[0-9a-zA-Z]$", "", title)
  title= gsub("-[0-9]$", "", title)
  title= gsub("-[0-9][0-9]$", "", title)
  title= gsub("-[0-9][0-9][0-9]$", "", title)
  title= gsub("-[0-9][0-9][0-9][0-9]$", "", title)
  title= gsub("-scr[0-9][0-9]$", "_scramble", title, ignore.case = T)
  title= gsub("-scr[0-9]$", "_scramble", title, ignore.case = T)
  title= gsub("-shrna[0-9]$", "_shRNA", title, ignore.case = T)
  title= gsub("-shrna[0-9]$", "_shRNA", title, ignore.case = T)
  title= gsub("shrna[0-9]$|scr[0-9]$|scramble[0-9]$|shrna[0-9][0-9]$|scr[0-9][0-9]$|scramble[0-9][0-9]$", "", title, ignore.case= T) #assumes only 99 scramble samples
  title= gsub("kd[0-9]$|cont[0-9]$||kd[0-9][0-9]$|cont[0-9][0-9]$", "", title, ignore.case= T) #assumes only 99 contamble samples
  title= gsub("sample[0-9][0-9]", "", title, ignore.case= T)
  title= gsub("sample.[0-9]|sample[0-9]", "", title, ignore.case= T)
  title= gsub("conrol", "control", title, ignore.case = T)
  title= gsub("#[0-9][0-9]", "", title)
  title= gsub("#[0-9]", "", title)
  title= gsub("  |    ", " ", title)
  title= gsub("control[0-9]$", "control", title, ignore.case = T)#
  title= gsub("control.[0-9].|control[0-9]", "control", title, ignore.case = T)#
  title= gsub("change[0-9]$", "change", title, ignore.case = T)
  title= gsub("knockdown[0-9]$", "knockdown", title, ignore.case = T)
  title= gsub("change[0-9]$", "change", title, ignore.case = T)
  title= gsub(",", "", title, ignore.case = T)
  title= gsub("rep[0-9][0-9]$", "", title, ignore.case = T)
  title= gsub("rep[0-9]$", "", title, ignore.case = T)
  title= gsub("biological replicate [0-9]", "", title, ignore.case = T)
  title= gsub("6h E[0-9]", "6_hour", title) #thanks GSE108345 exp would make sense
  #second_regular_expression= "(day)|(week)|(ed)|(hr)(hour[0-9])?$)" #stricter regular expression gets rid of other parts which may mess up clustering.
  #if(!grepl(second_regular_expression,title, ignore.case = T)){
  #  title <- unlist(strsplit(gsub("[!a-z!0-9!A-Z][0-9a-zA-Z]{,2}$","",title), "\\,|\\_"))
  #}
  if(identical(title, character(length= 0))){ #if I cut too much from the gsub above- provide original title.
    title <- ori_title} #fail safe if gsub removes entirety
  title <- unlist(strsplit(gsub("\\s|\\-","_",title), "\\,|\\_"))
  title <- title[!title == ""]
  if(words_only){
    title= title[as.logical(lapply(title,function(x){!grepl("[0-9]",x)}))]
  }
  return(title)
}
