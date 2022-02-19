"Filed out from Dolphin Smallalk"!

ValueConvertingControlView subclass: #WebView2View
	instanceVariableNames: 'settingsFlags unavailableLink webviewEnvironment webviewController webview webviewSettings eventHandlers'
	classVariableNames: 'CanNavigateToStrings DisableBrowserAcceleratorKeysMask DisableBuiltInErrorPageMask DisableDefaultContextMenuMask DisableDefaultScriptDialogsMask DisableDevToolsMask DisableGeneralAutofillMask DisableHostObjectsMask DisablePasswordAutosaveMask DisablePinchZoomMask DisableScriptMask DisableStatusBarMask DisableWebmessageMask DisableZoomControlMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2View guid: (GUID fromString: '{3a9f720c-51f6-49f2-8267-f2b3b878129c}')!
WebView2View addClassConstant: 'CanNavigateToStrings' value: 16r2000!
WebView2View addClassConstant: 'DisableBrowserAcceleratorKeysMask' value: 16r2!
WebView2View addClassConstant: 'DisableBuiltInErrorPageMask' value: 16r20!
WebView2View addClassConstant: 'DisableDefaultContextMenuMask' value: 16r1!
WebView2View addClassConstant: 'DisableDefaultScriptDialogsMask' value: 16r4!
WebView2View addClassConstant: 'DisableDevToolsMask' value: 16r8!
WebView2View addClassConstant: 'DisableGeneralAutofillMask' value: 16r400!
WebView2View addClassConstant: 'DisableHostObjectsMask' value: 16r10!
WebView2View addClassConstant: 'DisablePasswordAutosaveMask' value: 16r800!
WebView2View addClassConstant: 'DisablePinchZoomMask' value: 16r1000!
WebView2View addClassConstant: 'DisableScriptMask' value: 16r40!
WebView2View addClassConstant: 'DisableStatusBarMask' value: 16r80!
WebView2View addClassConstant: 'DisableWebmessageMask' value: 16r100!
WebView2View addClassConstant: 'DisableZoomControlMask' value: 16r200!
WebView2View comment: ''!
!WebView2View categoriesForClass!MVP-Resources-Misc! !
!WebView2View methodsFor!

allowContextMenu
	"Answer whether the Edge default context menu should be shown."

	^settingsFlags noMask: DisableDefaultContextMenuMask!

allowContextMenu: aBoolean
	"Set whether Edge should display it's default context menu.
	Note that this (like any other settings changes) will only take effect after a navigation."

	settingsFlags := settingsFlags mask: DisableDefaultContextMenuMask set: aBoolean not.
	webviewSettings areDefaultContextMenusEnabled: aBoolean!

areBrowserAcceleratorKeysEnabled
	"Answer whether the Edge default accelerator keys should be enabled."

	^settingsFlags noMask: DisableBrowserAcceleratorKeysMask!

areBrowserAcceleratorKeysEnabled: aBoolean
	"Set whether the Edge default accelerator keys should be enabled."

	settingsFlags := settingsFlags mask: DisableBrowserAcceleratorKeysMask set: aBoolean not.
	webviewSettings areBrowserAcceleratorKeysEnabled: aBoolean!

areDefaultScriptDialogsEnabled
	^settingsFlags noMask: DisableDefaultScriptDialogsMask!

areDefaultScriptDialogsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDefaultScriptDialogsMask set: aBoolean not.
	webviewSettings areDefaultScriptDialogsEnabled: aBoolean!

areDevToolsEnabled
	^settingsFlags noMask: DisableDevToolsMask!

areDevToolsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDevToolsMask set: aBoolean not.
	webviewSettings areDevToolsEnabled: aBoolean!

areHostObjectsAllowed
	^settingsFlags noMask: DisableHostObjectsMask!

areHostObjectsAllowed: aBoolean
	settingsFlags := settingsFlags mask: DisableHostObjectsMask set: aBoolean not.
	webviewSettings areHostObjectsAllowed: aBoolean!

browserVersion
	^self webviewEnvironment browserVersionString!

canGoBack
	^webview notNull and: [webview canGoBack]!

canGoForward
	^webview notNull and: [webview canGoForward]!

