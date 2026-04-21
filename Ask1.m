imag=imread('small_lena_grayscale.png');%Diavazw mia Gkriza eikona
imag=double(imag)/255;%Aparaithto gia euros timhs 0 ews 1
imag_color=imread('small_lena_color.png');%Grayscale eikona me xrwmata
imag_color=double(imag_color)/255;%kasting gia na parei euros timhs 0 ews 1

A = [0.299 0.587 0.114;-0.1687 -0.3313 0.5;0.5 -0.4187 -0.08131];%Pinakas 3x3 gia metatroph se YUV
[num_of_rows num_of_columns num_of_channels]=size(imag);%Gia na parw ta antistoixa sizes ths eikonas

yuv_imag=zeros(num_of_rows,num_of_columns,3);%Arxikopoihsh yuv eikonas sto 0(8a exei 3 kanalia)


new_U=zeros(num_of_rows,num_of_columns,1);%Telikos pinakas U
new_V=zeros(num_of_rows,num_of_columns,1);%Telikos pinakas V

arr1=zeros(num_of_rows,num_of_columns);%Periexei 8etikous ari8mous mege8os oso h eikona input
arr1_counter=0;

%Pinakes orismata pinaka sparse(3pletes)
arr_i=[];%Apo8hkeuw Grammes Gia ka8e pixel gia na ftiaxw pinaka A(Sparse)
arr_j=[];%Apo8hkeuw sthles Gia ka8e pixelgia na ftiaxw Pinaka A(sparse)
arr_v=[];%Apo8hkeuw times Gia ka8e pixel gia na ftiaxw pinaka A(sparse)


%Ta arxikopoiw sto 0 epeidh 8elw ta xrwmata na einai idia(1 Sthlh) mege8os prokuptei apo ton pol/smo pinakwn sto grammiko susthma
U_B=zeros(num_of_rows*num_of_columns,1);%Pinakas B gia to kanali U(Tou grammikou syst)
V_B=zeros(num_of_rows*num_of_columns,1);%Pinakas B gia to kanali V(Tou grammikou syst)

%Edw arxikopoiw pinaka arr1 gia metafora syntetagmenwn se ka8e grammh tou pinaka A
for j=1:num_of_columns
    for i=1:num_of_rows
        
        arr1(i,j)=arr1_counter+1;
        arr1_counter=arr1_counter+1;
    end
end


for i=1:num_of_rows
    for j=1:num_of_columns
        %Gia na parw ka8e pixel ths YUV eikonas
        
        yuv_imag(i,j,:)=A*reshape(imag(i,j,:),[3,1]);
    end
end

for i=1:num_of_rows
    for j=1:num_of_columns
        
        
        yuv_imag_color(i,j,:)=A*reshape(imag_color(i,j,:),[3,1]);
    end
end
%Emfanish Yuv eikonas
%figure;
%imshow(uint8(yuv_imag));

%Emfanish yuv eikonas me xrwmata apo user
%figure;
%imshow(uint8(imag));

%----------------------------------------------------------------------------
%Diatrexw oloklhrh thn eikona ws pros ta pixel



