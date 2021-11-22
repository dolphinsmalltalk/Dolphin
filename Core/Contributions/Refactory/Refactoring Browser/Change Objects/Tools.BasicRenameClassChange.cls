"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Tools.BasicRenameClassChange'
	instanceVariableNames: 'newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.BasicRenameClassChange guid: (Core.GUID fromString: '{dc85835a-3411-4e24-8431-aaf6173e1350}')!
Tools.BasicRenameClassChange comment: ''!
!Tools.BasicRenameClassChange categoriesForClass!Refactory-Change Objects! !
!Tools.BasicRenameClassChange methodsFor!

asUndoOperation
	^self class rename: newName to: classReference asString!

changeClass: aBehavior
	super changeClass: aBehavior.
	classReference := classReference instance!

changeString
	^'Rename <1d> to <2s>' << {classReference. newName}!

newName
	^newName!

primitiveExecute
	ClassBuilder renameClass: self changeClass to: newName!

printOn: aStream
	aStream
		print: ClassBuilder;
		nextPutAll: ' renameClass: ';
		nextPutAll: self displayClassName;
		nextPutAll: ' to: ';
		print: self newName;
		nextPut: $!!!

rename: oldString to: newString
	classReference := oldString asQualifiedReference.
	newName := newString! !
!Tools.BasicRenameClassChange categoriesForMethods!
asUndoOperation!converting!public! !
changeClass:!accessing!public! !
changeString!printing!public! !
newName!public! !
primitiveExecute!accessing!public! !
printOn:!printing!public! !
rename:to:!initialize/release!initializing!private! !
!

!Tools.BasicRenameClassChange class methodsFor!

rename: oldString to: newString
	^self new
		rename: oldString to: newString;
		yourself! !
!Tools.BasicRenameClassChange class categoriesForMethods!
rename:to:!instance creation!public! !
!

