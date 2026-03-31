library(tidyverse)
library(ellmer)


# Read responses
responses <- read.csv('student-responses.csv')
names(responses)

questions <- responses[,c(5,9:18)]
names(questions)

# Function to output AI text
generate_ai_categories <- function(question_text, responses) {
  response_text <- paste(responses, collapse = ' ||| ')
  ai_prompt <- sprintf(
    '
You are an expert research assistant specializing in quantitative and qualitative data analysis. Your task is to create 5–10 concise categories from the survey responses provided.

Rules for output:
- Output ONLY a comma-separated list of categories.
- Each category should be 1–6 words long.
- Merge responses with similar meaning into one category.
- Avoid duplicates or overlapping categories.

Negative instructions (do NOT do any of these):
- Do not provide explanations or reasoning.
- Do not include numbering, bullets, headers, or extra text.
- Do not include examples in the output.
- Do not use line breaks in the output.
- Do not invent categories that are not supported by the responses.

Survey responses (each response separated by three vertical bars): %s
    ',
    response_text
  )

  ai_response <- chat$chat(ai_prompt)

  return(data.frame(
    question = question_text,
    response = as.character(ai_response)
  ))
}

# generate_ai_categories('abstract_reflection', questions$What.components.of.the.experiment.are.clearer.now.than.they.were.as.a.participant.What.questions.do.you.still.have.for.the.experimenter.Write.3.5.sentences.reflecting.on.the.abstract)

# Loop to collect repeated results across all questions
ai_results <- data.frame()
for(i in 1:ncol(questions)) {
  for(j in 1:20) {

    chat <- chat_ollama(
      system_prompt = 'You are a research assistant. Provide concise, high-quality responses exactly as instructed. Do not deviate from the user prompt.',
      model = 'llama3',
      params = list(temperature = 0.05)
    )

    time_start <- Sys.time()
    tmp_df <- generate_ai_categories(names(questions)[i], questions[,i])
    time_end <- Sys.time()
    tmp_df$iter <- j
    tmp_df$time_start <- time_start
    tmp_df$time_end <- time_end

    rm(chat)

    ai_results <- bind_rows(ai_results, tmp_df)
  }
}

write.csv(ai_results, file = 'ai_results.csv')


hist(as.numeric(ai_results$time_end - ai_results$time_start),
     breaks = seq(40, 75, by = 1))
