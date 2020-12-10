"Filed out from Dolphin Smalltalk 7"!

Tools.Scintilla.InterfaceDefinition subclass: #'Tools.Scintilla.FunctionDefinition'
	instanceVariableNames: 'funcType returnType lParam wParam returnTypeName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.FunctionDefinition guid: (Core.GUID fromString: '{1c19ff8a-f7a5-4f32-ad24-5ddb1990984f}')!
Tools.Scintilla.FunctionDefinition comment: ''!
!Tools.Scintilla.FunctionDefinition categoriesForClass!Development! !
!Tools.Scintilla.FunctionDefinition methodsFor!

constPrefix
	^'SCI_'!

defaultReturnValue
	^self hasReturnValue ifTrue: [self returnType default]!

displayOn: aStream
	aStream nextPutAll: returnTypeName;
		space;
		nextPutAll: name;
		nextPut: $(.
	wParam name ifNotNil: [
		aStream display: wParam].
	lParam name ifNotNil: [
		aStream nextPutAll: ', '.
		aStream display: lParam].
	aStream nextPut: $)!

emitBasicNullLParamFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitBasicWParamLParamFunctionOn: aPuttableStream
	| keywords |
	keywords := self selector subStrings: $:.
	aPuttableStream
		nextPutAll: keywords first;
		nextPut: $:;
		space;
		nextPutAll: wParam parameterName;
		space;
		nextPutAll: keywords second;
		nextPut: $:;
		space;
		nextPutAll: lParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

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

emitMethodBodyOn: aPuttableStream
	self emitMethodPreambleOn: aPuttableStream.
	self hasReturnValue
		ifTrue: 
			[| default |
			aPuttableStream nextPutAll: '^(this '.
			default := self defaultReturnValue.
			default isNil
				ifTrue: []
				ifFalse: 
					[aPuttableStream
						nextPutAll: 'ifNil: [';
						print: default;
						nextPutAll: '] '].
			aPuttableStream nextPutAll: 'ifNotNil: ['.
			self returnType emitReturnConversionAround: [self emitScintillaCallOn: aPuttableStream]
				on: aPuttableStream]
		ifFalse: 
			[aPuttableStream nextPutAll: '(this ifNotNil: ['.
			self emitScintillaCallOn: aPuttableStream].
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
	^wParam isUnused
		ifTrue: 
			[lParam isUnused
				ifTrue: [self emitNullNullFunctionOn: aWriteStream]
				ifFalse: [self emitNullLParamFunctionOn: aWriteStream]]
		ifFalse: 
			[lParam isUnused
				ifTrue: [self emitWParamNullFunctionOn: aWriteStream]
				ifFalse: [self emitWParamLParamFunctionOn: aWriteStream]]!

emitNullLParamFunctionOn: aWriteStream 
	^self hasStringResult 
		ifTrue: [self emitStringResultFunctionOn: aWriteStream]
		ifFalse: [self emitBasicNullLParamFunctionOn: aWriteStream]!

emitNullNullFunctionOn: aWriteStream
	aWriteStream
		nextPutAll: self selector;
		crtab.
	self emitMethodBodyOn: aWriteStream!

emitScintillaCallOn: aPuttableStream
	aPuttableStream
		nextPutAll: 'Library directFunction: this msg: ';
		nextPutAll: constName.
	wParam emitOutParam: $w on: aPuttableStream.
	lParam emitOutParam: $l on: aPuttableStream!

emitStringResultFunctionOn: aPuttableStream
	| resultClassExpression |
	aPuttableStream
		nextPutAll: self selector;
		crtab.
	self emitMethodPreambleOn: aPuttableStream.
	resultClassExpression := self fixedClassStringResults at: constName ifAbsent: ['stringClass'].
	aPuttableStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [Library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: nil]. ^len = 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: self constName) ifTrue: [aPuttableStream nextPutAll: '-1'].
	aPuttableStream
		nextPutAll: '. Library directFunction: this msg: ';
		nextPutAll: self constName;
		nextPutAll: ' wParam: 0 lpParam: result. result]'!

emitWParamLParamFunctionOn: aPuttableStream
	^self hasStringResult
		ifTrue: [self emitWParamStringResultFunctionOn: aPuttableStream]
		ifFalse: [self emitBasicWParamLParamFunctionOn: aPuttableStream]!

emitWParamNullFunctionOn: aPuttableStream
	aPuttableStream
		nextPutAll: self selector;
		space;
		nextPutAll: wParam parameterName;
		crtab.
	self emitMethodBodyOn: aPuttableStream!

