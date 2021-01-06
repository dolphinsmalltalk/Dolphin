"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.SOCKADDRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.SOCKADDRTest guid: (Core.GUID fromString: '{e3541b46-6070-429b-bd37-d5f2a40b8cc5}')!
OS.Tests.SOCKADDRTest comment: ''!
!OS.Tests.SOCKADDRTest categoriesForClass!Unclassified! !
!OS.Tests.SOCKADDRTest methodsFor!

testDisplayOnInvalid
	| subject |
	subject := SOCKADDR fromString: '[fe80::a221:b7ff:fe70:6185%7]:443'.
	subject sin6_family: 16rFFFF.
	self
		should: [subject displayString]
		raise: Net.SocketError
		matching: [:ex | ex errorCode = WinSocketErrors.WSAEINVAL]!

testFromString
	#('192.168.1.6:80' '[fe80::a221:b7ff:fe70:6185%7]:443') do: 
			[:each |
			| subject |
			subject := SOCKADDR fromString: each.
			self assert: subject displayString equals: each]! !
!OS.Tests.SOCKADDRTest categoriesFor: #testDisplayOnInvalid!public!unit tests! !
!OS.Tests.SOCKADDRTest categoriesFor: #testFromString!public!unit tests! !

