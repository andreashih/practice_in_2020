library(dplyr)
data(nerd)

nerd %>%
  group_by(Noun, Century) %>%
  count(Noun) %>%
  ungroup() %>%
  ggplot(aes(Century, n, fill = Noun)) +
  facet_wrap(~Noun) +
  geom_col()
  
nerd %>%
  group_by(Noun, Century, Eval) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  ggplot(aes(Century, n, fill = Eval)) +
  facet_wrap(~Noun) +
  geom_bar(position = "dodge", stat = "identity")

nerd %>%
  group_by(Noun, Register, Eval) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  ggplot(aes(Register, n, fill = Eval)) +
  facet_wrap(~Noun) +
  geom_bar(position = "dodge", stat = "identity")