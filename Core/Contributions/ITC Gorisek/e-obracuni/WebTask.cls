"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebTask
	instanceVariableNames: 'application lastRequestTime superTask session taskId dummyCounter taskInactivated parentTopNavigation requestMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebTask guid: (GUID fromString: '{DB798156-A4C3-41FF-AA2B-D932157A5586}')!
WebTask comment: ''!
!WebTask categoriesForClass!Unclassified! !
!WebTask methodsFor!

ajaxGetSessionRefresh
	"Called from ITC.widget.SessionRefresher. Used for simple session refreshing, triggered by sleep timer."

	| fromJsEventTime newRequestTime |
	(fromJsEventTime := self webRequest getIntegerId) isNil 
		ifFalse: [newRequestTime := session getLastRequestTime - (fromJsEventTime / 1000) rounded].
	newRequestTime > 0 
		ifTrue: 
			[session lastRequestTime: newRequestTime.
			self lastRequestTime: newRequestTime].
	"Timer is setted in AJAX response, becouse we need to set it for each AJAX action, as they set last request time."
	self putAjaxResultsForNoAction!

ajaxJavascriptFragmentForErrorMessage: errorDescription 
	^'window.alert(' 
		, ('asp.error.RuntimeErrorMessageWithDescription' webTranslateWith: errorDescription) 
				asJavascriptValue 
			, ');'!

application
	^application!

becomeInactive
	taskInactivated := true.
	"set last request time so that this task will get removed in 3 minutes from now"
	lastRequestTime := ItcSystemManager absoluteSecondsClockValue 
				- application maxInactivityTime + (3 * 60)!

dispatch: request action: aString on: stream 
	| action methodSelector |
	action := aString webAsActionString copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	action at: 1 put: (action at: 1) asUppercase.
	session tracer isNil ifFalse: [self traceLog: action].
	methodSelector := ('process' , action , ':on:') asSymbol.
	(self respondsTo: methodSelector) 
		ifTrue: 
			[^self 
				perform: methodSelector
				with: request
				with: stream].
	methodSelector := ('process' , action) asSymbol.
	(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector].
	(self newCoder: stream) unsupportedActionPage: action!

dispatch: request action: aString using: possibleActions on: stream withDefault: defaultAction 
	| action methodSelector |
	action := aString copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	(possibleActions includes: action) ifFalse: [action := defaultAction copy].
	action isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	(self newCoder: stream) unsupportedActionPage: action!

dispatch: request on: stream 
	| action methodSelector |
	(self 
		dispatchAjaxAction: request action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	action := request action.
	action isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	(self respondsTo: #processDefault) ifTrue: [^self processDefault].
	(self respondsTo: #processDefault:on:) ifTrue: [^self processDefault: request on: stream].
	(self newCoder: stream) unsupportedActionPage: action!

dispatch: request using: possibleActions on: stream 
	| action methodSelector |
	action := request action copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	(possibleActions detect: [:eachAction | eachAction webAsActionString = action] ifNone: []) isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	(self newCoder: stream) unsupportedActionPage: action!

dispatch: request using: possibleActions on: stream ifInactive: inactiveAction 
	| action methodSelector |
	self isActive 
		ifTrue: [action := request action copy]
		ifFalse: [action := inactiveAction webAsActionString copy].
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	(possibleActions detect: [:eachAction | eachAction webAsActionString = action] ifNone: []) isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	(self newCoder: stream) unsupportedActionPage: action!

dispatch: request using: possibleActions on: stream ifNone: aBlock 
	| action methodSelector |
	action := request action copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	(possibleActions detect: [:eachAction | eachAction webAsActionString = action] ifNone: []) isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	^aBlock value!

dispatch: request using: possibleActions on: stream withDefault: defaultAction 
	| action methodSelector |
	action := request action copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: nil) ifTrue: [^self].
	possibleActions detect: [:eachAction | eachAction webAsActionString = action]
		ifNone: [action := defaultAction copy webAsActionString].
	action isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[^self 
						perform: methodSelector
						with: request
						with: stream].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) ifTrue: [^self perform: methodSelector]].
	(self newCoder: stream) unsupportedActionPage: action!

