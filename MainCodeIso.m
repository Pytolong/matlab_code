clc
clear

load Mic.mat  


faza=0           % Select the phase that be under consideration 
                    % =0 Black/Pore; =128 Grey/YSZ; =255 White/Ni;

if  faza==0
    Y=Y0;
elseif faza==127
    Y=Y127;
elseif faza==255
    Y=Y255;
end



% Form matrix Z:

% Z - Matrix of values 0/1, marks non-isolated clusters beginning from the first image
% where  1- non-isolated phase;  0- other phases;

Z=zeros(nx,ny,nz);
Z(:,:,2)=((Y(:,:,1)==1) & (Y(:,:,2)==1)); % Non-isolated clusters between first and second images




%% Main Loop
% The code compares matrix 'Z' with the next image (matrix 'Y+1'). When in theese two
% images, woxels with the same coordinates are equal '1' in both arrays, code
% marks this woxel in next matrix 'Z' (Z+1) by '1'. In next step code checks
% if the cluster is growing: in the matrix 'Y+1' code checks cells in all
% directions if the cell is '1', the code includes it to matrix 'Z+1',
% In that case the process repeats for this cell.

    
% A - Array informs us about action that have been taken in woxels
    % 0 - don't consider this cell
    % 1 - include this cell to matrix 'Z'
    % 2 - check growth of this woxel in every direction.
            
% The code looks for value of '1' cells in array 'A' , and checks adjecent cells 
% in all directions, if they also equal '1' : 
% includes this adjecent cells to matrix 'Z+1', 
% changes values of adjecent cells for '1' or '0' in array A 
% changes value cell under consideration to '2'

for i=2:1:nz-1 
            
    A=zeros(nx,ny);  
        
        Z(:,:,i+1)=((Z(:,:,i)==1) & (Y(:,:,i+1)==1));  
        A(:,:)=Z(:,:,i+1);          
        
    while true                              
        [rows,cols] = find(A==1);      % Repeat procces until all cells are equal 2 or 0
        if isempty(rows)
            break
        end
        
        for k=1:length(rows)            
                                 
              Z(rows(k),cols(k),i+1)=1;
             
                if (cols(k)~=1) &&  A(rows(k),cols(k)-1)~=2 && (Y(rows(k),cols(k)-1,i+1)==1) 
                    Z(rows(k),cols(k)-1,i+1)=1;
                    A(rows(k),cols(k)-1)=1;
                end   

                if (rows(k)~=nx) && A(rows(k)+1,cols(k))~=2 &&  (Y(rows(k)+1,cols(k),i+1)==1) 
                    Z(rows(k)+1,cols(k),i+1)=1;
                    A(rows(k)+1,cols(k))  =1;
                end              
                
                if (rows(k)~=1) && A(rows(k)-1,cols(k))~=2 &&  (Y(rows(k)-1,cols(k),i+1)==1) 
                    Z(rows(k)-1,cols(k),i+1)=1;
                    A(rows(k)-1,cols(k))=1; 
                end
                
                if (cols(k)~=ny) && A(rows(k),cols(k)+1)~=2 && (Y(rows(k),cols(k)+1,i+1)==1) 
                    Z(rows(k),cols(k)+1,i+1)=1;
                    A(rows(k),cols(k)+1)=1;
                end
                
                A(rows(k),cols(k))=2; 
          end
          
     end
 

end

% Single initialization is not enough!
% Repeats the whole process taking into concideration the current matrix 'Z'
% beginning from the opposite side and repeating all actions as long as the
% matrix 'Z' changes.

Zz=zeros(nx,ny,nz);
C = Z(:)-Zz(:);

while sum(C)~=0
    C = Z(:)-Zz(:);
    Zz(:)=Z(:);  
sum(C)
    [Z]=fun2(Z,Y,nx,ny,nz);
    [Z]=fun(Z,Y,nx,ny,nz);
end
 
%% Creation of Images

% The code from the results creates matrices where marks by proper values 
% of isolated and other phase.

for i=1:1:nz

y{i}=Y(:,:,i)   ;
z{i}=Z(:,:,i)    ;

q{i}=zeros(nx,ny);


    if faza==0 
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   % isolated phase
        q{i}(z{i}==1) = 133; % other phase 
        imwrite(uint8(q{i}),sprintf("./Mic15/por/PorIso%04d.png", i)); % sprintf("path to save images", i)
    end

    if faza==127 
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   
        q{i}(z{i}==1) = 133;
        imwrite(ind2rgb(q{i},newmap),sprintf("./Mic0/Szary%04d.png", i))
    end

    if faza==255
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   
        q{i}(z{i}==1) = 133;
        imwrite(uint8(q{i}),sprintf("./MicPo12/Bialy%04d.png", i));
    end



end


%% Calculation 

iso=0;
all=0;
for i=2:1:numberOfFiles-1
    
    for k=1:1:nx
    for w=1:1:ny

        if q{i}(w,k)==255
            iso=iso+1;
        end
    end
    end
end


c=sum(B(:) == 127);
d=sum(B(:) == 0);
e=sum(B(:) == 255);

Ni= e/(c+d+e) % percentage of nickel phase 
YSZ=c/(c+d+e) % percentage of YSZ phase 
Por=d/(c+d+e) % percentage of pore phase


all=sum(Y(:) == 1);

% percentage of isolated phase 
if faza==255
    Nikiel_Perkolacja=(all-iso)/all
elseif faza==0
    Por_Perkolacja=(all-iso)/all
elseif faza==127
    YSZ_Perkolacja=(all-iso)/all
end


