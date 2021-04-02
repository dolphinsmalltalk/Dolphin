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
	^{#(#(#Object) nil #(#Object)).
		{#(#Smalltalk #Object). nil. #(#Smalltalk #Object)}.
		#(#(#OpcodePool #Nop) nil #(#OpcodePool #Nop)).
		#(#(#Smalltalk #OpcodePool #Nop) nil #(#Smalltalk #OpcodePool #Nop)).
		{{missingNamespace. '__MissingClass'}. nil. nil}.
		{{missingNamespace. 'Date'}. nil. nil}.
		#(#(#Object #_EventsRegister) nil #(#Object #_EventsRegister)).
		{#(#_EventsRegister). Object. #(#Object #_EventsRegister)}.
		#(#(#XProgramming #SUnit #TestCase) nil #(#XProgramming #SUnit #TestCase)).
		{#('_' #SUnit #TestCase). XProgramming. #(#XProgramming #SUnit #TestCase)}}!

nameSuffix
	^''!

printStringTestCases
	^#(#(#(#Object) '#{Object}') #(#(#OpcodePool #Nop) '#{OpcodePool.Nop}') #(#('A' 'B' 'C') '#{A.B.C}') #(#('_' 'SUnit' 'TestCase') '#{_.SUnit.TestCase}'))!

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
			subject := self subjectClass path: each first context: each second.
			self assert: subject asString equals: (each last copyFrom: 3 to: each last size - 1)]!

testAsSymbol
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first context: each second.
			self assert: subject asSymbol identicalTo: (each last copyFrom: 3 to: each last size - 1) asSymbol]!

testBinding
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self subjectClass path: each first context: each second.
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
			actual := (self subjectClass path: each first context: each second) bindingOrNil.
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

testBindingRoot
	| subject |
	subject := self subjectClass path: #(#OpcodePool 'Nop').
	self assert: subject bindingRoot identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject bindingRoot identicalTo: OpcodePool!

testEnvironmentName
	| subject |
	#('Core.Object' 'Core' 'Smalltalk' 'Smalltalk' 'Root' 'Smalltalk' 'Smalltalk.Animal' 'Smalltalk' 'Animal' 'Smalltalk' 'XProgramming.SUnit' 'XProgramming' 'XProgramming.SUnit.TestCase' 'XProgramming.SUnit')
		pairsDo: 
			[:each :expected |
			subject := self subjectClass pathString: each.
			self assert: subject environmentName equals: expected].
	subject := (self subjectClass pathString: 'Root') instance
				setContext: Root;
				yourself.
	self assert: subject environmentName equals: 'Root'.
	subject := (self subjectClass pathString: 'TestCase') instance
				setContext: XProgramming.SUnit;
				yourself.
	self assert: subject environmentName equals: 'XProgramming.SUnit'!

testEquals
	self assert: (self subjectClass path: #(#Smalltalk))
		equals: (self subjectClass pathString: #Smalltalk).
	self assert: (self subjectClass path: #(#Smalltalk #Object))
		equals: (self subjectClass pathString: 'Smalltalk.Object').
	self deny: (self subjectClass path: #(#Smalltalk)) equals: Object new.
	"BindingReference equality is a stable property based on the path and starting point. Different paths to the same target binding (of which there may be many) are not equal."
	self deny: (self subjectClass path: #(#Core #Object))
		equals: (self subjectClass path: #(#Smalltalk #Object)).
	self assert: (self subjectClass path: #('Core'))
		equals: (self subjectClass simpleName: 'Core' in: Smalltalk).
	self assert: (self subjectClass path: #('_' 'Object') context: self class)
		equals: (self subjectClass path: #(#Object) context: self class)!

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
	self assert: subject home identicalTo: OpcodePool.
	subject := self subjectClass path: #(#Object) home: self class.
	self assert: subject home identicalTo: self class environment!

testIfDefined
	self bindingTestCases do: 
			[:each |
			| subject actual path expected |
			subject := self subjectClass path: each first context: each second.
			actual := subject ifDefined: [:value | value].
			path := each last.
			expected := path isNil ifFalse: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

testIfDefinedIfNotDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first context: each second.
			subject ifDefined: 
					[:value |
					self assert: value identicalTo: (self valueOfBinding: (Smalltalk resolveBindingPath: each last))]
				ifNotDefined: [self assertIsNil: each last]]!

testInstance
	| subject |
	subject := self subjectClass pathString: 'Object'.
	self assert: subject instance identicalTo: subject!

testIsDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first context: each second.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	self bindingTestCases do: [:each | self assert: (self subjectClass path: each first context: each second) isLiteral]!

testIsRelative
	| subject |
	subject := self subjectClass path: #(#Object) context: Core.
	self assert: subject isRelative.
	self deny: subject isAbsolute.
	subject := self subjectClass path: #('_' #SUnit #TestCase) context: XProgramming.
	self assert: subject isRelative.
	self deny: subject isAbsolute.
	subject := self subjectClass path: #(#Object) context: Association.
	self assert: subject isRelative.
	self deny: subject isAbsolute.
	subject := self subjectClass path: #(#Core #Object) context: nil.
	self deny: subject isRelative.
	self assert: subject isAbsolute.
	subject := self subjectClass path: #(#Core #Object) context: Association.
	self deny: subject isRelative.
	self assert: subject isAbsolute!

testIsSelfEvaluating
	self bindingTestCases
		do: [:each | self assert: (self subjectClass path: each first context: each second) isSelfEvaluating]!

testLessOrEqual
	| a a1 b |
	a := self subjectClass pathString: 'Core.Object'.
	a1 := self subjectClass pathString: 'Core.Object'.
	b := self subjectClass pathString: 'Core.object'.
	self assert: a <= a.
	self assert: a <= a1.
	self assert: a1 <= a.
	self deny: a <= b!

testMeta
	| subject meta |
	subject := self subjectClass pathString: #'Core.Object'.
	meta := subject meta.
	self assert: subject meta isMeta.
	self assert: meta value identicalTo: Object class!

testPath
	"Cases
	- unqualified name (always relative)
	- qualified absolute
	- qualified relative"

	{#(#(#Object) nil #(#Object)).
		#(#(#Core #Object) nil #(#Core #Object)).
		{#(#_EventsRegister). Object. #(#_EventsRegister)}.
		#(#(#XProgramming #SUnit #TestCase) nil #(#XProgramming #SUnit #TestCase)).
		{#('_' #SUnit #TestCase). XProgramming. #(#SUnit #TestCase)}} do: 
				[:each |
				| subject |
				subject := self subjectClass path: each first context: each second.
				self assert: subject path equals: each last]!

testPathString
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self subjectClass pathString: pathString.
			self assert: subject path equals: path].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #()!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first.
			self assert: subject printString equals: each last]!

testPrivate
	| subject |
	subject := self subjectClass pathString: 'Object'.
	self assert: subject private isPrivate.
	self deny: subject isPrivate.
	self deny: subject equals: subject private!

testRefersToLiteral
	"A BindingReference matches literals for the same path..."

	| method objectRef poolConstRef poolConst |
	method := self class lookupMethod: testSelector.
	objectRef := self subjectClass pathString: #'Core.Object'.
	self assert: (objectRef refersTo: (self subjectClass path: #(#Core #Object))
				asLiteralOf: method).
	".. and the binding to which it would resolve ..."
	self assert: (objectRef refersTo: Object binding asLiteralOf: method).
	"... but not the target value."
	self deny: (objectRef refersTo: Object asLiteralOf: method).
	"BindingRef to a pool variable."
	poolConstRef := self subjectClass pathString: '_PrimitiveFailureCode.AccessViolation'.
	poolConst := _PrimitiveFailureCode localBindingFor: 'AccessViolation'.
	self
		assert: (poolConstRef refersTo: (self subjectClass path: #(#_PrimitiveFailureCode 'AccessViolation'))
				asLiteralOf: method).
	self assert: (poolConstRef refersTo: poolConst asLiteralOf: method).
	"Should a BindingRef implicitly refers to refs along its path? Not sure."
	false
		ifTrue: 
			[self
				assert: (poolConstRef refersTo: #{Kernel._PrimitiveFailureCode} asLiteralOf: method)].
	#namespaceToDo.	"This should be true - a reference to a nested binding is implicitly a reference to the outer binding."
	false
		ifTrue: 
			[self assert: (poolConstRef refersTo: _PrimitiveFailureCode binding asLiteralOf: method)]!

testShortName
	#(#Root #Smalltalk #Core #'Core.Class' #'Kernel.BindingContext') do: 
			[:each |
			| subject |
			subject := self subjectClass pathString: each.
			self assert: subject shortName equals: ($. split: each) last , self nameSuffix.
			self assert: subject shortName equals: subject simpleName].
	#('XProgramming.SUnit' 'XProgramming.SUnit.TestCase') do: 
			[:each |
			| subject |
			subject := self subjectClass pathString: each.
			self assert: subject shortName equals: subject pathString , self nameSuffix.
			self deny: subject shortName equals: subject simpleName]!

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
			subject := self subjectClass path: path context: each second.
			self assert: subject unqualifiedName equals: path last , self nameSuffix]!

testValue
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self subjectClass path: each first context: each second.
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
			subject := self subjectClass path: each first context: each second.
			actual := subject valueOrNil.
			path := each last.
			expected := path ifNotNil: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

valueOfBinding: aVariableBinding
	^aVariableBinding value! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #bindingTestCases!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #nameSuffix!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAppend!public! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testAsSymbol!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBinding!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBindingOrNil!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBindingOrNilInContext!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testBindingRoot!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testEnvironmentName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testEquals!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testHash!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testHome!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIfDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIfDefinedIfNotDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testInstance!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsDefined!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsLiteral!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsRelative!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testIsSelfEvaluating!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testMeta!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPath!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPathString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPrintString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testPrivate!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testRefersToLiteral!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testShortName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testStoreString!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testUnqualifiedName!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testValue!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #testValueOrNil!public!unit tests! !
!Kernel.Tests.AbstractBindingReferenceTest categoriesFor: #valueOfBinding:!helpers!private! !

