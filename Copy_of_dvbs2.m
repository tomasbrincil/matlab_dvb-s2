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
fec_length = 60;

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
% bitová rychlost konstatnní a z toho poèítám T, symbolová rychlost
T = 1 / f;
% time duration of one symbol
t = T/1000:T/1000:T;
I = [];
Q = [];
y = [];

% convert array into complex number
b=1;
cmplx = [];
for a = 1:2:length(symbol)
   cmplx(b) = complex(symbol(a), symbol(a+1));
   b = b + 1;
end
for i = 1:length(cmplx)
    y1=real(cmplx(i))*cos(2*pi*f*t); % inphase component
    y2=real(cmplx(i))*sin(2*pi*f*t) ;% Quadrature component
    I=[I y1]; % inphase signal vector
    Q=[Q y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig=y; % transmitting signal after modulation
tt=T/1000:T/1000:(T*length(interleaved_rof))/2;
figure(1)
subplot(3,1,1);
plot(tt,I), grid on;
title('I');
subplot(3,1,2);
plot(tt,Q), grid on;
title('Q');
subplot(3,1,3);
plot(tt,Tx_sig), grid on;
title('QPSK');
scatterplot(cmplx);
hold on;

cmplx = 0;


%% 16 APSK modulator
% take all input data by four and take IQ from lookup table
R1 = [0.267+0.267i -0.267+0.267i -0.267-0.267i 0.267-0.267i];
R2 = [1.095+0.293i 0.802+0.802i 0.293+1.095i -0.293+1.095i -0.802+0.802i -1.095+0.293i -1.095-0.293i -0.802-0.802i -0.293-1.095i 0.293-1.095i 0.802-0.802i 1.095-0.293i]; 
b=1;
for a = 1:4:length(interleaved_rot)
   four = interleaved_rot(a:a+3);
   
   if four == [0 0 0 0];
       cmplx(b)= R2(2);
   elseif four == [0 0 0 1];
       cmplx(b)= R2(11);
   elseif four == [0 0 1 0];
       cmplx(b) = R2(5);
   elseif four == [0 0 1 1];
       cmplx(b) = R2(8);
   elseif four == [0 1 0 0];
       cmplx(b) = R2(1);
   elseif four == [0 1 0 1];
       cmplx(b) = R2(12);
   elseif four == [0 1 1 0];
       cmplx(b) = R2(6);
   elseif four == [0 1 1 1];
       cmplx(b) = R2(7);
   elseif four == [1 0 0 0];
       cmplx(b) = R2(3);
   elseif four == [1 0 0 1];
       cmplx(b) = R2(10);
   elseif four == [1 0 1 0];
       cmplx(b) = R2(4);
   elseif four == [1 0 1 1];
       cmplx(b) = R2(9);
   elseif four == [1 1 0 0];
       cmplx(b) = R1(1);
   elseif four == [1 1 0 1];
       cmplx(b) = R1(4);
   elseif four == [1 1 1 0];
       cmplx(b) = R1(2);
   elseif four == [1 1 1 1];
       cmplx(b) = R1(3);
   end    
   b = b + 1;
end

I = [];
Q = [];
y = [];


for i = 1:length(cmplx)
    y1=real(cmplx(i))*cos(2*pi*f*t); % inphase component
    y2=real(cmplx(i))*sin(2*pi*f*t) ;% Quadrature component
    I=[I y1]; % inphase signal vector
    Q=[Q y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig=y; % transmitting signal after modulation
tt=T/1000:T/1000:(T*length(interleaved_rot)/4);
figure(2)
subplot(3,1,1);
plot(tt,I), grid on;
title('I');
subplot(3,1,2);
plot(tt,Q), grid on;
title('Q');
subplot(3,1,3);
plot(tt,Tx_sig), grid on;
title('16APSK');

scatterplot(cmplx);



%% Universal modulator
% take all input data by four and take IQ from lookup table

b=1;
for a = 1:5:length(interleaved_rot)
   four = interleaved_rot(a:a+4);
   symbol = num2str(four);
   symbol(isspace(symbol)) = '';
   symbol
   const = constellation_32apsk(symbol, 1, 2.84, 5.27, 6,5,8,2,15,16,12,11,20,18,23,25,31,17,28,26,7,1,8,2,14,4,13,3,21,19,22,24,30,32,29,27);
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
tt=T/1000:T/1000:(T*length(interleaved_rot)/5);
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