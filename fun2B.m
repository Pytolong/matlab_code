function [Z] = fun2B(Z,Y,nx,ny,nz)
%% Form matrix Z

    Zz(:,:,:)=Z(:,:,:);
%      Z(:,:,nz)=((Y(:,:,nz-1)==1) & (Y (:,:,nz)==1)); 
     Z(:,:,nz)=((Z(:,:,nz)==1)   | (Zz(:,:,nz)==1));

%% Main Loop

for i=nz-1:-1:2 
    
    A=zeros(nx,ny); 
    
        
         Z(:,:,i-1)=((Z(:,:,i)==1)   & (Y(:,:,i-1)==1));  
         Z(:,:,i-1)=((Z(:,:,i-1)==1) | (Zz(:,:,i-1)==1));                                                                           
         A(:,:)=Z(:,:,i-1);          

    while true

        [rows,cols] = find(A==1);
        if isempty(rows)
            break
        end
        
        for k=1:length(rows)
                                 
              Z(rows(k),cols(k),i-1)=1;
             
                if (cols(k)~=1) &&  A(rows(k),cols(k)-1)~=2 && (Y(rows(k),cols(k)-1,i-1)==1) 
                    Z(rows(k),cols(k)-1,i-1)=1;
                    A(rows(k),cols(k)-1)=1;
                end   

                if (rows(k)~=nx) && A(rows(k)+1,cols(k))~=2 &&  (Y(rows(k)+1,cols(k),i-1)==1) 
                    Z(rows(k)+1,cols(k),i-1)=1;
                    A(rows(k)+1,cols(k))  =1;
                end              
                
                if (rows(k)~=1) && A(rows(k)-1,cols(k))~=2 &&  (Y(rows(k)-1,cols(k),i-1)==1) 
                    Z(rows(k)-1,cols(k),i-1)=1;
                    A(rows(k)-1,cols(k))=1; 
                end
                
                if (cols(k)~=ny) && A(rows(k),cols(k))~=2 && (Y(rows(k),cols(k)+1,i-1)==1) 
                    Z(rows(k),cols(k)+1,i-1)=1;
                    A(rows(k),cols(k)+1)=1;
                end
                
                A(rows(k),cols(k))=2; 
          end
          
     end
 

end



end

