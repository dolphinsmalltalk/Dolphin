"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.FILETIMETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.FILETIMETest guid: (Core.GUID fromString: '{60160261-ed86-485b-834c-ef305dad3be9}')!
OS.Tests.FILETIMETest comment: ''!
!OS.Tests.FILETIMETest categoriesForClass!Unclassified! !
!OS.Tests.FILETIMETest methodsFor!

assertFromIntegerInvertible: anInteger
	self assert: (FILETIME fromInteger: anInteger) asInteger equals: (anInteger bitAnd: 2 ** 64 - 1)!

testFromInteger
	self assertFromIntegerInvertible: 126661379535479952.
	self assertFromIntegerInvertible: 0.
	self assertFromIntegerInvertible: SmallInteger maximum.
	self assertFromIntegerInvertible: 2 ** 32 - 1.
	self assertFromIntegerInvertible: 2 ** 32.
	self assertFromIntegerInvertible: 2 ** 32 + 1.
	self assertFromIntegerInvertible: 2 ** 64 - 1.
	self should: [FILETIME fromInteger: 2 ** 64] raise: Error.
	self assertFromIntegerInvertible: -1.
	self assertFromIntegerInvertible: -2 ** 31.
	self assertFromIntegerInvertible: -2 ** 32.
	self assertFromIntegerInvertible: -2 ** 63! !
!OS.Tests.FILETIMETest categoriesFor: #assertFromIntegerInvertible:!helpers!private! !
!OS.Tests.FILETIMETest categoriesFor: #testFromInteger!public!unit tests! !

