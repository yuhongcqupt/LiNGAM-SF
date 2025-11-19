function [] = saveG2File(targetFile,Fname,DGA_CSSU,G_evauluated,hVIndex,newNames,i,t)
if exist(targetFile)==0 %%判断文件夹是否存在
    mkdir(targetFile);  %%不存在时候，创建文件夹
end
save([targetFile,Fname,num2str(t),'_',num2str(i),'.mat'],'DGA_CSSU','G_evauluated','hVIndex','newNames');
end