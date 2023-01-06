"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'WebView2.Tests.WebView2ViewTest'
	instanceVariableNames: 'domContentLoaded navigationCompleted processFailed webViewReady'
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
	| start |
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
			to: self.
	webViewReady := false.
	presenter createView: URLPresenter defaultView.
	"We need to wait until the web view is ready before we commence any testing"
	start := DateAndTime now.
	SessionManager inputState loopWhile: [webViewReady not and: [DateAndTime now - start < 10 seconds]].
	self assert: webViewReady!

onDomContentLoaded: anICoreWebView2DOMContentLoadedEventArgs
	domContentLoaded := anICoreWebView2DOMContentLoadedEventArgs!

onNavigationCompleted: anICoreWebView2NavigationCompletedEventArgs2
	navigationCompleted := anICoreWebView2NavigationCompletedEventArgs2!

onProcessFailed: anICoreWebView2ProcessFailedEventArgs2 
	processFailed := anICoreWebView2ProcessFailedEventArgs2
!

onWebViewAvailable
	webViewReady := true!

testBrowserCrashRecovery
	"Test browser recovery after a crash of the browser process that causes it to exit"

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	processFailed := navigationCompleted := domContentLoaded := nil.
	presenter model value: 'edge://inducebrowsercrashforrealz/'.
	self waitForNavigationCompleted.
	self assert: processFailed isKindOf: ICoreWebView2ProcessFailedEventArgs2.
	self assert: processFailed isBrowserProcessExit.
	"Unless suppressed by the #processFailed: handler, the webview will be recreated and navigated to the crashes page"
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'edge://crashes/'.
	self assert: navigationCompleted navigationId equals: domContentLoaded navigationId!

testNavigateToString
	"Bit of a kick-the-tyres test, but it does execute a lot of the integration, e.g. creating the WebView2 environment, controller and view, and setting up event handlers and handling of events."

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	navigationCompleted := domContentLoaded := nil.
	presenter model value: '<html><title>Greetings</title><body>Hello World!!</body></html>'.
	self waitForNavigationCompleted.
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'about:blank'.
	self assert: webview documentTitle equals: 'Greetings'.
	self assert: navigationCompleted navigationId equals: domContentLoaded navigationId!

testPropertyDefaults
	"To simplify use of the large number of interface versions for IWebView2View, we provide default values for all the properties defined in the later interfaces for the earlier versions."

	| webview baseInterface |
	webview := presenter view webview.
	baseInterface := webview queryInterface: ICoreWebView2.
	"ICoreWebView2_2: cookieManager, environment"
	self assert: webview cookieManager isKindOf: ICoreWebView2CookieManager.
	self assertIsNil: baseInterface cookieManager.
	self assert: webview environment isKindOf: ICoreWebView2Environment.
	self assertIsNil: baseInterface environment.
	"ICoreWebView2_3: isSuspended"
	self deny: baseInterface isSuspended.
	"ICoreWebView2_4 - no new properties"
	"ICoreWebView2_5 - no new properties"
	"ICoreWebView2_6 - no new properties"
	"ICoreWebView2_7 - no new properties"
	"ICoreWebView2_8: isDocumentPlayingAudio, isMuted"
	self deny: baseInterface isDocumentPlayingAudio.
	self deny: baseInterface isMuted.
	baseInterface isMuted: true.
	self deny: baseInterface isMuted.
	webview isMuted: true.
	self assert: webview isMuted.
	self deny: baseInterface isMuted.
	"ICoreWebView2_9: defaultDownloadDialogCornerAlignment, defaultDownloadDialogMargin, isDefaultDownloadDialogOpen"
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 0.
	baseInterface defaultDownloadDialogCornerAlignment: 5.
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 0.
	webview defaultDownloadDialogCornerAlignment: 5.
	self assert: webview defaultDownloadDialogCornerAlignment equals: 5.
	self assert: baseInterface defaultDownloadDialogCornerAlignment equals: 0.
	self assert: baseInterface defaultDownloadDialogMargin equals: 0.
	baseInterface defaultDownloadDialogMargin: 5.
	self assert: baseInterface defaultDownloadDialogMargin equals: 0.
	webview defaultDownloadDialogMargin: 15 @ 25.
	self assert: webview defaultDownloadDialogMargin equals: 15 @ 25.
	self assert: baseInterface defaultDownloadDialogMargin equals: 0.
	self deny: baseInterface isDefaultDownloadDialogOpen.
	"ICoreWebView2_10 - no new properties"
	"ICoreWebView2_11 - no new properties"
	"ICoreWebView2_12: statusBarText"
	self assertIsNil: baseInterface statusBarText.
	self assert: webview statusBarText equals: ''.
	"ICoreWebView2_13: profile"
	self assert: webview profile isKindOf: ICoreWebView2Profile.
	self assertIsNil: baseInterface profile.
	"ICoreWebView2_14 - no new properties"
	"ICoreWebView2_15: faviconUri"
	self assertIsNil: baseInterface faviconUri.
	self assert: webview faviconUri equals: ''!

waitForNavigationCompleted
	| start |
	start := DateAndTime now.
	SessionManager inputState
		loopWhile: [navigationCompleted isNil and: [DateAndTime now - start < 2 minutes]]! !
!WebView2.Tests.WebView2ViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
onDomContentLoaded:!event handling!private! !
onNavigationCompleted:!event handling!private! !
onProcessFailed:!event handling!private! !
onWebViewAvailable!event handling!private! !
testBrowserCrashRecovery!public!unit tests! !
testNavigateToString!public!unit tests! !
testPropertyDefaults!public!unit tests! !
waitForNavigationCompleted!helpers!private! !
!

