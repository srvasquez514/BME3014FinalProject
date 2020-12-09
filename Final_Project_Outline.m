%% Name and Group Number
% Names = Azka Siddiq, Claire Nicolas, Sarah Vasquez 
% GroupNumber = 5

clear all
close all
%% Import Data - Azka
% Please remember that this code must prompt the user for the file name.Use
% funvtion inputdlg(). Having done so, use the filename input to import
% your data set. Plot the data set to assure that it is importing the
% correct data. You are allowed to ask the user for if the data set came
% from a healthy or infracted heart.
% 
%This code imports the original files and removes the header
%I'm leaving it commented for now because it's a lot eaasier to run the code and check progress when you don't... 
    %have to input the file name everytime -AZKA
prompt=inputdlg('What is the filename?');
fname=char(prompt);  
rawdata=dlmread(fname,',',23,0);
list={'Healthy','Infarcted'};
isHealthy=listdlg('PromptString', {'What type of heart is the data from?'},...
    'SelectionMode','single','ListString',list);
% rawdata
%fname = 'Sham1.csv';
rawdata2 = importdata(fname);
time = rawdata(:,1);
heartwaveform = rawdata(:,2);
%% Set sampling frequency
Fs = 250; % Hz
%% Design and Apply Low-Pass Filter to Raw Data Set
% Here, use designfilt() to design a lowpass filter. You may use an if
% statement to switch between different lowpass filters for infracter and
% healthy hearts.Adjust the passband frequency in order that you know that
% the signal is properly filtered. Also, plot the unfiltered and filtered
% signal to display the improvement made by filtering.

%First, plot the raw data for visual inspection and later comparison with
%lowpass filter
figure
plot(time,heartwaveform)
xlabel('Time (Seconds)')
ylabel('Pressure (mmHg)')
title('Raw Unfiltered Heart Condition Data')
%% Stop
%isHealthy = 1; %%Delete at the very end****
if isHealthy == 1  %filter for healthy hearts
    LP = designfilt('lowpassfir','PassbandFrequency',12,...
    'StopbandFrequency',60,'StopbandAttenuation',70,'SampleRate',Fs);
    filtdata = filter(LP,heartwaveform);
elseif isHealthy == 2  %filter for infracted hearts 
      LP = designfilt('lowpassfir','PassbandFrequency',8,...
    'StopbandFrequency',40,'StopbandAttenuation',60,'SampleRate',Fs);
    filtdata = filter(LP,heartwaveform); 
else
    disp('Invalid Heart State input. Please try again.')
end

%% Plotting the Filtered Data

timedelay = grpdelay(LP); % find delay associated with low pass filter
disp(timedelay(1));
delay = timedelay(1);
filtdata = filtdata(delay:end); % account for this delay in dataset
delaytime = time(1:length(filtdata));% Time of dataset accounting for time delay form filter
%% Plot of LowPass Data & Raw Data
figure
plot(time,heartwaveform, 'b-')
hold on
plot(delaytime,filtdata, 'r-')
xlabel('Time (Seconds)','FontSize',16)
ylabel('Pressure (mmHg)','FontSize',16)
title('Low Pass vs. Raw Data Filtered Heart Condition','FontSize',18)
legend('Raw Data','Filtered Data','FontSize',12)
hold off

%% Identify Local Maxima and Count for Heartbeats
% You may use previous code you have created in earlier labs to perfrom
% local maxima detection on the filtered signal. You should set your
% thresholds here. However, please remember to CHANGE YOUR VARIABLE
% NAMES. Tip - preallocate vectors of zeros to save time and processing power.
% It takes longer for the CPU to append to a vector than to change a vector
% value.

% level = 50;
% threshdata = false(size(filtdata));
% thresdata(filtdata > level) = true;
% threshdiff = diff(threshdata);

peakdata = islocalmax(filtdata);
maxlocal = find(peakdata);
disp(maxlocal)

