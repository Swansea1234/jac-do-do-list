# jac-do-do-list
🚀 Jac ToDo Master: A Command-Line Organizer
Welcome to the future of task management! This is a simple, persistence-enabled ToDo List application built entirely in Jac, the language for building hyper-graphical applications.

This project was developed for a [Insert Your Class Name or Course ID Here] assignment.

✨ Features
Persistence: Tasks are stored on the graph (root node) and remain saved even after you quit the application and restart.

Simple Command Interface: Easy-to-use menu driven by a single walker.

External Integration: Leverages the impl feature to seamlessly call standard Python functions (utils.py) for date formatting and timestamp generation.

🛠️ Project Structure
File

Purpose

Key Jac Elements

todo.jac

The core application, containing the main logic, menu, and state transitions.

node Task, edge Completed, walker Entry, with entry

utils.py

Python helper module providing essential utilities.

get_timestamp(), format_time()

README.md

(This file!) Documentation and running instructions.

-

🏃 Getting Started (How to Run It)
Prerequisites
You must have the Jac compiler installed.

Install Jac:

pip3 install jaclang

Clone the Repository:

git clone [Your GitHub URL Here]
cd jac_todo_app

Execution
Ensure you are inside the jac_todo_app folder, then use the following command to run the application:

# This is the guaranteed way to execute the Jac module using Python 3:
python3 -m jac run todo.jac

💡 Troubleshooting (The "Command Refused" Fix)
If you encounter the error ModuleNotFoundError: No module named jac even after installing, it means your python3 command is not using the same Python environment where jaclang was installed.

Here are quick solutions to try:

Try using python instead of python3:

python -m jac run todo.jac

Ensure Virtual Environment is Active: If you are using a tool like venv or conda, make sure you have activated the environment before attempting to run the command.
