"Filed out from Dolphin Smalltalk"!

WebView2.Tests.WebViewEnvironmentTest
	subclass: #'WebView2.Tests.ICoreWebView2Environment10Test'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.ICoreWebView2Environment10Test guid: (Core.GUID fromString: '{6bbbfdb7-a679-47d0-8a52-3253d0306632}')!

WebView2.Tests.ICoreWebView2Environment10Test comment: ''!

!WebView2.Tests.ICoreWebView2Environment10Test methodsFor!

minimumEnvironmentVersion
	^ICoreWebView2Environment10!

testControllerOptions
	| controllerOptions |
	controllerOptions := webviewEnvironment createCoreWebView2ControllerOptions.
	"In-private mode"
	self deny: controllerOptions isInPrivateModeEnabled.
	controllerOptions isInPrivateModeEnabled: true.
	self assert: controllerOptions isInPrivateModeEnabled.
	"Profile name"
	self assert: controllerOptions profileName equals: ''.
	controllerOptions profileName: 'Foo'.
	self assert: controllerOptions profileName equals: 'Foo'.
	"Script local"
	self assert: controllerOptions scriptLocale equals: ''.
	controllerOptions scriptLocale: 'en-GB'.
	self assert: controllerOptions scriptLocale equals: 'en-GB'! !

!WebView2.Tests.ICoreWebView2Environment10Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testControllerOptions!public! !
!

