function [direction] = judgeDirection(vector1,vector2)
%UNTITLED3 此处显示有关此函数的摘要
%   output:
% 0 - There may not be a causal path between two variables.
% 1 - vector1 -> vector2
% -1 - vector2 -> vector1
rs = xor(vector1,vector2);
difIndex = find(rs);
if isempty(difIndex) 
    direction = 0;
else
    d = vector2(difIndex) - vector1(difIndex);
    %
    if all (~(diff(d)))
        direction = d(1);
    else
        direction = 0;
    end
end
end