dispatchAjaxAction: action request: request on: stream useMutex: mutexToUse 
	"Process AJAX requests which expect javascript to be returned as a response.
	An AJAX request for Javascript always begins with prefix #ajaxGet... or #ajaxPost...
	Answer <true> if an AJAX request was processed, else <false> for regular HTTP actions.
	"

	| methodSelector |
	action isNilOrEmpty ifTrue: [^false].
	(action beginsWith: 'ajaxSnippet') 
		ifTrue: 
			[^self 
				dispatchAjaxCodeSnippetAction: action
				request: request
				on: stream
				useMutex: mutexToUse].
	((action beginsWith: 'ajaxGet') or: [action beginsWith: 'ajaxPost']) ifFalse: [^false].
	"mark that this process is responding to an Ajax request for javascript code"
	Processor activeProcess webProcessingAjaxRequest: true.
	session tracer isNil ifFalse: [self traceLog: action].
	methodSelector := action asSymbol.
	(self respondsTo: methodSelector) 
		ifTrue: 
			[mutexToUse notNil 
				ifTrue: [mutexToUse critical: [self perform: methodSelector]]
				ifFalse: [self perform: methodSelector].
			^true].
	methodSelector := (action , ':on:') asSymbol.
	(self respondsTo: methodSelector) 
		ifTrue: 
			[mutexToUse notNil 
				ifTrue: 
					[mutexToUse critical: 
							[self 
								perform: methodSelector
								with: request
								with: stream]]
				ifFalse: 
					[self 
						perform: methodSelector
						with: request
						with: stream].
			^true].
	ItcSystemManager 
		logLineWithTsAndSession: 'AJAX action not supported: ' , self class printString , '>> ' 
				, action printString.
	self putAjaxResultsMessageBox: 'Action *' , action asWebString 
				, '* is not supported in the current context.'.
	^true!

dispatchAjaxCodeSnippetAction: action request: request on: stream useMutex: mutexToUse 
	"Process AJAX snippet requests which expect snippets of HTML code to be returned as a response.
	An AJAX request always begins with prefix #ajaxSnippet...
	Answer <true> if an AJAX snippet request was processed, else <false>.
	"

	"mark that this process is responding to an Ajax request for HTML code snippet"

	| methodSelector onLoadScript oldHttpStream newHttpStream |
	Processor activeProcess webProcessingAjaxCodeSnippetRequest: true.
	action at: 1 put: (action at: 1) asUppercase.
	methodSelector := ('process' , action) asSymbol.
	oldHttpStream := stream.
	oldHttpStream setNoCache.
	newHttpStream := WebHttpStream new on: (WriteStream on: String new).
	(self respondsTo: methodSelector) 
		ifTrue: 
			[Processor activeProcess webStream: newHttpStream.
			mutexToUse notNil 
				ifTrue: [mutexToUse critical: [self perform: methodSelector]]
				ifFalse: [self perform: methodSelector]]
		ifFalse: 
			[methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[Processor activeProcess webStream: newHttpStream.
					mutexToUse notNil 
						ifTrue: 
							[mutexToUse critical: 
									[self 
										perform: methodSelector
										with: request
										with: newHttpStream]]
						ifFalse: 
							[self 
								perform: methodSelector
								with: request
								with: newHttpStream]]
				ifFalse: 
					[(self newCoder: stream) unsupportedActionPage: action.
					^true]].
	(onLoadScript := Processor activeProcess webAjaxRequestJavascriptOnLoadCollectorContentsOrNil) 
		isNilOrEmpty 
			ifFalse: 
				[newHttpStream
					nextPutAll: '<script type="text/javascript" language="JavaScript">';
					nextPutAll: onLoadScript;
					nextPutAll: '
</script>'].
	oldHttpStream contentType: 'text/html; charset=utf-8'.
	oldHttpStream nextPutAll: newHttpStream contents asUTF8.
	Processor activeProcess webStream: oldHttpStream.
	^true!

dispatchWithMutex: request on: stream 
	| m |
	(m := requestMutex) isNil ifTrue: [requestMutex := m := Semaphore forMutualExclusion].
	(self 
		dispatchAjaxAction: request action
		request: request
		on: stream
		useMutex: m) ifFalse: [(self newCoder: stream) unsupportedActionPage: request action]!

dispatchWithMutex: request using: possibleActions on: stream 
	| action methodSelector m |
	(m := requestMutex) isNil ifTrue: [requestMutex := m := Semaphore forMutualExclusion].
	action := request action copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: m) ifTrue: [^self].
	(possibleActions detect: [:eachAction | eachAction webAsActionString = action] ifNone: []) isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[m critical: 
							[self 
								perform: methodSelector
								with: request
								with: stream].
					^self].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[m critical: [self perform: methodSelector].
					^self]].
	(self newCoder: stream) unsupportedActionPage: action!

