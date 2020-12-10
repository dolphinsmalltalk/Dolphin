"Filed out from Dolphin Smalltalk 7"!

Tools.Tests.ClassSelectorTest subclass: #'Tools.Tests.ClassHierarchySelectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassHierarchySelectorTest guid: (Core.GUID fromString: '{92fa03e6-71b4-4ff0-8fb9-901b0058396f}')!
Tools.Tests.ClassHierarchySelectorTest comment: ''!
!Tools.Tests.ClassHierarchySelectorTest categoriesForClass!Unclassified! !
!Tools.Tests.ClassHierarchySelectorTest methodsFor!

classToTest
	^ClassHierarchySelector
!

removalOfSelectionLeaves: aClass
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	| siblings |
	siblings := aClass superclass subclasses.
	^siblings size = 1 
		ifTrue: [aClass superclass]
		ifFalse: [siblings asSortedCollection after: aClass]!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior! !
!Tools.Tests.ClassHierarchySelectorTest categoriesFor: #classToTest!helpers!private! !
!Tools.Tests.ClassHierarchySelectorTest categoriesFor: #removalOfSelectionLeaves:!helpers!private! !
!Tools.Tests.ClassHierarchySelectorTest categoriesFor: #resetSelection!helpers!private! !

