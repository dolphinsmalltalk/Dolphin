"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'WebView2.Tests.WebView2CustomSchemeRegistrationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.Tests.WebView2CustomSchemeRegistrationTest guid: (Core.GUID fromString: '{0a7ce017-d187-48bf-9d57-7bdb53a95f91}')!

WebView2.Tests.WebView2CustomSchemeRegistrationTest comment: ''!

!WebView2.Tests.WebView2CustomSchemeRegistrationTest methodsFor!

testAllowedOrigins
	| subject interface |
	subject := WebView2CustomSchemeRegistration newScheme: 'foo'.
	self assert: subject allowedOrigins equals: #().
	interface := subject queryInterface: ICoreWebView2CustomSchemeRegistration.
	self assert: interface allowedOrigins equals: #().
	#(#('https://www.object-arts.com') #('https://www.object-arts.com' 'https://www.github.com') #())
		do: 
			[:origins |
			interface allowedOrigins: origins.
			self assert: subject allowedOrigins equals: origins.
			self assert: interface allowedOrigins equals: origins]! !

!WebView2.Tests.WebView2CustomSchemeRegistrationTest categoriesForMethods!
testAllowedOrigins!public! !
!

