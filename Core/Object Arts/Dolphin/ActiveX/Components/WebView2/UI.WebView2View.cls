"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.WebView2View'
	instanceVariableNames: 'settingsFlags unavailableLink webviewEnvironment webviewController webview eventHandlers environmentOptions environmentEventHandlers profileName scriptLocale _unused26'
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
			'DisableExternalDropsMask' -> 16r4000.
			'DisableGeneralAutofillMask' -> 16r400.
			'DisableHostObjectsMask' -> 16r10.
			'DisablePasswordAutosaveMask' -> 16r800.
			'DisablePinchZoomMask' -> 16r1000.
			'DisableScriptMask' -> 16r40.
			'DisableSmartScreen' -> 16r20000.
			'DisableStatusBarMask' -> 16r80.
			'DisableSwipeNavigationMask' -> 16r8000.
			'DisableWebmessageMask' -> 16r100.
			'DisableZoomControlMask' -> 16r200.
			'EnableInPrivateModeMask' -> 16r10000
		}!

UI.WebView2View guid: (Core.GUID fromString: '{3a9f720c-51f6-49f2-8267-f2b3b878129c}')!

UI.WebView2View comment: '`WebView2View` is a `<valueView>` that wraps the Microsoft Edge WebView2 embeddable browser to display content downloaded from a URL, or provided as a string.'!

!UI.WebView2View categoriesForClass!MVP-Views! !

!UI.WebView2View methodsFor!

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
	^environmentOptions allowSSO!

allowSSO: aBoolean
	"Set whether single sign-on should be enabled (the default)."

	self allowSSO = aBoolean ifTrue: [^self].
	self recreateAround: [environmentOptions allowSSO: aBoolean]!

areBrowserAcceleratorKeysEnabled
	"Answer whether the Edge default accelerator keys should be enabled."

	^settingsFlags noMask: DisableBrowserAcceleratorKeysMask!

areBrowserAcceleratorKeysEnabled: aBoolean
	"Set whether the Edge default accelerator keys should be enabled."

	settingsFlags := settingsFlags mask: DisableBrowserAcceleratorKeysMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings areBrowserAcceleratorKeysEnabled: aBoolean]!

areBrowserExtensionsEnabled
	^environmentOptions areBrowserExtensionsEnabled!

areBrowserExtensionsEnabled: aBoolean
	self areBrowserExtensionsEnabled = aBoolean ifTrue: [^self].
	self recreateAround: [environmentOptions areBrowserExtensionsEnabled: aBoolean]!

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

basicShowWithStyle: anInteger
	| result |
	result := super basicShowWithStyle: anInteger.
	webviewController ifNotNil: [webviewController isVisible: anInteger ~~ SW_HIDE].
	^result!

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
	"Currently we don't attempt to set any controller options - see ICoreWebView2ControllerOptions[2]"

	| controllerOptions |
	controllerOptions := webviewEnvironment createCoreWebView2ControllerOptions.
	self isInPrivateModeEnabled ifTrue: [controllerOptions isInPrivateModeEnabled: true].
	profileName isNil ifFalse: [controllerOptions profileName: profileName].
	scriptLocale isNil ifFalse: [controllerOptions scriptLocale: scriptLocale tag].
	webviewEnvironment
		createCoreWebView2Controller: handle
		withOptions: controllerOptions
		thenDo: [:hr :controller | hr < 0 ifFalse: [self onControllerCreated: controller]].	"We could create a composition controller here, but there is no point as we don't have any integration with Direct Composition"
	controllerOptions free!

createWebViewEnvironment
	| completed userDataFolder |
	completed := (WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 ifFalse: [self onEnvironmentCreated: env]])
					queryInterface: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.
	userDataFolder := self defaultUserDataFolder.
	
	[WebView2Loader default
		createCoreWebView2EnvironmentWithOptions: nil
		userDataFolder: userDataFolder
		environmentOptions: (environmentOptions queryInterface: ICoreWebView2EnvironmentOptions)
		environmentCreatedHandler: completed]
			on: HRESULTError
			do: [:ex | self createUnavailableLink].
	completed free.
	self topShell
		when: #positionChanged:
		send: #onShellPositionChanged:
		to: self!

defaultUserDataFolder
	^File composePath: (SessionManager current getenv: 'LocalAppData')
		subPath: (File splitFilenameFrom: (DynamicLinkLibrary moduleFileName: nil)) , '.WebView2'!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver."

	"Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	^User32
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

