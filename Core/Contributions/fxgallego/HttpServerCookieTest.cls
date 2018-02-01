"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HttpServerCookieTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerCookieTest guid: (GUID fromString: '{7684239b-67a2-4aad-9654-a03faff8d3eb}')!
HttpServerCookieTest comment: ''!
!HttpServerCookieTest categoriesForClass!Unclassified! !
!HttpServerCookieTest methodsFor!

testNameValueAsString
	| cookie |
	
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	self assert: cookie asString = 'Dolphin=Smalltalk'
	!

testNameValueDomainAsString
	| cookie |
	
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	cookie domain: 'object-arts.com'.
	self assert: cookie asString = 'Dolphin=Smalltalk; Domain=object-arts.com'
	!

testNameValueDomainPathAsString
	| cookie |
	
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	cookie domain: 'object-arts.com'.
	cookie path: 'foo/bar'.
	self assert: cookie asString = 'Dolphin=Smalltalk; Domain=object-arts.com; Path=foo/bar'
	!

testNameValueExpiresAsString
	| cookie ts |
	ts := TimeStamp date: (Date fromString: '01/02/2018') time: (Time fromString: '15:00:00').
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	cookie expires: ts.
	self assert: cookie asString = 'Dolphin=Smalltalk; Expires=Thu, 01 Feb 2018 15:00:00 GMT'
	!

testNameValueMaxAgeAsString
	| cookie |
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	cookie maxAge: 60 * 60 .
	self assert: cookie asString = 'Dolphin=Smalltalk; Max-Age=3600'
	!

testNameValueSecureHttpOnlyAsString
	| cookie |
	cookie := HttpServerCookie name: 'Dolphin' value: 'Smalltalk'.
	cookie secure: true; httpOnly: true.
	self assert: cookie asString = 'Dolphin=Smalltalk; Secure; HttpOnly'
	! !
!HttpServerCookieTest categoriesFor: #testNameValueAsString!public! !
!HttpServerCookieTest categoriesFor: #testNameValueDomainAsString!public! !
!HttpServerCookieTest categoriesFor: #testNameValueDomainPathAsString!public! !
!HttpServerCookieTest categoriesFor: #testNameValueExpiresAsString!public! !
!HttpServerCookieTest categoriesFor: #testNameValueMaxAgeAsString!public! !
!HttpServerCookieTest categoriesFor: #testNameValueSecureHttpOnlyAsString!public! !

