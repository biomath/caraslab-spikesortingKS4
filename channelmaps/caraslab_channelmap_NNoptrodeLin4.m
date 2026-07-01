function [Nchannels, kcoords_map, xcoords_map, ycoords_map] = caraslab_channelmap_NNoptrodeLin4(recording_format)
%caraslab_channelmap_NNoptrodeLin4(recording_format)
%
%Returns channel group (k), x-coordinate, and y-coordinate maps for the
%Neuronexus Qtrode-Linear probe (only set up for Intan+OpenEphys).
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
        error('caraslab_channelmap_NNoptrodeLin4:notImplemented', ...
            'This probe type has not been set up yet for the TDT system')
    case 'intan'
        % From top (closest to optical fiber) to bottom
        firstch = 2;
        secondch = 1;
        thirdch = 3;
        fourthch = 4;
    otherwise
        error('caraslab_channelmap_NNoptrodeLin4:badFormat', ...
            'Unrecognized recording_format: %s', recording_format)
end

% This will be used below to set kcoords appropriately
kcoords_map = {firstch, secondch, thirdch, fourthch};

%-----------------------------------------------------------------------
%Define the x coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
xcoords_map = {0; 0; 0; 0};

%-----------------------------------------------------------------------
%Define the y coordinates for each channel group (in relative microns)
%-----------------------------------------------------------------------
ycoords_map = {250; 200; 150; 100};

end
