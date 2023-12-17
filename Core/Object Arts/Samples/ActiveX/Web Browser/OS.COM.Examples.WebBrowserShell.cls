"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'OS.COM.Examples.WebBrowserShell'
	instanceVariableNames: 'address browser statusModel zoomModel flags profileModel'
	classVariableNames: 'CurrentColorScheme PreferredColorScheme'
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {
			'ColorSchemes' -> {
						LookupTable withAll: {
									#browserBackground -> Color white.
									#browserBar -> (Color brightness: 16r10 / 16r11).
									#browserForeground -> Color black.
									#browserHistoryArrow -> Color commonGreen.
									#browserToolbarButton -> Color transparent
								}.
						LookupTable withAll: {
									#browserBackground -> (Color brightness: 16r3B / 16rFF).
									#browserBar -> (Color brightness: 16r3B / 16rFF).
									#browserForeground -> Color white.
									#browserHistoryArrow -> Color limeGreen.
									#browserToolbarButton -> (Color brightness: 16r3B / 16rFF)
								}
					}.
			'ImagesBlockedMask' -> 16r2.
			'LogEventsMask' -> 16r1
		}!
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

browserView
	^browser view!

buildSettingsPopup: aMenu
	| submenu |
	aMenu
		addCommand: #toggleEventLogging description: 'Log WebView2 &Events to Transcript';
		addSeparator.
	submenu := aMenu addSubmenu: '&Default WebView2 UI'.
	submenu
		addCommand: #toggleAllowContextMenu description: 'Context &Menus';
		addCommand: #toggleBrowserAcceleratorKeysEnabled description: '&Accelerator Keys';
		addCommand: #toggleBuiltinErrorPageEnabled description: '&Error Pages';
		addCommand: #toggleDefaultScriptDialogsEnabled description: 'Script &Dialogs'.
	"	name: #defaultWebviewUIEnablement;"
	aMenu
		addSeparator;
		addCommand: #toggleAllowExternalDrop description: 'Accept &Dropped Files';
		addCommand: #toggleDevToolsEnabled description: '&DevTools (F12)';
		addCommand: #toggleWebMessaging description: 'Web &Messaging';
		addSeparator;
		addCommand: #togglePinchZoomEnabled description: 'P&inch Zoom';
		addCommand: #toggleSwipeNavigation description: 'S&wipe Navigation';
		addCommand: #toggleStatusBar description: '&Status Bubbles';
		addCommand: #toggleZoomControl description: '&Zoom Control'.
	submenu := (aMenu addSubmenu: 'Preferred &Color Scheme') yourself.
	"name: #colorScheme;"
	#('&Auto' '&Light' '&Dark') keysAndValuesDo: 
			[:eachKey :eachValue |
			submenu
				addItem: ((CommandMenuItem commandDescription: (CommandDescription
								command: (Message selector: #preferredColorScheme: argument: eachKey - 1)
								description: eachValue))
						isRadioButtonStyle: true;
						yourself)].
	aMenu
		addSeparator;
		addCommand: #toggleGeneralAutofill description: 'General &Autofill';
		addCommand: #togglePasswordAutosave description: '&Password Autosave';
		addCommand: #toggleBlockImages description: 'Block &Images';
		addCommand: #toggleJavaScript description: '&JavaScript';
		addCommand: #toggleInPrivateMode description: 'In Private &Mode';
		yourself.
	submenu := (aMenu addSubmenu: '&Tracking Prevention Level') yourself.
	"name: #trackingPreventionLevel;"
	#('&None' '&Basic' 'Ba&lanced' '&Strict') keysAndValuesDo: 
			[:eachKey :eachValue |
			submenu
				addItem: ((CommandMenuItem commandDescription: (CommandDescription
								command: (Message selector: #trackingPreventionLevel: argument: eachKey - 1)
								description: eachValue))
						isRadioButtonStyle: true;
						yourself)].
	aMenu addCommand: #toggleSmartScreen description: '&SmartScreen'!

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
	self class
		when: #colorSchemeChanged
		send: #onColorSchemeChanged
		to: self.
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
				withArguments: { nil. each }].
	SessionManager current
		when: #settingChanged:
		send: #onSystemSettingChanged:
		to: self!

displayError: anException
	statusModel value: anException.
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

onColorSchemeChanged
	self view
		invalidate;
		hasDarkWindowFrame: CurrentColorScheme = WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK.
	"We have to rebuild the toolbar to repopulate it with new icons rendered from the TextTileIcons with the foreground/background colours of the new scheme"
	(self view viewNamed: 'toolbar') recreate!

onDocumentTitleChanged
	"Private - Event fired by Edge WebView2 when the document title has changed, so update the browser caption."

	self caption: self browserView documentTitle!

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

onSystemSettingChanged: anArray
	(anArray first = 'ImmersiveColorSet'
		and: [self preferredColorScheme = WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO])
			ifTrue: [self updateColorScheme]!

onViewOpened
	"Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'status'.
	statusItem model: statusModel.
	statusItem := self view viewNamed: 'zoom'.
	statusItem model: zoomModel.
	statusItem := self view viewNamed: 'profile'.
	statusItem model: profileModel!

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
	self isLoggingEvents ifTrue: [SessionManager current traceLine: trace].
	statusModel value: trace!

onWebViewAvailable
	"Private - The edge browser is loaded as a number of asynchronous steps. The #webviewAvailable event is fired when the browser is ready for navigation."

	self preferredColorScheme: PreferredColorScheme.
	"The view resource is configured in the light colour scheme, so if that is not the current scheme we'll need to rebuild the toolbar, change the caption colour, etc"
	CurrentColorScheme ~= WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT
		ifTrue: [self onColorSchemeChanged].
	"Display the Edge browser version in the status bar field on the right"
	(self view viewNamed: 'browserVersion') model: self browserView webviewEnvironment asValue.
	self onZoomFactorChanged.
	profileModel value: self browserView profile!

onZoomFactorChanged
	zoomModel value: '<1p>%%' << (self browserView zoomFactor * 100) rounded!

openTaskManagerWindow
	self webview2 openTaskManagerWindow!

openUrl: aString
	"Navigate to the specified URL."

	browser model value: aString!

preferredColorScheme
	^self profile
		ifNil: [WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO]
		ifNotNil: 
			[:profile |
			| preferred |
			preferred := profile preferredColorScheme.
			profile free.
			preferred]!

preferredColorScheme: anInteger
	"Switch the browser colour scheme to that identified by the <integer> argument, from the COREWEBVIEW2_PREFERRED_COLOR_SCHEME enumeration.
	The choices are 'auto', to track the OS setting, 'light', and 'dark'. The dark mode has detail issues, especially with the toolbar, because Windows does not provide public APIs for dark-mode theming of Win32 controls. We do the best we can with the standard theming, but but it would be worth exploring the undocumented APIs to see if some of the fit and finish issues can be eliminated."

	<commandQuery: #queryPreferredColorScheme:>
	self profile ifNotNil: [:profile | profile preferredColorScheme: anInteger].
	self updateColorScheme!

print
	self webview2 showBrowserPrintDialog!

printToPdf
	<commandQuery: #queryPrintToPdf:>
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

profile
	^self browserView profile!

queryPreferredColorScheme: aCommandQuery
	aCommandQuery
		isEnabled: self profile notNil;
		isChecked: self preferredColorScheme = aCommandQuery command argument!

queryPrintToPdf: aCommandQuery
	aCommandQuery isEnabled: (self hasWebview and: [self webview2 canPrintToPdf])!

querySwipeNavigation: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isSwipeNavigationEnabled!

queryToggleAllowContextMenu: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view allowContextMenu!

queryToggleAllowExternalDrop: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view allowExternalDrop!

queryToggleBlockImages: aCommandQuery
	aCommandQuery
		isEnabled: self hasWebview;
		isChecked: self isBlockingImages!

queryToggleBrowserAcceleratorKeysEnabled: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view areBrowserAcceleratorKeysEnabled!

queryToggleBuiltinErrorPageEnabled: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isBuiltInErrorPageEnabled!

queryToggleDefaultScriptDialogsEnabled: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view areDefaultScriptDialogsEnabled!

queryToggleDevToolsEnabled: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view areDevToolsEnabled!

queryToggleEventLogging: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isLoggingEvents!

queryToggleGeneralAutofill: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isGeneralAutofillEnabled!

queryToggleInPrivateMode: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isInPrivateModeEnabled!

queryToggleJavaScript: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isScriptEnabled!

queryTogglePasswordAutosave: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isPasswordAutosaveEnabled!

queryTogglePinchZoomEnabled: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isPinchZoomEnabled!

queryToggleSmartScreen: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isSmartScreenEnabled!

queryToggleStatusBar: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isStatusBarEnabled!

queryToggleSwipeNavigation: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isSwipeNavigationEnabled!

queryToggleWebMessaging: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isWebMessageEnabled!

queryToggleZoomControl: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view isZoomControlEnabled!

queryTrackingPreventionLevel: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self browserView trackingPreventionLevel = aCommandQuery command argument!

refresh
	self webview2 reload!

settingsMenu
	<commandQuery: #hasWebview>
	<menuPopulator: #buildSettingsPopup:>
	^self!

toggleAllowContextMenu
	<commandQuery: #queryToggleAllowContextMenu:>
	| webview |
	webview := browser view.
	webview allowContextMenu: webview allowContextMenu not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleAllowExternalDrop
	<commandQuery: #queryToggleAllowExternalDrop:>
	| webview |
	webview := browser view.
	webview allowExternalDrop: webview allowExternalDrop not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleBlockImages
	<commandQuery: #queryToggleBlockImages:>
	self isBlockingImages: self isBlockingImages not.
	self refresh!

toggleBrowserAcceleratorKeysEnabled
	<commandQuery: #queryToggleBrowserAcceleratorKeysEnabled:>
	| webview |
	webview := browser view.
	webview areBrowserAcceleratorKeysEnabled: webview areBrowserAcceleratorKeysEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleBuiltinErrorPageEnabled
	<commandQuery: #queryToggleBuiltinErrorPageEnabled:>
	| webview |
	webview := browser view.
	webview isBuiltInErrorPageEnabled: webview isBuiltInErrorPageEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleDefaultScriptDialogsEnabled
	<commandQuery: #queryToggleDefaultScriptDialogsEnabled:>
	| webview |
	webview := browser view.
	webview areDefaultScriptDialogsEnabled: webview areDefaultScriptDialogsEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleDevToolsEnabled
	<commandQuery: #queryToggleDevToolsEnabled:>
	| webview |
	webview := browser view.
	webview areDevToolsEnabled: webview areDevToolsEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleEventLogging
	<commandQuery: #queryToggleEventLogging:>
	self isLoggingEvents: self isLoggingEvents not!

toggleGeneralAutofill
	<commandQuery: #queryToggleGeneralAutofill:>
	| webview |
	webview := browser view.
	webview isGeneralAutofillEnabled: webview isGeneralAutofillEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleInPrivateMode
	<commandQuery: #queryToggleInPrivateMode:>
	browser view isInPrivateModeEnabled: self isInPrivateModeEnabled not!

toggleJavaScript
	<commandQuery: #queryToggleJavaScript:>
	| webview |
	webview := browser view.
	webview isScriptEnabled: webview isScriptEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

togglePasswordAutosave
	<commandQuery: #queryTogglePasswordAutosave:>
	| webview |
	webview := browser view.
	webview isPasswordAutosaveEnabled: webview isPasswordAutosaveEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

togglePinchZoomEnabled
	<commandQuery: #queryTogglePinchZoomEnabled:>
	browser view isPinchZoomEnabled: browser view isPinchZoomEnabled not!

toggleSmartScreen
	<commandQuery: #queryToggleSmartScreen:>
	| webview |
	webview := browser view.
	webview isSmartScreenEnabled: webview isSmartScreenEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleStatusBar
	<commandQuery: #queryToggleStatusBar:>
	| webview |
	webview := browser view.
	webview isStatusBarEnabled: webview isStatusBarEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleSwipeNavigation
	<commandQuery: #queryToggleSwipeNavigation:>
	| webview |
	webview := browser view.
	webview isSwipeNavigationEnabled: webview isSwipeNavigationEnabled not!

toggleWebMessaging
	<commandQuery: #queryToggleWebMessaging:>
	| webview |
	webview := browser view.
	webview isWebMessageEnabled: webview isWebMessageEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

toggleZoomControl
	<commandQuery: #queryToggleZoomControl:>
	| webview |
	webview := browser view.
	webview isZoomControlEnabled: webview isZoomControlEnabled not.
	"Most settings do not take effect until after navigation, so refresh"
	self refresh!

trackingPreventionLevel: anInteger
	<commandQuery: #queryTrackingPreventionLevel:>
	self browserView trackingPreventionLevel: anInteger!

updateColorScheme
	self class updateColorScheme: self preferredColorScheme!

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
browserView!accessing!public! !
buildSettingsPopup:!commands-actions!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayError:!operations!private! !
hasWebview!private!testing! !
help!commands-actions!public! !
home!commands-actions!public! !
homePage!constants!private! !
initialize!initializing!private! !
isBlockingImages!public!testing! !
isBlockingImages:!accessing!public! !
isInPrivateModeEnabled!accessing!public! !
isLoggingEvents!public!testing! !
isLoggingEvents:!commands-actions!public! !
navigate!commands-actions!public! !
navigateTo:!operations!private! !
onColorSchemeChanged!private!updating! !
onDocumentTitleChanged!event handling!private! !
onFavIconChanged!event handling!private! !
onProcessFailed:!event handling!private! !
onSourceChanged:!event handling!private! !
onSystemSettingChanged:!event handling-win32!private! !
onViewOpened!event handling!public! !
onWebResourceRequested:!event handling!private! !
onWebView2Event:name:!event handling!private! !
onWebViewAvailable!event handling!private! !
onZoomFactorChanged!event handling!private! !
openTaskManagerWindow!commands-actions!public! !
openUrl:!operations!public! !
preferredColorScheme!accessing!public! !
preferredColorScheme:!commands-actions!public! !
print!commands-actions!public! !
printToPdf!commands-actions!public! !
profile!accessing!public! !
queryPreferredColorScheme:!commands-queries!private! !
queryPrintToPdf:!commands-queries!private! !
querySwipeNavigation:!commands-queries!private! !
queryToggleAllowContextMenu:!commands-queries!private! !
queryToggleAllowExternalDrop:!commands-queries!private! !
queryToggleBlockImages:!commands-queries!private! !
queryToggleBrowserAcceleratorKeysEnabled:!commands-queries!private! !
queryToggleBuiltinErrorPageEnabled:!commands-queries!private! !
queryToggleDefaultScriptDialogsEnabled:!commands-queries!private! !
queryToggleDevToolsEnabled:!commands-queries!private! !
queryToggleEventLogging:!commands-queries!private! !
queryToggleGeneralAutofill:!commands-queries!private! !
queryToggleInPrivateMode:!commands-queries!private! !
queryToggleJavaScript:!commands-queries!private! !
queryTogglePasswordAutosave:!commands-queries!private! !
queryTogglePinchZoomEnabled:!commands-queries!private! !
queryToggleSmartScreen:!commands-queries!private! !
queryToggleStatusBar:!commands-queries!private! !
queryToggleSwipeNavigation:!commands-queries!private! !
queryToggleWebMessaging:!commands-queries!private! !
queryToggleZoomControl:!commands-queries!private! !
queryTrackingPreventionLevel:!commands-queries!private! !
refresh!commands-actions!public! !
settingsMenu!commands-actions!public! !
toggleAllowContextMenu!commands-actions!public! !
toggleAllowExternalDrop!commands-actions!public! !
toggleBlockImages!commands-actions!public! !
toggleBrowserAcceleratorKeysEnabled!commands-actions!public! !
toggleBuiltinErrorPageEnabled!commands-actions!public! !
toggleDefaultScriptDialogsEnabled!commands-actions!public! !
toggleDevToolsEnabled!commands-actions!public! !
toggleEventLogging!commands-actions!public! !
toggleGeneralAutofill!commands-actions!public! !
toggleInPrivateMode!commands-actions!public! !
toggleJavaScript!commands-actions!public! !
togglePasswordAutosave!commands-actions!public! !
togglePinchZoomEnabled!commands-actions!public! !
toggleSmartScreen!commands-actions!public! !
toggleStatusBar!commands-actions!public! !
toggleSwipeNavigation!commands-actions!public! !
toggleWebMessaging!commands-actions!public! !
toggleZoomControl!commands-actions!public! !
trackingPreventionLevel:!commands-actions!public! !
updateColorScheme!private!updating! !
webview2!accessing!private! !
webviewSettings!accessing!private! !
zoomReset!commands-actions!public! !
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
		helpId: 10621.
	PreferredColorScheme := WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO.
	CurrentColorScheme := WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT.
	(ColorSchemes at: CurrentColorScheme)
		keysAndValuesDo: [:eachKey :eachValue | ThemeColor addNamed: eachKey color: eachValue]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #browserBar nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 5 nil nil nil 160 nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140851532 131137 272 nil 112 nil 517 nil nil nil 272 nil nil 226 #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 8 1094 1 #{UI.ToolbarIconButton} 272 5 1350 4 #{UI.CommandDescription} #home 8 'Home page' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $⌂ nil 98 #browserToolbarButton 98 #browserForeground nil nil 1 nil nil nil 386 272 1 418 #goBack 8 'Back' 1 1 466 8 $🡠 nil 512 98 #browserHistoryArrow nil nil 1 nil nil nil 386 272 1 418 #goForward 8 'Forward' 1 1 466 8 $🡢 nil 512 624 nil nil 1 nil nil nil 386 272 1 418 #print 8 'Print ...' 1 1 466 8 $🖶 nil 512 528 nil nil 1 nil nil nil 386 272 1 418 #help 8 'Information' 1 1 466 8 $🛈 nil 512 528 nil nil 1 nil nil nil 386 272 1 418 #openTaskManagerWindow 8 'Open &Task Manager' 1 1 466 8 $⚛ nil 512 528 nil nil 1 nil nil nil 386 272 273 418 #settingsMenu 8 'Settings' 1 1 466 8 $⚙ nil 512 528 nil nil 1 nil nil nil 582 1 #{UI.ToolbarSeparator} 272 1 nil nil 1 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 5 3 1170 581 79 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 1 0 0 0 36 1 0 0 40 0 0 0] 8 #() 1170 193 193 nil 29 8 'browserTools' nil nil nil nil 8 #() nil 518 #{Graphics.Rectangle} 1170 5 3 1170 5 5 1 nil 1170 65 65 nil nil 130 1 1 nil nil nil 272 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 1424 nil 112 nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1170 193 193 nil 1424 130 9 1 nil nil 18 #{UI.PushButton} 50 20 nil 1424 50 2 8 1140924416 1 1600 nil 112 1170 101 51 5 nil nil nil 1600 nil nil 418 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1074 50 3 1122 #createAt:extent: 50 2 1170 1673 13 1170 101 57 1600 1122 #isEnabled: 8 #(false) 1600 1122 #text: 50 1 8 '&Go' 1600 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 68 3 0 0 6 0 0 0 118 3 0 0 34 0 0 0] 8 #() 1280 nil 29 nil 18 #{UI.TextEdit} 50 20 nil 1424 50 2 8 1149304960 1 1936 nil 98 #browserBackground nil 5 2886 4 #{UI.Menu} nil true 50 2 1094 2 #{UI.CommandMenuItem} 1 418 #navigate 8 '&Go' 1 1 nil nil nil 2066 2097153 418 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1936 528 nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 1074 50 2 1122 #createAt:extent: 50 2 1170 9 13 1170 1657 57 1936 1122 #setMarginWidths: 50 1 8 #(4 4) 1936 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 6 0 0 0 64 3 0 0 34 0 0 0] 8 #() 1280 nil 45 226 #{Core.IdentityDictionary} 50 4 1936 8 'address' 1600 8 'go' 1330 1170 9 13 1170 9 11 1074 50 1 1122 #createAt:extent: 50 2 1170 585 3 1170 1781 79 1424 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 36 1 0 0 1 0 0 0 158 4 0 0 40 0 0 0] 50 2 1936 1600 1280 nil 27 1074 50 1 1122 #createAt:extent: 50 2 1170 1 1 1170 2369 85 160 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 42 0 0 0] 50 2 272 1424 1280 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 65 2816 nil 6 #{Graphics.Color} #transparent nil 5 nil 1542 #{Graphics.UxThemeFont} nil true nil 1568 1609 nil nil 2816 528 nil 226 #{Core.IdentityDictionary} 50 8 1862 1 #{UI.StatusBarItem} 8193 301 2816 nil 518 #{Core.Message} #displayString 8 #() 3010 #iconImageIndex 8 #() nil 8 'browserVersion' 2978 8193 251 2816 nil 3010 #displayString 8 #() 3010 #iconImageIndex 3136 nil 8 'profile' 2978 8193 -1 2816 nil 3010 #displayString 3072 nil nil 8 'status' 2978 8193 101 2816 nil 3010 #displayString 8 #() nil nil 8 'zoom' nil nil nil 50 4 3184 3104 3232 2992 1094 1 #{UI.StatusBarNullItem} 8705 1 2816 nil nil 1074 50 1 1122 #createAt:extent: 50 2 1170 1 1533 1170 2369 43 2816 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 8 #() 1280 nil 29 nil nil 18 #{UI.WebView2View} 50 26 nil 32 50 2 8 1140850688 1 3488 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 3488 nil nil 2194 nil nil 262145 nil nil nil nil nil 1286 #{WebView2.WebView2EnvironmentOptions} nil 15 nil 8 '110.0.1549.0' 5 nil nil nil nil 1074 50 1 1122 #createAt:extent: 50 2 1170 1 85 1170 2369 1449 3488 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 160 4 0 0 254 2 0 0] 352 1280 nil 29 226 #{Core.IdentityDictionary} 50 6 3488 8 'browser' 2816 8 'progress' 160 8 'toolbar' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1074 50 2 1122 #createAt:extent: 50 2 1170 6143 21 1170 2401 1653 32 1122 #text: 50 1 8 'WebView2 Browser' 32 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 50 3 2816 160 3488 1280 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

updateColorScheme: anInteger
	| actual |
	PreferredColorScheme := anInteger.
	actual := anInteger = WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO
				ifTrue: 
					["[Microsoft recommand a cheesy check on the value of the system foreground colour](https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/apply-windows-themes) to detect if in dark mode!! Just too horrible, so use the undocumented theme API instead."
					UxTheme refreshImmersiveColorPolicyState.
					actual := UxTheme shouldAppsUseDarkMode
								ifTrue: [WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK]
								ifFalse: [WebView2.COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT]]
				ifFalse: [anInteger].
	CurrentColorScheme = actual ifTrue: [^self].
	CurrentColorScheme := actual.
	(ColorSchemes at: actual)
		keysAndValuesDo: [:eachKey :eachValue | (Color named: eachKey) actualColor: eachValue].
	self trigger: #colorSchemeChanged! !
!OS.COM.Examples.WebBrowserShell class categoriesForMethods!
displayOn:!printing!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
updateColorScheme:!private!updating! !
!

