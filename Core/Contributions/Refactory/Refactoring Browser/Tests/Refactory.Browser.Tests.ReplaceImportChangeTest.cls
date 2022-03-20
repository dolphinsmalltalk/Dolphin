"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.ReplaceImportChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ReplaceImportChangeTest guid: (Core.GUID fromString: '{f3ffdc7d-109c-4770-96c3-9b6cf396fa3a}')!
Refactory.Browser.Tests.ReplaceImportChangeTest comment: ''!
!Refactory.Browser.Tests.ReplaceImportChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ReplaceImportChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := AddImportChange add: Tools fullyQualifiedReference private to: UI.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: RemoveImportChange.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject changeString |
	subject := AddImportChange add: Tools fullyQualifiedReference private to: UI.
	self assert: subject beforeText equals: UI definition.
	self assert: subject afterText
		equals: 'Kernel.Namespace subclass: #UI
	instanceVariableNames: ''''
	classVariableNames: ''''
	imports: #(#{Core} #{Graphics} #{OS private} #{Kernel private} #{Tools private})
	classInstanceVariableNames: ''''
	classConstants: {}'.
	self assert: subject changeString equals: 'Import #{Tools private} into UI'.
	self assert: subject printString equals: 'UI addImport: #{Tools private}!!'! !
!Refactory.Browser.Tests.ReplaceImportChangeTest categoriesForMethods!
testAsUndo!public! !
testPrinting!public! !
!

