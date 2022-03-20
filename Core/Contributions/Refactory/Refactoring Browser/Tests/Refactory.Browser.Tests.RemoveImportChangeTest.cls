"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.RemoveImportChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveImportChangeTest guid: (Core.GUID fromString: '{1c35b060-44ef-427a-9d31-213e104939e8}')!
Refactory.Browser.Tests.RemoveImportChangeTest comment: ''!
!Refactory.Browser.Tests.RemoveImportChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveImportChangeTest methodsFor!

testAsUndo
	| subject undo |
	subject := RemoveImportChange remove: OS.Win32Constants fullyQualifiedReference from: UI.View.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: AddImportChange.
	self assert: undo variable identicalTo: subject variable.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject changeString |
	subject := RemoveImportChange remove: OS fullyQualifiedReference private from: UI.
	self assert: subject beforeText equals: UI definition.
	self assert: subject afterText
		equals: 'Kernel.Namespace subclass: #UI
	instanceVariableNames: ''''
	classVariableNames: ''''
	imports: #(#{Core} #{Graphics} #{Kernel private})
	classInstanceVariableNames: ''''
	classConstants: {}'.
	changeString := 'Remove import #{OS private} from UI'.
	self assert: subject changeString equals: changeString.
	self assert: subject printString equals: 'UI removeImport: #{OS private}!!'! !
!Refactory.Browser.Tests.RemoveImportChangeTest categoriesForMethods!
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

