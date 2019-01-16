clear all
close all
%% 5.1.6 Base-Band Header Insertion
Kbch = 3072; % according Table 5b first row
MATYPE1 = [ 1 1 1 1 0 0 1 0 ];
MATYPE2 = [ 0 0 0 0 0 0 0 0 ];
UPL =  [ 0 0 0 0 0 0 0 0 ];
DFL = [0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 ]; % we consider full DATA FILED without any PADDING so Kbch - 80
SYNC =  [ 0 0 0 0 0 0 0 0 ];
SYNCD =  [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];

CRC8 = comm.CRCGenerator([ MATYPE1 MATYPE2 UPL DFL SYNC SYNCD ], 'Polynomial', 'CRC-8');
CRC8 = de2bi(CRC8.FinalXOR, 16);

BBHEADER = [ MATYPE1 MATYPE2 UPL DFL SYNC SYNCD CRC8 ];
DATAFILED = randi([0 1],1,Kbch-80);
BBFRAME = [ BBHEADER DATAFILED];

%% There should be FECFRAME generation though
% noraml frame FEC
%fec_length = 64800;
% short frame FEC
%fec_length = 16200;
fec_length = 1800;

% lets skip the generation and do some magic for example random gen :))
FECFRAME = randi([0 1],1,fec_length);

%% 5.4 Bit mapping into constellation aka bit Interleaving
cols = 3; % for three columns based on 3/5

% lets generate matrix column by column
index = 1;
for col = 1:cols
    for row = 1:fec_length/cols
        matrix(row,col) = FECFRAME(index);
        index = index + 1;
    end
end

% READ-OUT THIRD - 8PSK
index = 1;
for row = 1:fec_length/cols
    for col = cols:-1:1
        interleaved_rot(index) = matrix(row,col);
        index = index + 1;
    end
end

% READ-OUT FIRST - QPSK
index = 1;
for row = 1:fec_length/cols
    for col = 1:cols
        interleaved_rof(index) = matrix(row,col);
        index = index + 1;
    end
end

%% QPSK modulator
% as first we need to transform binary data to non-return-to-zero set
data_NRZ = 2 * interleaved_rof - 1;
% make a pairs of bits in columns as one symbol
%symbol = reshape(data_NRZ, 2, length(interleaved_rof) / 2)
symbol = data_NRZ;
% carrier frequency (as minimum value done by bitrate)
f = 10e6;
% period of one symbol
% bitov� rychlost konstatnn� a z toho po��t�m T, symbolov� rychlost
T = 1 / f;
% time duration of one symbol
t = T/1000:T/1000:T;





%% Universal modulator
% take all input data by four and take IQ from lookup table
bits = 5;
bitsm = bits-1;
b=1;
for a = 1:bits:length(interleaved_rot)
   four = interleaved_rot(a:a+bitsm);
   symbol = num2str(four);
   symbol(isspace(symbol)) = ''
   %const = constellation_qpsk(symbol, 1, 1, 2, 4, 3);
   const = constellation_32apsk(symbol, 1, 2.84, 5.27, 6,5,8,2,15,16,12,11,20,18,23,25,31,17,28,26,7,1,10,9,14,4,13,3,21,19,22,24,30,32,29,27);
   %const = constellation_32apsk(symbol, 1, 2.84, 5.27, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
   cmplxx(b) = const;
   b = b + 1;
end

I = [];
Q = [];
y = [];


for i = 1:length(cmplxx)
    y1=real(cmplxx(i))*cos(2*pi*f*t); % inphase component
    y2=real(cmplxx(i))*sin(2*pi*f*t) ;% Quadrature component
    I=[I y1]; % inphase signal vector
    Q=[Q y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig=y; % transmitting signal after modulation
tt=T/1000:T/1000:(T*length(interleaved_rot)/bits);
figure(2)
subplot(3,1,1);
plot(tt,I), grid on;
title('I');
subplot(3,1,2);
plot(tt,Q), grid on;
title('Q');
subplot(3,1,3);
plot(tt,Tx_sig), grid on;
title('universal - 16APSK');

scatterplot(cmplxx);