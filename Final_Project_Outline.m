%% Name and Group Number
%% Import Data - Azka
% Please remember that this code must prompt the user for the file name.Use
% funvtion inputdlg(). Having done so, use the filename input to import
% your data set. Plot the data set to assure that it is importing the
% correct data. You are allowed to ask the user for if the data set came
% from a healthy or infracted heart.
% 
% function inputdlg()
% choose_group = questdlg('Which data set are we going to analyze?','Input Group', 'Sham', 'Infarcted', 'Thick');
% heartcondition = ["Sham", "Infarct"];
% heartcondition_identifier = 1; %Sham
% for i = 6 %due to the six sets of each data we have for sham and infarcted
%     fname = sprintf('%s_%s.csv',heartcondition(heartcondition_identifier),num2str(i));
%     rawdata = importdata(fname,',',23);
% end
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

%Define Samples to Plot to identify waveforms in 1 second intervals
sample = 1:1:250; %Want to see the five wave forms we talked about in class in 1 second. 
%Verify the sampling rate created only views that data at one second
figure
plot(time(sample),heartwaveform(sample))
xlabel('Time (Seconds)')
ylabel('Pressure (mmHg)')
title('Raw Unfiltered Heart Condition Data - 1 Second')

%% Desigining the lowpass filter
LP = designfilt('lowpassfir','PassbandFrequency',10,...
    'StopbandFrequency',60,'StopbandAttenuation',65,'SampleRate',250);
filtdata = filter(LP,heartwaveform);
figure
plot(time(sample),filtdata(sample))
xlabel('Time (Seconds)')
ylabel('Pressure (mmHg)')
title('Low Pass Filtered Heart Condition Data - 1 Second')
% pass_band = [6 5];
% stop_band_freq = [25 60];
% stop_band_att = [65];
% lpFilt = designfilt('lowpassfir','PassbandFrequency', 5,...
%    pass_band(heartwaveform),...
%    'StopbandFrequency',stop_band_freq(heartwaveform),'StopbandAttenuation',stop_band_att(heartwaveform),...
%    'SampleRate', Fs);
%Applying low pass filter
% lowfilt_data = filter(lpFilt,heartwaveform);
%Plot to visually check the function worked accordingly
% figure
% plot(time,lowfilt_data)
% xlabel('Time (Seconds)')
% ylabel('Pressure (mmHg)')
% title('Low Pass Filtered Heart Condition Data - 1 Second')
%% Stop
if heartwaveform == 1
    %filter for healthy hearts
elseif heartwaveform == 2
   %filter for infracted hearts 
else
    disp('Invalid Heart State input. Please try again.')
end


%% Plot Filtered Data

timedelay = grpdelay(LP); % find delay associated with low pass filter
lowfilt = filtdata(timedelay:end); % account for this delay in dataset
lowtime = time(1:(end-timedelay));
figure
plot(lowtime(sample),lowfilt(sample))
xlabel ('Time(s)')
ylabel('Pressure (mmHg)')
title('Lowpass Filtered Data')
%% Identify Local Maxima and Count for Heartbeats
% You may use previous code you have created in earlier labs to perfrom
% local maxima detection on the filtered signal. You should set your
% thresholds here. However, please remember to CHANGE YOUR VARIABLE
% NAMES. Tip - preallocate vectors of zeros to save time and processing power.
% It takes longer for the CPU to append to a vector than to change a vector
% value.
[peaks,loc,width,~] = findpeaks(lowfilt);
figure
plot(lowtime(loc),lowfilt(loc), 'o' , lowtime(1:1016),lowfilt(1:1016)); %Arrays need to be the same size so used 1:1016 to plot peaks.
xlabel('Time(s)')
ylabel('Pressure (mmHg)')
title('Peaks of Heart Pressure Waveform')
%% Applying the filtering
level = 0.5*(max(lowfilt)-min(lowfilt));
threshdata = false(size(peaks));
thresdata(peaks > level) = true;
peak_err = find(threshdata == 0);
peaks(peak_err) = [];
loc(peak_err) = [];
width(peak_err) = [];
% threshdiff = diff(threshdata);
% peakstart = find(threshdiff==1);
% peakend = find(threshdiff==-1);
% peakstart = peakstart(1:end-1);
% peakend = peakend(2:end);
% 
% peak = zeros(size(peakstart));
% amp = zeros(size(peakstart));
% 
% for i = 1:length(peakstart)
%   [peakmax,curind] = max(lowfilt(peakstart(i):peakend(i)));
%   peak(i) = curind+peakstart(i)-1;
%   [qrsmin,~] = min(hpdata(peakstart(i):peakend(i)));
%   amp(i) = peakmax-qrsmin;
% end
%% Plot Again
figure
plot(lowtime(peaks),lowfilt(peaks), 'o' ,lowtime(1:1016),lowfilt(1:1016)); %Arrays need to be the same size so used 1:1016 to plot peaks.
xlabel('Time(s)')
ylabel('Pressure (mmHg)')
title('Peaks of Heart Pressure Waveform')
% rrint = diff(peak)/Fs;
% HR = 60/mean(rrint);
%% Find peaks (Systolic)
% Use the findpeaks() function to find the peaks of the cleaned signal.
% Plot the peaks over the cleaned signal to prove that your threshold is
% correct.
% findpeaks(-y) finds min values of a set or min peaks
[peaks_min,loc_min,width_min,~] = findpeaks(-lowfilt);
peaks_min = abs(peaks_min);
figure
plot(lowtime(loc_min),lowfilt(loc_min), 'o', lowtime(1:1016), lowfilt(1:1016));
xlabel('Time (s)')
ylabel('Pressure (mmHg)')
title('Diastolic Pressure before filtering');
%% Find Minima (Diastolic) (inverted data set)
% Do the same as with the systolic, however invert the signal in order to
% find the diastolic minima occurance which now looks like a peak and thus you are able to use findpeaks(). Plot the occurances of the minima on
% the original filtered signal to prove that your threshold is correct.

