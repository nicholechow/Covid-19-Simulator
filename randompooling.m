function phi=randompooling(n,m,k,p)
phi=eye(m,n);
alpha=0;
max_iteration=100;
for i=1:n
    temp=randperm(m);
    phi(temp(1:2),i)=1;
end
i=1;
iteration_no=1;
phi_new=phi;
while iteration_no<max_iteration
    while i<=n
        while true
            for j=1:m
                if rand<=p && phi_new(j,i)==1
                    temp=randi([1,m]);
                    while phi_new(temp,i)==1
                        temp=randi([1,m]);
                    end
                    [phi_new(temp,i) phi_new(j,i)]=deal(phi_new(j,i),phi_new(temp,i));
                end
            end
            flag=true;
            for kk=1:i-1
                flag=flag&&~isequal(phi_new(:,kk),phi_new(:,i));
            end
            if flag
                i=i+1;
                break
            end
        end
    end
    max_str=[];
    for ii=1:n-1
        for jj=1:ii-1
            max_str=[max_str phi_new(:,ii)'*phi_new(:,jj)];
        end
    end
    alpha_new=k-max(max_str);
    if alpha_new/alpha>rand
        alpha=alpha_new;
        phi=phi_new;
    end
    iteration_no=iteration_no+1;
end
end