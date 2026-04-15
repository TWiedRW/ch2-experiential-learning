library(tidyverse)
library(stringr)

# Function to create meaningful labels from topic terms
create_clean_label <- function(keybert_str) {
  if(is.na(keybert_str) || keybert_str == "") {
    return("Uncategorized")
  }
  
  # Extract all quoted terms
  terms <- str_extract_all(keybert_str, "'([^']+)'")[[1]]
  terms <- str_remove_all(terms, "'")
  
  # Filter out unhelpful short terms and overly common words
  terms <- terms[nchar(terms) > 3]
  terms <- terms[!str_detect(terms, "^(the|and|think|like|they|just|very|what|from|more|some|this)$")]
  
  # Take top 2-3 terms
  key_terms <- terms[1:min(3, length(terms))]
  
  # Remove duplicates
  key_terms <- unique(key_terms)
  
  if(length(key_terms) == 0) {
    return("General topics")
  }
  
  # Create readable label
  label <- str_to_title(paste(key_terms, collapse = " + "))
  return(label)
}

# Process all questions
all_labels <- tibble()

for(q_num in 1:11) {
  file_path <- glue::glue("data/bertopic_exports/per_question/q{q_num}/topic_info.csv")
  
  if(file.exists(file_path)) {
    data <- read_csv(file_path, 
                     col_types = cols(
                       Topic = col_character(),
                       Count = col_character(),
                       KeyBERT = col_character(),
                       .default = col_skip()
                     ))
    
    labels_df <- data %>%
      mutate(
        Question = paste0("Q", q_num),
        Topic_ID = as.numeric(Topic),
        Response_Count = as.numeric(Count),
        Label = sapply(KeyBERT, create_clean_label, USE.NAMES = FALSE)
      ) %>%
      select(Question, Topic_ID, Response_Count, Label) %>%
      arrange(Topic_ID)
    
    all_labels <- bind_rows(all_labels, labels_df)
  }
}

# Print formatted output
cat("\n")
cat(strrep("═", 115), "\n")
cat("BERTopic TOPIC LABELS - All Questions\n")
cat(strrep("═", 115), "\n\n")

for(q_num in 1:11) {
  q <- paste0("Q", q_num)
  q_data <- all_labels %>% 
    filter(Question == q) %>% 
    arrange(Topic_ID)
  
  if(nrow(q_data) > 0) {
    cat(sprintf("%s\n", q))
    cat(strrep("─", 115), "\n")
    
    for(i in 1:nrow(q_data)) {
      row <- q_data[i, ]
      
      if(row$Topic_ID == -1) {
        topic_label <- "⊗ OUTLIERS"
      } else {
        topic_label <- sprintf("Topic %2.0f  ", row$Topic_ID)
      }
      
      cat(sprintf("  %s  (n=%3.0f)  %s\n", topic_label, row$Response_Count, row$Label))
    }
    cat("\n")
  }
}

cat(strrep("═", 115), "\n\n")

# Save to CSV
write_csv(all_labels, "data/topic_labels.csv")

cat("✓ Labels saved to: data/topic_labels.csv\n\n")

# Also print as a simple reference table
cat("QUICK REFERENCE TABLE\n")
cat(strrep("─", 115), "\n")
wide_labels <- all_labels %>%
  pivot_wider(
    names_from = Question,
    values_from = Label,
    values_fill = "---"
  ) %>%
  rename("Topic_ID" = "Topic_ID")

print(wide_labels)
