%alarm1:5
clear;


sig1 = 0.001;
sig2 = 0.001;
r = 0.75;

Name = 'sachs\';
dataName = 'sachs';
%File for storing results
RSFile = ['G:\matlab\pointone\\Open Source\Result\',Name,dataName,'_OCSL_SF.xlsx'];
rootFile = ['G:\matlab\pointone\Open Source\',Name];
%File for storing temp results
RStemp = ['G:\matlab\pointone\Compared\Result\',Name,'OCSL_SF\'];
%
for t=1:10
    %load data
    load([rootFile,dataName,num2str(t),'.mat']);
    %The order of feature stream
    filename = [rootFile,dataName,num2str(t),'.txt'];
    %load("G:\matlab\pointone\generateData\pigs\pigs1.mat");
    %filename = 'G:\matlab\pointone\generateData\pigs_10.txt'; 
    featureList = readStreaming(filename);
    %rootFile = 'G:\matlab\pointone\Compared\Result\';
    %dataFile = 'pigs\';
    %dataFile = 'hepar\';
    %dataFile = 'child\';
    %recordFile_rs = 'totalerror_mm2.txt';
    %recordFile_time = 'runningTime_mm2.txt';

    [fold,~]=size(featureList);
    %fold=3;
    runtime=zeros(1,fold);
    runtime_k=zeros(1,fold);
    runtime_k2=zeros(1,fold);
    %nSamples:Samples£¬numOfVar: The number of features
    [nSamples,numOfVar]=size(X);
    %missing 
    miss= zeros(1,fold);
    %extra
    extra= zeros(1,fold);
    %reverse
    reverse= zeros(1,fold);
    %missorient
    missorient= zeros(1,fold);
    %total error
    totalerr= zeros(1,fold);
    %TP
    correct= zeros(1,fold);
    lEdge = zeros(1,fold);
    GEdge = zeros(1,fold);
    cEdge = zeros(1,fold);
    %P,Recall,F1
    P = zeros(1,fold);
    R = zeros(1,fold);
    F1 = zeros(1,fold);
    P_pie = zeros(1,fold);
    R_pie = zeros(1,fold);
    F1_pie = zeros(1,fold);


    G_O = [];
    oIndex = [];
    testNum = [];
    LC = [];

    for i=1:fold
        fprintf('This is %d times\n', i);
        newF = featureList{i};
        %update data to simulate streaming features
        oldF  = oIndex;
        oIndex = [oIndex,newF];
        numFeature = size(oIndex,2);
        DAG_MA = zeros(numFeature);
        data = X(:,oIndex);
        oldData = X(:,oldF);
        newData = X(:,newF);
        %show the graph 
        %option1 = nodeNames(oIndex);newData
        option1 = [];
        start1 = tic;
        [DAG_MA,~] = LiNGAMSF(G_O,oldData,newData,r,sig1,sig2,option1,LC);
        runtime(1,i)=toc(start1);
        G_O = DAG_MA;

        not_oIndex = setdiff(1:numOfVar,oIndex);
        hV = nodeNames(not_oIndex);
        [G_evauluated,newNames,lefthV,hVIndex]= evaluatedG(G,nodeNames,hV);
        [ordered_oIndex,originIndex] = sort(oIndex);
        %This step is needed since the order of the features is shuffled.
        DAG_MA = DAG_MA(originIndex,originIndex);
        [miss(1,i),extra(1,i),reverse(1,i),missorient(1,i),correct(1,i),totalerr(1,i),lEdge(1,i),GEdge(1,i),cEdge(1,i),P(1,i),R(1,i),F1(1,i),P_pie(1,i),R_pie(1,i),F1_pie(1,i)]=Compare_Dag(DAG_MA,G_evauluated,hVIndex);
        saveG2File(RStemp,dataName,DAG_MA,G_evauluated,hVIndex,newNames,i,t);
    end
    saveRS(RSFile,totalerr,miss,extra,reverse,missorient,correct,runtime,lEdge,GEdge,cEdge,P,R,F1,P_pie,R_pie,F1_pie,t);

end
%write2File(rootFile,dataFile,recordFile_rs,recordFile_time,totalerr,miss,extra,reverse,missorient,correct,runtime);