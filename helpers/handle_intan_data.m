function handle_intan_data(recnode_path, savedir_path, data_filename, ...
    data_channel_idx, adc_channel_idx, info_only)
    % Data channels have the naming convention *CHXX.continuous
    % Read recording info to get channel order; ADC channels will also
    % be in the mix; Channels should come out in order

    batch_size = 1800000; % Lower this number if running out of memory

    try
        data_channels = {};
        for ch = data_channel_idx-1
            % Construct file names (try lowercase and uppercase)
            cur_ch = fullfile(recnode_path, sprintf('amp-A-%03d.dat', ch));            
            % Determine which file exists
            if exist(cur_ch,'file')
                data_channels{end+1} = cur_ch;
            else
                error('Cannot find amplifier file for channel %d in folder %s', ch, recnode_path);
            end
        end
    end

    % For file naming purposes
    [~, cur_path] = fileparts(savedir_path);

    %% Read data channels and add to a .dat file
    if ~info_only
        fprintf('Processing data channels: %s\n', cur_path)
        % load one channel just to gauge data size
        fid = fopen(data_channels{1},'r');
        temp_ch = fread(fid, Inf, '*int16');  % read as column vector
        fclose(fid);
        data_size = length(temp_ch);
        Nbatch = ceil(data_size / batch_size); % number of data batches

        batch_counter = 1;
        fprintf('\tProcessing %d batches.......\n', Nbatch)
        lineLength_toUpdate = 0;
        [fid_data, msg] = fopen(data_filename,'w');
        for ibatch = 1:Nbatch  % Couldn't get the batch stuff to work properly yet,
            rawsig = zeros(length(data_channels), batch_size, 'int16');  % preallocate
            for ch_idx=1:length(data_channels)
                fid = fopen(data_channels{ch_idx}, 'r');

                fseek_offset = 2*(batch_size*(ibatch-1));  % in bytes
                fseek(fid, fseek_offset, 'bof'); % fseek to batch start in raw file
                 
                cur_ch_data = fread(fid, batch_size, '*int16');  
                fclose(fid);

                rawsig(ch_idx, 1:length(cur_ch_data)) = cur_ch_data';

                nsampcurr = length(cur_ch_data); % how many time samples the current batch has
                
                if nsampcurr<batch_size
                    % trim the trailing zeros from rawsig
                    rawsig = rawsig(:, 1:length(cur_ch_data));
                end
            end

            fwrite(fid_data, rawsig, 'int16');
           
            % Update last line in console as a poor-man's progress bar
            fprintf(repmat('\b',1,lineLength_toUpdate));
            lineLength_toUpdate = fprintf('\tCompleted %d out %d of batches.......\n', batch_counter, Nbatch);
            batch_counter = batch_counter + 1;
        end

        fclose(fid_data);
    
        %% Read ADC channels and add to a .dat file
        % if ~isempty(adc_channels)
        %     % TODO
        % end
    end
    
    %% Read DAC channels; Bundle in a .info file and output as CSV
    % unpack them in the behavior pipeline; this struct is meant to
    % look somewhat similar to the TDT epData that comes out of Synapse

    % For Rig2 with ePsych:
    % 0: DAC1 = sound on/off
    % 1: DAC2 = spout on/off
    % 2: DAC3 = trial start/end
    % 3: DAC4 = shock
    fprintf('Reading Events channels:\n')
    events_filename = fullfile(savedir_path, [cur_path '.info']);
    
    % Convoluted way to get the sampling rate
    info_file = fullfile(recnode_path, 'info.rhd');
    fid = fopen(info_file, 'r');
    sampling_rate = fread(fid, 3, 'single');  % Provisional code: Ensure this is always correct
    sampling_rate = sampling_rate(3);
    fprintf('\tFetching sampling rate from info.rhd. Ensure this number is correct: %d\n', sampling_rate)
    fclose(fid);

    % Add some recording params and events to epData (Synapse data format)
    epData.streams.RSn1.fs = sampling_rate;
    epData.streams.RSn1.channels = 1:length(data_channels);
    
    % Grab events files and convert them to common format
    event_files_dir = dir(fullfile(recnode_path, '*board-DIGITAL-IN-*dat'));
    event_files_names = {event_files_dir.name};
    dac_filematch = regexp(event_files_names, '\d{2}\.dat', 'match');

    events.channel = [];
    events.state = [];
    events.sampleNumber = [];
    for dac_ch=1:length(event_files_dir)
        ch_idx = find(contains(event_files_names, dac_filematch{dac_ch}));
        fid = fopen(fullfile(event_files_dir(ch_idx).folder, event_files_dir(ch_idx).name),'r');
        ch_states = fread(fid, Inf, '*int16'); 
        fclose(fid);
        
        % Detect TTL switch indeces
        ch_number = dac_filematch{dac_ch}{1};
        ch_number = str2num(ch_number(1:2));

        ch_states = single(ch_states);
        ch_switches = find(ischange(ch_states)); % find samples where TTL changes state   
        
        events.channel = [events.channel; repmat(ch_number, length(ch_switches), 1)];
        events.state = [events.state; ch_states(ch_switches)];
        events.sampleNumber  = [events.sampleNumber; ch_switches];
    end

    epData.event_ids = events.channel; 
    epData.event_states = events.state;

    epData.timestamps = double(events.sampleNumber)/sampling_rate;
    epData.info.blockname = cur_path;

    % Grab date and timestamp from folder name (no idea where to find it
    % elsewhere)
    block_date_timestamp = split(recnode_path, filesep);
    block_date_timestamp = split(block_date_timestamp{end}, '_');
    block_date_timestamp = strjoin(block_date_timestamp(end-1:end), '_');
    block_date_timestamp = datevec(block_date_timestamp, 'yymmdd_HHMMSS');
    epData.info.StartTime = block_date_timestamp;  % TDT-like

    save(events_filename, 'epData','-v7.3');

    % Output each channel with events as separate csv with onset,
    % offset and duration
    unique_dacs = unique(epData.event_ids);
    for cur_event_id_idx=1:length(unique_dacs)
        cur_event_id = unique_dacs(cur_event_id_idx);
        cur_event_mask = epData.event_ids == cur_event_id;
        cur_event_states = epData.event_states(cur_event_mask);            
        cur_timestamps = epData.timestamps(cur_event_mask);

        cur_onsets = cur_timestamps(cur_event_states == 1);
        cur_offsets = cur_timestamps(cur_event_states == 0);

        % Handle DAC exceptions here
        % Skip DAC if either onset or offset are completely absent
        if isempty(cur_onsets) || isempty(cur_offsets)
            continue
        end

        % Remove first offset if lower than first onset 
        if cur_offsets(1) < cur_onsets(1)
            cur_offsets = cur_offsets(2:end);
        end

        % Remove last onset if length mismatch
        if length(cur_onsets) ~= length(cur_offsets)
            cur_onsets = cur_onsets(1:end-1);
        end

        % Calulate durations
        cur_durations = cur_offsets - cur_onsets;

        % Convert to table and output csv

        fileID = fopen(fullfile(savedir_path, 'CSV files', ...
            [cur_path '_DAC' int2str(cur_event_id) '.csv']), 'w');

        header = {'Onset', 'Offset', 'Duration'};
        fprintf(fileID,'%s,%s,%s\n', header{:});
        nrows = length(cur_onsets);
        for idx = 1:nrows
            output_cell = {cur_onsets(idx), cur_offsets(idx), cur_durations(idx)};

            fprintf(fileID,'%f,%f,%f\n', output_cell{:});
        end
        fclose(fileID);

    end
end
