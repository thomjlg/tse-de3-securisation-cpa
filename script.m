%chargement des vecteurs Inputs, SubBytes et Traces
load('Inputs.mat');
load('SubBytes.mat')
load('traces1000x512.mat');

%creation d'un vecteur pour les 256 valeurs de sous-clef
subb_key = 0:255;

%creation d'une matrice de 1000 lignes et 256 colonnes avec des 0
ma_matrice = zeros(1000,256);

%AddRoundKey
for i=1:1000
    for j=1:256
        ma_matrice(i,j) = bitxor(Inputs1(i),subb_key(j));
    end
end

%SubBytes
for i=1:1000
    for j=1:256
        ma_matrice(i,j) = SubBytes(ma_matrice(i,j)+1);
    end
end
 
%poids de hamming
for i=1:1000
    for j=1:256
        nb_bits=0;
        for k=1:8
            b = bitget(ma_matrice(i,j), k);
            if b == 1
                nb_bits = nb_bits + 1;
            end
        
        end
        ma_matrice(i,j) = nb_bits;
    end
end

%Correlation
for i=1:256
    for j=1:512
       corr = corrcoef(ma_matrice(:,i), traces(:,j));
       value_correl(i, j) = abs(corr(1,2));
    end
    vect_final(i) = max(value_correl(i, :));
end

%clef
max(vect_final);
find(vect_final==max(vect_final));
%valeur max
disp(max(vect_final));
%sa position dans la matrice
disp(find(vect_final==max(vect_final)));
%donc -1 pour respecter 0-255
disp("clef");
disp(find(vect_final==max(vect_final)) -1);

%affichage des graphes
tiledlayout(2,1)

% 2D
nexttile
plot(vect_final);
colorbar

% 3D
nexttile
surf(value_correl);
colorbar


