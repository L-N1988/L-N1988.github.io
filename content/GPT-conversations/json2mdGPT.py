import json
import sys
import os

file_path = "".join(sys.argv[1:])
_, output_file = os.path.split(file_path)
output_file = output_file.replace('.json', '.md')

print(file_path, '==➡️==>', output_file)

# Sample JSON data
with open(file_path) as f: 
    json_data = f.read()

# Load JSON data
data = json.loads(json_data)

# Extract messages and write to Markdown
markdown_output = []
for message in data["messages"]:
    # Extract the content parts if they exist
    if 'author' in message and 'role' in message['author']:
        if message['author']['role'] == 'user':
            markdown_output.append("\n# Q by user\n")
        if message['author']['role'] == 'assistant':
            markdown_output.append("\n# A by GPT\n")

    if 'content' in message and 'parts' in message['content']:
        for part in message['content']['parts']:
            markdown_output.append(part)

# Output to Markdown format (e.g., writing to a file)
markdown_file_content = "".join(markdown_output)

# Writing to a Markdown file
with open(output_file, 'w') as file:
    # Replace brackets to math dollar symbols
    file.write(markdown_file_content\
               .replace('\\(', '$')\
               .replace('\\)', '$')\
               .replace('\\[', '$$')\
               .replace('\\]', '$$'))
