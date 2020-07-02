library(readr)
library(stringr)
library(dplyr)

concord_shi <- read_csv("causation_sketch_engine_shi.csv")

concord_rang <- read_csv("causation_sketch_engine_rang.csv", 
                        col_names = FALSE, skip = 4)

concord_shi2 <- concord_shi %>%
  mutate(pre = sapply(str_split(pre, "</s><s>"), tail, 1), 
         post = sapply(str_split(post, "</s><s>"), head, 1))

concord_rang2 <- concord_rang %>%
  mutate(X2 = sapply(str_split(X2, "</s><s>"), tail, 1), 
         X4 = sapply(str_split(X4, "</s><s>"), head, 1))

write_csv(concord_shi2, "C:\\Users\\user\\Desktop\\practice_in_2020\\concord_shi.csv")

write_csv(concord_rang2, "C:\\Users\\user\\Desktop\\practice_in_2020\\concord_rang.csv")


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

get_actor(concord_rang$X2, "(?<=(/NN|/NR))[^(/N)]+(?=(/NN|/NR))")

