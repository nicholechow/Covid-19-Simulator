clear all
close all

human=200;
sample.x=rand(human,1);
sample.y=rand(human,1);
sample.u=(randi([-1 0],human,1)*2+1).*rand(human,1);
sample.v=(randi([-1 0],human,1)*2+1).*rand(human,1);
sample.sick=0*eye(human,1);
sample.sick_time=0*eye(human,1);
sample.status=0*eye(human,1);
stay_at_home=false;
testing=false;
dt=0.02;
i=0;
death_rate=0.02;

temp=randi([1 human],1);
sample.sick(temp)=1; %Intorducing a random sick
vaccination_ratio=0;
for ii=1:human
    if sample.sick(ii)~=1 && rand<=vaccination_ratio
        sample.sick(ii)=2;
    end
end
if stay_at_home
    for ii=1:human
        if rand<=0.8 && sample.sick(ii)~=1
            sample.status(ii)=1;
        end
    end
end
while ~isempty(find(sample.sick==1)) || dt*i==20
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
            if sample.sick(k)==3 || sample.status(k)==1
                x=sample.x(k);
                y=sample.y(k);
            else
                x=sample.x(k)+sample.u(k)*dt;
                y=sample.y(k)+sample.v(k)*dt;
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
            %Death or Recover
            for ii=1:human
                if dt*i-sample.sick_time(ii)>=1 && sample.sick(ii)==1 && i>=30
                    if rand<=death_rate
                        sample.sick(ii)=3;
                    else
                        sample.sick(ii)=2;
                    end
                end
            end
            if sample.status(k)==1
                sign='x';
                fontsize=12;
            else
                sign='.';
                fontsize=20;
            end
            switch sample.sick(k)
                case 0 %Healthy
                    set(h(k),'XData',x,'YData',y,'Color','b','Marker',sign,'MarkerSize',fontsize)
                case 1 %Sick
                    set(h(k),'XData',x,'YData',y,'Color','r','Marker',sign,'MarkerSize',fontsize)
                case 2 %Recovered
                    set(h(k),'XData',x,'YData',y,'Color','g','Marker',sign,'MarkerSize',fontsize)
                case 3 %Dead
                    set(h(k),'XData',x,'YData',y,'Color','k','Marker',sign,'MarkerSize',fontsize)
            end
        end
        drawnow
    end
    i=i+1;
    record.healthy(i)=numel(find(sample.sick==0));
    record.sick(i)=numel(find(sample.sick==1));
    record.recovered(i)=numel(find(sample.sick==2));
    record.dead(i)=numel(find(sample.sick==3));
end
