function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNBuz5x1264(recording_format)
%caraslab_channelmap_NNBuz5x1264(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus Buzsaki 5x12 H64LP probe.
%
% Input variables:
%   recording_format:  'synapse' or 'intan'
%
% Output variables:
%   Nchannels:      number of channels on this probe
%   kcoords_map:    cell array of channel groups (one cell per shank/site group)
%   xcoords_map:    cell array of x-coordinates (microns), matched to kcoords_map
%   ycoords_map:    cell array of y-coordinates (microns), matched to kcoords_map

Nchannels = 64;

switch recording_format
    % Synapse channel mapping
    case 'synapse'
        %Define the channel groups:
        shank1L = [61,60,63,62,58,59]; %left side of shank 1
        shank1R = [54,55,52,53,57,56]; %right side of shank 1

        shank2L = [49,48,51,50,18,17]; %left side of shank 2
        shank2R = [21,24,26,25,22,20]; %right side of shank 2

        shank3L = [32,29,30,28,31,27]; %left side of shank 3
        shank3R = [2,3,4,6,1,5];       %right side of shank 3

        shank4L = [11,10,8,7,12,14];   %left side of shank 4
        shank4R = [47,46,45,44,16,15]; %right side of shank 4

        shank5L = [40,41,42,43,39,38]; %left side of shank 5
        shank5R = [35,34,64,33,36,37]; %right side of shank 5

        extrasite1 = 23;     %extra sites on shank 3
        extrasite2 = 9;     %extra sites on shank 3
        extrasite3 = 19;     %extra sites on shank 3
        extrasite4 = 13;     %extra sites on shank 3

    % Intan channel mapping
    case  'intan'
        %Define the channel groups:
        shank1L = [19, 20, 17, 18, 22, 21]; %left side of shank 1
        shank1R = [26, 25, 28, 27, 23, 24]; %right side of shank 1

        shank2L = [31, 32, 29, 30, 1, 2]; %left side of shank 2
        shank2R = [6, 7, 9, 10, 5, 3]; %right side of shank 2

        shank3L = [15, 14, 13, 11, 16, 12]; %left side of shank 3
        shank3R = [49, 52, 51, 53, 50, 54];       %right side of shank 3

        shank4L = [60, 57, 55, 56, 59, 61];   %left side of shank 4
        shank4R = [33, 34, 35, 36, 63, 64]; %right side of shank 4

        shank5L = [40, 39, 38, 37, 41, 42]; %left side of shank 5
        shank5R = [45, 46, 47, 48, 44, 43]; %right side of shank 5

        extrasite1 = 8;     %extra sites on shank 3
        extrasite2 = 58;     %extra sites on shank 3
        extrasite3 = 4;     %extra sites on shank 3
        extrasite4 = 62;     %extra sites on shank 3

    otherwise
        error('caraslab_channelmap_NNBuz5x1264:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {[shank1L,shank1R]; [shank2L,shank2R]; ...
    [shank3L,shank3R]; [shank4L,shank4R]; [shank5L,shank5R]; ...
    extrasite1; extrasite2; extrasite3; extrasite4};


%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%On each shank, sites are spaced in two columns, set 20 um apart
xL = zeros(1,6);
xR = zeros(1,6)+20;

%Shank 1 will be defined as starting at position 0
Xshank1L = xL;
Xshank1R = xR;

%Shank 2 is 200 um away from shank 1
Xshank2L = 200+xL;
Xshank2R = 200+xR;

%Shank 3 is 400 um away from shank 1
Xshank3L = 400+xL;
Xshank3R = 400+xR;

%Shank 4 is 600 um away from shank 1
Xshank4L = 600+xL;
Xshank4R = 600+xR;

%Shank 5 is 800 um away from shank 1
Xshank5L = 800+xL;
Xshank5R = 800+xR;

%The extra sites are centered on shank 3 (i.e. 10 um offset from the columns)
Xextra1 = 10 + Xshank3L(1);
Xextra2 = 10 + Xshank3L(2);
Xextra3 = 10 + Xshank3L(3);
Xextra4 = 10 + Xshank3L(4);

% This will be used below to set xcoords appropriately
xcoords_map = {[Xshank1L,Xshank1R]; [Xshank2L,Xshank2R]; ...
    [Xshank3L,Xshank3R]; [Xshank4L,Xshank4R]; [Xshank5L,Xshank5R]; ...
    Xextra1; Xextra2; Xextra3; Xextra4};


%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%Left column starts 55 um above the tip,
%and extends upwards in 20 um spacing
yL = fliplr(55:20:(55+20*5));

%Right column starts 35 um above the tip,
%and extends upward in 20 um spacing
yR = fliplr(35:20:(35+20*5));

%Shank 1
Yshank1L = yL;
Yshank1R = yR;

%Shank 2
Yshank2L = yL;
Yshank2R = yR;

%Shank 3
Yshank3L = yL;
Yshank3R = yR;

%Shank 4
Yshank4L = yL;
Yshank4R = yR;

%Shank 5
Yshank5L = yL;
Yshank5R = yR;

%Extra sites start 200 um above the top most site on the left,
%and extend upwards in 200 um spacing
Yextra1 = yL(end)+200;
Yextra2 = yL(end)+400;
Yextra3 = yL(end)+600;
Yextra4 = yL(end)+800;

% This will be used below to set ycoords appropriately
ycoords_map = {[Yshank1L,Yshank1R]; [Yshank2L,Yshank2R]; ...
    [Yshank3L,Yshank3R]; [Yshank4L,Yshank4R]; [Yshank5L,Yshank5R]; ...
    Yextra1; Yextra2; Yextra3; Yextra4};

end
