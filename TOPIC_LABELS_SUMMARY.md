# BERTopic Labels Summary

This document provides human-readable labels for all topics identified by BERTopic analysis across 11 survey questions.

## Overview

- **Total Questions**: 11 (Q1-Q11)
- **Total Topics**: 90 topics across all questions
- **Outlier Topic (-1)**: Responses that don't fit well into any identified topic cluster

The labels are derived from the top 3 KeyBERT terms for each topic, which represent the most salient concepts within that cluster.

---

## Methodology: Label Creation and Justification

### Data Source
Topic labels were derived from BERTopic analyses performed on raw student responses. For each topic, BERTopic generated multiple representations of the topic's core concepts:
- **KeyBERT representation**: Terms ranked by semantic relevance to the cluster
- **Maximal Marginal Relevance (MMR) representation**: Terms maximizing diversity within the topic
- **Part-of-Speech (POS) representation**: Grammatically-informed term extraction

### Label Generation Process

The label creation followed a three-stage process:

#### Stage 1: Term Extraction
For each topic, the top 3-4 KeyBERT terms were extracted from BERTopic's output. KeyBERT was selected as the primary representation method because:
- It ranks terms by their semantic centrality to the topic cluster
- It balances specificity with interpretability
- It captures multi-word phrases (e.g., "3D graphs", "sample size") that better represent thematic content than single words

#### Stage 2: Semantic Interpretation
Rather than concatenating raw terms (which produced outputs like "Measurement Errors + Measurement + Perception Differences"), the research team interpreted the underlying semantic meaning of the term set to create a single coherent label. This interpretation considered:

1. **Semantic relationships between terms**: How do the terms relate conceptually?
2. **Question context**: What does this cluster represent in the context of the original survey prompt?
3. **Student response patterns**: What are students actually discussing in this cluster?
4. **Conceptual clarity**: Can this label be understood by someone unfamiliar with the raw data?

#### Stage 3: Validation and Refinement
Labels were refined through iterative review by the research team, considering:
- **Accuracy**: Does the label faithfully represent the topic content?
- **Readability**: Is the label comprehensible and clear?
- **Specificity**: Is the label specific enough to distinguish this topic from others?
- **Brevity**: Is the label concise enough for easy reference?

### Labeling Criteria

Each label was assigned using these explicit criteria:

| Criterion | Description |
|-----------|-------------|
| **Human-interpretable** | Label reads like how a human researcher would describe the topic|
| **Semantically faithful** | Label accurately represents the constellation of KeyBERT terms |
| **Context-aware** | Label acknowledges the specific survey question being answered |
| **Discriminative** | Label distinguishes this topic from other topics in the same question |
| **Concise** | Label is short enough to serve as a quick descriptor (typically 4-10 words) |

### Examples of the Labeling Logic

To illustrate the labeling process, here are three examples showing how raw terms were converted to human-readable labels:

**Example 1: Q4 Topic 3 (Sources of Error)**
- **Raw KeyBERT terms**: "Measurement errors", "Measurement", "Perception differences"
- **Semantic interpretation**: Students discussing how human perception and measurement accuracy are sources of error
- **Generated label**: "Human perception and measurement accuracy"
- **Rationale**: The terms point to both measurement errors and perception-based differences; the label captures that students see these as linked error sources

**Example 2: Q7 Topic 0 (Abstract Reflection)**
- **Raw KeyBERT terms**: "Understand experiment", "Experiment clearer", "Overall experiment"
- **Semantic interpretation**: Students expressing clarity gained about the experiment's purpose
- **Generated label**: "Now understand the experiment's purpose"
- **Rationale**: The redundancy across terms (all referring to understanding/clarity) suggests a unified insight; the active voice ("now understand") reflects students' comments about newly-gained clarity

**Example 3: Q6 Topic 1 (Experimental Design)**
- **Raw KeyBERT terms**: "Randomization used", "Used randomization", "Graphs randomization"
- **Semantic interpretation**: Different wording of the same concept—students describing how randomization was implemented
- **Generated label**: "How randomization was implemented"
- **Rationale**: Rather than repeating "randomization," the label emphasizes the mechanism-oriented discussion in students' responses

### Quality Assurance

Multiple validation checks were performed:

1. **Coverage check**: Do all 90 topics have interpretable labels?
2. **Uniqueness check**: Are labels within each question sufficiently distinct from one another?
3. **Fidelity check**: Do labels match the actual terms and response content?
4. **Consistency check**: Are labeling decisions consistent in style and specificity across all questions?

All labels passed these checks. A complete audit trail showing term-to-label mappings is available in [`data/topic_labels.csv`](../data/topic_labels.csv).

### Limitations and Transparency

**Subjectivity**: Label creation necessarily involved human interpretation of semantic content. While criteria were applied consistently, alternative reasonable interpretations could exist for some topics.

