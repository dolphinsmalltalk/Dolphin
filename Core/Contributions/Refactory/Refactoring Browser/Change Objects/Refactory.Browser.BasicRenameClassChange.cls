"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange
	subclass: #'Refactory.Browser.BasicRenameClassChange'
	instanceVariableNames: 'newName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.BasicRenameClassChange guid: (Core.GUID fromString: '{dc85835a-3411-4e24-8431-aaf6173e1350}')!
Refactory.Browser.BasicRenameClassChange comment: ''!
!Refactory.Browser.BasicRenameClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.BasicRenameClassChange methodsFor!

asUndoOperation
	^self class rename: newName to: classReference asString!

changeClass
	^(self classReference bindingOrNil ifNil: [newName asQualifiedReference bindingOrNil]) value!

changeClass: aBehavior
	super changeClass: aBehavior.
	classReference := classReference instance!

changeString
	^'Rename <1d> to <2s>' << {classReference. newName}!

mutateClassDetails: aClassDetails
	aClassDetails className: newName!

newName
	^newName!

primitiveExecute
	ClassBuilder renameClass: self changeClass to: newName!

printOn: aStream
	aStream
		print: ClassBuilder;
		nextPutAll: ' renameClass: ';
		display: classReference;
		nextPutAll: ' to: ';
		print: self newName;
		nextPut: $!!!

rename: oldString to: newString
	classReference := oldString asQualifiedReference.
	newName := newString! !
!Refactory.Browser.BasicRenameClassChange categoriesForMethods!
asUndoOperation!converting!public! !
changeClass!accessing!public! !
changeClass:!accessing!public! !
changeString!printing!public! !
mutateClassDetails:!helpers!private! !
newName!accessing!public! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
rename:to:!initializing!private! !
!

!Refactory.Browser.BasicRenameClassChange class methodsFor!

rename: oldString to: newString
	^self new
		rename: oldString to: newString;
		yourself! !
!Refactory.Browser.BasicRenameClassChange class categoriesForMethods!
rename:to:!instance creation!public! !
!