dispatchWithMutex: request using: possibleActions on: stream withDefault: defaultAction 
	| action methodSelector m |
	(m := requestMutex) isNil ifTrue: [requestMutex := m := Semaphore forMutualExclusion].
	action := request action copy.
	(self 
		dispatchAjaxAction: action
		request: request
		on: stream
		useMutex: m) ifTrue: [^self].
	possibleActions detect: [:eachAction | eachAction webAsActionString = action]
		ifNone: [action := defaultAction webAsActionString copy].
	action isNil 
		ifFalse: 
			[action at: 1 put: (action at: 1) asUppercase.
			session tracer isNil ifFalse: [self traceLog: action].
			methodSelector := ('process' , action , ':on:') asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[m critical: 
							[self 
								perform: methodSelector
								with: request
								with: stream].
					^self].
			methodSelector := ('process' , action) asSymbol.
			(self respondsTo: methodSelector) 
				ifTrue: 
					[m critical: [self perform: methodSelector].
					^self]].
	(self newCoder: stream) unsupportedActionPage: action!

doesNotUnderstand: failedMessage 
	| selector |
	((selector := failedMessage selector asString) beginsWith: 'process') 
		ifTrue: 
			[(selector includes: $:) 
				ifTrue: 
					[selector := (selector upTo: $:) asSymbol.
					(self respondsTo: selector) ifTrue: [^self perform: selector]]
				ifFalse: 
					[selector := (selector , ':on:') asSymbol.
					(self respondsTo: selector) 
						ifTrue: 
							[^self 
								perform: selector
								with: self webRequest
								with: self webStream]]].
	^super doesNotUnderstand: failedMessage!

elapsedTimeSince: newTime 
	lastRequestTime isNil ifTrue: [^nil].
	lastRequestTime == false ifTrue: [^nil].
	^newTime - lastRequestTime!

initialize
	"This method is sent when task object is created."

	!

isActive
	^taskInactivated isNil!

lastRequestTime
	^lastRequestTime!

lastRequestTime: anInteger 
	"persistent tasks do not expire"

	lastRequestTime == false ifFalse: [lastRequestTime := anInteger]!

onTaskRemoved
	"Private - This method is sent when task is removed.
	It can be sent more than once."

	!

parentTopNavigation
	^parentTopNavigation!

parentTopNavigation: anObject
	parentTopNavigation := anObject!

