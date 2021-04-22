clc
clear

%% Images Measurements 
nx=250; ny=250; numberOfFiles=250;  
nz=numberOfFiles;

B = readRaw('./Microstructure.raw',nx, ny, nz,'int');  


%% Load Raw

% loaded images transform in matrix of values 0 or 1
% where: 0- phase under consideration;  1- other phases

    Y0=zeros(nx,ny,nz);  
    Y0(:) = B(:)==      0; %Change value to select the phase to be consideration!     
                           %for example: ==0 Black/Pore; ==128 Grey/YSZ; ==255 White/Ni;
                             
                             
    Y127=zeros(nx,ny,nz);  
    Y127(:) = B(:)==      127; %Change value to select the phase to be consideration!     
                               %for example: ==0 Black/Pore; ==128 Grey/YSZ; ==255 White/Ni;
                             
                             
    Y255=zeros(nx,ny,nz);  
    Y255(:) = B(:)==      255; %Change value to select the phase to be consideration!     
                               %for example: ==0 Black/Pore; ==128 Grey/YSZ; ==255 White/Ni;
    
                             

save Mic.mat