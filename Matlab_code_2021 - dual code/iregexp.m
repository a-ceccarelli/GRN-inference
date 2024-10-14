function varargout = iregexp(str,xpr,varargin)
% Interactively try regular expressions and view REGEXP's outputs in a figure.
%
% (c) 2016-2021 Stephen Cobeldick
%
%%% Syntax:
%  iregexp()
%  iregexp(str,xpr)
%  iregexp(str,xpr,<REGEXP options>)
%  [<REGEXP outputs>] = iregexp(...)
%
% Regular expressions are a powerful tool for working with strings, but
% creating a regular expression can be quite a challenge. IREGEXP is an
% interactive sandpit for playing around with different parse string and
% regular expression combinations, displaying REGEXP's outputs as you type.
%
% Two edit-boxes are for entering the parse string and regular expression.
% The ParseString edit-box defaults to single-line mode, selecting the
% check-box selects multi-line mode. A few handy keyboard shortcuts:
%
% Operation:                 | Single-Line Mode: | Multi-Line Mode:
% ---------------------------|-------------------|------------------
% Enter text (update outputs)| enter             | control + enter
% Switch between edit-boxes  | tab               | control + tab
% Newline character          | N/A               | enter
% Tab character              | N/A               | tab
%
% Note0: trailing newline characters are removed by the ParseString edit-box.
%
% A callback tries to update the outputs as text is typed, but to update
% the outputs correctly the text MUST be entered with a mouse-click
% outside the edit-box. You can also call the function to set the input
% string, the regular expression, or use any REGEXP optional input arguments.
%
% Escaped characters in the displayed outputs (ASCII 7-13 & 92):
% | bell | backspace | tab | line feed | vert. tab | form feed | carriage return | backslash |
% |------|-----------|-----|-----------|-----------|-----------|-----------------|-----------|
% |  \a  |    \b     | \t  |    \n     |    \v     |    \f     |        \r       |    \\     |
%
%% Example %%
%
% Ellipses indicate continuation without closing the figure window.
%
% % Call with the default parse and regular expression strings:
% >> iregexp()
% % ...interactively add the parse string '0_AAA111-BB22.CCCC3'.
% % ...interactively add the regular expression '([A-Z]+)'.
% % ...call to set a new parse string:
% >> iregexp('0_aaa111-BB22.cccc3',[])
% % ...interactively change the regular expression to '([a-z]+)\d+'.
% % ...call to allow case-insensitive matching:
% >> iregexp([],[],'ignorecase')
% % ...interactively change the regular expression to '(?<str>[A-Z]+)(?<num>\d+)'.
% % ...call to assign selected outputs to some variables:
% >> [A,B,C,D] = iregexp([],[],'ignorecase','match','start','tokens','split')
%  A = {'aaa111', 'BB22', 'cccc3'}
%  B = [3, 10, 15]
%  C = {{'aaa','111'},{'BB','22'},{'cccc','3'}}
%  D = {'0_','-','.',''}
%
%% Input and Output Arguments %%
%
%%% Inputs
%  str = CharVector or StringScalar, the text to be parsed.
%      = [] uses the current text.
%  xpr = CharVector or StringScalar, the regular expression.
%      = [] uses the current regular expression.
% <REGEXP options> are exactly as per REGEXP (CharVector or StringScalar):
%      = 'once'
%      = 'warnings'
%      = 'matchcase'/'ignorecase'
%      = 'dotall'/'dotexceptnewline'
%      = 'stringanchors'/'lineanchors'
%      = 'literalspacing'/'freespacing'
%      = Output selection specifiers, any of:
%        'start', 'end', 'tokenExtents', 'match', 'tokens', 'names', 'split'.
%
% Note1: The provided options remain valid until the next IREGEXP call.
% Note2: There is no way to change the REGEXP options from within the GUI figure.
% Note3: For simplicity outputs are returned as CharVectors, not as Strings.
%
% See also REGEXP REGEXPI REGEXPREP REGEXPTRANSLATE NATSORT NATSORTFILES NATSORTROWS

persistent fgh txh edh chk uit inp arg ids
%
%% Input Wrangling %%
%
assert(nargin~=1,'SC:iregexp:SingleInput',...
	'The first and second inputs <str> and <xpr> must be provided together.')
%
def = {'Enter your text here!','(?<word>\w+)'};
%
if isempty(fgh)||~ishghandle(fgh)
	[fgh,txh,edh,chk,uit,inp] = irxNewFig(def,@irxClBk,@irxKyPr);
