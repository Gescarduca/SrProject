classdef stanford_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Menu                           matlab.ui.container.Menu
        PlotTrajectoryButton           matlab.ui.control.Button
        Final_search_q6                matlab.ui.control.NumericEditField
        Final_search_q6EditFieldLabel  matlab.ui.control.Label
        Final_search_q5                matlab.ui.control.NumericEditField
        Final_search_q5EditFieldLabel  matlab.ui.control.Label
        Final_search_q4                matlab.ui.control.NumericEditField
        Final_search_q4EditFieldLabel  matlab.ui.control.Label
        Final_search_q3                matlab.ui.control.NumericEditField
        Final_search_q3EditFieldLabel  matlab.ui.control.Label
        Final_search_q2                matlab.ui.control.NumericEditField
        Final_search_q2EditFieldLabel  matlab.ui.control.Label
        Final_search_q1                matlab.ui.control.NumericEditField
        Final_search_q1EditFieldLabel  matlab.ui.control.Label
        Start_search_q6                matlab.ui.control.NumericEditField
        Start_search_q6EditFieldLabel  matlab.ui.control.Label
        Start_search_q5                matlab.ui.control.NumericEditField
        Start_search_q5EditFieldLabel  matlab.ui.control.Label
        Start_search_q4                matlab.ui.control.NumericEditField
        Start_search_q4EditFieldLabel  matlab.ui.control.Label
        Start_search_q3                matlab.ui.control.NumericEditField
        Start_search_q3EditFieldLabel  matlab.ui.control.Label
        Start_search_q2                matlab.ui.control.NumericEditField
        Start_search_q2EditFieldLabel  matlab.ui.control.Label
        Start_search_q1                matlab.ui.control.NumericEditField
        Start_search_q1EditFieldLabel  matlab.ui.control.Label
        final_z                        matlab.ui.control.NumericEditField
        final_zEditFieldLabel          matlab.ui.control.Label
        final_y                        matlab.ui.control.NumericEditField
        final_yEditFieldLabel          matlab.ui.control.Label
        final_x                        matlab.ui.control.NumericEditField
        final_xEditFieldLabel          matlab.ui.control.Label
        z_coordinate                   matlab.ui.control.NumericEditField
        initial_zLabel                 matlab.ui.control.Label
        y_coordinate                   matlab.ui.control.NumericEditField
        initial_yLabel                 matlab.ui.control.Label
        x_coordinate                   matlab.ui.control.NumericEditField
        inital_xLabel                  matlab.ui.control.Label
        q6                             matlab.ui.control.NumericEditField
        q6EditFieldLabel               matlab.ui.control.Label
        q5                             matlab.ui.control.NumericEditField
        q5EditFieldLabel               matlab.ui.control.Label
        q4                             matlab.ui.control.NumericEditField
        q4EditFieldLabel               matlab.ui.control.Label
        q3                             matlab.ui.control.NumericEditField
        q3EditFieldLabel               matlab.ui.control.Label
        q2                             matlab.ui.control.NumericEditField
        q2EditFieldLabel               matlab.ui.control.Label
        q1                             matlab.ui.control.NumericEditField
        q1EditFieldLabel               matlab.ui.control.Label
        KinematicsSwitch               matlab.ui.control.Switch
        KinematicsSwitchLabel          matlab.ui.control.Label
        CalculateButton                matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            %app;
            %delete(app.UIFigure)
            
        end

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            knToCalculate = string(app.KinematicsSwitch.Value);
            Th1 = string(app.q1.Value);
            Th2 = string(app.q2.Value);
            Th3 = string(app.q3.Value);
            Th4 = string(app.q4.Value);
            Th5 = string(app.q5.Value);
            Th6 = string(app.q6.Value);
            mdl_stanford;
            if Th1 ~= "" && Th2 ~= "" && Th3 ~= "" && Th4 ~= "" && Th5 ~= "" && Th6 ~= "" 
                j1 = str2double(Th1)*pi/180;
                j2 = str2double(Th2)*pi/180;
                j3 = str2double(Th3)*pi/180;
                j4 = str2double(Th4)*pi/180;
                j5 = str2double(Th5)*pi/180;
                j6 = str2double(Th6)*pi/180;
                 if knToCalculate == "Forward"
                    T = stanf.fkine([j1,j2,j3,j4,j5,j6]);
                    stanf.plot([j1,j2,j3,j4,j5,j6]);
                    %set coordinate fields to fkine resulst
                    x = T.t(1);
                    y= T.t(2);
                    z = T.t(3);
                    app.x_coordinate.Value = x;
                    app.y_coordinate.Value = y;
                    app.z_coordinate.Value = z;
                 end
                 
                 if knToCalculate == "Inverse"
                     x = app.x_coordinate.Value;
                     y = app.y_coordinate.Value;
                     z = app.z_coordinate.Value;
                     T = stanf.ikine6s([x,y,z]);
                     if not (T(3)<0)
                         stanf.plot(T); 
                     else
                        fig = uifigure;
                        uialert(fig,'Value cannot be negative for prismatic joint','Invalid Value');
                     end
                     
                 end
            end
        end

        % Menu selected function: Menu
        function MenuSelected(app, event)
            twoLinkAppDesigner
            delete(app)
        end

        % Button pushed function: PlotTrajectoryButton
        function PlotTrajectoryButtonPushed(app, event)
             start_angle_q1 = app.Start_search_q1.Value*pi/180;
             start_angle_q2 = app.Start_search_q2.Value*pi/180;
             start_angle_q3 = app.Start_search_q3.Value*pi/180;
             start_angle_q4 = app.Start_search_q4.Value*pi/180;
             start_angle_q5 = app.Start_search_q5.Value*pi/180;
             start_angle_q6 = app.Start_search_q6.Value*pi/180;
             
             final_search_q1 = app.Final_search_q1.Value*pi/180;
             final_search_q2 = app.Final_search_q2.Value*pi/180;
             final_search_q3 = app.Final_search_q3.Value*pi/180;
             final_search_q4 = app.Final_search_q4.Value*pi/180;
             final_search_q5 = app.Final_search_q5.Value*pi/180;
             final_search_q6 = app.Final_search_q6.Value*pi/180;
             
             start_pos_x = app.x_coordinate.Value;
             start_pos_y = app.y_coordinate.Value;
             start_pos_z = app.z_coordinate.Value;
             
             final_pos_x = app.final_x.Value;
             final_pos_y = app.final_y.Value;
             final_pos_z = app.final_z.Value;
             
             T1= transl(start_pos_x, start_pos_y, start_pos_z);
             T2 = transl(final_pos_x,final_pos_y,final_pos_z);
             
             %check if sum of position is less than max value in workspace
             
             if (start_pos_x+start_pos_y+start_pos_z)>2 || (start_pos_x+start_pos_y+start_pos_z)<2
                 uialert(app.UIFigure,"Values are outside of robot workspace, must be between -2 and 2 in all axes");
             
             
             else
                  start_k = twolink.ikine6s(T1,'q0',[start_angle_q1 start_angle_q2 start_angle_q3 start_angle_q4 start_angle_q5 start_angle_q6],'mask',[1 1 1 0 0 0]);
                  final_k = twolink.ikine6s(T2,'q0',[final_search_q1 final_search_q2 final_search_q3 final_search_q4 final_search_q5 final_search_q6],'mask',[1 1 1 0 0 0]);
                  if isempty(start_k) || isempty(final_k)
                      uialert(app.UIFigure,"One of the ")
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
            app.UIFigure.Position = [100 100 850 645];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create Menu
            app.Menu = uimenu(app.UIFigure);
            app.Menu.MenuSelectedFcn = createCallbackFcn(app, @MenuSelected, true);
            app.Menu.Text = 'Menu';

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [36 103 100 22];
            app.CalculateButton.Text = 'Calculate';

            % Create KinematicsSwitchLabel
            app.KinematicsSwitchLabel = uilabel(app.UIFigure);
            app.KinematicsSwitchLabel.HorizontalAlignment = 'center';
            app.KinematicsSwitchLabel.Position = [51 147 64 22];
            app.KinematicsSwitchLabel.Text = 'Kinematics';

            % Create KinematicsSwitch
            app.KinematicsSwitch = uiswitch(app.UIFigure, 'slider');
            app.KinematicsSwitch.Items = {'Forward', 'Inverse'};
            app.KinematicsSwitch.Position = [59 184 45 20];
            app.KinematicsSwitch.Value = 'Forward';

            % Create q1EditFieldLabel
            app.q1EditFieldLabel = uilabel(app.UIFigure);
            app.q1EditFieldLabel.HorizontalAlignment = 'right';
            app.q1EditFieldLabel.Position = [51 572 25 22];
            app.q1EditFieldLabel.Text = 'q1';

            % Create q1
            app.q1 = uieditfield(app.UIFigure, 'numeric');
            app.q1.Position = [91 572 100 22];

            % Create q2EditFieldLabel
            app.q2EditFieldLabel = uilabel(app.UIFigure);
            app.q2EditFieldLabel.HorizontalAlignment = 'right';
            app.q2EditFieldLabel.Position = [51 525 25 22];
            app.q2EditFieldLabel.Text = 'q2';

            % Create q2
            app.q2 = uieditfield(app.UIFigure, 'numeric');
            app.q2.Position = [91 525 100 22];

            % Create q3EditFieldLabel
            app.q3EditFieldLabel = uilabel(app.UIFigure);
            app.q3EditFieldLabel.HorizontalAlignment = 'right';
            app.q3EditFieldLabel.Position = [51 484 25 22];
            app.q3EditFieldLabel.Text = 'q3';

            % Create q3
            app.q3 = uieditfield(app.UIFigure, 'numeric');
            app.q3.Position = [91 484 100 22];

            % Create q4EditFieldLabel
            app.q4EditFieldLabel = uilabel(app.UIFigure);
            app.q4EditFieldLabel.HorizontalAlignment = 'right';
            app.q4EditFieldLabel.Position = [52 442 25 22];
            app.q4EditFieldLabel.Text = 'q4';

            % Create q4
            app.q4 = uieditfield(app.UIFigure, 'numeric');
            app.q4.Position = [92 442 100 22];

            % Create q5EditFieldLabel
            app.q5EditFieldLabel = uilabel(app.UIFigure);
            app.q5EditFieldLabel.HorizontalAlignment = 'right';
            app.q5EditFieldLabel.Position = [51 400 25 22];
            app.q5EditFieldLabel.Text = 'q5';

            % Create q5
            app.q5 = uieditfield(app.UIFigure, 'numeric');
            app.q5.Position = [91 400 100 22];

            % Create q6EditFieldLabel
            app.q6EditFieldLabel = uilabel(app.UIFigure);
            app.q6EditFieldLabel.HorizontalAlignment = 'right';
            app.q6EditFieldLabel.Position = [51 362 25 22];
            app.q6EditFieldLabel.Text = 'q6';

            % Create q6
            app.q6 = uieditfield(app.UIFigure, 'numeric');
            app.q6.Position = [91 362 100 22];

            % Create inital_xLabel
            app.inital_xLabel = uilabel(app.UIFigure);
            app.inital_xLabel.HorizontalAlignment = 'right';
            app.inital_xLabel.Position = [251 572 43 22];
            app.inital_xLabel.Text = 'inital_x';

            % Create x_coordinate
            app.x_coordinate = uieditfield(app.UIFigure, 'numeric');
            app.x_coordinate.Position = [309 572 100 22];

            % Create initial_yLabel
            app.initial_yLabel = uilabel(app.UIFigure);
            app.initial_yLabel.HorizontalAlignment = 'right';
            app.initial_yLabel.Position = [249 525 46 22];
            app.initial_yLabel.Text = 'initial_y';

            % Create y_coordinate
            app.y_coordinate = uieditfield(app.UIFigure, 'numeric');
            app.y_coordinate.Position = [310 525 100 22];

            % Create initial_zLabel
            app.initial_zLabel = uilabel(app.UIFigure);
            app.initial_zLabel.HorizontalAlignment = 'right';
            app.initial_zLabel.Position = [248 484 46 22];
            app.initial_zLabel.Text = 'initial_z';

            % Create z_coordinate
            app.z_coordinate = uieditfield(app.UIFigure, 'numeric');
            app.z_coordinate.Position = [309 484 100 22];

            % Create final_xEditFieldLabel
            app.final_xEditFieldLabel = uilabel(app.UIFigure);
            app.final_xEditFieldLabel.HorizontalAlignment = 'right';
            app.final_xEditFieldLabel.Position = [254 442 40 22];
            app.final_xEditFieldLabel.Text = 'final_x';

            % Create final_x
            app.final_x = uieditfield(app.UIFigure, 'numeric');
            app.final_x.Position = [309 442 100 22];

            % Create final_yEditFieldLabel
            app.final_yEditFieldLabel = uilabel(app.UIFigure);
            app.final_yEditFieldLabel.HorizontalAlignment = 'right';
            app.final_yEditFieldLabel.Position = [257 400 40 22];
            app.final_yEditFieldLabel.Text = 'final_y';

            % Create final_y
            app.final_y = uieditfield(app.UIFigure, 'numeric');
            app.final_y.Position = [312 400 100 22];

            % Create final_zEditFieldLabel
            app.final_zEditFieldLabel = uilabel(app.UIFigure);
            app.final_zEditFieldLabel.HorizontalAlignment = 'right';
            app.final_zEditFieldLabel.Position = [257 362 40 22];
            app.final_zEditFieldLabel.Text = 'final_z';

            % Create final_z
            app.final_z = uieditfield(app.UIFigure, 'numeric');
            app.final_z.Position = [312 362 100 22];

            % Create Start_search_q1EditFieldLabel
            app.Start_search_q1EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q1EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q1EditFieldLabel.Position = [417 572 94 22];
            app.Start_search_q1EditFieldLabel.Text = 'Start_search_q1';

            % Create Start_search_q1
            app.Start_search_q1 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q1.Position = [526 572 100 22];

            % Create Start_search_q2EditFieldLabel
            app.Start_search_q2EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q2EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q2EditFieldLabel.Position = [417 525 94 22];
            app.Start_search_q2EditFieldLabel.Text = 'Start_search_q2';

            % Create Start_search_q2
            app.Start_search_q2 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q2.Position = [526 525 100 22];

            % Create Start_search_q3EditFieldLabel
            app.Start_search_q3EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q3EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q3EditFieldLabel.Position = [417 484 94 22];
            app.Start_search_q3EditFieldLabel.Text = 'Start_search_q3';

            % Create Start_search_q3
            app.Start_search_q3 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q3.Position = [526 484 100 22];

            % Create Start_search_q4EditFieldLabel
            app.Start_search_q4EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q4EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q4EditFieldLabel.Position = [417 442 94 22];
            app.Start_search_q4EditFieldLabel.Text = 'Start_search_q4';

            % Create Start_search_q4
            app.Start_search_q4 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q4.Position = [526 442 100 22];

            % Create Start_search_q5EditFieldLabel
            app.Start_search_q5EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q5EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q5EditFieldLabel.Position = [417 400 94 22];
            app.Start_search_q5EditFieldLabel.Text = 'Start_search_q5';

            % Create Start_search_q5
            app.Start_search_q5 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q5.Position = [526 400 100 22];

            % Create Start_search_q6EditFieldLabel
            app.Start_search_q6EditFieldLabel = uilabel(app.UIFigure);
            app.Start_search_q6EditFieldLabel.HorizontalAlignment = 'right';
            app.Start_search_q6EditFieldLabel.Position = [417 362 94 22];
            app.Start_search_q6EditFieldLabel.Text = 'Start_search_q6';

            % Create Start_search_q6
            app.Start_search_q6 = uieditfield(app.UIFigure, 'numeric');
            app.Start_search_q6.Position = [526 362 100 22];

            % Create Final_search_q1EditFieldLabel
            app.Final_search_q1EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q1EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q1EditFieldLabel.Position = [637 572 94 22];
            app.Final_search_q1EditFieldLabel.Text = 'Final_search_q1';

            % Create Final_search_q1
            app.Final_search_q1 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q1.Position = [746 572 100 22];

            % Create Final_search_q2EditFieldLabel
            app.Final_search_q2EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q2EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q2EditFieldLabel.Position = [637 525 94 22];
            app.Final_search_q2EditFieldLabel.Text = 'Final_search_q2';

            % Create Final_search_q2
            app.Final_search_q2 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q2.Position = [746 525 100 22];

            % Create Final_search_q3EditFieldLabel
            app.Final_search_q3EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q3EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q3EditFieldLabel.Position = [637 484 94 22];
            app.Final_search_q3EditFieldLabel.Text = 'Final_search_q3';

            % Create Final_search_q3
            app.Final_search_q3 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q3.Position = [746 484 100 22];

            % Create Final_search_q4EditFieldLabel
            app.Final_search_q4EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q4EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q4EditFieldLabel.Position = [637 442 94 22];
            app.Final_search_q4EditFieldLabel.Text = 'Final_search_q4';

            % Create Final_search_q4
            app.Final_search_q4 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q4.Position = [746 442 100 22];

            % Create Final_search_q5EditFieldLabel
            app.Final_search_q5EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q5EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q5EditFieldLabel.Position = [637 400 94 22];
            app.Final_search_q5EditFieldLabel.Text = 'Final_search_q5';

            % Create Final_search_q5
            app.Final_search_q5 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q5.Position = [746 400 100 22];

            % Create Final_search_q6EditFieldLabel
            app.Final_search_q6EditFieldLabel = uilabel(app.UIFigure);
            app.Final_search_q6EditFieldLabel.HorizontalAlignment = 'right';
            app.Final_search_q6EditFieldLabel.Position = [637 362 94 22];
            app.Final_search_q6EditFieldLabel.Text = 'Final_search_q6';

            % Create Final_search_q6
            app.Final_search_q6 = uieditfield(app.UIFigure, 'numeric');
            app.Final_search_q6.Position = [746 362 100 22];

            % Create PlotTrajectoryButton
            app.PlotTrajectoryButton = uibutton(app.UIFigure, 'push');
            app.PlotTrajectoryButton.ButtonPushedFcn = createCallbackFcn(app, @PlotTrajectoryButtonPushed, true);
            app.PlotTrajectoryButton.Position = [575 163 100 22];
            app.PlotTrajectoryButton.Text = 'Plot Trajectory';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = stanford_exported

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