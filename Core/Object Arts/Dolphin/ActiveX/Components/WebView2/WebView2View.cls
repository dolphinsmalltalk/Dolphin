"Filed out from Dolphin Smalltalk"!

ValueConvertingControlView subclass: #WebView2View
	instanceVariableNames: 'settingsFlags unavailableLink webviewEnvironment webviewController webview eventHandlers'
	classVariableNames: 'CanNavigateToStrings DisableBrowserAcceleratorKeysMask DisableBuiltInErrorPageMask DisableDefaultContextMenuMask DisableDefaultScriptDialogsMask DisableDevToolsMask DisableExternalDropsMask DisableGeneralAutofillMask DisableHostObjectsMask DisablePasswordAutosaveMask DisablePinchZoomMask DisableScriptMask DisableSSOMask DisableStatusBarMask DisableSwipeNavigationMask DisableWebmessageMask DisableZoomControlMask EnableCustomErrorReportingMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WebView2View guid: (GUID fromString: '{3a9f720c-51f6-49f2-8267-f2b3b878129c}')!

WebView2View addClassConstant: 'CanNavigateToStrings' value: 16r2000!
WebView2View addClassConstant: 'DisableBrowserAcceleratorKeysMask' value: 16r2!
WebView2View addClassConstant: 'DisableBuiltInErrorPageMask' value: 16r20!
WebView2View addClassConstant: 'DisableDefaultContextMenuMask' value: 16r1!
WebView2View addClassConstant: 'DisableDefaultScriptDialogsMask' value: 16r4!
WebView2View addClassConstant: 'DisableDevToolsMask' value: 16r8!
WebView2View addClassConstant: 'DisableExternalDropsMask' value: 16r4000!
WebView2View addClassConstant: 'DisableGeneralAutofillMask' value: 16r400!
WebView2View addClassConstant: 'DisableHostObjectsMask' value: 16r10!
WebView2View addClassConstant: 'DisablePasswordAutosaveMask' value: 16r800!
WebView2View addClassConstant: 'DisablePinchZoomMask' value: 16r1000!
WebView2View addClassConstant: 'DisableScriptMask' value: 16r40!
WebView2View addClassConstant: 'DisableSSOMask' value: 16r10000!
WebView2View addClassConstant: 'DisableStatusBarMask' value: 16r80!
WebView2View addClassConstant: 'DisableSwipeNavigationMask' value: 16r8000!
WebView2View addClassConstant: 'DisableWebmessageMask' value: 16r100!
WebView2View addClassConstant: 'DisableZoomControlMask' value: 16r200!
WebView2View addClassConstant: 'EnableCustomErrorReportingMask' value: 16r20000!

WebView2View comment: '`WebView2View` is a `<valueView>` that wraps the Microsoft Edge WebView2 embeddable browser to display content downloaded from a URL, or provided as a string.'!

!WebView2View categoriesForClass!MVP-Resources-Misc! !

!WebView2View methodsFor!

allowContextMenu
	"Answer whether the Edge default context menu should be shown."

	^settingsFlags noMask: DisableDefaultContextMenuMask!

allowContextMenu: aBoolean
	"Set whether Edge should display it's default context menu.
	Note that this (like any other settings changes) will only take effect after a navigation."

	settingsFlags := settingsFlags mask: DisableDefaultContextMenuMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areDefaultContextMenusEnabled: aBoolean]!

allowExternalDrop
	"Answer whether externally sourced drag & drops should be received."

	^settingsFlags noMask: DisableExternalDropsMask!

allowExternalDrop: aBoolean
	"Set whether exterbally sourced drag & drops should be received."

	settingsFlags := settingsFlags mask: DisableExternalDropsMask set: aBoolean not.
	self webviewController ifNotNil: [:controller | controller allowExternalDrop: aBoolean]!

allowSSO
	^settingsFlags noMask: DisableSSOMask!

