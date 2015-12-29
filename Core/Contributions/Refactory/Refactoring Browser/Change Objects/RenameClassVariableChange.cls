"Filed out from Dolphin Smalltalk 2000 release 5.00"!

RenameVariableChange subclass: #RenameClassVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameClassVariableChange guid: (GUID fromString: '{54E09D9C-6F1F-4089-840B-A583B258AFAC}')!
RenameClassVariableChange comment: ''!
!RenameClassVariableChange categoriesForClass!Refactory-Change Objects! !
!RenameClassVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameClassVar: oldName to: newName! !
!RenameClassVariableChange categoriesFor: #renameVariable!private! !

