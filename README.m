%[text] ## some code snippents and helper function that might be useful
%[text] Aug2023 Simon Kuwahara
%[text] - `Alt/Opt + Enter`: toggle text/code.
%[text] - `Ctrl/Cmd + Alt/Opt + Enter`: add section break
%[text] - `Ctrl/Cmd + Enter`: run section \
%[text] I can't enter Japanese comments thanks to a bug. Stupid matlab.
clear
%%
%[text] ### Get directories
curDir    = pwd                              % NOT the location of script %[output:6e8abeaf]
scriptDir = fileparts(mfilename("fullpath")) % does NOT work on livescript %[output:8362a743]
scriptDir = fileparts(matlab.desktop.editor.getActiveFilename) % only MATLAB %[output:5bbe6ca6]
%%
%[text] **Always use ''/"**. Don't ever use "\\".
% YES
fugaDir = './some/random/path'; % Works with all platforms.

% NO!
% fugaDir = '.\some\random\path'; % Don't use it. UNIX will fail.

clear fugaDir
%%
%[text] ### Add functions directory
cd(scriptDir)
cd helperFunctions/
funcDir = pwd %[output:1e3280a6]
%[text] Add functions to path.
addpath(genpath(funcDir))
%%
%[text] ### Create directories
dirName = 'hoge';

% if directory does not exist, create directory
cd(scriptDir)
if ~isfolder(dirName)
    mkdir(fullfile(cd,dirName))
end

% save directory
cd(dirName)
hogeDir = pwd %[output:9ecb366e]
%%
%[text] ### Directory content
%[text] Get direcory content.
hogeContent = dir(hogeDir);
hogeContent = hogeContent(~cellfun('isempty', {hogeContent.date})) % date==empty is invalid %[output:54807c1d]
%%
%[text] Get 2nd content name in hogeDir.
hogeFileTwo = hogeContent(2).name %[output:38ce8c27]
%%
%[text] Check if 1st content is a file or a folder.
if hogeContent(1).isdir %[output:group:4b374709]
    disp('1st content is folder.'); %[output:2e0b7fd3]
else
    disp('1st content is file.');
end %[output:group:4b374709]
%%
%[text] Search file name, get date.
hogeFName = '..' %[output:776bf068]
fileDate = hogeContent(strcmp({hogeContent.name}, hogeFName)).date;
%%
%[text] ### Check environment
%[text] - ./helperFunctions/getVersion.m \
% check environment
[isOctave, release] = getVersion() %[output:4d3577cf] %[output:488272a3]

% check if toolbox is available
searchToolbox = 'signal_toolbox' % signal processing toolbox %[output:209b1fef]
toolboxInstalled    = license('test', searchToolbox) %[output:224bb1f8]
%%
% check system
comp = Screen('Computer') % depends on PTB %[output:192db62a]
%%
%[text] ### Check function availability
chkObj = "dictionary" % dictionary() implemeted from R2022b
existance = exist(chkObj)~=0

keys   = {'A', 'B', 'C', 'D', 'E'};
values =  [1,   2,   3,   4,   5];

if existance
    hashMap = dictionary(keys, values)
else
    hashMap = containers.Map(keys, values) % deprecated
end
%%
%[text] ### Search directory
%[text] Search and print any file inside dataDir with the last 4 letters: '.mat'.
%[text] - ./helperFunctions/goThruFold.m
%[text] - ./helperFunctions/searchAndDestroy.m(inherited example) \
inDir = dataDir;
outDir = []; % unused, see src
regexFilter = '\.mat$';

shoutMat = goThruFold(inDir, outDir, regexFilter); % constructor
shoutMat.main(); % run main
%%
%[text] ### Read all images from directory
%[text] Search all image within a directory.
%[text] - ./helperFunctions/readImgFromDir.m \
imgDir = dataDir;
imgCond = 0; % just filling in parameter; no meaning here

imgStruct = readImgFromDir(imgDir, imgCond)

% search image matrix from file name
imgFileName = 'hoge.jpg';
imgMatrix = imgStruct(strcmp({imgStruct.imgName}, imgFileName)).imgMat;
%%
%[text] ### Clean up
%[text] Delete /hoge.
% Will fail if session doesn't have sufficient privileges.
% Using try-catch is controvirtial, but I'll use it anyway for now.
rmDirName = hogeDir
if isfolder(rmDirName)
    try
        rmdir(rmDirName, 's')
    catch ME
        warning('remove directory failed. Check privileges.')
        rethrow(ME)
    end
else
    fprintf('%s does not exist.', rmDirName);
