"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Object subclass: #ChangeSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChangeSet comment: ''!

ChangeSet guid: (GUID fromString: '{8B3CD8E0-529F-484C-9897-A7F024C089A8}')!

!ChangeSet categoriesForClass!Unclassified! !
!ChangeSet methodsFor!

changed: anAspectSymbol with: aParameter 
	"Allow objects to depend on the ChangeSet class instead of a particular instance 
	of ChangeSet (which may be switched using projects)."

	ChangeSet changed: anAspectSymbol with: aParameter.
	super changed: anAspectSymbol with: aParameter! !
!ChangeSet categoriesFor: #changed:with:!public!RefactoringBrowser! !

