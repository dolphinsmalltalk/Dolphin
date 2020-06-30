"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AbstractBindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractBindingReferenceTest guid: (GUID fromString: '{aca86665-9b25-4f35-bdb8-0c0e434df4e6}')!
AbstractBindingReferenceTest isAbstract: true!
AbstractBindingReferenceTest comment: ''!
!AbstractBindingReferenceTest categoriesForClass!Unclassified! !
!AbstractBindingReferenceTest methodsFor!

bindingTestCases
	"May ccontains some examples that currently do not resolve as there are no namespaces."

	| missingNamespace |
	missingNamespace := '_' , GUID newUnique idlString copyReplacing: $- withObject: $_.
	^{#(#(#Object)).
		{#(#Smalltalk #Object). #(#Smalltalk #Object)}.
		#(#(#OpcodePool #Nop)).
		#(#(#Smalltalk #OpcodePool #Nop) #(#Smalltalk #OpcodePool #Nop)).
		{{missingNamespace. '__MissingClass'}. nil}.
		{{missingNamespace. 'Date'}. nil}.
		{#(#Object #_EventsRegister). #(#Object #_EventsRegister)}}!

newTestSubjectWithPath: anArrayOfStrings
	^self subjectClass path: anArrayOfStrings!

newTestSubjectWithPathString: aString
	^self subjectClass pathString: aString!

printStringTestCases
	^self subclassResponsibility!

subjectClass
	self subclassResponsibility!

testAsQualifiedReference
	| subject |
	subject := self subjectClass path: #(#Object).
	self assert: subject asQualifiedReference identicalTo: subject!

testAsString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject asString equals: (each last copyFrom: 3 to: each last size - 1)]!

testAsSymbol
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject asSymbol identicalTo: (each last copyFrom: 3 to: each last size - 1) asSymbol]!

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
	"BindingReference equality is a stable property based on the path and starting point. Different paths to the same target binding (of which there may be many) are not equal."
	self deny: (self newTestSubjectWithPath: #('Object'))
		equals: (self newTestSubjectWithPath: #('Smalltalk' 'Object')).
	self assert: (self subjectClass path: #('Core'))
		equals: (self subjectClass simpleName: 'Core' in: Smalltalk).
	"This demonstrates a significant gotcha with BindingReferences: Literal binding refs start the binding search in the method class, so they are not equivalent to a BindingReference constructed from just a path string that does not have a context class.
	Many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path from the same starting point. An exception to this is literal binding refs in expressions that are compiled without context (e.g. in a workspace or a file-in), these do not have a starting context because the expressions
	are not explicitly compiled in any particular class and can only reference variables in Smalltalk with unqualified names, not the class variables of Object or any variables in namespaces imported into Object."
	self deny: 'Object' asQualifiedReference equals: #{Object}.!

testHash
	self assert: (self subjectClass path: #('Smalltalk' 'OpcodePool' 'Nop')) hash
		equals: (self subjectClass pathString: 'Smalltalk.OpcodePool.Nop') hash.
	"Same target variable, but different paths, so different hashes."
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #('Smalltalk' 'Object')) hash.
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #('Smalltalk')) hash.
	self assert: (BindingReference path: #('Core' 'Object')) hash
		equals: (BindingReference path: #('Core' 'Object') home: Smalltalk) hash!

testHome
	| subject |
	subject := self subjectClass path: #('OpcodePool' 'Nop').
	self assert: subject home identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject home identicalTo: OpcodePool
!

testIfDefined
	self bindingTestCases do: 
			[:each |
			| subject actual path expected |
			subject := self newTestSubjectWithPath: each first.
			actual := subject ifDefined: [:value | value].
			path := each last.
			expected := path isNil ifFalse: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

testIfDefinedIfNotDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			subject
				ifDefined: [:value | self assert: value identicalTo: (self valueOfBinding: (Smalltalk resolveBindingPath: each last))]
				ifNotDefined: [self assertIsNil: each last]]!

testInstance
	self subclassResponsibility!

testIsDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	self bindingTestCases do: [:each | self assert: (self newTestSubjectWithPath: each first) isLiteral]!

testIsWilcard
	self bindingTestCases do: [:each | self deny: (self newTestSubjectWithPath: each first) isWildcard]!

testLessOrEqual
	| a a1 b |
	a := self newTestSubjectWithPathString: 'Core.Object'.
	a1 := self newTestSubjectWithPathString: 'Core.Object'.
	b := self newTestSubjectWithPathString: 'Core.object'.
	self assert: a <= a.
	self assert: a <= a1.
	self assert: a1 <= a.
	self deny: a <= b!

testMeta
	self subclassResponsibility!

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
			self deny: subject isWildcard].

	#('*' 'Smalltalk.Core.*')
		do: [:each | self assert: (self subjectClass pathString: each) pathString equals: each].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #().
	self deny: subject isWildcard!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject printString equals: each last]!

testRefersToLiteral
	self subclassResponsibility!

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
					expected := self valueOfBinding: (Smalltalk resolveBindingPath: path).
					self assert: actual identicalTo: expected]]!

testValueOrNil
	self bindingTestCases do: 
			[:each |
			| path subject expected actual |
			path := each last.
			subject := self newTestSubjectWithPath: each first.
			actual := subject valueOrNil.
			expected := path ifNotNil: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

valueOfBinding: aVariableBinding
	^self subclassResponsibility! !
!AbstractBindingReferenceTest categoriesFor: #bindingTestCases!constants!private! !
!AbstractBindingReferenceTest categoriesFor: #newTestSubjectWithPath:!helpers!private! !
!AbstractBindingReferenceTest categoriesFor: #newTestSubjectWithPathString:!helpers!private! !
!AbstractBindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!AbstractBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!AbstractBindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!AbstractBindingReferenceTest categoriesFor: #testAsString!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testAsSymbol!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testBinding!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testBindingOrNil!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testHash!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testHome!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testIfDefined!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testIfDefinedIfNotDefined!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testInstance!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testIsDefined!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testIsLiteral!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testIsWilcard!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testMeta!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testPath!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testPathString!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testPrintString!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testRefersToLiteral!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testSimpleName!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testStoreString!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testValue!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #testValueOrNil!public!unit tests! !
!AbstractBindingReferenceTest categoriesFor: #valueOfBinding:!helpers!private! !

