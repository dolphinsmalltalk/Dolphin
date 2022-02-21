"Filed out from Dolphin Smalltalk"!

UI.Shell subclass: #'OS.COM.Examples.WebBrowserShell'
	instanceVariableNames: 'address browser statusModel logEvents zoomModel'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Examples.WebBrowserShell guid: (Core.GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!
OS.COM.Examples.WebBrowserShell comment: 'WebBrowserShell is a simple web browser application built around the Microsoft Web Browser control (the basis of Internet Explorer).

This sample does wire up to a few events from the brower control (mainly for illustrative purposes), but if you want to learn more about what events are fired and when it is recommended that you monitor the behaviour of the control using the ''Active-X Control Browser'' tool.

Try:
	WebBrowserShell show

Instance Variables:
	address		<TextPresenter>. The text URL being browsed/to be browsed.
	browser		<URLPresenter>. Presenter behind the explorer view.
	statusModel	<ValueHolder>. Model to hold status text updated by events from the explorer control.

'!
!OS.COM.Examples.WebBrowserShell categoriesForClass!Samples! !
!OS.COM.Examples.WebBrowserShell methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	statusModel := ValueHolder new.
	zoomModel := ValueHolder new.
	browser := self add: Smalltalk.URLPresenter new name: 'browser'.
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
	Smalltalk.WebView2View webview2Events do: 
			[:each |
			browser
				when: each
				send: #onWebView2Event:name:
				to: self
				withArguments: {nil. each}]!

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
!OS.COM.Examples.WebBrowserShell categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
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

!OS.COM.Examples.WebBrowserShell class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Simple Web Browser'!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 7 nil nil nil 528 480 8 1808128240 170 192 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 528 34 2 8 1140916352 1025 640 nil 480 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #navigate 8 '&Go' 1 1 nil nil nil 754 2097153 786 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 640 nil 8 1808146176 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 331 15 1058 1891 41 640 1010 #contextMenu: 34 1 720 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 165 0 0 0 7 0 0 0 86 4 0 0 27 0 0 0] 8 #() 1058 193 193 nil 27 8 'address' 410 ##(Smalltalk.PushButton) 34 20 nil 528 34 2 8 1140924416 1 1232 nil nil 1058 97 41 519 nil nil nil 1232 nil 8 1808150656 786 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 1058 2237 11 1058 121 49 1232 1010 #isEnabled: 8 #(false) 1232 1010 #text: 34 1 8 '&Go' 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 94 4 0 0 5 0 0 0 154 4 0 0 29 0 0 0] 8 #() 1200 nil 29 8 'go' 170 192 8 #() 8 #() nil 590342 ##(Smalltalk.Rectangle) 1058 5 3 1058 5 5 1 nil 1058 33 31 1058 45 45 nil 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 528 34 2 8 1140850944 1 1824 nil nil nil 7 nil nil nil 1824 nil 8 1808190368 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 1058 221 19 1058 111 41 1824 1010 #text: 34 1 8 'Address:' 1824 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 9 0 0 0 165 0 0 0 29 0 0 0] 8 #() 1200 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 17 2162 #fixedViewLeft 111 2162 #fixedPreviousTop 5 2162 #fixedViewTop 41 640 2130 2176 1 2162 #fixedParentRight -143 2208 -3 2224 41 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 2272 nil 480 nil 519 nil nil nil 2272 480 8 1808128240 170 192 1632 170 192 34 8 9185 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 2272 1 786 #home 8 'Home page' 1 1 nil 9185 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 71 1058 1857 33 73 9191 1246790 1 ##(Smalltalk.ToolbarSystemButton) 2272 1 786 #printToPdf 8 'Print to PDF' 1 1 nil 9191 1 29 9189 2610 2272 1 786 459270 ##(Smalltalk.Message) #goForward 8 #() 8 'Forward' 1 1 nil 9189 17 3 9187 2610 2272 1 786 2706 #goBack 2736 8 'Back' 1 1 nil 9187 17 1 34 5 2416 2768 2672 2624 1049158 1 ##(Smalltalk.ToolbarSeparator) 2272 1 nil nil 1 nil 1058 33 33 1058 45 45 nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 1058 15 15 1058 191 51 2272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 102 0 0 0 32 0 0 0] 8 #() 1200 nil 27 2130 2162 #fixedParentLeft 11 2192 191 2162 #fixedParentTop 13 2224 51 410 ##(Smalltalk.StaticRectangle) 34 14 nil 528 34 2 8 1140916498 1 3120 nil 480 nil 7 nil nil nil 3120 nil 8 1808190368 946 138 144 34 1 1010 #createAt:extent: 34 2 1058 1 63 1058 2365 5 3120 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 31 0 0 0 158 4 0 0 33 0 0 0] 8 #() 1200 nil 27 2130 3088 -3 2256 1 2162 #fixedViewBottom -3 2162 #fixedParentBottom 1 1232 2130 2162 #fixedViewRight -119 2256 -7 2208 -3 2224 49 946 138 144 34 1 1010 #createAt:extent: 34 2 1058 1 1 1058 2369 71 528 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 35 0 0 0] 34 5 2272 1824 640 1232 3120 1200 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3600 nil 480 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1058 193 193 nil 3600 nil 8 1807681552 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 -1 3600 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'status' 3810 1 301 3600 nil 2706 #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3808 #defaultGetImageBlock 417549187 8 #[30 105 226 0 106] #iconImageIndex 3920 7 257 nil nil 8 'browserVersion' 3810 1 101 3600 nil 2706 #displayString 8 #() nil nil 8 'zoom' 34 3 3824 4000 3856 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3600 nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 1058 1 1533 1058 2369 43 3600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1200 nil 27 nil nil 410 ##(Smalltalk.WebView2View) 34 21 nil 416 34 2 8 1140850688 1 4272 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 4272 nil nil 914 nil nil 1 nil nil nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 1058 1 71 1058 2369 1463 4272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 35 0 0 0 160 4 0 0 254 2 0 0] 1632 1200 nil 27 170 192 34 4 4272 8 'browser' 3600 8 'progress' nil nil nil nil nil 16151 nil nil nil nil 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 1058 12287 21 1058 2401 1653 416 1010 #text: 34 1 8 'Simple Web Browser' 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 175 28 0 0 68 3 0 0] 34 3 3600 528 4272 1200 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!OS.COM.Examples.WebBrowserShell class categoriesForMethods!
displayOn:!printing!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

