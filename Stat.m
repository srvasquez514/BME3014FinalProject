 
 %% Creating the Sham Array's
    ShamHR = [337.1935,296.3215,582.4251,531.3351,367.8474,337.1935];
    ShamDP = [4.4955,0.28168,3.5023,6.3631,45.0107,11.3288];
    ShamSP = [81.3978,85.5238,77.6587,71.905,111.598,88.629];
    ShamMDP = [74.7669,86.6544,78.1372,68.0991,66.6868,77.6205];
    ShamT = [0.013566,0.011032,0.012111,0.016048,0.052875,0.01886];
    ShamMaDPDT = [10.4102,10.47,9.9794,7.8348,9.5985,9.7152];
    ShamMiDPDT = [8.4611,9.3545,6.0335,6.7818,6.6983,8.4356];
%% Finding the mean of the Sham Measured Values
    SavgHR = mean(ShamHR); %408.7194
    SavgDP = mean(ShamDP); %11.8303
    SavgSP = mean(ShamSP); %86.1187
    SavgMDP = mean (ShamMDP); %75.3275
    SavgT = mean(ShamT); %0.0207
    SavgMaDPDT = mean(ShamMaDPDT); %9.6680
    SavgMiDPDT = mean(ShamMiDPDT); %7.6275
%% St.Dev of all Calculated Values
   SdevHR = std(ShamHR); %118.1050
    SdevDP = std(ShamDP); %16.6590
    SdevSP = std(ShamSP); %13.7967
    SdevMDP = std(ShamMDP); %7.3304
    SdevT = std(ShamT); %0.0160
    SdevMaDPDT = std(ShamMaDPDT); %0.9653
    SdevMiDPDT = std(ShamMiDPDT); %1.300
    
%% Infarcted Data Analysis for Mean & St.Dev
   InfarctHR = [458.1281,709.3596,399.0148,738.9163,798.0296,744.898];
   InfarctDP = [5.5393,3.5506,4.8788,11.0664,5.7542,1.0582];
   InfarctSP = [82.9678,54.8397,100.8954,56.6308,92.2617,64.0323];
   InfarctMDP = [79.5805,53.3434,97.1242,48.6105,89.9344,71.6039];
   InfarctT = [0.01485,0.015198,0.01419,0.021391,0.010673,0.007647];
   InfarctMaDPDT = [12.1544,8.214,16.0547,8.1983,16.3588,11.9959];
   InfarctMiDPDT = [8.4255,6.0081,11.3249,5.8131,12.8331,8.2483];
   %Averages for the Infarction Data
    IavgHR = mean(InfarctHR); %641.3911
    IavgDP = mean(InfarctDP); %5.3079
    IavgSP = mean(InfarctSP); %75.2713
    IavgMDP = mean(InfarctMDP); %73.3661
    IavgT = mean(InfarctT); %0.0140
    IavgMaDPDT = mean(InfarctMaDPDT); %12.1627
    IavgMiDPDT = mean(InfarctMiDPDT); %8.7755
    
    IdevHR = std(InfarctHR); %168.3519
    IdevDP = std(InfarctDP); %3.3089
    IdevSP = std(InfarctSP); %19.4717
    IdevMDP = std(InfarctMDP); %19.4650
    IdevT = std (InfarctT); %0.0047
    IdevMaDPDT = std(InfarctMaDPDT); %3.5803
    IdevMiDPDT = std(InfarctMiDPDT); %2.8213

%% T-Test between Sham & Infarcted Data
disp('T-Test')
[h1, p1] = ttest2(ShamHR, InfarctHR); %p = 0.0197

[h2, p2] = ttest2(ShamDP , InfarctDP); %p = 0.3690

[h3, p3] = ttest2(ShamSP , InfarctSP); %p = 0.2916

[h4, p4] = ttest2(ShamMDP, InfarctMDP); %p = 0.8220

[h5, p5] = ttest2(ShamT , InfarctT); %P = 0.3437

[h6, p6] = ttest2(ShamMaDPDT , InfarctMaDPDT); %P = 0.1304

[h7, p7] = ttest2(ShamMiDPDT , InfarctMiDPDT); %P = 0.3866
