"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2EnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2EnvironmentTest guid: (Core.GUID fromString: '{ce513c7e-5901-4f0e-8441-c8e896b771ed}')!

WebView2.Tests.ICoreWebView2EnvironmentTest comment: ''!

!WebView2.Tests.ICoreWebView2EnvironmentTest methodsFor!

testBrowserVersionString
	| browserVersion parts |
	browserVersion := webviewEnvironment browserVersionString.
	parts := ($. split: browserVersion) collect: [:each | Integer fromString: each].
	self assert: parts size equals: 4!

testCreateWebResourceResponse
	| subject content stream headers |
	content := 'Foo🐬bar'.
	stream := content readStream.
	subject := webviewEnvironment
				createWebResourceResponse: stream
				statusCode: 200
				reasonPhrase: 'Foobar'
				headers: 'OK<n>Content-Type: application/json' expandMacros.
	self assert: (subject content isSameCOMObject: (stream queryInterface: IUnknown)).
	self assert: subject statusCode equals: 200.
	self assert: subject reasonPhrase equals: 'Foobar'.
	subject reasonPhrase: 'Barfoo'.
	self assert: subject reasonPhrase equals: 'Barfoo'.
	self assert: (Utf8String fromByteArray: subject content upToEnd) equals: content.
	headers := subject headers.
	self assert: headers size equals: 1.
	self assert: headers associations equals: { 'Content-Type' -> 'application/json' }.
	headers at: 'Foo' put: 'Bar'.
	self assert: headers size equals: 2.
	self assert: headers associations equals: { 'Content-Type' -> 'application/json'. 'Foo' -> 'Bar' }! !

!WebView2.Tests.ICoreWebView2EnvironmentTest categoriesForMethods!
testBrowserVersionString!public! !
testCreateWebResourceResponse!public! !
!