allowSSO: aBoolean
	"Set whether single sign-on should be enabled (the default)."

	self allowSSO = aBoolean ifTrue: [^self].
	self recreateAround: [settingsFlags := settingsFlags mask: DisableSSOMask set: aBoolean not]!

areBrowserAcceleratorKeysEnabled
	"Answer whether the Edge default accelerator keys should be enabled."

	^settingsFlags noMask: DisableBrowserAcceleratorKeysMask!

areBrowserAcceleratorKeysEnabled: aBoolean
	"Set whether the Edge default accelerator keys should be enabled."

	settingsFlags := settingsFlags mask: DisableBrowserAcceleratorKeysMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areBrowserAcceleratorKeysEnabled: aBoolean]!

areDefaultScriptDialogsEnabled
	^settingsFlags noMask: DisableDefaultScriptDialogsMask!

areDefaultScriptDialogsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDefaultScriptDialogsMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areDefaultScriptDialogsEnabled: aBoolean]!

areDevToolsEnabled
	^settingsFlags noMask: DisableDevToolsMask!

areDevToolsEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableDevToolsMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areDevToolsEnabled: aBoolean]!

areHostObjectsAllowed
	^settingsFlags noMask: DisableHostObjectsMask!

areHostObjectsAllowed: aBoolean
	settingsFlags := settingsFlags mask: DisableHostObjectsMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areHostObjectsAllowed: aBoolean]!

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
	| completed userDataFolder options |
	completed := (WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 ifFalse: [self onEnvironmentCreated: env]])
					queryInterface: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.
	userDataFolder := File composePath: (SessionManager current getenv: 'LocalAppData')
				subPath: (File splitFilenameFrom: (ExternalLibrary moduleFileName: nil)) , '.WebView2'.
	options := WebView2EnvironmentOptions new.
	options
		allowSSO: self allowSSO;
		isCustomCrashReportingEnabled: self isCustomCrashReportingEnabled.
	
	[WebView2Loader default
		createCoreWebView2EnvironmentWithOptions: nil
		userDataFolder: userDataFolder
		environmentOptions: (options queryInterface: ICoreWebView2EnvironmentOptions)
		environmentCreatedHandler: completed]
			on: Win32Error
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
	webviewController close.
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
	webview := DeafObject.Current!

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
	self webviewSettings ifNotNil: [:settings | settings isBuiltInErrorPageEnabled: aBoolean]!

isCustomCrashReportingEnabled
	^settingsFlags allMask: EnableCustomErrorReportingMask!

isCustomCrashReportingEnabled: aBoolean
	"Set whether custom error reporting should be enabled (suppressing the default behaviour of uploading crashes to Microsoft)."

	self isCustomCrashReportingEnabled = aBoolean ifTrue: [^self].
	self
		recreateAround: [settingsFlags := settingsFlags mask: EnableCustomErrorReportingMask set: aBoolean]!

isGeneralAutofillEnabled
	^settingsFlags noMask: DisableGeneralAutofillMask!

isGeneralAutofillEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableGeneralAutofillMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isGeneralAutofillEnabled: aBoolean]!

isPasswordAutosaveEnabled
	^settingsFlags noMask: DisablePasswordAutosaveMask!

isPasswordAutosaveEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePasswordAutosaveMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isPasswordAutosaveEnabled: aBoolean]!

isPinchZoomEnabled
	^settingsFlags noMask: DisablePinchZoomMask!

isPinchZoomEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisablePinchZoomMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isPinchZoomEnabled: aBoolean]!

isScriptEnabled
	^settingsFlags noMask: DisableScriptMask!

isScriptEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableScriptMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isScriptEnabled: aBoolean]!

isStatusBarEnabled
	^settingsFlags noMask: DisableStatusBarMask!

isStatusBarEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableStatusBarMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isStatusBarEnabled: aBoolean]!

