"Filed out from Dolphin Smalltalk"!

Shell subclass: #WebBrowserShell
	instanceVariableNames: 'address browser statusModel zoomModel flags'
	classVariableNames: 'ImagesBlockedMask LogEventsMask'
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!

WebBrowserShell guid: (GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!

WebBrowserShell addClassConstant: 'ImagesBlockedMask' value: 16r2!
WebBrowserShell addClassConstant: 'LogEventsMask' value: 16r1!

WebBrowserShell comment: 'WebBrowserShell is a simple web browser application built around the Microsoft Web Browser control (the basis of Internet Explorer).

This sample does wire up to a few events from the brower control (mainly for illustrative purposes), but if you want to learn more about what events are fired and when you can turn on logging of WebView2 events from the Settings menu, and will then see a trace of all events being logged to the Transcript as the browser is used.

The sample also illustrates the use of `TextTileIcon`s as the glyphs for the toolbar buttons. These provide a clean monochrome look.

Try:
```
	WebBrowserShell show
```

## Instance Variables:
  `address`		`<textPresenter>` presenting the text URL being browsed/to be browsed.
  `browser`		`URLPresenter`. Presenter connected to a `WebView2View` that parents the browser control itself.
  `statusModel`	`ValueHolder` holding the status text updated by events from the browser control.
  `zoomModel`		`ValueHolder` holding the zoom percentage
  `flags`			`<integer>`. Various flags

'!

!WebBrowserShell categoriesForClass!Samples! !

!WebBrowserShell methodsFor!

areImagesBlocked
	^false!

buildPopupForCommand: aSymbol
	aSymbol == #settings ifTrue: [^self buildSettingsPopup].
	^nil!

buildSettingsPopup
	#todo.	"Would be nice to use annotations to build this dynamically, but that is not supported in D7."
	^Menu new
		addCommand: #toggleEventLogging description: 'Log WebView2 Events to Transcript';
		addCommand: #toggleBlockImages description: 'Block Images';
		addCommand: #toggleAllowContextMenu description: 'WebView2 Context Menus';
		addCommand: #toggleAllowExternalDrop description: 'Accept Dropped Files';
		addCommand: #toggleBrowserAcceleratorKeysEnabled description: 'WebView2 Accelerator Keys';
		addCommand: #toggleBuiltinErrorPageEnabled description: 'WebView2 Error Pages';
		addCommand: #toggleDefaultScriptDialogsEnabled description: 'WebView2 Script Dialogs';
		addCommand: #toggleDevToolsEnabled description: 'DevTools (F12)';
		addCommand: #toggleGeneralAutofill description: 'General Autofill';
		addCommand: #toggleJavaScript description: 'JavaScript';
		addCommand: #togglePasswordAutosave description: 'Password Autosave';
		addCommand: #togglePinchZoomEnabled description: 'Pinch Zoom';
		addCommand: #toggleStatusBar description: 'Status Bubbles';
		addCommand: #toggleSwipeNavigation description: 'Swipe Navigation';
		addCommand: #toggleWebMessaging description: 'Web Messaging';
		addCommand: #toggleZoomControl description: 'Zoom Control';
		yourself!

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
			to: self;
		when: #favIconChanged
			send: #onFavIconChanged
			to: self;
		when: #webResourceRequested:
			send: #onWebResourceRequested:
			to: self.
	"We don't really need all these other events, but observe them for illustrative purposes"
	WebView2View webview2Events do: 
			[:each |
			browser
				when: each
				send: #onWebView2Event:name:
				to: self
				withArguments: {nil. each}]!

displayError: ex
	statusModel value: ex.
	^Sound errorBeep!

hasWebview
	^self webview2 notNil!

help
	self openUrl: 'edge://about'!

home
	"Go to the Home page"

	self openUrl: self homePage!

homePage
	"Private - Answer the home page to use for the receiver"

	^'http://www.github.com/DolphinSmalltalk/Dolphin'!

initialize
	flags := 0.
	super initialize!

isBlockingImages
	^flags allMask: ImagesBlockedMask!

isBlockingImages: aBoolean
	"Enable/disable downloads of images. Intended as an example of resource request filtering. The actual filter is implemented in #onWebResourceRequested:, i.e. via the SASE events mechanism to which WebView2View translates the WebView2 async events."

	aBoolean == self isBlockingImages ifTrue: [^self].
	aBoolean
		ifTrue: 
			[flags := flags maskSet: ImagesBlockedMask.
			self webview2 addWebResourceRequestedFilter: '*'
				resourceContext: COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE]
		ifFalse: 
			[flags := flags maskClear: ImagesBlockedMask.
			self webview2 removeWebResourceRequestedFilter: '*'
				resourceContext: COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE]!

isLoggingEvents
	"Answer whether WebView2 events should be logged to the transcript."

	^flags allMask: LogEventsMask!

isLoggingEvents: aBoolean
	"Enable/disable logging of WebView2 events to the transcript."

	flags := flags mask: LogEventsMask set: aBoolean!

navigate
	"Navigate to the address in the address bar."

	self navigateTo: address value!

navigateTo: aString
	"Private - Navigate to the argument, assumed to be a URL."

	"We want to by-pass the normal check for the same value here."

	browser model setValue: aString.
	[browser model notifyChanged] on: HRESULTError
		do: 
			[:ex |
			"If the URI is invalid, the browser will throw an invalid arg error. If it was invalid because there was no protocol specified, assume it is intended as a web page request, prepend https, and try again"
			(ex hresult asInteger = Win32Errors.E_INVALIDARG and: 
					[(aString indexOfSubCollection: '//:') == 0
						and: [(aString anySatisfy: [:each | each isSeparator]) not]])
				ifTrue: 
					[address value: 'https://' , aString.
					self navigate]
				ifFalse: 
					[statusModel value: ex.
					Sound errorBeep]]!

onDocumentTitleChanged
	"Private - Event fired by Edge WebView2 when the document title has changed, so update the browser caption."

	self caption: browser view documentTitle!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	popup := self buildPopupForCommand: aToolbarButton command asSymbol.
	popup isNil ifTrue: [^nil].
	popup queryAllFromView: self view.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onFavIconChanged
	self webview2 getFavIcon: COREWEBVIEW2_FAVICON_IMAGE_FORMAT_PNG
		thenDo: [:hr :stream | self view smallIcon: (GdiplusBitmap fromIStream: stream) asIcon]!

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
	statusItem model: zoomModel.
	"Enable toolbar pulldowns"
	(self view viewNamed: 'browserTools' ifNone: nil)
		ifNotNil: 
			[:toolbar |
			toolbar presenterConnectionPoint
				when: #dropDown:
				send: #onDropDown:
				to: self].!

onWebResourceRequested: anICoreWebView2WebResourceRequestedEventArgs
	"Private - Implement web request filter, in this case to block images when that option is enabled by the user."

	| response |
	anICoreWebView2WebResourceRequestedEventArgs resourceContext
		== COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE ifFalse: [^self].
	"Override the response with an empty one to block the download."
	response := self webview2 environment
				createWebResourceResponse: nil
				statusCode: 403
				reasonPhrase: 'Blocked'
				headers: 'Content-Type: image/jpeg'.
	anICoreWebView2WebResourceRequestedEventArgs response: response.
	"Release our ref on the ICoreWebView2WebResourceResponse to avoid generating a lot of finalizable garbage when there are many images."
	response free!

onWebView2Event: anICoreWebView2EventArgs name: aSymbol
	| trace |
	trace := '<1s> <2p>' << {aSymbol. anICoreWebView2EventArgs}.
	self isLoggingEvents
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

openTaskManagerWindow
	self webview2 openTaskManagerWindow!

openUrl: aString
	"Navigate to the specified URL."

	browser model value: aString!

print
	self webview2 showBrowserPrintDialog!

printToPdf
	| filename |
	filename := FileSaveDialog new
				caption: 'Print to PDF...';
				fileTypes: #(#('PDFs (*.pdf)' '*.pdf'));
				value: '';
				showModal.
	filename ifNil: [^self].
	self webview2
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
			webview := self webview2.
			aCommandQuery isEnabled: (webview notNil and: [webview canPrintToPdf]).
			^true].
	^(self querySettingsCommands: aCommandQuery) or: [super queryCommand: aCommandQuery]!

