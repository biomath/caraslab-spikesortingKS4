function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNA1x16(recording_format)
%caraslab_channelmap_NNA1x16(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus A1x16-Linear probe (only set up for Intan+OpenEphys).
%
% Input variables:
%   recording_format:  'synapse' or 'intan'
%
% Output variables:
%   Nchannels:      number of channels on this probe
%   kcoords_map:    cell array of channel groups (one cell per channel)
%   xcoords_map:    cell array of x-coordinates (microns), matched to kcoords_map
%   ycoords_map:    cell array of y-coordinates (microns), matched to kcoords_map

Nchannels = 16;

switch recording_format
    case 'synapse'
        error('caraslab_channelmap_NNA1x16:notImplemented', ...
            'This probe type has not been set up yet for the TDT system')
    case 'intan'
        % From top of shank to bottom
        shank_chs = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9];
    otherwise
        error('caraslab_channelmap_NNA1x16:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
% Channels are 100 um apart so it doesn't make sense to sort
% them together, maybe?
kcoords_map = num2cell(shank_chs);

%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
xcoords_map = num2cell(zeros(size(shank_chs)));

%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
ycoords_chs = 1500:-100:0;  % top to bottom
ycoords_map = num2cell(ycoords_chs);

end