isSwipeNavigationEnabled
	^settingsFlags noMask: DisableSwipeNavigationMask!

isSwipeNavigationEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableSwipeNavigationMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isSwipeNavigationEnabled: aBoolean]!

isWebMessageEnabled
	^settingsFlags noMask: DisableWebmessageMask!

isWebMessageEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableWebmessageMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isWebMessageEnabled: aBoolean]!

isZoomControlEnabled
	^settingsFlags noMask: DisableZoomControlMask!

isZoomControlEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableZoomControlMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isZoomControlEnabled: aBoolean]!

notifyMove
	webviewController ifNil: [^self].
	webviewController NotifyParentWindowPositionChanged!

observeControllerEvents
	##({ICoreWebView2AcceleratorKeyPressedEventHandler.
		ICoreWebView2FocusLostEventHandler.
		ICoreWebView2FocusGainedEventHandler.
		ICoreWebView2RasterizationScaleChangedEventHandler.
		ICoreWebView2ZoomFactorChangedEventHandler.
		ICoreWebView2MoveFocusRequestedEventHandler})
			do: [:each | self observeEvent: each from: webviewController].
	(webviewController queryInterface: ICoreWebView2CompositionController ifNone: [])
		ifNotNil: 
			[:webviewComposition |
			self registerEventSink: (WebView2EventSink
						source: webviewComposition
						interfaceClass: ICoreWebView2CursorChangedEventHandler
						handler: [:source :args | self presenter trigger: ICoreWebView2CursorChangedEventHandler eventName with: args])]!

observeEnvironmentEvents
	##({ICoreWebView2NewBrowserVersionAvailableEventHandler.
		ICoreWebView2BrowserProcessExitedEventHandler.
		ICoreWebView2ProcessInfosChangedEventHandler})
			do: [:each | self observeEvent: each from: webviewEnvironment]!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	| event argsClass handlerBlock |
	event := anICoreWebView2EventHandlerClass eventName.
	argsClass := anICoreWebView2EventHandlerClass argsClass.
	handlerBlock := argsClass == IUnknown
				ifTrue: [[:source :args | self presenter trigger: event]]
				ifFalse: 
					[argsClass superclass isNonInstantiable
						ifTrue: [[:source :args | self presenter trigger: event with: args]]
						ifFalse: 
							["Here we are assuming that there is only ever xxxEventArgs and xxxEventArgs2. This is true currently. If more depth is added, we could walk up the hierarchy querying"
							[:source :args | self presenter trigger: event with: (args queryInterface: argsClass ifNone: [args])]]].
	^self registerEventSink: (WebView2EventSink
				source: anICoreWebView2EventSource
				interfaceClass: anICoreWebView2EventHandlerClass
				handler: handlerBlock)!

