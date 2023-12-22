"Filed out from Dolphin Smalltalk"!

Kernel.Tests.BindingReferenceTest
	subclass: #'Kernel.Tests.ScopedBindingReferenceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ScopedBindingReferenceTest guid: (Core.GUID fromString: '{08ed9f21-acc1-4531-8b3c-ac6baaed031a}')!
Kernel.Tests.ScopedBindingReferenceTest isNonInstantiable: true!
Kernel.Tests.ScopedBindingReferenceTest comment: ''!
!Kernel.Tests.ScopedBindingReferenceTest methodsFor!

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

pathTestCases
	^{#(#(#Object) nil #(#Object)).
		#(#(#Core #Object) nil #(#Core #Object)).
		{#(#_EventsRegister). Object. #(#_EventsRegister)}.
		#(#(#XProgramming #SUnit #TestCase) nil #(#XProgramming #SUnit #TestCase)).
		{#('_' #SUnit #TestCase). XProgramming. #(#SUnit #TestCase)}}!

printStringTestCases
	^#(#(#(#Object) nil '#{Object}') #(#(#OpcodePool #Nop) nil '#{OpcodePool.Nop}') #(#('A' 'B' 'C') nil '#{A.B.C}') #(#('_' 'SUnit' 'TestCase') #{XProgramming} '#{_.SUnit.TestCase}'))!

testBindingOrNilInContext
	| ref |
	ref := self newSubjectWithPathString: '_EventsRegister' scope: Object.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister').
	ref := self newSubjectWithPathString: '_EventsRegister' scope: Object >> #trigger:.
	self assert: ref bindingOrNil equals: (Object localBindingFor: '_EventsRegister')!

testBindingScope
	| subject |
	subject := self newSubjectWithPath: #(#OpcodePool 'Nop').
	self assert: subject bindingScope identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject isImmutable.
	self assert: subject bindingScope identicalTo: OpcodePool!

testEnvironmentNameInScope
	| subject |
	subject := (self newSubjectWithPathString: 'Root' scope: Root) instance.
	self assert: subject environmentName equals: 'Root'.
	subject := (self newSubjectWithPathString: 'TestCase' scope: XProgramming.SUnit) instance.
	self assert: subject environmentName equals: 'XProgramming.SUnit'!

testEqualsInScope
	| subject1 subject2 subject1a subject1b |
	subject1 := self newSubjectWithPath: #('Core').
	subject2 := self subjectClass simpleName: 'Core' in: Smalltalk.
	self assert: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: 0.
	self assert: subject1 <==> subject2 equals: 0.
	subject1 := self newSubjectWithPath: #('_' 'Object') scope: self class.
	subject2 := self newSubjectWithPath: #(#Object) scope: self class.
	self assert: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: 0.
	self assert: subject1 <==> subject2 equals: 0.
	subject1 := self newSubjectWithPath: #('Core' 'Object') scope: self class.
	subject2 := self newSubjectWithPath: #('Core' 'Object')
				scope: (self class lookupMethod: self selector).
	self assert: subject1 equals: subject2.
	self assert: subject1 <=> subject2 equals: 0.
	self assert: subject1 <==> subject2 equals: 0!

testHashInScope
	self assert: (self newSubjectWithPath: #('Core' 'Object')) hash
		equals: (self subjectClass path: #('Core' 'Object') home: Smalltalk) hash.
	self deny: (self newSubjectWithPath: #('Object')) hash
		equals: (self newSubjectWithPath: #('Object') scope: Core) hash.
	self assert: (self newSubjectWithPath: #('Core' 'Object') scope: self class) hash
		equals: (self newSubjectWithPath: #('Core' 'Object') scope: (self class lookupMethod: self selector))
				hash!

testHome
	| subject |
	subject := self newSubjectWithPath: #(#OpcodePool 'Nop').
	self assert: subject home identicalTo: Smalltalk.
	subject := self subjectClass path: #('Nop') home: OpcodePool.
	self assert: subject isImmutable.
	self assert: subject home identicalTo: OpcodePool.
	subject := self subjectClass path: #(#Object) home: self class.
	self assert: subject home identicalTo: self class environment!

testIsLiteralInScope
	| subject |
	subject := self newSubjectWithPath: #(#Object) scope: Core.
	self deny: subject isLiteral.
	subject := self newSubjectWithPath: #('_' #SUnit #TestCase) scope: XProgramming.
	self deny: subject isLiteral!

testIsSelfEvaluatingInScope
	| subject |
	subject := self newSubjectWithPath: #(#Object) scope: Core.
	self deny: subject isSelfEvaluating.
	subject := self newSubjectWithPath: #('_' #SUnit #TestCase) scope: XProgramming.
	self deny: subject isSelfEvaluating!

testRefersToLiteralPoolVariable
	"A BindingReference matches literals for the same path..."

	| poolConstRef poolConst |
	"BindingRef to a pool variable."
	poolConstRef := self newSubjectWithPathString: '_PrimitiveFailureCode.AccessViolation'.
	poolConst := _PrimitiveFailureCode localBindingFor: 'AccessViolation'.
	self assert: (poolConstRef
				refersToLiteral: (self newSubjectWithPath: #(#_PrimitiveFailureCode 'AccessViolation'))).
	self assert: (poolConstRef refersToLiteral: poolConst).
	self deny: (poolConstRef refersToLiteral: poolConst value).
	"Should a BindingRef implicitly refers to refs along its path? Not entirely sure, but at the moment not"
	self deny: (poolConstRef refersToLiteral: #{Kernel._PrimitiveFailureCode}).
	#namespaceToDo.	"This should be true - a reference to a nested binding is implicitly a reference to the outer binding."
	self deny: (poolConstRef refersToLiteral: _PrimitiveFailureCode binding)!

testScope
	| subject coreRelative |
	subject := self newSubjectWithPathString: 'Object'.
	self deny: subject isRelative.
	self assert: (subject scope: nil) equals: subject.
	coreRelative := subject scope: Core.
	self deny: coreRelative equals: subject.
	self assert: coreRelative isRelative.
	self assert: coreRelative scope identicalTo: Core! !
!Kernel.Tests.ScopedBindingReferenceTest categoriesForMethods!
bindingTestCases!constants!private! !
pathTestCases!private!unit tests! !
printStringTestCases!constants!private! !
testBindingOrNilInContext!public!unit tests! !
testBindingScope!public!unit tests! !
testEnvironmentNameInScope!public!unit tests! !
testEqualsInScope!public!unit tests! !
testHashInScope!public!unit tests! !
testHome!public!unit tests! !
testIsLiteralInScope!public!unit tests! !
testIsSelfEvaluatingInScope!public!unit tests! !
testRefersToLiteralPoolVariable!public!unit tests! !
testScope!public!unit tests! !
!

