function [R,L] = endpoint(D,SR)
[dt,srt]=audioread('audio2/BK.wav');
fs=44100;
THRESHOLD=0.3;
%y=(y(:,1)+y(:,2))/2;
t = 0:1/fs:(length(dt) - 1)/fs;
%endpointdetection
samplePerFrame=floor(fs/100);
bgSampleCount=floor(fs/5); %according to formula, 1600 sample needed for 8 khz

%----------
%calculation of mean and std
bgSample=[];
for i=1:1:bgSampleCount
    bgSample=[bgSample dt(i)];
end
meanVal=mean(bgSample);
sDev=std(bgSample);
%----------
%identify voiced or not for each value
for i=1:1:length(dt)
   if(abs(dt(i)-meanVal)/sDev > THRESHOLD)
       voiced(i)=1;
   else
       voiced(i)=0;
   end
end


% identify voiced or not for each frame
%discard insufficient samples of last frame

usefulSamples=length(dt)-mod(length(dt),samplePerFrame);
frameCount=usefulSamples/samplePerFrame;
voicedFrameCount=0;
for i=1:1:frameCount
   cVoiced=0;
   cUnVoiced=0;
   for j=i*samplePerFrame-samplePerFrame+1:1:(i*samplePerFrame)
       if(voiced(j)==1)
           cVoiced=(cVoiced+1);
       else
           cUnVoiced=cUnVoiced+1;
       end
   end
   %mark frame for voiced/unvoiced
   if(cVoiced>cUnVoiced)
       voicedFrameCount=voicedFrameCount+1;
       voicedUnvoiced(i)=1;
   else
       voicedUnvoiced(i)=0;
   end
end

y=[];

%-----
for i=1:1:frameCount
    if(voicedUnvoiced(i)==1)
    for j=i*samplePerFrame-samplePerFrame+1:1:(i*samplePerFrame)
            y= [y dt(j)];
        end
    end
end

%---display plot and play both sounds
figure,plot(t,dt), axis([0, (length(dt) - 1)/fs -0.1 0.1]);
t1 = 0:1/fs:(length(y) - 1)/fs;
figure,plot(t1,y),axis([0, (length(y) - 1)/fs -0.1 0.1]);
end