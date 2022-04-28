﻿"Filed out from Dolphin Smalltalk"!

GUIDTest subclass: #IIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IIDTest guid: (GUID fromString: '{e9fe24b9-00fe-42fb-9fda-bcf25e367989}')!
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
!IIDTest categoriesForMethods!
subjectClass!constants!private! !
testDisplayString!constants!public! !
!
