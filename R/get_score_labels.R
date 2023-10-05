get_score_labels= function(sample_names){
  up_reg_labels = c("overexp", "express", "transgen", "expos", "tg", "induc",
                    "stim", "treated", "transfected", "overexpression",
                    "transformed", "tumor", "tomour"
  )
  down_reg_labels <- c("knock", "null",
                       "s[hi]rna",
                       "delet",
                       "si[a-zA-z]",
                       "reduc",
                       "kd",
                       "\\-\\/",
                       "\\/\\-",
                       "\\+\\/", "\\/\\+",
                       "cre", "flox",
                       "mut",
                       "defici",
                       "[_| ]ko[_| ]|[_| ]ko$")
  control_labels <- c("untreat", "_ns_",
                      "normal",
                      "gfp",
                      "vehicle",
                      "sensitive",
                      "stable",
                      "ctrl",
                      "non.sense",
                      "nonsense",
                      "baseline",
                      "mock",
                      "_luc_|_luc",
                      "siluc",
                      "wildtype|wild.type",
                      "nontreat",
                      "non.treated",
                      "control",
                      "ctrl",
                      "untreated",
                      "no.treat",
                      "undosed",
                      "untransfected",
                      "mir.nc",
                      "minc",
                      "_non_|^non_",
                      "scramble",
                      "lucif",
                      "parent",
                      "free.medi",
                      "untransfected",
                      "ntc",
                      "mirNC")
  label_score= rep(0, length(sample_names))
  label_score[grepl(paste(up_reg_labels, collapse = "|"), sample_names,
                    ignore.case = T)]= 1
  label_score[grepl(paste(down_reg_labels, collapse = "|"), sample_names,
                    ignore.case = T)]= 2
  label_score[grepl(paste(control_labels, collapse = "|"), sample_names,
                    ignore.case = T)]= 0
  return(label_score)
}
