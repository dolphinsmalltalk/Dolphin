"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.BindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: 'TestVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.BindingReferenceTest guid: (Core.GUID fromString: '{aca86665-9b25-4f35-bdb8-0c0e434df4e6}')!
Kernel.Tests.BindingReferenceTest isNonInstantiable: true!
Kernel.Tests.BindingReferenceTest comment: ''!
!Kernel.Tests.BindingReferenceTest categoriesForClass!Unclassified! !
!Kernel.Tests.BindingReferenceTest methodsFor!

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
		{#(#Kernel #VMLibrary #Registry #Symbol). Core. nil}.
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
			subject := self subjectClass path: each first scope: each second.
			self assert: subject asString equals: (each last copyFrom: 3 to: each last size - 1)]!

testAsSymbol
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first scope: each second.
			self assert: subject asSymbol identicalTo: (each last copyFrom: 3 to: each last size - 1) asSymbol]!

testBinding
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self subjectClass path: each first scope: each second.
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
			actual := (self subjectClass path: each first scope: each second) bindingOrNil.
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
	ref := self subjectClass pathString: '_EventsRegister' scope: Object.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister').
	ref := self subjectClass pathString: '_EventsRegister' scope: Object >> #trigger:.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister')!

testBindingScope
	| subject |
	subject := self subjectClass path: #(#OpcodePool 'Nop').
	self assert: subject bindingScope identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject bindingScope identicalTo: OpcodePool!

