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

canFind
	^(webviewEnvironment isKindOf: ICoreWebView2Environment15) and: [presenter isBlank not]!

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

channelSearchKind
	^environmentOptions channelSearchKind!

channelSearchKind: anInteger

	self channelSearchKind = anInteger ifTrue: [^self].
	self recreateAround: [environmentOptions channelSearchKind: anInteger]!

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
	| controllerOptions |
	controllerOptions := webviewEnvironment createCoreWebView2ControllerOptions.
	self isInPrivateModeEnabled ifTrue: [controllerOptions isInPrivateModeEnabled: true].
	profileName ifNotNil: [controllerOptions profileName: profileName].
	scriptLocale ifNotNil: [controllerOptions scriptLocale: scriptLocale tag].
	backcolor ifNotNil: [controllerOptions defaultBackgroundColor: backcolor].
	webviewEnvironment
		createCoreWebView2Controller: handle
		withOptions: controllerOptions
		thenDo: [:hr :controller | hr < 0 
			ifTrue: [hr = E_ABORT ifFalse: [HRESULTError signalWith: hr]]
			ifFalse: [self onControllerCreated: controller]].	"We could create a composition controller here, but there is no point as we don't have any integration with Direct Composition"
	controllerOptions free!

createWebViewEnvironment
	| completed userDataFolder |
	completed := (WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 
						ifTrue: [HRESULTError signal: 'Failed to create WebView2 environment' with: hr]
						ifFalse: [self onEnvironmentCreated: env]])
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
	"Answer a path for the browser data folder that is writable with user privileges. We make this unique for a particular configuration of environment options, because it isn't possible to start webview2 instances with the same data folder that have mismatched environment options."

	^File composePath: (SessionManager current getenv: 'LocalAppData')
		subPath: '<1s>-<2s>.WebView2' << {
						File splitStemFrom: (Module moduleFileName: nil).
						self environmentOptions thumbprint
					}!

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

eventSinkFor: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	^anICoreWebView2EventSource newEventSink: anICoreWebView2EventHandlerClass
		handler: (anICoreWebView2EventHandlerClass triggerBlockFor: self presenter)!

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

find
	"Launch the FindText dialog in response to a generic toolbar find command."

	<commandQuery: #queryFind:>
	self findPrompt: self suggestedFindText!

findPrompt: aString
	"Private - Launch the modeless Find dialog.
	Pre-populate the dialog with aString."

	webviewEnvironment createFindOptions
		ifNotNil: 
			[:options |
			| find |
			options findTerm: aString.
			find := webview find.
			find start: options thenDo: [:hr | ]]!

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

observeBrowserProcessExit
	"Private - Process exit is a special case as we don't want to unregister this immediately when closing the browser view, or we will never get the event!!.
	When the view is being fully recreated, e.g. due to changing a style that is set in environment options such as the scrollbar style, we may very well receive this for the previous browser process after we have already started creating the new view."

	| urlPresenter processExited |
	urlPresenter := self presenter.
	processExited := WebView2EventSink new.
	processExited
		source: webviewEnvironment
		interfaceClass: ICoreWebView2BrowserProcessExitedEventHandler
		handler: 
			[:source :args |
			urlPresenter trigger: #processExited: with: args.
			processExited free].
	processExited register!

observeControllerEvents
	##({
		ICoreWebView2AcceleratorKeyPressedEventHandler.
		ICoreWebView2FocusGainedEventHandler.
		ICoreWebView2FocusLostEventHandler.
		ICoreWebView2MoveFocusRequestedEventHandler.
		ICoreWebView2RasterizationScaleChangedEventHandler.
		ICoreWebView2ZoomFactorChangedEventHandler.
	}) do: [:each | self observeEvent: each from: webviewController].
	(webviewController queryInterface: ICoreWebView2CompositionController ifNone: [])
		ifNotNil: 
			[:webviewComposition |
			##({ ICoreWebView2CursorChangedEventHandler. ICoreWebView2NonClientRegionChangedEventHandler })
				do: [:each | self observeEvent: each from: webviewComposition]]!

observeEnvironmentEvents

	environmentEventHandlers
		ifNil: 
			[environmentEventHandlers := ##({
						ICoreWebView2NewBrowserVersionAvailableEventHandler.
						ICoreWebView2ProcessInfosChangedEventHandler
					}) collect: 
								[:each |
								(self eventSinkFor: each from: webviewEnvironment)
									register;
									yourself]].
	"Process exit is a special case as we don't want to unregister this immediately when closing the browser view, or we will never get the event!!"
	self observeBrowserProcessExit!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2EventSource
	^self registerEventSink: (self eventSinkFor: anICoreWebView2EventHandlerClass
				from: anICoreWebView2EventSource)!

observeEvent: anICoreWebView2EventHandlerClass from: anICoreWebView2Interface handler: aDyadicValuable
	^self registerEventSink: (anICoreWebView2Interface newEventSink: anICoreWebView2EventHandlerClass
				handler: aDyadicValuable)!

