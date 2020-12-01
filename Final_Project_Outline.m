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
%prompt=inputdlg('What is the filename?');
%fname=char(prompt);  
%rawdata=dlmread(fname,',',23,0);


fname = 'Infarct1.csv';
rawdata = importdata(fname);
time = rawdata.data(:,1);
heartwaveform = rawdata.data(:,2);
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

% %Define Samples to Plot to identify waveforms in 1 second intervals
% sample = 1:1:250; %Want to see the five wave forms we talked about in class in 1 second. 
% %Verify the sampling rate created only views that data at one second
% figure
% plot(time(sample),heartwaveform(sample))
% xlabel('Time (Seconds)')
% ylabel('Pressure (mmHg)')
% title('Raw Unfiltered Heart Condition Data - 1 Second')
%% Stop
isHealthy = 1;
if isHealthy == 1  %filter for healthy hearts
    LP = designfilt('lowpassfir','PassbandFrequency',10,...
    'StopbandFrequency',60,'StopbandAttenuation',65,'SampleRate',Fs);
    filtdata = filter(LP,heartwaveform);
    %filtered = filter(LPH, heartwaveform) Make different lpfilt for <3TYPE
elseif isHealthy == 2  %filter for infracted hearts 
      LP = designfilt('lowpassfir','PassbandFrequency',10,...
    'StopbandFrequency',60,'StopbandAttenuation',65,'SampleRate',Fs);
    filtdata = filter(LP,heartwaveform); %filtered = filter(LPI, heartwaveform)
else
    disp('Invalid Heart State input. Please try again.')
end


%% Plotting the Filtered Data

figure
plot(time,filtdata)
xlabel('Time (Seconds)')
ylabel('Pressure (mmHg)')
title('Low Pass Filtered Heart Condition')

% timedelay = grpdelay(LP); % find delay associated with low pass filter
% lowfilt = filtdata(timedelay:end); % account for this delay in dataset
% lowtime = time(1:(end-timedelay));% Time of dataset accounting for time delay form filter

%% Identify Local Maxima and Count for Heartbeats
% You may use previous code you have created in earlier labs to perfrom
% local maxima detection on the filtered signal. You should set your
% thresholds here. However, please remember to CHANGE YOUR VARIABLE
% NAMES. Tip - preallocate vectors of zeros to save time and processing power.
% It takes longer for the CPU to append to a vector than to change a vector
% value.

level = 50;
threshdata = false(size(filtdata));
thresdata(filtdata > level) = true;
threshdiff = diff(threshdata);

maximastart = find(threshdiff==1);
maximaend = find(threshdiff==-1);
maxpeak = zeros(size(maximastart));
amp = zeros(size(maximastart));

for i = 1:length(maximastart)
  [heartmax,curind] = max(filtdata(maximastart(i):maximaend(i)));
  maxpeak(i) = curind+maximastart(i)-1;
  [heartmin,~] = min(filtdata(maximastart(i):maximaend(i)));
  amp(i) = heartmax-heartmin;
end

peakdata = islocalmax(filtdata);
maxlocal = find(peakdata);
lowdata = islocalmin(filtdata);
minlocal = find(lowdata);
disp(maxlocal)
disp(minlocal)

%% Plot of Local Maxima
% hold on
% plot(time(peakdata),filtdata(peakdata), 'or')
% plot(time(lowdata), filtdata(lowdata),'or')
% plot(time(maxlocal),filtdata(maxlocal), 'or')
% plot(time(minlocal), filtdata(minlocal),'or')
% % figure
% plot(time(maximastart:maximaend), filtdata(maximastart:maximaend),'or')
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Local Maxima of Heart Pressure Waveform')

% figure
% plot(time,filtdata, 'or', time(peakdata:lowdata), filtdata(peakdata:lowdata))
%% Find peaks (Systolic)
% Use the findpeaks() function to find the peaks of the cleaned signal.
% Plot the peaks over the cleaned signal to prove that your threshold is
% correct.
% findpeaks(-y) finds min values of a set or min peaks
% [peaks_min,loc_min,width_min,~] = findpeaks(lowfilt);
% peaks_min = abs(peaks_min);
% title('Peaks (Systolic) of Heart Pressure Waveform')

avgdata = mean(filtdata);
[peaks,loc] = findpeaks(filtdata);
realpeaks = (peaks);
realloc = (loc);
for i = 1: length(realpeaks)
    if realpeaks(i) < avgdata
        realpeaks(i) = 0;
        realloc(i) = 0;
    end
end
 realpeaks(realpeaks==0) = [];
 realloc(realloc ==0) = []; 

maxlocations = realloc;
disp(maxlocations);

