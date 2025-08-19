"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'OS.COM.Examples.WebBrowserShell'
	instanceVariableNames: 'address browser statusModel zoomModel flags profileModel'
	classVariableNames: 'CurrentColorScheme PreferredColorScheme'
	imports: #(#{UI} #{WebView2 private})
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
			'DisableScreenCaptureMask' -> 16r8.
			'ImagesBlockedMask' -> 16r2.
			'LogEventsMask' -> 16r1.
			'SuppressSaveAsDialogMask' -> 16r4
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

areBrowserExtensionsEnabled
	^browser view areBrowserExtensionsEnabled!

browserExtensionsMenu
	<commandQuery: #hasWebview>
	<commandQuery: #areBrowserExtensionsEnabled>
	"Because the query to return the extensions list is asynchronous, the experience is not very good if we defer the query until the menu is about to popup. It is better to build this directly while building the outer settings menu."
	"<menuPopulator: #buildExtensionsMenu:>"
	!

browserScrollBarStyle: anInteger
	"Note that if we named this #scrollBarStyle:, if the browser view itself has focus then because WebView2View implements #scrollBarStyle:, then the command routing framework would judge the browser view to be a valid command target meaning that our command query would not be run, and the radio buttons would not be set. We could alter the command routing to avoid this, but it is simpler just to use a different selector for the command."

	<commandQuery: #queryScrollBarStyle:>
	self browserView scrollBarStyle: anInteger!

browserTrackingPreventionLevel: anInteger
	<commandQuery: #queryTrackingPreventionLevel:>
	self browserView trackingPreventionLevel: anInteger!

browserView
	^browser view!

