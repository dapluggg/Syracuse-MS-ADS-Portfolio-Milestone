#%%
import sys
import time
import plotting as pt
import pandas as pd
import pathlib
import fetch_tweets as ft
import vectorize as vc
import analysis as an
import models as md
from sklearn.model_selection import train_test_split

DATA_DIR_LOCAL = pathlib.Path('data')
DATA_DIR=pathlib.Path('/Users/shashanknagaraja/Library/Mobile Documents/com~apple~CloudDocs/Syracuse/IST 738 Text Mining/week6/hw6/politicalParty-classifier/data')
HANDLES_PATH=pathlib.Path(DATA_DIR_LOCAL / 'handles.txt')
timestr = time.strftime("%m-%d-%Y-%H%M%S")
OUTPUT_FILE = DATA_DIR_LOCAL / 'output' / f'Model Performance-{timestr}.txt'
f = open(OUTPUT_FILE, 'w')
sys.stdout = f



#%%

def main(download_data=False, dry_run=False):
    if download_data:
        handles_df = ft.load_accounts(HANDLES_PATH)
        print('Attempting to get tweets from the following handles: ')
        print(handles_df['Handle'])
        tweets = ft.get_tweets_multip(handles_df['Handle'], 2000, 128)
        an.load_jsons(DATA_DIR)
        return download_data
    else:
        if dry_run:
            compressed_file = 'SMALL_tweetsdf.bz2'
        else:
            compressed_file = 'tweetsdf.bz2'
        tweetdf = pd.read_pickle(DATA_DIR / compressed_file, compression='bz2')
        tweetdf = an.get_party_names(tweetdf, HANDLES_PATH)

        cv_binary_vecs = vc.vectorize_reviews_sklearn_countvec_binary(tweetdf)
        cv_vecs = vc.vectorize_reviews_sklearn_countvec(tweetdf)
        tfidf_vecs = vc.vectorize_reviews_sklearn_tfidf(tweetdf)
        print(f'CV Binary Vectors: {cv_binary_vecs.shape[1]} features. ')
        print(f'CV Vectors: {cv_vecs.shape[1]} features. ')
        print(f'TFIDF Vectors: {tfidf_vecs.shape[1]} features. ')
        vecs = [cv_vecs, tfidf_vecs]

        results = []
        for vec in vecs:
            X_train, X_test, y_train, y_test = train_test_split(vec, tweetdf['Party'])
            result = md.train_models(X_train, y_train, X_test, y_test)
            results.append(result)

        return results
    

if __name__ == "__main__":
    tmp = main(download_data=False, dry_run=False)
f.close()
# %% 

    