# test_python_version.py
import sys
print(f"Python version: {sys.version}")
print(f"Python major.minor: {sys.version_info.major}.{sys.version_info.minor}")

# Check if we're on Python 3.10+
if sys.version_info.major == 3 and sys.version_info.minor >= 10:
    print(" Python 3.10+ - Should work with SQLAlchemy")
else:
    print(" Python < 3.10 - Might have different issues")
