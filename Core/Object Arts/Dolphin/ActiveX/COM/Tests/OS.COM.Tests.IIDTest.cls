"Filed out from Dolphin Smalltalk"!

Core.Tests.GUIDTest
	subclass: #'OS.COM.Tests.IIDTest'
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

testDisplayStringIUknown
	| subject |
	subject := IUnknown iid.
	self assert: subject displayString equals: 'IUnknown'.
	super testDisplayString! !
!OS.COM.Tests.IIDTest categoriesForMethods!
subjectClass!constants!private! !
testDisplayStringIUknown!constants!public! !
!

