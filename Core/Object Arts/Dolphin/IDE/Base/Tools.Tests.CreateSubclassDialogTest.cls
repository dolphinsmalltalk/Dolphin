"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.CreateSubclassDialogTest'
	instanceVariableNames: 'subject'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.CreateSubclassDialogTest guid: (Core.GUID fromString: '{9c6a31f7-b898-43c0-a175-305e0521267d}')!
Tools.Tests.CreateSubclassDialogTest comment: ''!
!Tools.Tests.CreateSubclassDialogTest categoriesForClass!Unclassified! !
!Tools.Tests.CreateSubclassDialogTest methodsFor!

tearDown
	subject ifNotNil: [subject destroy].
	^super tearDown!

testNewRootNamespaceSubclass
	subject := CreateSubclassDialog newSubclassOf: Root inPackage: nil.
	self assert: subject namespacePresenter value equals: Root.
	self assert: subject subclassName equals: 'Root'.
	self deny: subject canApply.
	subject subclassName: 'Root.__Root__'.
	self assert: subject canApply.
	self assert: subject subclassName equals: '__Root__'! !
!Tools.Tests.CreateSubclassDialogTest categoriesForMethods!
tearDown!private!running! !
testNewRootNamespaceSubclass!public! !
!