% %% Plotting the Systolic Pressure
% figure
% plot(time(realloc),realpeaks, 'o', time,filtdata(1:length(time)));  %Arrays need to be the same size so used 1:1016 to plot peaks.
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Peaks of Heart Pressure Waveform')
%% Find Minima (Diastolic) (inverted data set)
% Do the same as with the systolic, however invert the signal in order to
% find the diastolic minima occurance which now looks like a peak and thus you are able to use findpeaks(). Plot the occurances of the minima on
% the original filtered signal to prove that your threshold is correct.
avgdata = mean(-filtdata);
[peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+50);
realpeaks1 = (peaks1);
realloc1 = (loc1);
for i = 1: length(realpeaks1)
    if realpeaks1(i) < avgdata
        realpeaks1(i) = 0;
        realloc1(i) = 0;
    end
end
 realpeaks1(realpeaks1==0) = [];
 realloc1(realloc1 ==0) = []; 

minlocations = realloc1;
disp(minlocations);

% %% Plotting Distolic Pressure Waveform
% plot(time(realloc1),realpeaks1, 'o', time,-filtdata(1:length(time)));  
% % plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Minima (Diastolic) of Heart Pressure Waveform')
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
  maxDP = mean((filtdata(maxlocations)-filtdata(minlocations(1)))); 
else 
   maxDP = mean((filtdata(maxlocations)-filtdata((minlocations(2))))); 
end

disp(maxDP);
% maxDP = mean((filtdata(maxlocations)-filtdata(minlocations)));

%% Maximum rate of pressure increase 
% Take the derivative of the filtered signal and find the peaks using the
% findpeaks() function once more. Please plot the differentiated signal and
% the peaks in order to prove that your are finding the peaks.

derivolt=diff(filtdata);
% avgdata = mean(derivolt);
level = 5;
[peaks3,loc3] = findpeaks(derivolt);
realpeaks3 = (peaks3);
realloc3 = (loc3);
for i = 1:length(peaks3)
    if realpeaks3(i) < level
        realpeaks3(i) = 0;
        realloc3(i) = 0;
    end
end
realpeaks3(realpeaks3==0) = [];
realloc3(realloc3 ==0) = []; 

derivolt=diff(filtdata);
i = 1;
for value = 1:length(realpeaks3)
    realpeaks3Index(i) = find(derivolt == realpeaks3(value));
    i = i+1;
end
% plot(time(loc3),peaks3, 'o', time(length(derivolt)),derivolt);  
% % plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Max Pressure Peaks of Heart Pressure Waveform')
%% Minimum rate of pressure increase
% Do the same as above, however you would apply the findpeaks() function to
% the inverted derivative vector to find the minima. Plot the minimum rates
% of pressure increase on the derivative graph to show that your threshold
% was adequate.

derivolt= diff(-filtdata);
% avgdata = mean(-derivolt);
level = 5;
[peaks4,loc4] = findpeaks(derivolt);
% realpeaks = (peaks);
% realloc = (loc);
for i = 1: length(-peaks4)
    if peaks4(i) < level
        peaks4(i) = 0;
       loc4(i) = 0;
    end
end
peaks4(peaks4==0) = [];
loc4(loc4 ==0) = []; 
 derivolt=diff(-filtdata);
i = 1;
for value = 1:length(peaks4)
    peaks4Index(i) = find(derivolt == peaks4(value));
    i = i+1;
end
% plot(time(loc4),peaks4, 'o', time(1:end-1),-derivolt);  
% % plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Min Pressure Peaks of Heart Pressure Waveform')
%% Validation of minima dp/dt and minima
% Plot the original filtered signal, but now with where the max and minimum
% change in pressures noted. Best way to do so is to take the occurances of
% the minima and maxima (which should be samples) and plot it against the
% original signal values at those occurances(aka samples).
% 
% figure
% plot(time,filtdata)
% hold on
% plot(time(realloc3),realpeaks3, 'o')
% plot(time(loc4),peaks4, 'bo')

