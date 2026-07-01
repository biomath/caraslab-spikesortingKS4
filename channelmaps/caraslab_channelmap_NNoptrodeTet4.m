function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNoptrodeTet4(recording_format)
%caraslab_channelmap_NNoptrodeTet4(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus Qtrode tetrode probe (only set up for Intan+OpenEphys).
%
% Input variables:
%   recording_format:  'synapse' or 'intan'
%
% Output variables:
%   Nchannels:      number of channels on this probe
%   kcoords_map:    cell array of channel groups
%   xcoords_map:    cell array of x-coordinates (microns), matched to kcoords_map
%   ycoords_map:    cell array of y-coordinates (microns), matched to kcoords_map

Nchannels = 4;

switch recording_format
    case 'synapse'
        error('caraslab_channelmap_NNoptrodeTet4:notImplemented', ...
            'This probe type has not been set up yet for the TDT system')
    case 'intan'
        qtrode = 1:4;
    otherwise
        error('caraslab_channelmap_NNoptrodeTet4:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {qtrode};

%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
% Leftmost channel is arbitrarily 0
xcoords_map = {[17.8, 17.8, 0, 35.6]};

%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
% Tip of the probe is 0
ycoords_map = {[155.6, 120, 137.8, 137.8]};

end
