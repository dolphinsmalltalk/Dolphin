"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.ClassCategoryChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ClassCategoryChangeTest guid: (Core.GUID fromString: '{8933849e-9a86-4196-b80a-e7eaec8546a5}')!
Refactory.Browser.Tests.ClassCategoryChangeTest comment: ''!
!Refactory.Browser.Tests.ClassCategoryChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ClassCategoryChangeTest methodsFor!

subjectClass
	^ClassCategoryChange!

testAsUndo
	| subject undo |
	subject := self subjectClass categorize: Object
				as: {ClassCategory name: 'Kernel-Objects'. ClassCategory name: 'Refactoring-Model'}.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo categories equals: Object categories.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject printString |
	subject := self subjectClass categorize: Object
				as: {ClassCategory name: 'Kernel-Objects'. ClassCategory name: 'Refactoring-Model'}.
	self assert: subject beforeText equals: '!!Core.Object categoriesForClass!!Kernel-Objects!! !!'.
	printString := '!!Core.Object categoriesForClass!!Kernel-Objects!!Refactoring-Model!! !!'.
	self assert: subject afterText equals: printString.
	self assert: subject changeString equals: 'Categorize Core.Object'.
	self assert: subject printString equals: printString! !
!Refactory.Browser.Tests.ClassCategoryChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

