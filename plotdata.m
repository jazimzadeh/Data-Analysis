function [out1,out2] = plotdata(filepath,record_num,varargin)
% Julien B. Azimzadeh - May 21, 2015
% This function plots each of the parameters passed into the function.
% The following parameters can be selected to be plotted:
% Ionto     = Iontophoresis current
% Xc        = Commanded displacement (to piezo)
% Xd        = Displacement recorded by photodiode
% I         = Current from voltage clamp
% LaserC    = Commanded laser output
% LaserP    = Picked-off laser power
% Enter the full filepath as a string, then the record you wish to plot
% from, and finally the parameters you wish to plot.

% *** Make sure we are in the desired directory ***
current_dir = pwd;
if strcmp(current_dir,filepath) == 0    % if the current dir is not the one desired
    cd(filepath);                       % then go to the one desired
end

% *** Import parameter (recorded) data ***
fileList = dir('*.txt'); % Get an array w/ 1 cell per file. The 'name' field of the array contains the file name
file_names = {fileList.name}; 
has_raw = strfind(file_names,'raw.txt');            % Find names that contain 'raw.txt'
q_matches = cellfun(@isempty,has_raw);              % Mark the non-raws with 1's and the raw with 0's
fileList2 = fileList(q_matches);                    % Make a new fileList, that contains only .txt files, with no raw.txt
struct_data = cellfun(@importdata,{fileList2.name});

r = record_num;                         % The record number to plot
num_params = length(varargin);          % Number of parameters to plot for that record

%out1 = varargin{1};
%out2 = varargin{2};

% *** Import logfile data ***
logfile_name = getfield(dir('*.log'),'name');
logfile_name_clean = logfile_name(1:end-7); % remove excess numbers from filename, for use in figure titles below
logfile = importdata(logfile_name);
wavetrain = logfile.data(r,8);              % get number of wavetrains [actually waveforms] for that run
laser_delay = logfile.data(r,43)*.001;      % in milliseconds
laser_duration = logfile.data(r,44)*.001;   % in milliseconds
laser_voltage = logfile.data(r,63);

Fs = logfile.data(r,12);                    % sampling rate
T = 1/Fs;
L = length(struct_data(r).data(:,2));    
t = (0:L-1)*T;                              % time vector
   
% Make a list of the parameters to plot?
for n = 1:num_params
   subplot(num_params,1,n) 
   plot(t,struct_data(r).data(:,:)); 
   hold on
   
end

end
