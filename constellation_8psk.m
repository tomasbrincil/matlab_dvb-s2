function const = constellation_8psk(symbol, radius, p1, p2, p3, p4, p5, p6, p7, p8)
    len = sqrt(.5*radius^2);
    array = [complex(0, radius) complex(len, len) complex(radius, 0) complex(len, -len) complex(0, -radius) complex(-len, -len) complex(-radius, 0) complex(-len, len)];
    constellation = [array(p1), array(p2), array(p3), array(p4), array(p5), array(p6), array(p7), array(p8)];
    pos = bin2dec(symbol)+1;
    const = constellation(pos);
end