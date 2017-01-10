% Austin Mease, Allen Kempke, Cullen Moran, Devlin
% 11/14/14
%% Project Shazam!

%% SECTION 4, part 1
% This is part 4, with proper operational assumption/ abstraction.
[list, numSongs] = getMp3List('viva.mp3')
songRefrenceList = zeros(numSongs,2);
maxSongsPerBin = 10;
maxHashBins = 2^17;
hTable_total = zeros(maxHashBins,2*maxSongsPerBin+1); % This represents the hashtable for the output.
for n=1:numSongs %n represents the song id value to be passed into the hashtable call later (refrence variable)
    songRefrenceList(n,list(n).name);
    hTable_total = addToHash(hTable_total, n, song) % <---- by passing it in as a variable we can modify it like it's a global variable. Same result, different implementation.
end



% Above here is the database creation
% Below here is the input test
inputFile = audioread('viva.mp3');
inputSongVectors = make_table( inputFile )
maxSongsPerBin = 10;
maxHashBins = 2^17;
hTable = zeros(maxHashBins,2*maxSongsPerBin+1); % This represents the hashtable for the input song.
for n=1:length(Songs)
    hashValue = Songs(n,1) +Songs(n,2)*2^8 + Songs(n,4)*2^16;
    p = 2;
    while (hTable[hashValue, p]~=0 & p<2*maxSongsPerBin)
        p = p+1;
    end
     if (p<2*maxSongsPerBin)
        continue
    end
    htable[hashValue,p]=0000000000 %<------- 0 place holder for these unknown hash values.
     htable[hashValue,p+1]=inputSongVectors(n,4)
end

histoData = zeroes(numSongs,2) % nx2 matrix containing song ID and number of occurences.

quickCompareTableSub = hTable(:,1) % linear vector containing just the hash code values - Database
MatchableHashesSub = find( quickCompareTableSub) % indices of the nonzero elements - Database

quickCompareTableMain = hTable_total(:,1) % linear vector containing just the hash code values - Database
MatchableHashesMain = find( quickCompareTableMain) % indices of the nonzero elements - Database
% This for loop creates the histogram data by refrencing the hash table and
% tallying the song ID.
for n = 1:length(MatchableHashesSub)
    for m = 1:length(MatchableHashesMain)
        if (htable[MatchableHashesSub(n),1] == hTable_total[MatchableHashesMain(m),1])
            i = 2
            while hTable_total[MatchableHashesMain(m),i]~=0 && i<=2*maxSongsPerBin
                histoData[hTable_total[MatchableHashesMain(m),i],2] = histoData[hTable_total[MatchableHashesMain(m),i],2] + 1;
                i= i+2;
            end
        end
    end
end

histogram(histoData)
% We didn't use the PDF's methodology for matching. We didn't know what
% your were talking about, it seemed like you weren't even using the hash
% value. We used the hash value.
% We didn't know how to do the scatterplot because again, we didn't know
% what was going on with the comparing time diffrences. 

% The hash table size is dependent both on the desired limitation of
% collisions and, dependently, the hash function. It's always desirable to
% have a sizable hash table, because this limits collisions (and thus
% boosts confidence). However due to the size/ memory requirements it is
% not too uncommon that a smaller hash table is prefered. But for optimal
% confidence, we want a table that is 30*#ofSongs, because if we optimally
% hit 30 peaks (and thereby rows created), and we want no repeated hash
% values, than we would want the table to be a minimum of this size.

% Limiting the number of peaks chosen from window will limit collisions,
% thus improving the end confidence.

% We could measure confidence by comparing the relative hights of a
% solution with the other peaks in the histogram. If the answser that we
% find has a peak 2x the size of the next closest, we can be pretty
% confident. If they were really close to each other, there could be
% background noise conflicting with the read-in.




% Songs we used :
%   Viva - ColdPlay
%   Copacabana - Barry Manilow
%   I Get Around - The Beach Boys
%   My Nigga- Lil Wayne
%   Let It Go - Frozen
%   Baby - Let it Go
%   Gangum Style - PSY
%   99 Problems - Hugo
%   Without Me - Eminem
%   Around the World - Daft Punk
