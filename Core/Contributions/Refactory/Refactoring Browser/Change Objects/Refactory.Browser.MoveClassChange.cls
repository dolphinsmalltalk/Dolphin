"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange subclass: #'Refactory.Browser.MoveClassChange'
	instanceVariableNames: 'superclassName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.MoveClassChange guid: (Core.GUID fromString: '{bc59a55b-44a6-46b0-bead-8e1fbf05e2a9}')!
Refactory.Browser.MoveClassChange comment: 'DolphinMoveClassChange is a Dolphin specific class change that invokes the ClassBuilder to move a class under a new superclass.'!
!Refactory.Browser.MoveClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.MoveClassChange methodsFor!

= anObject 
	^super = anObject and: [anObject superclassName = superclassName]!

asUndoOperation
	^self class move: self changeClass toSuperclass: self changeClass superclass!

changeString
	^'Move <1s> under <2s>' << {self changeClassName. self superclassName}!

primitiveExecute
	ClassBuilder moveClass: self changeClass toSuperclass: superclassName asQualifiedReference value!

superclassName
	^superclassName!

superclassName: aString
	superclassName := aString! !
!Refactory.Browser.MoveClassChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!applying!private! !
superclassName!accessing!public! !
superclassName:!accessing!public! !
!

!Refactory.Browser.MoveClassChange class methodsFor!

move: aClass toSuperclass: superClass 
	^(self new changeClass: aClass)
		superclassName: superClass fullName;
		yourself!

moveClassNamed: aSymbol toSuperClassNamed: superSymbol 
	^(self new changeClassName: aSymbol)
		superclassName: superSymbol;
		yourself! !
!Refactory.Browser.MoveClassChange class categoriesForMethods!
move:toSuperclass:!instance creation!public! !
moveClassNamed:toSuperClassNamed:!instance creation!public! !
!