end
%
isc = @(t)ischar(t)&&ndims(t)<3&&size(t,1)<2; %#ok<ISMAT>
msg = '%s input <%s> must be a 1xN character vector, a scalar string, or [].';
nwl = char(10); %#ok<CHARTEN>
%
if nargin==0
	inp = def;
else
	str = irx1s2c(str);
	if isc(str)
		idx = ismember(nwl,str);
		set(chk, 'Value',idx)
		set(edh(1), 'String',{'X'}, 'Max',idx+1, 'String',regexp(str,'\n','split'))
		inp{1} = str;
	else
		assert(isequal(str,[]),'SC:iregexp:str:NotText',msg,'First','str')
	end
	xpr = irx1s2c(xpr);
	if isc(xpr)
		set(edh(2), 'String',{xpr})
		inp{2} = xpr;
	else
		assert(isequal(xpr,[]),'SC:iregexp:xpr:NotText',msg,'Second','xpr')
	end
end
%
varargin = cellfun(@irx1s2c,varargin,'uni',0);
%
%% Callback Functions %%
%
	function irxClBk(hnd,~,idx)
		% Callback Function for 'edit' uicontrols.
		tmp = strcat({nwl},get(hnd,'String'));
		tmp = [tmp{:}];
		inp{idx} = tmp(2:end);
		irxNested(inp{1},inp{2})
	end
%
	function irxKyPr(~,evt,idx)
		% Keypress function for 'edit' uicontrols.
		if strcmp(evt.Key,'backspace')
			if ~isempty(inp{idx})
				inp{idx}(end) = [];
			end
		elseif isempty(evt.Character)
			return
		elseif isstrprop(evt.Character,'graphic')||isstrprop(evt.Character,'wspace')
			inp{idx}(end+1) = evt.Character;
		end
		irxNested(inp{1},inp{2})
	end
%
%% Determine the Outputs %%
%
out = []; % fix thanks to Zhuohe Liu.
ord = {'start','end','tokenextents','match','tokens','names','split'}; % default
arg = lower(varargin);
idx = ismember(arg,ord);
[ord,idf] = unique([arg(idx),ord],'first');
[~,idf] = sort(idf); % stable sort
[~,ids] = cellfun(@(c)ismember(c,ord(idf)),{uit.output},'uni',0);
%
%% Parse the String using the Regular Expresssion %%
%
	function irxNested(one,two)
		% Actually call REGEXP:
		out = irxEigen(one,two,arg{:});
		% Prettyprint the output arguments:
		for k = 1:numel(ids)
			set(txh(k), 'Data',irxPretty(uit(k).output,out(ids{k})))
		end
	end
%
irxNested(inp{1},inp{2})
%
%waitfor(fgh) % uncomment to wait for the figure to be closed (one-shot).
%
varargout = out(1:nargout);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%iregexp
function arr = irx1s2c(arr)
% If scalar string then extract the character vector, otherwise data is unchanged.
if isa(arr,'string') && isscalar(arr)
	arr = arr{1};
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irx1s2c
function [fgh,txh,edh,chk,uit,def] = irxNewFig(def,cbk,kyp)
% Create a new figure with editboxes for <str> and <xpr>, and UITABLEs for outputs.
%
% Heights of UI objects:
aht = [0,0.1,0.3,0.65,1];
adf = diff(aht);
% Names of top-row UITABLE:
uit(2).title  = {'StartIndex','EndIndex','MatchStrings','SplitStrings'};
uit(2).output = {'start'     ,'end'     ,'match'       ,'split'};
uit(2).tmwdoc = {'startIndex','endIndex','matchStr'    ,'splitStr'};
% Names of bottom-row UITABLE:
uit(1).title  = {'TokenIndex'  ,'TokenStrings','TokenNames'};
uit(1).output = {'tokenextents','tokens'      ,'names'};
uit(1).tmwdoc = {'tokIndex'    ,'tokenStr'    ,'exprNames'};
% Names of 'edit' UICONTROL:
uicstr = {'StringToParse','RegularExpression'};
tmwdoc = {'parseStr'     ,'matchExpr'};
%
fgh = figure('Visible','on',...
	'Units','normalized',...
	'MenuBar','figure',...
	'Toolbar','none',...
	'Name','Interactive Regular Expression Tool',...
	'NumberTitle','off',...
	'HandleVisibility','off',...
	'IntegerHandle','off',...
	'Tag',mfilename);
%
for m = 2:-1:1
	str = sprintf(',%s',uit(m).tmwdoc{:});
	txh(m) = uitable(fgh, 'Visible','on',...
		'TooltipString',sprintf('REGEXP outputs <%s>',str(2:end)),...
		'Units','normalized',...
		'Position',[0,aht(m+2),1,adf(m+2)],...
		'ColumnName',uit(m).title,...
		'ColumnEditable',false,...
		'Enable','inactive');
