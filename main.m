clear all
n=12;
m=8;
k=2;
p=0.1;
max_iteration=100;
phi=randompooling(n,m,k,p)
[sample,y]=assigning_random(p,n,m,phi)
output=twopass(y,phi,n,m,sample)
T_round1=onepass(y,phi,n,m)