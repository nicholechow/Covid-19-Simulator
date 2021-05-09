clear all
close all
human=200;
sample.x=rand(human,1);
sample.y=rand(human,1);
sample.u=(randi([-1 0],human,1)*2+1).*rand(human,1);
sample.v=(randi([-1 0],human,1)*2+1).*rand(human,1);
sample.sick=0*eye(human,1);
sample.sick_time=0*eye(human,1);
sample.
dt=0.02;
i=0;
death_rate=0.02;
temp=randi([1 human],1);
sample.sick(temp)=1; %Intorducing a random sick

while ~isempty(find(sample.sick==1))
    if i == 0
        for k = 1 : human
            hold on;
            switch sample.sick(k)
                case 0 %Healthy
                    plot(sample.x(k), sample.y(k), '.b','MarkerSize',20);
                case 1 %Sick
                    plot(sample.x(k), sample.y(k), '.r','MarkerSize',20);
                case 2 %Recovered
                    plot(sample.x(k), sample.y(k), '.g','MarkerSize',20);
                case 3 %Dead
                    plot(sample.x(k), sample.y(k), '.k','MarkerSize',20);
            end
            axis([-0.05 1.05 -0.05 1.05])
            hold off;
        end
    else
        h = findobj(gca,'Type','line');
        for k=1:human
            if sample.sick(k)~=3
                x=sample.x(k)+sample.u(k)*dt;
                y=sample.y(k)+sample.v(k)*dt;
            else
                x=sample.x(k);
                y=sample.y(k);
            end
            if x > 1-dt
                sample.x(k) = sample.x(k)*(1-dt);
                sample.u(k) = -sample.u(k);
            end
            if y > 1-dt
                sample.y(k) = sample.y(k)*(1-dt);
                sample.v(k) = -sample.v(k);
            end
            if x < -dt
                sample.x(k) = sample.x(k)*(1-dt);
                sample.u(k) = -sample.u(k);
            end
            if y < -dt
                sample.y(k) = sample.y(k)*(1-dt);
                sample.v(k) = -sample.v(k);
            end
            sample.x(k)=x;
            sample.y(k)=y;
            if sample.sick(k)==1
                for jj=1:human
                    if k~=jj &&  norm([sample.x(jj) sample.y(jj)]-[sample.x(k) sample.y(k)])<=0.01 && sample.sick(jj)==0
                        sample.sick(jj)=1;
                        sample.sick_time(jj)= i*dt;
                    end
                end
            end
            
            for ii=1:human
                if dt*i-sample.sick_time(ii)==0.5 && sample.sick(ii)==1 && dt*i>=1
                    if rand<=death_rate
                        sample.sick(ii)=3;
                    else
                        sample.sick(ii)=2;
                    end
                end 
            end
            
            switch sample.sick(k)
                case 0 %Healthy
                    set(h(k),'XData',x,'YData',y,'Color','b')
                case 1 %Sick
                    set(h(k),'XData',x,'YData',y,'Color','r','Marker')
                case 2 %Recovered
                    set(h(k),'XData',x,'YData',y,'Color','g')
                case 3 %Dead
                    set(h(k),'XData',x,'YData',y,'Color','k')
            end
        end
        drawnow
    end
    i=i+1;
end