printOn: aStream 
	| time |
	aStream
		nextPutAll: 'Task:';
		nextPutAll: self class printString;
		nextPutAll: ' (';
		nextPutAll: (self isActive ifTrue: ['active'] ifFalse: ['inactive']).
	(time := self elapsedTimeSince: ItcSystemManager absoluteSecondsClockValue) notNil 
		ifTrue: 
			[time := application maxInactivityTime - time.
			time < 0 ifTrue: [time := 0].
			aStream 
				nextPutAll: ';remaining=' , (time // 60) printString , ':' , (time \\ 60) printString 
						, 's'].
	aStream nextPutAll: ')'!

printWebUrlOn: aStream 
	aStream
		nextPutAll: 'WOB-';
		nextPutAll: session sessionId;
		nextPut: $-;
		nextPutAll: taskId;
		nextPut: $-;
		nextPutAll: (dummyCounter := dummyCounter + 1) printString;
		nextPutAll: self urlExtension!

process: request on: stream 
	self subclassResponsibility!

processGet: request on: stream 
	self process: request on: stream!

processPost: request on: stream 
	self process: request on: stream!

putAjaxResults: results 
	^self 
		putAjaxResults: results
		isFrameRequest: (self webRequest booleanAt: 'isFrame')
		on: self webStream!

putAjaxResults: results isFrameRequest: isFrameRequest on: stream 
	stream putAjaxResults: results isFrameRequest: isFrameRequest!

putAjaxResults: results on: stream 
	^self 
		putAjaxResults: results
		isFrameRequest: (self webRequest booleanAt: 'isFrame')
		on: stream!

putAjaxResultsClosePopUpsAndRedirectToTask: aWebTask 
	"Close pop up windows and send an AJAX javascript request to redirect page to a new task.
	
	"

	^self putAjaxResults: 'if(AllDialogBoxes)basicCloseAllDialogBoxes();document.location.href=' 
				, aWebTask taskURLPrefix asJavascriptValue!

putAjaxResultsConfirmationDialog: message title: title confirmButtonLabel: confirmButtonLabel onConfirmAction: onConfirmAction hiddenId: hiddenId 
	^self 
		putAjaxResultsConfirmationDialog: message
		title: title
		confirmButtonLabel: confirmButtonLabel
		onConfirmAction: onConfirmAction
		onCancelAction: nil
		hiddenId: hiddenId
		showWaitAfterConfirmation: nil!

putAjaxResultsConfirmationDialog: message title: title confirmButtonLabel: confirmButtonLabel onConfirmAction: onConfirmAction hiddenId: hiddenId showWaitAfterConfirmation: aBoolean 
	^self 
		putAjaxResultsConfirmationDialog: message
		title: title
		confirmButtonLabel: confirmButtonLabel
		onConfirmAction: onConfirmAction
		onCancelAction: nil
		hiddenId: hiddenId
		showWaitAfterConfirmation: aBoolean!

putAjaxResultsConfirmationDialog: message title: title confirmButtonLabel: confirmButtonLabel onConfirmAction: onConfirmAction onCancelAction: onCancelAction hiddenId: hiddenId 
	^self 
		putAjaxResultsConfirmationDialog: message
		title: title
		confirmButtonLabel: confirmButtonLabel
		onConfirmAction: onConfirmAction
		onCancelAction: onCancelAction
		hiddenId: hiddenId
		showWaitAfterConfirmation: nil!

putAjaxResultsConfirmationDialog: message title: title confirmButtonLabel: confirmButtonLabel onConfirmAction: onConfirmAction onCancelAction: onCancelAction hiddenId: hiddenId showWaitAfterConfirmation: showWaitBoolean 
	| confirmAction cancelAction ws |
	confirmAction := onConfirmAction webAsActionString.
	cancelAction := onCancelAction webAsActionString.
	ws := WriteStream on: (String new: 1024).
	ws
		nextPutAll: 'if(confirm(';
		nextPutAll: message webTranslate webRemoveHtmlFormatting asJavascriptValue;
		nextPutAll: ')!!=''0'') {';
		nextPutAll: (showWaitBoolean = true ifTrue: ['ITC.widget.WaitClock.Show();'] ifFalse: ['']);
		nextPutAll: (confirmAction isAjaxAction 
					ifTrue: ['ajaxGetRequest(']
					ifFalse: ['document.location.href=']);
		nextPutAll: (self taskURLPrefixForAction: confirmAction id: hiddenId) asJavascriptValue;
		nextPut: (confirmAction isAjaxAction 
					ifTrue: 
						[ws nextPut: $).
						$}]
					ifFalse: [$}]).
	cancelAction notNil 
		ifTrue: 
			[ws
				nextPutAll: ' else {';
				nextPutAll: (cancelAction isAjaxAction 
							ifTrue: ['ajaxGetRequest(']
							ifFalse: ['document.location.href=']);
				nextPutAll: (self taskURLPrefixForAction: cancelAction id: hiddenId) asJavascriptValue;
				nextPut: (cancelAction isAjaxAction 
							ifTrue: 
								[ws nextPut: $).
								$}]
							ifFalse: [$}])].
	ws nextPut: $;.
	self putAjaxResults: ws contents!

putAjaxResultsForAccessDenied
	self 
		putAjaxResults: 'window.alert(' , 'error.PageAccessDenied' webTranslate asJavascriptValue , ');'!

