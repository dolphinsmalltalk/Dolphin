"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #GeneralBindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GeneralBindingReferenceTest guid: (GUID fromString: '{bc0780da-05e7-464d-af4f-48755f8f8d52}')!
GeneralBindingReferenceTest isAbstract: true!
GeneralBindingReferenceTest comment: ''!
!GeneralBindingReferenceTest categoriesForClass!Unclassified! !
!GeneralBindingReferenceTest methodsFor!

bindingTestCases
	"May ccontains some examples that currently do not resolve as there are no namespaces."

	| missingNamespace |
	missingNamespace := '_' , GUID newUnique idlString copyReplacing: $- withObject: $_.
	^{#(#(#Object)).
		{#(#Smalltalk #Object). #(#Object)}.
		#(#(#OpcodePool #Nop)).
		#(#(#Smalltalk #OpcodePool #Nop) #(#OpcodePool #Nop)).
		{{missingNamespace. '__MissingClass'}. nil}.
		{{missingNamespace. 'Date'}. nil}.
		{#(#Smalltalk #Object #_EventsRegister). #(#Object #_EventsRegister)}.
}!

newTestSubjectWithPath: anArrayOfStrings
	^self subjectClass path: anArrayOfStrings!

newTestSubjectWithPathString: a
	^self subjectClass pathString: a!

printStringTestCases
	^#(#(#(#Object) '#{Object}') #(#(#OpcodePool #Nop) '#{OpcodePool.Nop}') #(#('A' 'B' 'C') '#{A.B.C}'))!

subjectClass
	^self subclassResponsibility!

testAsString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject asString equals: (each last copyFrom: 3 to: each last size - 1)]!

testAsSymbol
	self assert: (self newTestSubjectWithPath: #('Object')) asSymbol identicalTo: #Object.
	self assert: (self newTestSubjectWithPath: #('OpcodePool' 'Break')) asSymbol
		identicalTo: #'OpcodePool.Break'!

testBinding
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self newTestSubjectWithPath: each first.
			path
				ifNil: [self should: [subject binding] raise: NotFoundError]
				ifNotNil: 
					[| expected actual |
					actual := subject binding.
					expected := Smalltalk resolveBindingPath: path.
					self assert: actual identicalTo: expected]]!

testBindingOrNil
	self bindingTestCases do: 
			[:each |
			| actual path |
			actual := (self newTestSubjectWithPath: each first) bindingOrNil.
			path := each last.
			path
				ifNil: [self assertIsNil: actual]
				ifNotNil: 
					[| expected |
					expected := Smalltalk resolveBindingPath: path.
					self assert: actual identicalTo: expected]]!

testEquals
	self assert: (self newTestSubjectWithPath: #('Smalltalk'))
		equals: (self newTestSubjectWithPathString: 'Smalltalk').
	self assert: (self newTestSubjectWithPath: #('Smalltalk' 'Object'))
		equals: (self newTestSubjectWithPathString: 'Smalltalk.Object').
	self deny: (self newTestSubjectWithPath: #('Smalltalk')) equals: Object new.
	"Different to VW behaviour."
	self assert: (self newTestSubjectWithPath: #('Object'))
		equals: (self newTestSubjectWithPath: #('Smalltalk' 'Object'))!

testHash
	self assert: (self subjectClass path: #('Smalltalk' 'OpcodePool' 'Nop')) hash
		equals: (self subjectClass pathString: 'Smalltalk.OpcodePool.Nop') hash.
	"Different VW behaviour."
	self assert: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #('Smalltalk' 'Object')) hash.
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #('Smalltalk')) hash!

testIfDefined
	self bindingTestCases do: 
			[:each |
			| subject actual path expected |
			subject := self newTestSubjectWithPath: each first.
			actual := subject ifDefined: [:value | value].
			path := each last.
			expected := path isNil ifFalse: [(Smalltalk resolveBindingPath: path) value].
			self assert: actual identicalTo: expected]!

testIfDefinedIfNotDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			subject
				ifDefined: [:value | self assert: value identicalTo: (Smalltalk resolveBindingPath: each last) value]
				ifNotDefined: [self assertIsNil: each last]]!

testIsDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	self bindingTestCases do: [:each | self deny: (self newTestSubjectWithPath: each first) isLiteral]!

testIsWilcard
	self bindingTestCases do: [:each | self deny: (self newTestSubjectWithPath: each first) isWildcard]!

testPath
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject path equals: each last ?? each first]!

testPathString
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := String
						streamContents: [:strm | path do: [:id | strm nextPutAll: id] separatedBy: [strm nextPut: $.]].
			subject := self subjectClass pathString: pathString.
			self assert: subject path equals: each last ?? path.
			self deny: subject isWildcard]!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject printString equals: each last]!

testSimpleName
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each first.
			subject := self newTestSubjectWithPath: path.
			self assert: subject simpleName equals: path last]!

testStoreString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject storeString equals: each last]!

testValue
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self newTestSubjectWithPath: each first.
			path
				ifNil: [self should: [subject value] raise: NotFoundError]
				ifNotNil: 
					[| expected actual |
					actual := subject value.
					expected := (Smalltalk resolveBindingPath: path) value.
					self assert: actual identicalTo: expected]]!

testValueOrNil
	self bindingTestCases do: 
			[:each |
			| path subject expected actual |
			path := each last.
			subject := self newTestSubjectWithPath: each first.
			actual := subject valueOrNil.
			expected := path ifNotNil: [(Smalltalk resolveBindingPath: path) value].
			self assert: actual identicalTo: expected]! !
!GeneralBindingReferenceTest categoriesFor: #bindingTestCases!constants!private! !
!GeneralBindingReferenceTest categoriesFor: #newTestSubjectWithPath:!helpers!private! !
!GeneralBindingReferenceTest categoriesFor: #newTestSubjectWithPathString:!helpers!private! !
!GeneralBindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!GeneralBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!GeneralBindingReferenceTest categoriesFor: #testAsString!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testAsSymbol!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testBinding!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testBindingOrNil!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testHash!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testIfDefined!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testIfDefinedIfNotDefined!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testIsDefined!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testIsLiteral!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testIsWilcard!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testPath!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testPathString!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testPrintString!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testSimpleName!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testStoreString!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testValue!public!unit tests! !
!GeneralBindingReferenceTest categoriesFor: #testValueOrNil!public!unit tests! !