observeWindowEvents
	"For some events we want to do more than just trigger a Smalltalk event, so these have custom handlers"

	self
		observeEvent: ICoreWebView2ProcessFailedEventHandler
		from: webview
		handler: [:source :args | self onProcessFailed: args].
	self
		observeEvent: ICoreWebView2SourceChangedEventHandler
		from: webview
		handler: [:source :args | self onSourceChanged: args].
	self
		observeEvent: ICoreWebView2HistoryChangedEventHandler
		from: webview
		handler: [:source :args | self onHistoryChanged].
	self
		observeEvent: ICoreWebView2FrameCreatedEventHandler
		from: webview
		handler: 
			[:source :args |
			self onFrameCreated: args.
			self presenter trigger: ICoreWebView2FrameCreatedEventHandler eventName with: args].
	self
		observeEvent: ICoreWebView2DownloadStartingEventHandler
		from: webview
		handler: [:source :args | self onDownloadStarting: args].
	##({
		ICoreWebView2BasicAuthenticationRequestedEventHandler.
		ICoreWebView2ClientCertificateRequestedEventHandler.
		ICoreWebView2ContainsFullScreenElementChangedEventHandler.
		ICoreWebView2ContentLoadingEventHandler.
		ICoreWebView2ContextMenuRequestedEventHandler.
		ICoreWebView2DocumentTitleChangedEventHandler.
		ICoreWebView2DOMContentLoadedEventHandler.
		ICoreWebView2FaviconChangedEventHandler.
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
	webviewController := anICoreWebView2Controller downCast.
	"Since we cannot trigger events off the presenter until it has been set, we delay observing environment events to here as at this point we know we definitely have a presenter and webview environment"
	self
		observeEnvironmentEvents;
		observeControllerEvents.
	self presenter trigger: #controllerAvailable.
	self resizeContentToFit.
	webview := webviewController coreWebView2.
	self initializeControl!

onDestroyed
	self unregisterEvents.
	self content close.
	self releaseWebView.
	self releaseWebViewEnvironment.
	^super onDestroyed!

onDownloadStarting: anICoreWebView2DownloadStartingEventArgs
	| download eventSinks |
	download := anICoreWebView2DownloadStartingEventArgs downloadOperation.
	eventSinks := ##({
				ICoreWebView2BytesReceivedChangedEventHandler.
				ICoreWebView2EstimatedEndTimeChangedEventHandler
			} asOrderedCollection)
				collect: [:each | self eventSinkFor: each from: download].
	"Register the StateChanged handler separately so we can use this to unhook on completion/interruption"
	eventSinks addLast: (download newEventSink: ICoreWebView2StateChangedEventHandler
				handler: 
					[:source :args |
					[self presenter trigger: ICoreWebView2StateChangedEventHandler eventName with: source]
						ensure: [source isFinished ifTrue: [eventSinks do: [:each | self unregisterEventSink: each]]]]).
	"Now register all the sinks with the download, and also store them in the receiver's register to ensure they are cleared up regardless, although normally we would expect that to happen when the download completes or is interrupted."
	eventSinks do: [:each | self registerEventSink: each].

	"Inform observers"
	self presenter trigger: ICoreWebView2DownloadStartingEventHandler eventName
		with: anICoreWebView2DownloadStartingEventArgs!

onEnvironmentCreated: anICoreWebView2Environment
	webviewEnvironment := anICoreWebView2Environment downCast.
	"Note that the presenter has not been set this point"
	self trigger: #environmentAvailable.
	self createWebView!

onEraseRequired: aColorEvent
	"The hosted webview will completely cover the receiver, so we don't want to erase as this can cause flashing, and also prevents a transparent default background colour in the WebView2 from showing through the parent background)."

	^true!

onFrameCreated: anICoreWebView2FrameCreatedEventArgs
	| frame frameSinks childFrameCreated |
	frame := anICoreWebView2FrameCreatedEventArgs frame.
	frameSinks := ##({
				ICoreWebView2FrameContentLoadingEventHandler.
				ICoreWebView2FrameDOMContentLoadedEventHandler.
				ICoreWebView2FrameNameChangedEventHandler.
				ICoreWebView2FrameNavigationCompletedEventHandler.
				ICoreWebView2FrameNavigationStartingEventHandler.
				ICoreWebView2FramePermissionRequestedEventHandler.
				ICoreWebView2FrameScreenCaptureStartingEventHandler.
				ICoreWebView2FrameWebMessageReceivedEventHandler
			} asOrderedCollection)
				collect: [:each | self eventSinkFor: each from: frame].
	"FrameCreated is a special case since we need to recurse to add event handlers for the new child frame. "
	childFrameCreated := frame newEventSink: ICoreWebView2FrameChildFrameCreatedEventHandler
				handler: 
					[:source :args |
					self onFrameCreated: args.
					self presenter
						trigger: ICoreWebView2FrameChildFrameCreatedEventHandler eventName
						with: source
						with: args].
	frameSinks addLast: childFrameCreated.

	"The FrameDestroyed event is sent from the frame being destroyed, making it asymmetric with respect to FrameCreated that is sent to the parent view or frame. It requires special handling in that on its receipt we want to destroy everything we might have associated with the frame."
	frameSinks addLast: (frame newEventSink: ICoreWebView2FrameDestroyedEventHandler
				handler: 
					[:source :args |
					[self presenter trigger: ICoreWebView2FrameDestroyedEventHandler eventName with: source]
						ensure: [frameSinks do: [:each | self unregisterEventSink: each]]]).
	"Now register all the sinks with the frame, and also store them in the receiver's register to ensure they are cleared up regardless, although normally we would expect that to happen when the frame is destroyed and receives the FrameDestroyed event."
	frameSinks do: [:each | self registerEventSink: each].

	"Prevent the child FrameCreated handler being unregistered on destroy as this causes a crash in the embedded browser DLL. Judging from the disassembly it looks like a bug in the control. No such issue occurs with any of the other events, and this one is newly defined. It seems that unregistering is not necessary anyway, as the destroyed frame releases the event sink interfaces."
	childFrameCreated token: nil!

