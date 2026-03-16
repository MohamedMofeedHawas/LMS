import sys
import warnings
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
warnings.filterwarnings("ignore")

from pipeline.runner import run

if __name__ == "__main__":
    run()
