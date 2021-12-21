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

testNewNamespaceSubclass
	subject := CreateSubclassDialog newSubclassOf: Namespace inPackage: nil.
	self assert: subject namespace equals: Root.
	self assert: subject subclassName equals: ''.
	self deny: subject canApply.
	subject subclassName: 'Root.__Namespace__'.
	self assert: subject canApply.
	self assert: subject subclassName equals: '__Namespace__'.
	subject subclassName: '__Namespace__'.
	self assert: subject subclassName equals: 'Smalltalk.__Namespace__'.
	self assert: subject canApply.
	subject namespace: Core.
	self assert: subject canApply.
	self assert: subject subclassName equals: 'Core.__Namespace__'!

testNewRootNamespaceSubclass
	subject := CreateSubclassDialog newSubclassOf: Root inPackage: nil.
	self assert: subject namespace equals: Root.
	self assert: subject subclassName equals: ''.
	self deny: subject canApply.
	subject subclassName: 'Root.__Root__'.
	self assert: subject canApply.
	self assert: subject subclassName equals: '__Root__'! !
!Tools.Tests.CreateSubclassDialogTest categoriesForMethods!
tearDown!private!running! !
testNewNamespaceSubclass!public! !
testNewRootNamespaceSubclass!public! !
!

