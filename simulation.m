close all
clear all
human=100;
sample=rand(human,2);
sample=[sample (randi([-1 0],100,1)*2+1).*rand(human,1) (randi([-1 0],100,1)*2+1).*rand(human,1) randi([-1 0],human,1) 0*eye(human,1)];
dt=0.01;
i=1;
p=0.05;
while ~any(sample(:,6))
    for j=1:human
        if rand<=0.05
            sample(j,6)=1;
        end
    end
end
while true
    if i == 1
        for k = 1 : human
            hold on;
            switch sample(k,6)
                case 0
                plot(sample(k,1), sample(k,2), '.k','MarkerSize',20);
                case 1
                    plot(sample(k,1), sample(k,2), '.r','MarkerSize',20);
                case 2
            end
            axis([-0.05 1.05 -0.05 1.05])
            hold off;
        end
    else
        h = findobj(gca,'Type','line');
        for k=1:human
            x=sample(k,1)+sample(k,3)*dt;
            y=sample(k,2)+sample(k,4)*dt;
            if x > 1-dt
                sample(k,1) = sample(k,1)*(1-dt);
                sample(k,3) = -sample(k,3);
            end
            if y > 1-dt
                sample(k,2) = sample(k,2)*(1-dt);
                sample(k,4) = -sample(k,4);
            end
            if x < -dt
                sample(k,1) = sample(k,1)*(1-dt);
                sample(k,3) = -sample(k,3);
            end
            if y < -dt
                sample(k,2) = sample(k,2)*(1-dt);
                sample(k,4) = -sample(k,4);
            end
            sample(k,1)=x;
            sample(k,2)=y;
            set(h(k),'XData',x)
            set(h(k),'YData',y)
        end
        drawnow
        pause(0.00000000001);
    end
    i=i+1;
end
