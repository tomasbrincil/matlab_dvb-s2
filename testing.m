symbol = '11';
constellation_qpsk(symbol, 1, 1, 2, 4, 3)

symbol = '000';
%constellation_8psk(symbol, 1, 5, 1, 2, 6, 8, 4, 3, 7)

symbol = '1111';
constellation_16apsk(symbol, 1, 3.15, 6,9,15,12,7,8,14,13,5,10,16,11,1,2,4,3);

symbol = '11111';
%constellation_32apsk(symbol, 1, 2.84, 5.27, 6,5,8,2,15,16,12,11,20,18,23,25,31,17,28,26,7,1,8,2,14,4,13,3,21,19,22,24,30,32,29,27)

for out = 1:32
   outm = out-1;
   symbol = dec2bin(outm);
   const = constellation_32apsk(symbol, 1, 2.84, 5.27, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
   complex(out) = const;
end

scatterplot(complex);