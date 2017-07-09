"Filed out from Dolphin Smalltalk 7"!

ScintillaDef subclass: #ScintillaFunctionDef
	instanceVariableNames: 'funcType returnType wParamType wParamName lParamType lParamName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaFunctionDef guid: (GUID fromString: '{1c19ff8a-f7a5-4f32-ad24-5ddb1990984f}')!
ScintillaFunctionDef comment: ''!
!ScintillaFunctionDef categoriesForClass!Development! !
!ScintillaFunctionDef methodsFor!

buildParamName: nameString type: typeString 
	^(String with: nameString first asLowercase) , (nameString copyFrom: 2) 
		, typeString objectClass name!

byteArrayStringResults
	"Answer the set of Scintilla functions declared as returning strings, but which really should return ByteArrays."

	^##((Set new)
		add: 'SCI_MARGINGETSTYLES';
		add: 'SCI_ANNOTATIONGETSTYLES';
		add: 'SCI_GETSUBSTYLEBASES';
		yourself)!

constPrefix
	^'SCI_'!

defaultReturnValue
	^self hasReturnValue ifTrue: [self returnType default printString] ifFalse: ['self']!

emitBasicNullLParamFunctionOn: aPuttableStream 
	| lParam |
	selector := self renamedFunctions at: constName
				ifAbsent: [('sci' , self name capitalized , ':') asSymbol].
	lParam := self buildParamName: self lParamName type: self lParamType.
	aPuttableStream
		nextPutAll: selector;
		space;
		nextPutAll: lParam;
		crtab.
	self 
		emitMethodBodyOn: aPuttableStream
		wParam: 0
		lParam: lParam!

emitBasicWParamLParamFunctionOn: aPuttableStream 
	| keywords keyword1 keyword2 wParam lParam |
	selector := self renamedFunctions at: constName ifAbsent: [].
	selector isNil 
		ifTrue: 
			[keyword2 := lParamName copyWith: $:.
			keyword1 := 'sci' , (name capitalized copyWith: $:).
			selector := (keyword1 , keyword2) asSymbol]
		ifFalse: 
			[keywords := selector subStrings: $:.
			keyword1 := keywords first copyWith: $:.
			keyword2 := keywords second copyWith: $:].
	wParam := self buildParamName: wParamName type: wParamType.
	lParam := self buildParamName: lParamName type: lParamType.
	aPuttableStream
		nextPutAll: keyword1;
		space;
		nextPutAll: wParam;
		space;
		nextPutAll: keyword2;
		space;
		nextPutAll: lParam;
		crtab.
	self 
		emitMethodBodyOn: aPuttableStream
		wParam: wParam
		lParam: lParam!

emitCommentOn: aPuttableStream 
	| target |
	self comment isEmpty ifTrue: [^self].
	target := String writeStream.
	target nextPut: $".
	self isPrivate ifTrue: [target nextPutAll: 'Private - '].
	self emitCommentString: self comment on: target.
	target nextPut: $".
	aPuttableStream
		nextPutAll: (Smalltalk developmentSystem 
					wrapText: target contents
					indent: Smalltalk developmentSystem workspaceClass defaultTabWidth + 1
					tabWidth: Smalltalk developmentSystem workspaceClass defaultTabWidth);
		cr!