canNavigateToStrings
	"Answer whether the receiver will display any model value that is not a URL as text. This flag should be set when the model value is an HTML string."

	^settingsFlags allMask: CanNavigateToStrings!

canNavigateToStrings: aBoolean
	"Set whether the receiver will display any model value that is not a URL as text. When not set (the default) the model value is always passed to the WebView2 control for navigation to a URI."

	settingsFlags := settingsFlags mask: CanNavigateToStrings set: aBoolean!

content
	^(webviewController ?? unavailableLink) ifNil: [DeafObject current]!

createUnavailableLink
	"Private - Create a helpful link in place of the webview2 that could not be created on the assumption that the runtime is not installed or is in need of repair."

	unavailableLink := SysLinkView new.
	unavailableLink
		parentView: self;
		show;
		displayValue: 'This content requires the <a href="https://developer.microsoft.com/microsoft-edge/webview2/">Microsoft Edge WebView2 runtime</a>'.
	self resizeContentToFit.
	unavailableLink
		when: #linkClicked:
		send: #onUnavailableLinkClicked:
		to: self!

createWebViewEnvironment
	| completed |
	completed := (WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 ifFalse: [self onEnvironmentCreated: env]])
					queryInterface: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.
	[WebView2Loader default createCoreWebView2Environment: completed] on: Win32Error
		do: [:ex | self createUnavailableLink].
	completed free!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver."

	"Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	^UserLibrary default
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

displayValue
	"Private - Answer the displayed contents of the receiver.
	Must be overridden by subclasses"

	webview isNull ifTrue: [^nil].
	^webview source!

displayValue: anObject
	"Private - Set the displayed contents of the receiver."

	(webview isNull or: [webview source = anObject]) ifTrue: [^self].
	(self canNavigateToStrings not or: [ShlwapiLibrary default pathIsURL: anObject])
		ifTrue: [webview navigate: anObject ?? 'about:blank']
		ifFalse: [webview navigateToString: anObject ?? '']!

documentTitle
	^webview documentTitle!

filerProxy
	| saved |
	saved := {webviewEnvironment.
				webviewController.
				webview.
				webviewSettings.
				unavailableLink.
				eventHandlers}.
	webviewEnvironment := webviewController := webview := unavailableLink := eventHandlers := nil.
	^[super filerProxy] ensure: 
			[webviewEnvironment := saved at: 1.
			webviewController := saved at: 2.
			webview := saved at: 3.
			webviewSettings := saved at: 4.
			unavailableLink := saved at: 5.
			eventHandlers := saved at: 6]!

finalRelease
	"The last reference to the receiver (as a COM object) has been released."
!

goBack
	webview goBack!

goForward
	webview goForward!

initialize
	super initialize.
	settingsFlags := 0.
	webview := webviewSettings := DeafObject.Current!

initializeControl
	"Settings must be established before navigating, or they will not take effect"

	self updateSettings.
	self registerEvents.

	"We need to know if the shell is moved so that we can notify the WebView2 as it may need to move dialogs"
	self topShell
		when: #positionChanged:
		send: #onShellPositionChanged:
		to: self.

	self presenter trigger: #webviewAvailable.

	"Refresh will cause a navigation"
	self refreshContents!

isBuiltInErrorPageEnabled
	^settingsFlags noMask: DisableBuiltInErrorPageMask!

isBuiltInErrorPageEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableBuiltInErrorPageMask set: aBoolean not.
	webviewSettings isBuiltInErrorPageEnabled: aBoolean!

isGeneralAutofillEnabled
	^settingsFlags noMask: DisableGeneralAutofillMask!

isGeneralAutofillEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableGeneralAutofillMask set: aBoolean not.
	webviewSettings isGeneralAutofillEnabled: aBoolean!

isPasswordAutosaveEnabled
	^settingsFlags noMask: DisablePasswordAutosaveMask!

isPasswordAutosaveEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePasswordAutosaveMask set: aBoolean not.
	webviewSettings isPasswordAutosaveEnabled: aBoolean!

isPinchZoomEnabled
	^settingsFlags noMask: DisablePinchZoomMask!

isPinchZoomEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePinchZoomMask set: aBoolean not.
	webviewSettings isPinchZoomEnabled: aBoolean!

isScriptEnabled
	^settingsFlags noMask: DisableScriptMask!

isScriptEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableScriptMask set: aBoolean not.
	webviewSettings isScriptEnabled: aBoolean!

isStatusBarEnabled
	^settingsFlags noMask: DisableStatusBarMask!

isStatusBarEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableStatusBarMask set: aBoolean not.
	webviewSettings isStatusBarEnabled: aBoolean!

isWebMessageEnabled
	^settingsFlags noMask: DisableWebmessageMask!

isWebMessageEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableWebmessageMask set: aBoolean not.
	webviewSettings isWebMessageEnabled: aBoolean!

isZoomControlEnabled
	^settingsFlags noMask: DisableZoomControlMask!

isZoomControlEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableZoomControlMask set: aBoolean not.
	webviewSettings isZoomControlEnabled: aBoolean!

notifyMove
	webviewController ifNil: [^self].
	webviewController NotifyParentWindowPositionChanged!

observeControllerEvents
	{ICoreWebView2AcceleratorKeyPressedEventHandler.
		ICoreWebView2FocusLostEventHandler.
		ICoreWebView2FocusGainedEventHandler.
		ICoreWebView2RasterizationScaleChangedEventHandler.
		ICoreWebView2ZoomFactorChangedEventHandler.
		ICoreWebView2MoveFocusRequestedEventHandler}
			do: [:each | self observeEvent: each from: webviewController].
	(webviewController queryInterface: ICoreWebView2CompositionController ifNone: [])
		ifNotNil: 
			[:webviewComposition |
			eventHandlers add: (WebView2EventSink
						source: webviewComposition
						interfaceClass: ICoreWebView2CursorChangedEventHandler
						handler: 
							[:source :args |
							self halt.
							self presenter trigger: ICoreWebView2CursorChangedEventHandler eventName with: args])]!

observeEnvironmentEvents
	{ICoreWebView2NewBrowserVersionAvailableEventHandler.
		ICoreWebView2BrowserProcessExitedEventHandler.
		ICoreWebView2ProcessInfosChangedEventHandler}
			do: [:each | self observeEvent: each from: webviewEnvironment]!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	^eventHandlers add: (WebView2EventSink
				source: anICoreWebView2EventSource
				interfaceClass: anICoreWebView2EventHandlerClass
				handler: [:source :args | self presenter trigger: anICoreWebView2EventHandlerClass eventName with: args])!

observeWindowEvents
	{ICoreWebView2ClientCertificateRequestedEventHandler.
		ICoreWebView2ContainsFullScreenElementChangedEventHandler.
		ICoreWebView2ContentLoadingEventHandler.
		ICoreWebView2DocumentTitleChangedEventHandler.
		ICoreWebView2DOMContentLoadedEventHandler.
		ICoreWebView2DownloadStartingEventHandler.
		ICoreWebView2FrameCreatedEventHandler.
		ICoreWebView2FrameNavigationCompletedEventHandler.
		ICoreWebView2FrameNavigationStartingEventHandler.
		ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler.
		ICoreWebView2IsDocumentPlayingAudioChangedEventHandler.
		ICoreWebView2IsMutedChangedEventHandler.
		ICoreWebView2NavigationCompletedEventHandler.
		ICoreWebView2NavigationStartingEventHandler.
		ICoreWebView2NewWindowRequestedEventHandler.
		ICoreWebView2PermissionRequestedEventHandler.
		ICoreWebView2ProcessFailedEventHandler.
		ICoreWebView2ScriptDialogOpeningEventHandler.
		ICoreWebView2WebMessageReceivedEventHandler.
		ICoreWebView2WebResourceRequestedEventHandler.
		ICoreWebView2WebResourceResponseReceivedEventHandler.
		ICoreWebView2WindowCloseRequestedEventHandler} do: [:each | self observeEvent: each from: webview].
	eventHandlers add: (WebView2EventSink
				source: webview
				interfaceClass: ICoreWebView2SourceChangedEventHandler
				handler: [:source :args | self onSourceChanged: args]).
	eventHandlers add: (WebView2EventSink
				source: webview
				interfaceClass: ICoreWebView2HistoryChangedEventHandler
				handler: [:source :args | self onHistoryChanged])!

