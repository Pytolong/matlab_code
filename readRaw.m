function B = readRaw(fileName, nx, ny, nz, dataType)
% filename - path to .raw file
% nx, ny, nz - dimensions of array
% dataType - scalar data type in .raw file 

 % open binary file 
file = fopen(fileName);
 % read file into vector
A = fread(file,nx*ny*nz,dataType);
 % reshape vector into array
B = reshape(A,nx,ny,nz);
end