symbol = '10';
constellation_qpsk(symbol, 1, 1, 2, 4, 3)

symbol = '101';
constellation_8psk(symbol, 1, 5, 1, 2, 6, 8, 4, 3, 7)

symbol = '1010';
constellation_16apsk(symbol, 1, 3.15, 6,9,15,12,7,8,14,13,5,10,16,11,1,2,4,3);

symbol = '10101';
constellation_32apsk(symbol, 1, 2.84, 5.27, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)


% testing routine for generating every single point in constellation
% diagram
% for out = 1:32
%    outm = out-1;
%    symbol = dec2bin(outm);
%    const = constellation_32apsk(symbol, 1, 2.84, 5.27, 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32)
%    complex(out) = const;
% end