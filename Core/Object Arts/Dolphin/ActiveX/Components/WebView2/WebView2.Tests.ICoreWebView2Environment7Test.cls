"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment7Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment7Test guid: (Core.GUID fromString: '{8c8d4929-e1a6-4c4a-b167-8c32397d0820}')!

WebView2.Tests.ICoreWebView2Environment7Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment7Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment7!

testUserDataFolder
	"ICoreWebView2Environment7: userDataFolder."

	| userdata |
	userdata := webviewEnvironment userDataFolder.
	self assertNotNil: userdata.
	self assert: (File isDirectory: userdata)! !

!WebView2.Tests.ICoreWebView2Environment7Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testUserDataFolder!public! !
!

