"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ChangeSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChangeSet guid: (GUID fromString: '{8b3cd8e0-529f-484c-9897-a7f024c089a8}')!
ChangeSet comment: ''!
!ChangeSet categoriesForClass!Unclassified! !
!ChangeSet methodsFor!

changed: anAspectSymbol with: aParameter 
	"Allow objects to depend on the ChangeSet class instead of a particular instance 
	of ChangeSet (which may be switched using projects)."

	ChangeSet changed: anAspectSymbol with: aParameter.
	super changed: anAspectSymbol with: aParameter! !
!ChangeSet categoriesFor: #changed:with:!public!RefactoringBrowser! !

