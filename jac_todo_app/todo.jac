# todo.jac

# ==============================================================================
# 1. Archetype Definitions (Data Structure)
# ==============================================================================

# Define the Task node and its properties
node Task {
    # Title of the task
    has title: str;
    # Timestamp of creation, uses a Python helper function from utils.py
    has created_at: float = impl::get_timestamp;
    # Status of the task
    has completed: bool = false;
}

# Define the Completion edge to link tasks to completion status
edge Completed {
    # Timestamp of when the task was completed
    has done_at: float = impl::get_timestamp;
}

# ==============================================================================
# 2. Walker Definition (Application Logic / "Agent")
# ==============================================================================

walker Entry {
    # The walker starts at the special 'root' node of the graph
    # Tasks are stored as nodes connected to the 'root' via an 'init' edge.
    
    # --- Ability 1: Create a new Task ---
    can create_task {
        std::out("What is the title of the new task? ");
        # Read user input from the terminal
        title = std::in();
        
        # Spawn a new Task node and connect it to the current node (root)
        spawn node Task(title=title) with init;
        std::out(f"✅ Task created: {title}\n");
    }

    # --- Ability 2: List Incomplete Tasks ---
    can list_incomplete_tasks {
        tasks = std::list_tasks(here);
        
        if (len(tasks) == 0) {
            std::out("🎉 All caught up! No incomplete tasks.\n");
            return;
        }

        std::out("📋 Incomplete Tasks:\n");
        # Iterate over all connected Task nodes that are not completed
        i = 1;
        for task in tasks:
            if (!task.completed) {
                # Format the creation time using the Python helper
                created_str = impl::format_time(task.created_at);
                
                std::out(f"  {i}. {task.title} (Created: {created_str})");
                task.index = i; # Temporarily store the index for selection
                i += 1;
            }
        
        std::out(f"\nTotal incomplete: {i - 1}\n");
    }
    
    # A helper function to find all incomplete tasks connected to the current node
    # This keeps the main list_incomplete_tasks logic cleaner.
    private can std::list_tasks(node_ref) -> list[node] {
        # Traverse from the current node along 'init' edges to 'Task' nodes
        return node_ref init { -> } node::Task;
    }

    # --- Ability 3: Complete a Task ---
    can complete_task {
        # Get the list of tasks and print them
        self.list_incomplete_tasks();

        tasks = std::list_tasks(here);
        incomplete_tasks = [t for t in tasks if !t.completed];
        
        if (len(incomplete_tasks) == 0) {
            return; # Nothing to complete
        }

        std::out("Enter the number of the task to complete (or 'q' to cancel): ");
        input_val = std::in();
        
        if (input_val == "q") {
            std::out("Operation cancelled.\n");
            return;
        }

        # Try to convert input to an integer index
        idx = std::to_int(input_val);
        
        if (idx == 0 || idx > len(incomplete_tasks)) {
            std::out("❌ Invalid task number.\n");
            return;
        }

        # Find the selected task based on the displayed index
        selected_task = incomplete_tasks[idx - 1];

        # Update the task status and create the completion edge
        selected_task.completed = true;
        
        # Connect the Task node to a 'Completed' edge back to itself (a loop)
        selected_task <+> edge Completed <+> selected_task;

        std::out(f"✅ Task completed: {selected_task.title}\n");
    }

    # --- Main Application Loop ---
    can run_app {
        std::out("\n" * 50); # Clear the screen for a cleaner interface
        std::out("🚀 Jac ToDo List Application\n");

        while (true) {
            std::out("----------------------------------------\n");
            std::out("Select an action:\n");
            std::out("  [1] Create New Task\n");
            std::out("  [2] List Incomplete Tasks\n");
            std::out("  [3] Complete Task\n");
            std::out("  [q] Quit\n");
            std::out("Action: ");

            action = std::in();
            std::out("\n");

            if (action == "1") {
                self.create_task;
            } elif (action == "2") {
                self.list_incomplete_tasks;
            } elif (action == "3") {
                self.complete_task;
            } elif (action == "q") {
                std::out("👋 Goodbye! Tasks are saved.\n");
                break;
            } else {
                std::out("❌ Invalid action. Please try again.\n");
            }
        }
    }
}

# ==============================================================================
# 3. Entry Point (Program Start)
# ==============================================================================

# The program starts here.
with entry {
    # The walker 'Entry' is spawned at the 'root' node (the starting node)
    spawn walker Entry { 
        # The first ability to execute is 'run_app'
        self.run_app;
    } on root;
}