function sample=assigning_random(p,n)
sample=[];
for i=1:n
    if rand<=p
        sample=[sample i];
    end
end
end