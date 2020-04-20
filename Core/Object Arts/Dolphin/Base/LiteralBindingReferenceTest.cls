"Filed out from Dolphin Smalltalk 7"!

GeneralBindingReferenceTest subclass: #LiteralBindingReferenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LiteralBindingReferenceTest guid: (GUID fromString: '{4f396603-25f9-42d3-bd66-3bdbe116d51e}')!
LiteralBindingReferenceTest comment: ''!
!LiteralBindingReferenceTest categoriesForClass!Unclassified! !
!LiteralBindingReferenceTest methodsFor!

newTestSubjectWithPath: anArrayOfStrings
	^(self subjectClass path: anArrayOfStrings)
		method: Processor activeProcess topFrame sender method;
		yourself!

newTestSubjectWithPathString: aString
	^(self subjectClass pathString: aString)
		method: Processor activeProcess topFrame sender method;
		yourself!

subjectClass
	^LiteralBindingReference!

testIsLiteral
	self assert: #{Object} isLiteral!

testMethod
	self assert: #{Object} method equals: Processor activeProcess topFrame method! !
!LiteralBindingReferenceTest categoriesFor: #newTestSubjectWithPath:!helpers!private! !
!LiteralBindingReferenceTest categoriesFor: #newTestSubjectWithPathString:!helpers!private! !
!LiteralBindingReferenceTest categoriesFor: #subjectClass!constants!private! !
!LiteralBindingReferenceTest categoriesFor: #testIsLiteral!public!unit tests! !
!LiteralBindingReferenceTest categoriesFor: #testMethod!public!unit tests! !

