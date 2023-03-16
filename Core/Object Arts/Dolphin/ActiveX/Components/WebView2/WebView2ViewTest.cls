"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #WebView2ViewTest
	instanceVariableNames: 'domContentLoaded navigationCompleted processFailed webViewReady webViewClosed'
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
WebView2ViewTest guid: (GUID fromString: '{3cee0357-fcb9-4dd8-8e6f-9962dbca8e5c}')!
WebView2ViewTest comment: ''!
!WebView2ViewTest categoriesForClass!Unclassified! !
!WebView2ViewTest methodsFor!

classToTest
	^URLPresenter!

initializePresenter
	presenter := URLPresenter on: URLPresenter defaultModel.
	presenter
		when: #domContentLoaded:
			send: #onDomContentLoaded:
			to: self;
		when: #navigationCompleted:
			send: #onNavigationCompleted:
			to: self;
		when: #processFailed:
			send: #onProcessFailed:
			to: self;
		when: #webviewAvailable
			send: #onWebViewAvailable
			to: self;
		when: #webviewClosed
			send: #onWebViewClosed
			to: self.
	webViewReady := false.
	presenter createView: URLPresenter defaultView.
	self waitAtMost: 20 seconds while: [webViewReady not].
	self assert: presenter view webview notNull!

onDomContentLoaded: anICoreWebView2DOMContentLoadedEventArgs
	domContentLoaded := anICoreWebView2DOMContentLoadedEventArgs navigationId!

onNavigationCompleted: anICoreWebView2NavigationCompletedEventArgs2
	navigationCompleted := anICoreWebView2NavigationCompletedEventArgs2!

onProcessFailed: anICoreWebView2ProcessFailedEventArgs2 
	processFailed := anICoreWebView2ProcessFailedEventArgs2 processFailedKind
!

onWebViewAvailable
	webViewReady := true!

onWebViewClosed
	webViewClosed := true!

tearDown
	navigationCompleted
		ifNotNil: 
			[navigationCompleted free.
			navigationCompleted := nil].
	webViewClosed := presenter notNil and: [presenter view isOpen].
	super tearDown.
	self waitAtMost: 2 seconds while: [webViewClosed not].
	presenter removeAllEventsTriggered!

testNavigateToString
	"Bit of a kick-the-tyres test, but it does execute a lot of the integration, e.g. creating the WebView2 environment, controller and view, and setting up event handlers and handling of events."

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	navigationCompleted := domContentLoaded := nil.
	presenter model value: '<html><title>Greetings</title><body>Hello World!!</body></html>'.
	self assert: self waitForNavigationCompleted.
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'about:blank'.
	self assert: webview documentTitle equals: 'Greetings'.
	self assert: navigationCompleted navigationId equals: domContentLoaded!

testProperties
	"Test the default properties and setting properties for all the core interfaces. We do this in one test because of the high startup cost for a WebView2 instance."

	self verifyWebViewProperties.
	self verifyWebViewEnvironmentProperties.
	self verifyWebViewControllerProperties.
	self verifyWebViewSettings!

testWebBrowserCrashRecovery
	"Test browser recovery after a crash of the browser process that causes it to exit"

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	processFailed := navigationCompleted := domContentLoaded := nil.
	presenter model value: 'edge://inducebrowsercrashforrealz/'.
	self assert: self waitForNavigationCompleted.
	self assert: processFailed
		equals: COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED.
	"Unless suppressed by the #processFailed: handler, the webview will be recreated and navigated to the crashes page"
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'edge://crashes/'.
	self assert: navigationCompleted navigationId equals: domContentLoaded!

