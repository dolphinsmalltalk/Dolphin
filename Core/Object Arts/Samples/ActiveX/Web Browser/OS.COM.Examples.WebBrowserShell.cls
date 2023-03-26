"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'OS.COM.Examples.WebBrowserShell'
	instanceVariableNames: 'address browser statusModel zoomModel flags profileModel'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: { 'ImagesBlockedMask' -> 16r2. 'LogEventsMask' -> 16r1 }!
OS.COM.Examples.WebBrowserShell guid: (Core.GUID fromString: '{840f8a35-998b-4346-ab86-95db62f03a47}')!
OS.COM.Examples.WebBrowserShell comment: '`WebBrowserShell` is a simple web browser application built around the Microsoft WebView2 Web Browser control, which is using the Edge chromium-based browser.

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
!OS.COM.Examples.WebBrowserShell categoriesForClass!Samples! !
!OS.COM.Examples.WebBrowserShell methodsFor!

areImagesBlocked
	^false!

browserView
	^browser view!

buildPopupForCommand: aSymbol
	aSymbol == #settingsMenu ifTrue: [^self buildSettingsPopup].
	^nil!

buildSettingsPopup
	| menu submenu |
	menu := Menu new.
	menu
		addCommand: #toggleEventLogging description: 'Log WebView2 &Events to Transcript';
		addSeparator;
		addCommand: #toggleAllowContextMenu description: 'WebView2 Context &Menus';
		addCommand: #toggleBrowserAcceleratorKeysEnabled description: 'WebView2 &Accelerator Keys';
		addCommand: #toggleBuiltinErrorPageEnabled description: 'WebView2 &Error Pages';
		addCommand: #toggleDefaultScriptDialogsEnabled description: 'WebView2 Script &Dialogs';
		addSeparator;
		addCommand: #toggleAllowExternalDrop description: 'Accept &Dropped Files';
		addCommand: #toggleDevToolsEnabled description: '&DevTools (F12)';
		addCommand: #toggleWebMessaging description: 'Web &Messaging';
		addSeparator;
		addCommand: #togglePinchZoomEnabled description: 'P&inch Zoom';
		addCommand: #toggleSwipeNavigation description: 'S&wipe Navigation';
		addCommand: #toggleStatusBar description: '&Status Bubbles';
		addCommand: #toggleZoomControl description: '&Zoom Control'.
	submenu := menu addSubmenu: 'Preferred &Color Scheme'.
	#('&Auto' '&Light' '&Dark') keysAndValuesDo: 
			[:eachKey :eachValue |
			submenu
				addItem: ((CommandMenuItem commandDescription: (CommandDescription
								command: (Message selector: #preferredColorScheme: argument: eachKey - 1)
								description: eachValue))
						isRadioButtonStyle: true;
						yourself)].
	menu
		addSeparator;
		addCommand: #toggleGeneralAutofill description: 'General &Autofill';
		addCommand: #togglePasswordAutosave description: '&Password Autosave';
		addCommand: #toggleBlockImages description: 'Block &Images';
		addCommand: #toggleJavaScript description: '&JavaScript';
		addCommand: #toggleInPrivateMode description: 'In Private &Mode';
		yourself.
	submenu := menu addSubmenu: '&Tracking Prevention Level'.
	#('&None' '&Basic' 'Ba&lanced' '&Strict') keysAndValuesDo: 
			[:eachKey :eachValue |
			submenu
				addItem: ((CommandMenuItem commandDescription: (CommandDescription
								command: (Message selector: #trackingPreventionLevel: argument: eachKey - 1)
								description: eachValue))
						isRadioButtonStyle: true;
						yourself)].
	^menu!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	statusModel := ValueHolder new.
	zoomModel := ValueHolder new.
	profileModel := ValueHolder new.
	browser := self add: URLPresenter new name: 'browser'.
	address := self add: TextPresenter new name: 'address'.!

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
				resourceContext: WebView2.COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE]
		ifFalse: 
			[flags := flags maskClear: ImagesBlockedMask.
			self webview2 removeWebResourceRequestedFilter: '*'
				resourceContext: WebView2.COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE]!

isInPrivateModeEnabled
	^browser view isInPrivateModeEnabled!

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

	self caption: self browserView documentTitle!

onDropDown: aToolbarButton
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	popup := self buildPopupForCommand: aToolbarButton command asSymbol.
	popup isNil ifTrue: [^nil].
	popup queryAllAlong: self commandPolicy recursive: true.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onFavIconChanged
	self webview2 getFavIcon: WebView2.COREWEBVIEW2_FAVICON_IMAGE_FORMAT_PNG
		thenDo: [:hr :stream | self view smallIcon: (Gdiplus.Bitmap fromIStream: stream) asIcon]!

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

	address model value: self browserView model value!

onViewOpened
	"Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'status'.
	statusItem model: statusModel.
	statusItem := self view viewNamed: 'zoom'.
	statusItem model: zoomModel.
	statusItem := self view viewNamed: 'profile'.
	statusItem model: profileModel.

	"Enable toolbar pulldowns"
	(self view viewNamed: 'browserTools' ifNone: nil)
		ifNotNil: 
			[:toolbar |
			toolbar presenterConnectionPoint
				when: #dropDown:
				send: #onDropDown:
				to: self]!

onWebResourceRequested: anICoreWebView2WebResourceRequestedEventArgs
	"Private - Implement web request filter, in this case to block images when that option is enabled by the user."

	| response |
	anICoreWebView2WebResourceRequestedEventArgs resourceContext
		== WebView2.COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE ifFalse: [^self].
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
	trace := aSymbol lastCodeUnit == $:
				ifTrue: ['<1s> <2p>' << { aSymbol. anICoreWebView2EventArgs }]
				ifFalse: [aSymbol].
	self isLoggingEvents
		ifTrue: 
			[Transcript
				nextPutAll: trace;
				cr].
	statusModel value: trace!

onWebViewAvailable
	"Private - The edge browser is loaded as a number of asynchronous steps. The #webviewAvailable event is fired when the browser is ready for navigation."

	"Display the Edge browser version in the status bar field on the right"

	(self view viewNamed: 'browserVersion') model: self browserView webviewEnvironment asValue.
	self onZoomFactorChanged.
	profileModel value: self browserView profile !

onZoomFactorChanged
	zoomModel value: '<1p>%%' << (self browserView zoomFactor * 100) rounded!

openTaskManagerWindow
	self webview2 openTaskManagerWindow!

openUrl: aString
	"Navigate to the specified URL."

	browser model value: aString!

preferredColorScheme
	^self browserView profile preferredColorScheme!

preferredColorScheme: anInteger
	^self browserView profile preferredColorScheme: anInteger!

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
				ifTrue: [Shell32 shellOpen: filename]
				ifFalse: [MessageBox errorMsg: 'Failed to print as PDF (<1p>)' << (HRESULT fromInteger: hr)]]!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	| commandSymbol |
	commandSymbol := aCommandQuery command.
	commandSymbol == #printToPdf:
		ifTrue: 
			[| webview |
			webview := self webview2.
			aCommandQuery isEnabled: (webview notNil and: [webview canPrintToPdf]).
			^true].
	^(self querySettingsCommands: aCommandQuery) or: [super queryCommand: aCommandQuery]!

