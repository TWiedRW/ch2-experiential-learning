library(tidyverse)

files <- list.files(pattern = '.Rdata', recursive = T)
files <- files[str_detect(files, 'emails/')]
files

files_combined <- list()
for(i in seq_along(files)) {
  load(files[i])
  files_combined[[i]] <- anonymized_responses
}

df_dirty <- files_combined %>%
  map(bind_rows, .id = 'module') %>%
  bind_rows(.id = 'section')

df_cleaner <- df_dirty %>%
  select(where(is.character), where(is.logical), attempt) %>%
  mutate(across(everything(), as.character)) %>%
  pivot_longer(cols = matches('[0-9]{1,10}'), names_to = 'question', values_to = 'response') %>%
  mutate(question = str_remove(question, '^[0-9]{1,10}: '),
         question = str_remove(question, '^X[0-9]{1,10}..')) %>%
  filter(!is.na(response)) %>%
  arrange(section, id, attempt, module, question)

semester_info <- df_cleaner %>%
  mutate(submitted = as_datetime(submitted)) %>%
  group_by(section) %>%
  summarize(mean_date = mean(submitted)) %>%
  mutate(year = year(mean_date),
         semester = case_when(
           month(mean_date) %in% 1:5 ~ 'Spring',
           month(mean_date) %in% 6:8 ~ 'Summer',
           month(mean_date) %in% 9:12 ~ 'Fall'
         )) %>%
  mutate(experiment = ifelse(year == 2025 & semester == 'Fall', 'Heat map', 'Bar chart'),
         section = as.numeric(section)) %>%
  arrange(year, semester, section) %>%
  select(-mean_date)

df_cleaner %>%
  group_by(question, id) %>%
  count() %>%
  filter(n > 1)

df_cleaner %>%
  select(-c(module, submitted)) %>%
  mutate(question = str_replace_all(question, '\\.', ' '),
         question = str_replace_all(question, '[[:punct:]]', ' '),
         question = trimws(question),
         question = str_replace_all(question, '  ', ' '),
         # question = trimws(tm::removePunctuation(question))
    ) %>%
  pivot_wider(names_from = question, values_from = response) %>%
  group_by(id) %>%
  type_convert() %>%
  filter(attempt == max(attempt)) %>%   #One participant responded twice
  filter(`As of today I am at least 19 years of age` == T & `My instructor may share my reflection responses with the researchers in this study` == 'I agree') %>%
  left_join(semester_info) %>%
  distinct() %>% #Make sure there are no duplicates since files are recursively selected
  write_csv('data/student-responses.csv')
