"Filed out from Dolphin Smalltalk 7"!

AbstractBindingReferenceTest subclass: #MetaBindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MetaBindingReferenceTest guid: (GUID fromString: '{fd978d4f-c029-4293-a636-297a14b7fa15}')!
MetaBindingReferenceTest comment: ''!
!MetaBindingReferenceTest categoriesForClass!Unclassified! !
!MetaBindingReferenceTest methodsFor!

printStringTestCases
	^#(#(#(#Object) '#{Object class}') #(#('A' 'B' 'C') '#{A.B.C class}'))!

subjectClass
	^MetaBindingReference!

testInstance
	| inst subject |
	inst := BindingReference pathString: 'Object'.
	subject := inst meta.
	self assert: subject instance identicalTo: inst!

testLessOrEqual
	| a b |
	super testLessOrEqual.
	a := self newTestSubjectWithPathString: 'Core.Object'.
	b := self newTestSubjectWithPathString: 'Core.object'.
	self deny: a <= b instance.
	self deny: a <= b instance!

testMeta
	| subject |
	subject := self newTestSubjectWithPathString: 'Object'.
	self assert: subject meta identicalTo: subject!

testRefersToLiteral
	"A BindingReference matches literals for the same path..."

	"self assert: (Object class fullyQualifiedReference refersToLiteral: (self subjectClass pathString: 'Object'))."
	".. and the binding to which it would resolve ..."
	self assert: (#{Object class} refersToLiteral: Object binding).
	"... but not the target value."
	self deny: (#{Object class} refersToLiteral: #{Object class} value).
!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!MetaBindingReferenceTest categoriesFor: #printStringTestCases!constants!private! !
!MetaBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!MetaBindingReferenceTest categoriesFor: #testInstance!public!unit tests! !
!MetaBindingReferenceTest categoriesFor: #testLessOrEqual!public!unit tests! !
!MetaBindingReferenceTest categoriesFor: #testMeta!public!unit tests! !
!MetaBindingReferenceTest categoriesFor: #testRefersToLiteral!public!unit tests! !
!MetaBindingReferenceTest categoriesFor: #valueOfBinding:!helpers!private! !

