function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNA4x16Lin64(recording_format)
%caraslab_channelmap_NNA4x16Lin64(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus A4x16 Poly2 Linear H64LP probe.
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
    case 'synapse'
        %Define the channel groups:
        shank1L = [59, 58, 61, 60, 63, 62, 56]; %left side of shank 1
        shank1R = [52, 53, 50, 51, 48, 49, 55]; %right side of shank 1

        shank2L = [24, 21, 22, 20, 17, 18, 26]; %left side of shank 2
        shank2R = [29, 32, 31, 27, 23, 19, 30]; %right side of shank 2

        shank3L = [3, 2, 1, 5, 9, 13, 4]; %left side of shank 3
        shank3R = [10, 11, 12, 14, 15, 16, 8];       %right side of shank 3

        shank4L = [42, 43, 44, 45, 46, 47, 41];   %left side of shank 4
        shank4R = [37, 36, 35, 34, 64, 33, 38]; %right side of shank 4
        extrasite1shank1 = 54;     %extra sites on shank 1
        extrasite2shank1 = 57;     %extra sites on shank 1
        extrasite3shank2 = 28;     %extra sites on shank 2
        extrasite4shank2 = 25;     %extra sites on shank 2
        extrasite5shank3 = 7;     %extra sites on shank 3
        extrasite6shank3 = 6;     %extra sites on shank 3
        extrasite7shank4 = 39;     %extra sites on shank 4
        extrasite8shank4 = 40;     %extra sites on shank 4
    case 'intan'
        %Define the channel groups:
        shank1L = [21, 22, 19, 20, 17, 18, 24]; %left side of shank 1
        shank1R = [28, 27, 30, 29, 32, 31, 25]; %right side of shank 1

        shank2L = [7, 6, 5, 3, 2, 1, 9]; %left side of shank 2
        shank2R = [14, 15, 16, 12, 8, 4, 13]; %right side of shank 2

        shank3L = [52, 49, 50, 54, 58, 62, 51]; %left side of shank 3
        shank3R = [57, 60, 59, 61, 64, 63, 55];       %right side of shank 3

        shank4L = [38, 37, 36, 35, 34, 33, 39];   %left side of shank 4
        shank4R = [43, 44, 45, 46, 47, 48, 42]; %right side of shank 4
        extrasite1shank1 = 23;     %extra sites on shank 1
        extrasite2shank1 = 26;     %extra sites on shank 1
        extrasite3shank2 = 10;     %extra sites on shank 2
        extrasite4shank2 = 11;     %extra sites on shank 2
        extrasite5shank3 = 53;     %extra sites on shank 3
        extrasite6shank3 = 56;     %extra sites on shank 3
        extrasite7shank4 = 40;     %extra sites on shank 4
        extrasite8shank4 = 41;     %extra sites on shank 4
    otherwise
        error('caraslab_channelmap_NNA4x16Lin64:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {[shank1L,shank1R]; [shank2L,shank2R]; ...
    [shank3L,shank3R]; [shank4L,shank4R]; ...
    extrasite1shank1; extrasite2shank1; extrasite3shank2; extrasite4shank2;
    extrasite5shank3; extrasite6shank3; extrasite7shank4; extrasite8shank4};


%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%On each shank, sites are spaced in two columns, set 17.32 um apart
xL = zeros(1,7);
xR = zeros(1,7)+17.32;

%Shank 1 will be defined as starting at position 0
Xshank1L = xL;
Xshank1R = xR;

%Shank 2 is 150 um away from shank 1
Xshank2L = 150+xL;
Xshank2R = 150+xR;

%Shank 3 is 300 um away from shank 1
Xshank3L = 300+xL;
Xshank3R = 300+xR;

%Shank 4 is 450 um away from shank 1
Xshank4L = 450+xL;
Xshank4R = 450+xR;

% Extra sites are centered on each shank, 17.32/2 from L electrodes
extrasite1shank1 = Xshank1L(1)+17.32/2;     %extra sites on shank 1
extrasite2shank1 = Xshank1L(1)+17.32/2;     %extra sites on shank 1
extrasite3shank2 = Xshank2L(1)+17.32/2;     %extra sites on shank 2
extrasite4shank2 = Xshank2L(1)+17.32/2;     %extra sites on shank 2
extrasite5shank3 = Xshank3L(1)+17.32/2;     %extra sites on shank 3
extrasite6shank3 = Xshank3L(1)+17.32/2;     %extra sites on shank 3
extrasite7shank4 = Xshank4L(1)+17.32/2;     %extra sites on shank 4
extrasite8shank4 = Xshank4L(1)+17.32/2;     %extra sites on shank 4

% This will be used below to set xcoords appropriately
xcoords_map = {[Xshank1L,Xshank1R]; [Xshank2L,Xshank2R]; ...
    [Xshank3L,Xshank3R]; [Xshank4L,Xshank4R]; ...
    extrasite1shank1; extrasite2shank1; extrasite3shank2; extrasite4shank2;
    extrasite5shank3; extrasite6shank3; extrasite7shank4; extrasite8shank4};


%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%Left column bottom channel is 50 um above the tip,
%and extends upward in 20 um spacing
yL = fliplr(50:20:(50+20*6));

%Right column starts 40 um above the tip,
%and extends upward in 20 um spacing
yR = fliplr(40:20:(40+20*6));

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

% Extra sites on shank 1 are centered on each shank, 100 and 200 away from top
% L site; shank 2 starts at same Y as shank 1 and the next moves up
% 100 um; same logic for 3 and 4
extrasite1shank1 = yL(1)+100;     %extra sites on shank 1
extrasite2shank1 = yL(1)+200;     %extra sites on shank 1
extrasite3shank2 = yL(1)+200;     %extra sites on shank 2
extrasite4shank2 = yL(1)+300;     %extra sites on shank 2
extrasite5shank3 = yL(1)+300;     %extra sites on shank 3
extrasite6shank3 = yL(1)+400;     %extra sites on shank 3
extrasite7shank4 = yL(1)+400;     %extra sites on shank 4
extrasite8shank4 = yL(1)+500;     %extra sites on shank 4

% This will be used below to set ycoords appropriately
ycoords_map = {[Yshank1L,Yshank1R]; [Yshank2L,Yshank2R]; ...
    [Yshank3L,Yshank3R]; [Yshank4L,Yshank4R]; ...
    extrasite1shank1; extrasite2shank1; extrasite3shank2; extrasite4shank2;
    extrasite5shank3; extrasite6shank3; extrasite7shank4; extrasite8shank4};

end