querySettingsCommands: aCommandQuery
	"Private - Enters details about a potential settings command for the receiver into aCommandQuery"

	| commandSymbol webview |
	commandSymbol := aCommandQuery command asSymbol.
	webview := self webview2.
	commandSymbol == #settingsMenu
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
	commandSymbol == #toggleInPrivateMode
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self isInPrivateModeEnabled.
			^true].
	commandSymbol == #trackingPreventionLevel:
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self browserView trackingPreventionLevel = aCommandQuery command argument.
			^true].
	commandSymbol == #preferredColorScheme:
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self preferredColorScheme = aCommandQuery command argument.
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

toggleInPrivateMode
	browser view isInPrivateModeEnabled: self isInPrivateModeEnabled not!

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

trackingPreventionLevel: anInteger
	self browserView trackingPreventionLevel: anInteger!

webview2
	| webview |
	webview := browser view webview.
	^webview notNull ifTrue: [webview]!

webviewSettings
	^self webview2 ifNotNil: [:webview2 | webview2 settings]!

zoomReset
	<acceleratorKey: 'Ctrl+0'>
	browser view zoomFactor: 1! !
!OS.COM.Examples.WebBrowserShell categoriesForMethods!
areImagesBlocked!public!testing! !
browserView!accessing!public! !
buildPopupForCommand:!commands!private! !
buildSettingsPopup!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayError:!operations!private! !
hasWebview!private!testing! !
help!commands!public! !
home!commands!public! !
homePage!constants!private! !
initialize!initializing!private! !
isBlockingImages!public!testing! !
isBlockingImages:!operations!public! !
isInPrivateModeEnabled!accessing!public! !
isLoggingEvents!public!testing! !
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
preferredColorScheme!accessing!public! !
preferredColorScheme:!operations!public! !
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
toggleInPrivateMode!commands!public! !
toggleJavaScript!commands!public! !
togglePasswordAutosave!commands!public! !
toggleStatusBar!commands!public! !
toggleWebMessaging!commands!public! !
toggleZoomControl!commands!public! !
trackingPreventionLevel:!operations!public! !
webview2!accessing!private! !
webviewSettings!accessing!private! !
zoomReset!commands!public! !
!

