"Filed out from Dolphin Smalltalk 2000 release 5.00"!

RenameVariableChange subclass: #RenameInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameInstanceVariableChange guid: (GUID fromString: '{73466117-A020-41E8-864C-DBE9F25CF7A0}')!
RenameInstanceVariableChange comment: ''!
!RenameInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!RenameInstanceVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameInstVar: oldName to: newName! !
!RenameInstanceVariableChange categoriesFor: #renameVariable!private! !

