function [cellArr] = readStreaming(filename)
%READSTREAMING 此处显示有关此函数的摘要
%   此处显示详细说明
%从文件读取数据并存为元胞数组
% 指定文件名
fid = fopen(filename, 'r');  % 打开文件
data = textscan(fid, '%s', 'Delimiter', '\n');  % 逐行读取数据
fclose(fid);  % 关闭文件
cellArr = cell(length(data{1}), 1);  % 初始化元胞数组
for i = 1:length(data{1})
    newStr = split(data{1}{i},';');
    temp = [];
    for j = 1:length(newStr)
        temp = [temp,str2num(newStr{j})];
    end
    cellArr{i} = temp;  % 将字符串转换为整数数组
end
end