onControllerCreated: anICoreWebView2Controller
	webviewController := self queryControllerInterface: anICoreWebView2Controller.
	self resizeContentToFit.
	webview := self queryWindowInterface.
	webviewSettings := self querySettingsInterface.
	self initializeControl!

onDestroyed
	self unregisterEvents.
	self content close.
	webviewController := webview := webviewSettings := nil.
	^super onDestroyed!

onEnvironmentCreated: anICoreWebView2Environment
	webviewEnvironment := self queryEnvironmentInterface: anICoreWebView2Environment.
	"We could create a composition controller here, but there is no point as we don't have any integration with Direct Composition"
	anICoreWebView2Environment createCoreWebView2Controller: handle
		thenDo: [:hr :controller | hr < 0 ifFalse: [self onControllerCreated: controller]]!

onHistoryChanged
	self invalidateUserInterface.
	self presenter trigger: #historyChanged!

onPositionChanged: aPositionEvent
	aPositionEvent isResize ifTrue: [self resizeContentToFit].
	aPositionEvent isMove ifTrue: [self notifyMove].
	^super onPositionChanged: aPositionEvent!

onShellPositionChanged: aPositionEvent
	aPositionEvent isMove ifTrue: [self notifyMove]!

onSourceChanged: anICoreWebView2SourceChangedEventArgs
	"Private - The 'Source Changed' event is an ideal point to synchronise the model with the current URI."

	self updateModel.
	self presenter trigger: #sourceChanged: with: anICoreWebView2SourceChangedEventArgs!

onUnavailableLinkClicked: aLITEM 
	ShellLibrary default shellOpen: aLITEM url!

onViewCreated
	"The receiver has just been fully created. This is a suitable place to perform
	initialization of the window from the receiver's instance variables."

	unavailableLink
		ifNotNil: 
			[unavailableLink destroy.
			unavailableLink := nil].
	webviewController := nil.
	webview := webviewSettings := DeafObject.Current.
	eventHandlers := OrderedCollection new.
	self createWebViewEnvironment!

queryCommand: query
	"Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.
	cmd == #goBack
		ifTrue: 
			[query isEnabled: self canGoBack.
			^true].
	cmd == #goForward
		ifTrue: 
			[query isEnabled: self canGoForward.
			^true].
	^super queryCommand: query!

queryControllerInterface: anIUnknown
	^anIUnknown queryInterface: ICoreWebView2Controller3
		ifNone: 
			[anIUnknown queryInterface: ICoreWebView2Controller2
				ifNone: [anIUnknown queryInterface: ICoreWebView2Controller]]!

queryEnvironmentInterface: anICoreWebView2Environment
	"Private - There are already 8 versions of the ICoreWebView2Environment; answer the latest available. A little more forethought in the design so as to not have to define 8 versions of a public interface in a year or two might be nice!!"

	##({ICoreWebView2Environment8.
		ICoreWebView2Environment7.
		ICoreWebView2Environment6.
		ICoreWebView2Environment5.
		ICoreWebView2Environment4.
		ICoreWebView2Environment3.
		ICoreWebView2Environment2})
			do: [:each | (anICoreWebView2Environment queryInterface: each ifNone: []) ifNotNil: [:interface | ^interface]].
	^anICoreWebView2Environment!

querySettingsInterface
	| settings |
	settings := webview settings.
	^settings queryInterface: ICoreWebView2Settings5
		ifNone: 
			[settings queryInterface: ICoreWebView2Settings4
				ifNone: 
					[settings queryInterface: ICoreWebView2Settings3
						ifNone: [settings queryInterface: ICoreWebView2Settings2 ifNone: [settings]]]]!

queryWindowInterface
	| webview2 |
	webview2 := webviewController coreWebView2.
	##({ICoreWebView2_9.
		ICoreWebView2_8.
		ICoreWebView2_7.
		ICoreWebView2_6.
		ICoreWebView2_5.
		ICoreWebView2_4.
		ICoreWebView2_3.
		ICoreWebView2_2})
			do: [:each | (webview2 queryInterface: each ifNone: []) ifNotNil: [:interface | ^interface]].
	^webview2!

