"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView subclass: #'UI.WebView2View'
	instanceVariableNames: 'settingsFlags unavailableLink webviewEnvironment webviewController webview eventHandlers'
	classVariableNames: ''
	imports: #(#{WebView2})
	classInstanceVariableNames: ''
	classConstants: {
		'CanNavigateToStrings' -> 16r2000.
		'DisableBrowserAcceleratorKeysMask' -> 16r2.
		'DisableBuiltInErrorPageMask' -> 16r20.
		'DisableDefaultContextMenuMask' -> 16r1.
		'DisableDefaultScriptDialogsMask' -> 16r4.
		'DisableDevToolsMask' -> 16r8.
		'DisableGeneralAutofillMask' -> 16r400.
		'DisableHostObjectsMask' -> 16r10.
		'DisablePasswordAutosaveMask' -> 16r800.
		'DisablePinchZoomMask' -> 16r1000.
		'DisableScriptMask' -> 16r40.
		'DisableStatusBarMask' -> 16r80.
		'DisableWebmessageMask' -> 16r100.
		'DisableZoomControlMask' -> 16r200
	}!
UI.WebView2View guid: (Core.GUID fromString: '{3a9f720c-51f6-49f2-8267-f2b3b878129c}')!
UI.WebView2View comment: '`WebView2View` is a `<valueView>` that wraps the Microsoft Edge WebView2 embeddable browser to display content downloaded from a URL, or provided as a string.'!
!UI.WebView2View categoriesForClass!MVP-Resources-Misc! !
!UI.WebView2View methodsFor!

allowContextMenu
	"Answer whether the Edge default context menu should be shown."

	^settingsFlags noMask: DisableDefaultContextMenuMask!

allowContextMenu: aBoolean
	"Set whether Edge should display it's default context menu.
	Note that this (like any other settings changes) will only take effect after a navigation."

	settingsFlags := settingsFlags mask: DisableDefaultContextMenuMask set: aBoolean not.
	self webviewSettings areDefaultContextMenusEnabled: aBoolean!

areBrowserAcceleratorKeysEnabled
	"Answer whether the Edge default accelerator keys should be enabled."

	^settingsFlags noMask: DisableBrowserAcceleratorKeysMask!

areBrowserAcceleratorKeysEnabled: aBoolean
	"Set whether the Edge default accelerator keys should be enabled."

	settingsFlags := settingsFlags mask: DisableBrowserAcceleratorKeysMask set: aBoolean not.
	self webviewSettings areBrowserAcceleratorKeysEnabled: aBoolean!

areDefaultScriptDialogsEnabled
	^settingsFlags noMask: DisableDefaultScriptDialogsMask!

areDefaultScriptDialogsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDefaultScriptDialogsMask set: aBoolean not.
	self webviewSettings areDefaultScriptDialogsEnabled: aBoolean!

areDevToolsEnabled
	^settingsFlags noMask: DisableDevToolsMask!

areDevToolsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDevToolsMask set: aBoolean not.
	self webviewSettings areDevToolsEnabled: aBoolean!

areHostObjectsAllowed
	^settingsFlags noMask: DisableHostObjectsMask!

areHostObjectsAllowed: aBoolean
	settingsFlags := settingsFlags mask: DisableHostObjectsMask set: aBoolean not.
	self webviewSettings areHostObjectsAllowed: aBoolean!

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

createWebView
	webviewEnvironment createCoreWebView2Controller: handle
		thenDo: [:hr :controller | hr < 0 ifFalse: [self onControllerCreated: controller]]	"We could create a composition controller here, but there is no point as we don't have any integration with Direct Composition"!

createWebViewEnvironment
	| completed |
	completed := (Smalltalk.WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 ifFalse: [self onEnvironmentCreated: env]])
					queryInterface: Smalltalk.ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.
	[Smalltalk.WebView2Loader default createCoreWebView2Environment: completed] on: Win32Error
		do: [:ex | self createUnavailableLink].
	completed free.
	self topShell
		when: #positionChanged:
		send: #onShellPositionChanged:
		to: self!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver."

	"Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	^UserLibrary default
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

