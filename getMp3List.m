function [ listing, numSongs ] = getMp3List( song )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
listing = dir('I:\Music')
listing = dir('*.mp3')%thing inside the parenthesis is the name of the file
                      % we save our songs into;
numSongs = length(listing);
for k = 1:numSongs
    fprintf('the name of song %d is %s\n',k,listing(k).name);
end
end

