import csv
import random
import os
import sys

NUM_ROWS = 50

COLUMNS = ["Пол человека", "Рост человека", "Возраст человека", "IQ человека"]

def generate_row():

    return {
        "Пол человека": random.choice(["М", "Ж"]),
        "Рост человека": random.randint(150, 200),
        "Возраст человека": random.randint(0, 100),
        "IQ человека": random.randint(80, 140),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)