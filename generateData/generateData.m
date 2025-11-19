dbstop if all error
nSamples = 1000;
discrete = 0; % Set to 1 for binary data
interv = 0; 
testNum = 10;
data = 'Toy';
dName = 'Toy';
rootFile = ['G:\matlab\pointone\Open Source\',data,'\'];
num = 8;
%groupPart代表每轮进来的特征数量，设置特征有多少轮次(未知)，最后一次超过groupPart的数量
groupPart = 2;
index=randperm(num);
itr_num = floor(num/groupPart);
features = cell(itr_num,1);
%rand('state',index),表示一个状态，index 0,1,2类似表示下标,则不同标记随机值不同，但是相同标记随机值相同
for t =1:testNum
    %真实存在的因果结构
    [X,clamped,G,nodeNames] = sampleNetwork(dName,nSamples,discrete,interv,1);
    %模拟随机生成的因果结构
    %[X,clamped,G,nodeNames] = sampleNetwork_SY(nSamples,num,discrete,interv,1,0.001);
    fileName = [rootFile,dName,num2str(t),'.mat'];
    save(fileName,'X','clamped','G','nodeNames')
    %保证生成alarm结构的5组数据，每组序号是到达的特征序号
    startP = 1;
    for i=1:itr_num
        if i < itr_num
            endP = startP+groupPart-1;
            features{i} = index(startP:endP);
            startP = endP + 1;
        else
            features{i} = index(startP:end);
        end
    end
    % write to the file
    fileID = fopen([rootFile,dName,num2str(t),'.txt'],'w');
    [nrows,ncols] = size(features);
    for row = 1:nrows
        fprintf(fileID,'%d;',features{row});
        fprintf(fileID,'\n');
    end
    fclose(fileID);
end
