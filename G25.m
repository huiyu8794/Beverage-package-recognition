% change your function name to your group number
function G25(selpath,mode)

    %load your trained neural network model
    if(mode == 1)
        pretrained = load('net.mat');
        net = pretrained.net;
    elseif(mode == 2)
        pretrained = load('net_yu.mat');
        detector = pretrained.detector; 
    elseif(mode == 3)
        pretrained = load('net3.mat');
        detector = pretrained.detector; 
    end
    
    %get all jpg images in selpath
    imageList = dir( strcat(selpath,"/*.jpg") );
    
    % change your group name
    groupName="G25";
    
    % output file name
    outfile = strcat(groupName,"_mode",num2str(mode),".txt");
%     ,"_",selpath
    
    fid=fopen(outfile,'w');
    for i = 1:length(imageList)
        filename = fullfile(imageList(i).folder, imageList(i).name );
        I = imread( filename );
        
        if(mode == 2)
            
            I = imresize(I,227/224);
        end
        
        % if you only do classfication on Single Database , use classfy
        % function
        if(mode == 1)
            imds = imageDatastore(filename);
            inputSize = net.Layers(1).InputSize;
            augimdsValidation = augmentedImageDatastore(inputSize(1:2),imds);
            [YPred,scores] = classify(net,augimdsValidation);
            D = cellstr(YPred);
            D = string(D);
            
            fprintf( fid,"%s ",  imageList(i).name );
            
            fprintf( fid,"%s ", D );
            
            fprintf( fid,"\n" );
        else
        
            [bboxes, scores, labels] = detect(detector, I);
%             [selectedBboxes,selectedScores,selectedLabels,index] = selectStrongestBboxMulticlass(bboxes,scores,labels, 'OverlapThreshold' , 0.1 )
            % print your pridict labels to file.
            fprintf( fid,"%s ",  imageList(i).name );
            
            if(~isempty(labels))
                D = cellstr(labels);
                G = string(D);
                N = length(G);
                Z = G(1);
                if N >= 2
                    for i=2:N
                        Z = strcat(Z , " ");
                        Z = strcat(Z , G(i));
                    end
                end

                fprintf( fid,"%s ",Z );

            end
            fprintf( fid,"\n" ); 
        end
% % %         % print your pridict labels to file.
% % %         fprintf( fid,"%s ",  imageList(i).name );
% % %         for j = 1:length(selectedLabels)
% % %             fprintf( fid,"%s ",selectedLabels(j) );
% % %         end
% % %         fprintf( fid,"\n" );
    end
    fclose(fid);
    
end