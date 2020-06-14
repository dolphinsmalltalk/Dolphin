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
	self assert: guid size equals: 16.
	self assert: guid equals: GUID null.
	self assert: guid isNull.
	self assert: guid asString size equals: 38.
	self assert: (guid asByteArray allSatisfy: [:each | each = 0])!

testAsByteArray
	| subject bytes parts |
	subject := GUID newUnique.
	bytes := subject asByteArray.
	parts := $- split: subject idlString.
	"See https://docs.microsoft.com/en-us/windows/win32/api/guiddef/ns-guiddef-guid"
	self assert: ((bytes dwordAtOffset: 0) printStringBase: 16 nDigits: 8) asLowercase equals: parts first.
	self assert: ((bytes wordAtOffset: 4) printStringBase: 16 nDigits: 4) asLowercase equals: parts second.
	self assert: ((bytes wordAtOffset: 6) printStringBase: 16 nDigits: 4) asLowercase equals: parts third.
	self assert: (bytes copyFrom: 9 to: 10) hex equals: parts fourth.
	self assert: (bytes copyFrom: 11 to: 16) hex equals: parts fifth.
	self assert: (GUID fromBytes: bytes) equals: subject.
	self assert: GUID null asByteArray equals: #[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]!

testAsInteger
	| guids status |
	self assert: GUID null asInteger equals: 0.
	guids := (1 to: 3) collect: [:i | GUID newUnique].
	status := DWORDBytes new.
	guids do: 
			[:subject |
			| int cmp |
			int := subject asInteger.
			self assert: int positive.
			cmp := RPCLibrary default
						uuidCompare: int basicYourAddress
						uuid2: subject
						status: status.
			self assert: status value equals: 0.
			self assert: cmp equals: 0]!

testComparison
	| guid1 guid2 |
	guid1 := GUID newUnique.
	guid2 := GUID newUnique.
	self assert: guid1 equals: guid1.
	self assert: guid2 equals: guid2.
	self deny: guid1 equals: guid2.
	self deny: guid1 hash equals: guid2 hash!

testFromString
	| guid string src |
	src := GUID newUnique.
	string := src asString.
	guid := GUID fromString: string.
	self assert: guid size equals: 16.
	self assert: guid asString size equals: 38.
	self assert: src equals: guid!

testFromStringNull
	self assertNull: (GUID fromString: GUID null asString)!

testNewUnique
	| uuid |
	uuid := GUID newUnique.
	self assert: uuid size equals: 16.
	self deny: uuid isNull.
	self assert: uuid asString size equals: 38!

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
					self deny: guid1 equals: guid2]]!

testStoreOn
	| subject stored collection |
	subject := GUID newUnique.
	collection := OrderedCollection with: subject.
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection.
	self assert: (Compiler evaluate: GUID null storeString) equals: GUID null!

testUniqueness
	| generated size |
	size := 1000.
	generated := Set new: size.
	size timesRepeat: [generated add: GUID newUnique].
	self assert: generated size equals: size! !
!GUIDTest categoriesFor: #assertNull:!private!testing! !
!GUIDTest categoriesFor: #testAsByteArray!public!testing! !
!GUIDTest categoriesFor: #testAsInteger!public!testing! !
!GUIDTest categoriesFor: #testComparison!public!testing! !
!GUIDTest categoriesFor: #testFromString!public!testing! !
!GUIDTest categoriesFor: #testFromStringNull!public!testing! !
!GUIDTest categoriesFor: #testNewUnique!public!testing! !
!GUIDTest categoriesFor: #testNull!public!testing! !
!GUIDTest categoriesFor: #testOrder!public!testing! !
!GUIDTest categoriesFor: #testStoreOn!public!testing / printing! !
!GUIDTest categoriesFor: #testUniqueness!public!testing! !