%Gia na parw ka8e kentrarismeno pixel
for i=1:num_of_rows
    for j=1:num_of_columns
        %Elegxos an xrwmata diapernoun to trexwn kentriko pixel
        if abs(yuv_imag(i,j,1) - yuv_imag_color(i,j,1))^2 > 1e-3 && abs(yuv_imag(i,j,2) - yuv_imag_color(i,j,2))^2 > 1e-3 && abs(yuv_imag(i,j,3) - yuv_imag_color(i,j,3))^2 > 1e-3
            row_A=arr1(i,j);
            arr_i=[arr_i row_A];
            arr_j=[arr_j row_A];
            arr_v=[arr_v 1];
            
            
            U_B(row_A,1)=yuv_imag_color(i,j,2);
            V_B(row_A,1)=yuv_imag_color(i,j,3);

        else
            %An exw idies times kanaliwn (Xrwma) shmainei oti sto trexwn pixel den exei allaxei kati den exw dld xrwmatikh grammh sthn eikona Epomenws prepei na ereunhsw ti ginetai sta geitonika pixels
            
            %Kentrarismeno pixel idia grammh kai sthlh ston Pinaka A panta(Kuria Diagwnios tou Sparse)
            row_A=arr1(i,j);%Grammh kentrarismenou pixel ston pinaka A(Sparse) Menei sta8erh otan upologizw geitonika pixel ka8e grammhs ston pinaka A
            arr_i=[arr_i row_A];
            arr_j=[arr_j row_A];
            arr_v=[arr_v 1];%Kentriko pixel exei panta timh 1 se ka8e grammh tou A

            %An den valw auta ta if's 8a exw 8ema me to indexing ths eikonas stis 1es kai teleutaies grammes kai sthles sxetika me thn geitonia 3x3
            
            

            %Gia thn 1h grammh
            if i-1>1
                first_temp_i=i-1;
            else
                first_temp_i=1;
            end
            
            %Gia thn 1h sthlh
            if j-1>1
                first_temp_j=j-1;
            else
                first_temp_j=1;
            end
    
            %Gia thn teleutaia grammh
            if i+1>num_of_rows%512
                last_temp_i=num_of_rows;
                
            else
                last_temp_i=i+1;
            end
            
            %Gia thn teleutaia sthlh
            if j+1>num_of_columns%512
                last_temp_j=num_of_columns;
                
            else
                last_temp_j=j+1;
            end
            
    
            central_pixel=yuv_imag(i,j,:);%Kentrarw ka8e pixel ws pros thn geitonia 3x3
            
            neigh_avg=0;%Mo ka8e geitonias
            neigh_std=0;%std ka8e geitonias
            sum_wrs=0;%sum twn wrs gia ka8e geitonia
            luminance_lst=[];%Arxikopoihsh kenhs listas periexei intensities ka8e geitonias 3x3 8a ananewnetai gia ka8e geitonia
            
            for x=first_temp_i:last_temp_i
                
                  for y=first_temp_j:last_temp_j
                    %Diatrexw Geitonies 3x3 ws pros to ka8e kentriko pixel
                    
                    if(x==i && y==j)%Agnow to luminance tou kentrikou pixel Den to bazw sthn lista
                        continue
                    else
                        luminance_lst=[luminance_lst yuv_imag(x,y,1)];%Apo8hkeuw to luminance ka8e pixel ths geitonias ths grayscale eikonas
                    end
                    
                end
                
            end
            
            neigh_avg=mean(luminance_lst);%Edw upologizw ton mo ka8e geitonias
            neigh_std=std(luminance_lst);%Edw upologizw to std ka8e geitonias
            %8a ta xrhsim sto wrs se mia nea emfoleumenh for gia na upologisw to wrs
      
            
            for k=first_temp_i:last_temp_i%Edw upologizw to a8roisma twn wrs ths ka8e geitonias(Diatrexei geitonia gurw apo kentriko pixel)
                for l=first_temp_j:last_temp_j
                    if(k==i && l==j)%Agnow to wrs tou kentrikou pixel ths geitonias
                        continue
                    else
                        wrs=exp(- (( central_pixel(:,:,1) - yuv_imag(k,l,1) )^2)/(2*neigh_std^2));
                        sum_wrs=sum_wrs+wrs;%Pairnw to a8roisma twn wrs gia ka8e geitonia
                        
                    end
                end
            end
            %Exodos molis upologisw to sum_wrs ths trexousas geitonias
            
            
           %Edw briskw kanonikopoihmeno wrs(teliko)
           for k=first_temp_i:last_temp_i %Efoson brhka to a8roisma twn wrs ths trexousas geitonias edw diairw to ka8e wrs me to a8roisma twn timwn wrs ths geitonias tou
                for l=first_temp_j:last_temp_j
                    if(k==i && l==j)%Agnow to wrs tou kentrikou pixel ths geitonias
                        continue
                    else
                        wrs=exp(- ( central_pixel(:,:,1) - yuv_imag(k,l,1) )^2/(2*neigh_std^2));%A8roizw to std me kati apeiroelaxisto wste na mhn exw 0 ston paranomasth
                        new_wrs=wrs/sum_wrs;%Teliko wrs(Afotou diaire8ei me to sum_wrs)
                        col_A=arr1(k,l);%sthlh allazei sta geitonika pixel tou kentrikou pixel ka8e grammhs tou pinaka A
                        arr_i=[arr_i row_A];%Menei sta8erh h grammh oson afora ta geitonika pixel stis grammes tou pinaka A
                        arr_j=[arr_j col_A];%Sthlh allazei logw ths geitonias(Geitonikwn pixel) stis grammes tou pinaka A
                        arr_v=[arr_v -new_wrs];%Geitonika pixel ston sparse pinaka A exoun timh -wrs me bash thn sxesh (1)(-sum(wrs))
                    end
                end
           end
    
           
       
        
        
      
        
        

            

            
        
        end

    end
end

A_spars=sparse(arr_i,arr_j,arr_v,num_of_rows*num_of_columns,num_of_columns*num_of_rows);
%Pinakes sthles(anaferontai ston Pinaka x sto systhma)
U_recon=A_spars\U_B;
V_recon=A_spars\V_B;

%Metatrepw pinakes sthles U_recon,V_recon se eikona 2D dimension
counter=0;
for j=1:num_of_columns
    for i=1:num_of_rows
    counter=counter+1;
    new_U(i,j)=U_recon(counter,1);
    new_V(i,j)=V_recon(counter,1);
  end
end
    
imag_color_recon=cat(3,yuv_imag(:,:,1),new_U,new_V);%Enwnei to U kanali to Y kanali kai V pou exw upologisei sthn telikh eikona

for j=1:num_of_columns
    for i=1:num_of_rows
        
        imag_color_recon(i,j,:)=inv(A)*reshape(imag_color_recon(i,j,:),[3,1]);

    end
end
figure;
imshow(imag_color_recon);

