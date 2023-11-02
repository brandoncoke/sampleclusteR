gsm.title.managable= function(title, words_only= F){
  ori_title= title
  #rep with number at end- must be replicate id
  title= gsub("[_| ]rep[0-9][0-9][0-9]$", "", title, ignore.case= T)
  title= gsub("[_| ]rep[0-9][0-9]$", "", title, ignore.case= T)
  title= gsub("[ |_]rep[0-9]$", "", title, ignore.case= T)
  title= gsub("repeat", "", title, ignore.case= T)
  title= gsub("biological[_| ]replicate", "", title, ignore.case= T)
  title= gsub("biological", "", title, ignore.case= T)
  #just a letter or string of numbers at end- not useful in clustering
  title= gsub("[ |_][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]$", "", title)
  title= gsub("[ |_][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]$", "", title)
  title= gsub("[ |_][0-9a-zA-Z][0-9a-zA-Z]$", "", title)
  title= gsub("[ |_][0-9a-zA-Z]$", "", title)

  #thanks GSE13763... roman numerals for the sample title
  title= gsub("[\\(I\\)]", "", title)
  title= gsub("[\\(II\\)]", "", title)
  title= gsub("[\\(III\\)]", "", title)
  #parentheses - mucks clustering
  title= gsub("[(]|[)]", "_", title, ignore.case = T)

  title= gsub("rep.[a-z]$|rep.[a-z][a-z]$|rep.[a-z][a-z][a-z]$","",title, ignore.case = T)
  title= gsub("rep[a-z]$|rep[a-z][a-z]$|rep[a-z][a-z][a-z]$","",title, ignore.case = T)
  #bodge dealing with rep [0-9] sometimes appended to samples- no good for clustering.
  title= gsub("rep.[0-9]$|rep.[0-9][0-9]$|rep.[0-9][0-9][0-9]$","",title)
  title= gsub("rep[0-9]$|rep[0-9][0-9]$|rep[0-9][0-9][0-9]$","",title)
  title= gsub("replicate.[0-9][0-9]|replicate.[0-9]|replicate[0-9]", "",title, ignore.case = T) #removing replicate sample numbers- complicates clustering
  title= gsub("sample.[0-9][0-9]|sample.[0-9]|sample[0-9]", "",title, ignore.case = T)
  title= gsub("patient[0-9][0-9][0-9]", "patient", title, ignore.case = T)
  title= gsub("patient[0-9][0-9]", "patient", title, ignore.case = T)
  title= gsub("patient[0-9]", "patient", title, ignore.case = T)
  title= gsub("replica.[0-9]|replica[0-9]|replicate.[0-9]|replicate[0-9]|", "", title, ignore.case = T)
  title= gsub("replica.[a-z]|replica[a-z]|replicate.[a-z]|replicate[a-z]", "", title, ignore.case = T)
  title= gsub("replicate", "", title, ignore.case = T)
  title= gsub("duplicate", "", title, ignore.case = T)

  #These regexes are a heuristic-generally numbers at the end with spaces not useful information
  #usually shorthand for replicate numbers
  title= gsub("[_| ][0-9][0-9][0-9][0-9][_| ]|[0-9][0-9][0-9][0-9]$","", title)
  title= gsub("[_| ][0-9][0-9][0-9][0-9][_| ]|[0-9][0-9][0-9][0-9]$","", title)
  title= gsub("[_| ][0-9][0-9][0-9][_| ]|[_| ][0-9][0-9][0-9]$","", title)
  title= gsub("[_| ][0-9][0-9][_| ]|[_| ][0-9][0-9]$","", title)
  title= gsub("[_| ][0-9][_| ]|[_| ][0-9]$","", title)

  title= gsub("mir-", "mir", title, ignore.case = T)
  title= gsub(" -[0-9][0-9]$", "", title)
  title= gsub(" -[0-9]$", "", title)
  #sometimes replicates referred to 1st 2nd 3rd ect...
  title= gsub("[0-9][0-9][0-9]st", "", title)
  title= gsub("[0-9][0-9]st", "", title)
  title= gsub("[0-9]st", "", title)
  title= gsub("[0-9][0-9]2nd", "", title)
  title= gsub("[0-9]2nd", "", title)
  title= gsub("2nd", "", title)
  title= gsub("[0-9][0-9]3rd", "", title)
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
  #used when identifying controls
  title= gsub("control[0-9][0-9][0-9]", "control", title, ignore.case = T)
  title= gsub("control[0-9][0-9]", "control", title, ignore.case = T)
  title= gsub("control[0-9]", "control", title, ignore.case = T)
  title= gsub("-[0-9a-zA-Z]$", "", title)
  title= gsub("-[0-9]$", "", title)
  title= gsub("-[0-9][0-9]$", "", title)
  title= gsub("-[0-9][0-9][0-9]$", "", title)
  title= gsub("-[0-9][0-9][0-9][0-9]$", "", title)
  title= gsub("-scr[0-9][0-9]$", "_scramble", title, ignore.case = T)
  title= gsub("-scr[0-9]$", "_scramble", title, ignore.case = T)
  title= gsub("-shrna[0-9]$", "_shRNA", title, ignore.case = T)
  title= gsub("-shrna[0-9]$", "_shRNA", title, ignore.case = T)

  #board cluster combine shRNA targetting same gene as one cluster
  title= gsub("shrna[0-9]$|scr[0-9]$|scramble[0-9]$|shrna[0-9][0-9]$|scr[0-9][0-9]$|scramble[0-9][0-9]$", "", title, ignore.case= T) #assumes only 99 scramble samples
  title= gsub("kd[0-9]$|cont[0-9]$||kd[0-9][0-9]$|cont[0-9][0-9]$", "", title, ignore.case= T) #assumes only 99 contamble samples
  title= gsub("sample[0-9][0-9]", "", title, ignore.case= T)
  title= gsub("sample.[0-9]|sample[0-9]", "", title, ignore.case= T)
  title= gsub("conrol", "control", title, ignore.case = T)
  title= gsub("control.[0-9].", "control", title, ignore.case = T)#
  title= gsub("control.[0-9]", "control", title, ignore.case = T)#
  title= gsub("control[0-9]", "control", title, ignore.case = T)#

  #sometimes replicates titled #[0-9]
  title= gsub("#[0-9][0-9][0-9]", "", title)
  title= gsub("#[0-9][0-9]", "", title)
  title= gsub("#[0-9]", "", title)
  title= gsub("  |    ", " ", title)

  title= gsub("change[0-9]$", "change", title, ignore.case = T)
  title= gsub("knockdown[0-9]$", "knockdown", title, ignore.case = T)
  title= gsub("change[0-9]$", "change", title, ignore.case = T)
  title= gsub(",", "", title, ignore.case = T)
  title= gsub("rep[0-9][0-9]$", "", title, ignore.case = T)
  title= gsub("rep[0-9]$", "", title, ignore.case = T)
  title= gsub("rep[a-z]$", "", title, ignore.case = T)
  title= gsub("biological replicate [0-9]", "", title, ignore.case = T)
  title= gsub("6h E[0-9]", "6_hour", title) #thanks GSE108345 exp would make sense
  title= gsub("#[0-9]", "", title)
  title= gsub("ctrll", "control", title) #mis-spell
  title= gsub("number.[0-9][0-9]", "", title)
  title= gsub("number.[0-9]", "", title)
  title= gsub("number[0-9]", "", title)

  #bodge to deal with miRNAs- improves clustering ability
  title= gsub("mir0", "mirA", title, ignore.case = T)
  title= gsub("mir1", "mirB", title, ignore.case = T)
  title= gsub("mir2", "mirC", title, ignore.case = T)
  title= gsub("mir3", "mirD", title, ignore.case = T)
  title= gsub("mir4", "mirE", title, ignore.case = T)
  title= gsub("mir5", "mirF", title, ignore.case = T)
  title= gsub("mir6", "mirG", title, ignore.case = T)
  title= gsub("mir7", "mirH", title, ignore.case = T)
  title= gsub("mir8", "mirI", title, ignore.case = T)
  title= gsub("mir9", "mirJ", title, ignore.case = T)
  #second_regular_expression= "(day)|(week)|(ed)|(hr)(hour[0-9])?$)" #stricter regular expression gets rid of other parts which may mess up clustering.
  #if(!grepl(second_regular_expression,title, ignore.case = T)){
  #  title <- unlist(strsplit(gsub("[!a-z!0-9!A-Z][0-9a-zA-Z]{,2}$","",title), "\\,|\\_"))
  #}
  if(words_only){ # if there are pointless id numbers remove them
    #title= gsub("[a-z][0-9]", " ", title)
    title= gsub("[0-9]", "", title)
    title= paste(title,"_gsm")
  }
  #get rid of any empty spaces
  while(grepl("  |__|_ | ", title)){
    title= gsub("  |__|_ | ", "_", title)
  }
  title= gsub("^[_| ]", "", title)

  if(identical(title, character(length= 0))){ #if I cut too much from the gsub above- provide original title.
    title <- ori_title} #fail safe if gsub regexes above removes entirety of title





  title <- unlist(strsplit(gsub("\\s|\\-","_",title), "\\,|\\_"))
  title <- title[!title == ""]
  title= toupper(title)
  return(title)
  }