querySettingsCommands: aCommandQuery
	"Private - Enters details about a potential settings command for the receiver into aCommandQuery"

	| commandSymbol webview |
	commandSymbol := aCommandQuery command.
	webview := self webview2.
	commandSymbol == #settings
		ifTrue: 
			[aCommandQuery isEnabled: webview notNil.
			^true].
	commandSymbol == #toggleBlockImages
		ifTrue: 
			[aCommandQuery
				isEnabled: webview notNil;
				isChecked: self isBlockingImages.
			^true].
	commandSymbol == #toggleEventLogging
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self isLoggingEvents.
			^true].
	^#(#(#toggleAllowContextMenu #allowContextMenu) #(#toggleAllowExternalDrop #allowExternalDrop) #(#toggleBrowserAcceleratorKeysEnabled #areBrowserAcceleratorKeysEnabled) #(#toggleBuiltinErrorPageEnabled #isBuiltInErrorPageEnabled) #(#toggleDefaultScriptDialogsEnabled #areDefaultScriptDialogsEnabled) #(#toggleDevToolsEnabled #areDevToolsEnabled) #(#toggleGeneralAutofill #isGeneralAutofillEnabled) #(#toggleJavaScript #isScriptEnabled) #(#togglePasswordAutosave #isPasswordAutosaveEnabled) #(#togglePinchZoomEnabled #isPinchZoomEnabled) #(#toggleStatusBar #isStatusBarEnabled) #(#toggleSwipeNavigation #isSwipeNavigationEnabled) #(#toggleWebMessaging #isWebMessageEnabled) #(#toggleZoomControl #isZoomControlEnabled))
		anySatisfy: 
			[:each |
			commandSymbol == each first and: 
					[aCommandQuery
						isEnabled: webview notNil;
						isChecked: (browser view perform: each second).
					true]]!

