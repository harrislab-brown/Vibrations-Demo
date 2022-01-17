classdef ENGN1735_2735_Vibrations_Lab_GUI_v2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    % MATLAB defines the properties of each button, label, field on the GUI 
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        RefreshsettingsButton         matlab.ui.control.Button
        LightsButtonGroup             matlab.ui.container.ButtonGroup
        OnButton                      matlab.ui.control.RadioButton
        OnwithstrobingButton          matlab.ui.control.RadioButton
        OffButton                     matlab.ui.control.RadioButton
        ExternalspeakerIDEditField    matlab.ui.control.NumericEditField
        ExternalspeakerIDEditFieldLabel  matlab.ui.control.Label
        ENGN17352735LabUILabel        matlab.ui.control.Label
        DrivingAmplitudeSlider        matlab.ui.control.Slider
        DrivingAmplitudeSliderLabel   matlab.ui.control.Label
        StrobingfrequencyButtonGroup  matlab.ui.container.ButtonGroup
        StrobingfrequencyHzEditField  matlab.ui.control.NumericEditField
        StrobingfrequencyHzLabel      matlab.ui.control.Label
        Detuned3HzButton              matlab.ui.control.RadioButton
        Detuned2HzButton              matlab.ui.control.RadioButton
        UserdefinedfrequencyButton    matlab.ui.control.RadioButton
        Detuned1HzButton              matlab.ui.control.RadioButton
        SynchronizedButton            matlab.ui.control.RadioButton
        TurnoffsystemButton           matlab.ui.control.Button
        DrivingfrequencyHzEditField   matlab.ui.control.NumericEditField
        DrivingfrequencyHzLabel       matlab.ui.control.Label
        TurnonsystemButton            matlab.ui.control.Button
    end

    
    properties (Access = private)
        %The variables to operate the GUI. 
        A_strobe; %Amplitude of strobing or lights
        f_strobe; %Frequency of strobing or loghts 
        A_drive; %Amplitude of driving (depends on individual speaker) 
        % i.e. amplitdue of the speaker 
        f_drive; %Frequency of driving for the speaker
        done=0; %Variable to complete audio file. 
        stop1; %Variable to turn on/off the system
        player; %Output audio file, the sine wave
        refresh=0; %variable to enable refrshing with new parameters.
        % Description
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: TurnonsystemButton
        function TurnonsystemButtonPushed(app, event) 
            %app.variablename ensures the properties defined above are used
            %by the button.
            app.refresh=1; %Enable the ability to refresh
            Fs =40000; %Sampling frequency
            T=1/Fs; %Time period
            runtime=100; %time in seconds the code runs for
            a1=app.ExternalspeakerIDEditField.Value; %select external speaker ID
            t=0:T:runtime; %Loop over time steps
            app.stop1=0; 
            %y is the strobing signal with frequency omega2
            %x is the driving signal with frequency omega1
            while app.stop1==0 %turned on
                app.f_drive = app.DrivingfrequencyHzEditField.Value; %obtain driving frequency from field
                app.A_drive=app.DrivingAmplitudeSlider.Value; %obtain driving amplitude from slider
                if(app.OffButton.Value) %option to turn off strobing 
                    app.A_strobe=0; 
                    y=app.A_strobe.*ones([1,length(t)]);
                end
                if(app.OnButton.Value) % option to turn on strobing/constant source of light.
                    app.A_strobe=100; %can edit this value to dim or brighten the lights
                    y=app.A_strobe.*sin(2*pi*1000*t);
                end
                if(app.SynchronizedButton.Value && app.OnwithstrobingButton.Value) %option to turn on strobing
                    %with the same freqency as the driving frequency.
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2); %Square wave ensures the blinking of lights.
                end
                if(app.Detuned1HzButton.Value && app.OnwithstrobingButton.Value) %option to turn on strobing 
                    %with stroibng frequency greater than driving frequency
                    %by 1 unit.
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+1;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.UserdefinedfrequencyButton.Value && app.OnwithstrobingButton.Value) %user defined strobing frequncy.
                    app.A_strobe=0.1;
                    app.f_strobe=app.StrobingfrequencyHzEditField.Value;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.Detuned2HzButton.Value && app.OnwithstrobingButton.Value) %option to turn on strobing
                    %with stroibng frequency greater than driving frequency
                    %by 2 units.
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+2;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.Detuned3HzButton.Value && app.OnwithstrobingButton.Value) %option to turn on strobing
                    %with stroibng frequency greater than driving frequency
                    %by 3 units.
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+3;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                omega1 = 2*pi*app.f_drive;
                x=app.A_drive*sin(omega1*t);
                Out = [x; y]; %output to create audiofile
                app.player = audioplayer(Out, Fs, 16, a1); % generate audiofile
                play(app.player) %play audiofile
                pause(runtime) % runtime and loop execution time is same.
                app.stop1=1; 
            end
        end

        % Button pushed function: TurnoffsystemButton
        function TurnoffsystemButtonPushed(app, event)
            stop(app.player); %code to turn off button. 
            app.done=1; 
            app.refresh=0;
        end

        % Button pushed function: RefreshsettingsButton
        function RefreshsettingsButtonPushed(app, event)
        if app.refresh==1 %helps refresh code. Same code as turn system on button!
            app.refresh=1;
            Fs =40000;
            T=1/Fs;
            runtime=100;
            a1=app.ExternalspeakerIDEditField.Value;
            t=0:T:runtime;
            app.done=0;
            app.stop1=app.done;
            while app.stop1==0
                app.f_drive = app.DrivingfrequencyHzEditField.Value;
                app.A_drive=app.DrivingAmplitudeSlider.Value;
                if(app.OffButton.Value)
                    app.A_strobe=0;
                    y=app.A_strobe.*t;
                end
                if(app.OnButton.Value)
                    app.A_strobe=0.1;
                    y=app.A_strobe.*sin(2*pi*1000*t);
                end
                if(app.SynchronizedButton.Value && app.OnwithstrobingButton.Value)
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.Detuned1HzButton.Value && app.OnwithstrobingButton.Value)
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+1;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.UserdefinedfrequencyButton.Value && app.OnwithstrobingButton.Value)
                    app.A_strobe=0.1;
                    app.f_strobe=app.StrobingfrequencyHzEditField.Value;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.Detuned2HzButton.Value && app.OnwithstrobingButton.Value)
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+2;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                if(app.Detuned3HzButton.Value && app.OnwithstrobingButton.Value)
                    app.A_strobe=0.1;
                    app.f_strobe=app.f_drive+3;
                    omega2 = 2*pi*app.f_strobe;
                    y=app.A_strobe.*((square(omega2*t,20)+1)./2);
                end
                omega1 = 2*pi*app.f_drive;
                x=app.A_drive*sin(omega1*t);
                Out = [x; y];
                stop(app.player)
                app.player = audioplayer(Out, Fs, 16, a1);
                play(app.player)
                pause(runtime) 
                app.stop1=1;
            end
        end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 816 469];
            app.UIFigure.Name = 'UI Figure';

            % Create TurnonsystemButton
            app.TurnonsystemButton = uibutton(app.UIFigure, 'push');
            app.TurnonsystemButton.ButtonPushedFcn = createCallbackFcn(app, @TurnonsystemButtonPushed, true);
            app.TurnonsystemButton.Position = [129 51 140 60];
            app.TurnonsystemButton.Text = 'Turn on system';

            % Create DrivingfrequencyHzLabel
            app.DrivingfrequencyHzLabel = uilabel(app.UIFigure);
            app.DrivingfrequencyHzLabel.HorizontalAlignment = 'right';
            app.DrivingfrequencyHzLabel.Position = [28 306 125 22];
            app.DrivingfrequencyHzLabel.Text = 'Driving frequency (Hz)';

            % Create DrivingfrequencyHzEditField
            app.DrivingfrequencyHzEditField = uieditfield(app.UIFigure, 'numeric');
            app.DrivingfrequencyHzEditField.Limits = [0 1000];
            app.DrivingfrequencyHzEditField.Position = [168 306 100 22];

            % Create TurnoffsystemButton
            app.TurnoffsystemButton = uibutton(app.UIFigure, 'push');
            app.TurnoffsystemButton.ButtonPushedFcn = createCallbackFcn(app, @TurnoffsystemButtonPushed, true);
            app.TurnoffsystemButton.Position = [549 51 140 60];
            app.TurnoffsystemButton.Text = 'Turn off system';

            % Create StrobingfrequencyButtonGroup
            app.StrobingfrequencyButtonGroup = uibuttongroup(app.UIFigure);
            app.StrobingfrequencyButtonGroup.Title = 'Strobing frequency';
            app.StrobingfrequencyButtonGroup.BackgroundColor = [1 1 1];
            app.StrobingfrequencyButtonGroup.Position = [504 206 296 178];

            % Create SynchronizedButton
            app.SynchronizedButton = uiradiobutton(app.StrobingfrequencyButtonGroup);
            app.SynchronizedButton.Text = 'Synchronized';
            app.SynchronizedButton.Position = [11 132 124 22];
            app.SynchronizedButton.Value = true;

            % Create Detuned1HzButton
            app.Detuned1HzButton = uiradiobutton(app.StrobingfrequencyButtonGroup);
            app.Detuned1HzButton.Text = 'Detuned +1 Hz';
            app.Detuned1HzButton.Position = [11 110 102 22];

            % Create UserdefinedfrequencyButton
            app.UserdefinedfrequencyButton = uiradiobutton(app.StrobingfrequencyButtonGroup);
            app.UserdefinedfrequencyButton.Text = 'User defined frequency';
            app.UserdefinedfrequencyButton.Position = [11 47 146 22];

            % Create Detuned2HzButton
            app.Detuned2HzButton = uiradiobutton(app.StrobingfrequencyButtonGroup);
            app.Detuned2HzButton.Text = 'Detuned +2 Hz';
            app.Detuned2HzButton.Position = [11 89 102 22];

            % Create Detuned3HzButton
            app.Detuned3HzButton = uiradiobutton(app.StrobingfrequencyButtonGroup);
            app.Detuned3HzButton.Text = 'Detuned +3 Hz';
            app.Detuned3HzButton.Position = [11 68 102 22];

            % Create StrobingfrequencyHzLabel
            app.StrobingfrequencyHzLabel = uilabel(app.StrobingfrequencyButtonGroup);
            app.StrobingfrequencyHzLabel.HorizontalAlignment = 'right';
            app.StrobingfrequencyHzLabel.Position = [11 18 132 22];
            app.StrobingfrequencyHzLabel.Text = 'Strobing frequency (Hz)';

            % Create StrobingfrequencyHzEditField
            app.StrobingfrequencyHzEditField = uieditfield(app.StrobingfrequencyButtonGroup, 'numeric');
            app.StrobingfrequencyHzEditField.Limits = [0 1000];
            app.StrobingfrequencyHzEditField.Position = [158 18 101 22];

            % Create DrivingAmplitudeSliderLabel
            app.DrivingAmplitudeSliderLabel = uilabel(app.UIFigure);
            app.DrivingAmplitudeSliderLabel.HorizontalAlignment = 'right';
            app.DrivingAmplitudeSliderLabel.Position = [28 166 100 22];
            app.DrivingAmplitudeSliderLabel.Text = 'Driving Amplitude';

            % Create DrivingAmplitudeSlider
            app.DrivingAmplitudeSlider = uislider(app.UIFigure);
            app.DrivingAmplitudeSlider.Limits = [0 0.2];
            app.DrivingAmplitudeSlider.Position = [149 175 623 3];

            % Create ENGN17352735LabUILabel
            app.ENGN17352735LabUILabel = uilabel(app.UIFigure);
            app.ENGN17352735LabUILabel.FontSize = 24;
            app.ENGN17352735LabUILabel.FontWeight = 'bold';
            app.ENGN17352735LabUILabel.Position = [268 411 282 30];
            app.ENGN17352735LabUILabel.Text = 'ENGN 1735/2735 Lab UI';

            % Create ExternalspeakerIDEditFieldLabel
            app.ExternalspeakerIDEditFieldLabel = uilabel(app.UIFigure);
            app.ExternalspeakerIDEditFieldLabel.HorizontalAlignment = 'right';
            app.ExternalspeakerIDEditFieldLabel.FontSize = 10;
            app.ExternalspeakerIDEditFieldLabel.Position = [635 11 93 22];
            app.ExternalspeakerIDEditFieldLabel.Text = 'External speaker ID';

            % Create ExternalspeakerIDEditField
            app.ExternalspeakerIDEditField = uieditfield(app.UIFigure, 'numeric');
            app.ExternalspeakerIDEditField.Limits = [0 150];
            app.ExternalspeakerIDEditField.FontSize = 10;
            app.ExternalspeakerIDEditField.Position = [743 11 57 22];

            % Create LightsButtonGroup
            app.LightsButtonGroup = uibuttongroup(app.UIFigure);
            app.LightsButtonGroup.Title = 'Lights';
            app.LightsButtonGroup.BackgroundColor = [1 1 1];
            app.LightsButtonGroup.Position = [326 274 133 91];

            % Create OffButton
            app.OffButton = uiradiobutton(app.LightsButtonGroup);
            app.OffButton.Text = 'Off';
            app.OffButton.Position = [11 45 58 22];
            app.OffButton.Value = true;

            % Create OnwithstrobingButton
            app.OnwithstrobingButton = uiradiobutton(app.LightsButtonGroup);
            app.OnwithstrobingButton.Text = 'On with strobing';
            app.OnwithstrobingButton.Position = [11 3 115 22];

            % Create OnButton
            app.OnButton = uiradiobutton(app.LightsButtonGroup);
            app.OnButton.Text = 'On';
            app.OnButton.Position = [11 24 58 22];

            % Create RefreshsettingsButton
            app.RefreshsettingsButton = uibutton(app.UIFigure, 'push');
            app.RefreshsettingsButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshsettingsButtonPushed, true);
            app.RefreshsettingsButton.Position = [339 51 140 60];
            app.RefreshsettingsButton.Text = 'Refresh settings';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ENGN1735_2735_Vibrations_Lab_GUI_v2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end