onHistoryChanged
	self invalidateUserInterface.
	self presenter trigger: ICoreWebView2HistoryChangedEventHandler eventName!

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
	self presenter trigger: ICoreWebView2ProcessFailedEventHandler eventName with: failedArgs.
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
	self presenter trigger: ICoreWebView2SourceChangedEventHandler eventName
		with: anICoreWebView2SourceChangedEventArgs!

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

queryFind: aCommandQuery
	self canFind ifFalse: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: 'text'!

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

releaseWebViewEnvironment
	webviewEnvironment := nil!

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

suggestedFindText
	"Private - Answer the text which will be used to pre-populate the find/replace dialog."

	^Clipboard current getTextIfNone: ['']!

trackingPreventionLevel
	^environmentOptions isTrackingPreventionEnabled
		ifTrue: [self profile preferredTrackingPreventionLevel]
		ifFalse: [COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_NONE]!

trackingPreventionLevel: anInteger
	self profile
		preferredTrackingPreventionLevel: anInteger ?? COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_BALANCED!

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
canFind!private!testing! !
canGoBack!commands!public! !
canGoForward!commands!public! !
canNavigateToStrings!public!settings! !
canNavigateToStrings:!public!settings! !
channelSearchKind!public!settings! !
channelSearchKind:!public!settings! !
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
eventSinkFor:from:!helpers!private! !
filerProxyIn:!binary filing!private! !
find!commands-actions!public!searching & replacing! !
findPrompt:!private!searching & replacing! !
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
observeBrowserProcessExit!private!realizing/unrealizing! !
observeControllerEvents!private!realizing/unrealizing! !
observeEnvironmentEvents!private!realizing/unrealizing! !
observeEvent:from:!helpers!private! !
observeEvent:from:handler:!private!realizing/unrealizing! !
observeWindowEvents!private!realizing/unrealizing! !
onControllerCreated:!event handling!private! !
onDestroyed!event handling!private! !
onDownloadStarting:!event handling!private! !
onEnvironmentCreated:!event handling!private! !
onEraseRequired:!event handling!public! !
onFrameCreated:!event handling!private! !
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
queryFind:!commands-queries!private! !
registerEventSink:!helpers!public! !
releaseWebView!operations!private!realizing/unrealizing! !
releaseWebViewEnvironment!operations!private!realizing/unrealizing! !
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
suggestedFindText!helpers!private! !
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

	^#(#acceleratorKeyPressed: #basicAuthenticationRequested: #clientCertificateRequested: #containsFullScreenElementChanged #contentLoading: #contextMenuRequested: #cursorChanged #devToolsProtocolEvent: #documentTitleChanged #domContentLoaded: #dowloadStateChanged: #downloadBytesReceivedChanged: #downloadEtcChanged: #downloadStarting: #favIconChanged #focusGained #focusLost #frame:childFrameCreated: #frame:contentLoading: #frame:domContentLoaded: #frame:navigationCompleted: #frame:navigationStarting: #frame:permissionRequested: #frame:webMessageReceived: #frameCreated: #frameDestroyed: #frameNameChanged: #historyChanged #isDefaultDownloadDialogOpenChanged #isDocumentPlayingAudioChanged #isMutedChanged #launchingExternalUriScheme: #moveFocusRequested: #navigationCompleted: #navigationStarting: #newBrowserVersionAvailable #newWindowRequested: #notificationReceived: #permissionRequested: #processExited: #processFailed: #processInfosChanged #rasterizationScaleChanged #safeFileSecurityCheckStarting: #saveAsUIShowing: #screenCaptureStarting: #scriptDialogOpening: #serverCertificateErrorDetected: #sourceChanged: #statusBarTextChanged #webMessageReceived: #webResourceRequested: #webResourceResponseReceived: #webviewAvailable #windowCloseRequested #zoomFactorChanged)!

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

