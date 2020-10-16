library(readr)
library(dplyr)
library(tidyr)
rang_sketcheg <- read_csv("C:/Users/user/Desktop/rang_sketcheg.csv")
shi_sketcheg <- read_csv("C:/Users/user/Desktop/shi_sketcheg.csv")

rang_sketcheg %>%
  filter(MentalS == 1 | MentalS == 0) %>%
  mutate(ResuPred = ifelse(ResuPred == "rang", "<讓>"), 
         Resource = "Sketch Engine (zhTenTen)") %>%
  rename(Causer = Subj, Causee = Obj) %>%
  unite("Sentence", pre:post, sep = " ", remove = FALSE) %>%
  select(ResuPred, Sentence, Causer, MentalS, Causee, MentalO, Property, Transitivity, Varieties, Resource)-> rang_sketcheg_a
  
shi_sketcheg %>%
  filter(MentalS == 1 | MentalS == 0) %>%
  mutate(ResuPred = ifelse(ResuPred == "shi", "<使>"), 
         Resource = "ASBC") %>%
  rename(Causer = Subj, Causee = Obj) %>%
  unite("Sentence", pre:post, sep = " ", remove = FALSE) %>%
  select(ResuPred, Sentence, Causer, MentalS, Causee, MentalO, Property, Transitivity, Varieties, Resource)-> shi_sketcheg_a

###################

rang_asbc <- read_csv("C:/Users/user/Desktop/rang_asbc.csv")
shi_asbc <- read_csv("C:/Users/user/Desktop/shi_asbc.csv")

rang_asbc %>%
  filter(MentalS == 1 | MentalS == 0) %>%
  mutate(ResuPred = ifelse(ResuPred == "rang", "<讓>"), 
         Resource = "ASBC") %>%
  rename(Sentence = sentence, Causer = Subj, Causee = Obj) %>%
  select(ResuPred, Sentence, Causer, MentalS, Causee, MentalO, Property, Transitivity, Varieties, Resource)-> rang_asbc_a

shi_asbc %>%
  filter(MentalS == 1 | MentalS == 0) %>%
  mutate(ResuPred = ifelse(ResuPred == "shi", "<使>"), 
         Resource = "ASBC") %>%
  rename(Sentence = sentence, Causer = Subj, Causee = Obj) %>%
  select(ResuPred, Sentence, Causer, MentalS, Causee, MentalO, Property, Transitivity, Varieties, Resource)-> shi_asbc_a

shi_rang_data <- bind_rows(shi_asbc_a, shi_sketcheg_a, rang_asbc_a, rang_sketcheg_a)

shi_rang_data %>%
  mutate(ResuPred = ifelse(ResuPred == "<讓>", "讓", "使")) -> shi_rang_data

write.csv(shi_rang_data, "shi_rang_data.csv")  
  