testEnvironmentName
	| subject |
	#('Core.Object' 'Core' 'Smalltalk' nil 'Root' nil 'Root.Smalltalk' 'Root' 'Smalltalk.Animal' 'Smalltalk' 'Animal' nil 'XProgramming.SUnit' 'XProgramming' 'XProgramming.SUnit.TestRunConsoleLogger' 'XProgramming.SUnit')
		pairsDo: 
			[:each :expected |
			subject := self subjectClass pathString: each.
			self assert: subject environmentName equals: expected].
	subject := (self subjectClass pathString: 'Root' scope: Root) instance.
	self assert: subject environmentName equals: 'Root'.
	subject := (self subjectClass pathString: 'TestCase' scope: XProgramming.SUnit) instance.
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
	self assert: (self subjectClass path: #('_' 'Object') scope: self class)
		equals: (self subjectClass path: #(#Object) scope: self class).
	self assert: (self subjectClass path: #('Core' 'Object') scope: self class)
		equals: (self subjectClass path: #('Core' 'Object') scope: (self class lookupMethod: self selector))!

testHash
	self assert: (self subjectClass path: #(#Kernel 'OpcodePool' 'Nop')) hash
		equals: (self subjectClass pathString: 'Kernel.OpcodePool.Nop') hash.
	"Same target variable, but different paths, so different hashes."
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #(#Smalltalk 'Object')) hash.
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #(#Smalltalk)) hash.
	self assert: (self subjectClass path: #('Core' 'Object')) hash
		equals: (self subjectClass path: #('Core' 'Object') home: Smalltalk) hash.
	self deny: (self subjectClass path: #('Object')) hash
		equals: (self subjectClass path: #('Object') scope: Core) hash.
	self assert: (self subjectClass path: #('Core' 'Object') scope: self class) hash
		equals: (self subjectClass path: #('Core' 'Object') scope: (self class lookupMethod: self selector))
				hash!

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
			subject := self subjectClass path: each first scope: each second.
			actual := subject ifDefined: [:value | value].
			path := each last.
			expected := path isNil ifFalse: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

testIfDefinedIfNotDefined
	self bindingTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first scope: each second.
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
			subject := self subjectClass path: each first scope: each second.
			self assert: subject isDefined equals: each last notNil]!

testIsLiteral
	| subject |
	subject := self subjectClass path: #(#Object) scope: Core.
	self deny: subject isLiteral.
	subject := self subjectClass path: #('_' #SUnit #TestCase) scope: XProgramming.
	self deny: subject isLiteral.
	subject := self subjectClass path: #(#Core #Object) scope: nil.
	self assert: subject isLiteral.
	self assert: subject private isLiteral!

testIsRelative
	| subject |
	subject := self subjectClass path: #(#Object) scope: Core.
	self assert: subject isRelative.
	subject := self subjectClass path: #('_' #SUnit #TestCase) scope: XProgramming.
	self assert: subject isRelative.
	subject := self subjectClass path: #(#Object) scope: Association.
	self assert: subject isRelative.
	subject := self subjectClass path: #(#Core #Object) scope: nil.
	self deny: subject isRelative.
	"If the path has multiple components, then unless the first component is '_', it is assumed to be an absolute path and the context is ignored"
	subject := self subjectClass path: #(#Core #Object) scope: Association.
	self deny: subject isRelative!

testIsSelfEvaluating
	| subject |
	subject := self subjectClass path: #(#Object) scope: Core.
	self deny: subject isSelfEvaluating.
	subject := self subjectClass path: #('_' #SUnit #TestCase) scope: XProgramming.
	self deny: subject isSelfEvaluating.
	subject := self subjectClass path: #(#Core #Object) scope: nil.
	self assert: subject isSelfEvaluating.
	self assert: subject private isSelfEvaluating!

testLessOrEqual
	| a a1 b |
	a := self subjectClass pathString: 'Core.Object'.
	a1 := self subjectClass pathString: 'Core.Object'.
	b := self subjectClass pathString: 'Core.object'.
	self assert: a <= a.
	self assert: a <= a1.
	self assert: a1 <= a.
	self deny: a <= b!

testLiteralStoreFull
	"The literal form should be used for fully qualified references"

	| full |
	full := self subjectClass path: #('Core' 'Object').
	{full. full private} do: 
			[:each |
			| expected actual binding rehydrated |
			binding := each binding.
			self assert: each literalStoreArray last identicalTo: each.
			actual := each literalStoreEvaluationString.
			rehydrated := Compiler evaluate: actual.
			self assert: rehydrated equals: each.
			self assertIsNil: (rehydrated instance instVarAt: 4).
			self assertIsNil: (rehydrated instance instVarAt: 5).
			self assert: rehydrated binding identicalTo: binding.
			expected := '(Object fromLiteralStoreArray: #(#''!!STL'' <1p> 8 <2p>))' << {STBFiler version. each}.
			self assert: actual equals: expected]!

testLiteralStoreRelative
	"The literal form cannot be used for unqualified or partially qualified (i.e. relative) references."

	| relative |
	relative := self subjectClass path: {'_'. self class name} scope: self class environment.
	{relative. relative private} do: 
			[:each |
			| actual rehydrated binding |
			binding := each binding.
			actual := each literalStoreArray.
			self deny: (actual includes: each).
			self assert: (actual includes: RelativeBindingReference).
			self assert: (actual includes: self class name).
			self assert: (actual includes: self class environment).
			rehydrated := Compiler evaluate: each literalStoreEvaluationString.
			self assert: rehydrated equals: each.
			self assertIsNil: (rehydrated instance instVarAt: 4).
			self assertIsNil: (rehydrated instance instVarAt: 5).
			self assert: rehydrated binding identicalTo: binding]!

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
				subject := self subjectClass path: each first scope: each second.
				self assert: subject path equals: each last]!

testPathString
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self subjectClass pathString: pathString.
			self assert: subject path equals: (path copyWithout: '_')].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #()!

testPathStringScope
	| subject pathString |
	self bindingTestCases do: 
			[:each |
			| path |
			path := each first.
			pathString := $. join: path.
			subject := self subjectClass pathString: pathString scope: each second.
			path first = '_'
				ifTrue: 
					[self assert: subject path equals: path allButFirst.
					self assert: subject pathString equals: (pathString copyFrom: 3)]
				ifFalse: 
					[self assert: subject path equals: path.
					self assert: subject pathString equals: pathString]].
	subject := self subjectClass pathString: ''.
	self assert: subject path equals: #()!

testPrintString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first scope: self class.
			self assert: subject printString equals: each last.
			subject := self subjectClass
						pathString: (each last copyFrom: 3 to: (each last indexOfAnyOf: ' }' startingAt: 3) - 1)
						scope: self class.
			self assert: subject printString equals: each last]!

testPrivate
	| subject private |
	subject := self subjectClass pathString: 'Object'.
	self deny: subject isPrivate.
	self deny: subject isRelative.
	private := subject private.
	self assert: private isPrivate.
	self deny: private isRelative.
	self deny: subject equals: private.
	BindingReference pathString: 'Object' scope: Core!

testPrivateRelative
	| subject private |
	subject := BindingReference pathString: 'Object' scope: Core.
	self deny: subject isPrivate.
	self assert: subject isRelative.
	private := subject private.
	self assert: private isPrivate.
	self assert: private isRelative.
	self deny: subject equals: private!

testRefersToLiteralClass
	| method objectRef |
	method := self class lookupMethod: testSelector.
	objectRef := self subjectClass pathString: #'Core.Object'.
	self assert: (objectRef refersTo: (self subjectClass path: #(#Core #Object)) asLiteralOf: method).
	".. and the binding to which it would resolve ..."
	self assert: (objectRef refersTo: Object binding asLiteralOf: method).
	"... and the target class."
	self assert: (objectRef refersTo: Object asLiteralOf: method).
	self deny: (objectRef refersTo: nil asLiteralOf: method).
	#namespaceToDo. "Should refer to the Namespace too"
	self assert: (objectRef refersTo: Core asLiteralOf: method) | true!

testRefersToLiteralNotFound
	| method objectRef |
	method := self class lookupMethod: testSelector.
	objectRef := self subjectClass pathString: #'Core.Object2'.
	self deny: (objectRef refersTo: (self subjectClass path: #(#Core #Object)) asLiteralOf: method).
	".. and the binding to which it would resolve ..."
	self deny: (objectRef refersTo: Object binding asLiteralOf: method).
	"... and the target class."
	self deny: (objectRef refersTo: Object asLiteralOf: method).
	self deny: (objectRef refersTo: nil asLiteralOf: method).
	"It doesn't refer to the namespace along the path either. This could perhaps be correct either way, but as the reference itself doesn't resolve it doesn't really refer to anything."
	self deny: (objectRef refersTo: Core asLiteralOf: method)!

testRefersToLiteralPoolVariable
	"A BindingReference matches literals for the same path..."

	| method poolConstRef poolConst |
	method := self class lookupMethod: testSelector.
	"BindingRef to a pool variable."
	poolConstRef := self subjectClass pathString: '_PrimitiveFailureCode.AccessViolation'.
	poolConst := _PrimitiveFailureCode localBindingFor: 'AccessViolation'.
	self
		assert: (poolConstRef refersTo: (self subjectClass path: #(#_PrimitiveFailureCode 'AccessViolation'))
				asLiteralOf: method).
	self assert: (poolConstRef refersTo: poolConst asLiteralOf: method).
	self deny: (poolConstRef refersTo: poolConst value asLiteralOf: method).
	"Should a BindingRef implicitly refers to refs along its path? Not entirely sure, but at the moment not"
	self deny: (poolConstRef refersTo: #{Kernel._PrimitiveFailureCode} asLiteralOf: method).
	#namespaceToDo.	"This should be true - a reference to a nested binding is implicitly a reference to the outer binding."
	self deny: (poolConstRef refersTo: _PrimitiveFailureCode binding asLiteralOf: method)!

testRelativeNoScope
	self should: [self subjectClass path: #('_' 'Object')] raise: Error!

testShortName
	#(#Root #Smalltalk #Core #'Core.Class' #'Kernel.BindingContext') do: 
			[:each |
			| subject |
			subject := self subjectClass pathString: each.
			self assert: subject shortName equals: ($. split: each) last , self nameSuffix.
			self assert: subject shortName equals: subject simpleName].
	#('XProgramming.SUnit' 'XProgramming.SUnit.TestRunConsoleLogger') do: 
			[:each |
			| subject |
			subject := self subjectClass pathString: each.
			self assert: subject shortName equals: subject pathString , self nameSuffix.
			self deny: subject shortName equals: subject simpleName]!

testStoreString
	self printStringTestCases do: 
			[:each |
			| subject |
			subject := self subjectClass path: each first scope: Smalltalk.
			self assert: subject storeString equals: each last]!

testUnqualifiedName
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each first.
			subject := self subjectClass path: path scope: each second.
			self assert: subject unqualifiedName equals: path last , self nameSuffix]!

testValue
	self bindingTestCases do: 
			[:each |
			| path subject |
			path := each last.
			subject := self subjectClass path: each first scope: each second.
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
			subject := self subjectClass path: each first scope: each second.
			actual := subject valueOrNil.
			path := each last.
			expected := path ifNotNil: [self valueOfBinding: (Smalltalk resolveBindingPath: path)].
			self assert: actual identicalTo: expected]!

valueOfBinding: aVariableBinding
	^aVariableBinding value! !
!Kernel.Tests.BindingReferenceTest categoriesForMethods!
bindingTestCases!constants!private! !
nameSuffix!constants!private! !
printStringTestCases!constants!private! !
subjectClass!constants!private! !
testAppend!public!unit tests! !
testAsQualifiedReference!public!unit tests! !
testAsString!public!unit tests! !
testAsSymbol!public!unit tests! !
testBinding!public!unit tests! !
testBindingOrNil!public!unit tests! !
testBindingOrNilInContext!public!unit tests! !
testBindingScope!public!unit tests! !
testEnvironmentName!public!unit tests! !
testEquals!public!unit tests! !
testHash!public!unit tests! !
testHome!public!unit tests! !
testIfDefined!public!unit tests! !
testIfDefinedIfNotDefined!public!unit tests! !
testInstance!public!unit tests! !
testIsDefined!public!unit tests! !
testIsLiteral!public!unit tests! !
testIsRelative!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLiteralStoreFull!public!unit tests! !
testLiteralStoreRelative!public!unit tests! !
testMeta!public!unit tests! !
testPath!public!unit tests! !
testPathString!public!unit tests! !
testPathStringScope!public!unit tests! !
testPrintString!public!unit tests! !
testPrivate!public!unit tests! !
testPrivateRelative!public!unit tests! !
testRefersToLiteralClass!public!unit tests! !
testRefersToLiteralNotFound!public!unit tests! !
testRefersToLiteralPoolVariable!public!unit tests! !
testRelativeNoScope!public!unit tests! !
testShortName!public!unit tests! !
testStoreString!public!unit tests! !
testUnqualifiedName!public!unit tests! !
testValue!public!unit tests! !
testValueOrNil!public!unit tests! !
valueOfBinding:!helpers!private! !
!

