function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNBuz4x8L(recording_format)
%caraslab_channelmap_NNBuz4x8L(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus X3-H32-Buzsaki32/L probe (only set up for Intan).
%
% Input variables:
%   recording_format:  'synapse' or 'intan'
%
% Output variables:
%   Nchannels:      number of channels on this probe
%   kcoords_map:    cell array of channel groups (one cell per shank/site group)
%   xcoords_map:    cell array of x-coordinates (microns), matched to kcoords_map
%   ycoords_map:    cell array of y-coordinates (microns), matched to kcoords_map

Nchannels = 32;

switch recording_format
    case 'synapse'
        % Not applicable in the Caras Lab. This probe is configured for
        % Molex+X-series amplifier recordings
        error('caraslab_channelmap_NNBuz4x8L:notApplicable', ...
            'This probe is not configured for Synapse recordings in the Caras Lab')
    case 'intan'
        %Define the channel groups:
        Kshank1 = [14, 32, 22, 24, 30, 16, 7, 8];  % top to bottom

        Kshank2 = [15, 6, 23, 5, 31, 13, 29, 21];  % top to bottom

        Kshank3 = [28, 4, 27, 3, 19, 12, 20, 11];  % top to bottom

        Kshank4 = [25, 2, 26, 1, 17, 10, 18, 9];  % top to bottom

    otherwise
        error('caraslab_channelmap_NNBuz4x8L:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {Kshank1; Kshank2; Kshank3; Kshank4};

%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
%Shank 1 channel 14 will be defined as starting at position 0
Xshank_spacing = 200;

Xshank1 = [0, 37, 4, 33, 8, 29, 12, 10.5];

Xshank2 = Xshank1 + Xshank_spacing;

Xshank3 = Xshank2 + Xshank_spacing;

Xshank4 = Xshank3 + Xshank_spacing;

% This will be used below to set xcoords appropriately
xcoords_map = {Xshank1; Xshank2; Xshank3; Xshank4};


%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
% Deepest channel is 22 um above the tip,
% and extends upward in 20 um spacing
y_locs = fliplr(22:20:(22+20*7));

% This will be used below to set ycoords appropriately
ycoords_map = {y_locs; y_locs; y_locs; y_locs};

end
