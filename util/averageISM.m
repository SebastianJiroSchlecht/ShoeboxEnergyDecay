function h = averageISM(num,c, fs, L, beta, limitsTime)

for it = 1:num
    rec = rand(1,3) .* L;
    src = rand(1,3) .* L;
    switch 'Politis'
        case 'Politis'
            [abs_echograms, rec_echograms, echograms] = compute_echograms_mics(L, src, rec, 1-beta.^2, limitsTime);
            h_temp = render_mic_rirs(abs_echograms, [], fs);
            h(:,it) = h_temp(1:limitsTime*fs,:);
        case 'Habets'
            mtype = 'omnidirectional';  % Type of microphone
            order = -1;                 % -1 equals maximum reflection order!
            dim = 3;                    % Room dimension
            orientation = 0;            % Microphone orientation (rad)
            hp_filter = 0;              % Enable high-pass filter
            h(:,it) = rir_generator(c, fs, rec, src, L, beta, limitsTime*fs, mtype, order, dim, orientation, hp_filter).';
    end
end

h = sum(h,2) / sqrt(num);
h = applyPressureSource(h);

