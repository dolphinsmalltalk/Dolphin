"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment8Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment8Test guid: (Core.GUID fromString: '{d1e90eb5-20de-47c1-a81d-e638e46852fd}')!

WebView2.Tests.ICoreWebView2Environment8Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment8Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment8!

testProcessInfos
	| subject |
	subject := webviewEnvironment processInfos.
	self assert: subject isEmpty! !

!WebView2.Tests.ICoreWebView2Environment8Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testProcessInfos!public! !
!

