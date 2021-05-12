function T_round1=onepass(y,phi,n,m)
T=1:n;
T_round1=[];
w=find(y==1)';
i=1;
while i<=m
    if y(i)==0
        for j=find(phi(i,:)==1)
            T=T(T~=j);
        end
    else
        if numel(find(phi(i,:)==1))==1
            T_round1=[T_round1 i];
            w=w(w~=i);
        end
    end
    i=i+1;
end
for i=T_round1
    T=T(T~=i);
end
while ~isempty(w)
    j=[];
    for i=1:n
        temp_w=w;
        for k=find(phi(:,i)==1)'
            temp_w=temp_w(temp_w~=k);
        end
        j=[j numel(temp_w)];
    end
    j=find(j==min(j),1,'first');
    T_round1=[T_round1 j];
    T=T(T~=j);
    for i=find(phi(:,j)==1)'
        w=w(w~=i);
    end
end
T_round1=sort(T_round1);
temp=[];
for i=1:numel(T_round1)
    if T_round1(i)<=n
        temp=[temp T_round1(i)];
    end 
end
T_round1=temp;
end