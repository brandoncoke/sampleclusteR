manual.exp.sets= function(groups, combined_table= combined_table){
  end_loop= "n"
  output= list(c(NA)) #as you cant for loop on a empty list
  while(!(tolower(end_loop) %in% c("y","yes","ye","t","tru","true"))){
    print(cbind(combined_table[,1:3], groups))
    CTRL_select= readline(prompt=paste0("Select a control group from 1 to ",max(groups),": "))
    while(!(CTRL_select %in% unique(groups))){ #wont stop bugging user until they provide a valid group
      print(cbind(combined_table[,1:3], groups))
      CTRL_select= readline(prompt=paste0("Select a control group from 1 to ",max(groups),": "))
    }
    non_CTRL= unique(groups)
    non_CTRL[non_CTRL != CTRL_select]
    print(cbind(combined_table[,1:3], groups))
    treated_samples= readline(prompt="Select treated samples like 2 3 4: ")
    treated_samples
    treated_samples= gsub("[',']|[A-Z]|[a-z]", "", treated_samples) #formatting response to valid format
    treated_samples= unlist((strsplit(treated_samples, " ")))
    treated_samples= as.numeric(treated_samples)
    treated_samples= treated_samples[!is.na(treated_samples)]
    treated_samples= treated_samples[treated_samples != CTRL_select]
    treated_samples= treated_samples[treated_samples %in% non_CTRL]
    while(!(any(treated_samples %in% non_CTRL))){
      print(cbind(combined_table[,1:3], groups))
      treated_samples= readline(prompt="Select treated samples like 2 3 4: ")
      treated_samples= gsub("[',']|[A-Z]|[a-z]", "", treated_samples) #readline provides string- need to convert to numeric list
      treated_samples= as.list((strsplit(treated_samples, " ")))
      treated_samples= as.numeric(treated_samples)
      treated_samples= treated_samples[!is.na(treated_samples)]
      treated_samples= treated_samples[treated_samples != CTRL_select]
      treated_samples= treated_samples[treated_samples %in% non_CTRL]
    }


    a_perm= groups
    a_perm[a_perm == CTRL_select]= 0 #as when I get the files ready i need to set CTRL samples as 0
    ori_perm= a_perm
    for(i in 1:length(treated_samples)){
      a_perm= ori_perm
      a_perm[a_perm == treated_samples[i]]= "N" #temp value as need to turn to 1 after for list
      a_perm[!(a_perm %in% c("0","N"))]= "X"
      a_perm[a_perm == "N"]= "1" #treated assigned with a 1 char
      a_perm= paste0(a_perm, collapse = "")
      output= c(output, a_perm)
    }
    end_loop= readline(prompt="Are you done assigning control and treated samples? Please answer yes or no.")
    while(!(tolower(end_loop) %in% c("y","yes","ye","n","no","nope","nop","t","tru","true","f", "false", "fal", "fa", "fals"))){ #drops loop only when no given
      end_loop= readline(prompt="Please answer yes or no. Are you done assigning control and treated samples? Invalid response provided.")
    }
  }
  output= output[!is.na(output)] #see line 3 gets rid of NA
  output= unique(output)
  temp= unlist(output) #gets rid of redundant combinations where treated and control flipped
  output[!duplicated(gsub("0|1", "A", temp))] #one way of doing it convert 0 (CTRL) and treated (1) to A then !duplicated

  return(output)
}
