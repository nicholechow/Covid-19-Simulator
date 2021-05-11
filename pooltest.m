function y=pooltest(sample_input,n,m,phi)
y=0*eye(m,1);
sample=[];
for i=1:numel(sample_input)
    if sample_input(i)==1
        sample=[sample i];
    end
end
for k=sample
    y=y+phi(:,k);
end
y=y~=0;
end