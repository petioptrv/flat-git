# Flatten Git Repo Script

This script takes in as single positional argumnet the path to a git repo. It then flattens all files under git versioning into a single text file
with the name `flat_{PROJECT_NAME}.txt`. For each project file, the output file will contain the path from the git root, along with Markdown code
block with the contents of the file.

This script was generated using [ChatGPT 4](https://chat.openai.com/share/771d942b-a8c6-44ff-b9d6-91514340fe4b). I had a 
[second conversation](https://chat.openai.com/share/b23ab447-8b78-4ec7-9daf-93307382d82e) that checked the work of the first one
and informed my follow-up prompts.

