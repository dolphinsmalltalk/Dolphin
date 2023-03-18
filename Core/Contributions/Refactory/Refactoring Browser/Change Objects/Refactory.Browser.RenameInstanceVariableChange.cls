"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameVariableChange
	subclass: #'Refactory.Browser.RenameInstanceVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameInstanceVariableChange guid: (Core.GUID fromString: '{73466117-a020-41e8-864c-dbe9f25cf7a0}')!
Refactory.Browser.RenameInstanceVariableChange comment: ''!
!Refactory.Browser.RenameInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RenameInstanceVariableChange methodsFor!

renameVariable
	#rbFix.	"Added to implement this change as a rename, rather than an add, copy value, remove sequence"
	self changeClass renameInstVar: oldName to: newName! !
!Refactory.Browser.RenameInstanceVariableChange categoriesForMethods!
renameVariable!applying!private! !
!