end
%
for m = 2:-1:1
	hnd = uipanel(fgh, 'Visible','on',...
		'Units','normalized',...
		'Position',[0,aht(3-m),1,adf(3-m)],...
		'Title',uicstr{m},...
		'TitlePosition','centertop',...
		'BorderType','line',...
		'BorderWidth',2);
	edh(m) = uicontrol(hnd, 'Visible','on',...
		'TooltipString',sprintf('REGEXP input <%s>',tmwdoc{m}),...
		'Units','normalized',...
		'Position',[0,0,1,1],...
		'Style','edit',...
		'String',def(m),...
		'HorizontalAlignment','center',...
		'Min',0,'Max',1,...
		'Callback',{cbk,m},...
		'BackgroundColor',[1,1,1],...
		'KeypressFcn',{kyp,m});
end
%
% Check box to select either single-line or multi-line ParseString:
fun = @(H,E)set(edh(1),'Max',1+(get(H,'Value')));
try % pre HG2.
	old = warning('off','MATLAB:Uipanel:HiddenImplementation');
	chk = get(hnd,'TitleHandle'); % Thank you to Yair Altman for the idea.
	set(chk, 'Style','checkbox', 'Value',0, 'Units','pixels',...
		'Position',get(chk,'Position')+[0,0,17,0], 'Callback',fun);
	warning(old)
catch %#ok<CTCH>
	chk = uicontrol(hnd, 'Style','checkbox', 'Value',0,...
		'Units','pixels', 'Position',[0,0,17,17], 'Callback',fun);
end
%
% Give focus to the ParseString 'edit' uicontrol:
uicontrol(edh(1));
%
drawnow()
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxNewFig
function out = irxEigen(one,two,varargin)
% Call REGEXP in a local function to allow for dynamic regular expressions.
%
[out{1:7}] = regexp(one,two,varargin{:});
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxEigen
function uid = irxPretty(otp,new)
% Prettyprint REGEXP outputs.
%
raw = {'\\','\a','\b','\t','\n','\v','\f','\r'};
rep = strcat('\',raw);
uid = cell(0,numel(new));
%
for m = 1:numel(otp)
	%
	switch otp{m}
		case {'start','end'}
			val = arrayfun(@(n)sprintf('%.0f',n),new{m},'UniformOutput',false);
		case {'split','match'}
			val = strcat('''',new{m},'''');
		case 'tokenextents'
			if iscell(new{m})
				val = cellfun(@irxPrtyMat,new{m},'UniformOutput',false);
			else
				val = irxPrtyMat(new{m});
			end
			val = strrep(val,' ',',');
		case 'tokens'
			if cellfun('isclass',new{m},'char')
				val = irxPrtyStr(new{m});
			else
				val = cellfun(@irxPrtyStr,new{m},'UniformOutput',false);
			end
		case 'names'
			val = irxPrtyName(new{m});
		otherwise
			error('I don''t know what to do with this input argument.')
	end
	%
	val = regexprep(val,raw,rep); % escaped
	%val = regexprep(val,' ','\xB7'); % interpunct
	%
	if ischar(val)
		uid{1,m} = val;
	elseif numel(val)
		uid(1:numel(val),m) = val;
	end
	%
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxPretty
function str = irxPrtyMat(mat)
% Prettyprint a 2D numeric matrix as "[1,2;3,4]".
%
if isempty(mat)
	str = '';
else
	fmt = repmat(',%.0f',1,size(mat,2));
	fmt = sprintf(';%s',fmt(2:end));
	str = sprintf(fmt,mat.');
	str = sprintf('[%s]',str(2:end));
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxPrtyMat
function str = irxPrtyStr(ccv)
% Prettyprint a vector cell array of char vectors as "{'a','b'}".
%
if isempty(ccv)
	str = '';
else
	ccv = strcat(',''',ccv,'''');
	str = strcat(ccv{:});
	str = sprintf('{%s}',str(2:end));
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxPrtyStr
function out = irxPrtyName(tnv)
% Prettyprint a structure of token names and values as "name:'value'".
%
fnm = fieldnames(tnv);
if isempty(fnm)
	out = '';
else
	fun = @(s)strcat(',',fnm,':''',struct2cell(s),'''');
	out = arrayfun(fun,tnv,'UniformOutput',false);
	out = cellfun(@(c)strcat(c{:}),out,'UniformOutput',false);
	out = cellfun(@(s)s(2:end),out,'UniformOutput',false);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%irxPrtyName