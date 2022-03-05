"Filed out from Dolphin Smalltalk"!

RenameVariableChange subclass: #RenameClassVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameClassVariableChange guid: (GUID fromString: '{54e09d9c-6f1f-4089-840b-a583b258afac}')!
RenameClassVariableChange comment: ''!
!RenameClassVariableChange categoriesForClass!Refactory-Change Objects! !
!RenameClassVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameClassVar: oldName to: newName! !
!RenameClassVariableChange categoriesForMethods!
renameVariable!private! !
!

