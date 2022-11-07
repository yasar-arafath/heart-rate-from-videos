dataDir = 'C:\Users\Mukilan\Documents\Develop\Matlab\videos';
resultsDir = 'C:\Users\Mukilan\Documents\Develop\Matlab\results';
inFile = fullfile(dataDir,'face_edited.mp4');
vidFile = inFile;
vid = VideoReader(vidFile);
vid
vidHeight = vid.Height;
vidWidth = vid.Width;
nChannels = 3;
fr = vid.FrameRate;
len = vid.NumberOfFrames;
temp = struct('cdata', zeros(vidHeight, vidWidth, nChannels, 'uint8'), 'colormap', []);
T = 1/fr;
tlen = len/fr;
t1 = linspace(0, tlen, len);
f = -fr/2:fr/len:fr/2-fr/len;
mov(1:len) = struct('cdata', zeros(vidHeight, vidWidth, nChannels, 'uint8'), 'colormap', []);
for k = 1 : len
    mov(k).cdata = read(vid, k);
end
centerVerMin = ceil((vidHeight/5) + (vidHeight/5));
centerVerMax = ceil((vidHeight/5) + (vidHeight/5) + (vidHeight/5));
centerHorMin = ceil((vidWidth/5) + (vidWidth/5));
centerHorMax = ceil((vidWidth/5)  + (vidWidth/5) +  + (vidWidth/5));
sampleHor = centerHorMax - centerHorMin;
sampleVer = centerVerMax - centerVerMin;
sample = zeros(sampleVer, sampleHor, len);
t = zeros(len);
avg = zeros(len);
for k = 1 : len
    for j = centerHorMin : centerHorMax
        for i = centerVerMin : centerVerMax
            sampleHorIndex = j - centerHorMin + 1;
            sampleVerIndex = i - centerVerMin + 1;
            sample(sampleVerIndex, sampleHorIndex, k) = mov(k).cdata(i, j, 1);
        end
    end
    t(k) = k;   % value of k (frames) for graphing
    avg(k) = mean(mean(sample(:,:,k)));
end
Y = fftshift(fft(avg));
figure
subplot(2,1,1)
title('Intensity of Center Pixel vs Frame');xlabel('Frame');ylabel('Pixel intensity')
plot(t,avg)
subplot(2,1,2)
title('Magnitude of Frequency to find Heart Rate');xlabel('Frequency (Hz)');ylabel('Magnitude')
stem(f,1/len*abs(Y),'filled')
