%% SECTION 4, part 2
HASH = load(HASHTABLE.mat);
SONGS = load(SONGID.mat);
inputFile = % figure out how to load.
inputSongVectors = make_table( inputFile )
hashFunction = f1*344^2 + f2*344 + t2-t1;
maxSongsPerBin = 10;
maxHashBins = 2^17;
hTable_total = zeros(maxHashBins,2*maxSongsPerBin);
for n=1:length(Songs)
    hashValue = Songs(n,1) +Songs(n,2)*2^8 + Songs(n,4)*2^16;
    p = 1;
    while (hTable[hashValue, p]~=0 & p<2*maxSongsPerBin)
        p = p+1;
    end
     if (p<2*maxSongsPerBin)
        continue
    end
    htable[hashValue,p]=0000000000 %<------- 0 place holder for these unknown hash values.
     htable[hashValue,p+1]=inputSongVectors(n,4)
end



%!!!!!! ASK HOW TO DO THE LAST 2 PORTIONS OF SECTION 4 PART 2, COMPARING
%DIFFERENCES TO MATCH. WHY NOT JUST USE HASH CODES/ TIMESTAMPS.