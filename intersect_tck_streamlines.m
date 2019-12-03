


main_path = '/Volumes/Moncho_SSD_II/Data/Defining White Matter/results_2019_11_21_QB_0p90_0p005';
subject = '/s1';
prefix_name_files = '/AF_L_fixEnds_qb_clean_';

output_path = '/Volumes/Moncho_SSD_II/Data/Defining White Matter/results_2019_11_21_QB_0p90_0p005';
posfix_name = 'intersected'; % for output name = prefix_name_files + posfix_name



%%

S = dir([main_path subject prefix_name_files '*.tck']);

N = length(S);
if N <= 1
    fprintf('No files to process...\n')
    return;
end
Files = cell(N,1);

for i = 1:N
    Files{i} = [main_path subject '/' S(i).name];
end

% newStr = split(Files{1},'/');
% length(newStr)
% Output = [];
% for i = 2:length(newStr)-1
%     Output = [Output '/' newStr{i}];
% end

Output_name = [output_path subject prefix_name_files posfix_name '2.tck'];

mkdir([output_path subject]);

%%

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
write_mrtrix_tracks(TCK{2}, Output_name)






