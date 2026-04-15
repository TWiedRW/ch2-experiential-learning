library(tidyverse)
library(stringr)

# Custom mapping: More human-sounding labels based on topic content
topic_labels_human <- tribble(
  # Q1: Pre-Experiment Reflection
  ~question, ~topic_id, ~human_label,
  "Q1", -1, "General reflections on scientific investigation",
  "Q1", 0, "Contrasting researcher vs public understanding",
  "Q1", 1, "Individual perspectives on research steps",
  "Q1", 2, "Systematic research process and peer review",
  "Q1", 3, "Science as discovery vs consumption",
  "Q1", 4, "How researchers conduct investigations",
  "Q1", 5, "Hypotheses, testing, and evidence-based science",
  "Q1", 6, "Rigorous scientific methodology",
  "Q1", 7, "Research methodology and hypothesis formation",
  "Q1", 8, "Researcher approach to scientific questions",
  "Q1", 9, "Conducting and sharing research",
  "Q1", 10, "Scientific research as a formal process",
  
  # Q2: Purpose of experiment
  "Q2", -1, "General thoughts on depth and perception",
  "Q2", 0, "Testing how students understand experiments",
  "Q2", 1, "Interpreting graphs and visualizing data",
  "Q2", 2, "Understanding differences in how things appear",
  "Q2", 3, "Comparing bar graphs across conditions",
  "Q2", 4, "Testing experimental differences",
  "Q2", 5, "Comparing 2D and 3D chart formats",
  "Q2", 6, "How perception affects size judgment",
  
  # Q3: Hypotheses being tested
  "Q3", -1, "Describing bar graph properties",
  "Q3", 0, "Testing how people judge sizes and differences",
  "Q3", 1, "Comparing 2D vs 3D graph perception",
  "Q3", 2, "Precise measurement of bar relationships",
  "Q3", 3, "Statistical testing concepts",
  "Q3", 4, "Formal hypothesis testing terminology",
  "Q3", 5, "Student accuracy in graph reading",
  
  # Q4: Sources of error
  "Q4", -1, "General errors in experiments",
  "Q4", 0, "Sample size and measurement validity",
  "Q4", 1, "Physical aspects of 3D materials",
  "Q4", 2, "Graph-related measurement issues",
  "Q4", 3, "Human perception and measurement accuracy",
  "Q4", 4, "Sampling bias and random error",
  "Q4", 5, "Data variability across participants",
  "Q4", 6, "Visual ability and eyesight limitations",
  "Q4", 7, "Individual differences in perception",
  
  # Q5: Variables examined
  "Q5", -1, "Mixing quantitative and categorical concepts",
  "Q5", 0, "Identifying quantitative variables in graphs",
  "Q5", 1, "Bar height as quantitative variable",
  "Q5", 2, "Size comparing as quantitative measure",
  "Q5", 3, "Mixed quantitative and categorical variables",
  "Q5", 4, "Graph types and quantitative data",
  "Q5", 5, "Variable classification in the experiment",
  "Q5", 6, "Categorical and quantitative distinctions",
  "Q5", 7, "Student responses to category questions",
  "Q5", 8, "Type of chart and numerical ratios",
  "Q5", 9, "Demographic characteristics as categorical",
  
  # Q6: Experimental design elements
  "Q6", -1, "Design features and randomization methods",
  "Q6", 0, "Control groups and experimental treatments",
  "Q6", 1, "How randomization was implemented",
  "Q6", 2, "Randomization in student assignments",
  "Q6", 3, "Randomization in experiment setup",
  "Q6", 4, "Random selection from blocks/kits",
  "Q6", 5, "Chart types in the experiment",
  "Q6", 6, "Selection through random assignment",
  "Q6", 7, "Random sampling procedures",
  "Q6", 8, "Treatment effects and experimental validity",
  "Q6", 9, "Randomization in participant grouping",
  
  # Q7: Abstract reflection - what's clearer
  "Q7", -1, "General commentary on graphics",
  "Q7", 0, "Now understand the experiment's purpose",
  "Q7", 1, "3D visualization and representation",
  "Q7", 2, "Depth perception in 3D designs",
  "Q7", 3, "Comparing 2D vs 3D charts",
  "Q7", 4, "Reading and interpreting experimental graphs",
  "Q7", 5, "Different chart formats compared",
  "Q7", 6, "Understanding data from graphs",
  "Q7", 7, "Physical 3D printed models",
  "Q7", 8, "Purpose and significance of experiment",
  "Q7", 9, "Design benefits for accessibility",
  
  # Q8: How components differed
  "Q8", -1, "Reflections on learning progression",
  "Q8", 0, "Visual differences between 2D and 3D",
  "Q8", 1, "Design elements across components",
  "Q8", 2, "Pre and post-study design understanding",
  "Q8", 3, "Information gain from different formats",
  "Q8", 4, "How each project component added value",
  "Q8", 5, "Participation vs. reading components",
  "Q8", 6, "Abstract vs. presentation format",
  "Q8", 7, "Project helped with learning",
  "Q8", 8, "Presentation provided new insights",
  "Q8", 9, "Noticed differences between methods",
  "Q8", 10, "Key findings and broader implications",
  
  # Q9: Emphasized in presentation vs abstract
  "Q9", -1, "Uncommon topic",
  "Q9", 0, "Presentation and abstract covered similar content",
  "Q9", 1, "Presentation added emphasis and detail",
  "Q9", 2, "Presentation format with visual aids",
  
  # Q10: Study critiques and improvements
  "Q10", -1, "Purpose and study participation comments",
  "Q10", 0, "Critiques of results and methodology",
  "Q10", 1, "Study design could be improved",
  "Q10", 2, "Study population and sample issues",
  "Q10", 3, "Study methodology and data collection",
  "Q10", 4, "Sample size and generalizability",
  
  # Q11: Preference - abstract or presentation?
  "Q11", -1, "Rare response",
  "Q11", 0, "Prefer the extended abstract format",
  "Q11", 1, "Presentation explained better",
  "Q11", 2, "Prefer watching the presentation",
  "Q11", 3, "Mixed preference between formats",
  "Q11", 4, "Presentation helps with learning"
)