emitWParamStringResultFunctionOn: aWriteStream
	| ignoreWParam resultClassExpression |
	ignoreWParam := self selector argumentCount = 0.
	aWriteStream
		nextPutAll: self selector;
		space.
	ignoreWParam ifFalse: [aWriteStream nextPutAll: wParam parameterName].
	aWriteStream crtab.
	self emitMethodPreambleOn: aWriteStream.
	resultClassExpression := self fixedClassStringResults at: constName ifAbsent: ['stringClass'].
	aWriteStream
		nextPutAll: '| len | len := this ifNil: [0] ifNotNil: [Library directFunction: this msg: ';
		nextPutAll: self constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: 0']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream
		nextPutAll: ' lpParam: nil]. ^len = 0 ifTrue: [';
		display: resultClassExpression;
		nextPutAll: ' empty] ifFalse: [| result | result := ';
		display: resultClassExpression;
		nextPutAll: ' newFixed: len'.
	(self stringResultsCountNull includes: constName) ifTrue: [aWriteStream display: -1].
	aWriteStream
		nextPutAll: '. Library directFunction: this msg: ';
		nextPutAll: constName.
	ignoreWParam
		ifTrue: [aWriteStream nextPutAll: ' wParam: len']
		ifFalse: [wParam emitOutParam: $w on: aWriteStream].
	aWriteStream nextPutAll: ' lpParam: result. result]'!

fixedClassStringResults
	"Answer the set of Scintilla functions declared as returning strings, but which need to
	return either a ByteArray or a specific class of String that doesn't depend on the view's
	current encoding."

	^##(LookupTable new
		at: 'SCI_MARGINGETSTYLES' put: ByteArray;
		at: 'SCI_ANNOTATIONGETSTYLES' put: ByteArray;
		at: 'SCI_GETSUBSTYLEBASES' put: ByteArray;
		at: 'SCI_TARGETASUTF8' put: Utf8String;
		yourself)!

funcType: aString 
	funcType := aString!

hasReturnValue
	^self returnType isVoid not!

hasStringResult
	^lParam typeName = 'stringresult'!

isCommand
	"void functions with no parameters that have been given a specific name are considered to be commands."

	^self isFunction and: 
			[self hasReturnValue not
				and: [wParam isUnused and: [lParam isUnused and: [(self selector beginsWith: 'sci') not]]]]!

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

lParam: anArray
	lParam := self makeParam: anArray!