destroyDeadWebView
	"Private - Tear down the remnants of a dead web view after browser process exit. This involves destroying the event sink objects, without unregistering them as that will fail, and freeing up the existing controller and view. The environment is retained in case a new view is to be created."

	eventHandlers := eventHandlers do: [:each | each destroy].
	eventHandlers := OrderedCollection new.
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
	(self canNavigateToStrings not or: [Shlwapi pathIsURL: anObject])
		ifTrue: [webview navigate: anObject ?? 'about:blank']
		ifFalse: [webview navigateToString: anObject ?? '']!

documentTitle
	^webview documentTitle!

environmentOptions
	^environmentOptions!

filerProxyIn: anSTxOutFiler
	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	proxy instVars
		at: ##(self indexOfInstVar: 'environmentEventHandlers') put: nil;
		at: ##(self indexOfInstVar: 'webviewEnvironment') put: nil;
		at: ##(self indexOfInstVar: 'webviewController') put: nil;
		at: ##(self indexOfInstVar: 'webview') put: nil;
		at: ##(self indexOfInstVar: 'unavailableLink') put: nil;
		at: ##(self indexOfInstVar: 'eventHandlers') put: nil.
	^proxy!

goBack
	<commandQuery: #canGoBack>
	webview goBack!

goForward
	<commandQuery: #canGoForward>
	webview goForward!

initialize
	super initialize.
	settingsFlags := 0.
	webview := DeafObject.Current.
	environmentOptions := WebView2EnvironmentOptions new!

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
	^environmentOptions isCustomCrashReportingEnabled!

isCustomCrashReportingEnabled: aBoolean
	"Set whether custom error reporting should be enabled (suppressing the default behaviour of uploading crashes to Microsoft)."

	self isCustomCrashReportingEnabled = aBoolean ifTrue: [^self].
	self recreateAround: [environmentOptions isCustomCrashReportingEnabled: aBoolean]!

isGeneralAutofillEnabled
	^settingsFlags noMask: DisableGeneralAutofillMask!

isGeneralAutofillEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableGeneralAutofillMask set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isGeneralAutofillEnabled: aBoolean]!

isInPrivateModeEnabled
	^settingsFlags allMask: EnableInPrivateModeMask!

isInPrivateModeEnabled: aBoolean
	self isInPrivateModeEnabled = aBoolean ifTrue: [^self].
	settingsFlags := settingsFlags mask: EnableInPrivateModeMask set: aBoolean.
	webviewController isNull ifFalse: [self recreate]!

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

isSmartScreenEnabled
	^settingsFlags noMask: DisableSmartScreen!

isSmartScreenEnabled: aBoolean
	settingsFlags := settingsFlags mask: DisableSmartScreen set: aBoolean not.
	self webviewSettings ifNotNil: [:settings | settings isReputationCheckingRequired: aBoolean]!

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
	webviewController isNull ifTrue: [^self].
	webviewController NotifyParentWindowPositionChanged!

observeControllerEvents
	##({
		ICoreWebView2AcceleratorKeyPressedEventHandler.
		ICoreWebView2FocusLostEventHandler.
		ICoreWebView2FocusGainedEventHandler.
		ICoreWebView2RasterizationScaleChangedEventHandler.
		ICoreWebView2ZoomFactorChangedEventHandler.
		ICoreWebView2MoveFocusRequestedEventHandler
	}) do: [:each | self observeEvent: each from: webviewController].
	(webviewController queryInterface: ICoreWebView2CompositionController ifNone: [])
		ifNotNil: 
			[:webviewComposition |
			##({ ICoreWebView2CursorChangedEventHandler. ICoreWebView2NonClientRegionChangedEventHandler })
				do: [:each | self observeEvent: each from: webviewComposition]]!

observeEnvironmentEvents
	environmentEventHandlers := OrderedCollection new: 3.
	##({
		ICoreWebView2NewBrowserVersionAvailableEventHandler.
		ICoreWebView2BrowserProcessExitedEventHandler.
		ICoreWebView2ProcessInfosChangedEventHandler
	}) do: 
				[:each |
				self registerEnvironmentEventSink: (WebView2EventSink
							source: webviewEnvironment
							interfaceClass: each
							handler: (each triggerBlockFor: self presenter))]!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	^self registerEventSink: (WebView2EventSink
				source: anICoreWebView2EventSource
				interfaceClass: anICoreWebView2EventHandlerClass
				handler: (anICoreWebView2EventHandlerClass triggerBlockFor: self presenter))!

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
	##({
		ICoreWebView2BasicAuthenticationRequestedEventHandler.
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
		ICoreWebView2WindowCloseRequestedEventHandler.
		ICoreWebView2LaunchingExternalUriSchemeEventHandler.
		ICoreWebView2NotificationReceivedEventHandler.
		ICoreWebView2SaveAsUIShowingEventHandler.
		ICoreWebView2SaveFileSecurityCheckStartingEventHandler.
		ICoreWebView2ScreenCaptureStartingEventHandler
	}) do: [:each | self observeEvent: each from: webview]!

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
	Shell32 shellOpen: aLITEM url!

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

