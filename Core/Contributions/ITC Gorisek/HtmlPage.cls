"Filed out from Dolphin Smalltalk X6.1"!

HtmlContainer subclass: #HtmlPage
	instanceVariableNames: 'title marginHeight marginWidth leftMargin topMargin rightMargin pageBackground bgColor focusField charset redirect stylesheet style refreshTimeout meta onLoadScript script framesetString favoritesIconUrl noScroll scriptLinks landscapeBool useSessionRefreshScriptBool'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'useGlobalKeyboardHandlerBool'!
HtmlPage guid: (GUID fromString: '{4757C3B1-2F7C-432A-B5F0-DA859067BC89}')!
HtmlPage comment: ''!
!HtmlPage categoriesForClass!Unclassified! !
!HtmlPage methodsFor!

addSessionRefreshOnKeyDownScript
	"When this method is called, then a session refresh script will be added to the generated page. This means that the session wont expire as long as the user is typing something into a form on the page."

	useSessionRefreshScriptBool := true!

bgColor: aString 
	bgColor := aString!

charset: aString 
	charset := aString!

favoritesIconUrl
	^favoritesIconUrl!

favoritesIconUrl: aString 
	favoritesIconUrl := aString!

focusField: aString 
	focusField := aString!

generateOn: aStream 
	| str |
	aStream 
		nextPutAll: '<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>'.
	redirect notNil 
		ifTrue: 
			[aStream 
				nextPutAll: '<META http-equiv="refresh"  content="' 
						, (refreshTimeout isNil ifTrue: ['1'] ifFalse: [refreshTimeout asWebString]) , ';URL=' 
						, redirect , '"/>'].
	meta isNil ifFalse: [aStream nextPutAll: meta].
	charset isNil 
		ifFalse: 
			[aStream 
				nextPutAll: '<meta http-equiv="Content-Type" content="text/html; charset=' , charset , '"/>'].
	favoritesIconUrl isNil 
		ifFalse: [aStream nextPutAll: '<link rel="shortcut icon" href="' , favoritesIconUrl , '" />'].
	pageBackground notNil 
		ifTrue: 
			[aStream 
				nextPutAll: '<style type="text/css"> <!!-- body {  background-repeat: no-repeat; background-image:  url(' 
						, pageBackground , '?OpenImageResource)} --> </style>'].
	title isNil 
		ifFalse: 
			[aStream
				nextPutAll: '<title>';
				nextPutAll: title;
				nextPutAll: '</title>'].
	self scriptLinks isNilOrEmpty 
		ifFalse: 
			[self scriptLinks do: 
					[:eachUrl | 
					aStream 
						nextPutAll: '<script type="text/javascript" language="JavaScript" src="' , eachUrl , '"></script>']].
	stylesheet isNil 
		ifFalse: 
			[aStream
				nextPutAll: '<link rel="stylesheet" type="text/css" href="';
				nextPutAll: stylesheet;
				nextPutAll: '"/>'].
	style isNil 
		ifFalse: 
			[aStream
				nextPutAll: '<style type="text/css"><!!--
';
				nextPutAll: style;
				nextPutAll: '
-->
</style>'].
	script isNil 
		ifFalse: 
			[aStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: script;
				nextPutAll: HtmlElement javascriptEndString].
	aStream nextPutAll: '</head>'.
	framesetString isNilOrEmpty ifFalse: [aStream nextPutAll: framesetString].
	aStream nextPutAll: '<body'.
	self noScroll == true ifTrue: [aStream nextPutAll: ' scroll="no"'].
	marginHeight isNil ifFalse: [aStream nextPutAll: ' marginheight="' , marginHeight , '"'].
	marginWidth isNil ifFalse: [aStream nextPutAll: ' marginwidth="' , marginWidth , '"'].
	leftMargin isNil ifFalse: [aStream nextPutAll: ' leftmargin="' , leftMargin , '"'].
	topMargin isNil ifFalse: [aStream nextPutAll: ' topmargin="' , topMargin , '"'].
	rightMargin isNil ifFalse: [aStream nextPutAll: ' rightmargin="' , rightMargin , '"'].
	pageBackground notNil ifTrue: [aStream nextPutAll: ' background="' , pageBackground , '"'].
	bgColor notNil ifTrue: [aStream nextPutAll: ' bgcolor="' , bgColor , '"'].
	"reusing temp str for holding a reference to the current task or session (default task), but only if turned on"
	useSessionRefreshScriptBool == true 
		ifTrue: 
			[(str := Processor activeProcess webTask) isNil 
				ifTrue: [(str := self webSession) isNil ifFalse: [str := str defaultTask]].
			(str notNil and: [str respondsTo: #taskURLPrefix]) ifTrue: [str := str taskURLPrefix]].
	(str notNil or: [focusField notNil or: [onLoadScript notNil]]) 
		ifTrue: 
			["add onload handler"
			aStream nextPutAll: ' onload="'.
			str isNil 
				ifFalse: 
					[str := 'try{ITC.widget.SessionRefresher.getSingleton(''' , str , ''', ' 
								, Processor activeProcess webApplication defaultExpirationTime printString , ')'.
					aStream
						nextPutAll: str;
						nextPutAll: '.setSleepTimer()}catch(ex){};'].
			focusField notNil ifTrue: [aStream nextPutAll: 'document.f.' , focusField , '.focus();'].
			onLoadScript isNil ifFalse: [aStream nextPutAll: onLoadScript].
			aStream nextPut: $"].
	(str notNil or: [self class useGlobalKeyboardHandler]) 
		ifTrue: 
			["add onkeydown handler, str now includes session refresh javascript code"
			aStream
				nextPutAll: ' ';
				nextPutAll: ((self webRequest notNil and: [self webRequest isOpera]) 
							ifTrue: ['onkeypress']
							ifFalse: ['onkeydown']);
				nextPutAll: '="'.
			str isNil 
				ifFalse: 
					[aStream
						nextPutAll: str;
						nextPutAll: '.setLastKeyEventTime()}catch(ex){};'].
			self class useGlobalKeyboardHandler 
				ifTrue: 
					["this is only added if keyboard handlers are being used"
					aStream nextPutAll: 'if(self.itc_gkHandler){return itc_gkHandler(event);}else{return true;}'].
			aStream nextPut: $"].
	aStream nextPut: $>.

	"--- keyboard handling script ---"
	(self class useGlobalKeyboardHandler 
		and: [(str := HtmlPage getKeyboardHandlingScriptForTheCurrentPageOrRequest) isNilOrEmpty not]) 
			ifTrue: 
				[aStream
					nextPutAll: HtmlElement javascriptBeginString;
					nextPutAll: 'self.itc_gkHandler=function(ev)
{' , str , '};
';
					nextPutAll: HtmlElement javascriptEndString].
	"---"
	super generateOn: aStream.
	aStream nextPutAll: '</body></html>'!

isLandscape
	^landscapeBool = true!

isPortrait
	^self isLandscape not!

leftMargin: aStringOrNumber
	aStringOrNumber isString 
		ifTrue: [leftMargin := aStringOrNumber]
		ifFalse: [leftMargin := aStringOrNumber printString]!

marginHeight: aStringOrNumber
	aStringOrNumber isString 
		ifTrue: [marginHeight := aStringOrNumber]
		ifFalse: [marginHeight := aStringOrNumber printString]!

marginWidth: aStringOrNumber
	aStringOrNumber isString 
		ifTrue: [marginWidth := aStringOrNumber]
		ifFalse: [marginWidth := aStringOrNumber printString]!

meta: aString 
	meta := aString!

noScroll
	^noScroll == true!

noScroll: aBoolean 
	noScroll := aBoolean!

onLoadScript: aString 
	onLoadScript := aString!

pageBackground: aString 
	pageBackground := aString!

redirect: aStringOrNil 
	redirect := aStringOrNil!

refreshTimeout: anInteger 
	refreshTimeout := anInteger!

rightMargin: aStringOrNumber
	aStringOrNumber isString 
		ifTrue: [rightMargin := aStringOrNumber]
		ifFalse: [rightMargin := aStringOrNumber printString]!

script: aString 
	script := aString!

scriptLinks
	scriptLinks isNil ifTrue: [scriptLinks := OrderedCollection new].
	^scriptLinks!

scriptLinksAdd: anUrl 
	self scriptLinks detect: [:eachUrl | eachUrl = anUrl] ifNone: [self scriptLinks add: anUrl]!

setAllPageMarginsToZero
	marginHeight := marginWidth := leftMargin := topMargin := rightMargin := '0'!

setFramesetString: aString 
	framesetString := aString!

setLandscape
	landscapeBool := true!

setPageSizeToA4Wide
	self setLandscape!

style: aString 
	style := aString!

styleAdd: aString 
	"Add inline CSS stylesheet string to page which is being generated."

	style := style add: aString withDelimiter: '
'!

stylesheet: aString 
	stylesheet := aString!

title
	^title!

title: aString 
	title := aString!

topMargin: aStringOrNumber
	aStringOrNumber isString 
		ifTrue: [topMargin := aStringOrNumber]
		ifFalse: [topMargin := aStringOrNumber printString]! !
!HtmlPage categoriesFor: #addSessionRefreshOnKeyDownScript!accessing!public! !
!HtmlPage categoriesFor: #bgColor:!public! !
!HtmlPage categoriesFor: #charset:!public! !
!HtmlPage categoriesFor: #favoritesIconUrl!accessing!public! !
!HtmlPage categoriesFor: #favoritesIconUrl:!accessing!public! !
!HtmlPage categoriesFor: #focusField:!public! !
!HtmlPage categoriesFor: #generateOn:!public! !
!HtmlPage categoriesFor: #isLandscape!accessing!public! !
!HtmlPage categoriesFor: #isPortrait!accessing!public! !
!HtmlPage categoriesFor: #leftMargin:!public! !
!HtmlPage categoriesFor: #marginHeight:!public! !
!HtmlPage categoriesFor: #marginWidth:!public! !
!HtmlPage categoriesFor: #meta:!public! !
!HtmlPage categoriesFor: #noScroll!public! !
!HtmlPage categoriesFor: #noScroll:!public! !
!HtmlPage categoriesFor: #onLoadScript:!public! !
!HtmlPage categoriesFor: #pageBackground:!public! !
!HtmlPage categoriesFor: #redirect:!public! !
!HtmlPage categoriesFor: #refreshTimeout:!public! !
!HtmlPage categoriesFor: #rightMargin:!public! !
!HtmlPage categoriesFor: #script:!public! !
!HtmlPage categoriesFor: #scriptLinks!public! !
!HtmlPage categoriesFor: #scriptLinksAdd:!public! !
!HtmlPage categoriesFor: #setAllPageMarginsToZero!document generation!public! !
!HtmlPage categoriesFor: #setFramesetString:!public! !
!HtmlPage categoriesFor: #setLandscape!accessing!document generation!public! !
!HtmlPage categoriesFor: #setPageSizeToA4Wide!accessing!document generation!public! !
!HtmlPage categoriesFor: #style:!public! !
!HtmlPage categoriesFor: #styleAdd:!public! !
!HtmlPage categoriesFor: #stylesheet:!public! !
!HtmlPage categoriesFor: #title!public! !
!HtmlPage categoriesFor: #title:!public! !
!HtmlPage categoriesFor: #topMargin:!public! !

!HtmlPage class methodsFor!

getKeyboardCodeConditionFor: keyName 
	| ch |
	keyName size = 1 
		ifTrue: 
			[ch := (keyName at: 1) asInteger.
			(ch >= 48 and: [ch <= 57]) 
				ifTrue: 
					["digits 0 to 9"
					^'kc==' , ch printString]]
		ifFalse: 
			[keyName size = 2 
				ifTrue: 
					['F1' = keyName ifTrue: [^'kc==112'].
					'F2' = keyName ifTrue: [^'kc==113'].
					'F4' = keyName ifTrue: [^'kc==115'].
					'F8' = keyName ifTrue: [^'kc==119'].
					'F9' = keyName ifTrue: [^'kc==120']]
				ifFalse: 
					['Esc' = keyName ifTrue: [^'kc==27'].
					'Insert' = keyName ifTrue: [^'kc==45'].
					'InsertOrEnter' = keyName ifTrue: [^'kc==45 || kc==13'].
					'Enter' = keyName ifTrue: [^'kc==13'].
					'Left' = keyName ifTrue: [^'kc==37'].
					'Right' = keyName ifTrue: [^'kc==39'].
					'Home' = keyName ifTrue: [^'kc==36']]].
	ItcSystemManager isRuntime 
		ifFalse: [self error: 'Unknown keyboard key name ' , keyName printString].
	^nil!

getKeyboardHandlingScriptForKeyNamed: keyName javascriptAction: javascriptString 
	| condition |
	^(condition := self getKeyboardCodeConditionFor: keyName) isNil 
		ifTrue: ['']
		ifFalse: ['if(' , condition , '){ITC.event.StopEvent(e);' , javascriptString , 'return false;}']!

getKeyboardHandlingScriptForTheCurrentPageOrRequest
	| coll stream streamSinglePress streamCtrlPressed streamAltPressed streamShiftPressed keyName |
	coll := Processor activeProcess webHtmlPageKeyboardHandlersCollectorOrNil.
	stream := WriteStream on: String new.
	coll isNilOrEmpty 
		ifFalse: 
			[streamAltPressed := streamCtrlPressed := streamShiftPressed := streamSinglePress := nil.
			stream
				nextPutAll: 'var e=ITC.event.GetEvent(ev);';
				nextPutAll: 'var kc=ITC.event.GetCharCode(e);';
				nextPutAll: 'var callerEl=e.srcElement?e.srcElement:e.target;'.
			"For using Enter like Tab. For now leave it in separate method for development reasons."
			self getKeyboardHandlingScriptForTheCurrentPageOrRequestEnterScriptOn: stream.
			coll do: 
					[:eachAssociation | 
					keyName := eachAssociation key asString.
					(keyName beginsWith: 'BrowserKeyAlt') 
						ifTrue: 
							[streamAltPressed isNil ifTrue: [streamAltPressed := WriteStream on: String new].
							streamAltPressed nextPutAll: (self getKeyboardHandlingScriptForKeyNamed: (keyName copyFrom: 14)
										javascriptAction: eachAssociation value)]
						ifFalse: 
							[(keyName beginsWith: 'BrowserKeyCtrl') 
								ifTrue: 
									[streamCtrlPressed isNil ifTrue: [streamCtrlPressed := WriteStream on: String new].
									streamCtrlPressed nextPutAll: (self getKeyboardHandlingScriptForKeyNamed: (keyName copyFrom: 15)
												javascriptAction: eachAssociation value)]
								ifFalse: 
									[(keyName beginsWith: 'BrowserKeyShift') 
										ifTrue: 
											[streamShiftPressed isNil ifTrue: [streamShiftPressed := WriteStream on: String new].
											streamShiftPressed nextPutAll: (self getKeyboardHandlingScriptForKeyNamed: (keyName copyFrom: 16)
														javascriptAction: eachAssociation value)]
										ifFalse: 
											[streamSinglePress isNil ifTrue: [streamSinglePress := WriteStream on: String new].
											streamSinglePress nextPutAll: (self getKeyboardHandlingScriptForKeyNamed: (keyName copyFrom: 11)
														javascriptAction: eachAssociation value)]]]].
			streamAltPressed isNil 
				ifFalse: 
					[stream
						nextPutAll: 'if(e.altKey&&!!e.ctrlKey&&!!e.shiftKey){';
						nextPutAll: streamAltPressed contents;
						nextPutAll: '};'].
			streamCtrlPressed isNil 
				ifFalse: 
					[stream
						nextPutAll: 'if(!!e.altKey&&e.ctrlKey&&!!e.shiftKey){';
						nextPutAll: streamCtrlPressed contents;
						nextPutAll: '};'].
			streamShiftPressed isNil 
				ifFalse: 
					[stream
						nextPutAll: 'if(!!e.altKey&&!!e.ctrlKey&&e.shiftKey){';
						nextPutAll: streamShiftPressed contents;
						nextPutAll: '};'].
			streamSinglePress isNil 
				ifFalse: 
					[stream
						nextPutAll: 'if(!!e.altKey&&!!e.ctrlKey&&!!e.shiftKey){';
						nextPutAll: streamSinglePress contents;
						nextPutAll: '};']].
	stream 
		nextPutAll: 'if(window.parent&&window.parent!!=window){if(window.parent.itc_gkHandler){if(window.parent.itc_gkHandler(ev)==false)return false}else{if(window.parent.parent&&window.parent.parent!!=window.parent&&window.parent.parent.itc_gkHandler){if(window.parent.parent.itc_gkHandler(ev)==false)return false}}};'.
	^stream contents!

getKeyboardHandlingScriptForTheCurrentPageOrRequestEnterScriptOn: stream 
	"For using Enter like Tab. Can use variables #e - event, #kc - key code, #callerEl - element on which event is called."

	| session |
	((session := self webSession) notNil and: [session useEnterForTabbing == true]) 
		ifFalse: 
			[stream nextPutAll: 'if(kc==13&&callerEl.type==''textarea'')return true;'.
			^nil].
	stream 
		nextPutAll: 
			[JavaScriptMinifier 
				minify: '
if(kc==13 && !!e.altKey && !!e.ctrlKey && !!e.shiftKey)
{
	var elForm = ITC.dom.FindParentFormFor(callerEl);
	if (elForm)
	{
		var elColl = elForm.getElementsByTagName(''*'');
		if(callerEl.tabIndex > 0)
		{
			var nextInd = callerEl.tabIndex + 1;
			for(i=0;i<elColl.length;i++)
			{
				if(elColl[i].tabIndex == nextInd)
				{
					elColl[i].focus();
					if (elColl[i].select) elColl[i].select();
					return false;
				}
			};

			for(i=0;i<elColl.length;i++)
			{
				if(elColl[i].tabIndex > nextInd)
				{
					elColl[i].focus();
					if (elColl[i].select) elColl[i].select();
					return false;
				}
			};
		}
		else
		{
			var found = false, elType, currEl;

			for(i=0;i<elColl.length;i++)
			{
				currEl = elColl[i];
				elType = currEl.type;
				if(found)
				{
					if(!!currEl.disabled && !!currEl.readOnly && (elType == ''text'' || elType == ''password'' || elType == ''textarea'' || elType == ''checkbox'' || elType == ''radio'' || elType == ''select-one'' || elType == ''select-multiple'') && ITC.util.IsVisible(currEl))
					{
						currEl.focus();
						if (currEl.select) currEl.select();
						return false;
					};
					if(elType == ''image'' && currEl.id && currEl.id.substr(0,12) == ''el_ExtJSGrid'' && currEl.id.substr(currEl.id.length-9,9) == ''_focusImg'')
					{
						currEl.focus();
						if (currEl.select) currEl.select();
						return false;
					};
				};
				if(!!found && currEl == callerEl) found = true;
			};
		}
	}
	else
	{
		if(callerEl.tagName == ''INPUT'' && callerEl.id && callerEl.id.substr(0,9) == ''ext-comp-'') return true;
	}
};'] 
					cachedValue!

javascriptForUrl: urlString 
	| str |
	^(urlString beginsWith: 'javascript:') 
		ifTrue: 
			[str := urlString copyFrom: 'javascript:' size + 1.
			((str endsWith: 'void(0);') and: [str size > 8]) 
				ifTrue: [str copyFrom: 1 to: str size - 8]
				ifFalse: [str]]
		ifFalse: ['window.location=' , urlString asJavascriptValue , ';']!

onKey: aSymbol add: javascriptString 
	"Defines multiple actions for same symbol."

	| def |
	(def := Processor activeProcess webHtmlPageKeyboardHandlersCollector 
				detect: [:each | each key == aSymbol]
				ifNone: 
					[self onKey: aSymbol do: javascriptString.
					nil]) isNil 
		ifFalse: 
			[Processor activeProcess webHtmlPageKeyboardHandlersCollector remove: def.

			"Add script to already defined action. It adds later defined scripts first to be executed."
			self onKey: def key add: javascriptString , def value]!

onKey: aSymbol add: javascriptString delayFurtherFor: aInteger 
	"Defines multiple actions for same symbol."

	| def |
	(def := Processor activeProcess webHtmlPageKeyboardHandlersCollector 
				detect: [:each | each key == aSymbol]
				ifNone: 
					[self onKey: aSymbol do: javascriptString.
					nil]) isNil 
		ifFalse: 
			[Processor activeProcess webHtmlPageKeyboardHandlersCollector remove: def.

			"Add script to already defined action. It adds later defined scripts first to be executed."
			self onKey: def key
				add: javascriptString , 'setTimeout(function(){' , def value , '}, ' , aInteger printString , ');']!

onKey: aSymbol do: javascriptString 
	self 
		onKey: aSymbol
		do: javascriptString
		replaceOldDef: false!

onKey: aSymbol do: javascriptString replaceOldDef: replaceDefBool 
	"Set action defined with #javascriptString to be executed on #aSymbol action.
If #replaceDefBool is set to true, all previously defined actions for #aSymbol will be replaced with new one.
If #replaceDefBool is set to false, action is set only if previous does not exsist.
Condition (javascriptString isNilOrEmpty and: [replaceDefBool]) can be used to remove already defined action from the page handler collection."
	| oldDef handlerColl |
	useGlobalKeyboardHandlerBool := true.
	handlerColl := Processor activeProcess webHtmlPageKeyboardHandlersCollector.
	oldDef := handlerColl detect: [:each | each key == aSymbol] ifNone: [].
	oldDef isNil 
		ifTrue: 
			[javascriptString isNilOrEmpty 
				ifFalse: [handlerColl add: (Association key: aSymbol value: javascriptString)]]
		ifFalse: 
			[replaceDefBool 
				ifTrue: 
					[handlerColl remove: oldDef.
					javascriptString isNilOrEmpty 
						ifFalse: [handlerColl add: (Association key: aSymbol value: javascriptString)]]]!

onKey: aSymbol gotoUrl: urlString 
	self onKey: aSymbol do: (self javascriptForUrl: urlString)!

onKey: aSymbol gotoUrl: urlString onClickDo: javascriptString 
	self onKey: aSymbol do: (javascriptString add: (self javascriptForUrl: urlString) withDelimiter: '')!

onKey: aSymbol gotoUrl: urlString target: targetWindowName 
	self onKey: aSymbol
		do: 'window.frames[' , targetWindowName asJavascriptValue , '].location=' 
				, urlString asJavascriptValue , ';'!

onKey: aSymbol task: aWebTask action: actionSymbolOrString 
	^self 
		onKey: aSymbol
		task: aWebTask
		action: actionSymbolOrString
		replaceOldDef: false!

onKey: aSymbol task: aWebTask action: actionSymbolOrString replaceOldDef: replaceDefBool 
	self 
		onKey: aSymbol
		do: (self javascriptForUrl: (aWebTask class 
						generateUrlPrefixStringFor: aWebTask taskURLPrefix
						action: actionSymbolOrString
						id: nil
						convertAjaxActionToScript: true))
		replaceOldDef: replaceDefBool.
	^true!

onKey: aSymbol task: aWebTask action: actionSymbolOrString replaceOldDef: replaceDefBool openInNewWindow: openInNewWindow 
	self 
		onKey: aSymbol
		do: (self javascriptForUrl: (aWebTask class 
						generateUrlPrefixStringFor: aWebTask taskURLPrefix
						action: actionSymbolOrString
						id: nil
						convertAjaxActionToScript: true
						openInNewWindow: openInNewWindow))
		replaceOldDef: replaceDefBool.
	^true!

title: aString

	^self new title: aString!

useGlobalKeyboardHandler
	^useGlobalKeyboardHandlerBool == true!

useGlobalKeyboardHandler: aBoolean 
	useGlobalKeyboardHandlerBool := aBoolean! !
!HtmlPage class categoriesFor: #getKeyboardCodeConditionFor:!keyboard handling!private! !
!HtmlPage class categoriesFor: #getKeyboardHandlingScriptForKeyNamed:javascriptAction:!keyboard handling!private! !
!HtmlPage class categoriesFor: #getKeyboardHandlingScriptForTheCurrentPageOrRequest!keyboard handling!public! !
!HtmlPage class categoriesFor: #getKeyboardHandlingScriptForTheCurrentPageOrRequestEnterScriptOn:!keyboard handling!private! !
!HtmlPage class categoriesFor: #javascriptForUrl:!keyboard handling!private! !
!HtmlPage class categoriesFor: #onKey:add:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:add:delayFurtherFor:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:do:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:do:replaceOldDef:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:gotoUrl:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:gotoUrl:onClickDo:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:gotoUrl:target:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:task:action:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:task:action:replaceOldDef:!keyboard handling!public! !
!HtmlPage class categoriesFor: #onKey:task:action:replaceOldDef:openInNewWindow:!keyboard handling!public! !
!HtmlPage class categoriesFor: #title:!instance creation!public! !
!HtmlPage class categoriesFor: #useGlobalKeyboardHandler!keyboard handling!public! !
!HtmlPage class categoriesFor: #useGlobalKeyboardHandler:!keyboard handling!public! !

