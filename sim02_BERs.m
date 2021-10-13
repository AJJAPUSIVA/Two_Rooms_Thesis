clc
close all
clear all
%% Room1 controlling parameters--------------------------------------------
    p.Ctrl.ifPlotOrientation2D           = true;
    p.Ctrl.ifRoom1PlotOrientation3D      = true;
    p.Ctrl.ifRoom1PlotDistOfIllumination = false;
    p.Ctrl.ifRoom1PlotReflectionPoints   = false;
    p.Ctrl.ifRoom1PlotDistOfTotalRxPow   = true;
    p.Ctrl.ifRoom1PlotDistOfRmsDelay     = false;
    p.Ctrl.ifRoom1PlotChannelImpulse     = false;
    p.Ctrl.ifRoom1PlotSymbols            = true;%
    p.Ctrl.ifRoom1SaveResults            = false;
    p.Ctrl.ifRoom1FindChannelResponse    = true;%
    p.Ctrl.ifRoom1UseOokModulation       = true;%
    p.Ctrl.ifRoom1plotBER                = true;%
    p.Ctrl.ifRoom1ShowTexts              = true;%
    p.Ctrl.iftworoomBER                  = true;%
    p.Ctrl.ifplotroom1BER                = true;
%% Room2 controlling parameters
% controlling parameters
    p.Ctrl.ifUseMultipleLEDs        = false;
    
    p.Ctrl.ifPlotIofPhi             = false;
    p.Ctrl.ifPlotOrientation2D      = true;
    p.Ctrl.ifPlotOrientation3D      = true;
    p.Ctrl.ifPlotDistOfIllumination = false;
    p.Ctrl.ifPlotReflectionPoints   = false;
    p.Ctrl.ifPlotDistOfTotalRxPow   = true;
    p.Ctrl.ifPlotDistOfRmsDelay     = false;
    p.Ctrl.ifPlotChannelImpulse     = false;
    p.Ctrl.ifPlotSymbols            = true;%
    p.Ctrl.ifShowTexts              = true;
    p.Ctrl.ifSaveResults            = false;
    p.Ctrl.ifFindChannelResponse    = true;%
    p.Ctrl.ifUseOokModulation       = true;%
    p.Ctrl.ifplotroom12BER          = true;
    p.Ctrl.ifUseOfdmModulation      = false;
    p.Ctrl.ifplotBER                = true;
%% system parameters ------------------------------------------------------
% controlling parameters
% room1 control parameters
p.deskLedHalfPowerSemiAngle = 60*pi/180; %in radian
p.deskLedCenterLuminousIntensity = 0.73; %cd
p.desknumberOfLedsInEachGroup = 3600;
p.deskLedFieldOfViewAngle = 50*pi/180; %in radian
p.CeilingDetectorPhysicalArea = 10^-4; %in m^2
p.CeilingGainOfOpticalArea = 1;
p.TxRoomWidth = 5;
p.TxRoomLength = 5;
p.TxRoomHeight = 3;
p.TxDeskHeight = 0.85;
p.TxrefCoeffcientWall = 0.8; %reflection coefficent of walls
p.TxrefCoeffCeiling = 0;%#ok
p.TxrefCoeffFloor = 0; %ok
p.numberOfdeskLeds = 1;
p.TxDeskPositionResolution  =0.1;

%room2 control parameters

p.halfPowerSemiAngle      = 60*pi/180;        % in radian
p.centerLuminousIntensity = 0.73;             % in cd
p.numberOfLedInEachGroup  = 3600;
p.fieldOfViewAngle        = 50*pi/180;        % in radian
p.detectorPhysicalArea    = 10^-4;            % in m^2
p.gaiOfAnOpticalFilter    = 1;    
p.roomWidth               = 5;
p.roomLength              = 5;
p.roomHeight              = 3;
p.deskHeight              = 0.85;
p.refCoeffWall            = 0.8;              % reflection coefficient from walls
p.refCoeffCeiling         = 0;%#ok
p.refCoeffFloor           = 0;%#ok
p.NumOfLeds               = 8;
p.deskPositionResolution  =0.1;

%%common parameters 
p.n      = 1.46;             % n in equation (6)
p.lightSpeed = 3e8;
p.i0 = 2e-4;% leakage current in amps
p.k = 1.38e-23;%Boltzmann constant J/K
p.q = 1.602e-19;%Charge of electron in C
p.V_led = -0.2:0.01:0.7;%led voltage(V)
p.t_F = 27;%temperature in F
p.n_led = 1.7;%led emission coefficient
p.A_1 = 1.044;
p.A_2 = 1.097;
p.lambda_i = 800;
p.lambda_d = 420:1:1120;% photodiode wavelength(nm)
p.lambda_1 = 449.67+4.81;
p.Delta_lambda_1 =23.91+2.92;
p.lambda_2 = 563.49+9.75;
p.Delta_lambda_2 = 133.84+12.98;
p.K_m = 683; %%maximum visibility ~683 lm/w at 555nm
p.transmitPower  = 4*10-6;        % 1 watt
p.deskMinimumDistFromWall           = 0.5;
p.reflectorPositionResolution       = 0.2;
% related to noise
p.SNRdB                             = 0.1;% signal to noise ration

% related to pulse width modulation
p.upsampleRate                      = 27;
p.pwmBitRate                        = 20e6;
p.pwmBitDuration                    = 1/p.pwmBitRate;
p.pwmSampleTime                     = p.pwmBitDuration /p.upsampleRate;
p.txtToTransmit                     = ['This is a paragraph to test. OpTic Gaming was established ',...
'in 2006 by OpTic "Kr3w" and Ryan "J" Musselman as a Call of ',...
'Duty sniping team.'];


%%%%%%%%run the simulation here
Results = OpticMain_TwoRoomfunc(p);