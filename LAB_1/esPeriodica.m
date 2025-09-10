function [ periodo,NF ] = esPeriodica( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
periodo=0;
NF=[];
error= 1e-10;
N=length(x);
M=(N/2);

for p=(1:M);
    n=1;
    while n<N-p
        if abs(x(n)-x(n+p))<= error
        n=n+1;
        else
        n=N;
        end
        
        if n==N-p
            periodo=p;
            NF=x(n:n+p-1);
            return
        end
    end
    

end

