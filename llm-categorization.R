# install.packages('ellmer')

responses <- read.csv('student-responses.csv')

library(ellmer)
library(tidyverse)
chat <- chat_ollama(
  model = 'llama3.1:8b',
  system_prompt = 'You are an expert qualitative research assistant. Your only goal is to provide high quality responses that exactly match the task you are given.'
)




# =========================
# 0. Setup
# =========================
library(ellmer)
library(tidyverse)
library(glue)
library(jsonlite)

responses <- read.csv("student-responses.csv")

chat <- chat_ollama(
  model = "llama3.1:8b",
  system_prompt = paste(
    "You are an expert qualitative research assistant.",
    "Follow instructions exactly and return structured outputs only."
  )
)

chat$chat()

type_response <- type_object(
  'Open-ended survey response for a single participant',
  classification = type_string('Categorizations of this response. Be brief and concise', required = F)
)