registerEvents
	self observeEnvironmentEvents.
	self observeControllerEvents.
	self observeWindowEvents.
	eventHandlers do: [:each | each register]!

resizeContentToFit
	self content rectangle: self clientRectangle!

showWithStyle: anInteger
	| result |
	result := super showWithStyle: anInteger.
	webviewController ifNotNil: [webviewController isVisible: anInteger ~~ SW_HIDE].
	^result!

stop
	webview Stop!

subclassWindow: hWnd
	"Private - Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	self attachHandle: hWnd!

subViews
	^#()!

unregisterEvents
	eventHandlers ifNil: [^self].
	eventHandlers do: [:each | each unregister].
	eventHandlers := nil!

updateSettings
	self allowContextMenu ifFalse: [webviewSettings areDefaultContextMenusEnabled: false].
	self areBrowserAcceleratorKeysEnabled
		ifFalse: [webviewSettings areBrowserAcceleratorKeysEnabled: false].
	self areDefaultScriptDialogsEnabled
		ifFalse: [webviewSettings areDefaultScriptDialogsEnabled: false].
	self areDevToolsEnabled ifFalse: [webviewSettings areDevToolsEnabled: false].
	self areHostObjectsAllowed ifFalse: [webviewSettings areHostObjectsAllowed: false].
	self isBuiltInErrorPageEnabled ifFalse: [webviewSettings isBuiltInErrorPageEnabled: false].
	self isScriptEnabled ifFalse: [webviewSettings isScriptEnabled: false].
	self isStatusBarEnabled ifFalse: [webviewSettings isStatusBarEnabled: false].
	self isWebMessageEnabled ifFalse: [webviewSettings isWebMessageEnabled: false].
	self isZoomControlEnabled ifFalse: [webviewSettings isZoomControlEnabled: false].
	self isGeneralAutofillEnabled ifFalse: [webviewSettings isGeneralAutofillEnabled: false].
	self isPasswordAutosaveEnabled ifFalse: [webviewSettings isPasswordAutosaveEnabled: false].
	self isPinchZoomEnabled ifFalse: [webviewSettings isPinchZoomEnabled: false]!

webview
	^webview!

webviewController
	^webviewController!

webviewEnvironment
	^webviewEnvironment!

webviewSettings
	^webviewSettings! !
!WebView2View categoriesForMethods!
allowContextMenu!public!settings! !
allowContextMenu:!public!settings! !
areBrowserAcceleratorKeysEnabled!public!settings! !
areBrowserAcceleratorKeysEnabled:!public!settings! !
areDefaultScriptDialogsEnabled!public!settings! !
areDefaultScriptDialogsEnabled:!public!settings! !
areDevToolsEnabled!public!settings! !
areDevToolsEnabled:!public!settings! !
areHostObjectsAllowed!public!settings! !
areHostObjectsAllowed:!public!settings! !
browserVersion!accessing!public! !
canGoBack!commands!public! !
canGoForward!commands!public! !
canNavigateToStrings!public!settings! !
canNavigateToStrings:!public!settings! !
content!accessing!private! !
createUnavailableLink!helpers!private! !
createWebViewEnvironment!event handling!private! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
documentTitle!accessing!public! !
filerProxy!binary filing!private! !
finalRelease!public!realizing/unrealizing! !
goBack!commands!public! !
goForward!commands!public! !
initialize!initializing!private! !
initializeControl!private!realizing/unrealizing! !
isBuiltInErrorPageEnabled!public!settings! !
isBuiltInErrorPageEnabled:!public!settings! !
isGeneralAutofillEnabled!public!settings! !
isGeneralAutofillEnabled:!public!settings! !
isPasswordAutosaveEnabled!public!settings! !
isPasswordAutosaveEnabled:!public!settings! !
isPinchZoomEnabled!public!settings! !
isPinchZoomEnabled:!public!settings! !
isScriptEnabled!public!settings! !
isScriptEnabled:!public!settings! !
isStatusBarEnabled!public!settings! !
isStatusBarEnabled:!public!settings! !
isWebMessageEnabled!public!settings! !
isWebMessageEnabled:!public!settings! !
isZoomControlEnabled!public!settings! !
isZoomControlEnabled:!public!settings! !
notifyMove!private!realizing/unrealizing! !
observeControllerEvents!helpers!private! !
observeEnvironmentEvents!helpers!private! !
observeEvent:from:!helpers!private! !
observeWindowEvents!helpers!private! !
onControllerCreated:!event handling!private! !
onDestroyed!event handling!private! !
onEnvironmentCreated:!event handling!private! !
onHistoryChanged!event handling!private! !
onPositionChanged:!event handling!public! !
onShellPositionChanged:!event handling!public! !
onSourceChanged:!event handling!private! !
onUnavailableLinkClicked:!event handling!private! !
onViewCreated!event handling!public! !
queryCommand:!commands!public! !
queryControllerInterface:!helpers!private! !
queryEnvironmentInterface:!helpers!private! !
querySettingsInterface!helpers!private! !
queryWindowInterface!helpers!private! !
registerEvents!private!realizing/unrealizing! !
resizeContentToFit!private!realizing/unrealizing! !
showWithStyle:!operations!private! !
stop!commands!public! !
subclassWindow:!operations!private! !
subViews!hierarchy!public!sub views! !
unregisterEvents!private!realizing/unrealizing! !
updateSettings!private!realizing/unrealizing! !
webview!accessing!public! !
webviewController!accessing!public! !
webviewEnvironment!accessing!public! !
webviewSettings!accessing!public! !
!

