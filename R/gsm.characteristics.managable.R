gsm.characteristics.managable= function(characteristic){
  ori_characteristic= characteristic #ori= original
  characteristic= gsub("^    ", "", characteristic) #could while loop the substr(characteristic, 1, 1) != " "- too slow need to bool check every cycle
  characteristic= gsub("^   ", "", characteristic)
  characteristic= gsub("^ ", "", characteristic)
  characteristic= gsub("rep.[0-9]|rep[0-9][0-9]|rep[0-9][0-9][0-9]$","",characteristic) #bodge dealing with rep [0-9] sometimes appended to samples- no good for clustering.
  characteristic= gsub("rep[0-9]|rep[0-9][0-9]|rep[0-9][0-9][0-9]$","",characteristic)
  characteristic= gsub("[0-9]$|[0-9][0-9]$|[0-9][0-9][0-9]$","",characteristic)
  characteristic= gsub("ctrll", "control", characteristic)
  characteristic= gsub("duplicate", "", characteristic)
  characteristic= gsub("number.[0-9][0-9]", "", characteristic)
  characteristic= gsub("number.[0-9]", "", characteristic)
  characteristic= gsub("number[0-9]", "", characteristic)


  characteristic= gsub("replicate.[0-9][0-9]|replicate.[0-9]|replicate[0-9]", "",characteristic, ignore.case = T) #removing replicate sample numbers- complicates clustering
  characteristic= gsub("sample.[0-9][0-9]|sample.[0-9]|sample[0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("patient[0-9][0-9][0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("patient [0-9][0-9][0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("patient[0-9][0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("patient [0-9][0-9]|patient [0-9]|patient[0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("project.[0-9][0-9]|project.[0-9]|project[0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("^    ", "", characteristic)
  characteristic= gsub("^   ", "", characteristic)
  characteristic= gsub("^ ", "", characteristic)
  characteristic= gsub("experiment[0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("experiment.[0-9][0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("experiment.[0-9]", "",characteristic, ignore.case = T)
  characteristic= gsub("[(]|[)]", "", characteristic, ignore.case = T)
  characteristic= gsub("^[0-9] |^[0-9][0-9] |^[0-9][0-9][0-9] ", "", characteristic, ignore.case = T)
  characteristic= gsub("Conrol", "Control", characteristic)
  characteristic= gsub("conrol", "control", characteristic)
  characteristic= gsub("#[0-9][0-9]", "", characteristic)
  characteristic= gsub("#[0-9][ |_]|#[0-9]$", "", characteristic)
  characteristic= gsub("-[0-9]$", "", characteristic)
  characteristic= gsub("-[0-9][0-9]$", "", characteristic)
  characteristic= gsub("-[0-9][0-9][0-9]$", "", characteristic)
  characteristic= gsub("-[0-9][0-9][0-9][0-9]$", "", characteristic)
  characteristic= gsub("shrna[0-9]$|scr[0-9]$|scramble[0-9]$|shrna[0-9][0-9]$|scr[0-9][0-9]$|scramble[0-9][0-9]$", "", characteristic, ignore.case= T) #assumes only 99 scramble samples
  characteristic= gsub("kd[0-9]$|cont[0-9]$||kd[0-9][0-9]$|cont[0-9][0-9]$", "", characteristic, ignore.case= T)
  characteristic= gsub("  |    ", " ", characteristic)
  #replicates sometimes refered to letter at end
  characteristic= gsub("[-|_| ][0-9a-z]$", "", characteristic, ignore.case= T)

  characteristic= unlist(strsplit(gsub("\\s|\\-","_",characteristic), "\\,|\\_"))
  if(identical(characteristic, character(length= 0))){
    characteristic <- ori_characteristic;
    characteristic= unlist(strsplit(gsub("\\s|\\-","_",characteristic), "\\,|\\_"))
    } #fail safe if gsub removes entirety of characteristic string
  characteristic= toupper(characteristic)
  return(characteristic)
}