profileName
	^profileName!

profileName: aString
	profileName = aString ifTrue: [^self].
	profileName := aString.
	webviewController notNull ifTrue: [self recreate]!

queryControllerInterface: anIUnknown
	| interfaceClass |
	interfaceClass := ICoreWebView2Controller4.
	
	[(anIUnknown queryInterface: interfaceClass ifNone: []) ifNotNil: [:interface | ^interface].
	(interfaceClass := interfaceClass superclass) == ICoreWebView2Controller]
			whileFalse.
	^anIUnknown queryInterface: ICoreWebView2Controller!

registerEnvironmentEventSink: aWebView2EventSink
	aWebView2EventSink register.
	^environmentEventHandlers add: aWebView2EventSink!

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

scriptLocale
	^scriptLocale!

scriptLocale: aLocale
	scriptLocale = aLocale ifTrue: [^self].
	scriptLocale := aLocale.
	webviewController notNull ifTrue: [self recreate]!

scrollBarStyle
	^environmentOptions scrollBarStyle!

scrollBarStyle: anInteger
	| style |
	style := anInteger ?? COREWEBVIEW2_SCROLLBAR_STYLE_DEFAULT.
	self scrollBarStyle = style ifTrue: [^self].
	self recreateAround: [environmentOptions scrollBarStyle: style]!

setControlBackcolor: aColor
	self webviewController defaultBackgroundColor: aColor!

setFocus
	"Sets focus to the receiver. Answers the View which previously had focus, or nil if
	none/invalid handle. Implicitly re-enables the enclosing popup (shell) view if currently
	disabled."

	^self getFirstChild
		ifNil: [super setFocus]
		ifNotNil: [:chromeWidget | (View fromHandle: chromeWidget) setFocus]!

stop
	webview Stop!

subclassWindow: hWnd
	"Private - Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	self attachHandle: hWnd!

subViews
	^#()!

trackingPreventionLevel
	^environmentOptions trackingPreventionLevel!

trackingPreventionLevel: anInteger
	| level |
	level := anInteger ?? COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED.
	self trackingPreventionLevel = level ifTrue: [^self].
	self recreateAround: [environmentOptions trackingPreventionLevel: level]!

unregisterEvents
	eventHandlers
		ifNotNil: 
			[eventHandlers do: [:each | each free].
			eventHandlers := nil].
	environmentEventHandlers
		ifNotNil: 
			[environmentEventHandlers do: [:each | each free].
			environmentEventHandlers := nil]!

unregisterEventSink: aWebView2EventSink
	"Explicitly unregister an event handler."

	"Note that normally this is not necessary since all handlers are unregistered when the browser control is closed. It is also rather expensive with the current implementation (which could of course be changed), since it involves removing an object from an OrderedCollection (i.e. serial search and then moving memory to close any hole opened up in the collection)."

	aWebView2EventSink unregister.
	eventHandlers remove: aWebView2EventSink ifAbsent: nil!

updateSettings
	| settings back |
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
	self isPinchZoomEnabled ifFalse: [settings isPinchZoomEnabled: false].
	back := self actualBackcolor.
	back isDefault ifFalse: [self setControlBackcolor: back]!

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

