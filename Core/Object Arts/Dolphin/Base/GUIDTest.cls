"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #GUIDTest
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GUIDTest guid: (GUID fromString: '{e1371d2f-b622-4825-b412-b44260477b09}')!
GUIDTest comment: ''!
!GUIDTest categoriesForClass!Tests-Network-UUID! !
!GUIDTest methodsFor!

assertNull: guid 
	self assert: guid size = 16.
	self assert: guid = GUID null.
	self assert: guid isNull.
	self assert: guid asString size = 38.
	self assert: (guid asByteArray allSatisfy: [:each | each = 0])!

testComparison
	| guid1 guid2 |
	guid1 := GUID newUnique.
	guid2 := GUID newUnique.
	self assert: guid1 = guid1.
	self assert: guid2 = guid2.
	self deny: guid1 = guid2.
	self deny: guid1 hash = guid2 hash!

testFromString
	| guid string src |
	src := GUID newUnique.
	string := src asString.
	guid := GUID fromString: string.
	self assert: guid size = 16.
	self assert: guid asString size = 38.
	self assert: src = guid!

testFromStringNull
	self assertNull: (GUID fromString: GUID null asString)!

testNewUnique
	| uuid |
	uuid := GUID newUnique.
	self assert: uuid size = 16.
	self deny: uuid isNull.
	self assert: uuid asString size = 38!

testNull
	self assertNull: GUID null!

testOrder
	100 timesRepeat: 
			[| guid1 guid2 |
			guid1 := GUID newUnique.
			guid2 := GUID newUnique.
			(guid1 asString last: 12) = (guid2 asString last: 12) 
				ifTrue: 
					[self assert: guid1 asInteger < guid2 asInteger.
					self assert: guid2 asInteger > guid1 asInteger.
					self deny: guid1 = guid2]]!

testUniqueness
	| generated size |
	size := 5000.
	generated := Set new: size.
	size timesRepeat: 
			[| guid |
			guid := GUID newUnique.
			self deny: (generated includes: guid).
			generated add: guid]! !
!GUIDTest categoriesFor: #assertNull:!private!testing! !
!GUIDTest categoriesFor: #testComparison!public!testing! !
!GUIDTest categoriesFor: #testFromString!public!testing! !
!GUIDTest categoriesFor: #testFromStringNull!public!testing! !
!GUIDTest categoriesFor: #testNewUnique!public!testing! !
!GUIDTest categoriesFor: #testNull!public!testing! !
!GUIDTest categoriesFor: #testOrder!public!testing! !
!GUIDTest categoriesFor: #testUniqueness!public!testing! !