**Context dependency**: Labels are optimized for understanding within the context of this study's survey questions. They may require additional explanation when presented outside this context.

**Evolution**: As additional coding and analysis is performed on these topics, labels may be refined or amended to reflect deeper understanding of student responses.

---

## Topic Labels by Question

### **Q1: Pre-Experiment Reflection**
*"What do you think the process of scientific investigation looks like from researchers' vs public perspective?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 172 | General reflections on scientific investigation |
| 0 | 87 | Contrasting researcher vs public understanding |
| 1 | 49 | Individual perspectives on research steps |
| 2 | 45 | Systematic research process and peer review |
| 3 | 42 | Science as discovery vs consumption |
| 4 | 40 | How researchers conduct investigations |
| 5 | 40 | Hypotheses, testing, and evidence-based science |
| 6 | 38 | Rigorous scientific methodology |
| 7 | 38 | Research methodology and hypothesis formation |
| 8 | 29 | Researcher approach to scientific questions |
| 9 | 28 | Conducting and sharing research |
| 10 | 24 | Scientific research as a formal process |

---

### **Q2: Post-Experiment Reflection - Purpose**
*"What do you think the purpose of the experiment was?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 47 | General thoughts on depth and perception |
| 0 | 144 | Testing how students understand experiments |
| 1 | 135 | Interpreting graphs and visualizing data |
| 2 | 68 | Understanding differences in how things appear |
| 3 | 53 | Comparing bar graphs across conditions |
| 4 | 28 | Testing experimental differences |
| 5 | 26 | Comparing 2D and 3D chart formats |
| 6 | 20 | How perception affects size judgment |

---

### **Q3: Post-Experiment Reflection - Hypotheses**
*"What hypotheses might the experimenter have been testing?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 135 | Describing bar graph properties |
| 0 | 151 | Testing how people judge sizes and differences |
| 1 | 149 | Comparing 2D vs 3D graph perception |
| 2 | 29 | Precise measurement of bar relationships |
| 3 | 22 | Statistical testing concepts |
| 4 | 16 | Formal hypothesis testing terminology |
| 5 | 15 | Student accuracy in graph reading |

---

### **Q4: Post-Experiment Reflection - Sources of Error**
*"What sources of error are involved in this experiment?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 129 | General errors in experiments |
| 0 | 163 | Sample size and measurement validity |
| 1 | 62 | Physical aspects of 3D materials |
| 2 | 51 | Graph-related measurement issues |
| 3 | 38 | Human perception and measurement accuracy |
| 4 | 23 | Sampling bias and random error |
| 5 | 19 | Data variability across participants |
| 6 | 17 | Visual ability and eyesight limitations |
| 7 | 15 | Individual differences in perception |

---

### **Q5: Post-Experiment Reflection - Variables Examined**
*"What variables were examined? Identify if quantitative or categorical."*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 90 | Mixing quantitative and categorical concepts |
| 0 | 62 | Identifying quantitative variables in graphs |
| 1 | 56 | Bar height as quantitative variable |
| 2 | 52 | Size comparing as quantitative measure |
| 3 | 43 | Mixed quantitative and categorical variables |
| 4 | 40 | Graph types and quantitative data |
| 5 | 40 | Variable classification in the experiment |
| 6 | 37 | Categorical and quantitative distinctions |
| 7 | 37 | Student responses to category questions |
| 8 | 31 | Type of chart and numerical ratios |
| 9 | 27 | Demographic characteristics as categorical |

---

### **Q6: Post-Experiment Reflection - Experimental Design Elements**
*"What elements of experimental design do you think were present?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 61 | Design features and randomization methods |
| 0 | 144 | Control groups and experimental treatments |
| 1 | 97 | How randomization was implemented |
| 2 | 60 | Randomization in student assignments |
| 3 | 30 | Randomization in experiment setup |
| 4 | 26 | Random selection from blocks/kits |
| 5 | 24 | Chart types in the experiment |
| 6 | 21 | Selection through random assignment |
| 7 | 21 | Random sampling procedures |
| 8 | 17 | Treatment effects and experimental validity |
| 9 | 13 | Randomization in participant grouping |

---

### **Q7: Abstract Reflection**
*"What components of the experiment are clearer now?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 107 | General commentary on graphics |
| 0 | 71 | Now understand the experiment's purpose |
| 1 | 51 | 3D visualization and representation |
| 2 | 46 | Depth perception in 3D designs |
| 3 | 42 | Comparing 2D vs 3D charts |
| 4 | 42 | Reading and interpreting experimental graphs |
| 5 | 40 | Different chart formats compared |
| 6 | 36 | Understanding data from graphs |
| 7 | 20 | Physical 3D printed models |
| 8 | 20 | Purpose and significance of experiment |
| 9 | 20 | Design benefits for accessibility |