maximumvalues = [];
for i = 1:length(maxlocal)
    maximumvalues(i) = filtdata(maxlocal(i));
end
figure
plot(delaytime,filtdata, 'b-')
hold on
plot(delaytime(maxlocal),filtdata(maxlocal), 'or', 'MarkerSize',12)
xlabel('Time (Seconds)', 'FontSize',16)
ylabel('Pressure (mmHg)', 'FontSize',16)
title('Local Maxima - Filtered Heart Condition', 'FontSize',18)

%% Find peaks (Systolic)
% Use the findpeaks() function to find the peaks of the cleaned signal.
% Plot the peaks over the cleaned signal to prove that your threshold is
% correct.

avgdata = mean(filtdata);
[peaks,loc] = findpeaks(filtdata);
systolicpeaks = (peaks);
systolicloc = (loc);
for i = 1: length(systolicpeaks)
    if systolicpeaks(i) < avgdata
        systolicpeaks(i) = 0;
        systolicloc(i) = 0;
    end
end
 systolicpeaks(systolicpeaks==0) = [];
 systolicloc(systolicloc ==0) = []; 

maxlocations = systolicloc;
disp(maxlocations);

%% Plotting the Systolic Pressure
figure
plot(delaytime(systolicloc),systolicpeaks, 'o', delaytime,filtdata, 'MarkerSize',12);  %Arrays need to be the same size so used 1:1016 to plot peaks.
xlabel('Time(s)', 'FontSize',16)
ylabel('Pressure (mmHg)', 'FontSize',16)
title('Systolic Peaks of Heart Pressure Waveform', 'FontSize',18)

%% Find Minima (Diastolic) (inverted data set)
% Do the same as with the systolic, however invert the signal in order to
% find the diastolic minima occurance which now looks like a peak and thus you are able to use findpeaks(). Plot the occurances of the minima on
% the original filtered signal to prove that your threshold is correct.

%MinPeakProminence try this command
if strcmp( fname, 'Sham 3.csv')
    [peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+30);
elseif isHealthy == 1
    [peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+25); %Sham 3 Data likes +30
elseif strcmp( fname, 'Infarct 1.csv')
     [peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+55);
elseif isHealthy == 2
    [peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+30);
 %55 for Infarct 1 and 30 for the rest of Infarct data
end

    

% diastoliclocmax = islocalmax(loc1);
% diastolicpeaksmax = islocalmax(peaks1);
% avgdata = mean(-filtdata);
% diastolicpeaks = (peaks1);
% diastolicloc = (loc1);
% for i = 1: length(diastolicloc)
%     if diastolicpeaks(i) < avgdata
%         diastolicpeaks(i) = 0;
%         diastolicloc(i) = 0;
%     end
% end
%  diastolicpeaks(diastolicpeaks==0) = [];
%  diastolicloc(diastolicloc ==0) = []; 

diastolicloc = []; 
diastolicpeaks = [];
level = mean(-filtdata);
k = 1;
for i = 1:length(loc1)
    if peaks1(i)<level
        continue
    else
        diastolicloc(k) = loc1(i);
        diastolicpeaks(k) = peaks1(i);
        k = k+1;
    end
end

peakdata = islocalmax(-filtdata);
maxlocal = find(peakdata);
disp(maxlocal)
 minvalues = [];
for i = 1:length(maxlocal)
    minvalues(i) = -filtdata(maxlocal(i));
end
 minlocations = diastolicloc;
disp(minlocations);
%% Plotting Distolic Pressure Waveform
figure
plot(delaytime(diastolicloc),diastolicpeaks, 'o', delaytime,-filtdata, 'MarkerSize',12);  
xlabel('Time(s)', 'FontSize',16) 
ylabel('Pressure (mmHg)', 'FontSize',16)
title('Minima (Diastolic) of Heart Pressure Waveform', 'FontSize',18)

