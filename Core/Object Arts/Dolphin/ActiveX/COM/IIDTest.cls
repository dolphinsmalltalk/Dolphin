"Filed out from Dolphin Smalltalk 7"!

External.Tests.GUIDTest subclass: #IIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
IIDTest guid: (Core.GUID fromString: '{e9fe24b9-00fe-42fb-9fda-bcf25e367989}')!
IIDTest comment: ''!
!IIDTest categoriesForClass!Tests-Network-UUID! !
!IIDTest methodsFor!

subjectClass
	^IID!

testDisplayString
	| subject |
	subject := IUnknown iid.
	self assert: subject displayString equals: 'IUnknown'.
	super testDisplayString! !
!IIDTest categoriesFor: #subjectClass!constants!private! !
!IIDTest categoriesFor: #testDisplayString!constants!public! !

