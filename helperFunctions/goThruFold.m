classdef goThruFold
    %{
    Search and print any file inside given folder that matches provided regex.

    example
    -------
    % Search and print any file inside dataDir with the last 4 letters: '.mat'.
    dataDir = './some/data/directory';
    shoutMat = goThruFold(dataDir, [], '\.mat$'); % constructor
    shoutMat.main(); % run main

    %}
    
    properties
        inDir     % directory to search
        outDir    % directory to output, unused
        contentName
        filterStr % regex to filter file
        isDir
        dirName
    end % properties
    
    methods
        
        % constructor
        function obj = goThruFold(inDir, outDir, filterStr)
            obj.inDir     = inDir;
            obj.outDir    = outDir; % unused
            obj.filterStr = filterStr;
        end
        
        % main logic: go through files in a folder and apply fileAction()
        function obj = main(obj)
            cd(obj.inDir);
            dirList = dir(obj.inDir);
            dirList = dirList(~cellfun('isempty', {dirList.date})); % date==empty is invalid
            for i = 3:length(dirList) % skip . and ..
                cd(obj.inDir)
                obj.contentName = dirList(i).name;
                obj.isDir       = dirList(i).isdir;
                obj.dirName     = dirList(i).folder;
                
                % escape if invalid
                if skipCondition(obj)
                    continue
                end

                % do action on file
                cd(obj.dirName)
                fileAction(obj);
            end % for
        end

        % define when to skip
        function skip = skipCondition(obj)
            skip = false;
            if obj.isDir
                skip = true;
            end
            if ~filterFileName(obj)
                skip = true;
            end
        end
        
        % define what is a valid file
        function validity = filterFileName(obj)
            validity = ~isempty(regexp(obj.contentName, obj.filterStr, 'once'));
        end
        
        % define file action when valid file is found
        function obj = fileAction(obj)
            fprintf(obj.contentName);
            fprintf('\n');
        end

    end % methods
end % class