end
%%
%[text] Remove funcion from path.
rmpath(genpath(funcDir))
%%
%[text] 
%[text] ### Some advice
%[text] Know the best practices well and know when to break them.
%[text] - 命名規則は旧来のMATLABの流れを尊重し、Java/C言語の慣習に従う(camelCase)
%[text] - 命名は2-3語で意味のわかるものにする
%[text] - 非推奨関数は使用禁止、ただし、Octave互換性を重視する場合は別
%[text] - インデントはスペース4文字
%[text] - while trueや再起関数など、無限に停止しないリスクのあるループは極力避けること
%[text] - 環境に依存する書き方は極力避けること(ファイルシステム、外部ツールボックスの依存関係には要注意)
%[text] - インデントは最大3段まで、それ以上になる場合は書き直すかローカル関数にくくりだす
%[text] - 関数は1つのことだけを担当してそれに特化する、1つの関数に複数のことはさせない
%[text] - グローバル変数は禁止
%[text] - clearは原則避け、メモリ節約のために使う場合はスコープに十分注意する
%[text] - コメントはコードの処理の説明にならないように注意、コメント無しでもわかるようにコーディングする
%[text] - コメントはなぜそのようなコードになったのかを説明するように心がける
%[text] - 冒頭コメントは概要説明を1行、書いた年月と開発者のイニシャル
%[text] - 全てのコードはクラスまたは関数にして外から呼べるようにすること
%[text] - 関数内部でパラメータのハードコードは禁止、すべて引数にしたうえで必要に応じてデフォルト値を設定すること
%[text] - 関数のコメントには引数と返り値の型を含めた詳細な説明を書く(ドキュメンテーションについては後ほど要検討)
%[text] - 今必要ない機能は実装しないこと
%[text] - 計算時間・メモリ使用量に注意しつつも、コードの可読性を害する場合は過度な最適化を行わないこと
%[text] - 配列は初期化すること、行列演算はベクトル化すること
%[text] - 互換性確保のために関数の中で関数を宣言しないこと
%[text] - Try to avoid using try~catch unless you really need to \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":37.7}
%---
%[output:6e8abeaf]
%   data: {"dataType":"textualVariable","outputData":{"name":"curDir","value":"'\/MATLAB Drive'"}}
%---
%[output:8362a743]
%   data: {"dataType":"textualVariable","outputData":{"name":"scriptDir","value":"'\/tmp\/Editor_tdleg'"}}
%---
%[output:5bbe6ca6]
%   data: {"dataType":"textualVariable","outputData":{"name":"scriptDir","value":"'\/MATLAB Drive\/my-matlab-snippets-jp'"}}
%---
%[output:1e3280a6]
%   data: {"dataType":"textualVariable","outputData":{"name":"funcDir","value":"'\/MATLAB Drive\/my-matlab-snippets-jp\/helperFunctions'"}}
%---
%[output:9ecb366e]
%   data: {"dataType":"textualVariable","outputData":{"name":"hogeDir","value":"'\/MATLAB Drive\/my-matlab-snippets-jp\/hoge'"}}
%---
%[output:54807c1d]
%   data: {"dataType":"tabular","outputData":{"columnNames":["name","folder","date","bytes","isdir","datenum"],"columns":6,"cornerText":"Fields","dataTypes":["char","char","char","double","logical","double"],"header":"2×1 struct array with fields:","name":"hogeContent","rows":2,"type":"struct","value":[["'.'","'\/MATLAB Drive\/my-matlab-snippets-jp\/hoge'","'17-Mar-2026 01:08:11'","0","1","7.4006e+05"],["'..'","'\/MATLAB Drive\/my-matlab-snippets-jp\/hoge'","'17-Mar-2026 01:08:11'","0","1","7.4006e+05"]]}}
%---
%[output:38ce8c27]
%   data: {"dataType":"textualVariable","outputData":{"name":"hogeFileTwo","value":"'..'"}}
%---
%[output:2e0b7fd3]
%   data: {"dataType":"text","outputData":{"text":"1st content is folder.\n","truncated":false}}
%---
%[output:776bf068]
%   data: {"dataType":"textualVariable","outputData":{"name":"hogeFName","value":"'..'"}}
%---
%[output:4d3577cf]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"isOctave","value":"   0\n"}}
%---
%[output:488272a3]
%   data: {"dataType":"matrix","outputData":{"columns":3,"header":"1×3 cell array","name":"release","rows":1,"type":"cell","value":[["'25.2.0.3150157 (R2025b) Update 4'","'2025'","'b'"]]}}
%---
%[output:209b1fef]
%   data: {"dataType":"textualVariable","outputData":{"name":"searchToolbox","value":"'signal_toolbox'"}}
%---
%[output:224bb1f8]
%   data: {"dataType":"textualVariable","outputData":{"name":"toolboxInstalled","value":"1"}}
%---
%[output:192db62a]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Unrecognized function or variable 'Screen'."}}
%---
