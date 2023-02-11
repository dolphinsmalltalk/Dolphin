"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest
	subclass: #'Refactory.Browser.Tests.ClassImportsChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ClassImportsChangeTest guid: (Core.GUID fromString: '{f3ffdc7d-109c-4770-96c3-9b6cf396fa3a}')!
Refactory.Browser.Tests.ClassImportsChangeTest comment: ''!
!Refactory.Browser.Tests.ClassImportsChangeTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ClassImportsChangeTest methodsFor!

subjectClass
	^ClassImportsChange!

testAsUndo
	| subject undo |
	subject := self subjectClass
				import: #(#{Core} #{Graphics.Gdiplus private} #{OS private} #{Kernel private})
				into: UI.
	undo := subject asUndoOperation.
	self assert: undo isKindOf: self undoClass.
	self assert: undo imports equals: UI imports.
	self assert: undo afterText equals: subject beforeText!

testPrinting
	| subject |
	subject := ClassImportsChange
				import: #(#{Core} #{Graphics.Gdiplus private} #{OS private} #{Kernel private})
				into: UI.
	self assert: subject beforeText equals: UI definition.
	self assert: subject afterText
		equals: 'Kernel.Namespace
	subclass: #UI
	instanceVariableNames: ''''
	classVariableNames: ''''
	imports: #(#{Core} #{Graphics.Gdiplus private} #{OS private} #{Kernel private})
	classInstanceVariableNames: ''''
	classConstants: {}'.
	self assert: subject changeString equals: 'Change imports into UI'.
	self assert: subject printString
		equals: 'UI imports: #(#{Core} #{Graphics.Gdiplus private} #{OS private} #{Kernel private})!!'! !
!Refactory.Browser.Tests.ClassImportsChangeTest categoriesForMethods!
subjectClass!constants!private! !
testAsUndo!public!unit tests! !
testPrinting!public!unit tests! !
!

