function const = constellation_16apsk(symbol, radius, gamma, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16)
    R1 = radius/gamma;
    R2 = radius;
    lenR1 = sqrt(.5*R1^2);
    lenR2 = sqrt(.5*R2^2);
    lenR2sin = sin(pi/12)*radius;
    lenR2cos = cos(pi/12)*radius;
    array = [complex(lenR1, lenR1) complex(lenR1, -lenR1) complex(-lenR1, -lenR1) complex(-lenR1, lenR1),complex(lenR2sin, lenR2cos),complex(lenR2, lenR2),complex(lenR2cos, lenR2sin),complex(lenR2cos, -lenR2sin), complex(lenR2, -lenR2),complex(lenR2sin, -lenR2cos),complex(-lenR2sin, -lenR2cos),complex(-lenR2, -lenR2), complex(-lenR2cos, -lenR2sin),complex(-lenR2cos, lenR2sin),complex(-lenR2, lenR2),complex(-lenR2sin, lenR2cos)];
    constellation = [array(p1), array(p2), array(p3), array(p4), array(p5), array(p6), array(p7), array(p8), array(p9), array(p10), array(p11), array(p12), array(p13), array(p14), array(p15), array(p16)];
    pos = bin2dec(symbol)+1;
    const = constellation(pos);
end