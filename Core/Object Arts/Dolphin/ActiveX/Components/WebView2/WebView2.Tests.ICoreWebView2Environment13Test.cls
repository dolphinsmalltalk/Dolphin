"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment13Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment13Test guid: (Core.GUID fromString: '{d1e90eb5-20de-47c1-a81d-e638e46852fd}')!

WebView2.Tests.ICoreWebView2Environment13Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment13Test methodsFor!

minimumEnvironmentVersion
	"From 1.0.2210.55"

	^ICoreWebView2Environment13!

testProcessExtendedInfos
	self
		should: 
			[webviewEnvironment getProcessExtendedInfosThenDo: [:hr :infos | self fail: 'Completed unexpectedly']]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_NOT_READY]! !

!WebView2.Tests.ICoreWebView2Environment13Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testProcessExtendedInfos!public! !
!

