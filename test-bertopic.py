# Guide: https://www.youtube.com/watch?v=v3SePt3fr9g

import pandas as pd
from bertopic import BERTopic
from sentence_transformers import SentenceTransformer

# ---------------------------------------------------------
# 1. Load the data
# ---------------------------------------------------------
responses = pd.read_csv("student-responses.csv")

# ---------------------------------------------------------
# 2. Create embeddings using SentenceTransformer

q1 = responses.iloc[:, 13].dropna().astype(str).tolist()

topic_model = BERTopic(embedding_model="all-MiniLM-L6-v2")

topics, probs = topic_model.fit_transform(q1)

# ---------------------------------------------------------
topic_model.get_topic_info()

topic_model.get_topic(0)

topic_model.get_representative_docs(0)

df = pd.DataFrame({"topic": topics, "document": q1})
df.head()

topic_model.visualize_topics()