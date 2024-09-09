library(tidyverse)

files <- list.files(pattern = '.Rdata', recursive = T)

for(i in 1:length(files)){
  load(files[i])
  print(as.numeric(map(anonymized_responses, nrow)))
}



res <- list()
for(i in 1:length(files)){
  load(files[i])
  res[[i]] <- anonymized_responses
}

map(res, bind_rows, .id = 'module') %>%
  bind_rows(.id = 'instructor') %>%
  janitor::clean_names() %>%
  mutate(across(everything(), as.character)) %>%
  select(-c(submitted, module)) %>%
  pivot_longer(cols = -c(instructor, id, section_sis_id), names_to = 'question') %>%
  filter(str_detect(question, '^x[0-9]{7}')) %>%
  mutate(question = str_remove(question, '^x[0-9]{7}_')) %>%
  filter(!is.na(value)) -> long


results <- long %>%
  pivot_wider(names_from = question, values_from = value) %>%
  filter(my_instructor_may_share_my_reflection_responses_with_the_researchers_in_this_study == 'I agree',
         as_of_today_i_am_at_least_19_years_of_age == 'TRUE')
write.csv(results, 'data/graphics218-allresponses.csv',
          row.names = F)