destroyDeadWebView
	"Private - Tear down the remnants of a dead web view after browser process exit. This involves destroying the event sink objects, without unregistering them as that will fail, and freeing up the existing controller and view. The environment is retained in case a new view is to be created."

	eventHandlers := eventHandlers
				select: [:each | each source == webviewEnvironment or: 
							[each destroy.
							false]].
	self releaseWebView!

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
				unavailableLink.
				eventHandlers}.
	webviewEnvironment := webviewController := webview := unavailableLink := eventHandlers := nil.
	^[super filerProxy] ensure: 
			[webviewEnvironment := saved at: 1.
			webviewController := saved at: 2.
			webview := saved at: 3.
			unavailableLink := saved at: 4.
			eventHandlers := saved at: 5]!

goBack
	webview goBack!

goForward
	webview goForward!

initialize
	super initialize.
	settingsFlags := 0.
	webview := self webviewSettings: DeafObject.Current!

initializeControl
	"Settings must be established before navigating, or they will not take effect"

	self observeWindowEvents.
	self updateSettings.
	self presenter trigger: #webviewAvailable.

	"Refresh will cause a navigation"
	self refreshContents!

isBuiltInErrorPageEnabled
	^settingsFlags noMask: DisableBuiltInErrorPageMask!

isBuiltInErrorPageEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableBuiltInErrorPageMask set: aBoolean not.
	self webviewSettings isBuiltInErrorPageEnabled: aBoolean!

isGeneralAutofillEnabled
	^settingsFlags noMask: DisableGeneralAutofillMask!

isGeneralAutofillEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableGeneralAutofillMask set: aBoolean not.
	self webviewSettings isGeneralAutofillEnabled: aBoolean!

isPasswordAutosaveEnabled
	^settingsFlags noMask: DisablePasswordAutosaveMask!

isPasswordAutosaveEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePasswordAutosaveMask set: aBoolean not.
	self webviewSettings isPasswordAutosaveEnabled: aBoolean!

isPinchZoomEnabled
	^settingsFlags noMask: DisablePinchZoomMask!

isPinchZoomEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePinchZoomMask set: aBoolean not.
	self webviewSettings isPinchZoomEnabled: aBoolean!

isScriptEnabled
	^settingsFlags noMask: DisableScriptMask!

isScriptEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableScriptMask set: aBoolean not.
	self webviewSettings isScriptEnabled: aBoolean!

isStatusBarEnabled
	^settingsFlags noMask: DisableStatusBarMask!

isStatusBarEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableStatusBarMask set: aBoolean not.
	self webviewSettings isStatusBarEnabled: aBoolean!

isWebMessageEnabled
	^settingsFlags noMask: DisableWebmessageMask!

isWebMessageEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableWebmessageMask set: aBoolean not.
	self webviewSettings isWebMessageEnabled: aBoolean!

isZoomControlEnabled
	^settingsFlags noMask: DisableZoomControlMask!

isZoomControlEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableZoomControlMask set: aBoolean not.
	self webviewSettings isZoomControlEnabled: aBoolean!

notifyMove
	webviewController ifNil: [^self].
	webviewController NotifyParentWindowPositionChanged!

