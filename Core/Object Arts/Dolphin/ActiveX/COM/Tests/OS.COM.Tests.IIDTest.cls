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

nullDisplayString
	^(RegKey classesRoot at: 'Interface\{00000000-0000-0000-0000-000000000000}'
		ifAbsent: ['{00000000-0000-0000-0000-000000000000}']) value!

subjectClass
	^IID!

testDisplayStringIUknown
	| subject |
	subject := IUnknown iid.
	self assert: subject displayString equals: 'IUnknown'! !

!OS.COM.Tests.IIDTest categoriesForMethods!
nullDisplayString!constants!private! !
subjectClass!constants!private! !
testDisplayStringIUknown!constants!public! !
!

