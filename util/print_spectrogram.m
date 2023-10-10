function print_spectrogram(h,fs,name)

figure;

[S,F,T] = spectrogram(h, 2^11, 2^11 - 2^6, 2^11, fs,'yaxis');
surf(T,F,clip(mag2db(abs(S)),[-100 0]),'LineStyle','none');
view([0,90]);
set(gca,'YScale','log');
ylim([100 10000]);
xlim([min(T), max(T)]);
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');

clb = colorbar;
colormap(gca,gray)
% clb.Limits = [-140,-40];
clb.Label.String = 'Power (dB)';
clb.Label.Interpreter = 'latex';
clb.Label.FontSize = 10;
clb.TickLabelInterpreter = 'latex';

set(gcf,'Units', 'inches', 'Position', [0 0 3.5 1.5]);
exportgraphics(gcf,name,'Resolution',600)
