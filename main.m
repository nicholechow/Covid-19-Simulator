function [output,T_round1]=main(sample_input)
n=24;
m=15;
k=4;
p=0.01;
[Q,R]=quorem(sym(numel(sample_input)),sym(n));
output=[];
T_round1=[];
if R==0
    test_no=Q;
else
    test_no=Q+1;
end

i=1;
for i=1:double(test_no)
    if i<double(test_no)
        seq=(1:n)+(i-1)*n;
    else
        seq=seq(n)+1:numel(sample_input);
    end
    clear phi
    phi=randompooling(n,m,k,p);
    y=pooltest(sample_input(seq),n,m,phi);
    output=[output seq(twopass(y,phi,n,m,sample_input(seq)))];
    T_round1=[T_round1 seq(onepass(y,phi,n,m))];
end
end