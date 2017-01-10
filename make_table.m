function [ peakfrequency, equalfrequency, timepeak, timedifference  ] = make_table( song )
%% 2 myshazam Part I
%% 2.1
[y, fs] = audioread('viva.mp3');
soundsc(y,fs);
%% 2.2
y = mean(y,2);
y = y - mean(y);
%y = fft(y);
newSampleRate = 8000;
y = resample(y,newSampleRate,fs);
%% 2.3
window = 64*10^-3*newSampleRate;
overlap = window/2;
figure(1);
[S, F, T] = spectrogram(y, window, overlap, window, newSampleRate);
imagesc(F,T,log(abs(S)+1));
title('Spectogram of Song')
ylabel('Time')
xlabel('Frequency')
%yshift = fftshift(y);
figure(2)
semilogy(T,abs(S));
xlabel('Frequency in Hz');
ylabel('Magnitude of DFT Coefficients');
title('Log Spectrum of Song X');

% It's common to study the logarithmicly scaled version of a signal because
% "The decibel (dB) is a logarithmic unit used to express the ratio between
% two values of a physical quantity, often power or intensity. One of these
% quantities is often a reference value, and in this case the decibel can
% be used to express the absolute level of the physical quantity, as in the
% case of sound pressure. The number of decibels is ten times the logarithm
% to base 10 of the ratio of two power quantities" - wikipedia
% Also, by nerfing the relative magnitude we allowed to see a less skew
% picture of the data.
%% 2.4
gs = 9;
[h, w] = size(S);
P = ones(h, w);
for i = (-gs-1)/2:(gs-1)/2
    for yy = (-gs-1)/2:(gs-1)/2 % ask how to do this
        if(i~=0 || yy~=0)
            CS = circshift(log(abs(S)+1),[i,yy]);
            P = P + ((log(abs(S)+1) - CS)>0);
            P = P>1;
        end
    end
end
figure(3);
colormap (1-gray);
imagesc(P);
title('Constellation Map')
xlabel('Time')
ylabel('Frequency')
% Total Peaks (1's) = 849
% Peaks Per Second = 76.833

%% 2.5
% ideal peaks per second = 30
% Write a routine which will find some optimal threshold automatically
% instead of manually doing it.
songInSeconds = length(y)/8000;
numDesiredPeaks = 30*round(songInSeconds);
count = 0;
for threshold = 0.0:0.1:1.5
    count = 0;
    for ii = 1:length(P(:,1))
        for yyy = 1:length(P(1,:))
            if(P(ii,yyy)==1)
                if(log(abs(S(ii,yyy))+1) < threshold)
                    P(ii,yyy) = 0;
                else
                    count = count + 1;
                end
            end
        end
    end
    if(abs(count - numDesiredPeaks) <= 5)
        break;
    end
end
figure(4);
colormap(1-gray);
imagesc(P);
title('Constellation Map with Threshold')
xlabel('Time')
ylabel('Frequency')

% We want to use the larger peaks because it's easier to differentiate than
% the relatively-close lower frequencies.
%% 2.6
% Set up empty arrays to store our max peaks
peakfrequency = [];
equalfrequency = [];
timepeak = [];
timedifference = [];

delTl = 40; %Check this value on Piazza
delTu = 5; %Check this value on Piazza
delTf = 45; %Check this value on Piazza

starty = 1;
endy = 257 - 40 - 1;
startx = 1;
endx = 344 - delTl - 5;
% This is where we are searching for the max peak
for i = starty : endy;
    for j = startx : endx;
        peak = P(i,j);
        if peak == 1;
            ypeak = i;
            xpeak = j;
            % This is where we construct the window
            windowlowy = ypeak - delTf;
            if windowlowy <= 0
                windowlowy = 1;
            end
            windowhighy = ypeak + delTf;
            windowlowx = xpeak + delTu;
            windowhighx = xpeak + delTl;
            counter = 0;
            % Start finding and adding points in the window
            for k = windowlowy : windowhighy;
                for m = windowlowx : windowhighx;
                    windowpeak = P(k,m);
                    if windowpeak == 1;
                        
                        if counter >= 3
                            break;
                        end
                        peakfrequency(end +1) = ypeak;
                        equalfrequency(end + 1) = k;
                        timepeak(end + 1) = xpeak;
                        timedifference(end +1) = m - xpeak;
                        counter = counter + 1;
                    end
                    % if counter == 3;
                    % counter = 0;
                    % break;
                    % end
                end
            end
        end
    end
end

%% 2.7
Table = [peakfrequency; equalfrequency; timepeak; timedifference];