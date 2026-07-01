function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NN4x16Poly64(recording_format)
%caraslab_channelmap_NN4x16Poly64(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus A4x16 Poly2 H64LP probe (only set up for Synapse).
%
% Input variables:
%   recording_format:  'synapse' or 'intan'
%
% Output variables:
%   Nchannels:      number of channels on this probe
%   kcoords_map:    cell array of channel groups (one cell per shank)
%   xcoords_map:    cell array of x-coordinates (microns), matched to kcoords_map
%   ycoords_map:    cell array of y-coordinates (microns), matched to kcoords_map

Nchannels = 64;

switch recording_format
    case 'synapse'
        %Define the channel groups:
        shank1L = [59,58,61,60,63,62,56,57]; %left side of shank 1
        shank1R = [52,53,50,51,48,49,55,54]; %right side of shank 1

        shank2L = [24,21,22,20,17,18,26,25]; %left side of shank 2
        shank2R = [29,32,31,27,23,19,30,28]; %right side of shank 2

        shank3L = [3,2,1,5,9,13,4,6]; %left side of shank 3
        shank3R = [10,11,12,14,15,16,8,7];       %right side of shank 3

        shank4L = [42,43,44,45,46,47,41,40];   %left side of shank 4
        shank4R = [37,36,35,34,64,33,38,39]; %right side of shank 4
    case  'intan'
        % TODO
        error('caraslab_channelmap_NN4x16Poly64:notImplemented', ...
            'This probe type has not been set up yet for the Intan system')
    otherwise
        error('caraslab_channelmap_NN4x16Poly64:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {[shank1L,shank1R]; [shank2L,shank2R]; ...
    [shank3L,shank3R]; [shank4L,shank4R]};


%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%On each shank, sites are spaced in two columns, set 30 um apart
xL = zeros(1,8);
xR = zeros(1,8)+30;

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

% This will be used below to set xcoords appropriately
xcoords_map = {[Xshank1L,Xshank1R]; [Xshank2L,Xshank2R]; ...
    [Xshank3L,Xshank3R]; [Xshank4L,Xshank4R]};

%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%Left column starts 73 um above the tip,
%and extends upwards in 23 um spacing; 7 spaces between channels
yL = fliplr(73:23:(73+23*7));

%Right column starts 50 um above the tip,
%and extends upward in 23 um spacing; 7 spaces between channels
yR = fliplr(50:23:(50+23*7));

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

% This will be used below to set ycoords appropriately
ycoords_map = {[Yshank1L,Yshank1R]; [Yshank2L,Yshank2R]; ...
    [Yshank3L,Yshank3R]; [Yshank4L,Yshank4R]};

end
