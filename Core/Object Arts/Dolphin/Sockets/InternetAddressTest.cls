"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #InternetAddressTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InternetAddressTest guid: (GUID fromString: '{3D606958-5C0E-4788-A978-70BF30CF372D}')!
InternetAddressTest comment: ''!
!InternetAddressTest categoriesForClass!Unclassified! !
!InternetAddressTest methodsFor!

testAllForHost
	| addresses oacom |
	self isOnline ifFalse: [^self].

	"Microsoft should have more than one IP associated with microsoft.com"
	addresses := InternetAddress allForHost: 'microsoft.com'.
	self assert: addresses size > 1.
	self assert: (addresses anySatisfy: [:each | each ipAddress beginsWith: #[191 239]]).

	"OA central"
	addresses := InternetAddress allForHost: 'object-arts.com'.
	self assert: addresses size = 1.
	OSVERSIONINFO current isWin9X ifTrue: [self assert: addresses first host = 'object-arts.com'] ifFalse: [self assert: (addresses first host endsWith: 'cable.virginm.net')]!

testHost
	| name ip |
	self isOnline ifFalse: [^self].
	name := InternetAddress host: 'uk2.net'.
	ip := InternetAddress ipAddress: name ipAddress.
	self assert: ip host = name host!

testIsIPString
	self deny: (InternetAddress isIPString: '').
	self deny: (InternetAddress isIPString: '.').
	self deny: (InternetAddress isIPString: 'a').
	self deny: (InternetAddress isIPString: 'a.').
	self deny: (InternetAddress isIPString: 'invalid').
	self deny: (InternetAddress isIPString: 'www.foo.org').
	self deny: (InternetAddress isIPString: 'www.foo.org.').
	self deny: (InternetAddress isIPString: 'www.foo.or1.').
	self deny: (InternetAddress isIPString: '1foo.or1.').
	self deny: (InternetAddress isIPString: '1.2.3.-').
	self assert: (InternetAddress isIPString: 'invalid.invalid.invalid.4invalid').
	self assert: (InternetAddress isIPString: '1.2.3.4')
!

testLocalHost
	| local computerName |
	computerName := SessionManager current computerName asLowercase.
	local := InternetAddress localHost.
	self assert: local host asUppercase = computerName asUppercase.
	self assert: (((InternetAddress ipAddress: local ipAddress) host subStrings: $.) first 
				sameAs: computerName)! !
!InternetAddressTest categoriesFor: #testAllForHost!public!unit tests! !
!InternetAddressTest categoriesFor: #testHost!public!unit tests! !
!InternetAddressTest categoriesFor: #testIsIPString!public!unit tests! !
!InternetAddressTest categoriesFor: #testLocalHost!public!unit tests! !

