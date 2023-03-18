"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.BasicRenameClassChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.BasicRenameClassChangeTest guid: (Core.GUID fromString: '{daca5a98-79b1-4c67-af7c-454061a1b5f4}')!
Refactory.Browser.Tests.BasicRenameClassChangeTest comment: ''!
!Refactory.Browser.Tests.BasicRenameClassChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.BasicRenameClassChangeTest methodsFor!

subjectClass
	^BasicRenameClassChange!

testAsUndo
	| subject undo |
	subject := self subjectClass rename: 'Core.Object' to: 'Core.Foo'.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo newName equals: 'Core.Object'.
	self assert: undo classReference equals: #{Core.Foo}.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := self subjectClass rename: 'Core.Object' to: 'Core.Foo'.
	self assert: subject beforeText equals: Object definition.
	self assert: subject afterText
		equals: (Object definition copyReplaceAll: 'Core.Object' with: 'Core.Foo').
	self assert: subject changeString equals: 'Rename Core.Object to Core.Foo'.
	self assert: subject printString equals: 'ClassBuilder renameClass: Core.Object to: ''Core.Foo''!!'! !
!Refactory.Browser.Tests.BasicRenameClassChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

