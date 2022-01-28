clc
clear
%-----Training---------------
tic
dirname = 'training';
dlist = dir (fullfile(dirname, '*.wav'));
tks=[];
for i = 1:length(dlist);
    tks{i} = fullfile(dirname,dlist(i).name);
end
% Initialize the hash table database array 
clear_hashtable
% Calculate the landmark hashes for each reference track and store
% it in the array (takes a few seconds per track).
add_tracks(tks);
wtime=toc;
msg1=sprintf('Time Taken to Train Databased is %f seconds\n', wtime); 
msgbox(msg1)
%--------------------------------------------------------------------------------
%---------Testing-------------
A=uigetfile();
folder = 'F:\WORK\master&degreefyp\dissertation 2\fingerprint\github\test\';
filename = fullfile(folder,A);
setappdata(0,'filename',filename);
%[dt,srt] = audioread(A);
[speech,srt] = audioread(filename); %choose command
[noise,fs] = audioread('ssn.wav'); % add noise
snr = 30;%snr value for noise
dt = addnoise( speech, noise, snr );
% -------------Add for real time------------------------------
% display('MULA BERCAKAP');       
% sig = audiorecorder(8000,16,1); 
% recordblocking(sig,2);           
% display('BERHENTI BERCAKAP');
% name1 = getaudiodata(sig);       
% audiowrite('real_time/command.wav',name1,8000);
% [dt,srt] = audioread('real_time/command.wav');
%---------------------------------------------------------
% Run the query
tic
R = match_query(dt,srt);
% R returns all the matches, sorted by match quality.  Each row
% describes a match with three numbers: the index of the item in
% the database that matches, the number of matching hash landmarks,
% and the time offset (in 32ms steps) between the beggining of the
% reference track and the beggining of the query audio.
R(1,:);
% 5 11 4 means tks{5} was matched with 11 matching landmarks, at a
% time offset of 4 frames (query starts ~ 0.13s after beginning of
% reference track).
%
% Plot the matches
%illustrate_match(dt,srt,tks);
%illstrate landmark fucntion
% Run the query
[R,Lm] = match_query(dt,srt);
% Lm returns the matching landmarks in the original track's time frame

% Recalculate the landmarks for the query
Lq = find_landmarks(dt,srt);
% Plot them
subplot(211)
show_landmarks(dt,srt,Lq);

% Recalculate landmarks for the match piece
tbase = 0.032;  % time base of analysis
matchtrk = R(1,1);
matchdt = R(1,3);
[d,sr] = audioread(tks{matchtrk});
Ld = find_landmarks(d,sr);
% Plot them, aligning time to the query
subplot(212)
show_landmarks(d,sr,Ld,matchdt*tbase + [0 length(dt)/srt]);
[p,name,e] = fileparts(tks{matchtrk});
name(find(name == '_')) = ' ';
title(['Match: ',name,' at ',num2str(matchdt*tbase),' sec']);
%title('Databased');
% Highlight the matching landmarks
show_landmarks([],sr,Lm,[],'o-g');
subplot(211)
show_landmarks([],sr,Lm-repmat([matchdt 0 0 0],size(Lm,1),1),[],'o-g');
title('Input Command')
pattern1 = "BK";
pattern2 = "TK";
pattern3 = "BL";
pattern4 = "TL";
pattern5 = "BT";
pattern6 = "S1";
pattern7 = "S2";
pattern8 = "S3";
pattern9 = "TT";
command1 = contains(name,pattern1);
command2 = contains(name,pattern2);
command3 = contains(name,pattern3);
command4 = contains(name,pattern4);
command5 = contains(name,pattern5);
command6 = contains(name,pattern6);
command7 = contains(name,pattern7);
command8 = contains(name,pattern8);
command9 = contains(name,pattern9);
%% raspberry pi
if command1 == 1  
    display('THE COMMAND GIVEN : BUKA KIPAS')
    %writeDigitalPin(mypi,17,1) 
elseif command2 == 1 
    display('THE COMMAND GIVEN : TUTUP KIPAS')
   % writeDigitalPin(mypi,17,0)
elseif command3 == 1 
    display('THE COMMAND GIVEN : BUKA LAMPU')
   % writeDigitalPin(mypi,27,1)
elseif command4 == 1 
    display('THE COMMAND GIVEN : TUTUP LAMPU')
   % writeDigitalPin(mypi,27,0)
elseif command5 == 1 
    display('THE COMMAND GIVEN : BUKA TV')
   % writeDigitalPin(mypi,22,1)
elseif command6 == 1 
    display('THE COMMAND GIVEN : SIARAN 1')
   % writeDigitalPin(mypi,22,1)
   % writeDigitalPin(mypi,23,0)
   % writeDigitalPin(mypi,24,0)
elseif command7 == 1 
    display('THE COMMAND GIVEN : SIARAN 2')
   % writeDigitalPin(mypi,23,1)
   % writeDigitalPin(mypi,22,0)
   % writeDigitalPin(mypi,24,0)
elseif command8 == 1 
    display('THE COMMAND GIVEN : SIARAN 3')
   % writeDigitalPin(mypi,24,1)
   % writeDigitalPin(mypi,23,0)
   % writeDigitalPin(mypi,22,0)
elseif command9 == 1 
    display('THE COMMAND GIVEN : TUTUP TV')
   % writeDigitalPin(mypi,22,0)
   % writeDigitalPin(mypi,23,0)
   % writeDigitalPin(mypi,24,0)
end
colormap(1-gray)
mtime=toc;
msg2=sprintf('Time Taken to Match Input Command and Databased is %f seconds \n', mtime); 
msgbox(msg2)
% This re-runs the match, then plots spectrograms of both query and
% the matching part of the reference, with the landmark pairs
% plotted on top in red, and the matching landmarks plotted in
% green.

