function [sample,y]=assigning_random(p,n,m,phi)
sample=[];
for i=1:n
    if rand<=p
        sample=[sample i];
    end
end
y=0*eye(m,1);
for i=sample
    y=y+phi(:,i);
end
y=y~=0;
end