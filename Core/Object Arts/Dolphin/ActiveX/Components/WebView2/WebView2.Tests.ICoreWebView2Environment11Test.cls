"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment11Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment11Test guid: (Core.GUID fromString: '{ce513c7e-5901-4f0e-8441-c8e896b771ed}')!

WebView2.Tests.ICoreWebView2Environment11Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment11Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment11!

testFailureReportFolderPath
	| path |
	path := webviewEnvironment failureReportFolderPath.
	self assert: (path endsWith: 'Crashpad\reports')! !

!WebView2.Tests.ICoreWebView2Environment11Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testFailureReportFolderPath!public! !
!

