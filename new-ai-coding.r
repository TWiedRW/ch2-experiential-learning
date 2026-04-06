responses <- read.csv('student-responses.csv')

library(ellmer)
library(tidyverse)
library(glue)
library(wordcloud2)
library(tidytext)
chat <- chat_ollama(
  model = 'mistral'
)


names(responses)

##### Pre-Experiment Reflection #####

# Step 1: Word Cloud
responses %>%
  rename(q1 = 14) %>%
  unnest_tokens(output = word, input = q1) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  wordcloud2()


# Step 2: n-grams
responses %>%
  rename(q1 = 14) %>%
  unnest_tokens(output = bigram, input = q1, token = 'ngrams', n = 3) %>%
  anti_join(stop_words, by = c('bigram' = 'word')) %>%
  count(bigram, sort = TRUE) %>%
  filter(n > 1) %>%
  wordcloud2()


# Step 3: LDA Topic Modeling
library(topicmodels)
library(tm)
lda_responses <- responses %>%
  rename(q1 = 14) %>%
  mutate(student_id = row_number()) %>%
  unnest_tokens(output = word, input = q1) %>%
  anti_join(stop_words) %>%
  count(student_id, word) %>%
  cast_dtm(student_id, word, n)

lda_model <- LDA(lda_responses, k = 2, control = list(seed = 1234))

tidy(lda_model, matrix = 'beta')

topics <- tidy(lda_model, matrix = "beta")

top_terms <- topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup()

ggplot(top_terms, aes(x = reorder_within(term, beta, topic),
                      y = beta,
                      fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_x_reordered() +
  labs(title = "Top Terms per Topic",
       x = "Term",
       y = "Beta (Probability)") +
  coord_flip()


# Step 4: LLM Topic Extraction
ai_q1 <- chat$chat(
  glue(
    "You are an expert in quantitative research methods. A survey was conducted with the question: 
    'What do you think the process of scientific investitation looks like from the perspective of a researcher compared to what it looks like from the perspective of someone in the gneral public who is a consumer of scientific results. 
    Write a paragraph about how you think science happens.' 
    The responses are provided below, separated by ' ||||| ' for each response. 
    Create a concise list of 5-15 themes that emerge from these responses.
    Only provide the list of themes, do not provide any additional commentary or explanation.
    Separate each theme with a comma and a space. 
    For example, if the themes were 'theme1', 'theme2', and 'theme3', you would respond with: 'theme1, theme2, theme3'.

    Responses: {q1}
    "
  )
)

# Step 5: LLM Classification