observeControllerEvents
	##({Smalltalk.ICoreWebView2AcceleratorKeyPressedEventHandler.
		Smalltalk.ICoreWebView2FocusLostEventHandler.
		Smalltalk.ICoreWebView2FocusGainedEventHandler.
		Smalltalk.ICoreWebView2RasterizationScaleChangedEventHandler.
		Smalltalk.ICoreWebView2ZoomFactorChangedEventHandler.
		Smalltalk.ICoreWebView2MoveFocusRequestedEventHandler})
			do: [:each | self observeEvent: each from: webviewController].
	(webviewController queryInterface: Smalltalk.ICoreWebView2CompositionController ifNone: [])
		ifNotNil: 
			[:webviewComposition |
			self registerEventSink: (Smalltalk.WebView2EventSink
						source: webviewComposition
						interfaceClass: Smalltalk.ICoreWebView2CursorChangedEventHandler
						handler: [:source :args | self presenter trigger: Smalltalk.ICoreWebView2CursorChangedEventHandler eventName with: args])]!

observeEnvironmentEvents
	##({Smalltalk.ICoreWebView2NewBrowserVersionAvailableEventHandler.
		Smalltalk.ICoreWebView2BrowserProcessExitedEventHandler.
		Smalltalk.ICoreWebView2ProcessInfosChangedEventHandler})
			do: [:each | self observeEvent: each from: webviewEnvironment]!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	^self registerEventSink: (Smalltalk.WebView2EventSink
				source: anICoreWebView2EventSource
				interfaceClass: anICoreWebView2EventHandlerClass
				handler: [:source :args | self presenter trigger: anICoreWebView2EventHandlerClass eventName with: args])!

observeWindowEvents
	self registerEventSink: (Smalltalk.WebView2EventSink
				source: webview
				interfaceClass: Smalltalk.ICoreWebView2ProcessFailedEventHandler
				handler: [:source :args | self onProcessFailed: args]).
	self registerEventSink: (Smalltalk.WebView2EventSink
				source: webview
				interfaceClass: Smalltalk.ICoreWebView2SourceChangedEventHandler
				handler: [:source :args | self onSourceChanged: args]).
	self registerEventSink: (Smalltalk.WebView2EventSink
				source: webview
				interfaceClass: Smalltalk.ICoreWebView2HistoryChangedEventHandler
				handler: [:source :args | self onHistoryChanged]).
	##({Smalltalk.ICoreWebView2ClientCertificateRequestedEventHandler.
		Smalltalk.ICoreWebView2ContainsFullScreenElementChangedEventHandler.
		Smalltalk.ICoreWebView2ContentLoadingEventHandler.
		Smalltalk.ICoreWebView2DocumentTitleChangedEventHandler.
		Smalltalk.ICoreWebView2DOMContentLoadedEventHandler.
		Smalltalk.ICoreWebView2DownloadStartingEventHandler.
		Smalltalk.ICoreWebView2FrameCreatedEventHandler.
		Smalltalk.ICoreWebView2FrameNavigationCompletedEventHandler.
		Smalltalk.ICoreWebView2FrameNavigationStartingEventHandler.
		Smalltalk.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler.
		Smalltalk.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler.
		Smalltalk.ICoreWebView2IsMutedChangedEventHandler.
		Smalltalk.ICoreWebView2NavigationCompletedEventHandler.
		Smalltalk.ICoreWebView2NavigationStartingEventHandler.
		Smalltalk.ICoreWebView2NewWindowRequestedEventHandler.
		Smalltalk.ICoreWebView2PermissionRequestedEventHandler.
		Smalltalk.ICoreWebView2ScriptDialogOpeningEventHandler.
		Smalltalk.ICoreWebView2WebMessageReceivedEventHandler.
		Smalltalk.ICoreWebView2WebResourceRequestedEventHandler.
		Smalltalk.ICoreWebView2WebResourceResponseReceivedEventHandler.
		Smalltalk.ICoreWebView2WindowCloseRequestedEventHandler}) do: [:each | self observeEvent: each from: webview]!

onControllerCreated: anICoreWebView2Controller
	webviewController := self queryControllerInterface: anICoreWebView2Controller.
	self observeControllerEvents.
	self resizeContentToFit.
	webview := self queryWindowInterface.
	self initializeControl!