makeParam: anArray
	| paramName paramTypeName |
	paramName := anArray last.
	paramTypeName := anArray first.
	((paramTypeName = 'position' and: 
			[(##(#('bytes' 'space' 'lines' 'columns' 'relative') asSet) includes: paramName)
				or: [paramName beginsWith: 'length']])
		or: [paramTypeName = 'line' and: [paramName = 'lines']]) ifTrue: [paramTypeName := 'int'].
	^Tools.Scintilla.ParameterDefinition newName: paramName typeName: paramTypeName!

name
	^name!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(; display: self; nextPut: $).!

remappedReturnTypes
	"As of Scintilla 4.20 there are some helpful new parameter and return types intended to more closely describe
	usage in order to allow for better auto-generation of language bindings. However the 'position' type has been 
	abused to also describe lengths/sizes. Since we want to map from Scintilla's zero-based positions to Smalltalk
	1-based indexes, we need to distinguish between genuine positions, and misuses of the type."

	^##(| remappedReturnTypes |
	remappedReturnTypes := LookupTable new.
	#('SCI_GETSTYLEDTEXT' 'SCI_COUNTCHARACTERS' 'SCI_COUNTCODEUNITS' 'SCI_GETLINECOUNT' 'SCI_GETTEXTRANGE' 'SCI_GETTEXTLENGTH' 'SCI_REPLACETARGET' 'SCI_REPLACETARGETRE' 'SCI_WRAPCOUNT' 'SCI_LINESONSCREEN' 'SCI_POSITIONRELATIVE' 'SCI_POSITIONRELATIVECODEUNITS' 'SCI_GETSELECTIONNCARETVIRTUALSPACE' 'SCI_GETSELECTIONNANCHORVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE' 'SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE')
		do: [:each | remappedReturnTypes at: each put: 'int'].
	remappedReturnTypes)!

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
		at: 'SCI_GETCARETPERIOD' put: #caretPeriod;
		at: 'SCI_SETCARETPERIOD' put: #caretPeriod:;
		at: 'SCI_GETCARETWIDTH' put: #caretWidth;
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
		at: 'SCI_GETMOVEEXTENDSSELECTION' put: #isInSelectionExtendMode;
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
		at: 'SCI_GETADDITIONALSELECTIONTYPING' put: #hasAdditionalSelectionTyping;
		at: 'SCI_SETADDITIONALSELECTIONTYPING' put: #hasAdditionalSelectionTyping:;
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
		at: 'SCI_CLEARALL' put: #basicClearAll;
		at: 'SCI_EDITTOGGLEOVERTYPE' put: #toggleOvertype;
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
		at: 'SCI_CALLTIPSETHLT' put: #highlightCallTipFrom:to:;
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
		at: 'SCI_GETSELECTIONS' put: #selectionCount;
		at: 'SCI_SWAPMAINANCHORCARET' put: #swapPrimarySelectionAnchorAndCaret;
		at: 'SCI_VERTICALCENTRECARET' put: #centerCurrentLine;
		yourself.
	"3.6.3"
	renamedMessages
		at: 'SCI_GETALLLINESVISIBLE' put: #areAllLinesVisible;
		at: 'SCI_DESCRIBEKEYWORDSETS' put: #describeKeywordSets;
		at: 'SCI_GETLEXERLANGUAGE' put: #lexerLanguage;
		yourself.
	"3.7.0"
	renamedMessages
		at: 'SCI_MULTIEDGECLEARALL' put: #removeAllEdges;
		at: 'SCI_GETMOUSEWHEELCAPTURES' put: #isMouseWheelCaptured;
		at: 'SCI_SETMOUSEWHEELCAPTURES' put: #isMouseWheelCaptured:;
		yourself.

	"4.1.5"
	renamedMessages
		at: 'SCI_GETDEFAULTFOLDDISPLAYTEXT' put: #defaultFoldTextTag;
		at: 'SCI_SETDEFAULTFOLDDISPLAYTEXT' put: #defaultFoldTextTag:;
		yourself.

	"4.2 - introduces extra types allowing a number of functions to be generated in higher level form"
	renamedMessages
		at: 'SCI_GOTOLINE' put: #gotoLine:;
		at: 'SCI_GETLINEENDPOSITION' put: #lineEndPosition:;
		at: 'SCI_CALLTIPSETPOSSTART' put: #callTipPosition:;
		at: 'SCI_VISIBLEFROMDOCLINE' put: #lineFromDocumentLine:;
		at: 'SCI_DOCLINEFROMVISIBLE' put: #documentLineFromLine:;
		at: 'SCI_SETFOLDLEVEL' put: #foldLine:level:;
		at: 'SCI_GETFOLDLEVEL' put: #foldLevelOfLine:;
		at: 'SCI_GETLASTCHILD' put: #lastChildLine:level:;
		at: 'SCI_FOLDCHILDREN' put: #foldChildren:action:;
		at: 'SCI_EXPANDCHILDREN' put: #expandChildren:level:;
		at: 'SCI_GETFOLDPARENT' put: #parentOfFoldedLine:;
		at: 'SCI_SHOWLINES' put: #showLinesFrom:to:;
		at: 'SCI_HIDELINES' put: #hideLinesFrom:to:;
		at: 'SCI_GETLINEVISIBLE' put: #isLineVisible:;
		at: 'SCI_WRAPCOUNT' put: #wrapCount:;
		at: 'SCI_SETFOLDEXPANDED' put: #isLine:folded:;
		at: 'SCI_GETFOLDEXPANDED' put: #isLineFolded:;
		at: 'SCI_TOGGLEFOLD' put: #toggleFold:;
		at: 'SCI_TOGGLEFOLDSHOWTEXT' put: #toggleFold:showText:;
		at: 'SCI_FOLDLINE' put: #foldLine:action:;
		at: 'SCI_ENSUREVISIBLE' put: #ensureLineVisible:;
		at: 'SCI_ENSUREVISIBLEENFORCEPOLICY' put: #ensureLineVisibleEnforcingPolicy:;
		at: 'SCI_WORDSTARTPOSITION' put: #wordStartAt:onlyWordCharacters:;
		at: 'SCI_WORDENDPOSITION' put: #wordEndAt:onlyWordCharacters:;
		at: 'SCI_TEXTHEIGHT' put: #lineHeight:;
		at: 'SCI_GETFIRSTVISIBLELINE' put: #lineScroll;
		at: 'SCI_SETFIRSTVISIBLELINE' put: #lineScroll:;
		at: 'SCI_GETEDGECOLUMN' put: #edgeColumn;
		at: 'SCI_SETEDGECOLUMN' put: #edgeColumn:;
		at: 'SCI_SEARCHNEXT' put: #searchNext:text:;
		at: 'SCI_SEARCHPREV' put: #searchPrev:text:;
		at: 'SCI_FINDCOLUMN' put: #indexOfLine:column:;
		at: 'SCI_GETLINESTATE' put: #getLineState:;
		at: 'SCI_GETLINEINDENTATION' put: #indentationOfLine:;
		at: 'SCI_CLEARTABSTOPS' put: #clearTabStops:;
		at: 'SCI_GETCOLUMN' put: #columnFromPosition:;
		at: 'SCI_GETENDATLASTLINE' put: #canScrollPastEnd;
		at: 'SCI_GETRECTANGULARSELECTIONANCHOR' put: #rectangularSelectionAnchor;
		at: 'SCI_SETRECTANGULARSELECTIONCARET' put: #rectangularSelectionCaret:;
		at: 'SCI_SETRECTANGULARSELECTIONANCHOR' put: #rectangularSelectionAnchor:;
		at: 'SCI_GETRECTANGULARSELECTIONCARET' put: #rectangularSelectionCaret;
		at: 'SCI_SETLINESTATE' put: #setLine:state:;
		at: 'SCI_GETSELECTIONSTART' put: #selectionStart;
		yourself.

	"4.2.1"
	renamedMessages
		at: 'SCI_GETTABMINIMUMWIDTH' put: #tabMinimumWidth;
		at: 'SCI_SETTABMINIMUMWIDTH' put: #tabMinimumWidth:;
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

	"Brace highlighting"

	"1.67"

	"1.77"

	"Annotations"

	"2.01"
	"3.6.3"
	"3.7.0"

	"4.1.5"

	"4.2 - introduces extra types allowing a number of functions to be generated in higher level form"

	"4.2.1"
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

	"Brace highlighting"

	"1.67"

	"1.77"

	"Annotations"

	"2.01"
	"3.6.3"
	"3.7.0"

	"4.1.5"

	"4.2 - introduces extra types allowing a number of functions to be generated in higher level form"

	"4.2.1"
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

	"Brace highlighting"

	"1.67"

	"1.77"

	"Annotations"

	"2.01"
	"3.6.3"
	"3.7.0"

	"4.1.5"

	"4.2 - introduces extra types allowing a number of functions to be generated in higher level form"

	"4.2.1"
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

	"Brace highlighting"

	"1.67"

	"1.77"

	"Annotations"

	"2.01"
	"3.6.3"
	"3.7.0"

	"4.1.5"

	"4.2 - introduces extra types allowing a number of functions to be generated in higher level form"

	"4.2.1"!

