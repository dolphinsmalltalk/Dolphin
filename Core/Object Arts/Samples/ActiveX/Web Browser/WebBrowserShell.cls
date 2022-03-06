"Filed out from Dolphin Smalltalk"!

Shell subclass: #WebBrowserShell
	instanceVariableNames: 'address browser statusModel logEvents zoomModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebBrowserShell guid: (GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!
WebBrowserShell comment: 'WebBrowserShell is a simple web browser application built around the Microsoft Web Browser control (the basis of Internet Explorer).

This sample does wire up to a few events from the brower control (mainly for illustrative purposes), but if you want to learn more about what events are fired and when it is recommended that you monitor the behaviour of the control using the ''Active-X Control Browser'' tool.

Try:
	WebBrowserShell show

Instance Variables:
	address		<TextPresenter>. The text URL being browsed/to be browsed.
	browser		<URLPresenter>. Presenter behind the explorer view.
	statusModel	<ValueHolder>. Model to hold status text updated by events from the explorer control.

'!
!WebBrowserShell categoriesForClass!Samples! !
!WebBrowserShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	statusModel := ValueHolder new.
	zoomModel := ValueHolder new.
	browser := self add: URLPresenter new name: 'browser'.
	address := self add: TextPresenter new name: 'address'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	logEvents := true.
	"Some events we need to hook to stay in sync"
	browser
		when: #webviewAvailable
			send: #onWebViewAvailable
			to: self;
		when: #sourceChanged:
			send: #onSourceChanged:
			to: self;
		when: #documentTitleChanged
			send: #onDocumentTitleChanged
			to: self;
		when: #zoomFactorChanged
			send: #onZoomFactorChanged
			to: self;
		when: #processFailed:
			send: #onProcessFailed:
			to: self.
	"We don't really need all these other events, but observe them for illustrative purposes"
	WebView2View webview2Events do: 
			[:each |
			browser
				when: each
				send: #onWebView2Event:name:
				to: self
				withArguments: {nil. each}]!

help
	self openUrl: 'edge://about'!

home
	"Go to the Home page"

	self openUrl: self homePage!

homePage
	"Private - Answer the home page to use for the receiver"

	^'http://www.github.com/DolphinSmalltalk/Dolphin'!

navigate
	"Navigate to the address in the address bar.
	We want to by-pass the normal check for the same value here."

	"If the URI is invalid, the browser will throw an error."
	browser model setValue: address value.
	[browser model notifyChanged] on: Error do: [:ex | statusModel  value: ex. Sound errorBeep]!

onDocumentTitleChanged
	"Private - Event fired by Edge WebView2 when the document title has changed, so update the browser caption."

	self caption: browser view documentTitle!

onProcessFailed: anICoreWebView2ProcessFailedEventArgs
	| stream |
	stream := String writeStream.
	stream
		nextPutAll: 'The browser process has crashed.';
		cr;
		nextPutAll: 'Failure details:';
		cr.
	anICoreWebView2ProcessFailedEventArgs printableProperties do: 
			[:each |
			stream
				nextPutAll: '    ';
				nextPutAll: each;
				nextPutAll: ': ';
				print: (anICoreWebView2ProcessFailedEventArgs perform: each)]
		separatedBy: [stream cr].
	MessageBox errorMsg: stream contents caption: 'Oops!!'!

onSourceChanged: anICoreWebView2NavigationCompletedEventArgs
	"Private - Event fired by Edge WebView2 when a the 'source' has changed - this may include in-page navigation, in which case the document will not have changed, but the source URI will."

	"Keep the address bar in sync"
	address model value: browser view model value!

onViewOpened
	"Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'status'.
	statusItem model: statusModel.
	statusItem := self view viewNamed: 'zoom'.
	statusItem model: zoomModel!

onWebView2Event: anICoreWebView2EventArgs name: aSymbol
	| trace |
	trace := '<1s> <2p>' << {aSymbol. anICoreWebView2EventArgs}.
	logEvents
		ifTrue: 
			[Transcript
				nextPutAll: trace;
				cr].
	statusModel value: trace!

onWebViewAvailable
	"Private - The edge browser is loaded as a number of asynchronous steps. The #webviewAvailable event is fired when the browser is ready for navigation."

	"Display the Edge browser version in the status bar field on the right"

	(self view viewNamed: 'browserVersion') model: browser view webviewEnvironment asValue.
	self onZoomFactorChanged.
	"self openUrl: 'edge://about'"!

onZoomFactorChanged
	zoomModel value: '<1p>%%' << (browser view webviewController zoomFactor * 100) rounded!

openUrl: aString
	"Navigate to the specified URL."

	browser model value: aString!

printToPdf
	| filename |
	filename := FileSaveDialog new
				caption: 'Print to PDF...';
				fileTypes: #(#('PDFs (*.pdf)' '*.pdf'));
				value: '';
				showModal.
	filename ifNil: [^self].
	browser view webview
		printToPdf: filename
		settings: nil
		thenDo: 
			[:hr :isSuccess |
			isSuccess
				ifTrue: [ShellLibrary default shellOpen: filename]
				ifFalse: [MessageBox errorMsg: 'Failed to print as PDF (<1p>)' << (HRESULT fromInteger: hr)]]!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	aCommandQuery command == #printToPdf:
		ifTrue: 
			[| webview |
			webview := browser view webview.
			aCommandQuery isEnabled: (webview notNull and: [webview canPrintToPdf])].
	^super queryCommand: aCommandQuery! !
!WebBrowserShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
help!commands!public! !
home!commands!public! !
homePage!commands!private! !
navigate!commands!public! !
onDocumentTitleChanged!event handling!private! !
onProcessFailed:!event handling!private! !
onSourceChanged:!event handling!private! !
onViewOpened!event handling!public! !
onWebView2Event:name:!event handling!private! !
onWebViewAvailable!event handling!private! !
onZoomFactorChanged!event handling!private! !
openUrl:!operations!public! !
printToPdf!commands!public! !
queryCommand:!commands!private! !
!

!WebBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Simple Web Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon
		text: $\x1F310
		fontName: 'Segoe UI Emoji'
		color: Color forestGreen)!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10621!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 7 nil nil nil 528 480 8 1841879280 170 192 8 #() 170 192 624 8 #() nil 590342 ##(Smalltalk.Rectangle) 328198 ##(Smalltalk.Point) 5 3 706 5 5 1 nil 706 65 65 nil nil 498 1 1 nil nil nil 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 784 nil 480 nil 519 nil nil nil 784 480 8 1841879280 170 192 624 170 192 34 10 12547 1115206 1 ##(Smalltalk.ToolbarIconButton) 784 1 1180998 4 ##(Smalltalk.CommandDescription) #home 8 'Home page' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2302 nil nil nil nil nil 1 nil nil 12547 12553 914 784 1 946 #printToPdf 8 'Print to PDF' 1 1 994 $\x1F5B6 nil nil nil nil nil 1 nil nil 12553 12549 914 784 1 946 #goBack 8 'Back' 1 1 994 $\x1F860 nil nil 466 #commonGreen nil nil 1 nil nil 12549 12555 914 784 1 946 #help 8 'Help' 1 1 994 $\x1F6C8 nil nil nil nil nil 1 nil nil 12555 12551 914 784 1 946 #goForward 8 'Forward' 1 1 994 $\x1F862 nil nil 1152 nil nil 1 nil nil 12551 34 6 928 1088 1232 1024 1168 1049158 1 ##(Smalltalk.ToolbarSeparator) 784 1 nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 5 3 706 407 79 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 205 0 0 0 40 0 0 0] 8 #() 706 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1568 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 706 193 193 nil 1568 498 9 1 nil nil 410 ##(Smalltalk.PushButton) 34 20 nil 1568 34 2 8 1140924416 1 1744 nil nil 706 97 41 519 nil nil nil 1744 nil 8 1841901696 946 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1346 138 144 34 3 1410 #createAt:extent: 34 2 706 1851 11 706 97 59 1744 1410 #isEnabled: 8 #(false) 1744 1410 #text: 34 1 8 '&Go' 1744 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 3 0 0 5 0 0 0 205 3 0 0 34 0 0 0] 8 #() 1552 nil 29 nil 410 ##(Smalltalk.TextEdit) 34 16 nil 1568 34 2 8 1140916352 1025 2112 nil 480 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 946 #navigate 8 '&Go' 1 1 nil nil nil 2226 2097153 946 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2112 nil 8 1841897216 852486 ##(Smalltalk.NullConverter) nil nil 1 1346 138 144 34 3 1410 #createAt:extent: 34 2 706 9 11 706 1835 59 2112 1410 #contextMenu: 34 1 2192 2112 1410 #setMarginWidths: 34 1 8 #(4 4) 2112 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 5 0 0 0 153 3 0 0 34 0 0 0] 8 #() 1552 nil 27 170 192 34 4 1744 8 'go' 2112 8 'address' 674 706 9 11 706 9 11 1346 138 144 34 1 1410 #createAt:extent: 34 2 706 411 3 706 1955 79 1568 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 205 0 0 0 1 0 0 0 158 4 0 0 40 0 0 0] 34 2 2112 1744 1552 nil 27 1346 138 144 34 1 1410 #createAt:extent: 34 2 706 1 1 706 2369 85 528 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 42 0 0 0] 34 2 784 1568 1552 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3072 nil 480 nil 7 nil 1634 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 706 193 193 nil 3072 nil 8 1841432592 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 -1 3072 nil 459270 ##(Smalltalk.Message) #displayString 8 #() nil nil 8 'status' 3266 1 101 3072 nil 3298 #displayString 8 #() nil nil 8 'zoom' 3266 1 301 3072 nil 3298 #displayString 8 #() 3298 #iconImageIndex 3328 nil 8 'browserVersion' 34 3 3280 3360 3424 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3072 nil nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 706 1 1533 706 2369 43 3072 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1552 nil 27 nil nil 410 ##(Smalltalk.WebView2View) 34 21 nil 416 34 2 8 1140850688 1 3712 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 3712 nil nil 2370 nil nil 1 nil nil nil nil nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 706 1 85 706 2369 1449 3712 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 160 4 0 0 254 2 0 0] 624 1552 nil 27 170 192 34 4 3712 8 'browser' 3072 8 'progress' nil nil nil nil nil 8699 nil nil nil nil 1 nil nil 1346 138 144 34 2 1410 #createAt:extent: 34 2 706 12287 21 706 2401 1653 416 1410 #text: 34 1 8 'Simple Web Browser' 416 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 175 28 0 0 68 3 0 0] 34 3 3072 528 3712 1552 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!WebBrowserShell class categoriesForMethods!
displayOn:!printing!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