refresh
	self webview2 reload!

toggleAllowContextMenu
	| webview |
	webview := browser view.
	webview allowContextMenu: webview allowContextMenu not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleAllowExternalDrop
	| webview |
	webview := browser view.
	webview allowExternalDrop: webview allowExternalDrop not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleBlockImages
	self isBlockingImages: self isBlockingImages not.
	self refresh!

toggleBrowserAcceleratorKeysEnabled
	| webview |
	webview := browser view.
	webview areBrowserAcceleratorKeysEnabled: webview areBrowserAcceleratorKeysEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleBuiltinErrorPageEnabled
	| webview |
	webview := browser view.
	webview isBuiltInErrorPageEnabled: webview isBuiltInErrorPageEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleDefaultScriptDialogsEnabled
	| webview |
	webview := browser view.
	webview areDefaultScriptDialogsEnabled: webview areDefaultScriptDialogsEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleDevToolsEnabled
	| webview |
	webview := browser view.
	webview areDevToolsEnabled: webview areDevToolsEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleEventLogging
	self isLoggingEvents: self isLoggingEvents not!

toggleGeneralAutofill
	| webview |
	webview := browser view.
	webview isGeneralAutofillEnabled: webview isGeneralAutofillEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleJavaScript
	| webview |
	webview := browser view.
	webview isScriptEnabled: webview isScriptEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