figure
plot(time,filtdata)
hold on
plot(time(realloc3),filtdata(realpeaks3Index), 'o')
plot(time(loc4),filtdata(peaks4Index), 'bo')
%% Diastolic Time Constant
% % Find the diastolic time constant over a time range as noted in lecture.
% % Please see the pressureerror and the pressureeqn Matlab functions and
% % scripts provided by the Professor. Remeber to acount for if the first
% % diastolic value occurs after the first minimum dp/dt value (use an if
% % loop). Plot to shhow how well the curve fits the original signal (or if
% % it works at all!) This is the hardest part of the final project, so don't
% % get discouraged if you have issues in this section.
% 
% overalltime = [];
% overallmag = [];
% tao_estimate = [];
% 
% for i = 1:length(minima)-1
%  
%  timex = time(region);
% overalltime = [overalltime timex'];
% % Define starting point
% % [Po,P1,tau]
% P0 = [1 1 1];
% % Lower bounds
% lb = [0 0 .00001];
% % Upper bounds
% ub = [Inf Inf Inf];
% 
% anonfunc = @(P) pressureerror(P,timex,voltage(region));
% 
% %fitted_pressure = pressureeqn(Pest,timex);
% Pest = fmincon(anonfunc,P0,[],[],[],[],lb,ub);
% 
% tao_estimate = [tao_estimate Pest(3)];
% 
% fin = pressureeqn(Pest,timex);
% overallmag = [overallmag fin'];
% end
% 
% 
% 
%% Final Display of all Parameters to perform t and p tests on 
% %Finally display your average diastolic and systolic pressures, your
% %maximum deveoped pressure, your tau, and your maximum and minimum dp/dt
% %values for the user to see on the command window. And thats it :D
% 
% 
%% Identify Local Maxima and Count for Heartbeats
% You may use previous code you have created in earlier labs to perfrom
% local maxima detection on the filtered signal. You should set your
% thresholds here. However, please remember to CHANGE YOUR VARIABLE
% NAMES. Tip - preallocate vectors of zeros to save time and processing power.
% It takes longer for the CPU to append to a vector than to change a vector
% value.

level = 50;
threshdata = false(size(filtdata));
thresdata(filtdata > level) = true;
threshdiff = diff(threshdata);

maximastart = threshdiff(threshdiff==1); %
maximaend = threshdiff(threshdiff==-1);
maxpeak = zeros(size(maximastart));
amp = zeros(size(maximastart));

for i = 1:length(maximastart)
  [heartmax,curind] = max(filtdata(maximastart(i):maximaend(i)));
  maxpeak(i) = curind+maximastart(i)-1;
  [heartmin,~] = min(filtdata(maximastart(i):maximaend(i)));
  amp(i) = heartmax-heartmin;
end

peakdata = islocalmax(filtdata);
maxlocal = find(peakdata);
lowdata = islocalmin(filtdata);
minlocal = find(lowdata);
disp(maxlocal)
disp(minlocal)

%% Plot of Local Maxima
figure
plot(time,filtdata, 'or' , time(maximastart:maximaend), filtdata(maximastart:maximaend))
% plot(time(maximastart:maximaend), filtdata(maximastart:maximaend),'or')
xlabel('Time(s)') 
ylabel('Pressure (mmHg)')
title('Local Maxima of Heart Pressure Waveform')

% figure
% plot(time,filtdata, 'or', time(peakdata:lowdata), filtdata(peakdata:lowdata))
%% Find peaks (Systolic)
% Use the findpeaks() function to find the peaks of the cleaned signal.
% Plot the peaks over the cleaned signal to prove that your threshold is
% correct.
% findpeaks(-y) finds min values of a set or min peaks
% [peaks_min,loc_min,width_min,~] = findpeaks(lowfilt);
% peaks_min = abs(peaks_min);

% plot(lowtime(loc_min),lowfilt(loc_min), 'o', lowtime, lowfilt(1:end-1));
% xlabel('Time (s)')
% ylabel('Pressure (mmHg)')
% title('Diastolic Pressure before filtering');
% [pks,locs] = findpeaks(filtdata);
% disp(locs)
% figure
% plot(time(locs), filtdata(locs), 'or', time, filtdata)
% xlabel('Time(s)') 
% ylabel('Pressure (mmHg)')
% title('Peaks (Systolic) of Heart Pressure Waveform')

avgdata = mean(filtdata);
[peaks,loc] = findpeaks(filtdata);
realpeaks = (peaks);
realloc = (loc);
for i = 1: length(realpeaks)
    if realpeaks(i) < avgdata
        realpeaks(i) = 0;
        realloc(i) = 0;
    end
end
 realpeaks(realpeaks==0) = [];
 realloc(realloc ==0) = []; 

maxlocations = realloc;
disp(maxlocations);

%% Plotting the Systolic Pressure
figure
plot(time(realloc),realpeaks, 'o', time,filtdata(1:length(time)));  %Arrays need to be the same size so used 1:1016 to plot peaks.
xlabel('Time(s)') 
ylabel('Pressure (mmHg)')
title('Peaks of Heart Pressure Waveform')
%% Find Minima (Diastolic) (inverted data set)
% Do the same as with the systolic, however invert the signal in order to
% find the diastolic minima occurance which now looks like a peak and thus you are able to use findpeaks(). Plot the occurances of the minima on
% the original filtered signal to prove that your threshold is correct.
avgdata = mean(-filtdata);
[peaks1,loc1] = findpeaks(-filtdata,'MinPeakDistance',+50); %+50 is better for infarcted data and +25 is better for Sham data
for i = 1: length(peaks1)
    if peaks1(i) < avgdata
        peaks1(i) = 0;
        loc1(i) = 0;
    end
end
 peaks1(peaks1==0) = [];
 loc1(loc1 ==0) = []; 

minlocations = loc1;
disp(minlocations);

%% Plotting Distolic Pressure Waveform
figure
plot(time(loc1),peaks1, 'o', time,-filtdata(1:length(time)));  
% plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
xlabel('Time(s)') 
ylabel('Pressure (mmHg)')
title('Minima (Diastolic) of Heart Pressure Waveform')
%% Maximum Developed Pressure
% Maximum developed pressure is the mean of the difference between the
% systolic and diastolic pressures. However, please remember that you may
% have more diastolic points than systolic points depending on when the
% recording starts during the heart beat! Use an if statement to adjust
% which systolic pressure to use (first recorded value or second)!

disp(maxlocations);
disp(minlocations);
%maxDP = average(systolic - diastolic)

if length(maxlocations) <= length(minlocations)
  maxDP = mean((filtdata(maxlocations)-filtdata(minlocations))); 
else 
   maxDP = mean((filtdata(maxlocations)-filtdata(minlocations(2:end)))); 
end

disp(maxDP);
% maxDP = mean((filtdata(maxlocations)-filtdata(minlocations)));

%% Maximum rate of pressure increase 
% Take the derivative of the filtered signal and find the peaks using the
% findpeaks() function once more. Please plot the differentiated signal and
% the peaks in order to prove that your are finding the peaks.

derivolt=diff(filtdata);
level = 5;
[peaks3,loc3] = findpeaks(derivolt);
for i = 1: length(peaks3)
    if peaks3(i) < level
        peaks3(i) = 0;
        loc3(i) = 0;
    end
end
 peaks3(peaks3==0) = [];
 loc3(loc3 ==0) = []; 
 
plot(time(loc3),peaks3, 'o', time(length(derivolt)),derivolt);  
% plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
xlabel('Time(s)') 
ylabel('Pressure (mmHg)')
title('Max Pressure Peaks of Heart Pressure Waveform')
%% Minimum rate of pressure increase
% Do the same as above, however you would apply the findpeaks() function to
% the inverted derivative vector to find the minima. Plot the minimum rates
% of pressure increase on the derivative graph to show that your threshold
% was adequate.

derivolt=diff(filtdata);
level = 5;
[peaks4,loc4] = findpeaks(-derivolt);
for i = 1: length(peaks4)
    if peaks4(i) < level
        peaks4(i) = 0;
        loc4(i) = 0;
    end
end
 peaks4(peaks4==0) = [];
 loc4(loc4 ==0) = []; 
 
plot(time(loc4),peaks4, 'o', time(length(-derivolt)),-derivolt);  
% plot(time(locs1), filtdata(locs1), 'or', time, filtdata)
xlabel('Time(s)') 
ylabel('Pressure (mmHg)')
title('Min Pressure Peaks of Heart Pressure Waveform')
%% Validation of minima dp/dt and minima
% Plot the original filtered signal, but now with where the max and minimum
% change in pressures noted. Best way to do so is to take the occurances of
% the minima and maxima (which should be samples) and plot it against the
% original signal values at those occurances(aka samples).

figure
plot(time,filtdata)
hold on
plot(time(loc3),peaks3, 'or')
plot(time(loc4),peaks4, 'bo')

%% Diastolic Time Constant
% % Find the diastolic time constant over a time range as noted in lecture.
% % Please see the pressureerror and the pressureeqn Matlab functions and
% % scripts provided by the Professor. Remeber to acount for if the first
% % diastolic value occurs after the first minimum dp/dt value (use an if
% % loop). Plot to shhow how well the curve fits the original signal (or if
% % it works at all!) This is the hardest part of the final project, so don't
% % get discouraged if you have issues in this section.
% 
% overalltime = [];
% overallmag = [];
% tao_estimate = [];
% 
% for i = 1:length(minima)-1
%  
%  timex = time(region);
% overalltime = [overalltime timex'];
% % Define starting point
% % [Po,P1,tau]
% P0 = [1 1 1];
% % Lower bounds
% lb = [0 0 .00001];
% % Upper bounds
% ub = [Inf Inf Inf];
% 
% anonfunc = @(P) pressureerror(P,timex,voltage(region));
% 
% %fitted_pressure = pressureeqn(Pest,timex);
% Pest = fmincon(anonfunc,P0,[],[],[],[],lb,ub);
% 
% tao_estimate = [tao_estimate Pest(3)];
% 
% fin = pressureeqn(Pest,timex);
% overallmag = [overallmag fin'];
% end
% 
% 
% 
%% Final Display of all Parameters to perform t and p tests on 
% %Finally display your average diastolic and systolic pressures, your
% %maximum deveoped pressure, your tau, and your maximum and minimum dp/dt
% %values for the user to see on the command window. And thats it :D
% 
% 