!OS.COM.Examples.WebBrowserShell class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'WebView2 Browser'!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853516 131137 528 nil 480 nil 7 nil nil nil 528 480 8 1810814016 170 192 34 2 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853580 131073 640 nil 480 nil 519 nil nil nil 640 480 8 1810814016 170 192 8 #() nil nil nil 170 192 34 14 24141 1311814 1 #{UI.ToolbarIconButton} 640 1 1377606 4 #{UI.CommandDescription} #print 8 'Print ...' 1 1 1378630 2 #{Graphics.TextTileIcon} $🖶 nil nil nil nil nil 1 nil nil 24141 24137 786 640 1 818 #goBack 8 'Back' 1 1 866 $🡠 nil nil 466 #commonGreen nil nil 1 nil nil 24137 24147 786 640 273 818 #settingsMenu 8 'Settings' 1 1 866 $⚙ nil nil nil nil nil 1 nil nil 24147 24143 786 640 1 818 #help 8 'Information' 1 1 866 $🛈 nil nil nil nil nil 1 nil nil 24143 24139 786 640 1 818 #goForward 8 'Forward' 1 1 866 $🡢 nil nil 960 nil nil 1 nil nil 24139 24135 786 640 5 818 #home 8 'Home page' 1 1 866 $⌂ nil nil nil nil nil 1 nil nil 24135 24145 786 640 1 818 #openTaskManagerWindow 8 'Open &Task Manager' 1 1 866 $⚛ nil nil nil nil nil 1 nil nil 24145 34 8 1168 896 1104 800 1040 1232 976 1245766 1 #{UI.ToolbarSeparator} 640 1 nil nil 1 nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 5 3 1442 581 79 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 36 1 0 0 40 0 0 0] 8 #() 1442 193 193 nil 29 8 'browserTools' nil nil nil 170 192 736 8 #() nil 1180166 #{Graphics.Rectangle} 1442 5 3 1442 5 5 1 nil 1442 65 65 nil nil 498 1 1 nil nil nil 640 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 1712 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1442 193 193 nil 1712 498 9 1 nil nil 410 #{UI.PushButton} 34 20 nil 1712 34 2 8 1140924416 1 1888 nil nil 1442 101 51 7 nil nil nil 1888 nil 8 1810709872 818 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1346 34 3 1394 #createAt:extent: 34 2 1442 1673 11 1442 101 59 1888 1394 #isEnabled: 8 #(false) 1888 1394 #text: 34 1 8 '&Go' 1888 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 68 3 0 0 5 0 0 0 118 3 0 0 34 0 0 0] 8 #() 1552 nil 29 nil 410 #{UI.TextEdit} 34 16 nil 1712 34 2 8 1140916352 1025 2240 nil 480 nil 7 461638 4 #{UI.Menu} nil true 34 2 1180742 2 #{UI.CommandMenuItem} 1 818 #navigate 8 '&Go' 1 1 nil nil nil 2354 2097153 818 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2240 nil 8 1810702576 1049094 #{UI.NullConverter} nil nil 1 1346 34 2 1394 #createAt:extent: 34 2 1442 9 11 1442 1657 59 2240 1394 #setMarginWidths: 34 1 8 #(4 4) 2240 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 5 0 0 0 64 3 0 0 34 0 0 0] 8 #() 1552 nil 27 170 192 34 4 2240 8 'address' 1888 8 'go' 1618 1442 9 11 1442 9 11 1346 34 1 1394 #createAt:extent: 34 2 1442 585 3 1442 1781 79 1712 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 1 0 0 1 0 0 0 158 4 0 0 40 0 0 0] 34 2 2240 1888 1552 nil 27 1346 34 1 1394 #createAt:extent: 34 2 1442 1 1 1442 2369 85 528 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 42 0 0 0] 34 2 640 1712 1552 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 3120 nil 480 nil 7 nil 1778 nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 18 84 105 109 101 115 32 78 101 119 32 82 111 109 97 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1442 193 193 nil 3120 nil 8 1810507520 170 192 34 8 1050438 1 #{UI.StatusBarItem} 8193 251 3120 nil 786950 #{Core.Message} #displayString 736 3346 #iconImageIndex 736 nil 8 'profile' 3314 8193 101 3120 nil 3346 #displayString 8 #() nil nil 8 'zoom' 3314 8193 -1 3120 nil 3346 #displayString 8 #() nil nil 8 'status' 3314 8193 301 3120 nil 3346 #displayString 8 #() 3346 #iconImageIndex 3504 nil 8 'browserVersion' nil nil nil 34 4 3472 3328 3408 3536 1311814 1 #{UI.StatusBarNullItem} 8705 1 3120 nil nil 1346 34 1 1394 #createAt:extent: 34 2 1442 1 1533 1442 2369 43 3120 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1552 nil 29 nil nil 410 #{UI.WebView2View} 34 26 nil 416 34 2 8 1140850688 1 3808 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 3808 nil nil 2498 nil nil 262145 nil nil nil nil nil 2295046 #{WebView2.WebView2EnvironmentOptions} nil 15 nil 8 '110.0.1549.0' 5 nil nil nil nil 1346 34 1 1394 #createAt:extent: 34 2 1442 1 85 1442 2369 1449 3808 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 160 4 0 0 254 2 0 0] 736 1552 nil 29 170 192 34 4 3120 8 'progress' 3808 8 'browser' nil nil nil nil nil 14213 nil nil nil nil 1 nil nil 1346 34 2 1394 #createAt:extent: 34 2 1442 6143 21 1442 2401 1653 416 1394 #text: 34 1 8 'Simple Web Browser' 416 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 34 3 3120 528 3808 1552 nil 27)!

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

