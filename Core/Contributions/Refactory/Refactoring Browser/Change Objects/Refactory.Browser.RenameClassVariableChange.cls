"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameVariableChange
	subclass: #'Refactory.Browser.RenameClassVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameClassVariableChange guid: (Core.GUID fromString: '{54e09d9c-6f1f-4089-840b-a583b258afac}')!
Refactory.Browser.RenameClassVariableChange comment: ''!
!Refactory.Browser.RenameClassVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RenameClassVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameClassVar: oldName to: newName! !
!Refactory.Browser.RenameClassVariableChange categoriesForMethods!
renameVariable!applying!private! !
!

