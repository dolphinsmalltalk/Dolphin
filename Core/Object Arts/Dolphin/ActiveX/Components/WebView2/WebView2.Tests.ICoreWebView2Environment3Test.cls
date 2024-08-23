"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment3Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment3Test guid: (Core.GUID fromString: '{45fd7eb3-1806-4bdc-89e5-0861268e0058}')!

WebView2.Tests.ICoreWebView2Environment3Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment3Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment3!

testPointerInfo
	| subject value |
	subject := webviewEnvironment createPointerInfo.
	"the object has a lot of integer properties. We don't need to test that the wrappers for these are all created correctly, so just kick the tyres a bit."
	self assert: subject buttonChangeKind equals: 0.
	subject buttonChangeKind: 1.
	self assert: subject buttonChangeKind equals: 1.
	self assert: subject displayRect equals: (0 @ 0 extent: 0 @ 0).
	value := 100 @ 200 extent: 400 @ 300.
	subject displayRect: value.
	self assert: subject displayRect equals: value! !

!WebView2.Tests.ICoreWebView2Environment3Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testPointerInfo!public! !
!