observeWindowEvents
	"For some events we want to do more than just trigger a Smalltalk event, so these have custom handlers"

	self registerEventSink: (WebView2EventSink
				source: webview
				interfaceClass: ICoreWebView2ProcessFailedEventHandler
				handler: [:source :args | self onProcessFailed: args]).
	self registerEventSink: (WebView2EventSink
				source: webview
				interfaceClass: ICoreWebView2SourceChangedEventHandler
				handler: [:source :args | self onSourceChanged: args]).
	self registerEventSink: (WebView2EventSink
				source: webview
				interfaceClass: ICoreWebView2HistoryChangedEventHandler
				handler: [:source :args | self onHistoryChanged]).
	"For all other events we just trigger a Smalltalk event, so we can follow a generic pattern to set up the handler"
	##({ICoreWebView2BasicAuthenticationRequestedEventHandler.
		ICoreWebView2ClientCertificateRequestedEventHandler.
		ICoreWebView2ContainsFullScreenElementChangedEventHandler.
		ICoreWebView2ContentLoadingEventHandler.
		ICoreWebView2ContextMenuRequestedEventHandler.
		ICoreWebView2DocumentTitleChangedEventHandler.
		ICoreWebView2DOMContentLoadedEventHandler.
		ICoreWebView2DownloadStartingEventHandler.
		ICoreWebView2FaviconChangedEventHandler.
		ICoreWebView2FrameCreatedEventHandler.
		ICoreWebView2FrameNavigationCompletedEventHandler.
		ICoreWebView2FrameNavigationStartingEventHandler.
		ICoreWebView2FramePermissionRequestedEventHandler.
		ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler.
		ICoreWebView2IsDocumentPlayingAudioChangedEventHandler.
		ICoreWebView2IsMutedChangedEventHandler.
		ICoreWebView2NavigationCompletedEventHandler.
		ICoreWebView2NavigationStartingEventHandler.
		ICoreWebView2NewWindowRequestedEventHandler.
		ICoreWebView2PermissionRequestedEventHandler.
		ICoreWebView2ServerCertificateErrorDetectedEventHandler.
		ICoreWebView2ScriptDialogOpeningEventHandler.
		ICoreWebView2StatusBarTextChangedEventHandler.
		ICoreWebView2WebMessageReceivedEventHandler.
		ICoreWebView2WebResourceRequestedEventHandler.
		ICoreWebView2WebResourceResponseReceivedEventHandler.
		ICoreWebView2WindowCloseRequestedEventHandler}) do: [:each | self observeEvent: each from: webview]!

onControllerCreated: anICoreWebView2Controller
	webviewController := self queryControllerInterface: anICoreWebView2Controller.
	self observeControllerEvents.
	self resizeContentToFit.
	webview := webviewController coreWebView2.
	self initializeControl!

onDestroyed
	self unregisterEvents.
	self content close.
	self releaseWebView.
	"We don't free the webview environment, but rather let it be finalised. This allows an external observer to watch for the browser process exiting."
	webviewEnvironment := nil.
	^super onDestroyed!

onEnvironmentCreated: anICoreWebView2Environment
	webviewEnvironment := anICoreWebView2Environment downCast.
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

	| failedArgs isDead wasHandled |
	failedArgs := anICoreWebView2ProcessFailedEventArgs
				queryInterface: ICoreWebView2ProcessFailedEventArgs2
				ifNone: [anICoreWebView2ProcessFailedEventArgs].
	failedArgs handled: false.
	isDead := failedArgs isBrowserProcessExit.
	isDead ifTrue: [self destroyDeadWebView].
	"Give observers a chance to handle the failure and recover appropriately. If an observer does attempt recovery, it should set the If the `handled` flag in the event args to suppress default recover. If the flag is not set, then the default recovery is to proceed and create a new browser view and navigate to the crash page (to avoid going into a death spiral by reopening the page that caused the crash)."
	self presenter trigger: #processFailed: with: failedArgs.
	wasHandled := failedArgs handled.
	failedArgs free.
	(isDead and: [wasHandled not])
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

profile
	^webview profile!

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
	| interfaceClass |
	interfaceClass := ICoreWebView2Controller4.
	
	[(anIUnknown queryInterface: interfaceClass ifNone: []) ifNotNil: [:interface | ^interface].
	(interfaceClass := interfaceClass superclass) == ICoreWebView2Controller]
			whileFalse.
	^anIUnknown queryInterface: ICoreWebView2Controller!

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

settings
	"Do nothing here. Could show a settings dialog"!

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

unregisterEventSink: aWebView2EventSink
	aWebView2EventSink free.
	eventHandlers remove: aWebView2EventSink ifAbsent: []!

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
	^webview isNull ifFalse: [webview settings]!

zoomFactor
	^self webviewController zoomFactor!

zoomFactor: aNumber
	self webviewController zoomFactor = aNumber ifTrue: [^self].
	self webviewController zoomFactor: aNumber.
	self presenter trigger: #zoomFactorChanged! !