verifyWebViewControllerProperties
	| controller baseController |
	controller := presenter view webviewController.
	self assert: controller isKindOf: ICoreWebView2Controller4.
	baseController := controller queryInterface: ICoreWebView2Controller.
	"ICoreWebView2Controller: bounds, coreWebView2, isVisible, parentWindow, zoomFactor"
	self assert: baseController bounds equals: presenter view rectangle.
	self assert: baseController coreWebView2 isKindOf: ICoreWebView2_16.
	self assert: baseController coreWebView2 equals: presenter view webview.
	self assert: baseController isVisible.
	baseController isVisible: false.
	self deny: baseController isVisible.
	baseController isVisible: true.
	self assert: baseController isVisible.
	self assert: baseController parentWindow equals: presenter view handle asInteger.
	self assert: baseController zoomFactor equals: 1.
	baseController zoomFactor: 0.75.
	self assert: baseController zoomFactor equals: 0.75.
	"ICoreWebView2Controller2: defaultBackgroundColor"
	self assert: baseController defaultBackgroundColor equals: Color white.
	self assert: controller defaultBackgroundColor equals: Color white.
	controller defaultBackgroundColor: Color magenta.
	self assert: baseController defaultBackgroundColor equals: Color white.
	self assert: controller defaultBackgroundColor equals: Color magenta.
	"ICoreWebView2Controller3: boundsMode, rasterizationScale, shouldDetectMonitorScaleChanges"
	self assert: baseController boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	self assert: controller boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	controller boundsMode: COREWEBVIEW2_BOUNDS_MODE_USE_RASTERIZATION_SCALE.
	self assert: baseController boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	self assert: controller boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RASTERIZATION_SCALE.
	self assert: baseController rasterizationScale equals: 1.0.
	self assert: controller rasterizationScale equals: 1.0.
	controller rasterizationScale: 1.25.
	self assert: baseController rasterizationScale equals: 1.0.
	self assert: controller rasterizationScale equals: 1.25.
	self assert: baseController shouldDetectMonitorScaleChanges.
	self assert: controller shouldDetectMonitorScaleChanges.
	controller shouldDetectMonitorScaleChanges: false.
	self assert: baseController shouldDetectMonitorScaleChanges.
	self deny: controller shouldDetectMonitorScaleChanges.
	"ICoreWebView2Controller4: allowExternalDrop"
	self assert: baseController allowExternalDrop.
	self assert: controller allowExternalDrop.
	baseController allowExternalDrop: false.
	self assert: controller allowExternalDrop.
	self assert: baseController allowExternalDrop.
	controller allowExternalDrop: false.
	self deny: controller allowExternalDrop.
	self assert: baseController allowExternalDrop!

verifyWebViewEnvironmentProperties
	| browserVersion environment baseEnvironment parts |
	environment := presenter view webviewEnvironment.
	baseEnvironment := environment queryInterface: ICoreWebView2Environment.
	"ICoreWebView2Environment: browserVersionString"
	browserVersion := baseEnvironment browserVersionString.
	parts := ($. split: browserVersion) collect: [:each | Integer fromString: each].
	self assert: parts size equals: 4.
	"ICoreWebView2Environment2: No new properties."
	"ICoreWebView2Environment3: No new properties."
	"ICoreWebView2Environment4: No new properties."
	"ICoreWebView2Environment5: No new properties."
	"ICoreWebView2Environment6: No new properties."
	"ICoreWebView2Environment7: userDataFolder."
	self assertIsNil: baseEnvironment userDataFolder.
	self
		assert: (environment userDataFolder beginsWith: (SessionManager current getenv: 'LocalAppData')).
	"ICoreWebView2Environment9: No new properties."
	"ICoreWebView2Environment10: No new properties."
	^environment!

