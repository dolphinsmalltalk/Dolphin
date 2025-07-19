"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment2Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment2Test guid: (Core.GUID fromString: '{f46dc46c-2cdd-49ec-9a1d-173836eb8ccd}')!

WebView2.Tests.ICoreWebView2Environment2Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment2Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment2!

testCreateWebResourceRequest
	| subject headers testUri |
	testUri := 'https://github.com/dolphinsmalltalk/Dolphin/blob/master/Boot.st'.
	subject := webviewEnvironment
				createWebResourceRequest: testUri
				method: 'GET'
				postData: nil
				headers: 'Foo: Bar'.
	self assert: subject uri equals: testUri.
	self assert: subject method equals: 'GET'.
	self assertIsNil: subject content.
	headers := subject headers.
	self assert: headers size equals: 1.
	self assert: headers associations equals: { 'Foo' -> 'Bar' }.
	self assert: subject printString
		equals: 'a WebView2.ICoreWebView2WebResourceRequest(<1s>: method: ''GET'', uri: ''https://github.com/dolphinsmalltalk/Dolphin/blob/master/Boot.st'', headers: a WebView2.ICoreWebView2HttpRequestHeaders(<2s>: Foo))'
				<< { subject yourAddress printStringBase: 16. subject headers yourAddress printStringBase: 16 }! !

!WebView2.Tests.ICoreWebView2Environment2Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testCreateWebResourceRequest!public! !
!

