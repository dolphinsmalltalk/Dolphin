"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'WebView2.Tests.WebViewEnvironmentTest'
	instanceVariableNames: 'webviewEnvironment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.WebViewEnvironmentTest guid: (Core.GUID fromString: '{eb6b052d-fa47-4af8-8d50-e8cfa41dfd42}')!

WebView2.Tests.WebViewEnvironmentTest isNonInstantiable: true!

WebView2.Tests.WebViewEnvironmentTest comment: ''!

!WebView2.Tests.WebViewEnvironmentTest methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment!

setUp
	| completed latestEnv |
	super setUp.
	completed := (WebView2CompletionHandler
				completionBlock: [:hr :env | hr < 0 ifFalse: [webviewEnvironment := env downCast]])
					queryInterface: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler.
	WebView2Loader default createCoreWebView2Environment: completed.
	self waitForEnvironmentCreated.
	completed free.
	latestEnv := webviewEnvironment.
	webviewEnvironment := webviewEnvironment queryInterface: self minimumEnvironmentVersion
				ifNone: [self skip].
	latestEnv free!

tearDown
	webviewEnvironment free.
	webviewEnvironment :=  nil.
	super tearDown!

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

waitForEnvironmentCreated
	^self waitAtMost: 1 seconds while: [webviewEnvironment isNil]! !

!WebView2.Tests.WebViewEnvironmentTest categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
setUp!public! !
tearDown!public! !
waitAtMost:while:!helpers!private! !
waitForEnvironmentCreated!helpers!private! !
!