!WebView2View categoriesForMethods!
allowContextMenu!public!settings! !
allowContextMenu:!public!settings! !
allowExternalDrop!public!settings! !
allowExternalDrop:!public!settings! !
allowSSO!public!settings! !
allowSSO:!public!settings! !
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
isCustomCrashReportingEnabled!public!settings! !
isCustomCrashReportingEnabled:!public!settings! !
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
isSwipeNavigationEnabled!public!settings! !
isSwipeNavigationEnabled:!public!settings! !
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
profile!commands!public! !
queryCommand:!commands!public! !
queryControllerInterface:!helpers!private! !
registerEventSink:!helpers!public! !
releaseWebView!operations!private!realizing/unrealizing! !
resizeContentToFit!helpers!private! !
settings!public! !
showWithStyle:!operations!private! !
stop!commands!public! !
subclassWindow:!operations!private! !
subViews!hierarchy!public!sub views! !
unregisterEvents!private!realizing/unrealizing! !
unregisterEventSink:!helpers!public! !
updateSettings!private!realizing/unrealizing! !
webview!accessing!public! !
webviewController!accessing!public! !
webviewEnvironment!accessing!public! !
webviewSettings!accessing!public! !
zoomFactor!public! !
zoomFactor:!public! !
!

!WebView2View class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^ICoreWebView2 icon!

initialize
	"self initialize"
	self
		addClassConstant: 'DisableDefaultContextMenuMask' value: 16r1;
		addClassConstant: 'DisableBrowserAcceleratorKeysMask' value: 16r2;
		addClassConstant: 'DisableDefaultScriptDialogsMask' value: 16r4;
		addClassConstant: 'DisableDevToolsMask' value: 16r8;
		addClassConstant: 'DisableHostObjectsMask' value: 16r10;
		addClassConstant: 'DisableBuiltInErrorPageMask' value: 16r20;
		addClassConstant: 'DisableScriptMask' value: 16r40;
		addClassConstant: 'DisableStatusBarMask' value: 16r80;
		addClassConstant: 'DisableWebmessageMask' value: 16r100;
		addClassConstant: 'DisableZoomControlMask' value: 16r200;
		addClassConstant: 'DisableGeneralAutofillMask' value: 16r400;
		addClassConstant: 'DisablePasswordAutosaveMask' value: 16r800;
		addClassConstant: 'DisablePinchZoomMask' value: 16r1000;
		addClassConstant: 'CanNavigateToStrings' value: 16r2000;
		addClassConstant: 'DisableExternalDropsMask' value: 16r4000;
		addClassConstant: 'DisableSwipeNavigationMask' value: 16r8000
!

webview2Events
	"This is the full set of events. Not all are actually published currently; for example the frame and download events are not."

	^#(#acceleratorKeyPressed: #basicAuthenticationRequested: #bytesReceivedChanged #clientCertificateRequested: #containsFullScreenElementChanged #contentLoading: #contextMenuRequested: #cursorChanged #devToolsProtocolEvent: #documentTitleChanged #domContentLoaded: #dowloadStateChanged #downloadStarting: #favIconChanged #focusGained #focusLost #frameContentLoading: #frameCreated: #frameDestroyed #frameDomContentLoaded: #frameNameChanged #frameNavigationCompleted: #frameNavigationStarting: #framePermissionRequested: #frameWebMessageReceived: #historyChanged #isDefaultDownloadDialogOpenChanged #isDocumentPlayingAudioChanged #isMutedChanged #moveFocusRequested: #navigationCompleted: #navigationStarting: #newBrowserVersionAvailable #newWindowRequested: #permissionRequested: #processExited: #processFailed: #processInfosChanged #rasterizationScaleChanged #scriptDialogOpening: #serverCertificateErrorDetected: #sourceChanged: #statusBarTextChanged #webMessageReceived: #webResourceRequested: #webResourceResponseReceived: #webviewAvailable #windowCloseRequested #zoomFactorChanged)!

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