retType: aString
	returnTypeName := self remappedReturnTypes at: constName ifAbsent: [aString]!

returnType
	^returnType ifNil: [returnType := Tools.Scintilla.TypeReference named: returnTypeName]!

selector
	selector ifNotNil: [^selector].
	selector := self renamedFunctions at: constName
				ifAbsent: 
					[| stream |
					stream := String writeStream.
					stream
						nextPutAll: 'sci';
						nextPutAll: name capitalized.
					wParam isUnused
						ifTrue: [(lParam isUnused or: [self hasStringResult]) ifFalse: [stream nextPut: $:]]
						ifFalse: 
							[stream nextPut: $:.
							(lParam isUnused or: [self hasStringResult])
								ifFalse: 
									[stream
										nextPutAll: lParam name;
										nextPut: $:]].
					stream contents asSymbol].
	^selector!

stringResultsCountNull
	"Answer the set of all Scintilla control stringresult messages that include the null
	terminator in the count returned. Most do not (this inconsistency is a Scintilla bug
	really as it defeats the ability to generate a correct wrapper from the interface 
	metadata alone)."

	^##((Set new)
		add: 'SCI_GETSELTEXT';
		add: 'SCI_GETTEXT';
		add: 'SCI_GETCURLINE';
		shrink;
		yourself)!

wParam: anArray
	wParam := self makeParam: anArray! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #constPrefix!initializing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #defaultReturnValue!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #displayOn:!displaying!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitBasicNullLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitBasicWParamLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitCommentOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitCommentString:on:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodBodyOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodPreambleOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitMethodTextOn:!generating!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitNullLParamFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitNullNullFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitScintillaCallOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitStringResultFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamLParamFunctionOn:!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamNullFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #emitWParamStringResultFunctionOn:!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #fixedClassStringResults!accessing!constants!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #funcType:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #hasReturnValue!helpers!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #hasStringResult!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isCommand!helpers!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isFunction!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPrivate!private!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPropGet!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #isPropSet!public!testing! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #lParam:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #makeParam:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #name!accessing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #printOn:!printing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #remappedReturnTypes!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #renamedFunctions!constants!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #retType:!accessing!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #returnType!accessing!public! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #selector!generating!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #stringResultsCountNull!constants!private! !
!Tools.Scintilla.FunctionDefinition categoriesFor: #wParam:!accessing!private! !

!Tools.Scintilla.FunctionDefinition class methodsFor!

tokens: anArray 
	| func |
	func := super tokens: anArray.
	func wParam: (anArray at: 4).
	func lParam: (anArray at: 5).
	^func! !
!Tools.Scintilla.FunctionDefinition class categoriesFor: #tokens:!instance creation!public! !