%% Maximum Developed Pressure
% Maximum developed pressure is the mean of the difference between the
% systolic and diastolic pressures. However, please remember that you may
% have more diastolic points than systolic points depending on when the
% recording starts during the heart beat! Use an if statement to adjust
% which systolic pressure to use (first recorded value or second)!

disp(maxlocations);
disp(minlocations);
%maxDP = average(systolic - diastolic)

if maxlocations > 10
  maxDP = mean((filtdata(maxlocations(1))-filtdata(minlocations))); 
else 
   maxDP = mean((filtdata(maxlocations(2))-filtdata((minlocations)))); 
end

%% Maximum rate of pressure increase 
% Take the derivative of the filtered signal and find the peaks using the
% findpeaks() function once more. Please plot the differentiated signal and
% the peaks in order to prove that your are finding the peaks.

derivolt=diff(filtdata);
level = 5;
[peaks2,loc2] = findpeaks(derivolt);
Pmaxpeaks = (peaks2);
Pmaxloc = (loc2);
for i = 1:length(peaks2)
    if Pmaxpeaks(i) < level
        Pmaxpeaks(i) = 0;
        Pmaxloc(i) = 0;
    end
end
Pmaxpeaks(Pmaxpeaks==0) = [];
Pmaxloc(Pmaxloc ==0) = []; 

derivolt=diff(filtdata);
i = 1;
for value = 1:length(Pmaxpeaks)
    PmaxIndex(i) = find(derivolt == Pmaxpeaks(value));
    i = i+1;
end
%% Minimum rate of pressure increase
% Do the same as above, however you would apply the findpeaks() function to
% the inverted derivative vector to find the minima. Plot the minimum rates
% of pressure increase on the derivative graph to show that your threshold
% was adequate.

derivolt= diff(-filtdata);
% avgdata = mean(-derivolt);
level = 5;
[peaks3,loc3] = findpeaks(derivolt);
Pminpeaks = (peaks3);
Pminloc = (loc3);
for i = 1: length(-Pminpeaks)
    if Pminpeaks(i) < level
        Pminpeaks(i) = 0;
       Pminloc(i) = 0;
    end
end
Pminpeaks(Pminpeaks==0) = [];
Pminloc(Pminloc ==0) = []; 
 derivolt=diff(-filtdata);
i = 1;
for value = 1:length(Pminpeaks)
    PminIndex(i) = find(derivolt == Pminpeaks(value));
    i = i+1;
end
%% Validation of minima dp/dt and minima
% Plot the original filtered signal, but now with where the max and minimum
% change in pressures noted. Best way to do so is to take the occurances of
% the minima and maxima (which should be samples) and plot it against the
% original signal values at those occurances(aka samples).
% 
figure
plot(delaytime,filtdata)
hold on
plot(delaytime(Pmaxloc),filtdata(PmaxIndex), 'o', 'MarkerSize',12)
plot(delaytime(Pminloc),filtdata(PminIndex), 'bo', 'MarkerSize',12)
xlabel('Time(s)','FontSize',16) 
ylabel('Pressure (mmHg)','FontSize',16)
title('dp/dt of Heart Pressure Waveform','FontSize',18)