onDestroyed
	self unregisterEvents.
	self content close.
	self releaseWebView.
	webviewEnvironment
		ifNotNil: 
			[webviewEnvironment free.
			webviewEnvironment := nil].
	^super onDestroyed!

onEnvironmentCreated: anICoreWebView2Environment
	webviewEnvironment := self queryEnvironmentInterface: anICoreWebView2Environment.
	self observeEnvironmentEvents.
	self createWebView!

onHistoryChanged
	self invalidateUserInterface.
	self presenter trigger: #historyChanged!

onPositionChanged: aPositionEvent
	aPositionEvent isResize ifTrue: [self resizeContentToFit].
	aPositionEvent isMove ifTrue: [self notifyMove].
	^super onPositionChanged: aPositionEvent!

onProcessFailed: anICoreWebView2ProcessFailedEventArgs
	"Private - There has been some kind of browser process crash, with varying degress of severity. In most cases Edge will recover or indicate failure in place (for crashed frames). If, however, the browser process has completely failed and exited, we need to clean up before passing on the event. In the case of browser process exit, the existing browser view is unrecoverable, and must be completely recreated."

	| failedArgs isDead |
	failedArgs := anICoreWebView2ProcessFailedEventArgs
				queryInterface: Smalltalk.ICoreWebView2ProcessFailedEventArgs2
				ifNone: [anICoreWebView2ProcessFailedEventArgs].
	failedArgs handled: false.
	isDead := failedArgs isBrowserProcessExit.
	isDead ifTrue: [self destroyDeadWebView].
	"Give observers a chance to handle the failure and recover appropriately. If an observer does attempt recovery, it should set the If the `handled` flag in the event args to suppress default recover. If the flag is not set, then the default recovery is to proceed and create a new browser view and navigate to the crash page (to avoid going into a death spiral by reopening the page that caused the crash)."
	self presenter trigger: #processFailed: with: failedArgs.
	(isDead and: [failedArgs handled not])
		ifTrue: 
			[self model value: 'edge://crashes'.
			self createWebView]!

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
	webview := DeafObject.Current.
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
	^anIUnknown queryInterface: Smalltalk.ICoreWebView2Controller3
		ifNone: 
			[anIUnknown queryInterface: Smalltalk.ICoreWebView2Controller2
				ifNone: [anIUnknown queryInterface: Smalltalk.ICoreWebView2Controller]]!

queryEnvironmentInterface: anICoreWebView2Environment
	"Private - There are already 8 versions of the ICoreWebView2Environment; answer the latest available. A little more forethought in the design so as to not have to define 8 versions of a public interface in a year or two might be nice!!"

	##({Smalltalk.ICoreWebView2Environment8.
		Smalltalk.ICoreWebView2Environment7.
		Smalltalk.ICoreWebView2Environment6.
		Smalltalk.ICoreWebView2Environment5.
		Smalltalk.ICoreWebView2Environment4.
		Smalltalk.ICoreWebView2Environment3.
		Smalltalk.ICoreWebView2Environment2})
			do: [:each | (anICoreWebView2Environment queryInterface: each ifNone: []) ifNotNil: [:interface | ^interface]].
	^anICoreWebView2Environment!

querySettingsInterface
	| settings |
	settings := webview settings.
	##({Smalltalk.ICoreWebView2Settings6.
		Smalltalk.ICoreWebView2Settings5.
		Smalltalk.ICoreWebView2Settings4.
		Smalltalk.ICoreWebView2Settings3.
		Smalltalk.ICoreWebView2Settings2})
			do: [:each | (settings queryInterface: each ifNone: []) ifNotNil: [:itf | ^itf]].
	^settings!

queryWindowInterface
	| webview2 |
	webview2 := webviewController coreWebView2.
	##({Smalltalk.ICoreWebView2_9.
		Smalltalk.ICoreWebView2_8.
		Smalltalk.ICoreWebView2_7.
		Smalltalk.ICoreWebView2_6.
		Smalltalk.ICoreWebView2_5.
		Smalltalk.ICoreWebView2_4.
		Smalltalk.ICoreWebView2_3.
		Smalltalk.ICoreWebView2_2})
			do: [:each | (webview2 queryInterface: each ifNone: []) ifNotNil: [:interface | ^interface]].
	^webview2!

