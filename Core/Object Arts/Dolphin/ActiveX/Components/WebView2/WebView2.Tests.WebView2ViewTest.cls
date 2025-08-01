﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'WebView2.Tests.WebView2ViewTest'
	instanceVariableNames: 'domContentLoaded navigationCompleted processFailed webViewReady webviewEnvironment processExited navigationStarting'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.WebView2ViewTest guid: (Core.GUID fromString: '{3cee0357-fcb9-4dd8-8e6f-9962dbca8e5c}')!

WebView2.Tests.WebView2ViewTest comment: ''!

!WebView2.Tests.WebView2ViewTest methodsFor!

classToTest
	^UI.URLPresenter!

initializePresenter
	presenter := URLPresenter on: URLPresenter defaultModel.
	presenter
		when: #domContentLoaded:
			send: #onDomContentLoaded:
			to: self;
		when: #navigationStarting:
			send: #onNavigationStarting:
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
		when: #processExited:
			send: #onBrowserProcessExited:
			to: self.
	webViewReady := false.
	presenter createView: URLPresenter defaultView.
	presenter topShell show.
	"We need to wait until the web view is ready before we commence any testing"
	self waitAtMost: 20 seconds while: [webViewReady not].
	self assert: presenter view webview notNull.
	webviewEnvironment := presenter view webviewEnvironment.
	self assert: webviewEnvironment notNull!

onBrowserProcessExited: anICoreWebView2BrowserProcessExitedEventArgs
	"We track browser process shut down in order to wait at the end of one test case before we fire it up again for the next. This significantly increases the reliability of the tests when run together."

	anICoreWebView2BrowserProcessExitedEventArgs isNormalExit
		ifTrue: [processExited := anICoreWebView2BrowserProcessExitedEventArgs browserProcessId]!

onDomContentLoaded: anICoreWebView2DOMContentLoadedEventArgs
	domContentLoaded := anICoreWebView2DOMContentLoadedEventArgs navigationId!

onNavigationCompleted: anICoreWebView2NavigationCompletedEventArgs2
	navigationCompleted := anICoreWebView2NavigationCompletedEventArgs2!

onNavigationStarting: anICoreWebView2NavigationStartedEventArgs3
	navigationStarting := anICoreWebView2NavigationStartedEventArgs3!

onProcessFailed: anICoreWebView2ProcessFailedEventArgs2 
	processFailed := anICoreWebView2ProcessFailedEventArgs2 processFailedKind
!

onWebViewAvailable
	webViewReady := true!

tearDown
	presenter isNil ifTrue: [^self].
	navigationStarting
		ifNotNil: 
			[navigationStarting free.
			navigationStarting := nil].
	navigationCompleted
		ifNotNil: 
			[navigationCompleted free.
			navigationCompleted := nil].
	self destroyPresenter.
	self waitAtMost: 20 seconds while: [processExited isNil].
	webviewEnvironment notNull
		ifTrue: 
			[webviewEnvironment free.
			webviewEnvironment := nil].
	presenter removeAllEventsTriggered.
	super tearDown!

testContextMenu
	<knownSlowTest>
	<skipIf: #isCiBuild> "Too unreliable"
	<skipUnless: #isInForeground>
	| contextMenuHandler menuEvent newCmd iconStream cmdEventSink cmdFired |
	iconStream := IStream read: (FileLocator installRelative: 'Resources\Dolphin.ico') asString.
	newCmd := presenter view webviewEnvironment
				createContextMenuItem: '&Blah'
				iconStream: iconStream
				kind: COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND_COMMAND.
	self assertIsNil: newCmd items.
	self assert: newCmd label equals: '&Blah'.
	self assert: newCmd name equals: '&Blah'.
	self assert: newCmd kind equals: COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND_COMMAND.
	self assert: newCmd kindName equals: #command.
	self deny: newCmd isChecked.
	self assert: newCmd isEnabled.
	cmdFired := false.
	cmdEventSink := WebView2EventSink
				source: newCmd
				interfaceClass: ICoreWebView2CustomItemSelectedEventHandler
				handler: [:source | cmdFired := true].
	cmdEventSink register.
	contextMenuHandler := 
			[:eventArgs |
			| items |
			items := eventArgs menuItems.
			items
				removeAtIndex: (items findFirst: [:each | each name = 'inspectElement']);
				add: newCmd beforeIndex: 1.
			menuEvent := eventArgs].
	presenter
		when: #contextMenuRequested:
		send: #value:
		to: contextMenuHandler.
	navigationCompleted := nil.
	presenter model value: 'edge://edge-urls'.
	self assert: self waitForNavigationCompleted.
	presenter view setFocus.
	self sendKeyPress: Win32Constants.VK_APPS extended: true.
	self waitAtMost: 50 milliseconds while: [menuEvent isNil].
	"Hmmm, how can we tell that the context menu has actually popped up"
	self waitAtMost: 50 milliseconds while: [true].
	"Action the selected context menu command"
	self sendKeyPress: VK_RETURN extended: false.
	self waitAtMost: 200 milliseconds while: [cmdFired not].
	cmdEventSink free.
	self assert: cmdFired.