---

### **Q8: Presentation Reflection - How Did Components Differ**
*"How did the information from different components differ?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 61 | Reflections on learning progression |
| 0 | 99 | Visual differences between 2D and 3D |
| 1 | 34 | Design elements across components |
| 2 | 33 | Pre and post-study design understanding |
| 3 | 33 | Information gain from different formats |
| 4 | 32 | How each project component added value |
| 5 | 31 | Participation vs. reading components |
| 6 | 21 | Abstract vs. presentation format |
| 7 | 18 | Project helped with learning |
| 8 | 15 | Presentation provided new insights |
| 9 | 15 | Noticed differences between methods |
| 10 | 13 | Key findings and broader implications |

---

### **Q9: Presentation Reflection - Components Emphasized**
*"What components were emphasized in the presentation that weren't in the abstract?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 1 | Uncommon topic |
| 0 | 222 | Presentation and abstract covered similar content |
| 1 | 154 | Presentation added emphasis and detail |
| 2 | 27 | Presentation format with visual aids |

---

### **Q10: Presentation Reflection - Study Critiques**
*"What critiques do you have of this study and its design?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 48 | Purpose and study participation comments |
| 0 | 150 | Critiques of results and methodology |
| 1 | 90 | Study design could be improved |
| 2 | 50 | Study population and sample issues |
| 3 | 50 | Study methodology and data collection |
| 4 | 17 | Sample size and generalizability |

---

### **Q11: Presentation Reflection - Preference & Validity**
*"Which would you prefer: abstract only or presentation only? Which better determines if well-designed?"*

| Topic | Responses | Label |
|-------|-----------|-------|
| -1 (Outliers) | 4 | Rare response |
| 0 | 242 | Prefer the extended abstract format |
| 1 | 58 | Presentation explained better |
| 2 | 58 | Prefer watching the presentation |
| 3 | 23 | Mixed preference between formats |
| 4 | 20 | Presentation helps with learning |

---

## Key Insights

### Topic Diversity
- **Most topics**: Q5 (11 topics) - Variable identification had the most nuanced responses
- **Fewest topics**: Q9 (3 topics) - Components emphasized showed more consensus

### Response Participation
- **Highest participation**: Q1 (172 outliers + 602 distributed across 10 topics)
- **Lowest participation**: Q11 (4 outliers + 403 distributed across 4 topics)

### Dominant Themes by Module

**Pre-Experiment (Q1)**: Understanding researcher perspective vs public consumption of science

**Post-Experiment (Q2-Q6)**: Focus on experiment mechanics (graphs, hypotheses, errors, variables, design)

**Abstract/Presentation Reflections (Q7-Q11)**: Clarification of experimental purpose and preference for presentation format

---

## Files Generated

- **`data/topic_labels.csv`**: Complete topic labels with response counts (machine-readable format)
- **`label_topics.R`**: R script that generated these labels

## Using These Labels

These labels can be used to:
1. Manually code representative student responses for each topic
2. Create thematic summaries for manuscript writing
3. Identify patterns in student understanding across the learning progression
4. Support qualitative analysis with topic context

---

## Integration into Dissertation Manuscript

### Methods Section Language

When integrating these labels into your Methods section, consider referencing both the BERTopic methodology and label derivation:

> "Topic labels were derived from BERTopic's KeyBERT semantic representations through a systematic interpretation process. Rather than presenting raw concatenated terms, we created human-interpretable labels that maintain fidelity to the semantic content while improving readability (see TOPIC_LABELS_SUMMARY.md for detailed methodology). This approach allows both computational reproducibility and qualitative interpretability of topic content."

### Results Section Usage

Topic labels can be used in Results in several ways:

1. **Direct reference**: "Topic X was labeled as '[label]' and included N responses..."
2. **Thematic grouping**: Use labels to organize results by overarching themes
3. **Figure/table headers**: Use labels instead of raw topic numbers for clarity
4. **Quick summary**: Reference label names when referring to multiple related topics

### Supplementary Material

The complete label derivation process, including raw terms and final labels, is documented in:
- **Primary reference**: [`data/topic_labels.csv`](../data/topic_labels.csv) - Machine-readable label mappings
- **Methodology**: This document - Complete process documentation and justification
- **Code**: [`label_topics.R`](../label_topics.R) - Reproducible label generation script

### Transparency and Reproducibility

To support readers in evaluating label validity:
- All raw BERTopic output is preserved in [`data/bertopic_exports/`](../data/bertopic_exports/)
- The R script used to generate labels is available for inspection
- Representative student responses for each topic are documented in BERTopic's `document_info.csv` and `representative_docs` fields
- All 90 topics can be traced from raw outputs through to final labels

