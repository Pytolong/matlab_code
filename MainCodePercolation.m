clear

load Mic.mat

faza=255;        

if  faza==0
    Y=Y0;
elseif faza==127
    Y=Y127;
elseif faza==255
    Y=Y255;
end


%% Main Loop

% The code doesn't compare first and second images because percolated is
% cluster in contact with the external surface of the microstructure. 

% The code creates matrices that represent clusters beginning from the each
% external surface of the microstructure, so started from first and last
% images. After that compares both matrices to get a percolated cluster.

Zz=zeros(nx,ny,nz);
Z2=zeros(nx,ny,nz);
C = 1;
while sum(C)~=0
    [Z2]=funB(Z2,Y,nx,ny,nz);   
    [Z2]=fun2(Z2,Y,nx,ny,nz);
    
    C = Z2(:)-Zz(:);
    Zz(:)=Z2(:); 
    sum(C)
end



Zz=zeros(nx,ny,nz);
Z1=zeros(nx,ny,nz);
C = 1;

while sum(C)~=0
    [Z1]=fun2B(Z1,Y,nx,ny,nz);
    [Z1]=fun(Z1,Y,nx,ny,nz);
    C = Z1(:)-Zz(:);
    Zz(:)=Z1(:); 
    sum(C)
end



for i=1:1:nz
Z(:,:,i)=((Z1(:,:,i)==1) & (Z2(:,:,i)==1));   
end




%% Creation Images


for i=1:1:numberOfFiles

y{i}=Y(:,:,i)   ;
z{i}=Z(:,:,i)    ;

q{i}=zeros(nx,ny);


    if faza==0 
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   
        q{i}(z{i}==1) = 133;
        imwrite(uint8(q{i}),sprintf("./Percolation/Black%04d.png", i));
    end

    if faza==127 
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   
        q{i}(z{i}==1) = 133;
        imwrite(uint8(q{i}),sprintf("./Percolation/Grey%04d.png", i))
    end

    if faza==255
        q{i}=zeros(nx,ny);
        q{i}(y{i}==1)=255;   
        q{i}(z{i}==1) = 133;
        imwrite(uint8(q{i}),sprintf("./Percolation/White%04d.png", i));
    end



end



%% Calculation

per=0;
all=0;
for i=1:1:numberOfFiles
    
    for k=1:1:nx
    for w=1:1:ny

        if q{i}(w,k)==255
            per=per+1;
        end

        
    end
    end
end


c=sum(B(:) == 127);
d=sum(B(:) == 0);
e=sum(B(:) == 255);


Ni= e/(c+d+e) % percentage of nickel phase 
YSZ=c/(c+d+e) % percentage of YSZ phase 
Por=d/(c+d+e) % percentage of pore 



all=sum(Y(:) == 1);

% percentage of percolated phase 
if faza==255
    Nikiel_Perkolacja=(all-per)/all
elseif faza==0
    Por_Perkolacja=(all-per)/all
elseif faza==127
    YSZ_Perkolacja=(all-per)/all
end