!

testNavigateToString
	"Bit of a kick-the-tyres test, but it does execute a lot of the integration, e.g. creating the WebView2 environment, controller and view, and setting up event handlers and handling of events."

	<knownSlowTest>
	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	navigationCompleted := domContentLoaded := nil.
	presenter model value: '<html><title>Greetings</title><body>Hello World!!</body></html>'.
	self assert: self waitForNavigationCompleted.
	self assert: navigationStarting isKindOf: ICoreWebView2NavigationStartingEventArgs3.
	self assert: navigationStarting navigationKind equals: COREWEBVIEW2_NAVIGATION_KIND_NEW_DOCUMENT.
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'about:blank'.
	self assert: webview documentTitle equals: 'Greetings'.
	self assert: navigationCompleted navigationId equals: domContentLoaded!

testProperties
	"Test the default properties and setting properties for all the core interfaces. We do this in one test because of the high startup cost for a WebView2 instance."

	<knownSlowTest>
	navigationCompleted := nil.
	presenter model value: 'edge://edge-urls/'.
	self assert: self waitForNavigationCompleted.
	self verifyWebViewProperties.
	self verifyWebViewEnvironmentProperties.
	self verifyWebViewControllerProperties.
	self verifyWebViewSettings.
	self verifyWebViewProfile!

testWebBrowserCrashRecovery
	"Test browser recovery after a crash of the browser process that causes it to exit"

	<knownSlowTest>
	<skipIf: #isCiBuild>	"Too unreliable to run in CI"

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	processFailed := navigationCompleted := domContentLoaded := nil.
	presenter model value: 'edge://inducebrowsercrashforrealz/'.
	self assert: self waitForNavigationCompleted.
	self assert: processFailed equals: COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED.
	"Unless suppressed by the #processFailed: handler, the webview will be recreated and navigated to the crashes page"
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'edge://crashes/'.
	self assert: navigationCompleted navigationId equals: domContentLoaded!

verifyWebViewControllerProperties
	| controller baseController rasterizationScale |
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
	controller defaultBackgroundColor: Color menuHilight.
	self assert: baseController defaultBackgroundColor equals: Color white.
	self assert: controller defaultBackgroundColor equals: Color menuHilight.
	self should: [controller defaultBackgroundColor: (Color yellow alpha: 128)] raise: HRESULTError matching: [:ex | ex hresult = E_INVALIDARG].
	controller defaultBackgroundColor: (Color yellow alpha: 0).
	self assert: baseController defaultBackgroundColor equals: Color white.
	self assert: controller defaultBackgroundColor equals: (Color yellow alpha: 0).

	"ICoreWebView2Controller3: boundsMode, rasterizationScale, shouldDetectMonitorScaleChanges"
	self assert: baseController boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	self assert: controller boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	controller boundsMode: COREWEBVIEW2_BOUNDS_MODE_USE_RASTERIZATION_SCALE.
	self assert: baseController boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RAW_PIXELS.
	self assert: controller boundsMode equals: COREWEBVIEW2_BOUNDS_MODE_USE_RASTERIZATION_SCALE.
	self assert: baseController rasterizationScale equals: 1.0.
	rasterizationScale := controller rasterizationScale.
	self assert: rasterizationScale equals: presenter view dpi / USER_DEFAULT_SCREEN_DPI.
	controller rasterizationScale: rasterizationScale * 2.
	self assert: baseController rasterizationScale equals: 1.0.
	self assert: controller rasterizationScale equals: rasterizationScale * 2.
	controller rasterizationScale: rasterizationScale.
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
	"Most environment properties are tested in the separate WebViewEnvironment test hierarchy as these do only create the environment object and so are much cheaper to run. Some properties are not available unless we have the full browser stack through."

	| environment extendedProcessInfos renderer |
	environment := presenter view webviewEnvironment.
	environment getProcessExtendedInfosThenDo: [:hr :infos | extendedProcessInfos := infos].
	self waitAtMost: 2 seconds while: [extendedProcessInfos isNil].
	self assert: (#('RENDERER' 'BROWSER' 'UTILITY')
				difference: (extendedProcessInfos collect: [:each | each kindName]))
		equals: #()!

