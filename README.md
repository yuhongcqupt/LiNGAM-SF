
#### **LiNGAM-SF: Causal Structural Learning Method with Linear Non-Gaussian Acyclic Models for Streaming Features**

**This source code accompanies the paper "LiNGAM-SF: Causal Structural Learning Method with Linear Non-Gaussian Acyclic Models for Streaming Features" (submited to TNNLS).  This work describes how to learn causal structures for streaming features  with linear non-Gaussian acyclic models. We will  make our code publicly available upon accepttance.**

**The files in the folder "data" are used for test our method:**

- **The *generateData.m* is used for generating the synthetic data based on known causal structures.**
- **The *XXX.mat* in the subfolder  "XXX" is data generated for  experiments in the paper.  Note: You can use the file to generateData.m to generate more data.**
- **The *realData.csv* involves preprocessed data from the website [Yahoo Finance database](https://help.yahoo.com/kb/sln2311.html).**

**The files in the folder "Method" are our proposed method:**

- **The main function for  learning the causal structural  is in file *LiNGAMSF.m*.**
- **The *sensitivity\_analysis.m* file serves as an experiment parameter sensitivity.**
- **The *ablation\_analysis.m* file constitutes an ablation experiment**

**The files in the folder "others" are comparative method.**
