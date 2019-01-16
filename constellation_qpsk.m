function const = constellation_qpsk(symbol, radius, p1, p2, p3, p4);
    len = sqrt(.5*radius^2);
    array = [complex(len, len) complex(len, -len) complex(-len, -len) complex(-len, len)];
    constellation = [array(p1), array(p2), array(p3), array(p4)];
    pos = bin2dec(symbol)+1;
    const = constellation(pos);
end
