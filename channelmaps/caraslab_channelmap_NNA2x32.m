function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNA2x32(recording_format)
%caraslab_channelmap_NNA2x32(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus A2x32-5mm-25-200-177 probe (only set up for Synapse).
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
        shank1 = [18, 49, 17, 48, 20, 51, 22, 50, 21, 53, 24, 52, 26, 55, ...
            25, 54, 28, 57, 30, 56, 29, 59, 32, 58, 31, 61, 27, 60, 23, 63, 19, 62];
        shank2 = setdiff(1:64, shank1);  % fill with whatever is left out of 64 channels
    case 'intan'
        % TODO:
        error('caraslab_channelmap_NNA2x32:notImplemented', ...
            'This probe type has not been set up yet for the Intan system')
    otherwise
        error('caraslab_channelmap_NNA2x32:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {shank1; shank2};


%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
% Shanks are 200 um apart
Xshank1 = zeros(1,32);
Xshank2 = zeros(1,32)+200;

% This will be used below to set xcoords appropriately
xcoords_map = {Xshank1, Xshank2};

%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
% Electrodes start 50 um above the tip,
%and extend upwards in 25 um spacing; 31 spaces between channels
Yshank1 = fliplr(50:25:(50+25*31));
Yshank2 = Yshank1;
% This will be used below to set ycoords appropriately
ycoords_map = {Yshank1, Yshank2};

end
