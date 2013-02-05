function J = do_localmax(octave, thresh,smin)

%% file:       do_localmax.m
% author:      Noemie Phulpin
% description: returns the indexes of the local maximizers of the octave.
%%

[N,M,S]=size(octave); 
nb=1;
k=0.0002;
%for each point of this scale space
% we look for extrama bigger than thresh
J = [];
for s=2:S-1
    for j=20:M-20
        for i=20:N-20
            a=octave(i,j,s);
%             V = [ thresh octave(i-1,j-1,s-1) octave(i-1,j,s-1) octave(i-1,j+1,s-1) octave(i,j-1,s-1) octave(i,j+1,s-1) octave(i+1,j-1,s-1) octave(i+1,j,s-1) octave(i+1,j+1,s-1) octave(i-1,j-1,s) octave(i-1,j,s) octave(i-1,j+1,s) octave(i,j-1,s) octave(i,j+1,s) octave(i+1,j-1,s) octave(i+1,j,s) octave(i+1,j+1,s) octave(i-1,j-1,s+1) octave(i-1,j,s+1) octave(i-1,j+1,s+1) octave(i,j-1,s+1) octave(i,j+1,s+1) octave(i+1,j-1,s+1) octave(i+1,j,s+1) octave(i+1,j+1,s+1)];
%             maximum=max(V);
            
            if a>thresh+k ...
                    && a>octave(i-1,j-1,s-1)+k && a>octave(i-1,j,s-1)+k && a>octave(i-1,j+1,s-1)+k ...
                    && a>octave(i,j-1,s-1)+k && a>octave(i,j+1,s-1)+k && a>octave(i+1,j-1,s-1)+k ...
                    && a>octave(i+1,j,s-1)+k && a>octave(i+1,j+1,s-1)+k && a>octave(i-1,j-1,s)+k ...
                    && a>octave(i-1,j,s)+k && a>octave(i-1,j+1,s)+k && a>octave(i,j-1,s)+k ...
                    && a>octave(i,j+1,s)+k && a>octave(i+1,j-1,s)+k && a>octave(i+1,j,s)+k ...
                    && a>octave(i+1,j+1,s)+k && a>octave(i-1,j-1,s+1)+k && a>octave(i-1,j,s+1)+k ...
                    && a>octave(i-1,j+1,s+1)+k && a>octave(i,j-1,s+1)+k && a>octave(i,j+1,s+1)+k ...
                    && a>octave(i+1,j-1,s+1)+k && a>octave(i+1,j,s+1)+k && a>octave(i+1,j+1,s+1)+k
            %if (a-maximum>0.00004)
            %if (a-maximum>0.001)
                J(1,nb)=j-1;
                J(2,nb)=i-1;
                J(3,nb)=s+smin-1;
                nb=nb+1;
            end
        end
    end
end