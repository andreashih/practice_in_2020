#%%
with open('en_news.txt', encoding = 'utf-8') as f:
    en_news = f.read()
#%%
with open('brown_reference.txt', encoding = 'utf-8') as file:
    brown = file.read()
# %%
# methods1
en_news_wordlist = en_news.split()
brown_wordlist = brown.split()

def wordListToFreqDict(wordlist):
    wordfreq = [wordlist.count(p) for p in wordlist]
    return dict(list(zip(wordlist,wordfreq)))
# %%
en_news_freq = wordListToFreqDict(en_news_wordlist)
brown_freq = wordListToFreqDict(brown_wordlist)
# %%
