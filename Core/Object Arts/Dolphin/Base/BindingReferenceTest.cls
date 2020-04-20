"Filed out from Dolphin Smalltalk 7"!

GeneralBindingReferenceTest subclass: #BindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BindingReferenceTest guid: (GUID fromString: '{44a97a25-3e9f-43f4-b1aa-4cadf406ed5d}')!
BindingReferenceTest comment: ''!
!BindingReferenceTest categoriesForClass!Unclassified! !
!BindingReferenceTest methodsFor!

subjectClass
	^BindingReference!

testAsQualifiedReference
	self assert: 'Object' asQualifiedReference equals: #{Object}.
	self assert: 'Smalltalk.Object' asQualifiedReference equals: #{Object}.
	self assert: #{Object} asQualifiedReference identicalTo: #{Object}.
	self assert: 'Object._EventsRegister' asQualifiedReference equals: #{Object._EventsRegister}!

testEquals
	super testEquals.
	self assert: (self subjectClass path: #('Core'))
		equals: (self subjectClass pathString: 'Core' home: Smalltalk)!

testHash
	super testHash.
	self assert: (BindingReference path: #('Core' 'Object')) hash
		equals: (BindingReference path: #('Core' 'Object') home: Smalltalk) hash!

testHome
	| subject |
	subject := self subjectClass path: #('OpcodePool' 'Nop').
	self assert: subject home identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject home identicalTo: OpcodePool
!

testIsValidGlobalName
	#('A' 'A1' 'A_' '_A' 'a' '_a' '__A_B' 'A.B' 'Abc.D' '_Abc._d' 'abc.d')
		do: [:each | self assert: (BindingReference isValidQualifiedName: each)].
	#('_' '_.' 'A.' '.A' '_A.' '_.A' '.' 'a.' '_.a' '*' '' 'A.*' '*.' 'A..B')
		do: [:each | self deny: (BindingReference isValidQualifiedName: each)]!

testPathString
	| subject |
	super testPathString.
	#('*' 'Smalltalk.Core.*')
		do: [:each | self should: [self subjectClass pathString: each] raise: Error].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #().
	self deny: subject isWildcard! !
!BindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!BindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!BindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!BindingReferenceTest categoriesFor: #testHash!public!unit tests! !
!BindingReferenceTest categoriesFor: #testHome!public!unit tests! !
!BindingReferenceTest categoriesFor: #testIsValidGlobalName!public!unit tests! !
!BindingReferenceTest categoriesFor: #testPathString!public!unit tests! !

