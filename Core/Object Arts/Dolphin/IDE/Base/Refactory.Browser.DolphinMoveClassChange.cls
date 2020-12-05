"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.DolphinMoveClassChange'
	instanceVariableNames: 'superclassName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.DolphinMoveClassChange guid: (Core.GUID fromString: '{bc59a55b-44a6-46b0-bead-8e1fbf05e2a9}')!
Refactory.Browser.DolphinMoveClassChange comment: 'DolphinMoveClassChange is a Dolphin specific class change that invokes the ClassBuilder to move a class under a new superclass.'!
!Refactory.Browser.DolphinMoveClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.DolphinMoveClassChange methodsFor!

= anAddClassChange 
	^super = anAddClassChange and: [anAddClassChange superclassName = superclassName]!

asUndoOperation
	^self class move: self changeClass toSuperclass: self changeClass superclass!

changeString
	^'Move <1s> under <2s>' expandMacrosWith: self changeClassName with: self superclassName!

expression
	| stream |
	stream := String writeStream.
	stream
		print: ClassBuilder;
		space.
	#moveClass:toSuperclass: keywords with: {self changeClassName. superclassName}
		do: 
			[:eachKeyword :eachArg |
			stream
				space;
				display: eachKeyword;
				space;
				display: eachArg].
	^stream contents!

primitiveExecute
	^self changeClass compilerClass evaluate: self expression logged: true!

superclassName
	^superclassName!

superclassName: aString 
	superclassName := aString asSymbol! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #expression!private! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #primitiveExecute!public! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #superclassName!accessing!public! !
!Refactory.Browser.DolphinMoveClassChange categoriesFor: #superclassName:!accessing!public! !

!Refactory.Browser.DolphinMoveClassChange class methodsFor!

move: aClass toSuperclass: superClass 
	^(self new changeClass: aClass)
		superclassName: superClass name;
		yourself!

moveClassNamed: aSymbol toSuperClassNamed: superSymbol 
	^(self new changeClassName: aSymbol)
		superclassName: superSymbol;
		yourself! !
!Refactory.Browser.DolphinMoveClassChange class categoriesFor: #move:toSuperclass:!instance creation!public! !
!Refactory.Browser.DolphinMoveClassChange class categoriesFor: #moveClassNamed:toSuperClassNamed:!instance creation!public! !