buildBrowserExtensionsMenu: aMenu
	aMenu clear.
	self webview2 profile getBrowserExtensionsThenDo: 
			[:hr :extensionsList |
			hr = S_OK
				ifTrue: 
					[extensionsList do: 
							[:each |
							aMenu addCommand: (Message selector: #toggleEnableBrowserExtension: argument: each)
								description: each name]]]!

buildColorSchemeMenu: aMenu
	aMenu clear.
	#('&Auto' '&Light' '&Dark') keysAndValuesDo: 
			[:eachKey :eachValue |
			aMenu
				addItem: ((CommandMenuItem command: (Message selector: #preferredColorScheme: argument: eachKey - 1)
						description: eachValue)
						isRadioButtonStyle: true;
						yourself)]!

buildScrollBarStyleMenu: aMenu
	aMenu clear.
	#('&Default' '&Fluent Overlay') keysAndValuesDo: 
			[:eachKey :eachValue |
			aMenu addItem: ((CommandMenuItem command: (Message selector: #browserScrollBarStyle: argument: eachKey - 1)
						description: eachValue)
						isRadioButtonStyle: true;
						yourself)]!

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
		addCommand: #toggleDefaultScriptDialogsEnabled description: 'Script &Dialogs';
		addCommand: #toggleSuppressSaveAsDialog description: 'Sa&ve As Dialog'.
	aMenu
		addSeparator;
		addCommand: #toggleEnableBrowserExtensions description: 'Enable E&xtensions'.
	submenu := aMenu addSubmenu: '&Extensions'.
	submenu name: #browserExtensionsMenu.
	"Better UI experience if we trigger the asynchronous query to get the browser extensions list now"
	self buildBrowserExtensionsMenu: submenu.
	aMenu
		addSeparator;
		addCommand: #toggleAllowExternalDrop description: 'Accept &Dropped Files';
		addCommand: #toggleDevToolsEnabled description: '&DevTools (F12)';
		addCommand: #toggleWebMessaging description: 'Web &Messaging';
		addSeparator;
		addCommand: #togglePinchZoomEnabled description: 'P&inch Zoom';
		addCommand: #toggleSwipeNavigation description: 'S&wipe Navigation';
		addCommand: #toggleStatusBar description: '&Status Bubbles';
		addCommand: #toggleZoomControl description: '&Zoom Control';
		addItem: ((Menu description: 'Preferred &Color Scheme')
					name: #colorSchemeMenu;
					yourself);
		addCommand: #chooseBackcolor description: 'Background &Color';
		addItem: ((Menu description: '&ScrollBar Style')
					name: #scrollBarStyleMenu;
					yourself);
		addSeparator;
		addCommand: #toggleGeneralAutofill description: 'General &Autofill';
		addCommand: #togglePasswordAutosave description: '&Password Autosave';
		addCommand: #toggleBlockImages description: 'Block &Images';
		addCommand: #toggleDisableScreenCapture description: 'Disable Scree&n Capture';
		addCommand: #toggleJavaScript description: '&JavaScript';
		addCommand: #toggleInPrivateMode description: 'In Private &Mode';
		addItem: ((Menu description: '&Tracking Prevention Level')
					name: #trackingPreventionLevelMenu;
					yourself);
		addCommand: #toggleSmartScreen description: '&SmartScreen'!

buildTrackingPreventionLevelMenu: aMenu
	aMenu clear.
	#('&None' '&Basic' 'Ba&lanced' '&Strict') keysAndValuesDo: 
			[:eachKey :eachValue |
			aMenu addItem: ((CommandMenuItem
						command: (Message selector: #browserTrackingPreventionLevel: argument: eachKey - 1)
						description: eachValue)
						isRadioButtonStyle: true;
						yourself)]!

chooseBackcolor
	<commandQuery: #hasWebview>
	| color |
	color := browser view actualBackcolor.
	color = (Color named: #browserBackground) ifTrue: [color := Color default].
	color := color asValue.
	(ColorDialog showModalOn: color) ifNil: [^self].
	color := color value.
	color isDefault ifTrue: [color := Color named: #browserBackground].
	browser view backcolor: color!

colorSchemeMenu
	<commandQuery: #hasWebview>
	<menuPopulator: #buildColorSchemeMenu:>
	!

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
	browser view
		when: #environmentAvailable
		send: #onWebViewEnvironmentAvailable
		to: self.
	browser
		when: #controllerAvailable
			send: #onWebViewControllerAvailable
			to: self;
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
			to: self;
		when: #saveAsUIShowing:
			send: #onSaveAs:
			to: self;
		when: #permissionRequested:
			send: #onPagePermissionRequested:
			to: self;
		when: #framePermissionRequested:
			send: #onFramePermissionRequested:
			to: self;
		when: #notificationReceived:
			send: #onNotificationReceived:
			to: self;
		when: #screenCaptureStarting:
			send: #onScreenCaptureStarting:
			to: self;
		when: #webMessageReceived:
			send: #onWebMessageReceived:
			to: self;
		when: #basicAuthenticationRequested:
			send: #onBasicAuthenticationRequested:
			to: self.

	"We don't really need all these other events, but observe them for illustrative purposes"
	WebView2View webview2Events do: 
			[:each |
			browser
				when: each
				send: #onWebView2EventWith:with:name:
				to: self
				withArguments: { nil. nil. each }].
	SessionManager current
		when: #settingChanged:
		send: #onSystemSettingChanged:
		to: self!

displayError: anException
	statusModel value: anException.
	^Sound errorBeep!

find
	"Launch the browser Find experiencein response to a generic toolbar find command."

	<commandQuery: #queryFind:>
	browser view find!

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

isInPrivateModeEnabled
	^browser view isInPrivateModeEnabled!

isLoggingEvents
	"Answer whether WebView2 events should be logged to the transcript."

	^flags allMask: LogEventsMask!

isLoggingEvents: aBoolean
	"Enable/disable logging of WebView2 events to the transcript."

	flags := flags mask: LogEventsMask set: aBoolean!

isSaveAsDialogSuppressed
	"Answer whether the Save As dialog should be suppressed. If so the complete web page is just downloaded to its default path without the intervening file dialog."

	^flags allMask: SuppressSaveAsDialogMask!

isSaveAsDialogSuppressed: aBoolean
	"Enable/disable the file Save As dialog normally shown when the context menu Save As command is actioned. Note that the sense of this flag is inverted. When the argument is true, the dialog is disabled."

	flags := flags mask: SuppressSaveAsDialogMask set: aBoolean!

isScreenCaptureDisabled
	^flags allMask: DisableScreenCaptureMask!

isScreenCaptureDisabled: aBoolean 
	flags := flags mask: DisableScreenCaptureMask set: aBoolean!

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
			ex hresult asInteger = E_INVALIDARG
				ifTrue: 
					[(aString notEmpty and: 
							[(aString indexOfSubCollection: '://') == 0
								and: [(aString anySatisfy: [:each | each isSeparator]) not]])
						ifTrue: 
							[address value: 'https://' , aString.
							self navigate]
						ifFalse: 
							[ex messageText: 'Invalid Url: ' , aString.
							self displayError: ex]]
				ifFalse: [self displayError: ex]]!

onBasicAuthenticationRequested: anICoreWebView2BasicAuthenticationRequestedEventArgs
	"Private - Example showing unprompted response to basic auth request (visit https://authenticationtest.com/HTTPAuth/)"

	anICoreWebView2BasicAuthenticationRequestedEventArgs uri
		= 'https://authenticationtest.com/HTTPAuth/'
			ifTrue: 
				[anICoreWebView2BasicAuthenticationRequestedEventArgs response
					userName: 'user';
					password: 'pass']
	"If no response is provided (and the request is not marked as cancelled), the browser will prompt for credentials"!

onColorSchemeChanged
	self view
		invalidate;
		hasDarkWindowFrame: CurrentColorScheme = COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK.
	browser view backcolorChanged.
	"Webhave to rebuild the toolbar to repopulate it with new icons rendered from the TextTileIcons with the foreground/background colours of the new scheme"
	(self view viewNamed: 'toolbar') recreate!

onDocumentTitleChanged
	"Private - Event fired by Edge WebView2 when the document title has changed, so update the browser caption."

	self caption: self browserView documentTitle!

onFavIconChanged
	self webview2 getFavIcon: COREWEBVIEW2_FAVICON_IMAGE_FORMAT_PNG
		thenDo: [:hr :stream | self view smallIcon: (Gdiplus.Bitmap fromIStream: stream) asIcon]!

onFramePermissionRequested: anICoreWebView2PermissionRequestedEventArgs
	"Handle a permission request from a frame."

	self onPermissionRequested: anICoreWebView2PermissionRequestedEventArgs level: 'frame'!

onNotificationReceived: anICoreWebView2NotificationReceivedEventArgs
	"Private - Here we can choose to display the notification in a custom way, e.g. using our own message bubble, and mark the argument as handled to suppress the default handling (which is to display a popup message similar to a taskbar notification).
	We could also just suppress the notification, although a better way to do that in general would be to deny Notifications permission when requested."

	"To test try https://html-preview.github.io/?url=https://github.com/MicrosoftEdge/WebView2Samples/blob/main/SampleApps/WebView2APISample/assets/ScenarioNotificationReceived.html"

	"Note that we are observing the notification close requested event here only for illustrative purposes, not really to do anything especially useful with it. This event is unusual in that it is not implemented by one of the main WebView2 objects (environment, controller, and view), but rather by a temporary object (an ICoreWebView2Notification). This makes it more difficult to manaage the lifetime correctly to avoid a leak caused by the circular reference between the notification object and the observing event sink. Our event sinks hold a reference (and implicitly a COM reference) to the event source. The event source in turn holds a COM reference to any registered event sinks, creating a circular reference. Normally our event sinks have a well known point at which they can be explicitly unregistered, typically when the browser control is closed. Explicitly unregistering the event releases the references in both directions, allowing the COM objects at either end to be released if they are not in use elsewhere. In this case however, we are sinking an event from an object that we do not control the lifetime of, and furthermore the event itself may not be received at all. In fact we only receive the close requested event when the notification is clicked (and perhaps when close is requested in script). When the default  notification UI is used, we get no event (and apparently have no other way of knowing) if the notification is closed explicitly by the user clicking the close button rather than clicking the notification itself. Consequently we cannot rely on receiving the event to be able to unregister in a timely manner. The webview2 docs suggest that in general event handlers can avoid leaks by not taking a reference to the source (observed object). However even if we eschew our usual reference to the observed object from the sink, the WebView2 control does not clean things up when the notification is closed using the close button. Therefore to avoid a leak in this case we add the sink to the global set of live handlers owned by the view. Although this means the handler will likely persist much longer than is needed, it will at least be cleaned up when the browser control is closed. In a real application the most likely reason to hook this event would seem to be to know to close a custom notification, the event handler can be associated with the lifetime of that custom notification itself."

	| closeRequested |
	closeRequested := WebView2EventSink new.
	closeRequested
		source: anICoreWebView2NotificationReceivedEventArgs notification
		interfaceClass: ICoreWebView2NotificationCloseRequestedEventHandler
		handler: 
			[:source :args |
			self onWebView2EventWith: source with: args name: ICoreWebView2NotificationCloseRequestedEventHandler eventName.
			self browserView unregisterEventSink: closeRequested].
	self browserView registerEventSink: closeRequested!

onPagePermissionRequested: anICoreWebView2PermissionRequestedEventArgs
	"Handle a permission request from a page."

	self onPermissionRequested: anICoreWebView2PermissionRequestedEventArgs level: 'page'!

onPermissionRequested: anICoreWebView2PermissionRequestedEventArgs level: aString
	"Handle a permission request from a page."

	"To test try https://html-preview.github.io/?url=https://github.com/MicrosoftEdge/WebView2Samples/blob/main/SampleApps/WebView2APISample/assets/ScenarioNotificationReceived.html"

	| mb details |
	"Permission may have already been chosen, e.g. from frame."
	anICoreWebView2PermissionRequestedEventArgs permissionState ifNotNil: [^self].
	details := String writeStream.
	'This request <?originated:did not originate> from a user gesture.'
		expandMacrosWithArguments: { anICoreWebView2PermissionRequestedEventArgs isUserInitiated }
		on: details.
	details
		cr;
		nextPutAll: 'Requesting Uri: ';
		nextPutAll: anICoreWebView2PermissionRequestedEventArgs uri;
		cr;
		nextPutAll: 'Current permission: ';
		nextPutAll: anICoreWebView2PermissionRequestedEventArgs stateName.
	mb := MessageBox new
				headline: 'Permit <1s>?' << anICoreWebView2PermissionRequestedEventArgs permissionName;
				customButtons: #(#(#yes '&Allow') #(#no '&Deny'));
				isCancellable: false;
				detailsText: details contents;
				checkboxText: 'Save to profile?';
				isChecked: anICoreWebView2PermissionRequestedEventArgs savesInProfile;
				iconStyle: #shield;
				yourself.
	(mb confirm: 'The <2s> is requesting permission for <1s>. Do you want to allow this?'
				<< { anICoreWebView2PermissionRequestedEventArgs permissionName. aString })
		ifNotNil: 
			[:answer |
			anICoreWebView2PermissionRequestedEventArgs
				permissionState: answer;
				savesInProfile: mb isChecked]!

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

onSaveAs: anICoreWebView2SaveAsUIShowingEventArgs
	anICoreWebView2SaveAsUIShowingEventArgs
		allowReplace: true;
		kind: COREWEBVIEW2_SAVE_AS_KIND_COMPLETE;
		suppressDefaultDialog: self isSaveAsDialogSuppressed!

onScreenCaptureStarting: anICoreWebView2ScreenCaptureStartingEventArgs 
	"To test: https://html-preview.github.io/?url=https://github.com/MicrosoftEdge/WebView2Samples/blob/main/SampleApps/WebView2APISample/assets/ScenarioScreenCapture.html"

	self isScreenCaptureDisabled ifTrue: [anICoreWebView2ScreenCaptureStartingEventArgs cancel: true].!

onSourceChanged: anICoreWebView2NavigationCompletedEventArgs
	"Private - Event fired by Edge WebView2 when a the 'source' has changed - this may include in-page navigation, in which case the document will not have changed, but the source URI will."

	"Keep the address bar in sync"

	address model value: self browserView model value!

onSystemSettingChanged: anArray
	(anArray first = 'ImmersiveColorSet'
		and: [self preferredColorScheme = COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO])
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

onWebMessageReceived: anICoreWebView2WebMessageReceivedEventArgs2
	| message |
	message := anICoreWebView2WebMessageReceivedEventArgs2 tryGetWebMessageAsString.
	"e.g. Implement web messages to back sample scenario https://html-preview.github.io/?url=https://github.com/MicrosoftEdge/WebView2Samples/blob/main/SampleApps/WebView2APISample/assets/ScenarioScreenCapture.html"
	message = 'DisableScreenCapture'
		ifTrue: 
			[self isScreenCaptureDisabled: true.
			^self].
	message = 'EnableScreenCapture'
		ifTrue: 
			[self isScreenCaptureDisabled: false.
			^self].
	^self!

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

onWebView2EventWith: arg1 with: arg2 name: aSymbol
	| trace |
	trace := aSymbol lastCodeUnit == $:
				ifFalse: [aSymbol]
				ifTrue: 
					[String streamContents: 
							[:strm |
							| args |
							args := { arg1. arg2 } readStream.
							aSymbol keywords do: 
									[:each |
									strm
										nextPutAll: each;
										space;
										print: args next]
								separatedBy: [strm space]]].
	self isLoggingEvents ifTrue: [SessionManager current traceLine: trace].
	statusModel value: (EventNotification messageText: trace)!

onWebViewAvailable
	"Private - The edge browser is loaded as a number of asynchronous steps. The #webviewAvailable event is fired when the browser is ready for navigation."

	self preferredColorScheme: PreferredColorScheme.
	"The view resource is configured in the light colour scheme, so if that is not the current scheme we'll need to rebuild the toolbar, change the caption colour, etc"
	CurrentColorScheme ~= COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT
		ifTrue: [self onColorSchemeChanged].
	"Display the Edge browser version in the status bar field on the right"
	(self view viewNamed: 'browserVersion') model: self browserView webviewEnvironment asValue.
	self onZoomFactorChanged.
	"profileModel value: self browserView profile"!

onWebViewControllerAvailable
	"Private - Not really a view event, but send through the trace logic anyway"

	self onWebView2EventWith: self browserView webviewController with: nil name: #controllerAvailable:!

onWebViewEnvironmentAvailable
	"Private - Not really a view event, but send through the trace logic anyway"

	self onWebView2EventWith: self browserView webviewEnvironment with: nil name: #environmentAvailable:!

onZoomFactorChanged
	zoomModel value: '<1p>%%' << (self browserView zoomFactor * 100) rounded!

openTaskManagerWindow
	self webview2 openTaskManagerWindow!

openUrl: aString
	"Navigate to the specified URL."

	browser model value: aString!

preferredColorScheme
	^self profile
		ifNil: [COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO]
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

queryFind: aCommandQuery
	browser view queryFind: aCommandQuery!

queryPreferredColorScheme: aCommandQuery
	aCommandQuery
		isEnabled: self profile notNil;
		isChecked: self preferredColorScheme = aCommandQuery command argument!

queryPrintToPdf: aCommandQuery
	aCommandQuery isEnabled: (self hasWebview and: [self webview2 canPrintToPdf])!

queryScrollBarStyle: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self browserView scrollBarStyle = aCommandQuery command argument!

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

queryToggleDisableScreenCapture: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isScreenCaptureDisabled!

queryToggleEnableBrowserExtension: aCommandQuery
	| browserExt |
	browserExt := aCommandQuery command arguments single.
	aCommandQuery
		beEnabled;
		isChecked: browserExt isEnabled!

queryToggleEnableBrowserExtensions: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: browser view areBrowserExtensionsEnabled!

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

queryToggleSuppressSaveAsDialog: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isSaveAsDialogSuppressed not!

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

saveAs
	self webview2 showSaveAsUIThenDo: 
			[:hresult :saveAsUiResult |
			saveAsUiResult ~= COREWEBVIEW2_SAVE_AS_UI_RESULT_SUCCESS
				ifTrue: 
					[Notification signal: 'showSaveAsUI failed: <1d>'
								<< (#('COREWEBVIEW2_SAVE_AS_UI_RESULT_SUCCESS' 'COREWEBVIEW2_SAVE_AS_UI_RESULT_INVALID_PATH' 'COREWEBVIEW2_SAVE_AS_UI_RESULT_FILE_ALREADY_EXISTS' 'COREWEBVIEW2_SAVE_AS_UI_RESULT_KIND_NOT_SUPPORTED' 'COREWEBVIEW2_SAVE_AS_UI_RESULT_CANCELLED')
										lookup: saveAsUiResult + 1)]]!

scrollBarStyleMenu
	<commandQuery: #hasWebview>
	<menuPopulator: #buildScrollBarStyleMenu:>
	!

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

toggleDisableScreenCapture
	<commandQuery: #queryToggleDisableScreenCapture:>
	self isScreenCaptureDisabled: self isScreenCaptureDisabled not!

toggleEnableBrowserExtension: anICoreWebView2BrowserExtension
	"Note that this doesn't appear to have any lasting effect. The interface indicates that an extension has been disabled, but when the list of extensions are queried again, they are all enabled."

	<commandQuery: #queryToggleEnableBrowserExtension:>
	| enable |
	enable := anICoreWebView2BrowserExtension isEnabled not.
	anICoreWebView2BrowserExtension enable: enable
		thenDo: 
			[:hr |
			SessionManager current traceLine: '<1?Enabled:Disabled> extension <2p> (<3d>)'
						<< { enable. anICoreWebView2BrowserExtension name. HRESULT fromInteger: 0 }]!

toggleEnableBrowserExtensions
	<commandQuery: #queryToggleEnableBrowserExtensions:>
	browser view areBrowserExtensionsEnabled: self areBrowserExtensionsEnabled not!

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

toggleSuppressSaveAsDialog
	<commandQuery: #queryToggleSuppressSaveAsDialog:>
	self isSaveAsDialogSuppressed: self isSaveAsDialogSuppressed not!

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

trackingPreventionLevelMenu
	<commandQuery: #hasWebview>
	<menuPopulator: #buildTrackingPreventionLevelMenu:>
	!

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
areBrowserExtensionsEnabled!commands-queries!public! !
browserExtensionsMenu!commands-menus!public! !
browserScrollBarStyle:!commands-actions!public! !
browserTrackingPreventionLevel:!commands-actions!public! !
browserView!accessing!public! !
buildBrowserExtensionsMenu:!commands-menus!private! !
buildColorSchemeMenu:!commands-menus!private! !
buildScrollBarStyleMenu:!commands-menus!private! !
buildSettingsPopup:!commands-menus!private! !
buildTrackingPreventionLevelMenu:!commands-menus!private! !
chooseBackcolor!commands-actions!public! !
colorSchemeMenu!commands-menus!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
displayError:!operations!private! !
find!commands-actions!public!searching & replacing! !
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
isSaveAsDialogSuppressed!public!testing! !
isSaveAsDialogSuppressed:!accessing!public! !
isScreenCaptureDisabled!public!testing! !
isScreenCaptureDisabled:!accessing!public! !
navigate!commands-actions!public! !
navigateTo:!operations!private! !
onBasicAuthenticationRequested:!event handling!private! !
onColorSchemeChanged!private!updating! !
onDocumentTitleChanged!event handling!private! !
onFavIconChanged!event handling!private! !
onFramePermissionRequested:!event handling!private! !
onNotificationReceived:!private! !
onPagePermissionRequested:!event handling!private! !
onPermissionRequested:level:!event handling!private! !
onProcessFailed:!event handling!private! !
onSaveAs:!event handling!private! !
onScreenCaptureStarting:!private! !
onSourceChanged:!event handling!private! !
onSystemSettingChanged:!event handling-win32!private! !
onViewOpened!event handling!public! !
onWebMessageReceived:!event handling!private! !
onWebResourceRequested:!event handling!private! !
onWebView2EventWith:with:name:!event handling!private! !
onWebViewAvailable!event handling!private! !
onWebViewControllerAvailable!private! !
onWebViewEnvironmentAvailable!private! !
onZoomFactorChanged!event handling!private! !
openTaskManagerWindow!commands-actions!public! !
openUrl:!operations!public! !
preferredColorScheme!accessing!public! !
preferredColorScheme:!commands-actions!public! !
print!commands-actions!public! !
printToPdf!commands-actions!public! !
profile!accessing!public! !
queryFind:!commands-queries!private! !
queryPreferredColorScheme:!commands-queries!private! !
queryPrintToPdf:!commands-queries!private! !
queryScrollBarStyle:!commands-queries!private! !
querySwipeNavigation:!commands-queries!private! !
queryToggleAllowContextMenu:!commands-queries!private! !
queryToggleAllowExternalDrop:!commands-queries!private! !
queryToggleBlockImages:!commands-queries!private! !
queryToggleBrowserAcceleratorKeysEnabled:!commands-queries!private! !
queryToggleBuiltinErrorPageEnabled:!commands-queries!private! !
queryToggleDefaultScriptDialogsEnabled:!commands-queries!private! !
queryToggleDevToolsEnabled:!commands-queries!private! !
queryToggleDisableScreenCapture:!commands-queries!private! !
queryToggleEnableBrowserExtension:!commands-queries!private! !
queryToggleEnableBrowserExtensions:!commands-queries!private! !
queryToggleEventLogging:!commands-queries!private! !
queryToggleGeneralAutofill:!commands-queries!private! !
queryToggleInPrivateMode:!commands-queries!private! !
queryToggleJavaScript:!commands-queries!private! !
queryTogglePasswordAutosave:!commands-queries!private! !
queryTogglePinchZoomEnabled:!commands-queries!private! !
queryToggleSmartScreen:!commands-queries!private! !
queryToggleStatusBar:!commands-queries!private! !
queryToggleSuppressSaveAsDialog:!commands-queries!private! !
queryToggleSwipeNavigation:!commands-queries!private! !
queryToggleWebMessaging:!commands-queries!private! !
queryToggleZoomControl:!commands-queries!private! !
queryTrackingPreventionLevel:!commands-queries!private! !
refresh!commands-actions!public! !
saveAs!commands-actions!public! !
scrollBarStyleMenu!commands-menus!public! !
settingsMenu!commands-actions!public! !
toggleAllowContextMenu!commands-actions!public! !
toggleAllowExternalDrop!commands-actions!public! !
toggleBlockImages!commands-actions!public! !
toggleBrowserAcceleratorKeysEnabled!commands-actions!public! !
toggleBuiltinErrorPageEnabled!commands-actions!public! !
toggleDefaultScriptDialogsEnabled!commands-actions!public! !
toggleDevToolsEnabled!commands-actions!public! !
toggleDisableScreenCapture!commands-actions!public! !
toggleEnableBrowserExtension:!commands-actions!public! !
toggleEnableBrowserExtensions!commands-actions!public! !
toggleEventLogging!commands-actions!public! !
toggleGeneralAutofill!commands-actions!public! !
toggleInPrivateMode!commands-actions!public! !
toggleJavaScript!commands-actions!public! !
togglePasswordAutosave!commands-actions!public! !
togglePinchZoomEnabled!commands-actions!public! !
toggleSmartScreen!commands-actions!public! !
toggleStatusBar!commands-actions!public! !
toggleSuppressSaveAsDialog!commands-actions!public! !
toggleSwipeNavigation!commands-actions!public! !
toggleWebMessaging!commands-actions!public! !
toggleZoomControl!commands-actions!public! !
trackingPreventionLevelMenu!commands-menus!public! !
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

	^WebView2View icon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10621.
	PreferredColorScheme := COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO.
	CurrentColorScheme := COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT.
	(ColorSchemes at: CurrentColorScheme)
		keysAndValuesDo: [:eachKey :eachValue | ThemeColor addNamed: eachKey color: eachValue]!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #browserBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131137 160 nil 98 #browserBar nil 517 nil nil nil 160 224 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1140857676 131137 288 nil 224 nil 517 nil nil nil 288 nil nil 242 #{Core.IdentityDictionary} 8 #() nil nil 98 #browserForeground nil 50 11 1862 2 #{UI.ToolbarTextButton} 288 161 1350 4 #{UI.CommandDescription} #goBack 8 'Back' 1 1 nil nil 98 #browserHistoryArrow nil 8 $\xE830 418 288 161 450 #goForward 8 'Forward' 1 1 nil nil 496 nil 8 $\xEA47 418 288 161 450 #refresh 8 'Re&fresh (Ctrl+R)' 9381 1 nil nil nil nil 8 $\xE72C 418 288 161 450 #home 8 'Home page' 1 1 nil nil nil nil 8 $\xE80F 418 288 161 450 #find 8 '&Find' 1 1 nil nil nil nil 8 $\xE721 418 288 161 450 #print 8 'Print ...' 1 1 nil nil nil nil 8 $\xE749 418 288 161 450 #saveAs 8 'Save As ...' 1 1 nil nil nil nil 8 $\xE78C 418 288 161 450 #help 8 'Information' 1 1 nil nil nil nil 8 $\xE946 418 288 161 450 #openTaskManagerWindow 8 'Open &Task Manager' 1 1 nil nil nil nil 8 $\xE9F5 418 288 433 450 #settingsMenu 8 'Settings' 1 1 nil nil nil nil 8 $\xE713 582 1 #{UI.ToolbarSeparator} 288 1 nil nil 13 5 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[6 0 0 0 7 0 0 0 76 1 0 0 40 0 0 0] 193 50 2 8 1140857676 131137 8 '' 288 3 8 #() 518 #{Graphics.Point} 193 193 nil 31 8 'browserTools' nil nil nil nil 8 #() nil 518 #{Graphics.Rectangle} 1378 13 15 1378 9 1 9 2369 #mediumSmallIcons nil nil 130 1 1 nil nil nil 288 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 1520 nil 224 nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1520 130 9 1 nil nil 18 #{UI.PushButton} 50 20 nil 1520 50 2 8 1140924416 1 1680 nil 224 1378 101 51 5 nil nil nil 1680 nil nil 450 #navigate 8 '&Go' 1 1 nil nil true nil nil nil 1138 50 2 1186 #createWindow: 50 1 1234 1266 8 #[30 3 0 0 1 0 0 0 80 3 0 0 26 0 0 0] 193 1712 8 '&Go' 1680 1186 #isEnabled: 8 #(false) 1680 3 8 #() 1378 193 193 nil 29 nil 18 #{UI.TextEdit} 50 20 nil 1520 50 2 8 1149304960 1 1984 nil 112 nil 5 2886 4 #{UI.Menu} nil true 50 2 1094 2 #{UI.CommandMenuItem} 1 450 #navigate 8 '&Go' 1 1 nil nil nil 2098 2097153 450 #accept 8 '&Accept' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1984 384 nil 518 #{UI.NullConverter} nil nil 65 #focusLost nil nil nil 1138 50 3 1186 #createWindow: 50 1 1234 1266 8 #[0 0 0 0 1 0 0 0 26 3 0 0 26 0 0 0] 193 2016 nil 1984 1186 #contextMenu: 50 1 2064 1984 1186 #setMarginWidths: 50 1 8 #(4 4) 1984 3 8 #() 1378 193 193 nil 45 242 #{Core.IdentityDictionary} 50 4 1984 8 'address' 1680 8 'go' 1442 1378 1 3 1378 1 15 1138 50 1 1186 #createWindow: 50 1 1234 1266 8 #[76 1 0 0 7 0 0 0 156 4 0 0 40 0 0 0] 193 1552 8 '' 1520 3 50 2 1984 1680 1378 193 193 nil 27 1138 50 1 1186 #createWindow: 50 1 1234 1266 8 #[0 0 0 0 0 0 0 0 160 4 0 0 40 0 0 0] 193 192 8 '' 160 3 50 2 288 1520 1378 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 2912 nil 6 #{Graphics.Color} #default nil 5 nil 1862 1 #{Graphics.UxThemeFont} nil true nil 193 nil 1609 nil nil 2912 384 nil 242 #{Core.IdentityDictionary} 50 8 1862 1 #{UI.StatusBarItem} 8193 301 2912 nil 518 #{Core.Message} #displayString 8 #() 3106 #iconImageIndex 8 #() nil 8 'browserVersion' 3074 8193 251 2912 nil 3106 #displayString 8 #() 3106 #iconImageIndex 3232 nil 8 'profile' 3074 8193 -1 2912 nil 3106 #displayString 3168 3106 #iconImageIndex 368 nil 8 'status' 3074 8193 101 2912 nil 3106 #displayString 8 #() nil nil 8 'zoom' nil nil nil 50 4 3280 3200 3344 3088 1094 1 #{UI.StatusBarNullItem} 8705 1 2912 nil nil 1138 50 1 1186 #createWindow: 50 1 1234 1266 8 #[0 0 0 0 254 2 0 0 160 4 0 0 19 3 0 0] 193 2944 8 '' 2912 3 8 #() 1378 193 193 nil 29 nil nil 18 #{UI.WebView2View} 50 26 nil 32 50 2 8 1140850688 1 3616 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 112 nil 5 nil nil nil 3616 nil nil 2226 nil nil 262145 nil nil nil nil nil 2374 3 #{WebView2.WebView2EnvironmentOptions} nil 7 nil 8 '115.0.1901.177' nil 3 1 1 8 #() nil nil nil nil 1138 50 1 1186 #createWindow: 50 1 1234 1266 8 #[0 0 0 0 40 0 0 0 160 4 0 0 254 2 0 0] 193 3648 8 '' 3616 3 368 1378 193 193 nil 29 242 #{Core.IdentityDictionary} 50 6 3616 8 'browser' 2912 8 'progress' 160 8 'toolbar' nil nil nil nil nil 1 nil nil nil nil nil nil 193 1138 50 1 1186 #createWindow: 50 1 1234 1442 1378 6143 21 1378 8543 1673 193 80 8 'WebView2 Browser' 32 1 50 3 2912 160 3616 1378 193 193 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

updateColorScheme: anInteger
	| actual |
	PreferredColorScheme := anInteger.
	actual := anInteger = COREWEBVIEW2_PREFERRED_COLOR_SCHEME_AUTO
				ifTrue: 
					["[Microsoft recommand a cheesy check on the value of the system foreground colour](https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/apply-windows-themes) to detect if in dark mode!! Just too horrible, so use the undocumented theme API instead."
					UxTheme refreshImmersiveColorPolicyState.
					actual := UxTheme shouldAppsUseDarkMode
								ifTrue: [COREWEBVIEW2_PREFERRED_COLOR_SCHEME_DARK]
								ifFalse: [COREWEBVIEW2_PREFERRED_COLOR_SCHEME_LIGHT]]
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

