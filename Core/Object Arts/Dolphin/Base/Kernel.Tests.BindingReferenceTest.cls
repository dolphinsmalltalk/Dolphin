"Filed out from Dolphin Smalltalk 7"!

AbstractBindingReferenceTest subclass: #BindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BindingReferenceTest guid: (GUID fromString: '{bc0780da-05e7-464d-af4f-48755f8f8d52}')!
BindingReferenceTest comment: ''!
!BindingReferenceTest categoriesForClass!Unclassified! !
!BindingReferenceTest methodsFor!

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
	self deny: a <= b meta! !
!BindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!BindingReferenceTest categoriesFor: #testAsQualifiedReference!public! !
!BindingReferenceTest categoriesFor: #testIsValidGlobalName!public!unit tests! !
!BindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !

