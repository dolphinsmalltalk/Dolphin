"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.ClassGuidChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ClassGuidChangeTest guid: (Core.GUID fromString: '{5032e332-18e7-4e74-8aa5-4846586fafda}')!
Refactory.Browser.Tests.ClassGuidChangeTest comment: ''!
!Refactory.Browser.Tests.ClassGuidChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ClassGuidChangeTest methodsFor!

testAsUndo
	| subject undo guid |
	guid := GUID newUnique.
	subject := ClassGuidChange setGuid: guid of: Object.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: ClassGuidChange.
	self assert: undo guid equals: Object guid.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject guid printString format |
	guid := GUID newUnique.
	subject := ClassGuidChange setGuid: guid of: Object.
	format := 'Core.Object guid: (Core.GUID fromString: ''<1d>'')!!'.
	self assert: subject beforeText equals: format << Object guid.
	printString := format << guid.
	self assert: subject afterText equals: printString.
	self assert: subject changeString equals: 'Set guid of Core.Object'.
	self assert: subject printString equals: printString! !
!Refactory.Browser.Tests.ClassGuidChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