registerEventSink: aWebView2EventSink
	aWebView2EventSink register.
	^eventHandlers add: aWebView2EventSink!

releaseWebView
	webview
		ifNotNil: 
			[webview free.
			webview := nil.
			self presenter trigger: #webviewClosed].
	webviewController
		ifNotNil: 
			[webviewController free.
			webviewController := nil]!

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
	eventHandlers do: [:each | each free].
	eventHandlers := nil!

updateSettings
	| settings |
	settings := self webviewSettings.
	self allowContextMenu ifFalse: [settings areDefaultContextMenusEnabled: false].
	self areBrowserAcceleratorKeysEnabled ifFalse: [settings areBrowserAcceleratorKeysEnabled: false].
	self areDefaultScriptDialogsEnabled ifFalse: [settings areDefaultScriptDialogsEnabled: false].
	self areDevToolsEnabled ifFalse: [settings areDevToolsEnabled: false].
	self areHostObjectsAllowed ifFalse: [settings areHostObjectsAllowed: false].
	self isBuiltInErrorPageEnabled ifFalse: [settings isBuiltInErrorPageEnabled: false].
	self isScriptEnabled ifFalse: [settings isScriptEnabled: false].
	self isStatusBarEnabled ifFalse: [settings isStatusBarEnabled: false].
	self isWebMessageEnabled ifFalse: [settings isWebMessageEnabled: false].
	self isZoomControlEnabled ifFalse: [settings isZoomControlEnabled: false].
	self isGeneralAutofillEnabled ifFalse: [settings isGeneralAutofillEnabled: false].
	self isPasswordAutosaveEnabled ifFalse: [settings isPasswordAutosaveEnabled: false].
	self isPinchZoomEnabled ifFalse: [settings isPinchZoomEnabled: false]!

webview
	^webview!

webviewController
	^webviewController!

webviewEnvironment
	^webviewEnvironment!

webviewSettings
	^self querySettingsInterface! !
!UI.WebView2View categoriesForMethods!
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
createUnavailableLink!private!realizing/unrealizing! !
createWebView!private!realizing/unrealizing! !
createWebViewEnvironment!private!realizing/unrealizing! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
destroyDeadWebView!private!realizing/unrealizing! !
displayValue!private!updating! !
displayValue:!private!updating! !
documentTitle!accessing!public! !
filerProxy!binary filing!private! !
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
notifyMove!event handling!private! !
observeControllerEvents!private!realizing/unrealizing! !
observeEnvironmentEvents!private!realizing/unrealizing! !
observeEvent:from:!helpers!private! !
observeWindowEvents!private!realizing/unrealizing! !
onControllerCreated:!event handling!private! !
onDestroyed!event handling!private! !
onEnvironmentCreated:!event handling!private! !
onHistoryChanged!event handling!private! !
onPositionChanged:!event handling!public! !
onProcessFailed:!event handling!private! !
onShellPositionChanged:!event handling!public! !
onSourceChanged:!event handling!private! !
onUnavailableLinkClicked:!event handling!private! !
onViewCreated!event handling!public! !
queryCommand:!commands!public! !
queryControllerInterface:!helpers!private! !
queryEnvironmentInterface:!helpers!private! !
querySettingsInterface!helpers!private! !
queryWindowInterface!helpers!private! !
registerEventSink:!helpers!private! !
releaseWebView!operations!private!realizing/unrealizing! !
resizeContentToFit!helpers!private! !
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

!UI.WebView2View class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk.ICoreWebView2 icon!

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
!UI.WebView2View class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
webview2Events!events!public! !
winClassName!constants!private! !
!

