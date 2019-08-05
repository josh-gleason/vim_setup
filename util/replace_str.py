import sys

# 1. input
# 2. output
# 3. search term
# 4. replace term

with open(sys.argv[1], 'r') as fin:
    data = fin.read()

data = data.replace(sys.argv[3], sys.argv[4])
with open(sys.argv[2], 'w') as fout:
    fout.write(data)
