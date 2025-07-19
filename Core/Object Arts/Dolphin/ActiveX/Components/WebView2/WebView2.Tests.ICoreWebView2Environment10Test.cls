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
	controllerOptions := (webviewEnvironment createCoreWebView2ControllerOptions) queryInterface: ICoreWebView2ControllerOptions.
	"In-private mode"
	self deny: controllerOptions isInPrivateModeEnabled.
	controllerOptions isInPrivateModeEnabled: true.
	self assert: controllerOptions isInPrivateModeEnabled.
	"Profile name"
	self assert: controllerOptions profileName equals: ''.
	controllerOptions profileName: 'Foo'.
	self assert: controllerOptions profileName equals: 'Foo'.
	"Script locale - not implemented at this version, so not settable"
	self assert: controllerOptions scriptLocale equals: Locale default name.
	controllerOptions scriptLocale: 'fr-FR'.
	self assert: controllerOptions scriptLocale equals: Locale default name.
	"Default background colour - not implemented at this version"
	self assert: controllerOptions defaultBackgroundColor equals: Graphics.Color window.
	controllerOptions defaultBackgroundColor: Graphics.Color gray.
	self assert: controllerOptions defaultBackgroundColor equals: Graphics.Color window.
	"AllowHostInputProcessing - not implemented at this version"
	self deny: controllerOptions allowHostInputProcessing.
	controllerOptions allowHostInputProcessing: true.
	self deny: controllerOptions allowHostInputProcessing
	
	! !

!WebView2.Tests.ICoreWebView2Environment10Test categoriesForMethods!
minimumEnvironmentVersion!constants!private! !
testControllerOptions!public! !
!

