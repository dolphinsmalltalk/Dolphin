"Filed out from Dolphin Smalltalk"!

Tools.Tests.ClassSelectorTest
	subclass: #'Tools.Tests.ClassHierarchySelectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassHierarchySelectorTest guid: (Core.GUID fromString: '{92fa03e6-71b4-4ff0-8fb9-901b0058396f}')!
Tools.Tests.ClassHierarchySelectorTest comment: ''!
!Tools.Tests.ClassHierarchySelectorTest methodsFor!

classToTest
	^ClassHierarchySelector
!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior! !
!Tools.Tests.ClassHierarchySelectorTest categoriesForMethods!
classToTest!helpers!private! !
resetSelection!helpers!private! !
!

