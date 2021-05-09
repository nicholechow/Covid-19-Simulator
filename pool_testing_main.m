function pool_testing_main
n=24;
m=16;
k=2;
p=0.05;
max_iteration=100;
phi=randompooling(n,m,k,p)
[sample,y]=assigning_random(p,n,m,phi)
output=twopass(y,phi,n,m,sample)
T_round1=onepass(y,phi,n,m)
end