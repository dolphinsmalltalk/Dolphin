"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.ChangeSet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ChangeSet guid: (Core.GUID fromString: '{8b3cd8e0-529f-484c-9897-a7f024c089a8}')!
Refactory.Browser.ChangeSet comment: ''!
!Refactory.Browser.ChangeSet categoriesForClass!Unclassified! !
!Refactory.Browser.ChangeSet methodsFor!

changed: anAspectSymbol with: aParameter
	"Allow objects to depend on the ChangeSet class instead of a particular instance 
	of ChangeSet (which may be switched using projects)."

	ChangeSet changed: anAspectSymbol with: aParameter.
	super changed: anAspectSymbol with: aParameter! !
!Refactory.Browser.ChangeSet categoriesFor: #changed:with:!public!RefactoringBrowser! !

