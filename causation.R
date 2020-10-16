library(readr)
library(stringr)
library(tidyverse)
library(Rling); library(rms); library(visreg); library(car)

# Clean up the dataset from sketch engine

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

# Merge the four datasets

rang_cht <- read_csv("rang_cht.csv")
shi_cht <- read_csv("shi_cht.csv")
rang_chs <- read_csv("rang_chs.csv")
shi_chs <- read_csv("shi_chs.csv")

shi_chs <- head(shi_chs, 201)

rang_chs <- head(rang_chs, 201)

causation_chs <- rbind(shi_chs, rang_chs) %>%
  filter(MentalS %in% c(1, 0)) %>%
  select(ResuPred, Property, Transitivity, Varieties)

shi_cht <- head(shi_cht, 201) %>%
  mutate(ResuPred = "shi")

rang_cht <- head(rang_cht, 201)

causation_cht <- rbind(shi_cht, rang_cht) %>%
  filter(MentalS %in% c(1, 0)) %>%
  select(ResuPred, Property, Transitivity, Varieties)

causation_all <- rbind(causation_chs, causation_cht) 
causation_all <- na.omit(causation_all)

write_csv(causation_all, "C:\\Users\\user\\Desktop\\practice_in_2020\\causation_all.csv")

###############################
library(mgcv)

causation <- read_csv("C:/Users/user/Desktop/practice_in_2020/causation_all.csv")

causation$ResuPred <- factor(causation$ResuPred)
causation$Property <- factor(causation$Property)
causation$Transitivity <- factor(causation$Transitivity)
causation$Varieties <- factor(causation$Varieties)

m.lrm <- lrm(ResuPred ~ Property + Transitivity + Varieties, data = causation)

rms::vif(m.lrm)

m.test()

m.lrm1 <- lrm(ResuPred ~ Property + Transitivity + Varieties, data = causation, 
              x = T, y = T)

validate(m.lrm1, B = 200)

s <- sample(455, 100)
d.small <- causation[s, ]
m.lrm1.small <- lrm(ResuPred ~ Property + Transitivity + Varieties, data = d.small, 
                    x = T, y = T)
validate(m.lrm1.small, B = 200)

##########

causation_sample <- causation %>% sample_frac(.8)

m.lrm <- lrm(ResuPred ~ Property + Transitivity + Varieties, data = causation_sample)
m.lrm