verifyWebViewProfile
	"In general we can't assert for particular profile property values, as these may have been altered from the defaults in a persistent profile."

	| profile cookieManager extensions |
	profile := presenter view webview profile.
	self assert: profile isKindOf: ICoreWebView2Profile.
	self assert: (profile profilePath beginsWith: presenter view defaultUserDataFolder).
	self assert: profile defaultDownloadFolderPath equals: SessionManager current downloadsDirectory.
	"ICoreWebView2Profile2: No new properties"
	"ICoreWebView2Profile3: preferredTrackingPreventionLevel"
	"The tracking prevention level may have been adjusted in the profile, so we can only assert that it is in range"
	self assert: (profile preferredTrackingPreventionLevel
				between: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_NONE
				and: COREWEBVIEW2_TRACKING_PREVENTION_LEVEL_STRICT).
	"ICoreWebView2Profile4: No new properties"
	"ICoreWebView2Profile5: Cookie manager"
	cookieManager := profile cookieManager.
	self assert: cookieManager isKindOf: ICoreWebView2CookieManager.
	"ICoreWebView2Profile6: isGeneralAutofillEnabled, isPasswordAutosaveEnabled"
	self assert: profile isGeneralAutofillEnabled isKindOf: Boolean.
	self assert: profile isPasswordAutosaveEnabled isKindOf: Boolean.
	"ICoreWebView2Profile7: GetBrowserExtensions"
	profile getBrowserExtensionsThenDo: 
			[:hr :list |
			self assert: hr equals: S_OK.
			extensions := list].
	self waitAtMost: 100 milliseconds while: [extensions isNil].
	self assert: (extensions anySatisfy: [:each | each name = 'Microsoft Clipboard Extension'])!

verifyWebViewProperties
	| defaultMargin webview2 baseInterface |
	webview2 := presenter view webview.
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
	self assert: baseInterface documentTitle equals: 'Edge URLs'.
	self assert: webview2 documentTitle equals: 'Edge URLs'.
	self assert: baseInterface settings isKindOf: ICoreWebView2Settings7.
	self assert: baseInterface source equals: 'edge://edge-urls/'.
	self assert: webview2 source equals: 'edge://edge-urls/'.
	"ICoreWebView2_2: cookieManager, environment"
	self assert: webview2 cookieManager isKindOf: ICoreWebView2CookieManager.
	self assertIsNil: baseInterface cookieManager.
	self assert: webview2 environment isKindOf: ICoreWebView2Environment.
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
	self assert: baseInterface defaultDownloadDialogCornerAlignment
		equals: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_TOP_RIGHT.
	baseInterface
		defaultDownloadDialogCornerAlignment: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_BOTTOM_RIGHT.
	self assert: baseInterface defaultDownloadDialogCornerAlignment
		equals: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_TOP_RIGHT.
	self assert: webview2 defaultDownloadDialogCornerAlignment
		equals: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_TOP_RIGHT.
	webview2
		defaultDownloadDialogCornerAlignment: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_BOTTOM_RIGHT.
	self assert: webview2 defaultDownloadDialogCornerAlignment
		equals: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_BOTTOM_RIGHT.
	self assert: baseInterface defaultDownloadDialogCornerAlignment
		equals: COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT_TOP_RIGHT.
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
	self assert: webview2 faviconUri equals: ''.
	"ICoreWebView2_16: No new properties"
	"ICoreWebView2_17: No new properties"
	"ICoreWebView2_18: No new properties"
	"ICoreWebView2_19: memoryUsageTargetLevel"
	self assert: baseInterface memoryUsageTargetLevel
		equals: COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL_NORMAL.
	self assert: webview2 memoryUsageTargetLevel equals: COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL_NORMAL.
	webview2 memoryUsageTargetLevel: COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL_LOW.
	self assert: baseInterface memoryUsageTargetLevel
		equals: COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL_NORMAL.
	self assert: webview2 memoryUsageTargetLevel equals: COREWEBVIEW2_MEMORY_USAGE_TARGET_LEVEL_LOW.
	"ICoreWebView2_20: frameId"
	self assert: baseInterface frameId equals: 0.
	(webview2 isKindOf: ICoreWebView2_20) ifTrue: [self deny: webview2 frameId equals: 0]!

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
	self assert: (userAgent contains: 'Edg/').
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
	"ICoreWebView2Settings7: hiddenPdfToolbarItems"
	self assert: settings hiddenPdfToolbarItems equals: WebView2.COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE.
	self assert: baseSettings hiddenPdfToolbarItems equals: WebView2.COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE.
	hidden := WebView2.COREWEBVIEW2_PDF_TOOLBAR_ITEMS_PRINT
				| WebView2.COREWEBVIEW2_PDF_TOOLBAR_ITEMS_SAVE_AS.
	settings hiddenPdfToolbarItems: hidden.
	self assert: settings hiddenPdfToolbarItems equals: hidden.
	self assert: baseSettings hiddenPdfToolbarItems equals: WebView2.COREWEBVIEW2_PDF_TOOLBAR_ITEMS_NONE.
	"ICoreWebView2Settings8: isReputationCheckingRequired (SmartScreen)"
	self assert: settings isReputationCheckingRequired.
	self assert: baseSettings isReputationCheckingRequired.
	(settings isKindOf: ICoreWebView2Settings8)
		ifTrue: 
			[settings isReputationCheckingRequired: false.
			self deny: settings isReputationCheckingRequired.
			self assert: baseSettings isReputationCheckingRequired].
	"ICoreWebView2Settings9: IsNonClientRegionSupportEnabled"
	(settings isKindOf: ICoreWebView2Settings9)
		ifTrue: 
			[settings isNonClientRegionSupportEnabled: true.
			self assert: settings isNonClientRegionSupportEnabled.
			self deny: baseSettings isNonClientRegionSupportEnabled]!

