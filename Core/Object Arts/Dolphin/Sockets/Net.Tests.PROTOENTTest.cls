"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Net.Tests.PROTOENTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Tests.PROTOENTTest guid: (Core.GUID fromString: '{c8be89d3-f8f9-45e9-ac08-5f54f8b82f3a}')!
Net.Tests.PROTOENTTest comment: ''!
!Net.Tests.PROTOENTTest categoriesForClass!Unclassified! !
!Net.Tests.PROTOENTTest methodsFor!

testFromInteger
	| tcp |
	tcp := OS.PROTOENT fromInteger: 6.
	self assert: tcp p_name equals: 'tcp'!

testFromIntegerInvalid
	self
		should: [OS.PROTOENT fromInteger: SmallInteger maximum]
		raise: SocketError
		matching: [:ex | ex statusCode = WinSocketErrors.WSANO_DATA]!

testFromString
	| tcp |
	tcp := OS.PROTOENT fromString: 'tcp'.
	self assert: tcp p_name equals: 'tcp'.
	self assert: tcp p_proto equals: 6.
	self assert: (tcp aliases includes: 'TCP')!

testFromStringInvalid
	self
		should: [OS.PROTOENT fromString: GUID newUnique asString]
		raise: SocketError
		matching: [:ex | ex statusCode = WinSocketErrors.WSANO_DATA]! !
!Net.Tests.PROTOENTTest categoriesFor: #testFromInteger!public! !
!Net.Tests.PROTOENTTest categoriesFor: #testFromIntegerInvalid!public! !
!Net.Tests.PROTOENTTest categoriesFor: #testFromString!public! !
!Net.Tests.PROTOENTTest categoriesFor: #testFromStringInvalid!public! !

