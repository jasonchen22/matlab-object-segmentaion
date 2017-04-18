function imathr = adaptThreshold(ima)

T = 0.03;

[H,W] = size(ima);
s2 = floor(W / 8 / 2);

imathr = zeros(H,W);
Imgt = zeros(H*W,1);
for i = 1: W
    sum = 0;
    for j = 1: H
        index = (j-1)*W + i;
        sum = sum + ima(j,i);
        if i == 1
            Imgt(index) = sum;
        else
            Imgt(index) = Imgt(index-1) + sum;
        end
    end
end

for i = 1: W
    for j = 1: H
        x1 = i - s2; x2 = i + s2;
        y1 = j - s2; y2 = j + s2;
        
        if x1 < 1, x1 = 1; end
        if x2 > W, x2 = W; end
        if y1 < 1, y1 = 1; end
        if y2 > H, y2 = H; end
        
        count = (x2 - x1)*(y2 - y1);
        
        sum = Imgt((y2-1)*W+x2) - Imgt((y1-1)*W+x2) - ...
              Imgt((y2-1)*W+x1) + Imgt((y1-1)*W+x1);

        if ima(j,i)*count < (sum*(1.0-T))
            imathr(j,i) = 0;
        else
            imathr(j,i) = 1;
        end

    end
end