!WebView2View class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^ICoreWebView2 icon!

initialize
	"self initialize"
	self
		addClassConstant: 'DisableDefaultContextMenuMask' value: 1;
		addClassConstant: 'DisableBrowserAcceleratorKeysMask' value: 2;
		addClassConstant: 'DisableDefaultScriptDialogsMask' value: 4;
		addClassConstant: 'DisableDevToolsMask' value: 8;
		addClassConstant: 'DisableHostObjectsMask' value: 16;
		addClassConstant: 'DisableBuiltInErrorPageMask' value: 32;
		addClassConstant: 'DisableScriptMask' value: 64;
		addClassConstant: 'DisableStatusBarMask' value: 128;
		addClassConstant: 'DisableWebmessageMask' value: 256;
		addClassConstant: 'DisableZoomControlMask' value: 512;
		addClassConstant: 'DisableGeneralAutofillMask' value: 1024;
		addClassConstant: 'DisablePasswordAutosaveMask' value: 2048;
		addClassConstant: 'DisablePinchZoomMask' value: 4096;
		addClassConstant: 'CanNavigateToStrings' value: 8192
!

webview2Events
	"This is the full set of events. Not all are actually published currently; for example the frame and download events are not."

	^#(#acceleratorKeyPressed: #browseProcessExited: #bytesReceivedChanged #clientCertificateRequested: #containsFullScreenElementChanged #contentLoading: #cursorChanged #devToolsProtocolEvent: #documentTitleChanged #domContentLoaded: #downloadStarting: #dowloadStateChanged #focusGained #focusLost #frameContentLoading: #frameCreated: #frameDestroyed #frameDomContentLoaded: #frameNameChanged #frameNavigationCompleted: #frameNavigationStarting: #frameWebMessageReceived: #historyChanged #isDefaultDownloadDialogOpenChanged #isDocumentPlayingAudioChanged #isMutedChanged #moveFocusRequested: #navigationCompleted: #navigationStarting: #newBrowserVersionAvailable #newWindowRequested: #permissionRequested: #processFailed: #processInfosChanged: #rasterizationScaleChanged #scriptDialogOpening: #sourceChanged: #webMessageReceived: #webResourceRequested: #webResourceResponseReceived: #webviewAvailable #windowCloseRequested #zoomFactorChanged)!

winClassName
	"Private - Answer the Windows class name, or atom, to be used when creating Windows attached
	to instances of the receiver."

	^self wndClassName! !
!WebView2View class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
webview2Events!events!public! !
winClassName!constants!private! !
!

