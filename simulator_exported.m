classdef simulator_exported < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        SimulationUIFigure            matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        LeftPanel                     matlab.ui.container.Panel
        DeathRateEditFieldLabel       matlab.ui.control.Label
        SimulationButton              matlab.ui.control.Button
        PoolTestingDropDownLabel      matlab.ui.control.Label
        DeathRateEditField            matlab.ui.control.NumericEditField
        PoolTestingDropDown           matlab.ui.control.DropDown
        VaccinationRatioSliderLabel   matlab.ui.control.Label
        VaccinationRatioSlider        matlab.ui.control.Slider
        StayAtHomeSwitchLabel         matlab.ui.control.Label
        StayAtHomeSwitch              matlab.ui.control.Switch
        AtHomeRationSliderLabel       matlab.ui.control.Label
        AtHomeRationSlider            matlab.ui.control.Slider
        MaxConcurrentlySickEditFieldLabel  matlab.ui.control.Label
        MaxConcurrentlySickEditField  matlab.ui.control.NumericEditField
        HealthyEditFieldLabel         matlab.ui.control.Label
        HealthyEditField              matlab.ui.control.NumericEditField
        RecoveredEditFieldLabel       matlab.ui.control.Label
        RecoveredEditField            matlab.ui.control.NumericEditField
        SickEditFieldLabel            matlab.ui.control.Label
        SickEditField                 matlab.ui.control.NumericEditField
        DeadEditFieldLabel            matlab.ui.control.Label
        DeadEditField                 matlab.ui.control.NumericEditField
        SampleSizeSliderLabel         matlab.ui.control.Label
        SampleSizeSlider              matlab.ui.control.Slider
        QuarantineEditFieldLabel      matlab.ui.control.Label
        QuarantineEditField           matlab.ui.control.NumericEditField
        RightPanel                    matlab.ui.container.Panel
        MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel  matlab.ui.control.Label
        UIAxes                        matlab.ui.control.UIAxes
        SimulationUIAxes              matlab.ui.control.UIAxes
    end
    
    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end
    
    % Callbacks that handle component events
    methods (Access = private)
        
        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.SimulationUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {651, 651};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {296, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
        
        % Button pushed function: SimulationButton
        function SimulationButtonPushed(app, event)
            value=round(app.SampleSizeSlider.Value);
            cla(app.SimulationUIAxes)
            sample.x=rand(value,1);
            sample.y=rand(value,1);
            sample.u=(randi([-1 0],value,1)*2+1).*rand(value,1);
            sample.v=(randi([-1 0],value,1)*2+1).*rand(value,1);
            sample.sick=0*eye(value,1);
            sample.sick_time=0*eye(value,1);
            sample.status=0*eye(value,1);
            dt=0.01*(value/100);
            i=0;
            temp=randi([1 value],1);
            sample.sick(temp)=1; %Intorducing a random sick
            vaccination_ratio=app.VaccinationRatioSlider.Value/100;
            
            for ii=1:value
                if sample.sick(ii)~=1 && rand<=vaccination_ratio
                    sample.sick(ii)=2;
                end
            end
            if numel(app.StayAtHomeSwitch.Value)== 2
                for ii=1:value
                    if rand<=app.AtHomeRationSlider.Value/100 && sample.sick(ii)~=1
                        sample.status(ii)=1;
                    end
                end
            end
            
            while ~isempty(find(sample.sick==1))
                if i == 0
                    for k = 1 : value
                        hold(app.SimulationUIAxes,'on');
                        switch sample.sick(k)
                            case 0 %Healthy
                                plot(app.SimulationUIAxes,sample.x(k), sample.y(k), '.b','MarkerSize',20);
                            case 1 %Sick
                                plot(app.SimulationUIAxes,sample.x(k), sample.y(k), '.r','MarkerSize',20);
                            case 2 %Recovered
                                plot(app.SimulationUIAxes,sample.x(k), sample.y(k), '.g','MarkerSize',20);
                            case 3 %Dead
                                plot(app.SimulationUIAxes,sample.x(k), sample.y(k), '.k','MarkerSize',20);
                        end
                        hold(app.SimulationUIAxes,'off');
                    end
                else
                    h = findobj(app.SimulationUIAxes,'Type','line');
                    for k=1:value
                        if sample.sick(k)==3 || sample.status(k)==1 %stay at home
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
                        if sample.sick(k)==1 && sample.status(k)~=2
                            for jj=1:value
                                if k~=jj &&  norm([sample.x(jj) sample.y(jj)]-[sample.x(k) sample.y(k)])<=0.01 && sample.sick(jj)==0
                                    sample.sick(jj)=1;
                                    sample.sick_time(jj)= i*dt;
                                end
                            end
                        end
                        %Death or Recover
                        for ii=1:value
                            if dt*i-sample.sick_time(ii)>=1 && sample.sick(ii)==1
                                if rand<=app.DeathRateEditField.Value
                                    sample.sick(ii)=3;
                                else
                                    sample.sick(ii)=2;
                                end
                            end
                        end
                        
                        switch sample.status(k)
                            case 1
                                sign='x';
                                fontsize=12;
                            case 2
                                sign='p';
                                fontsize=10;
                            otherwise
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
                    drawnow limitrate
                end
                
                i=i+1;
                record.healthy(i)=numel(find(sample.sick==0));
                record.sick(i)=numel(find(sample.sick==1));
                record.recovered(i)=numel(find(sample.sick==2));
                record.dead(i)=numel(find(sample.sick==3));
                
                cla(app.UIAxes)
                hold(app.UIAxes,'on');
                plot(app.UIAxes,record.healthy,'b')
                plot(app.UIAxes,record.sick,'r')
                plot(app.UIAxes,record.recovered,'g')
                plot(app.UIAxes,record.dead,'k')
                hold(app.UIAxes,'off');
                app.HealthyEditField.Value=record.healthy(i);
                app.RecoveredEditField.Value=record.recovered(i);
                app.SickEditField.Value=record.sick(i);
                app.DeadEditField.Value=record.dead(i);
                app.MaxConcurrentlySickEditField.Value=max(record.sick);
                
                if i==round(7000*dt)
                    [output,T_round1]=main(sample.sick);
                    if isequal(app.PoolTestingDropDown.Value,'Two-pass Testing')
                        for ii=output
                            sample.status(ii)=2;
                        end
                    else
                        if isequal(app.PoolTestingDropDown.Value,'Single-pass Testing')
                            for ii=T_round1
                                sample.status(ii)=2;
                            end
                        end
                    end
                end
            end
        end
    end
    
    % Component initialization
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)
            
            % Create SimulationUIFigure and hide until all components are created
            app.SimulationUIFigure = uifigure('Visible', 'off');
            app.SimulationUIFigure.AutoResizeChildren = 'off';
            app.SimulationUIFigure.Position = [100 100 708 651];
            app.SimulationUIFigure.Name = 'Covid-19 Simulator';
            app.SimulationUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);
            
            % Create GridLayout
            app.GridLayout = uigridlayout(app.SimulationUIFigure);
            app.GridLayout.ColumnWidth = {296, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';
            
            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;
            app.LeftPanel.Scrollable = 'on';
            
            % Create DeathRateEditFieldLabel
            app.DeathRateEditFieldLabel = uilabel(app.LeftPanel);
            app.DeathRateEditFieldLabel.HorizontalAlignment = 'right';
            app.DeathRateEditFieldLabel.Position = [31 300 88 22];
            app.DeathRateEditFieldLabel.Text = 'Death Rate';
            
            % Create SimulationButton
            app.SimulationButton = uibutton(app.LeftPanel, 'push');
            app.SimulationButton.ButtonPushedFcn = createCallbackFcn(app, @SimulationButtonPushed, true);
            app.SimulationButton.Position = [82 264 108 22];
            app.SimulationButton.Text = 'Simulation';
            
            % Create PoolTestingDropDownLabel
            app.PoolTestingDropDownLabel = uilabel(app.LeftPanel);
            app.PoolTestingDropDownLabel.HorizontalAlignment = 'right';
            app.PoolTestingDropDownLabel.Position = [40 490 71 22];
            app.PoolTestingDropDownLabel.Text = 'Pool Testing';
            
            % Create DeathRateEditField
            app.DeathRateEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DeathRateEditField.Limits = [0 1];
            app.DeathRateEditField.Position = [134 300 100 22];
            app.DeathRateEditField.Value = 0.02;
            
            % Create PoolTestingDropDown
            app.PoolTestingDropDown = uidropdown(app.LeftPanel);
            app.PoolTestingDropDown.Items = {'None', 'Two-pass Testing', 'Single-pass Testing'};
            app.PoolTestingDropDown.Position = [126 490 100 22];
            app.PoolTestingDropDown.Value = 'None';
            
            % Create VaccinationRatioSliderLabel
            app.VaccinationRatioSliderLabel = uilabel(app.LeftPanel);
            app.VaccinationRatioSliderLabel.HorizontalAlignment = 'right';
            app.VaccinationRatioSliderLabel.Position = [20 552 99 22];
            app.VaccinationRatioSliderLabel.Text = 'Vaccination Ratio';
            
            % Create VaccinationRatioSlider
            app.VaccinationRatioSlider = uislider(app.LeftPanel);
            app.VaccinationRatioSlider.Position = [140 561 94 3];
            
            % Create StayAtHomeSwitchLabel
            app.StayAtHomeSwitchLabel = uilabel(app.LeftPanel);
            app.StayAtHomeSwitchLabel.HorizontalAlignment = 'center';
            app.StayAtHomeSwitchLabel.Position = [93 412 80 22];
            app.StayAtHomeSwitchLabel.Text = 'Stay At Home';
            
            % Create StayAtHomeSwitch
            app.StayAtHomeSwitch = uiswitch(app.LeftPanel, 'slider');
            app.StayAtHomeSwitch.Position = [110 449 45 20];
            
            % Create AtHomeRationSliderLabel
            app.AtHomeRationSliderLabel = uilabel(app.LeftPanel);
            app.AtHomeRationSliderLabel.HorizontalAlignment = 'right';
            app.AtHomeRationSliderLabel.Position = [6 365 91 22];
            app.AtHomeRationSliderLabel.Text = 'At Home Ration';
            
            % Create AtHomeRationSlider
            app.AtHomeRationSlider = uislider(app.LeftPanel);
            app.AtHomeRationSlider.Position = [118 374 150 3];
            
            % Create MaxConcurrentlySickEditFieldLabel
            app.MaxConcurrentlySickEditFieldLabel = uilabel(app.LeftPanel);
            app.MaxConcurrentlySickEditFieldLabel.HorizontalAlignment = 'right';
            app.MaxConcurrentlySickEditFieldLabel.Position = [27 19 127 22];
            app.MaxConcurrentlySickEditFieldLabel.Text = 'Max Concurrently Sick';
            
            % Create MaxConcurrentlySickEditField
            app.MaxConcurrentlySickEditField = uieditfield(app.LeftPanel, 'numeric');
            app.MaxConcurrentlySickEditField.Position = [168 19 100 22];
            
            % Create HealthyEditFieldLabel
            app.HealthyEditFieldLabel = uilabel(app.LeftPanel);
            app.HealthyEditFieldLabel.HorizontalAlignment = 'right';
            app.HealthyEditFieldLabel.FontColor = [0 0 1];
            app.HealthyEditFieldLabel.Position = [40 225 46 22];
            app.HealthyEditFieldLabel.Text = 'Healthy';
            
            % Create HealthyEditField
            app.HealthyEditField = uieditfield(app.LeftPanel, 'numeric');
            app.HealthyEditField.Position = [101 225 100 22];
            
            % Create RecoveredEditFieldLabel
            app.RecoveredEditFieldLabel = uilabel(app.LeftPanel);
            app.RecoveredEditFieldLabel.HorizontalAlignment = 'right';
            app.RecoveredEditFieldLabel.FontColor = [0.3922 0.8314 0.0745];
            app.RecoveredEditFieldLabel.Position = [40 183 63 22];
            app.RecoveredEditFieldLabel.Text = 'Recovered';
            
            % Create RecoveredEditField
            app.RecoveredEditField = uieditfield(app.LeftPanel, 'numeric');
            app.RecoveredEditField.Position = [118 183 100 22];
            
            % Create SickEditFieldLabel
            app.SickEditFieldLabel = uilabel(app.LeftPanel);
            app.SickEditFieldLabel.HorizontalAlignment = 'right';
            app.SickEditFieldLabel.FontColor = [1 0 0];
            app.SickEditFieldLabel.Position = [40 146 29 22];
            app.SickEditFieldLabel.Text = 'Sick';
            
            % Create SickEditField
            app.SickEditField = uieditfield(app.LeftPanel, 'numeric');
            app.SickEditField.Position = [84 146 100 22];
            
            % Create DeadEditFieldLabel
            app.DeadEditFieldLabel = uilabel(app.LeftPanel);
            app.DeadEditFieldLabel.HorizontalAlignment = 'right';
            app.DeadEditFieldLabel.Position = [40 101 34 22];
            app.DeadEditFieldLabel.Text = 'Dead';
            
            % Create DeadEditField
            app.DeadEditField = uieditfield(app.LeftPanel, 'numeric');
            app.DeadEditField.Position = [89 101 100 22];
            
            % Create SampleSizeSliderLabel
            app.SampleSizeSliderLabel = uilabel(app.LeftPanel);
            app.SampleSizeSliderLabel.HorizontalAlignment = 'right';
            app.SampleSizeSliderLabel.Position = [6 607 72 22];
            app.SampleSizeSliderLabel.Text = 'Sample Size';
            
            % Create SampleSizeSlider
            app.SampleSizeSlider = uislider(app.LeftPanel);
            app.SampleSizeSlider.Limits = [50 200];
            app.SampleSizeSlider.Position = [99 616 150 3];
            app.SampleSizeSlider.Value = 50;
            
            % Create QuarantineEditFieldLabel
            app.QuarantineEditFieldLabel = uilabel(app.LeftPanel);
            app.QuarantineEditFieldLabel.HorizontalAlignment = 'right';
            app.QuarantineEditFieldLabel.FontColor = [0.9294 0.6941 0.1255];
            app.QuarantineEditFieldLabel.Position = [35 60 64 22];
            app.QuarantineEditFieldLabel.Text = 'Quarantine';
            
            % Create QuarantineEditField
            app.QuarantineEditField = uieditfield(app.LeftPanel, 'numeric');
            app.QuarantineEditField.Position = [114 60 100 22];
            
            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;
            app.RightPanel.Scrollable = 'on';
            
            % Create MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel
            app.MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel = uilabel(app.RightPanel);
            app.MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel.FontSize = 20;
            app.MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel.FontColor = [0.149 0.149 0.149];
            app.MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel.Position = [38 81 324 76];
            app.MovingSampleAtHomeSampleQuarantineCannotInfectOthersLabel.Text = {'● Moving Sample'; '✖ At Home Sample'; '★Quarantine(Cannot Infect Others)'};
            
            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'SIR model')
            xlabel(app.UIAxes, 't')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.PlotBoxAspectRatio = [2.16428571428571 1 1];
            app.UIAxes.Position = [11 183 370 217];
            
            % Create SimulationUIAxes
            app.SimulationUIAxes = uiaxes(app.RightPanel);
            title(app.SimulationUIAxes, 'Simulation')
            app.SimulationUIAxes.PlotBoxAspectRatio = [2.09539473684211 1 1];
            app.SimulationUIAxes.XLim = [-0.05 1.05];
            app.SimulationUIAxes.YLim = [-0.05 1.05];
            app.SimulationUIAxes.Position = [11 412 364 208];
            
            % Show the figure after all components are created
            app.SimulationUIFigure.Visible = 'on';
        end
    end
    
    % App creation and deletion
    methods (Access = public)
        
        % Construct app
        function app = simulator_exported
            
            % Create UIFigure and components
            createComponents(app)
            
            % Register the app with App Designer
            registerApp(app, app.SimulationUIFigure)
            
            if nargout == 0
                clear app
            end
        end
        
        % Code that executes before app deletion
        function delete(app)
            
            % Delete UIFigure when app is deleted
            delete(app.SimulationUIFigure)
        end
    end
end