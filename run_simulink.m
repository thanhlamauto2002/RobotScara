function [t1out, t2out, d3out, t4out, tout] = run_simulink(t)
set_param('cascadepid','StopTime',num2str(t(end)));
set_param('cascadepid','FixedStep',num2str(t(end)/100));

sim("cascadepid.slx");
% Assuming 'out' is a structure containing simulation results
% Access simulation results from the 'out' structure
tout  = evalin('base','out.tout')';
t1out = evalin('base','out.theta1out')';
t2out = evalin('base','out.theta2')';
d3out = evalin('base','out.d3out')';
t4out = evalin('base','out.theta4')';

end