verifyWebViewProperties
	| defaultMargin webview2 baseInterface |
	webview2 := presenter view webview.
	self assert: webview2 isKindOf: ICoreWebView2_16.
	baseInterface := webview2 queryInterface: ICoreWebView2.
	"ICoreWebView2: browserProcessId, canGoBack, canGoForward, containsFullScreenElement, documentTitle, settings, source"
	self assert: baseInterface browserProcessId equals: webview2 browserProcessId.
	self deny: baseInterface browserProcessId equals: 0.
	self deny: baseInterface canGoBack.
	self deny: webview2 canGoBack.
	self deny: baseInterface canGoForward.
	self deny: webview2 canGoForward.
	self deny: baseInterface containsFullScreenElement.
	self deny: webview2 containsFullScreenElement.
	self assert: baseInterface documentTitle equals: ''.
	self assert: webview2 documentTitle equals: ''.
	self assert: baseInterface settings isKindOf: ICoreWebView2Settings7.
	self assert: baseInterface source equals: 'about:blank'.
	self assert: webview2 source equals: 'about:blank'.
	"ICoreWebView2_2: cookieManager, environment"
	self assert: webview2 cookieManager isKindOf: ICoreWebView2CookieManager.
	self assertIsNil: baseInterface cookieManager.
	self assert: webview2 environment isKindOf: ICoreWebView2Environment11.
	self assertIsNil: baseInterface environment.
	"ICoreWebView2_3: isSuspended"
	self deny: baseInterface isSuspended.
	self deny: webview2 isSuspended.
	"ICoreWebView2_4: No new properties"
	"ICoreWebView2_5: No new properties"
	"ICoreWebView2_6: No new properties"
	"ICoreWebView2_7: No new properties"
	"ICoreWebView2_8: isDocumentPlayingAudio, isMuted"
	self deny: baseInterface isDocumentPlayingAudio.
	self deny: webview2 isDocumentPlayingAudio.
	self deny: baseInterface isMuted.
	self deny: webview2 isMuted.
	baseInterface isMuted: true.
	self deny: baseInterface isMuted.
	webview2 isMuted: true.
	self assert: webview2 isMuted.
	self deny: baseInterface isMuted.
	"ICoreWebView2_9: defaultDownloadDialogCornerAlignment, defaultDownloadDialogMargin, isDefaultDownloadDialogOpen"
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 1.
	baseInterface defaultDownloadDialogCornerAlignment: 5.
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 1.
	self assert: webview2 defaultDownloadDialogCornerAlignment equals: 1.
	webview2 defaultDownloadDialogCornerAlignment: 5.
	self assert: webview2 defaultDownloadDialogCornerAlignment equals: 5.
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 1.
	defaultMargin := webview2 defaultDownloadDialogMargin.
	self deny: defaultMargin equals: 0.
	self assert: baseInterface defaultDownloadDialogMargin equals: defaultMargin.
	baseInterface defaultDownloadDialogMargin: 5.
	self assert: baseInterface defaultDownloadDialogMargin equals: defaultMargin.
	webview2 defaultDownloadDialogMargin: 15 @ 25.
	self assert: webview2 defaultDownloadDialogMargin equals: 15 @ 25.
	self assert: baseInterface defaultDownloadDialogMargin equals: defaultMargin.
	self deny: baseInterface isDefaultDownloadDialogOpen.
	"ICoreWebView2_10: No new properties"
	"ICoreWebView2_11: No new properties"
	"ICoreWebView2_12: statusBarText"
	self assert: baseInterface statusBarText equals: ''.
	self assert: webview2 statusBarText equals: ''.
	"ICoreWebView2_13: profile"
	self assert: webview2 profile isKindOf: ICoreWebView2Profile.
	self assertIsNil: baseInterface profile.
	"ICoreWebView2_14: No new properties"
	"ICoreWebView2_15: faviconUri"
	self assert: baseInterface faviconUri equals: ''.
	self assert: webview2 faviconUri equals: ''!