emitCommentString: aString on: aPuttableStream 
	aString do: [:each | aPuttableStream nextPut: (each == $" ifTrue: [$'] ifFalse: [each])]!

emitMethodBodyOn: aPuttableStream wParam: wParam lParam: lParam 
	| retConversion |
	self emitMethodPreambleOn: aPuttableStream.
	self hasReturnValue 
		ifTrue: 
			[aPuttableStream
				nextPutAll: '^(this isNil ifTrue: [';
				nextPutAll: self defaultReturnValue;
				nextPutAll: ']']
		ifFalse: [aPuttableStream nextPutAll: '(this isNil'].
	aPuttableStream nextPutAll: ' ifFalse: ['.
	retConversion := self returnType fromMessage.
	retConversion 
		ifNotNil: 
			[retConversion last == $: 
				ifTrue: 
					[aPuttableStream
						print: self returnType objectClass;
						space;
						nextPutAll: retConversion;
						nextPutAll: ' (']
				ifFalse: [aPuttableStream nextPut: $(]].
	self 
		emitScintillaCallOn: aPuttableStream
		wParam: wParam
		lParam: lParam.
	retConversion 
		ifNotNil: 
			[aPuttableStream nextPut: $).
			retConversion last == $: 
				ifFalse: 
					[aPuttableStream
						space;
						nextPutAll: retConversion]].
	aPuttableStream nextPutAll: '])'!

emitMethodPreambleOn: aPuttableStream 
	self emitCommentOn: aPuttableStream.
	self isDeprecated 
		ifTrue: 
			[aPuttableStream
				print: 'deprecated' asSymbol;
				nextPut: $.;
				crtab]!

emitMethodTextOn: aWriteStream
	^(self isUnusedParameter: wParamName)
		ifTrue: 
			[(self isUnusedParameter: lParamName)
				ifTrue: [self emitNullNullFunctionOn: aWriteStream]
				ifFalse: [self emitNullLParamFunctionOn: aWriteStream]]
		ifFalse: 
			[(self isUnusedParameter: lParamName)
				ifTrue: [self emitWParamNullFunctionOn: aWriteStream]
				ifFalse: [self emitWParamLParamFunctionOn: aWriteStream]]!

emitNullLParamFunctionOn: aWriteStream 
	^self hasStringResult 
		ifTrue: [self emitStringResultFunctionOn: aWriteStream]
		ifFalse: [self emitBasicNullLParamFunctionOn: aWriteStream]!

emitNullNullFunctionOn: aWriteStream 
	selector := self renamedFunctions at: constName ifAbsent: [('sci' , name capitalized) asSymbol].
	aWriteStream
		nextPutAll: selector;
		crtab.
	self 
		emitMethodBodyOn: aWriteStream
		wParam: 0
		lParam: 0!

emitScintillaCallOn: aPuttableStream wParam: wParam lParam: lParam 
	aPuttableStream
		nextPutAll: 'ScintillaLibrary default directFunction: this msg: ';
		nextPutAll: constName;
		nextPutAll: ' wParam: ';
		display: wParam;
		space;
		display: wParamType toScintilla;
		nextPutAll: (lParamType byRef ifTrue: [' lpParam: '] ifFalse: [' lParam: ']);
		display: lParam;
		space;
		display: lParamType toScintilla!

emitStringResultFunctionOn: aPuttableStream 
	| emptyResult |
	selector := self renamedFunctions at: constName ifAbsent: [('sci' , name capitalized) asSymbol].
	aPuttableStream
		nextPutAll: selector;
		crtab.
	self emitMethodPreambleOn: aPuttableStream.
	emptyResult := (self byteArrayStringResults includes: constName) ifTrue: [#[]] ifFalse: [''].
	aPuttableStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [ScintillaLibrary default directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: nil]. ^len = 0 ifTrue: [';
		print: emptyResult;
		nextPutAll: '] ifFalse: [| result | result := ';
		display: emptyResult class;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: self constName) ifTrue: [aPuttableStream nextPutAll: '-1'].
	aPuttableStream
		nextPutAll: '. ScintillaLibrary default directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: result. result]'!

emitWParamLParamFunctionOn: aPuttableStream 
	^self isStringResultWParamFunction 
		ifTrue: [self emitWParamStringResultFunctionOn: aPuttableStream]
		ifFalse: [self emitBasicWParamLParamFunctionOn: aPuttableStream]!

emitWParamNullFunctionOn: aPuttableStream 
	| wParam |
	selector := self renamedFunctions at: constName
				ifAbsent: [('sci' , name capitalized , ':') asSymbol].
	wParam := self buildParamName: wParamName type: wParamType.
	aPuttableStream
		nextPutAll: selector;
		space;
		nextPutAll: wParam;
		crtab.
	self 
		emitMethodBodyOn: aPuttableStream
		wParam: wParam
		lParam: 0!

emitWParamStringResultFunctionOn: aWriteStream 
	| ignoreWParam param emptyResult |
	selector := self renamedFunctions at: constName
				ifAbsent: [('sci' , name capitalized , ':') asSymbol].
	ignoreWParam := selector argumentCount = 0.
	param := self buildParamName: self wParamName type: self wParamType.
	aWriteStream
		nextPutAll: self selector;
		space.
	ignoreWParam ifFalse: [aWriteStream nextPutAll: param].
	aWriteStream crtab.
	self emitMethodPreambleOn: aWriteStream.
	emptyResult := (self byteArrayStringResults includes: constName) ifTrue: [#[]] ifFalse: [''].
	aWriteStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [ScintillaLibrary default directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: ';
		display: (ignoreWParam ifTrue: [0] ifFalse: [param]);
		nextPutAll: ' lpParam: nil]. ^len = 0 ifTrue: [';
		print: emptyResult;
		nextPutAll: '] ifFalse: [| result | result := ';
		display: emptyResult class;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: constName) ifTrue: [aWriteStream display: -1].
	aWriteStream
		nextPutAll: '. ScintillaLibrary default directFunction: this msg: ';
		nextPutAll: constName;
		nextPutAll: ' wParam: ';
		display: (ignoreWParam ifTrue: ['len'] ifFalse: [param]);
		nextPutAll: ' lpParam: result. result]'!

funcType: aString 
	funcType := aString!

hasReturnValue
	^self returnType isVoid not!

hasStringResult
	^self lParamType name = 'stringresult'!

isCommand
	"void functions with no parameters are considered to be commands."

	^self isFunction and: [self hasReturnValue not and: [wParamName isNil and: [lParamName isNil]]]!

isFunction
	^funcType = 'fun'!

isPrivate
	| sel |
	sel := self renamedFunctions at: constName ifAbsent: [].
	^sel isNil or: [sel beginsWith: 'basic']!

isPropGet
	^funcType = 'get'!

isPropSet
	^funcType = 'set'!

isStringResultFunction
	^lParamType name = 'stringresult'!

isStringResultWParamFunction
	^self isStringResultFunction and: [wParamType name = 'int']!

isUnusedParameter: aString
	^aString isNil or: [aString = 'unused']!

lParam: anArray 
	lParamName := anArray last.
	lParamType := ScintillaTypeRef named: anArray first!

lParamName
	^lParamName!

lParamType
	^lParamType!

name
	^name!

renamedFunctions
	^##(| renamedMessages |
	renamedMessages := LookupTable new.
	"Indicators"
	renamedMessages
		at: 'SCI_GETINDICATORCURRENT' put: #currentIndicatorId;
		at: 'SCI_SETINDICATORCURRENT' put: #currentIndicatorId:;
		at: 'SCI_GETINDICATORVALUE' put: #currentIndicatorValue;
		at: 'SCI_SETINDICATORVALUE' put: #currentIndicatorValue:;
		at: 'SCI_INDICATORALLONFOR' put: #indicatorMaskAt:;
		yourself.

	"Zooming"
	renamedMessages
		at: 'SCI_ZOOMIN' put: #zoomIn;
		at: 'SCI_ZOOMOUT' put: #zoomOut;
		at: 'SCI_GETZOOM' put: #zoomLevel;
		at: 'SCI_SETZOOM' put: #zoomLevel:;
		yourself.
	"Undo and Redo"
	renamedMessages
		at: 'SCI_BEGINUNDOACTION' put: #beginUndoGroup;
		at: 'SCI_ENDUNDOACTION' put: #endUndoGroup;
		at: 'SCI_EMPTYUNDOBUFFER' put: #emptyUndoBuffer;
		at: 'SCI_CANREDO' put: #canRedo;
		at: 'SCI_CANUNDO' put: #canUndo;
		at: 'SCI_REDO' put: #redo;
		at: 'SCI_GETUNDOCOLLECTION' put: #isUndoEnabled;
		at: 'SCI_SETUNDOCOLLECTION' put: #isUndoEnabled:;
		at: 'SCI_UNDO' put: #basicUndo;
		yourself.
	"Tabs & indents"
	renamedMessages
		at: 'SCI_GETHIGHLIGHTGUIDE' put: #highlightGuide;
		at: 'SCI_SETHIGHLIGHTGUIDE' put: #highlightGuide:;
		at: 'SCI_GETINDENT' put: #indentation;
		at: 'SCI_SETINDENT' put: #indentation:;
		at: 'SCI_GETTABWIDTH' put: #tabWidth;
		at: 'SCI_SETTABWIDTH' put: #tabWidth:;
		at: 'SCI_GETUSETABS' put: #isUsingTabs;
		at: 'SCI_SETUSETABS' put: #isUsingTabs:;
		at: 'SCI_GETBACKSPACEUNINDENTS' put: #backspaceUnindents;
		at: 'SCI_SETBACKSPACEUNINDENTS' put: #backspaceUnindents:;
		at: 'SCI_GETTABINDENTS' put: #tabIndents;
		at: 'SCI_SETTABINDENTS' put: #tabIndents:;
		yourself.
	""
	renamedMessages
		at: 'SCI_GETXOFFSET' put: #xOffset;
		at: 'SCI_SETXOFFSET' put: #xOffset:;
		at: 'SCI_BACKTAB' put: #unindent;
		at: 'SCI_LINEFROMPOSITION' put: #basicLineFromPosition:;
		at: 'SCI_POSITIONFROMLINE' put: #basicPositionAtLine:;
		at: 'SCI_GETVIEWEOL' put: #hasVisibleLineEndings;
		at: 'SCI_SETVIEWEOL' put: #hasVisibleLineEndings:;
		at: 'SCI_GETHSCROLLBAR' put: #canHScroll;
		at: 'SCI_GETVSCROLLBAR' put: #canVScroll;
		at: 'SCI_SETENDATLASTLINE' put: #canScrollPastEnd:;
		yourself.
	"Caret"
	renamedMessages
		at: 'SCI_GOTOPOS' put: #goto:;
		at: 'SCI_GETCURRENTPOS' put: #caretPosition;
		at: 'SCI_SETEMPTYSELECTION' put: #caretPosition:;
		at: 'SCI_GETANCHOR' put: #anchorPosition;
		at: 'SCI_SETANCHOR' put: #anchorPosition:;
		at: 'SCI_GETCARETFORE' put: #caretForecolor;
		at: 'SCI_GETCARETPERIOD' put: #caretPeriod;
		at: 'SCI_SETCARETPERIOD' put: #caretPeriod:;
		at: 'SCI_GETCARETWIDTH' put: #caretWidth;
		at: 'SCI_GETCARETLINEBACK' put: #currentLineBackcolor;
		at: 'SCI_GETCARETLINEBACKALPHA' put: #currentLineAlpha;
		at: 'SCI_SETCARETLINEBACKALPHA' put: #currentLineAlpha:;
		at: 'SCI_GETCARETLINEVISIBLE' put: #isCurrentLineHighlighted;
		at: 'SCI_SETCARETLINEVISIBLE' put: #isCurrentLineHighlighted:;
		at: 'SCI_GETCARETLINEVISIBLEALWAYS' put: #isCurrentLineHighlightedAlways;
		at: 'SCI_SETCARETLINEVISIBLEALWAYS' put: #isCurrentLineHighlightedAlways:;
		at: 'SCI_MOVECARETINSIDEVIEW' put: #moveCaretInsideView;
		at: 'SCI_CHOOSECARETX' put: #rememberCaretX;
		at: 'SCI_GETADDITIONALCARETSVISIBLE' put: #areAdditionalCaretsVisible;
		at: 'SCI_SETADDITIONALCARETSVISIBLE' put: #areAdditionalCaretsVisible:;
		at: 'SCI_GETCARETLINEFRAME' put: #currentLineFrameWidth;
		at: 'SCI_SETCARETLINEFRAME' put: #currentLineFrameWidth:;
		yourself.
	"Markers"
	renamedMessages
		at: 'SCI_MARKERDELETEALL' put: #deleteMarkers:;
		yourself.
	"Scrolling"
	renamedMessages
		at: 'SCI_SETVSCROLLBAR' put: #showVerticalScrollBar:;
		at: 'SCI_GETSCROLLWIDTH' put: #scrollWidth;
		at: 'SCI_SETSCROLLWIDTH' put: #scrollWidth:;
		at: 'SCI_GETSCROLLWIDTHTRACKING' put: #isScrollWidthTracking;
		at: 'SCI_SETSCROLLWIDTHTRACKING' put: #isScrollWidthTracking:;
		yourself.
	"Line wrapping"
	renamedMessages
		at: 'SCI_LINESSPLIT' put: #splitTarget:;
		at: 'SCI_LINESJOIN' put: #joinTarget;
		yourself.

	"Whitespace"
	renamedMessages
		at: 'SCI_GETWHITESPACESIZE' put: #whitespaceMarkerSize;
		at: 'SCI_SETWHITESPACESIZE' put: #whitespaceMarkerSize:;
		yourself.

	"Selection and information"
	renamedMessages
		at: 'SCI_SELECTIONISRECTANGLE' put: #isSelectionRectangular;
		at: 'SCI_HIDESELECTION' put: #hideSelection:;
		at: 'SCI_GETSELALPHA' put: #selectionAlpha;
		at: 'SCI_SETSELALPHA' put: #selectionAlpha:;
		at: 'SCI_GETSELEOLFILLED' put: #isSelectionBackcolorExtendedToEndOfLine;
		at: 'SCI_SETSELEOLFILLED' put: #isSelectionBackcolorExtendedToEndOfLine:;
		at: 'SCI_GETSELECTIONEMPTY' put: #isSelectionEmpty;
		at: 'SCI_GETSELTEXT' put: #selection;
		at: 'SCI_GETTARGETTEXT' put: #targetText;
		at: 'SCI_GETCURLINE' put: #currentLineText;
		at: 'SCI_TARGETWHOLEDOCUMENT' put: #targetAll;
		at: 'SCI_CLEAR' put: #basicClearSelection;
		at: 'SCI_GETTEXTLENGTH' put: #textLength;
		yourself.
	"Text retrieval and modification"
	renamedMessages
		at: 'SCI_GETTEXT' put: #plainText;
		yourself.
	"Styling"
	renamedMessages
		at: 'SCI_CLEARDOCUMENTSTYLE' put: #removeAllStyling;
		at: 'SCI_SETSTYLING' put: #styleNext:mask:;
		at: 'SCI_GETENDSTYLED' put: #stylingPosition;
		at: 'SCI_STARTSTYLING' put: #startStylingFrom:;
		at: 'SCI_COLOURISE' put: #restyleFrom:to:;
		at: 'SCI_GETSTYLEAT' put: #styleIdAt:;
		yourself.

	"Miscellaneous"
	renamedMessages
		at: 'SCI_GETMOUSEDWELLTIME' put: #hoverTime;
		at: 'SCI_SETMOUSEDWELLTIME' put: #hoverTime:;
		at: 'SCI_GETBUFFEREDDRAW' put: #isDrawingBuffered;
		at: 'SCI_SETBUFFEREDDRAW' put: #isDrawingBuffered:;
		at: 'SCI_GETOVERTYPE' put: #isOvertypeEnabled;
		at: 'SCI_SETOVERTYPE' put: #isOvertypeEnabled:;
		at: 'SCI_GETMODIFY' put: #isTextModified;
		at: 'SCI_GETLINECOUNT' put: #lineCount;
		at: 'SCI_GETPRINTCOLOURMODE' put: #printColourMode;
		at: 'SCI_SETPRINTCOLOURMODE' put: #printColourMode:;
		at: 'SCI_GETPRINTMAGNIFICATION' put: #printMagnification;
		at: 'SCI_SETPRINTMAGNIFICATION' put: #printMagnification:;
		at: 'SCI_CLEARALL' put: #clearAll;
		at: 'SCI_EDITTOGGLEOVERTYPE' put: #toggleOvertype;
		at: 'SCI_GETEDGECOLOUR' put: #edgeColor;
		at: 'SCI_SETEDGECOLOUR' put: #edgeColor:;
		at: 'SCI_GETTWOPHASEDRAW' put: #isDrawingTwoPhase;
		at: 'SCI_SETTWOPHASEDRAW' put: #isDrawingTwoPhase:;
		at: 'SCI_SETREADONLY' put: #setReadOnly:;
		at: 'SCI_TAB' put: #indent;
		at: 'SCI_TARGETFROMSELECTION' put: #setTargetRangeFromSelection;
		at: 'SCI_GETSTATUS' put: #errorStatus;
		at: 'SCI_SETSTATUS' put: #errorStatus:;
		at: 'SCI_LINESONSCREEN' put: #linesOnScreen;
		at: 'SCI_GETMOUSEDOWNCAPTURES' put: #willCaptureMouse;
		at: 'SCI_SETMOUSEDOWNCAPTURES' put: #willCaptureMouse:;
		at: 'SCI_ADDTEXT' put: #insertText:from:;
		at: 'SCI_GETWRAPSTARTINDENT' put: #hangingIndent;
		at: 'SCI_SETWRAPSTARTINDENT' put: #hangingIndent:;
		at: 'SCI_GETPOSITIONCACHE' put: #positionCacheSize;
		at: 'SCI_SETPOSITIONCACHE' put: #positionCacheSize:;
		at: 'SCI_GETEXTRAASCENT' put: #extraAscent;
		at: 'SCI_SETEXTRAASCENT' put: #extraAscent:;
		at: 'SCI_GETEXTRADESCENT' put: #extraDescent;
		at: 'SCI_SETEXTRADESCENT' put: #extraDescent:;
		yourself.

	"Hotspot"
	renamedMessages
		at: 'SCI_GETHOTSPOTACTIVEBACK' put: #activeHotspotBackcolor;
		at: 'SCI_GETHOTSPOTACTIVEFORE' put: #activeHotspotForecolor;
		at: 'SCI_GETHOTSPOTACTIVEUNDERLINE' put: #isActiveHotspotUnderlined;
		at: 'SCI_SETHOTSPOTACTIVEUNDERLINE' put: #isActiveHotspotUnderlined:;
		at: 'SCI_GETHOTSPOTSINGLELINE' put: #areHotspotsSingleLine;
		at: 'SCI_SETHOTSPOTSINGLELINE' put: #areHotspotsSingleLine:;
		yourself.

	"Autocompletion"
	renamedMessages
		at: 'SCI_AUTOCCANCEL' put: #cancelAutoCompletion;
		at: 'SCI_AUTOCACTIVE' put: #isAutoCompletionActive;
		at: 'SCI_AUTOCCOMPLETE' put: #acceptAutoCompletion;
		at: 'SCI_AUTOCGETIGNORECASE' put: #isAutoCompletionCaseInsensitive;
		at: 'SCI_AUTOCSETIGNORECASE' put: #isAutoCompletionCaseInsensitive:;
		at: 'SCI_AUTOCGETAUTOHIDE' put: #isAutoCompletionCancelledWhenNoMatch;
		at: 'SCI_AUTOCSETAUTOHIDE' put: #isAutoCompletionCancelledWhenNoMatch:;
		at: 'SCI_AUTOCSELECT' put: #findAutoCompletionEntry:;
		at: 'SCI_AUTOCGETCANCELATSTART' put: #isAutoCompletionCancelledAtStart;
		at: 'SCI_AUTOCSETCANCELATSTART' put: #isAutoCompletionCancelledAtStart:;
		at: 'SCI_AUTOCGETDROPRESTOFWORD' put: #isAutoCompletionTruncating;
		at: 'SCI_AUTOCSETDROPRESTOFWORD' put: #isAutoCompletionTruncating:;
		at: 'SCI_AUTOCGETCHOOSESINGLE' put: #isAutoCompletionSingleMatchChosen;
		at: 'SCI_AUTOCSETCHOOSESINGLE' put: #isAutoCompletionSingleMatchChosen:;
		at: 'SCI_CLEARREGISTEREDIMAGES' put: #destroyAutoCompletionListImages;
		at: 'SCI_AUTOCGETMAXWIDTH' put: #maxCompletionListWidth;
		at: 'SCI_AUTOCSETMAXWIDTH' put: #maxCompletionListWidth:;
		at: 'SCI_AUTOCGETMAXHEIGHT' put: #maxCompletionListHeight;
		at: 'SCI_AUTOCSETMAXHEIGHT' put: #maxCompletionListHeight:;
		at: 'SCI_AUTOCGETCURRENTTEXT' put: #autoCompletionCurrentText;
		at: 'SCI_AUTOCPOSSTART' put: #autoCompletionListPosition;
		yourself.

	"Calltips"
	renamedMessages
		at: 'SCI_CALLTIPACTIVE' put: #isCallTipActive;
		at: 'SCI_CALLTIPCANCEL' put: #cancelCallTip;
		at: 'SCI_CANCEL' put: #cancelModes;
		at: 'SCI_CALLTIPSETPOSITION' put: #isCallTipAboveText:;
		at: 'SCI_CALLTIPPOSSTART' put: #callTipPosition;
		yourself.

	"Macros"
	renamedMessages
		at: 'SCI_STARTRECORD' put: #startRecording;
		at: 'SCI_STOPRECORD' put: #stopRecording;
		yourself.

	"Commands - Cursor movement"
	renamedMessages
		at: 'SCI_CHARLEFT' put: #moveLeft;
		at: 'SCI_CHARRIGHT' put: #moveRight;
		at: 'SCI_WORDLEFT' put: #moveToStartOfWord;
		at: 'SCI_WORDLEFTEND' put: #moveToEndOfPreviousWord;
		at: 'SCI_WORDRIGHT' put: #moveToEndOfWord;
		at: 'SCI_WORDRIGHTEND' put: #moveToEndOfNextWord;
		at: 'SCI_WORDPARTLEFT' put: #moveToStartOfWordPart;
		at: 'SCI_WORDPARTRIGHT' put: #moveToEndOfWordPart;
		at: 'SCI_LINEUP' put: #moveUp;
		at: 'SCI_LINEDOWN' put: #moveDown;
		at: 'SCI_PARAUP' put: #moveParaUp;
		at: 'SCI_PARADOWN' put: #moveParaDown;
		at: 'SCI_PAGEUP' put: #movePageUp;
		at: 'SCI_PAGEUP' put: #movePageUp;
		at: 'SCI_STUTTEREDPAGEUP' put: #moveStutteredPageUp;
		at: 'SCI_PAGEDOWN' put: #movePageDown;
		at: 'SCI_STUTTEREDPAGEDOWN' put: #moveStutteredPageDown;
		at: 'SCI_DOCUMENTEND' put: #moveToEndOfDocument;
		at: 'SCI_DOCUMENTSTART' put: #moveToStartOfDocument;
		at: 'SCI_HOME' put: #moveToStartOfLine;
		at: 'SCI_HOMEWRAP' put: #moveToStartOfWrappedLine;
		at: 'SCI_HOMEDISPLAY' put: #moveToStartOfDisplayLine;
		at: 'SCI_VCHOME' put: #moveToVcHome;
		at: 'SCI_VCHOMEWRAP' put: #moveToWrappedVcHome;
		at: 'SCI_VCHOMEDISPLAY' put: #moveToVcStartOfDisplayLine;
		at: 'SCI_LINEEND' put: #moveToEndOfLine;
		at: 'SCI_LINEENDDISPLAY' put: #moveToEndOfDisplayLine;
		at: 'SCI_LINEENDWRAP' put: #moveToEndOfWrappedLine;
		at: 'SCI_LINESCROLLDOWN' put: #scrollDown;
		at: 'SCI_LINESCROLLUP' put: #scrollUp;
		yourself.

	"Commands - Selection movement"
	renamedMessages
		at: 'SCI_CHARLEFTEXTEND' put: #extendLeft;
		at: 'SCI_CHARRIGHTEXTEND' put: #extendRight;
		at: 'SCI_CHARLEFTRECTEXTEND' put: #extendRectangleLeft;
		at: 'SCI_CHARRIGHTRECTEXTEND' put: #extendRectangleRight;
		at: 'SCI_WORDLEFTEXTEND' put: #extendToStartOfWord;
		at: 'SCI_WORDLEFTENDEXTEND' put: #extendToEndOfPreviousWord;
		at: 'SCI_WORDRIGHTEXTEND' put: #extendToEndOfWord;
		at: 'SCI_WORDRIGHTENDEXTEND' put: #extendToEndOfNextWord;
		at: 'SCI_WORDPARTLEFTEXTEND' put: #extendToStartOfWordPart;
		at: 'SCI_WORDPARTRIGHTEXTEND' put: #extendToEndOfWordPart;
		at: 'SCI_DOCUMENTENDEXTEND' put: #extendToEndOfDocument;
		at: 'SCI_DOCUMENTSTARTEXTEND' put: #extendToStartOfDocument;
		at: 'SCI_HOMEEXTEND' put: #extendToStartOfLine;
		at: 'SCI_HOMEWRAPEXTEND' put: #extendToStartOfWrappedLine;
		at: 'SCI_HOMEDISPLAYEXTEND' put: #extendToStartOfDisplayLine;
		at: 'SCI_HOMERECTEXTEND' put: #extendRectangleToStartOfLine;
		at: 'SCI_VCHOMEEXTEND' put: #extendToVcHome;
		at: 'SCI_VCHOMERECTEXTEND' put: #extendRectangleToVcHome;
		at: 'SCI_VCHOMEWRAPEXTEND' put: #extendToWrappedVcHome;
		at: 'SCI_VCHOMEDISPLAYEXTEND' put: #extendToStartOfVcDisplayLine;
		at: 'SCI_LINEDOWNEXTEND' put: #extendDown;
		at: 'SCI_LINEUPEXTEND' put: #extendUp;
		at: 'SCI_LINEDOWNRECTEXTEND' put: #extendRectangleDown;
		at: 'SCI_LINEUPRECTEXTEND' put: #extendRectangleUp;
		at: 'SCI_LINEENDEXTEND' put: #extendToEndOfLine;
		at: 'SCI_LINEENDRECTEXTEND' put: #extendRectangleToEndOfLine;
		at: 'SCI_LINEENDDISPLAYEXTEND' put: #extendToEndOfDisplayLine;
		at: 'SCI_LINEENDWRAPEXTEND' put: #extendToEndOfWrappedLine;
		at: 'SCI_PAGEUPEXTEND' put: #extendPageUp;
		at: 'SCI_PAGEUPRECTEXTEND' put: #extendRectanglePageUp;
		at: 'SCI_STUTTEREDPAGEUPEXTEND' put: #extendStutteredPageUp;
		at: 'SCI_PAGEDOWNEXTEND' put: #extendPageDown;
		at: 'SCI_STUTTEREDPAGEDOWNEXTEND' put: #extendStutteredPageDown;
		at: 'SCI_PAGEDOWNRECTEXTEND' put: #extendRectanglePageDown;
		at: 'SCI_PARAUPEXTEND' put: #extendParaUp;
		at: 'SCI_PARADOWNEXTEND' put: #extendParaDown;
		at: 'SCI_SELECTALL' put: #basicSelectAll;
		yourself.

	"Unsupported rectangular selection commands"
	false
		ifTrue: 
			[renamedMessages
				at: 'SCI_PARADOWNRECTEXTEND' put: #extendRectangleParaDown;
				at: 'SCI_PARAUPRECTEXTEND' put: #extendRectangleParaUp;
				at: 'SCI_WORDLEFTRECTEXTEND' put: #extendRectangleToStartOfWord;
				at: 'SCI_WORDRIGHTRECTEXTEND' put: #extendRectangleToEndOfWord;
				yourself].

	"Commands - Deletion"
	renamedMessages
		at: 'SCI_DELLINELEFT' put: #deleteToStartOfLine;
		at: 'SCI_DELLINERIGHT' put: #deleteToEndOfLine;
		at: 'SCI_DELWORDLEFT' put: #deleteToStartOfWord;
		at: 'SCI_DELWORDRIGHT' put: #deleteToNextWord;
		at: 'SCI_DELWORDRIGHTEND' put: #deleteToEndOfWord;
		at: 'SCI_DELETEBACK' put: #backspace;
		at: 'SCI_DELETEBACKNOTLINE' put: #backspaceNoLine;
		yourself.

	"Commands - Insertion"
	renamedMessages
		at: 'SCI_FORMFEED' put: #formFeed;
		at: 'SCI_NEWLINE' put: #newLine;
		yourself.

	"Commands - Cut, Copy & Paste"
	renamedMessages
		at: 'SCI_PASTE' put: #pasteClipboard;
		at: 'SCI_CUT' put: #cutSelection;
		at: 'SCI_COPY' put: #copySelection;
		at: 'SCI_COPYALLOWLINE' put: #copySelectionOrLine;
		at: 'SCI_LINECUT' put: #cutLine;
		at: 'SCI_LINEDELETE' put: #deleteLine;
		at: 'SCI_LINECOPY' put: #copyLine;
		at: 'SCI_LINEDUPLICATE' put: #duplicateLine;
		at: 'SCI_LINETRANSPOSE' put: #twiddleLines;
		yourself.

	"Commands - Other"
	renamedMessages
		at: 'SCI_UPPERCASE' put: #convertToUppercase;
		at: 'SCI_LOWERCASE' put: #convertToLowercase;
		at: 'SCI_MOVESELECTEDLINESUP' put: #moveSelectedLinesUp;
		at: 'SCI_MOVESELECTEDLINESDOWN' put: #moveSelectedLinesDown;
		at: 'SCI_SCROLLTOSTART' put: #scrollToStart;
		at: 'SCI_SCROLLTOEND' put: #scrollToEnd;
		at: 'SCI_LINEREVERSE' put: #reverseSelectedLines;
		yourself.
	
	"Brace highlighting"
	renamedMessages
		at: 'SCI_BRACEBADLIGHT' put: #highlightMismatchedBrace:;
		at: 'SCI_BRACEHIGHLIGHT' put: #highlightBracesAt:and:;
		yourself.

	"1.67"
	renamedMessages
		at: 'SCI_SELECTIONDUPLICATE' put: #duplicateSelection;
		yourself.

	"1.77"
	renamedMessages
		at: 'SCI_SETKEYSUNICODE' put: #isKeyboardInputUnicode:;
		at: 'SCI_GETKEYSUNICODE' put: #isKeyboardInputUnicode;
		yourself.

	"Annotations"
	renamedMessages
		at: 'SCI_ANNOTATIONCLEARALL' put: #basicRemoveAllAnnotations;
		at: 'SCI_ANNOTATIONGETSTYLEOFFSET' put: #annotationStylesOffset;
		at: 'SCI_ANNOTATIONSETSTYLEOFFSET' put: #annotationStylesOffset:;
		yourself.

	"2.01"
	renamedMessages
		at: 'SCI_GETMULTIPLESELECTION' put: #isMultiSelect;
		at: 'SCI_SETMULTIPLESELECTION' put: #isMultiSelect:;
		at: 'SCI_CLEARSELECTIONS' put: #removeSelections;
		at: 'SCI_GETADDITIONALCARETSBLINK' put: #hasBlinkingSecondaryCarets;
		at: 'SCI_SETADDITIONALCARETSBLINK' put: #hasBlinkingSecondaryCarets:;
		at: 'SCI_GETADDITIONALSELALPHA' put: #secondarySelectionAlpha;
		at: 'SCI_SETADDITIONALSELALPHA' put: #secondarySelectionAlpha:;
		at: 'SCI_ROTATESELECTION' put: #rotateSelection;
		at: 'SCI_GETADDITIONALCARETFORE' put: #secondaryCaretForecolor;
		at: 'SCI_GETSELECTIONS' put: #selectionCount;
		at: 'SCI_MARGINGETSTYLEOFFSET' put: #marginStylesOffset;
		at: 'SCI_MARGINSETSTYLEOFFSET' put: #marginStylesOffset:;
		at: 'SCI_SWAPMAINANCHORCARET' put: #swapPrimarySelectionAnchorAndCaret;
		at: 'SCI_VERTICALCENTRECARET' put: #centerCurrentLine;
		yourself.
	"3.6.3"
	renamedMessages
		at: 'SCI_GETALLLINESVISIBLE' put: #areAllLinesVisible;
		at: 'SCI_DESCRIBEKEYWORDSETS' put: #describeKeywordSets;
		at: 'SCI_GETLEXERLANGUAGE' put: #lexerLanguage;
		at: 'SCI_PROPERTYNAMES' put: #lexerPropertyNames;
		yourself.
	"3.7.0"
	renamedMessages
		at: 'SCI_MULTIEDGECLEARALL' put: #removeAllEdges;
		at: 'SCI_GETMOUSEWHEELCAPTURES' put: #isMouseWheelCaptured;
		at: 'SCI_SETMOUSEWHEELCAPTURES' put: #isMouseWheelCaptured:;
		yourself.
	renamedMessages
		shrink;
		yourself)
	"Indicators"

	"Zooming"
	"Undo and Redo"
	"Tabs & indents"
	""
	"Caret"
	"Markers"
	"Scrolling"
	"Line wrapping"

	"Whitespace"

	"Selection and information"
	"Text retrieval and modification"
	"Styling"

	"Miscellaneous"

	"Hotspot"

	"Autocompletion"

	"Calltips"

	"Macros"

	"Commands - Cursor movement"

	"Commands - Selection movement"

	"Unsupported rectangular selection commands"

	"Commands - Deletion"

	"Commands - Insertion"

	"Commands - Cut, Copy & Paste"

	"Commands - Other"

	"1.67"

	"1.77"

	"Annotations"

	"2.01"
	"3.6.3"
	"3.7.0"!

retType: aString 
	returnType := ScintillaTypeRef named: aString!

returnType
	^returnType!

stringResultsCountNull
	"Answer the set of all Scintilla control stringresult messages that include the null
	terminator in the count returned. Most do not (this inconsistency is a Scintilla bug
	really)."

	^##((Set new)
		add: 'SCI_GETSELTEXT';
		add: 'SCI_GETTEXT';
		add: 'SCI_GETCURLINE';
		shrink;
		yourself)!

wParam: anArray 
	wParamName := anArray last.
	wParamType := ScintillaTypeRef named: anArray first!

wParamName
	^wParamName!

wParamType
	^wParamType! !
!ScintillaFunctionDef categoriesFor: #buildParamName:type:!helpers!private! !
!ScintillaFunctionDef categoriesFor: #byteArrayStringResults!accessing!constants!private! !
!ScintillaFunctionDef categoriesFor: #constPrefix!initializing!private! !
!ScintillaFunctionDef categoriesFor: #defaultReturnValue!accessing!private! !
!ScintillaFunctionDef categoriesFor: #emitBasicNullLParamFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitBasicWParamLParamFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitCommentOn:!helpers!private! !
!ScintillaFunctionDef categoriesFor: #emitCommentString:on:!helpers!private! !
!ScintillaFunctionDef categoriesFor: #emitMethodBodyOn:wParam:lParam:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitMethodPreambleOn:!helpers!private! !
!ScintillaFunctionDef categoriesFor: #emitMethodTextOn:!generating!public! !
!ScintillaFunctionDef categoriesFor: #emitNullLParamFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitNullNullFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitScintillaCallOn:wParam:lParam:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitStringResultFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitWParamLParamFunctionOn:!helpers!private! !
!ScintillaFunctionDef categoriesFor: #emitWParamNullFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #emitWParamStringResultFunctionOn:!generating!private! !
!ScintillaFunctionDef categoriesFor: #funcType:!accessing!private! !
!ScintillaFunctionDef categoriesFor: #hasReturnValue!helpers!public! !
!ScintillaFunctionDef categoriesFor: #hasStringResult!helpers!private! !
!ScintillaFunctionDef categoriesFor: #isCommand!helpers!private! !
!ScintillaFunctionDef categoriesFor: #isFunction!public!testing! !
!ScintillaFunctionDef categoriesFor: #isPrivate!private!testing! !
!ScintillaFunctionDef categoriesFor: #isPropGet!public!testing! !
!ScintillaFunctionDef categoriesFor: #isPropSet!public!testing! !
!ScintillaFunctionDef categoriesFor: #isStringResultFunction!helpers!private! !
!ScintillaFunctionDef categoriesFor: #isStringResultWParamFunction!helpers!private! !
!ScintillaFunctionDef categoriesFor: #isUnusedParameter:!generating!helpers!public! !
!ScintillaFunctionDef categoriesFor: #lParam:!accessing!private! !
!ScintillaFunctionDef categoriesFor: #lParamName!accessing!public! !
!ScintillaFunctionDef categoriesFor: #lParamType!accessing!public! !
!ScintillaFunctionDef categoriesFor: #name!accessing!public! !
!ScintillaFunctionDef categoriesFor: #renamedFunctions!constants!private! !
!ScintillaFunctionDef categoriesFor: #retType:!accessing!private! !
!ScintillaFunctionDef categoriesFor: #returnType!accessing!public! !
!ScintillaFunctionDef categoriesFor: #stringResultsCountNull!constants!private! !
!ScintillaFunctionDef categoriesFor: #wParam:!accessing!private! !
!ScintillaFunctionDef categoriesFor: #wParamName!accessing!public! !
!ScintillaFunctionDef categoriesFor: #wParamType!accessing!public! !

!ScintillaFunctionDef class methodsFor!

tokens: anArray 
	| func |
	func := super tokens: anArray.
	func wParam: (anArray at: 4).
	func lParam: (anArray at: 5).
	^func! !
!ScintillaFunctionDef class categoriesFor: #tokens:!instance creation!public! !

