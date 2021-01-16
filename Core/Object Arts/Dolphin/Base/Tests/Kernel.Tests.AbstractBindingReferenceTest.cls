"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.AbstractBindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AbstractBindingReferenceTest guid: (Core.GUID fromString: '{aca86665-9b25-4f35-bdb8-0c0e434df4e6}')!
Kernel.Tests.AbstractBindingReferenceTest isNonInstantiable: true!
Kernel.Tests.AbstractBindingReferenceTest comment: ''!
!Kernel.Tests.AbstractBindingReferenceTest categoriesForClass!Unclassified! !
!Kernel.Tests.AbstractBindingReferenceTest methodsFor!

bindingTestCases
	| missingNamespace |
	missingNamespace := '_' , GUID newUnique idlString copyReplacing: $- withObject: $_.
	^{#(#(#Object)).
		{#(#Smalltalk #Object). #(#Smalltalk #Object)}.
		#(#(#OpcodePool #Nop)).
		#(#(#Smalltalk #OpcodePool #Nop) #(#Smalltalk #OpcodePool #Nop)).
		{{missingNamespace. '__MissingClass'}. nil}.
		{{missingNamespace. 'Date'}. nil}.
		#(#(#Object #_EventsRegister)).
		#(#(#XProgramming #SUnit #TestCase))}!

newTestSubjectWithPath: anArrayOfStrings
	^self subjectClass path: anArrayOfStrings!

newTestSubjectWithPathString: aString
	^self subjectClass pathString: aString!

printStringTestCases
	^#(#(#(#Object) '#{Object}') #(#(#OpcodePool #Nop) '#{OpcodePool.Nop}') #(#('A' 'B' 'C') '#{A.B.C}'))!

subjectClass
	self subclassResponsibility!

testAppend
	| subject nested |
	subject := self subjectClass path: #(#'Object').
	"Class variables can be bound on both sides, so this should work for meta binding refs too."
	nested := subject append: '_EventsRegister'.
	self assert: nested binding identicalTo: (Object localBindingFor: #_EventsRegister)!

testAsQualifiedReference
	| subject |
	subject := self subjectClass path: #(#'Core.Object').
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
	| subject |
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
					self assert: actual identicalTo: expected]].
	"Check that we don't arbitrarily bind class variables of Object"
	subject := BindingReference pathString: '_EventsRegister'.
	self assertIsNil: subject bindingOrNil!

testBindingOrNilInContext
	| ref |
	ref := self subjectClass pathString: '_EventsRegister' context: Object.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister').
	ref := self subjectClass pathString: '_EventsRegister' context: Object >> #trigger:.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister')!

testEnvironmentName
	| subject |
	#('Core.Object' 'Core' 'Smalltalk' 'Smalltalk' 'Root' 'Smalltalk' 'Smalltalk.Animal' 'Smalltalk' 'Animal' 'Smalltalk' 'XProgramming.SUnit' 'XProgramming' 'XProgramming.SUnit.TestCase' 'XProgramming.SUnit')
		pairsDo: 
			[:each :expected |
			subject := self newTestSubjectWithPathString: each.
			self assert: subject environmentName equals: expected].
	subject := (self newTestSubjectWithPathString: 'Root') instance setContext: Root; yourself.
	self assert: subject environmentName equals: 'Root'.
	subject := (self newTestSubjectWithPathString: 'TestCase') instance setContext: XProgramming.SUnit; yourself.
	self assert: subject environmentName equals: 'XProgramming.SUnit'.
!

testEquals
	self assert: (self newTestSubjectWithPath: #(#Smalltalk))
		equals: (self newTestSubjectWithPathString: #Smalltalk).
	self assert: (self newTestSubjectWithPath: #(#Smalltalk #Object))
		equals: (self newTestSubjectWithPathString: 'Smalltalk.Object').
	self deny: (self newTestSubjectWithPath: #(#Smalltalk)) equals: Object new.
	"BindingReference equality is a stable property based on the path and starting point. Different paths to the same target binding (of which there may be many) are not equal."
	self deny: (self newTestSubjectWithPath: #(#'Core.Object'))
		equals: (self newTestSubjectWithPath: #(#Smalltalk #Object)).
	self assert: (self subjectClass path: #('Core'))
		equals: (self subjectClass simpleName: 'Core' in: Smalltalk).
	"This demonstrates a significant gotcha with BindingReferences: Literal binding refs start the binding search in the method class, so they are not equivalent to a BindingReference constructed from just a path string that does not have a context class.
	Many BindingReferences that are not considered equivalent may eventually bind to the same target binding - this is a necessary condition for BindingReference equivalence, but it is not sufficient. BindingReferences are only equivalent if they represent the same binding path from the same starting point. An exception to this is literal binding refs in expressions that are compiled without context (e.g. in a workspace or a file-in), these do not have a starting context because the expressions
	are not explicitly compiled in any particular class and can only reference variables in Smalltalk with unqualified names, not the class variables of Object or any variables in namespaces imported into Object."
	self deny: #'Core.Object' asQualifiedReference equals: #{Object}!

testHash
	self assert: (self subjectClass path: #(#Kernel 'OpcodePool' 'Nop')) hash
		equals: (self subjectClass pathString: 'Kernel.OpcodePool.Nop') hash.
	"Same target variable, but different paths, so different hashes."
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #(#Smalltalk 'Object')) hash.
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #(#Smalltalk)) hash.
	self assert: (BindingReference path: #('Core' 'Object')) hash
		equals: (BindingReference path: #('Core' 'Object') home: Smalltalk) hash!

testHome
	| subject |
	subject := self subjectClass path: #(#OpcodePool 'Nop').
	self assert: subject home identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject home identicalTo: OpcodePool!

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
			subject ifDefined: 
					[:value |
					self assert: value identicalTo: (self valueOfBinding: (Smalltalk resolveBindingPath: each last))]
				ifNotDefined: [self assertIsNil: each last]]!

testInstance
	| subject |
	subject := self newTestSubjectWithPathString: 'Object'.
	self assert: subject instance identicalTo: subject!

testIsDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPath: each first.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	self bindingTestCases do: [:each | self assert: (self newTestSubjectWithPath: each first) isLiteral]!

testIsSelfEvaluating
	self bindingTestCases
		do: [:each | self assert: (self newTestSubjectWithPath: each first) isSelfEvaluating]!

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
	| subject meta |
	subject := self newTestSubjectWithPathString: #'Core.Object'.
	meta := subject meta.
	self assert: subject meta isMeta.
	self assert: meta value identicalTo: Object class!

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
			self assert: subject path equals: each last ?? path].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #()!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject printString equals: each last]!

testRefersToLiteral
	"A BindingReference matches literals for the same path..."

	| objectRef poolConstRef poolConst |
	objectRef := self subjectClass pathString: #'Core.Object'.
	self assert: (objectRef refersToLiteral: (self subjectClass path: #(#'Core.Object'))).
	".. and the binding to which it would resolve ..."
	self assert: (objectRef refersToLiteral: Object binding).
	"... but not the target value."
	self deny: (objectRef refersToLiteral: Object).
	"BindingRef to a pool variable."
	poolConstRef := self subjectClass pathString: '_PrimitiveFailureCode.AccessViolation'.
	poolConst := _PrimitiveFailureCode localBindingFor: 'AccessViolation'.
	self assert: (poolConstRef
				refersToLiteral: (self subjectClass path: #(#_PrimitiveFailureCode 'AccessViolation'))).
	self assert: (poolConstRef refersToLiteral: poolConst).
	"Should a BindingRef implicitly refers to refs along its path? Not sure."
	false
		ifTrue: [self assert: (poolConstRef refersToLiteral: _PrimitiveFailureCode asQualifiedReference)].
	#namespaceToDo.	"This should be true - a reference to a nested binding is implicitly a reference to the outer binding."
	false ifTrue: [self assert: (poolConstRef refersToLiteral: _PrimitiveFailureCode binding)]!

testShortName
	#(#Root #Smalltalk #Core #'Core.Class' #'Kernel.BindingContext') do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPathString: each.
			self assert: subject shortName equals: subject unqualifiedName].
	#('XProgramming.SUnit' 'XProgramming.SUnit.TestCase') do: 
			[:each |
			| subject |
			subject := self newTestSubjectWithPathString: each.
			self assert: subject shortName equals: subject pathString]!

testStoreString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject storeString equals: each last]!

testUnqualifiedName
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each first.
			subject := self newTestSubjectWithPath: path.
			self assert: subject unqualifiedName equals: path last]!

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
			subject := self newTestSubjectWithPath: each first.
			actual := subject valueOrNil.
			path := each last.
			expected := path ifNotNil: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

valueOfBinding: aVariableBinding
	^aVariableBinding value! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #bindingTestCases!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #newTestSubjectWithPath:!helpers!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #newTestSubjectWithPathString:!helpers!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAppend!public! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsSymbol!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBinding!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBindingOrNil!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBindingOrNilInContext!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testEnvironmentName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testHash!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testHome!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIfDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIfDefinedIfNotDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testInstance!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsLiteral!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsSelfEvaluating!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testMeta!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPath!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPathString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPrintString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testRefersToLiteral!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testShortName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testStoreString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testUnqualifiedName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testValue!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testValueOrNil!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #valueOfBinding:!helpers!private! !