!UI.WebView2View categoriesForMethods!
allowContextMenu!public!settings! !
allowContextMenu:!public!settings! !
allowExternalDrop!public!settings! !
allowExternalDrop:!public!settings! !
allowSSO!public!settings! !
allowSSO:!public!settings! !
areBrowserAcceleratorKeysEnabled!public!settings! !
areBrowserAcceleratorKeysEnabled:!public!settings! !
areBrowserExtensionsEnabled!public!settings!testing! !
areBrowserExtensionsEnabled:!public!settings! !
areDefaultScriptDialogsEnabled!public!settings! !
areDefaultScriptDialogsEnabled:!public!settings! !
areDevToolsEnabled!public!settings! !
areDevToolsEnabled:!public!settings! !
areHostObjectsAllowed!public!settings! !
areHostObjectsAllowed:!public!settings! !
basicShowWithStyle:!operations!private! !
browserVersion!accessing!public! !
canGoBack!commands!public! !
canGoForward!commands!public! !
canNavigateToStrings!public!settings! !
canNavigateToStrings:!public!settings! !
content!accessing!private! !
createUnavailableLink!private!realizing/unrealizing! !
createWebView!private!realizing/unrealizing! !
createWebViewEnvironment!private!realizing/unrealizing! !
defaultUserDataFolder!enquiries!private! !
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
destroyDeadWebView!private!realizing/unrealizing! !
displayValue!private!updating! !
displayValue:!private!updating! !
documentTitle!accessing!public! !
environmentOptions!accessing!public! !
filerProxyIn:!binary filing!private! !
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
isInPrivateModeEnabled!public!settings! !
isInPrivateModeEnabled:!public!settings! !
isPasswordAutosaveEnabled!public!settings! !
isPasswordAutosaveEnabled:!public!settings! !
isPinchZoomEnabled!public!settings! !
isPinchZoomEnabled:!public!settings! !
isScriptEnabled!public!settings! !
isScriptEnabled:!public!settings! !
isSmartScreenEnabled!public!settings! !
isSmartScreenEnabled:!public!settings! !
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
profileName!accessing!public! !
profileName:!accessing!public! !
queryControllerInterface:!helpers!private! !
registerEnvironmentEventSink:!helpers!public! !
registerEventSink:!helpers!public! !
releaseWebView!operations!private!realizing/unrealizing! !
resizeContentToFit!helpers!private! !
scriptLocale!accessing!public! !
scriptLocale:!accessing!public! !
scrollBarStyle!public!settings! !
scrollBarStyle:!public!settings! !
setControlBackcolor:!helpers!private! !
setFocus!operations!public! !
stop!commands!public! !
subclassWindow:!operations!private! !
subViews!hierarchy!public!sub views! !
trackingPreventionLevel!public!settings! !
trackingPreventionLevel:!public!settings! !
unregisterEvents!private!realizing/unrealizing! !
unregisterEventSink:!helpers!public! !
updateSettings!private!realizing/unrealizing! !
webview!accessing!public! !
webviewController!accessing!public! !
webviewEnvironment!accessing!public! !
webviewSettings!accessing!public! !
zoomFactor!public!zooming! !
zoomFactor:!public!zooming! !
!

!UI.WebView2View class methodsFor!

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

stbConvert: instVarArray fromVersion: verInteger
	"Convert from earlier version view by updating and answering the array of instance variables
	(for the View), instVarArray."

	| instVars |
	instVars := instVarArray.
	verInteger < 13 ifTrue: [instVars := super stbConvert: instVarArray fromVersion: verInteger].
	verInteger < 14 ifTrue: [instVars := self stbConvertFromVersion13: instVars].
	^instVars!

stbConvertFromVersion13: anArray
	"Private - Perform an STB conversion from a version 13 <WebView2View> to version 14.
	Adds environmentOptions instance variable and a few spares."

	| count settingsFlags |
	settingsFlags := anArray at: 16.
	count := anArray size + 5.
	^(Array new: count)
		replaceFrom: 1
			to: 21
			with: anArray
			startingAt: 1;
		at: 22
			put: (WebView2EnvironmentOptions new
					allowSSO: (settingsFlags noMask: 16r10000);
					isCustomCrashReportingEnabled: (settingsFlags allMask: 16r20000);
					yourself);
		yourself!

stbVersion
	^14!

webview2Events
	"This is the full set of events. Not all are actually published currently; for example the frame and download events are not."

	^#(#acceleratorKeyPressed: #basicAuthenticationRequested: #bytesReceivedChanged #clientCertificateRequested: #containsFullScreenElementChanged #contentLoading: #contextMenuRequested: #cursorChanged #devToolsProtocolEvent: #documentTitleChanged #domContentLoaded: #dowloadStateChanged #downloadStarting: #favIconChanged #focusGained #focusLost #frameContentLoading: #frameCreated: #frameDestroyed #frameDomContentLoaded: #frameNameChanged #frameNavigationCompleted: #frameNavigationStarting: #framePermissionRequested: #frameWebMessageReceived: #historyChanged #isDefaultDownloadDialogOpenChanged #isDocumentPlayingAudioChanged #isMutedChanged #launchingExternalUriScheme: #moveFocusRequested: #navigationCompleted: #navigationStarting: #newBrowserVersionAvailable #newWindowRequested: #notificationReceived: #permissionRequested: #processExited: #processFailed: #processInfosChanged #rasterizationScaleChanged #safeFileSecurityCheckStarting: #saveAsUIShowing: #screenCaptureStarting: #scriptDialogOpening: #serverCertificateErrorDetected: #sourceChanged: #statusBarTextChanged #webMessageReceived: #webResourceRequested: #webResourceResponseReceived: #webviewAvailable #windowCloseRequested #zoomFactorChanged)!

winClassName
	"Private - Answer the Windows class name, or atom, to be used when creating Windows attached
	to instances of the receiver."

	^self wndClassName! !

!UI.WebView2View class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
stbConvert:fromVersion:!binary filing!public! !
stbConvertFromVersion13:!binary filing!private! !
stbVersion!binary filing!public! !
webview2Events!events!public! !
winClassName!constants!private! !
!

