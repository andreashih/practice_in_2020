library(readr)
library(stringr)
library(dplyr)

concord_shi <- read_csv("concord_shi.csv", 
                        col_names = FALSE, skip = 4)

concord_rang <- read_csv("concord_rang.csv", 
                        col_names = FALSE, skip = 4)

concord_rang %>%
  filter(str_detect(X2, "^[，。][^(，|。)]+/N[^(，|。)]+$")) -> a

head(str_extract(concord_rang$X2, "(?<=(/NN|/NR))[^(/N)]+(?=(/NN|/NR))"))
head(str_extract(concord_rang$X4, "(?<=(/NN|/NR))[^(/N)]+(?=(/NN|/NR))"))
concord_rang$X2[1]


get_actor <- function(left_context, actor_pat) {
  left_context = stringr::str_split(left_context, " +")
  left_context = left_context[[1]]
  
  left_context_rev = rev(left_context)
  for (i in seq_along(left_context_rev)) {
    if (str_detect(left_context_rev[i], "/N[NR]")) 
      break
  }
}

