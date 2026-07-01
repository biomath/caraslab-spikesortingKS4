function caraslab_createChannelMap(savedir, probetype, recording_format)
%caraslab_createChannelMap(savedir,probetype,recording_format)
%
%Create a channel map file for a specific probe type
%
% Input variables:
%   savedir:    directory to save channelmap file (-mat)
%
%   probetype:  specifies the probe style used for recordings
%   Only the following have been set up:
%               'NNBuz5x1264':      Neuronexus Buzsaki 5x12 H64LP
%               'NN4x16Poly64':     Neuronexus A4x16 Poly2 H64LP (only for Synapse)
%               'NNA4x16Lin64':     Neuronexus A4x16 Poly2 Linear H64LP
%               'NNA2x32':          Neuronexus A2x32-5mm-25-200-177 (only for Synapse)
%               'NNoptrodeLin4':    Neuronexus Qtrode-Linear (only for Intan+OpenEphys)
%               'NNA1x16':          Neuronexus A1x16-Linear (only for Intan+OpenEphys)
%               'NNBuz4x8L':        Neuronexus X3-H32-Buzsaki32/L (only for Intan+OpenEphys)
%
%   recording_format:  'synapse' or 'intan'
%
% Each probe's channel/x/y coordinate maps are defined in a dedicated
% caraslab_channelmap_<probetype>.m file. This master file just dispatches
% to the right one, builds the final chanMap/kcoords/xcoords/ycoords
% vectors, and saves them.
%
% Kilosort2 note: kcoords is used to forcefully restrict templates to channels in the same
% channel group. An option can be set in the master_file to allow a fraction
% of all templates to span more channel groups, so that they can capture shared
% noise across all channels. This option is ops.criterionNoiseChannels = 0.2;
% If this number is less than 1, it will be treated as a fraction of the total number of clusters
% If this number is larger than 1, it will be treated as the "effective
% number" of channel groups at which to set the threshold. So if a template
% occupies more than this many channel groups, it will not be restricted to
% a single channel group.

% Dispatch to the probe-specific map definition
switch probetype
    case 'NNBuz5x1264'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNBuz5x1264(recording_format);
    case 'NN4x16Poly64'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NN4x16Poly64(recording_format);
    case 'NNA4x16Lin64'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNA4x16Lin64(recording_format);
    case 'NNA2x32'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNA2x32(recording_format);
    case 'NNBuz4x8L'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNBuz4x8L(recording_format);
    case 'NNoptrodeLin4'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNoptrodeLin4(recording_format);
    case 'NNoptrodeTet4'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNoptrodeTet4(recording_format);
    case 'NNA1x16'
        [Nchannels, kcoords_map, xcoords_map, ycoords_map] = ...
            caraslab_channelmap_NNA1x16(recording_format);
    otherwise
        fprintf('\nProbe dimensions not specified!\nAdd a caraslab_channelmap_%s.m file to add dimensions before map can be generated.\n', probetype)
        return
end

%Create the channel map (and a version that's indexed starting at zero)
chanMap = 1:Nchannels;
chanMap0ind = chanMap - 1;

%-----------------------------------------------------------------------
%Define the k coordinates for each channel group
%-----------------------------------------------------------------------
%The k coordinates indicate the group that each channel belongs to. Nearby
%sites on a single shank might pickup activity from the same neuron, for
%instance, and thus belong to the same group, but sites that are spaced far
%apart, or on different shanks, could not possibly pick up the same unit,
%and thus should be identified as being members of different groups.
%Specifying the groups will help Kilosort's algorithm discard noisy
%templates that are shared across groups.
%
% Channels need to be mapped according to the .dat channel stream which is 1:Nchan
kcoords =  ones(Nchannels, 1);  %  Placeholders
xcoords =  ones(Nchannels, 1);
ycoords =  ones(Nchannels, 1);
for x=1:length(kcoords_map)  % loop through shanks
    kcoords(kcoords_map{x}) = x;  % Change kcoords to shank index
    xcoords(kcoords_map{x}) = xcoords_map{x};  % Map xcoords
    ycoords(kcoords_map{x}) = ycoords_map{x};  % Map ycoords
end

% Identify dead (or disconnected) channels
connected = true(Nchannels, 1); % a 'connected' channel is one that is active (not dead)

%% Save
filename = fullfile(savedir,[probetype, '_', recording_format, '.mat']);
save(filename,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind')
fprintf('Saved channel map file: %s \n',filename);

end