togglePasswordAutosave
	| webview |
	webview := browser view.
	webview isPasswordAutosaveEnabled: webview isPasswordAutosaveEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleStatusBar
	| webview |
	webview := browser view.
	webview isStatusBarEnabled: webview isStatusBarEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleWebMessaging
	| webview |
	webview := browser view.
	webview isWebMessageEnabled: webview isWebMessageEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleZoomControl
	| webview |
	webview := browser view.
	webview isZoomControlEnabled: webview isZoomControlEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

webview2
	| webview |
	webview := browser view webview.
	^webview notNull ifTrue: [webview]!

webviewSettings
	^self webview2 ifNotNil: [:webview2 | webview2 settings]!

zoomReset
	"<acceleratorKey: 'Ctrl+0'>"
	browser view zoomFactor: 1! !

!WebBrowserShell categoriesForMethods!
areImagesBlocked!public!testing! !
buildPopupForCommand:!commands!private! !
buildSettingsPopup!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayError:!operations!private! !
hasWebview!private!testing! !
help!commands!public! !
home!commands!public! !
homePage!commands!private! !
initialize!initializing!private! !
isBlockingImages!commands!public! !
isBlockingImages:!commands!public! !
isLoggingEvents!commands!public! !
isLoggingEvents:!commands!public! !
navigate!commands!public! !
navigateTo:!operations!private! !
onDocumentTitleChanged!event handling!private! !
onDropDown:!event handling!private! !
onFavIconChanged!event handling!private! !
onProcessFailed:!event handling!private! !
onSourceChanged:!event handling!private! !
onViewOpened!event handling!public! !
onWebResourceRequested:!event handling!private! !
onWebView2Event:name:!event handling!private! !
onWebViewAvailable!event handling!private! !
onZoomFactorChanged!event handling!private! !
openTaskManagerWindow!commands!public! !
openUrl:!operations!public! !
print!commands!public! !
printToPdf!commands!public! !
queryCommand:!commands!private! !
querySettingsCommands:!commands!private! !
refresh!commands!public! !
toggleAllowContextMenu!commands!public! !
toggleAllowExternalDrop!commands!public! !
toggleBlockImages!commands!public! !
toggleBrowserAcceleratorKeysEnabled!commands!public! !
toggleBuiltinErrorPageEnabled!commands!public! !
toggleDefaultScriptDialogsEnabled!commands!public! !
toggleDevToolsEnabled!commands!public! !
toggleEventLogging!commands!public! !
toggleGeneralAutofill!commands!public! !
toggleJavaScript!commands!public! !
togglePasswordAutosave!commands!public! !
toggleStatusBar!commands!public! !
toggleWebMessaging!commands!public! !
toggleZoomControl!commands!public! !
webview2!commands!private! !
webviewSettings!commands!private! !
zoomReset!commands!public! !
!

!WebBrowserShell class methodsFor!

