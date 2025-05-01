"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.SOCKADDRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.SOCKADDRTest guid: (Core.GUID fromString: '{e3541b46-6070-429b-bd37-d5f2a40b8cc5}')!

OS.Tests.SOCKADDRTest comment: ''!

!OS.Tests.SOCKADDRTest methodsFor!

ipAddressStrings
	^#('0.0.0.0' '192.168.1.6:80' '[fe80::a221:b7ff:fe70:6185%7]:443' '2a0a:ef40:37:2001:9556:eb11:425b:c50b' '2a0a:ef40:37:2001:bd4b:ab1:59da:784e')!

testDisplayOnInvalid
	| subject |
	subject := SOCKADDR fromString: '[fe80::a221:b7ff:fe70:6185%7]:443'.
	subject sin_family: 16rFFFF.
	self
		should: [subject displayString]
		raise: Net.SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL]!

testFromString
	self ipAddressStrings do: 
			[:each |
			| subject |
			subject := SOCKADDR fromString: each.
			self assert: subject displayString equals: each].
	self
		should: [SOCKADDR fromString: '192.168.1.0:']
		raise: Win32Error
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL]!

testSockAddrStorage
	self ipAddressStrings do: 
			[:each |
			| subject sockaddr |
			sockaddr := SOCKADDR fromString: each.
			subject := SOCKADDR_STORAGE fromAddress: sockaddr yourAddress.
			self assert: subject sin_addr equals: sockaddr sin_addr]! !

!OS.Tests.SOCKADDRTest categoriesForMethods!
ipAddressStrings!constants!private! !
testDisplayOnInvalid!public!unit tests! !
testFromString!public!unit tests! !
testSockAddrStorage!public!unit tests! !
!