verifyWebViewSettings
	| settings baseSettings userAgent hidden |
	settings := presenter view webviewSettings.
	self assert: settings isKindOf: ICoreWebView2Settings7.
	baseSettings := settings queryInterface: ICoreWebView2Settings.
	"ICoreWebView2Settings: areDefaultContextMenusEnabled, areDevToolsEnabled, arHostObjectsAllowed, isBuildInErrorPageEnabled, isScriptEnabled, isStatusBarEnabled, isWebMessageEnabled, isZoomControlEnabled"
	self assert: baseSettings areDefaultContextMenusEnabled.
	baseSettings areDefaultContextMenusEnabled: false.
	self deny: baseSettings areDefaultContextMenusEnabled.
	self assert: baseSettings areDevToolsEnabled.
	baseSettings areDevToolsEnabled: false.
	self deny: baseSettings areDevToolsEnabled.
	self assert: baseSettings areHostObjectsAllowed.
	baseSettings areHostObjectsAllowed: false.
	self deny: baseSettings areHostObjectsAllowed.
	self assert: baseSettings isBuiltInErrorPageEnabled.
	baseSettings isBuiltInErrorPageEnabled: false.
	self deny: baseSettings isBuiltInErrorPageEnabled.
	self assert: baseSettings isScriptEnabled.
	baseSettings isScriptEnabled: false.
	self deny: baseSettings isScriptEnabled.
	self assert: baseSettings isStatusBarEnabled.
	baseSettings isStatusBarEnabled: false.
	self deny: baseSettings isStatusBarEnabled.
	self assert: baseSettings isWebMessageEnabled.
	baseSettings isWebMessageEnabled: false.
	self deny: baseSettings isWebMessageEnabled.
	self assert: baseSettings isZoomControlEnabled.
	baseSettings isZoomControlEnabled: false.
	self deny: baseSettings isZoomControlEnabled.
	"ICoreWebView2Settings2: userAgent"
	userAgent := settings userAgent.
	self assert: (userAgent endsWith: 'Edg/' , presenter view webviewEnvironment browserVersionString).
	self assert: baseSettings userAgent equals: ICoreWebView2Settings defaultUserAgent.
	userAgent := userAgent copyFrom: 1 to: (userAgent indexOfSubCollection: 'Edg/').
	settings userAgent: userAgent.
	self assert: settings userAgent equals: userAgent.
	self assert: baseSettings userAgent equals: ICoreWebView2Settings defaultUserAgent.
	"ICoreWebView2Settings3: areBrowserAcceleratorKeysEnabled"
	self assert: settings areBrowserAcceleratorKeysEnabled.
	self assert: baseSettings areBrowserAcceleratorKeysEnabled.
	settings areBrowserAcceleratorKeysEnabled: false.
	self deny: settings areBrowserAcceleratorKeysEnabled.
	self assert: baseSettings areBrowserAcceleratorKeysEnabled.
	"ICoreWebView2Settings4: isGeneralAutofillEnabled, isPasswordAutosaveEnabled"
	self assert: settings isGeneralAutofillEnabled.
	self assert: baseSettings isGeneralAutofillEnabled.
	settings isGeneralAutofillEnabled: false.
	self deny: settings isGeneralAutofillEnabled.
	self assert: baseSettings isGeneralAutofillEnabled.
	self deny: baseSettings isPasswordAutosaveEnabled.
	self deny: settings isPasswordAutosaveEnabled.
	settings isPasswordAutosaveEnabled: true.
	self assert: settings isPasswordAutosaveEnabled.
	self deny: baseSettings isPasswordAutosaveEnabled.
	"ICoreWebView2Settings5: isPinchZoomEnabled"
	self assert: settings isPinchZoomEnabled.
	self assert: baseSettings isPinchZoomEnabled.
	settings isPinchZoomEnabled: false.
	self deny: settings isPinchZoomEnabled.
	self assert: baseSettings isPinchZoomEnabled.
	"ICoreWebView2Settings6: isSwipeNavigationEnabled"
	self assert: settings isSwipeNavigationEnabled.
	self assert: baseSettings isSwipeNavigationEnabled.
	settings isSwipeNavigationEnabled: false.
	self deny: settings isSwipeNavigationEnabled.
	self assert: baseSettings isSwipeNavigationEnabled.
	"ICoreWebView2Settings6: hiddenPdfToolbarItems"
	self assert: settings hiddenPdfToolbarItems equals: COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE.
	self assert: baseSettings hiddenPdfToolbarItems equals: COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE.
	hidden := COREWEBVIEW2_PDF_TOOLBAR_ITEMS_PRINT | COREWEBVIEW2_PDF_TOOLBAR_ITEMS_SAVE_AS.
	settings hiddenPdfToolbarItems: hidden.
	self assert: settings hiddenPdfToolbarItems equals: hidden.
	self assert: baseSettings hiddenPdfToolbarItems equals: COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE!

waitAtMost: aDuration while: aNiladicValuable
	| start |
	start := DateAndTime now.
	SessionManager inputState
		loopWhile: [aNiladicValuable value and: [DateAndTime now - start < aDuration]].
	^aNiladicValuable value not!

waitForNavigationCompleted
	^self waitAtMost: 60 seconds while: [navigationCompleted isNil]! !
!WebView2ViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
onDomContentLoaded:!event handling!private! !
onNavigationCompleted:!event handling!private! !
onProcessFailed:!event handling!private! !
onWebViewAvailable!event handling!private! !
onWebViewClosed!event handling!private! !
tearDown!public!Running! !
testNavigateToString!public!unit tests! !
testProperties!public!unit tests! !
testWebBrowserCrashRecovery!public!unit tests! !
verifyWebViewControllerProperties!helpers!private! !
verifyWebViewEnvironmentProperties!helpers!private! !
verifyWebViewProperties!helpers!private! !
verifyWebViewSettings!helpers!private! !
waitAtMost:while:!helpers!private! !
waitForNavigationCompleted!helpers!private! !
!

