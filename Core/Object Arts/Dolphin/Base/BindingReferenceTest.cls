"Filed out from Dolphin Smalltalk 7"!

AbstractBindingReferenceTest subclass: #BindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BindingReferenceTest guid: (GUID fromString: '{bc0780da-05e7-464d-af4f-48755f8f8d52}')!
BindingReferenceTest comment: ''!
!BindingReferenceTest categoriesForClass!Unclassified! !
!BindingReferenceTest methodsFor!

printStringTestCases
	^#(#(#(#Object) '#{Object}') #(#(#OpcodePool #Nop) '#{OpcodePool.Nop}') #(#('A' 'B' 'C') '#{A.B.C}'))!

subjectClass
	^BindingReference!

testAsQualifiedReference
	| object |
	super testAsQualifiedReference.
	object := self subjectClass path: #(#Object).
	self assert: 'Object' asQualifiedReference equals: object.
	"Although these two binding refs would resolve to the same binding, they are not equivalent as one has a more specific path."
	self deny: 'Smalltalk.Object' asQualifiedReference equals: object.
	self assert: object asQualifiedReference identicalTo: object.
	self assert: 'Object._EventsRegister' asQualifiedReference
		equals: (self subjectClass path: #(#Object #_EventsRegister))!

testInstance
	| subject |
	subject := self newTestSubjectWithPathString: 'Object'.
	self assert: subject instance identicalTo: subject!

testIsValidGlobalName
	#('A' 'A1' 'A_' '_A' 'a' '_a' '__A_B' 'A.B' 'Abc.D' '_Abc._d' 'abc.d')
		do: [:each | self assert: (BindingReference isValidQualifiedName: each)].
	#('_' '_.' 'A.' '.A' '_A.' '_.A' '.' 'a.' '_.a' '*' '' 'A.*' '*.' 'A..B')
		do: [:each | self deny: (BindingReference isValidQualifiedName: each)]!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self newTestSubjectWithPathString: 'Core.Object'.
	b := self newTestSubjectWithPathString: 'Core.object'.
	self assert: a <= a meta.
	self deny: a <= b meta!

testMeta
	| subject meta |
	subject := self newTestSubjectWithPathString: 'Object'.
	meta := subject meta.
	self assert: subject meta isMeta.
	self assert: meta value identicalTo: Object class!

testRefersToLiteral
	"A BindingReference matches literals for the same path..."

	self assert: (Object fullyQualifiedReference refersToLiteral: (self subjectClass pathString: 'Object')).
	".. and the binding to which it would resolve ..."
	self assert: (#{Object} refersToLiteral: Object binding).
	"... but not the target value."
	self deny: (#{Object} refersToLiteral: #{Object} value).
	"BindingRef to a pool variable."
	self assert: (#{_PrimitiveFailureCode.AccessViolation}
				refersToLiteral: #{_PrimitiveFailureCode.AccessViolation}).
	self assert: (#{_PrimitiveFailureCode.AccessViolation}
				refersToLiteral: #{_PrimitiveFailureCode.AccessViolation} binding).
	"Should a BindingRef implicitly refers to refs along its path? Not sure."
	false
		ifTrue: 
			[self assert: (#{_PrimitiveFailureCode.AccessViolation} refersToLiteral: #{_PrimitiveFailureCode})].
	#todo.	"This should be true, but at present is not because bindings do not know their scope."
	false
		ifTrue: 
			[self
				assert: (#{_PrimitiveFailureCode.AccessViolation} refersToLiteral: #{_PrimitiveFailureCode} binding)]!

valueOfBinding: aVariableBinding
	^aVariableBinding value! !
!BindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!BindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!BindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!BindingReferenceTest categoriesFor: #testInstance!public!unit tests! !
!BindingReferenceTest categoriesFor: #testIsValidGlobalName!public!unit tests! !
!BindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !
!BindingReferenceTest categoriesFor: #testMeta!public!unit tests! !
!BindingReferenceTest categoriesFor: #testRefersToLiteral!public!unit tests! !
!BindingReferenceTest categoriesFor: #valueOfBinding:!helpers!private! !