putAjaxResultsForCloseAllDialogBoxes
	^self putAjaxResults: 'closeAllDialogBoxes();'!

putAjaxResultsForCloseAllDialogBoxesFollowedBySetFocusTo: fieldName 
	^self 
		putAjaxResults: 'basicCloseAllDialogBoxes();document.' 
				, Processor activeProcess webCoderDefaultFormName , '.' 
				, fieldName asString , '.focus();'!

putAjaxResultsForCloseTopDialogBox
	^self putAjaxResults: 'closeTopDialogBox();'!

putAjaxResultsForNoAction
	^self putAjaxResults: 'null'!

putAjaxResultsIntoDiv: divId coder: aHtmlCoder 
	self 
		putAjaxResults: 'ITC.dom.GetElement("' , divId , '").innerHTML=' , aHtmlCoder ajaxHtmlFragment , ';'!

putAjaxResultsIntoDiv: divId coder: aHtmlCoder focusField: fieldName 
	fieldName isNil ifTrue: [^self putAjaxResultsIntoDiv: divId coder: aHtmlCoder].
	self 
		putAjaxResults: 'ITC.dom.GetElement("' , divId , '").innerHTML=' , aHtmlCoder ajaxHtmlFragment 
				, ';document.' , Processor activeProcess webCoderDefaultFormName 
				, '.' , fieldName asString 
				, '.focus();'!

putAjaxResultsIntoDiv: divId htmlContents: aString 
	self 
		putAjaxResults: 'ITC.dom.GetElement("' , divId , '").innerHTML=' , aString asJavascriptValue , ';'!

putAjaxResultsMessageBox: aMessage 
	^self 
		putAjaxResults: 'window.alert(' , aMessage webTranslate webRemoveHtmlFormatting asJavascriptValue 
				, ')'!

putAjaxResultsMessageBox: aMessage followedBySetFocusTo: fieldName 
	^self 
		putAjaxResults: 'window.alert(' , aMessage webTranslate webRemoveHtmlFormatting asJavascriptValue 
				, ');document.' , Processor activeProcess webCoderDefaultFormName 
				, '.' , fieldName asString 
				, '.focus();'!

putAjaxResultsMessageBoxFollowedByAllDialogsClose: aMessage 
	"Use basicCloseAllDialogBoxes(). If closeAllDialogBoxes() is used close() initiates onClose defined action, we don't need that, just close boxes."

	^self 
		putAjaxResults: 'window.alert(' , aMessage webTranslate webRemoveHtmlFormatting asJavascriptValue 
				, ');basicCloseAllDialogBoxes();'!

putAjaxResultsRedirectToTask: aWebTask 
	"Sends an AJAX javascript request to redirect page to a new task.
	If used in IE, then explicitly dispose all pop up dialog boxes to avoid memory leaks.
	"

	^self 
		putAjaxResults: (self webRequest isInternetExplorer 
				ifTrue: ['if(AllDialogBoxes)basicCloseAllDialogBoxes();']
				ifFalse: ['']) , '
document.location.href=' 
				, aWebTask taskURLPrefix asJavascriptValue!

putAjaxResultsRedirectToTask: aWebTask action: action 
	"Sends an AJAX javascript request to redirect page to a new task.
	If used in IE, then explicitly dispose all pop up dialog boxes to avoid memory leaks.
	"

	^self 
		putAjaxResults: (self webRequest isInternetExplorer 
				ifTrue: ['if(AllDialogBoxes)basicCloseAllDialogBoxes();']
				ifFalse: ['']) , '
document.location.href=' 
				, (aWebTask taskURLPrefixForAction: action) asJavascriptValue!

putAjaxResultsRedirectToUrl: aString 
	"Sends an AJAX javascript request to redirect page to a new URL.
	If used in IE, then explicitly dispose all pop up dialog boxes to avoid memory leaks.
	"

	^self 
		putAjaxResults: (self webRequest isInternetExplorer 
				ifTrue: ['if(AllDialogBoxes)closeAllDialogBoxes();']
				ifFalse: ['']) , '
document.location.href=' 
				, aString asJavascriptValue!

