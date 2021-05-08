function output=twopass(y,phi,n,m,sample)
T=1:n;
T_round1=[];
T_round2=[];
i=1;
while i<=m
    if y(i)==0
        for j=find(phi(i,:)==1)
            T=T(T~=j);
        end
    else
        if numel(find(phi(i,:)==1))==1
            T_round1=[T_round1 i];
        end
    end
    i=i+1;
end
for i=T_round1
    T=T(T~=i);
end
for i=T
    if find(sample==i)
        T_round2=[T_round2 i];
    end
end
output=[T_round1 T_round2];
output=sort(output);
end