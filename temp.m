clc;
close all;
clear all;

message='hello world';
asc=double(message);
ascbin=dec2bin(asc);

fc=8e6;
fs=16e6;
A1=5;
A0=1;
bitd=0.01;

t = 0:1/fs:bitd-(1/fs);

ask=[];

for j=1:size(ascbin,1)
    current=ascbin(j,:);
    for i=1:length(current)
        if current(i)=='1'
            modulated=A1*cos(2*pi*fc*t);
        else
            modulated=A0*cos(2*pi*fc*t);
        end
    ask=[ask,modulated];
    end
end

figure;
plot(0:1/fs:(length(ask)-1)/fs, ask);

decode=[];

ts=1/fs;
b=bitd/ts;
for i=1:b:length(ask)
    decode=[decode,ask(i)];
end

bin=[];
for j=1:length(decode)
    if decode(j)==5
        bin=[bin,'1'];
    else 
        bin=[bin,'0'];
    end
end

disp(bin);

numBits = 7; 
numChars = length(bin) / numBits; 

asciiChars = char(zeros(1, numChars));

for i = 1:numChars
    binaryChunk = bin((i-1)*numBits + 1:i*numBits);
    decimalValue = bin2dec(binaryChunk);
    asciiChars(i) = char(decimalValue);
end
disp(asciiChars);