putAjaxResultsRedirectToUrlInNewWindow: aString 
	^self 
		putAjaxResults: 'if(AllDialogBoxes)closeAllDialogBoxes();window.open(''' 
				, aString webJavascriptStringEncoded , ''', ''_blank'');'!

session
	^session!

sessionURLPrefix
	| stream |
	^session defaultTask isNil 
		ifFalse: 
			[stream := WriteStream on: (String new: 128).
			stream
				nextPut: $/;
				nextPutAll: application urlPrefix;
				nextPut: $/.
			session defaultTask printWebUrlOn: stream.
			stream contents]!

setApplication: aWebApplication 
	application := aWebApplication!

setApplication: aWebApplication session: aWebSession 
	application := aWebApplication.
	session := aWebSession.
	taskId := ''.
	dummyCounter := 0.
	self initialize!

setApplication: aWebApplication session: aWebSession taskId: aString 
	application := aWebApplication.
	session := aWebSession.
	taskId := aString.
	dummyCounter := 0.
	self initialize!

superTask
	^superTask!

superTask: aTask 
	superTask := aTask!

taskId
	^taskId!

taskUrl
	| stream |
	stream := WriteStream on: (String new: 128).
	self printWebUrlOn: stream.
	^stream contents!

taskURLPrefix
	| stream |
	stream := WriteStream on: (String new: 128).
	stream nextPutAll: '/' , application urlPrefix , '/'.
	self printWebUrlOn: stream.
	^stream contents!

taskURLPrefixForAction: aStringOrSymbol 
	^WebTask 
		generateUrlPrefixStringFor: self taskURLPrefix
		action: aStringOrSymbol
		id: nil
		convertAjaxActionToScript: false!

taskURLPrefixForAction: aStringOrSymbol id: anObject 
	^WebTask 
		generateUrlPrefixStringFor: self taskURLPrefix
		action: aStringOrSymbol
		id: anObject
		convertAjaxActionToScript: false!

taskURLPrefixForAction: aStringOrSymbol id: anObject filenamePostfix: filenamePostfix 
	^WebTask 
		generateUrlPrefixStringFor: self taskURLPrefix
		action: aStringOrSymbol
		id: anObject
		convertAjaxActionToScript: false
		filenamePostfix: filenamePostfix!

traceLog: action 
	session tracer 
		nextPutAll: Timestamp now asFilenameString , ': tracing ' , self class printString , '->' 
				, action , '
'!

urlExtension
	^'.html'!

urlPrefixForAction: aStringOrSymbol 
	^WebTask 
		generateUrlPrefixStringFor: self taskURLPrefix
		action: aStringOrSymbol
		id: nil
		convertAjaxActionToScript: true!

urlPrefixForAction: aStringOrSymbol id: anObject 
	^WebTask 
		generateUrlPrefixStringFor: self taskURLPrefix
		action: aStringOrSymbol
		id: anObject
		convertAjaxActionToScript: true! !
!WebTask categoriesFor: #ajaxGetSessionRefresh!public! !
!WebTask categoriesFor: #ajaxJavascriptFragmentForErrorMessage:!accessing!ajax support!public! !
!WebTask categoriesFor: #application!public! !
!WebTask categoriesFor: #becomeInactive!public! !
!WebTask categoriesFor: #dispatch:action:on:!private! !
!WebTask categoriesFor: #dispatch:action:using:on:withDefault:!private! !
!WebTask categoriesFor: #dispatch:on:!private! !
!WebTask categoriesFor: #dispatch:using:on:!private! !
!WebTask categoriesFor: #dispatch:using:on:ifInactive:!private! !
!WebTask categoriesFor: #dispatch:using:on:ifNone:!private! !
!WebTask categoriesFor: #dispatch:using:on:withDefault:!private! !
!WebTask categoriesFor: #dispatchAjaxAction:request:on:useMutex:!ajax support!private! !
!WebTask categoriesFor: #dispatchAjaxCodeSnippetAction:request:on:useMutex:!ajax support!private! !
!WebTask categoriesFor: #dispatchWithMutex:on:!private! !
!WebTask categoriesFor: #dispatchWithMutex:using:on:!private! !
!WebTask categoriesFor: #dispatchWithMutex:using:on:withDefault:!private! !
!WebTask categoriesFor: #doesNotUnderstand:!public! !
!WebTask categoriesFor: #elapsedTimeSince:!public! !
!WebTask categoriesFor: #initialize!public! !
!WebTask categoriesFor: #isActive!public! !
!WebTask categoriesFor: #lastRequestTime!public! !
!WebTask categoriesFor: #lastRequestTime:!public! !
!WebTask categoriesFor: #onTaskRemoved!private! !
!WebTask categoriesFor: #parentTopNavigation!accessing!public! !
!WebTask categoriesFor: #parentTopNavigation:!accessing!public! !
!WebTask categoriesFor: #printOn:!public! !
!WebTask categoriesFor: #printWebUrlOn:!public! !
!WebTask categoriesFor: #process:on:!public! !
!WebTask categoriesFor: #processGet:on:!public! !
!WebTask categoriesFor: #processPost:on:!public! !
!WebTask categoriesFor: #putAjaxResults:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResults:isFrameRequest:on:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResults:on:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsClosePopUpsAndRedirectToTask:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsConfirmationDialog:title:confirmButtonLabel:onConfirmAction:hiddenId:!ajax support!private! !
!WebTask categoriesFor: #putAjaxResultsConfirmationDialog:title:confirmButtonLabel:onConfirmAction:hiddenId:showWaitAfterConfirmation:!ajax support!private! !
!WebTask categoriesFor: #putAjaxResultsConfirmationDialog:title:confirmButtonLabel:onConfirmAction:onCancelAction:hiddenId:!ajax support!private! !
!WebTask categoriesFor: #putAjaxResultsConfirmationDialog:title:confirmButtonLabel:onConfirmAction:onCancelAction:hiddenId:showWaitAfterConfirmation:!ajax support!private! !
!WebTask categoriesFor: #putAjaxResultsForAccessDenied!ajax support!private! !
!WebTask categoriesFor: #putAjaxResultsForCloseAllDialogBoxes!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsForCloseAllDialogBoxesFollowedBySetFocusTo:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsForCloseTopDialogBox!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsForNoAction!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsIntoDiv:coder:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsIntoDiv:coder:focusField:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsIntoDiv:htmlContents:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsMessageBox:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsMessageBox:followedBySetFocusTo:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsMessageBoxFollowedByAllDialogsClose:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsRedirectToTask:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsRedirectToTask:action:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsRedirectToUrl:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #putAjaxResultsRedirectToUrlInNewWindow:!ajax support!private!suggest filelds support! !
!WebTask categoriesFor: #session!public! !
!WebTask categoriesFor: #sessionURLPrefix!public! !
!WebTask categoriesFor: #setApplication:!public! !
!WebTask categoriesFor: #setApplication:session:!public! !
!WebTask categoriesFor: #setApplication:session:taskId:!public! !
!WebTask categoriesFor: #superTask!public! !
!WebTask categoriesFor: #superTask:!public! !
!WebTask categoriesFor: #taskId!public! !
!WebTask categoriesFor: #taskUrl!public! !
!WebTask categoriesFor: #taskURLPrefix!public! !
!WebTask categoriesFor: #taskURLPrefixForAction:!public! !
!WebTask categoriesFor: #taskURLPrefixForAction:id:!public! !
!WebTask categoriesFor: #taskURLPrefixForAction:id:filenamePostfix:!public! !
!WebTask categoriesFor: #traceLog:!private! !
!WebTask categoriesFor: #urlExtension!public! !
!WebTask categoriesFor: #urlPrefixForAction:!ajax support!public! !
!WebTask categoriesFor: #urlPrefixForAction:id:!ajax support!public! !

!WebTask class methodsFor!

generateUrlPrefixStringFor: urlPrefix action: aStringOrSymbol id: anObject convertAjaxActionToScript: convertAjaxActionToScriptBoolean 
	^self 
		generateUrlPrefixStringFor: urlPrefix
		action: aStringOrSymbol
		id: anObject
		convertAjaxActionToScript: convertAjaxActionToScriptBoolean
		filenamePostfix: nil!

generateUrlPrefixStringFor: urlPrefix action: aStringOrSymbol id: anObject convertAjaxActionToScript: convertAjaxActionToScriptBoolean filenamePostfix: filenamePostfix 
	| stream |
	stream := WriteStream on: (String new: 128).
	(convertAjaxActionToScriptBoolean and: [aStringOrSymbol isAjaxAction]) 
		ifTrue: 
			[Processor activeProcess attributes at: #javascriptDialogBox put: true.
			(aStringOrSymbol asString beginsWith: 'ajaxPost') 
				ifTrue: 
					[stream
						nextPutAll: 'javascript:if(getTopDialogBox() && getTopDialogBox().m_FormName)ajaxPostRequestForAction(document.forms[getTopDialogBox().m_FormName],';
						nextPutAll: aStringOrSymbol asJavascriptValue;
						nextPutAll: ');void(0);']
				ifFalse: 
					[stream
						nextPutAll: 'javascript:ajaxGetRequest(''';
						nextPutAll: urlPrefix;
						nextPutAll: '?action=';
						nextPutAll: aStringOrSymbol webAsActionString.
					anObject isNilOrEmpty 
						ifFalse: 
							[stream
								nextPutAll: '&id=';
								nextPutAll: anObject asWebString webHttpUrlEncoded].
					stream nextPutAll: ''');void(0);']]
		ifFalse: 
			[stream nextPutAll: urlPrefix.
			filenamePostfix isNil 
				ifFalse: 
					[filenamePostfix isNilOrEmpty 
						ifFalse: 
							[filenamePostfix first = $/ ifFalse: [stream nextPut: $/].
							stream nextPutAll: filenamePostfix]].
			stream
				nextPutAll: '?action=';
				nextPutAll: aStringOrSymbol webAsActionString.
			anObject isNilOrEmpty 
				ifFalse: 
					[stream
						nextPutAll: '&id=';
						nextPutAll: anObject asWebString webHttpUrlEncoded]].
	^stream contents!

generateUrlPrefixStringFor: urlPrefix action: aStringOrSymbol id: anObject convertAjaxActionToScript: convertAjaxActionToScriptBoolean openInNewWindow: openInNewWindow 
	| stream |
	stream := WriteStream on: (String new: 128).
	(convertAjaxActionToScriptBoolean and: [aStringOrSymbol isAjaxAction]) 
		ifTrue: 
			[Processor activeProcess attributes at: #javascriptDialogBox put: true.
			(aStringOrSymbol asString beginsWith: 'ajaxPost') 
				ifTrue: 
					[stream
						nextPutAll: 'javascript:ajaxPostRequestForAction(document.forms[getTopDialogBox().m_FormName],';
						nextPutAll: aStringOrSymbol asJavascriptValue;
						nextPutAll: ');void(0);']
				ifFalse: 
					[stream
						nextPutAll: 'javascript:ajaxGetRequest(''';
						nextPutAll: urlPrefix;
						nextPutAll: '?action=';
						nextPutAll: aStringOrSymbol webAsActionString.
					anObject isNilOrEmpty 
						ifFalse: 
							[stream
								nextPutAll: '&id=';
								nextPutAll: anObject asWebString webHttpUrlEncoded].
					stream nextPutAll: ''');void(0);']]
		ifFalse: 
			[openInNewWindow == true ifTrue: [stream nextPutAll: 'javascript:window.open('''].
			stream
				nextPutAll: urlPrefix;
				nextPutAll: '?action=';
				nextPutAll: aStringOrSymbol webAsActionString.
			anObject isNilOrEmpty 
				ifFalse: 
					[stream
						nextPutAll: '&id=';
						nextPutAll: anObject asWebString webHttpUrlEncoded].
			openInNewWindow == true ifTrue: [stream nextPutAll: ''', ''_blank'');']].
	^stream contents! !
!WebTask class categoriesFor: #generateUrlPrefixStringFor:action:id:convertAjaxActionToScript:!public! !
!WebTask class categoriesFor: #generateUrlPrefixStringFor:action:id:convertAjaxActionToScript:filenamePostfix:!public! !
!WebTask class categoriesFor: #generateUrlPrefixStringFor:action:id:convertAjaxActionToScript:openInNewWindow:!public! !

