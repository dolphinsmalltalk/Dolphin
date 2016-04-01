"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #IntegerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IntegerTest guid: (GUID fromString: '{025B6E24-5E2B-49B1-9F4B-55B831A5AEF3}')!
IntegerTest comment: ''!
!IntegerTest categoriesForClass!Unclassified! !
!IntegerTest methodsFor!

canonicalInstance
	^self subclassResponsibility!

testClassReadFromRadix
	| stream |
	0 to: 35
		do: 
			[:i | 
			self 
				assert: (Integer readFrom: (Character digitValue: i) asString readStream radix: 36) = i].
	2 to: 36 do: [:i | self assert: (Integer readFrom: '10' readStream radix: i) = i].
	"Not an error if digit out of range of radix, just terminates the integer"
	stream := '20' readStream.
	self assert: (Integer readFrom:  stream radix: 2) = 0.
	self assert: stream position = 0.
	stream := '12' readStream.
	self assert: (Integer readFrom: stream radix: 2) = 1.
	self assert: stream position = 1.!

testFactorial
	#(0 1 2 3 4 5 6 7 8 9 10 11 97 100 101 1000 1001) do: 
			[:each | 
			| factorial |
			factorial := 1.
			2 to: each do: [:i | factorial := i * factorial].
			self assert: factorial = each factorial2p].
	self should: [-1 factorial] raise: Error!

testIndexedAccess
	"WARNING THIS TEST HANGS THE IMAGE when run for SmallInteger"

	| int |
	int := self canonicalInstance.
	self should: [int at: 1 put: 0] raise: Error.
	SessionManager current productVersion >= 6.0 
		ifTrue: 
			["These bugs only corrected in D6 and later"
			self should: [int size] raise: Error.
			self should: [int at: 1] raise: Error].
!

testIsInteger
	self assert: self canonicalInstance isInteger!

testIsPowerOfTwo
	| powersOfTwo nonPowersOfTwo |
	powersOfTwo := (0 to: 100) collect: [:each | 2 raisedTo: each].
	nonPowersOfTwo := (powersOfTwo collect: [:each | each negated])
				, #(0 3 -3 5 -5 6 -6 7 -7 9 -9 10 -10 100 -100 1000 -1000 12345678 -12345678 1234567890 -1234567890 12345678901234567890 -12345678901234567890).
	powersOfTwo do: [:each | self assert: each isPowerOfTwo].
	nonPowersOfTwo do: [:each | self deny: each isPowerOfTwo]!

testNew
	self should: [self canonicalInstance class new] raise: TestResult error!

testPrimesUpTo
	| primes |
	primes := Integer primesUpTo: 100.
	self assert: primes asArray 
				= #(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)!

testSetBit
	1 to: 128 do: [:i | self assert: (0 setBit: i) = (2 raisedToInteger: i - 1)].
	0 to: 128
		do: 
			[:twoPower | 
			| i |
			i := 2 raisedToInteger: twoPower.
			1 to: 128
				do: 
					[:j | 
					| expected |
					expected := 2 raisedToInteger: j - 1.
					j - 1 = twoPower ifFalse: [expected := expected + i].
					self assert: (i setBit: j) = expected]]!

testTwoComplementRightShift
	| large small |
	small := 2 << 16.
	large := 2 << 32.
	self should: 
			[(small negated bitShift: -1) ~= ((small + 1) negated bitShift: -1) 
				== ((large negated bitShift: -1) ~= ((large + 1) negated bitShift: -1))].
	self should: 
			[(small bitShift: -1) ~= (small + 1 bitShift: -1) 
				== ((large bitShift: -1) ~= (large + 1 bitShift: -1))]! !
!IntegerTest categoriesFor: #canonicalInstance!constants!private! !
!IntegerTest categoriesFor: #testClassReadFromRadix!public!unit tests! !
!IntegerTest categoriesFor: #testFactorial!public!unit tests! !
!IntegerTest categoriesFor: #testIndexedAccess!public!unit tests! !
!IntegerTest categoriesFor: #testIsInteger!public!unit tests! !
!IntegerTest categoriesFor: #testIsPowerOfTwo!public! !
!IntegerTest categoriesFor: #testNew!public!unit tests! !
!IntegerTest categoriesFor: #testPrimesUpTo!public!unit tests! !
!IntegerTest categoriesFor: #testSetBit!public!unit tests! !
!IntegerTest categoriesFor: #testTwoComplementRightShift!public!unit tests! !

!IntegerTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!IntegerTest class categoriesFor: #isAbstract!public!Testing! !

