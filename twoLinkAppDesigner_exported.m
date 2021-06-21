classdef twoLinkAppDesigner_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        stanford                  matlab.ui.container.Menu
        optimal_finalq1           matlab.ui.control.NumericEditField
        Start_searchatq2forfinalPositionEditFieldLabel  matlab.ui.control.Label
        optimal_finalq2           matlab.ui.control.NumericEditField
        Start_searchatq1porfinalPositionEditFieldLabel  matlab.ui.control.Label
        optimal_q1                matlab.ui.control.NumericEditField
        Start_searchatq1forinitalPositionLabel  matlab.ui.control.Label
        optimal_q2                matlab.ui.control.NumericEditField
        Start_searchatq2forinitialPositionLabel  matlab.ui.control.Label
        PlottrajectoryButton      matlab.ui.control.Button
        z_desejado                matlab.ui.control.NumericEditField
        z_desejadoEditFieldLabel  matlab.ui.control.Label
        y_desejado                matlab.ui.control.NumericEditField
        y_desejadoEditFieldLabel  matlab.ui.control.Label
        x_desejado                matlab.ui.control.NumericEditField
        x_desejadoEditFieldLabel  matlab.ui.control.Label
        UITable                   matlab.ui.control.Table
        z_coordenate              matlab.ui.control.NumericEditField
        zEditFieldLabel           matlab.ui.control.Label
        y_coordenate              matlab.ui.control.NumericEditField
        yEditFieldLabel           matlab.ui.control.Label
        x_coordenate              matlab.ui.control.NumericEditField
        xEditFieldLabel           matlab.ui.control.Label
        joint2                    matlab.ui.control.NumericEditField
        q2EditFieldLabel          matlab.ui.control.Label
        joint1                    matlab.ui.control.NumericEditField
        q1EditFieldLabel          matlab.ui.control.Label
        KinematicsSwitch          matlab.ui.control.Switch
        KinematicsSwitchLabel     matlab.ui.control.Label
        CalculateButton           matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalculateButton
        function CalculateButtonPushed(app, event)
            %Check kinematics
            knToCalculate = string(app.KinematicsSwitch.Value);
            Th1 = string(app.joint1.Value);
            Th2 = string(app.joint2.Value);
            if knToCalculate =="Forward"

                %Th1 = str2double(app.joint1.Value)*pi/180;
                %Th2 = str2double(app.joint1.Value)*pi/180;
                
                if Th1 ~= "" && Th2 ~= ""
                    try
                    Th1 = str2double(Th1)*pi/180;
                    Th2 = str2double(Th2)*pi/180;
                    %L(1) = Link([0 0 1 0]);
                    %L(2) = Link([0 0 1 0]);
                    %twolink = SerialLink(L,'name','dois links');
                    mdl_twolink;
                    twolink.name = "2_Joint_Demo";
                    %figure(app.UIAxes);
                    twolink.plot([Th1 Th2]) %este cria uma 
                    %imshow(twolink.plot([Th1 Th2]),'Parent',app.UIAxes);
                    %plot(app.UIAxes, twolink)
                    %plot(app.UIAxes, Th1, Th2);
                   
                    %mesh(app.UIAxes,twolink.plot([Th1 Th2]));
                    
                    
                    T = twolink.fkine([Th1,Th2]);
                    x = T.t(1);
                    y = T.t(2);
                    z = T.t(3);
                  
                    
                    
                    
                    app.x_coordenate.Value = (x);
                    app.y_coordenate.Value = (floor(y));
                    app.z_coordenate.Value = (floor(z));
                    
                    app.UITable.Data={1,Th1,0,0,1,0
                        2,Th2,0,0,1,0};
                    
                    catch ME
                        message = ME.message;
                        uialert(app.UIFigure,message,"Alert");
                    end
                end
            end
            if knToCalculate == "Inverse"
                Th1 = string(app.x_coordenate.Value);
                Th2 = string(app.y_coordenate.Value);
                Th3 = string(app.z_coordenate.Value);
                if Th2 ~= "0"
                    fig = uifigure;
                    uialert(fig,'Model can only move in X and Z axes ','Invalid Value');
                   
                
                elseif Th1 ~= "" && Th2 ~= ""
                  
                    x = round(str2double(Th1),3);
                    z = round(str2double(Th3),3);
                    s = x+z;
                    uialert(uifigure, string(s),"alert");
                    
                    if s<=2 || s>=-2
                    mdl_twolink;
                    T = transl(x,0,z);
                    %T = transl(1,0,1);
                    %the mask is in relation to the axes of the end
                    %effector
                    
                       try
                        optimal_joint_1 = app.optimal_q1.Value*pi/180;
                        optimal_joint_2 = app.optimal_q2.Value*pi/180;
                        uialert(app.UIFigure,optimal_joint_1 + " " + optimal_joint_2, "test")
                        J = twolink.ikine(T,'q0',[optimal_joint_1 optimal_joint_2],'mask',[1 1 0 0 0 0]);
                        twolink.name = "2_Joint_Demo";
                        twolink.plot(J);
                        app.joint1.Value = round(J(1),3);
                        app.joint2.Value = round(J(2),3);
                        catch ME
                        message = ME.message;
                        uialert(app.UIFigure,message,"Alert");
                        end
                   
                    

 
                    %T= desired end effector homogenous matrix/ [0 0] =
                    %initial joint config , start search at this config
                    %/[1 0 1 0 0 0]= only care about constraints in x axis
                    %and z axis cause theses are the only 2 that the robot
                    %can move in
                    %mask is now [1 1 0 0 0 0] since there is a rotation of
                    %the base towards X such that Y points to the sky now
                    
                    
                    else
                        fig=uifigure;
                        uialert(fig,"Values inserted are outside the workspace of the robot", "Invalid parameters");
                    end
                end
            end
        end

        % Menu selected function: stanford
        function stanfordMenuSelected(app, event)
            stanford
            delete(app)
        end

        % Button pushed function: PlottrajectoryButton
        function PlottrajectoryButtonPushed(app, event)
                Th1 = string(app.x_coordenate.Value);
                Th2 = string(app.y_coordenate.Value);
                Th3 = string(app.z_coordenate.Value);
                final_x = string(app.x_desejado.Value);
                %initial_y = string(app.y_desejado.Value);
                final_z = string(app.z_desejado.Value);
                
                if Th1 ~= "" && Th2~="" && Th3~="" %&& final_x ~="" && final_y ~="" && final_z ~=""
                    final_x = round(str2double(final_x),3);
                    %initial_y = round(str2double(final_y),3);
                    final_z= round(str2double(final_z),3);
                    if (final_x + final_z) >2 || (final_x + final_z)<-2
                        uialert(app.UIFigure,"Desired Values are outside the workspace of the robot X and Z must each be within -1 to 1","Outside the Workspace")
                    else
                    x = round(str2double(Th1),3);
                    %y = round(str2double(Th2)*pi/180,3);
                    z = round(str2double(Th3),3);
                    

                    %T = transl(initial_x,initial_y,initial_z);
                    T = transl(x,0,z);
                    T2 = transl(final_x,0,final_z);
                    optimal_joint_1 = app.optimal_q1.Value*pi/180;
                    optimal_joint_2 = app.optimal_q2.Value*pi/180;
                    optimal_joint_1_final = app.optimal_finalq1.Value*pi/180;
                    optimal_joint_2_final = app.optimal_finalq2.Value*pi/180;
                    
                    uialert(app.UIFigure,x + " " + z, "testing");
                    mdl_twolink;
                    try
                        %check for empty ikine
                        
                      %J = twolink.ikine(T,'q0',[0 0],'mask',[1 1 0 0 0 0]);
                      J = twolink.ikine(T,'q0',[optimal_joint_1 optimal_joint_2],'mask',[1 1 0 0 0 0]);
                    
                    %start_array= [x,y,z];
                    qn=twolink.ikine(T2,'q0',[optimal_joint_1_final optimal_joint_2_final],'mask',[1 1 0 0 0 0]);
                    if ~isempty(J) && ~isempty(qn)
                        uialert(app.UIFigure,"in array check","t");
                        qt = jtraj(J,qn,50);
                        twolink.plot(qt);
                    else
                        uialert(app.UIFigure, "Arrays were empty: " + mat2str(J) + "Second Array is: " + mat2str(qn),"Ikine Error");
                    end
                    
                    catch ME
                        message = ME.message
                        uialert(app.UIFigure,message,"Alert");
                    end
                   
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
            app.UIFigure.Position = [100 100 913 591];
            app.UIFigure.Name = 'MATLAB App';

            % Create stanford
            app.stanford = uimenu(app.UIFigure);
            app.stanford.MenuSelectedFcn = createCallbackFcn(app, @stanfordMenuSelected, true);
            app.stanford.Text = 'stanford';
            app.stanford.HandleVisibility = 'off';

            % Create CalculateButton
            app.CalculateButton = uibutton(app.UIFigure, 'push');
            app.CalculateButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateButtonPushed, true);
            app.CalculateButton.Position = [38 74 100 22];
            app.CalculateButton.Text = 'Calculate';

            % Create KinematicsSwitchLabel
            app.KinematicsSwitchLabel = uilabel(app.UIFigure);
            app.KinematicsSwitchLabel.HorizontalAlignment = 'center';
            app.KinematicsSwitchLabel.Position = [58 127 64 22];
            app.KinematicsSwitchLabel.Text = 'Kinematics';

            % Create KinematicsSwitch
            app.KinematicsSwitch = uiswitch(app.UIFigure, 'slider');
            app.KinematicsSwitch.Items = {'Forward', 'Inverse'};
            app.KinematicsSwitch.Position = [65 164 51 22];
            app.KinematicsSwitch.Value = 'Forward';

            % Create q1EditFieldLabel
            app.q1EditFieldLabel = uilabel(app.UIFigure);
            app.q1EditFieldLabel.HorizontalAlignment = 'right';
            app.q1EditFieldLabel.Position = [17 517 25 22];
            app.q1EditFieldLabel.Text = 'q1';

            % Create joint1
            app.joint1 = uieditfield(app.UIFigure, 'numeric');
            app.joint1.Position = [57 517 100 22];

            % Create q2EditFieldLabel
            app.q2EditFieldLabel = uilabel(app.UIFigure);
            app.q2EditFieldLabel.HorizontalAlignment = 'right';
            app.q2EditFieldLabel.Position = [18 471 25 22];
            app.q2EditFieldLabel.Text = 'q2';

            % Create joint2
            app.joint2 = uieditfield(app.UIFigure, 'numeric');
            app.joint2.Position = [58 471 100 22];

            % Create xEditFieldLabel
            app.xEditFieldLabel = uilabel(app.UIFigure);
            app.xEditFieldLabel.HorizontalAlignment = 'right';
            app.xEditFieldLabel.Position = [18 427 25 22];
            app.xEditFieldLabel.Text = 'x';

            % Create x_coordenate
            app.x_coordenate = uieditfield(app.UIFigure, 'numeric');
            app.x_coordenate.RoundFractionalValues = 'on';
            app.x_coordenate.Position = [58 427 99 22];

            % Create yEditFieldLabel
            app.yEditFieldLabel = uilabel(app.UIFigure);
            app.yEditFieldLabel.HorizontalAlignment = 'right';
            app.yEditFieldLabel.Position = [19 385 25 22];
            app.yEditFieldLabel.Text = 'y';

            % Create y_coordenate
            app.y_coordenate = uieditfield(app.UIFigure, 'numeric');
            app.y_coordenate.RoundFractionalValues = 'on';
            app.y_coordenate.Position = [59 385 99 22];

            % Create zEditFieldLabel
            app.zEditFieldLabel = uilabel(app.UIFigure);
            app.zEditFieldLabel.HorizontalAlignment = 'right';
            app.zEditFieldLabel.Position = [19 343 25 22];
            app.zEditFieldLabel.Text = 'z';

            % Create z_coordenate
            app.z_coordenate = uieditfield(app.UIFigure, 'numeric');
            app.z_coordenate.RoundFractionalValues = 'on';
            app.z_coordenate.Position = [59 343 100 22];

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'q'; 'Theta'; 'alpha'; 'd'; 'a'; 'offset'};
            app.UITable.RowName = {};
            app.UITable.Position = [198 74 452 95];

            % Create x_desejadoEditFieldLabel
            app.x_desejadoEditFieldLabel = uilabel(app.UIFigure);
            app.x_desejadoEditFieldLabel.HorizontalAlignment = 'right';
            app.x_desejadoEditFieldLabel.Position = [210 427 67 22];
            app.x_desejadoEditFieldLabel.Text = 'x_desejado';

            % Create x_desejado
            app.x_desejado = uieditfield(app.UIFigure, 'numeric');
            app.x_desejado.Position = [292 427 100 22];

            % Create y_desejadoEditFieldLabel
            app.y_desejadoEditFieldLabel = uilabel(app.UIFigure);
            app.y_desejadoEditFieldLabel.HorizontalAlignment = 'right';
            app.y_desejadoEditFieldLabel.Position = [211 385 67 22];
            app.y_desejadoEditFieldLabel.Text = 'y_desejado';

            % Create y_desejado
            app.y_desejado = uieditfield(app.UIFigure, 'numeric');
            app.y_desejado.Position = [293 385 100 22];

            % Create z_desejadoEditFieldLabel
            app.z_desejadoEditFieldLabel = uilabel(app.UIFigure);
            app.z_desejadoEditFieldLabel.HorizontalAlignment = 'right';
            app.z_desejadoEditFieldLabel.Position = [212 343 67 22];
            app.z_desejadoEditFieldLabel.Text = 'z_desejado';

            % Create z_desejado
            app.z_desejado = uieditfield(app.UIFigure, 'numeric');
            app.z_desejado.Position = [294 343 100 22];

            % Create PlottrajectoryButton
            app.PlottrajectoryButton = uibutton(app.UIFigure, 'push');
            app.PlottrajectoryButton.ButtonPushedFcn = createCallbackFcn(app, @PlottrajectoryButtonPushed, true);
            app.PlottrajectoryButton.Position = [739 53 100 22];
            app.PlottrajectoryButton.Text = 'Plot trajectory';

            % Create Start_searchatq2forinitialPositionLabel
            app.Start_searchatq2forinitialPositionLabel = uilabel(app.UIFigure);
            app.Start_searchatq2forinitialPositionLabel.HorizontalAlignment = 'right';
            app.Start_searchatq2forinitialPositionLabel.Position = [527 471 199 22];
            app.Start_searchatq2forinitialPositionLabel.Text = 'Start_search at q2 for initial Position';

            % Create optimal_q2
            app.optimal_q2 = uieditfield(app.UIFigure, 'numeric');
            app.optimal_q2.Position = [741 471 100 22];

            % Create Start_searchatq1forinitalPositionLabel
            app.Start_searchatq1forinitalPositionLabel = uilabel(app.UIFigure);
            app.Start_searchatq1forinitalPositionLabel.HorizontalAlignment = 'right';
            app.Start_searchatq1forinitalPositionLabel.Position = [529 517 196 22];
            app.Start_searchatq1forinitalPositionLabel.Text = 'Start_search at q1 for inital Position';

            % Create optimal_q1
            app.optimal_q1 = uieditfield(app.UIFigure, 'numeric');
            app.optimal_q1.Position = [740 517 100 22];

            % Create Start_searchatq1porfinalPositionEditFieldLabel
            app.Start_searchatq1porfinalPositionEditFieldLabel = uilabel(app.UIFigure);
            app.Start_searchatq1porfinalPositionEditFieldLabel.HorizontalAlignment = 'right';
            app.Start_searchatq1porfinalPositionEditFieldLabel.Position = [529 335 197 22];
            app.Start_searchatq1porfinalPositionEditFieldLabel.Text = 'Start_search at q1 por final Position';

            % Create optimal_finalq2
            app.optimal_finalq2 = uieditfield(app.UIFigure, 'numeric');
            app.optimal_finalq2.Position = [741 335 100 22];

            % Create Start_searchatq2forfinalPositionEditFieldLabel
            app.Start_searchatq2forfinalPositionEditFieldLabel = uilabel(app.UIFigure);
            app.Start_searchatq2forfinalPositionEditFieldLabel.HorizontalAlignment = 'right';
            app.Start_searchatq2forfinalPositionEditFieldLabel.Position = [532 385 193 22];
            app.Start_searchatq2forfinalPositionEditFieldLabel.Text = 'Start_search at q2 for final Position';

            % Create optimal_finalq1
            app.optimal_finalq1 = uieditfield(app.UIFigure, 'numeric');
            app.optimal_finalq1.Position = [740 385 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = twoLinkAppDesigner_exported

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