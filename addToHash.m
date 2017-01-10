function [ htable ] = addToHash( htable, iterable, Songs )
% This function takes in a  list of song peak to peak elements and
% creates a hash table based off of this. 
table = make_table(n, songs); % <-- This is with the assumption that the make_table operation correctly creates a matrix per song, as directed in the PDF documentmake_table;
maxSongsPerBin = 10;
maxHashBins = 2^17;

for n=1:length(Songs)
    hashValue = Songs(n,1) +Songs(n,2)*2^8 + Songs(n,4)*2^16;
    p = 2;
    while ((htable[hashValue, p]~=0) && (p<2*maxSongsPerBin))
        p = p+1;
    end
    if (p<=2*maxSongsPerBin)
        continue
    end
    htable[hashValue,p]=iterable %<------- This is supposed to be the song ID. I'm not sure how to identify. Ask about this.
    htable[hashValue,p+1]=Songs(n,4)
end
end

