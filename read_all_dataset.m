function trainTable = read_all_dataset(Listfilename)
%  read_all_dataset Summary of this function goes here
%   Detailed explanation goes here
    function data = parseLabel(filename)
        fid = fopen(filename);
        data = textscan(fid,"%f%f%f%f%f%f%f%f%s",'delimiter',',');
        fclose(fid);
    end
    fid = fopen(Listfilename);
    ListArray = textscan(fid,'%s%s','delimiter',' ');
    fclose(fid);
    [imageFilename , labelFilename] = ListArray{:};
    fds = fileDatastore(labelFilename,'ReadFcn',@parseLabel);
    numObservations = numel(fds.Files);
    for i = 1:numObservations
        [data , info ]= read(fds); %%data�����e info�����|
        bbox = horzcat( data{1:8} );%�N�C�Ӥp���X���@�Ӥj�x�}
        label = horzcat( data{9} );%���olabel
        bboxes{1,i} = bbox;
        labels{1,i} = label;
        
        % change to rantangle label
        bbox =bboxes{1,i};
        x = bbox(:,1:2:end);%���otxt����x�y��
        y = bbox(:,2:2:end);%���otxt����y�y��
        xMin = min(x,[],2);%�bx����̤p��
        xMax = max(x,[],2);%�bx����̤j��
        yMin = min(y,[],2);%�by����̤p��
        yMax = max(y,[],2);%�by����̤j��
        bboxes{1,i} = [xMin,yMin,xMax-xMin,yMax-yMin];%�s���W���I �P���e
        
        %�y�Ь� ���U ���W �k�W �k�U
    end
    BBoxes = bboxes;
    Labels = labels;
    NumClasses = 105;
    
    for i=1:NumClasses
        class{1,i}= strcat( 'B' , num2str(i) );%��B1~B105�o�X��
    end
    imageTable = table(imageFilename);%�N�Ҧ��Ϥ�(���|)�s��table
    labelsTable  = cell2table(cell(numObservations,NumClasses), 'VariableNames', class);
%     Labels{1,1}{2}
    for i = 1:numObservations
        for j = 1:size(Labels{1,i})%�d�ݬO�X���X
            tidx = find(string(labelsTable.Properties.VariableNames) == Labels{1,i}{j} );
            %tidx���d�ݬ�B�X
            labelsTable{ i , tidx } = mat2cell(BBoxes{1,i}(j,:),1);
        end
    end
    trainTable = [imageTable labelsTable];%�X��
    
    for i=1:2462
        
        disp(BBoxes{1,i}(1,3:4));
    end
end


