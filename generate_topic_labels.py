import pandas as pd
import re
import json
from pathlib import Path

base_path = Path("data/bertopic_exports/per_question/")

def extract_terms(representation_str):
    """Extract terms from BERTopic representation field"""
    if pd.isna(representation_str):
        return []
    # Remove brackets and split by comma, then clean up quotes
    terms = re.findall(r"'([^']+)'", str(representation_str))
    return terms[:5]  # Get top 5 terms

def create_label(terms):
    """Create a human-readable label from topic terms"""
    if not terms:
        return "Uncategorized"
    
    # Filter out overly common/generic terms
    filtered = [t for t in terms[:4] if len(t) > 2 and t not in 
                ['like', 'think', 'just', 'people', 'results', 'data', 'make', 'way']]
    
    if not filtered:
        filtered = terms[:3]
    
    return " + ".join(filtered)

# Collect all topic labels
all_topics = []

for q_dir in sorted(base_path.glob("q*")):
    topic_file = q_dir / "topic_info.csv"
    
    if topic_file.exists():
        q_num = q_dir.name.replace("q", "")
        df = pd.read_csv(topic_file)
        
        for _, row in df.iterrows():
            topic_id = int(row['Topic'])
            count = int(row['Count']) if pd.notna(row['Count']) else 0
            
            # Try each representation method in order of preference
            representation = row.get('KeyBERT', row.get('Representation', ''))
            
            terms = extract_terms(representation)
            label = create_label(terms)
            
            all_topics.append({
                'Question': f"Q{q_num}",
                'Topic': topic_id,
                'Count': count,
                'Top_Terms': " + ".join(terms[:4]) if terms else "N/A",
                'Label': label
            })

# Create output dataframe and save
output_df = pd.DataFrame(all_topics).sort_values(['Question', 'Topic'])
output_df.to_csv("data/topic_labels.csv", index=False)

# Print formatted output
print("\n" + "="*100)
print("BERTopic LABELS BY QUESTION")
print("="*100)

for q in [f"Q{i}" for i in range(1, 12)]:
    q_data = output_df[output_df['Question'] == q]
    if len(q_data) > 0:
        print(f"\n{q}")
        print("-"*100)
        for _, row in q_data.iterrows():
            topic_marker = "⊗ OUTLIERS" if row['Topic'] == -1 else f"  Topic {int(row['Topic']):2d}"
            print(f"{topic_marker:15s} (n={int(row['Count']):3d}):  {row['Label']}")

print("\n" + "="*100)
print(f"Complete labels saved to: data/topic_labels.csv")
print("="*100 + "\n")

# Also create a more detailed version
detailed_df = output_df[['Question', 'Topic', 'Count', 'Top_Terms', 'Label']]
detailed_df.columns = ['Question', 'Topic_ID', 'Response_Count', 'Top_Terms', 'Topic_Label']
detailed_df.to_csv("data/topic_labels_detailed.csv", index=False)
print(f"Detailed version saved to: data/topic_labels_detailed.csv\n")
