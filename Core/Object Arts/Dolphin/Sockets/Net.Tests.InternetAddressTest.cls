﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Net.Tests.InternetAddressTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Net.Tests.InternetAddressTest guid: (Core.GUID fromString: '{3d606958-5c0e-4788-a978-70bf30cf372d}')!

Net.Tests.InternetAddressTest comment: ''!

!Net.Tests.InternetAddressTest methodsFor!

testAllForHost
	<skipUnless: #isOnline>
	| addresses |

	"dns.google has two fixed and well-known IP addresses"
	addresses := InternetAddress allForHost: 'dns.google.com'.
	self assert: addresses size equals: 2.
	self assert: (addresses collect: [:each | each ipAddress]) asSet
		equals: #(#[8 8 4 4] #[8 8 8 8]) asSet.

	"google.com has only one"
	addresses := InternetAddress allForHost: 'google.com'.
	self assert: (addresses anySatisfy: [:each | each host endsWith: '1e100.net'])!

testHost
	<skipUnless: #isOnline>
	| ip |
	ip := InternetAddress ipAddress: #[9 9 9 9].
	self assert: ip host equals: 'dns9.quad9.net'!

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
	<skipIf: #isCiBuild>
	| local computerName |
	computerName := SessionManager current computerName asLowercase.
	local := InternetAddress localHost.
	self assert: local host asLowercase equals: computerName.
	self assert: ((InternetAddress ipAddress: local ipAddress) host subStrings: $.) first asLowercase
		equals: computerName! !

!Net.Tests.InternetAddressTest categoriesForMethods!
testAllForHost!public!unit tests! !
testHost!public!unit tests! !
testIsIPString!public!unit tests! !
testLocalHost!public!unit tests! !
!

