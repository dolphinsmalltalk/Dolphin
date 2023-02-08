"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #WebView2ViewTest
	instanceVariableNames: 'domContentLoaded navigationCompleted processFailed webViewReady webViewClosed'
	classVariableNames: ''
	poolDictionaries: ''
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
	"We need to wait until the web view is ready before we commence any testing"
	self assert: (self waitAtMost: 20 seconds while: [webViewReady not])!

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

testWebBrowserCrashRecovery
	"Test browser recovery after a crash of the browser process that causes it to exit"

	| webview |
	webview := presenter view.
	webview canNavigateToStrings: true.
	processFailed := navigationCompleted := domContentLoaded := nil.
	presenter model value: 'edge://inducebrowsercrashforrealz/'.
	self assert: self waitForNavigationCompleted.
	self assert: processFailed
		equals: WebView2Constants.COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED.
	"Unless suppressed by the #processFailed: handler, the webview will be recreated and navigated to the crashes page"
	self assert: navigationCompleted isKindOf: ICoreWebView2NavigationCompletedEventArgs2.
	self assert: navigationCompleted isSuccess.
	self assert: webview displayValue equals: 'edge://crashes/'.
	self assert: navigationCompleted navigationId equals: domContentLoaded!

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
testWebBrowserCrashRecovery!public!unit tests! !
waitAtMost:while:!helpers!private! !
waitForNavigationCompleted!helpers!private! !
!

