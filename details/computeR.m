function [Rigrp] = computeR(i_obs,j_target)
%COMPUTERESI 此处显示有关此函数的摘要
%   此处显示详细说明
%xdata: data
%i_obs: Other observational variables
%j_target: A variable that needs to be evaluated 

Cov = cov(i_obs,j_target);
Rigrp = i_obs-(Cov(1,2)/Cov(2,2)*j_target);
end

%% 
