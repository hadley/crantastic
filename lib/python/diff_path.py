# List of files in dir a and b

import os
from os.path import join

path_a = "/Users/hadley/cran/reshape_0.7.3/reshape"
path_b = "/Users/hadley/cran/reshape_0.7.4/reshape"

a = []
b = []

for root, dirs, files in os.walk(path_a):
    myroot = root.replace(path_a, "")
    for file in files:
        a.append(join(myroot, file))

for root, dirs, files in os.walk(path_b):
    myroot = root.replace(path_b, "")
    for file in files:
        b.append(join(myroot, file))

# Convert to sets
seta = set(a)
setb = set(b)

# Print list of added files, with contents (a - b)
# Print list of deleted files (b - a)
# Print list of changed files with html diff (a & b)