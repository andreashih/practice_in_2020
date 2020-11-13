import re

# read files
with open('beef.txt', 'r', encoding='utf-8-sig') as f:
    beef_content = f.read()
with open('asbc_reference.txt', 'r', encoding='utf-8-sig') as f:
    asbc_content = f.read()

# split by spaces
beef = re.split('\s+', beef_content)
asbc = re.split('\s+', asbc_content)

# make frequency list
def count_freq(corpus):
    word_freq = {}
    for word in corpus:
        if word not in word_freq:
            word_freq[word] = 1
        else:
            word_freq[word] += 1
    return word_freq

# sort frequency list
beef_freq = count_freq(beef)
sorted(beef_freq.items(), reverse=True, key=lambda x: x[1])

# %%
asbc_freq = count_freq(asbc)
sorted(asbc_freq.items(), reverse=True, key=lambda x: x[1])

# %%
