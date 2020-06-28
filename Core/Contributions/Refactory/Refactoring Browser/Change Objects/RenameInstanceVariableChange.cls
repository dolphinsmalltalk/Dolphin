"Filed out from Dolphin Smalltalk 7"!

RenameVariableChange subclass: #RenameInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameInstanceVariableChange guid: (GUID fromString: '{73466117-a020-41e8-864c-dbe9f25cf7a0}')!
RenameInstanceVariableChange comment: ''!
!RenameInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!RenameInstanceVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameInstVar: oldName to: newName! !
!RenameInstanceVariableChange categoriesFor: #renameVariable!private! !