# Read original labels
original_labels <- read_csv("data/topic_labels.csv")

# Join with human labels
updated_labels <- original_labels %>%
  left_join(topic_labels_human, by = c("Question" = "question", "Topic_ID" = "topic_id")) %>%
  mutate(Label = coalesce(human_label, Label)) %>%
  select(Question, Topic_ID, Response_Count, Label)

# Save updated version
write_csv(updated_labels, "data/topic_labels.csv")

# Print for review
cat("\n")
cat(strrep("═", 120), "\n")
cat("HUMAN-READABLE BERTOPIC LABELS - IMPROVED VERSION\n")
cat(strrep("═", 120), "\n\n")

for(q_num in 1:11) {
  q <- paste0("Q", q_num)
  q_data <- updated_labels %>% 
    filter(Question == q) %>% 
    arrange(Topic_ID)
  
  if(nrow(q_data) > 0) {
    cat(sprintf("%s\n", q))
    cat(strrep("─", 120), "\n")
    
    for(i in 1:nrow(q_data)) {
      row <- q_data[i, ]
      
      if(row$Topic_ID == -1) {
        topic_label <- "⊗ Outliers"
      } else {
        topic_label <- sprintf("Topic %2.0f  ", row$Topic_ID)
      }
      
      cat(sprintf("  %s  (n=%3.0f)  %s\n", topic_label, row$Response_Count, row$Label))
    }
    cat("\n")
  }
}

cat(strrep("═", 120), "\n")
cat("✓ Updated labels saved to: data/topic_labels.csv\n\n")
