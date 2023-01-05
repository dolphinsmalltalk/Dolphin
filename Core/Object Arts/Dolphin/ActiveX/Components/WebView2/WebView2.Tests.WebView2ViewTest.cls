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
waitForNavigationCompleted!helpers!private! !
!

