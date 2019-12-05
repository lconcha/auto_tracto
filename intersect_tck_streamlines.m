
function intersect_tck_streamlines(tckOUT,varargin)



Output_name = tckOUT;


fprintf(1,' Finding the intersection of the following files:\n');
for t = 1 : length(varargin)
   thistck = varargin{t};
   fprintf(1,' %d : %s\n', t, thistck);
   Files{t} = thistck;
end



%%


N = length(Files);

eps = 1e-6;
TCK = cell(N,1);
M = zeros(N,1);
for i = 1:N
    TCK{i} = read_mrtrix_tracks(Files{i});
    M(i) = str2num(TCK{i}.count);
end


idx = zeros(M(1),1);
for i = 1:M(1)
    streamline = TCK{1}.data{i};
    count = 0;
    Npoinst = size(streamline,1);
    for j = 2:N
        for k = 1:M(j)
            band = 0;
            streamlineM = TCK{j}.data{k};
            if Npoinst ~= size(streamlineM,1)
                continue;
            end

            for ww = 1:Npoinst
                dist = sqrt(sum((streamline(ww,:) - streamlineM(ww,:)).^ 2));
                if dist > eps
                    break;
                end
                if Npoinst == ww
                    band = 1;
                end
            end

            if band == 1
                break;
            end
        end

        count = count + band;
    end

    if count == N - 1
        idx(i) = 1;
    end
end

%%

NN = sum(idx > 0);
TCK{2}.data = cell(1,sum(idx > 0));
contador = 1;
for i = 1:M(1)
    if (idx(i) > 0)
        TCK{2}.data{contador} = TCK{1}.data{i};
        contador = contador + 1;
    end
end
TCK{2}.count = num2str(NN);
fprintf(1,'  Writing file %s\n',Output_name)
write_mrtrix_tracks(TCK{2}, Output_name)