level = (0.5*(min(-lowfilt)-max(-lowfilt)))+min(-lowfilt);
threshdata = false(size(abs(peaks_min)));
thresdata(abs(peaks_min) > level) = true;
peak_err = find(threshdata == 0);
peaks_min(peak_err) = [];
loc_min(peak_err) = [];
width_min(peak_err) = [];
figure
plot(lowtime(loc_min),lowfilt(loc_min), 'o', lowtime(1:1016), lowfilt(1:1016));
xlabel('Time (s)')
ylabel('Pressure (mmHg)')
title('Diastolic Pressure after filtering');
%% Maximum Developed Pressure - Claire
% Maximum developed pressure is the mean of the difference between the
% systolic and diastolic pressures. However, please remember that you may
% have more diastolic points than systolic points depending on when the
% recording starts during the heart beat! Use an if statement to adjust
% which systolic pressure to use (first recorded value or second)!



%% Maximum rate of pressure increase 
% Take the derivative of the filtered signal and find the peaks using the
% findpeaks() function once more. Please plot the differentiated signal and
% the peaks in order to prove that your are finding the peaks.
derivolt=diff(voltage);


%% Minimum rate of pressure increase
% Do the same as above, however you would apply the findpeaks() function to
% the inverted derivative vector to find the minima. Plot the minimum rates
% of pressure increase on the derivative graph to show that your threshold
% was adequate.


%% Validation of minima dp/dt and minima
% Plot the original filtered signal, but now with where the max and minimum
% change in pressures noted. Best way to do so is to take the occurances of
% the minima and maxima (which should be samples) and plot it against the
% original signal values at those occurances(aka samples).




%% Diastolic Time Constant
% Find the diastolic time constant over a time range as noted in lecture.
% Please see the pressureerror and the pressureeqn Matlab functions and
% scripts provided by the Professor. Remeber to acount for if the first
% diastolic value occurs after the first minimum dp/dt value (use an if
% loop). Plot to shhow how well the curve fits the original signal (or if
% it works at all!) This is the hardest part of the final project, so don't
% get discouraged if you have issues in this section.

overalltime = [];
overallmag = [];
tao_estimate = [];

for i = 1:length(minima)-1
 
 timex = time(region);
overalltime = [overalltime timex'];
% Define starting point
% [Po,P1,tau]
P0 = [1 1 1];
% Lower bounds
lb = [0 0 .00001];
% Upper bounds
ub = [Inf Inf Inf];

anonfunc = @(P) pressureerror(P,timex,voltage(region));

%fitted_pressure = pressureeqn(Pest,timex);
Pest = fmincon(anonfunc,P0,[],[],[],[],lb,ub);

tao_estimate = [tao_estimate Pest(3)];

fin = pressureeqn(Pest,timex);
overallmag = [overallmag fin'];
end



%% Final Display of all Parameters to perform t and p tests on 
%Finally display your average diastolic and systolic pressures, your
%maximum deveoped pressure, your tau, and your maximum and minimum dp/dt
%values for the user to see on the command window. And thats it :D