%% Diastolic Time Constant
% % Find the diastolic time constant over a time range as noted in lecture.
% % Please see the pressureerror and the pressureeqn Matlab functions and
% % scripts provided by the Professor. Remeber to acount for if the first
% % diastolic value occurs after the first minimum dp/dt value (use an if
% % loop). Plot to show how well the curve fits the original signal (or if
% % it works at all!) This is the hardest part of the final project, so don't
% % get discouraged if you have issues in this section.
% diastolicloc = maxk(diastolicloc,length(systolicloc));
% overalltime = [];
% overallmag = [];
% tao_estimate = [];
% i = 1;
% if Pminloc(i) < diastolicloc(i)
%   Pminloc = Pminloc(length(diastolicloc));
% elseif diastolicloc(i) > Pminloc(i)
%     diastolicloc = diastolicloc(length(Pminloc(i)));
% end
% minima = diastolicpeaks;
% voltage = filtdata;
% for i = 1:length(minima)-1
%     if Pminloc(i) < diastolicloc(i)
%         region = (Pminloc(i): diastolicloc(i));
%     elseif Pminloc(i) > diastolicloc(i)
%         region = (diastolicloc(i): Pminloc(i));
%     elseif Pminloc(i) == 0 || diastolicloc(i) == 0
%       Pminloc(i) = [ ] ;
%    diastolicloc(i) = [ ];
%     end
% for i = 1:length(minima)-1
%     if Pminloc(1)<diastolicloc(1)
%         region = (Pminloc(i):diastolicloc(i));
%     elseif Pminloc(1)<diastolicloc(2) && Pminloc(2)<diastolicloc(2)
%         if i == 1
%             i = 2;
%         end
%         region = (Pminloc(i):diastolicloc(i));
%     else
%         region = (Pminloc(i+3):diastolicloc(i));
%     end
%region = (Pminloc(i): diastolicloc(i));
overalltime = [];
overallmag = [];
tao_estimate = [];
i = 1;
if diastolicloc(i) < Pminloc(i)
diastolicloc = diastolicloc(2:end);
end
minima = diastolicpeaks;
voltage = filtdata;
for i = 1:length(minima)-1
    if Pminloc(i) < diastolicloc(i)
        region = (Pminloc(i): diastolicloc(i));
    elseif Pminloc(i) > diastolicloc(i)
        region = (diastolicloc(i): Pminloc(i));
    elseif Pminloc(i) == 0 || diastolicloc(i) == 0
      Pminloc(i) = [ ] ;
      diastolicloc(i) = [ ];
    end
 timex = time(region);
overalltime = [overalltime timex' NaN];
% Define starting point
% [Po,P1,tau]
P0 = [1 1 1];
% Lower bounds
lb = [0 0 .00001];
% Upper bounds
ub = [Inf Inf Inf];

anonfunc = @(P) pressureerror(P,timex,voltage(region));
% fitted_pressure = pressureeqn(Pest,timex);
Pest = fmincon(anonfunc,P0,[],[],[],[],lb,ub);

tao_estimate = [tao_estimate Pest(3)];

fin = pressureeqn(Pest,timex);
overallmag = [overallmag fin' NaN];
end
figure
plot(delaytime,filtdata,'b-')
hold on
plot(overalltime,overallmag,'r-')
xlabel('Time(s)','FontSize',16) 
ylabel('Pressure (mmHg)','FontSize',16)
title('Diastolic Time Constants of Heart Pressure Waveform','FontSize',18)

%% Final Display of all Parameters to perform t and p tests on 
% %Finally display your average diastolic and systolic pressures, your
% %maximum deveoped pressure, your tau, and your maximum and minimum dp/dt
% %values for the user to see on the command window. And thats it :D
% 
% 

disp(['Heartrate: ', num2str(((length(systolicpeaks))/delaytime(length(delaytime)))*60), ' Beats/min ']) %avg beats per minute for rats is 300-400 BPM %avg beats per minute for rats is 300-400 BPM

disp(['Average Diastolic Pressure: ', num2str(-mean(minvalues)), ' mmHg      ', 'Average Systolic Pressure: ', num2str(mean(systolicpeaks)), ' mmHg '])
% 
disp(['Maximum Developed Pressure: ', num2str(mean(maxDP)), ' mmHg '])
% 
disp(['Tao: ', num2str(mean(tao_estimate)), ' Units N/A'])
% 
disp(['Maximum dp/dt Value: ', num2str(max(Pmaxpeaks)), ' mmHg/s ','        Minimum dp/dt Value: ', num2str(min(Pminpeaks)), ' mmHg/s '])
