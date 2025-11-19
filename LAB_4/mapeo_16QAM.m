function [ a_k, b_k ] = mapeo_16QAM( grupos_bits )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
pam_map = containers.Map({'11','10','00','01'}, [-3,-1,1,3]);
a_k = zeros(1,12);
b_k = zeros(1,12);
    for kch = 1:12
        bits4 = grupos_bits{kch};
        pair1 = bits4(1:2);
        pair2 = bits4(3:4);
        a_k(kch) = pam_map(pair1);
        b_k(kch) = pam_map(pair2);
    end
end