displayOn: aPuttableStream
	"Append, to aPuttableStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aPuttableStream nextPutAll: 'WebView2 Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^WebView2View icon!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 7 nil nil nil 528 480 8 1819137088 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 640 nil 480 nil 519 nil nil nil 640 480 8 1819137088 170 192 8 #() 170 192 34 14 8739 1115206 1 ##(Smalltalk.ToolbarIconButton) 640 1 1180998 4 ##(Smalltalk.CommandDescription) #printToPdf 8 'Print to PDF' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F5B6 nil nil nil nil nil 1 nil nil 8739 8735 786 640 1 818 #goBack 8 'Back' 1 1 866 $\x1F860 nil nil 466 #commonGreen nil nil 1 nil nil 8735 8761 786 640 1 818 #openTaskManagerWindow 8 'Open &Task Manager' 1 1 866 $\x269B nil nil nil nil nil 1 nil nil 8761 8741 786 640 1 818 #help 8 'Help' 1 1 866 $\x1F6C8 nil nil nil nil nil 1 nil nil 8741 8737 786 640 1 818 #goForward 8 'Forward' 1 1 866 $\x1F862 nil nil 960 nil nil 1 nil nil 8737 8733 786 640 1 818 #home 8 'Home page' 1 1 866 $\x2302 nil nil nil nil nil 1 nil nil 8733 8743 786 640 273 818 #settings 8 'Settings' 1 1 866 $\x2699 nil nil nil nil nil 1 nil nil 8743 34 8 1168 896 1104 800 1040 976 1232 1049158 1 ##(Smalltalk.ToolbarSeparator) 640 1 nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 5 3 1458 581 79 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 36 1 0 0 40 0 0 0] 8 #() 1458 193 193 nil 27 8 'browserTools' 170 192 736 8 #() nil 590342 ##(Smalltalk.Rectangle) 1458 5 3 1458 5 5 1 nil 1458 65 65 nil nil 498 1 1 nil nil nil 640 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1728 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1458 193 193 nil 1728 498 9 1 nil nil 410 ##(Smalltalk.PushButton) 34 20 nil 1728 34 2 8 1140924416 1 1904 nil nil 1458 97 41 519 nil nil nil 1904 nil 8 1819032944 818 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1346 138 144 34 3 1410 #createAt:extent: 34 2 1458 1677 11 1458 97 59 1904 1410 #isEnabled: 8 #(false) 1904 1410 #text: 34 1 8 '&Go' 1904 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 3 0 0 5 0 0 0 118 3 0 0 34 0 0 0] 8 #() 1568 nil 29 nil 410 ##(Smalltalk.TextEdit) 34 16 nil 1728 34 2 8 1140916352 1025 2272 nil 480 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 818 #navigate 8 '&Go' 1 1 nil nil nil 2386 2097153 818 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2272 nil 8 1819025648 852486 ##(Smalltalk.NullConverter) nil nil 1 1346 138 144 34 3 1410 #createAt:extent: 34 2 1458 9 11 1458 1661 59 2272 1410 #contextMenu: 34 1 2352 2272 1410 #setMarginWidths: 34 1 8 #(4 4) 2272 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 5 0 0 0 66 3 0 0 34 0 0 0] 8 #() 1568 nil 27 170 192 34 4 2272 8 'address' 1904 8 'go' 1634 1458 9 11 1458 9 11 1346 138 144 34 1 1410 #createAt:extent: 34 2 1458 585 3 1458 1781 79 1728 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 1 0 0 1 0 0 0 158 4 0 0 40 0 0 0] 34 2 2272 1904 1568 nil 27 1346 138 144 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 2369 85 528 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 42 0 0 0] 34 2 640 1728 1568 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3232 nil 480 nil 7 nil 1794 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1458 193 193 nil 3232 nil 8 1818830592 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 101 3232 nil 459270 ##(Smalltalk.Message) #displayString 8 #() nil nil 8 'zoom' 3426 1 -1 3232 nil 3458 #displayString 8 #() nil nil 8 'status' 3426 1 301 3232 nil 3458 #displayString 8 #() 3458 #iconImageIndex 3552 nil 8 'browserVersion' 34 3 3520 3440 3584 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3232 nil nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 1458 1 1533 1458 2369 43 3232 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1568 nil 27 nil nil 410 ##(Smalltalk.WebView2View) 34 21 nil 416 34 2 8 1140850688 1 3872 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 3872 nil nil 2530 nil nil 262145 nil nil nil nil nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 1458 1 85 1458 2369 1449 3872 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 160 4 0 0 254 2 0 0] 736 1568 nil 27 170 192 34 4 3232 8 'progress' 3872 8 'browser' nil nil nil nil nil 8465 nil nil nil nil 1 nil nil 1346 138 144 34 2 1410 #createAt:extent: 34 2 1458 6143 21 1458 2401 1653 416 1410 #text: 34 1 8 'Simple Web Browser' 416 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 34 3 3232 528 3872 1568 nil 27 )!

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

