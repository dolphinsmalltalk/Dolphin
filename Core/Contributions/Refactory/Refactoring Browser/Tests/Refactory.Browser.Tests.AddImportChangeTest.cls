"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.AddImportChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddImportChangeTest guid: (Core.GUID fromString: '{b586c037-4783-400e-b9dd-fb75e17a0e28}')!
Refactory.Browser.Tests.AddImportChangeTest comment: ''!
!Refactory.Browser.Tests.AddImportChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddImportChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := AddImportChange add: Tools fullyQualifiedReference private to: UI.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: RemoveImportChange.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
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
!Refactory.Browser.Tests.AddImportChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

