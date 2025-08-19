"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment15Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment15Test guid: (Core.GUID fromString: '{86ca655b-b34c-47a7-b363-a52b67bc2b55}')!

WebView2.Tests.ICoreWebView2Environment15Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment15Test methodsFor!

minimumEnvironmentVersion
	"From 1.0.3405.78"

	^ICoreWebView2Environment15!

testFindOptions
	| findOptions |
	findOptions := webviewEnvironment createFindOptions.
	"Defaults"
	self deny: findOptions isCaseSensitive.
	self deny: findOptions shouldMatchWord.
	self assert: findOptions shouldHighlightAllMatches.
	self deny: findOptions suppressDefaultFindDialog.
	self assert: findOptions findTerm isEmpty.
	"Updating"
	findOptions isCaseSensitive: true.
	self assert: findOptions isCaseSensitive.
	findOptions shouldMatchWord: true.
	self assert: findOptions shouldMatchWord.
	findOptions shouldHighlightAllMatches: false.
	self deny: findOptions shouldHighlightAllMatches.
	findOptions suppressDefaultFindDialog: true.
	self assert: findOptions suppressDefaultFindDialog.
	findOptions findTerm: 'Foo'.
	self assert: findOptions findTerm equals: 'Foo'.
	findOptions free


! !

!WebView2.Tests.ICoreWebView2Environment15Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testFindOptions!public!unit tests! !
!

