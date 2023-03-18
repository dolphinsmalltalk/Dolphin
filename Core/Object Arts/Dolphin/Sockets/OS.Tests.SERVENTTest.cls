"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.SERVENTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.SERVENTTest guid: (Core.GUID fromString: '{9d6b8651-1dc9-4274-97cc-44e053e36b8a}')!
OS.Tests.SERVENTTest comment: ''!
!OS.Tests.SERVENTTest methodsFor!

testFromInteger
	| http |
	http := SERVENT fromInteger: 80.
	self assert: http s_name equals: 'http'!

testFromIntegerInvalid
	self
		should: [SERVENT fromInteger: SmallInteger maximum]
		raise: Net.SocketError
		matching: [:ex | ex statusCode = WinSocketErrors.WSANO_DATA]!

testFromString
	| http |
	http := SERVENT fromString: 'http'.
	self assert: http s_name equals: 'http'!

testFromStringInvalid
	self
		should: [SERVENT fromString: GUID newUnique asString]
		raise: Net.SocketError
		matching: [:ex | ex statusCode = WinSocketErrors.WSANO_DATA]! !
!OS.Tests.SERVENTTest categoriesForMethods!
testFromInteger!public! !
testFromIntegerInvalid!public! !
testFromString!public! !
testFromStringInvalid!public! !
!