viewClass
	^UI.WebView2View!

waitAtMost: aDuration while: aNiladicValuable
	| start |
	aNiladicValuable value ifFalse: [^true].
	start := DateAndTime now.
	SessionManager inputState
		loopWhile: [aNiladicValuable value and: [DateAndTime now - start < aDuration]].
	"Transcript
		nextPutAll: 'Waited ';
		display: DateAndTime now - start;
		nextPutAll: ' for ';
		print: aNiladicValuable;
		cr."
	^aNiladicValuable value not!

waitForNavigationCompleted
	^self waitAtMost: 20 seconds while: [navigationCompleted isNil]! !

!WebView2.Tests.WebView2ViewTest categoriesForMethods!
classToTest!constants!private! !
initializePresenter!public!Running! !
onBrowserProcessExited:!event handling!private! !
onDomContentLoaded:!event handling!private! !
onNavigationCompleted:!event handling!private! !
onNavigationStarting:!event handling!private! !
onProcessFailed:!event handling!private! !
onWebViewAvailable!event handling!private! !
tearDown!public!Running! !
testContextMenu!public!unit tests! !
testNavigateToString!public!unit tests! !
testProperties!public!unit tests! !
testWebBrowserCrashRecovery!public!unit tests! !
verifyWebViewControllerProperties!helpers!private! !
verifyWebViewEnvironmentProperties!helpers!private! !
verifyWebViewProfile!helpers!private! !
verifyWebViewProperties!helpers!private! !
verifyWebViewSettings!helpers!private! !
viewClass!constants!private! !
waitAtMost:while:!helpers!private! !
waitForNavigationCompleted!helpers!private! !
!

!WebView2.Tests.WebView2ViewTest class methodsFor!

resource_URLPresenter_WebView2_13
	"Answer the literal data from which the 'WebView2' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_URLPresenter_WebView2_13)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.WebView2View} 34 21 nil nil 34 2 8 1140916224 1 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 7 nil nil nil 416 nil nil 1049094 #{UI.NullConverter} nil nil 262145 nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 674 1179 289 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 76 14 0 0 154 0 0 0] 8 #() 674 193 193 nil 27)!

resource_URLPresenter_WebView2_D7
	"Answer the literal data from which the 'WebView2' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_WebView2)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.WebView2View) 34 21 nil nil 34 2 8 1140916224 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 7 nil nil nil 416 nil nil 852486 ##(Smalltalk.NullConverter) nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 12287 21 690 1179 289 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 76 26 0 0 154 0 0 0] 8 #() 690 193 193 nil 27 )! !

!WebView2.Tests.WebView2ViewTest class categoriesForMethods!
resource_URLPresenter_WebView2_13!public!resources-views! !
resource_URLPresenter_WebView2_D7!public!resources-views! !
!

