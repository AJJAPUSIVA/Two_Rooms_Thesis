function [arr] = strBin(str)
strBinary = ('');

arr = zeros(length(str),8);

for i = 1: length(str)
bnry = dec2bin(str(i));
strBinary = num2str(bnry);
for j = 1:length(strBinary)
arr(i,9-j) = strBinary(length(strBinary)-j+1) - 48;
end
end
return