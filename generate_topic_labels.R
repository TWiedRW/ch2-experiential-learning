library(tidyverse)
library(stringr)

# Path to topic info files  
base_path <- "data/bertopic_exports/per_question/"

# Function to extract terms from KeyBERT representation
extract_keybert_terms <- function(keybert_str) {
  # Parse KeyBERT field which is a string with pairs like "'term1', 'term2'"
  terms <- str_extract_all(keybert_str, "'([^']+)'")[[1]]
  # Remove the quotes
  terms <- str_remove_all(terms, "'")
  return(terms[1:4])  # Get top 4 terms
}

# Function to create a meaningful label
create_label <- function(terms) {
  if(length(terms) == 0) return("Uncategorized")
  
  # Filter out very short or common terms
  terms <- terms[nchar(terms) > 2]
  
  if(length(terms) == 0) return("General response")
  
  # Take top 2-3 terms and create label
  label <- paste(terms[1:min(3, length(terms))], collapse = " + ")
  return(label)
}

# Collect all topics
all_topics_list <- list()

for(q_num in 1:11) {
  file_path <- glue::glue("{base_path}q{q_num}/topic_info.csv")
  
  if(file.exists(file_path)) {
    # Read just the needed columns
    data <- read_csv(file_path, col_types = cols(
      Topic = col_character(),
      Count = col_character(),
      KeyBERT = col_character(),
      .default = col_skip()
    ))
    
    # Create labels
    labels_df <- data %>%
      mutate(
        Question = paste0("Q", q_num),
        Topic_ID = as.numeric(Topic),
        Response_Count = as.numeric(Count),
        Label = sapply(KeyBERT, create_label)
      ) %>%
      select(Question, Topic_ID, Response_Count, Label) %>%
      arrange(Topic_ID)
    
    all_topics_list[[q_num]] <- labels_df
  }
}

# Combine into single dataframe
all_topics <- bind_rows(all_topics_list)

# Print formatted output
cat("\n")
cat(strrep("=", 100), "\n")
cat("BERTOPIC LABELS BY QUESTION\n")
cat(strrep("=", 100), "\n\n")

for(q in paste0("Q", 1:11)) {
  q_data <- all_topics %>% filter(Question == q) %>% arrange(Topic_ID)
  
  if(nrow(q_data) > 0) {
    cat(q, "\n")
    cat(strrep("-", 100), "\n")
    
    for(i in 1:nrow(q_data)) {
      row <- q_data[i, ]
      
      if(row$Topic_ID == -1) {
        marker <- "⊗ OUTLIERS    "
      } else {
        marker <- sprintf("  Topic %2.0f    ", row$Topic_ID)
      }
      
      cat(sprintf("%s (n=%3.0f):  %s\n", marker, row$Response_Count, row$Label))
    }
    cat("\n")
  }
}

# Save to CSV
output_df <- all_topics %>%
  mutate(
    Topic_ID = as.integer(Topic_ID),
    Response_Count = as.integer(Response_Count)
  )

write_csv(output_df, "data/topic_labels.csv")

cat(strrep("=", 100), "\n")
cat("Labels saved to: data/topic_labels.csv\n")
cat(strrep("=", 100), "\n\n")
