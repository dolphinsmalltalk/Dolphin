"Filed out from Dolphin Smalltalk 7"!

External.Tests.GUIDTest subclass: #'OS.COM.Tests.IIDTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.IIDTest guid: (Core.GUID fromString: '{e9fe24b9-00fe-42fb-9fda-bcf25e367989}')!
OS.COM.Tests.IIDTest comment: ''!
!OS.COM.Tests.IIDTest categoriesForClass!Tests-Network-UUID! !
!OS.COM.Tests.IIDTest methodsFor!

subjectClass
	^IID!

testDisplayString
	| subject |
	subject := IUnknown iid.
	self assert: subject displayString equals: 'IUnknown'.
	super testDisplayString! !
!OS.COM.Tests.IIDTest categoriesFor: #subjectClass!constants!private! !
!OS.COM.Tests.IIDTest categoriesFor: #testDisplayString!constants!public! !

