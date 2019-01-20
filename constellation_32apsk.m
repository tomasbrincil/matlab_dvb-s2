function const = constellation_32apsk(symbol, radius, gamma1, gamma2, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32)
    R3 = radius;
    R1 = R3/gamma2;
    R2 = gamma1*R1;
    lenR1 = sqrt(.5*R1^2);
    lenR2 = sqrt(.5*R2^2);
    lenR2sin = sin(pi/12)*R2;
    lenR2cos = cos(pi/12)*R2;
    lenR3 = sqrt(.5*R3^2);
    lenR3sin = sin(pi/8)*R3;
    lenR3cos = cos(pi/8)*R3;
    array = [complex(lenR1, lenR1) complex(lenR1, -lenR1) complex(-lenR1, -lenR1) complex(-lenR1, lenR1) complex(lenR2sin, lenR2cos) complex(lenR2, lenR2) complex(lenR2cos, lenR2sin) complex(lenR2cos, -lenR2sin) complex(lenR2, -lenR2) complex(lenR2sin, -lenR2cos) complex(-lenR2sin, -lenR2cos) complex(-lenR2, -lenR2) complex(-lenR2cos, -lenR2sin) complex(-lenR2cos, lenR2sin) complex(-lenR2, lenR2) complex(-lenR2sin, lenR2cos) complex(lenR3sin, lenR3cos) complex(lenR3, lenR3) complex(lenR3cos, lenR3sin) complex(R3, 0) complex(lenR3cos, -lenR3sin) complex(lenR3, -lenR3) complex(lenR3sin, -lenR3cos) complex(0, -R3) complex(-lenR3sin, -lenR3cos) complex(-lenR3, -lenR3) complex(-lenR3cos, -lenR3sin) complex(-R3, 0) complex(-lenR3cos, lenR3sin) complex(-lenR3, lenR3) complex(-lenR3sin, lenR3cos) complex(0, R3)];
    constellation = [array(p1), array(p2), array(p3), array(p4), array(p5), array(p6), array(p7), array(p8), array(p9), array(p10), array(p11), array(p12), array(p13), array(p14), array(p15), array(p16), array(p17), array(p18), array(p19), array(p20), array(p21), array(p22), array(p23), array(p24), array(p25), array(p26), array(p27), array(p28), array(p29), array(p30), array(p31), array(p32)];
    pos = bin2dec(symbol)+1;
    %constellation(pos)
    const = constellation(pos);
end