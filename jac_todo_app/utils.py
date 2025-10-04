# utils.py
import time
from datetime import datetime

# --- Required by Task and Completed archetypes ---
def get_timestamp() -> float:
    """Returns the current Unix timestamp."""
    return time.time()

# --- Required by the Walker for display ---
def format_time(timestamp: float) -> str:
    """Formats a timestamp into a readable date/time string."""
    try:
        # datetime.fromtimestamp raises ValueError for out-of-range timestamps
        return datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d %H:%M:%S")
    except ValueError:
        return "Invalid Time"