"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryClassChange subclass: #'Tools.MoveClassChange'
	instanceVariableNames: 'superclassName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MoveClassChange guid: (Core.GUID fromString: '{bc59a55b-44a6-46b0-bead-8e1fbf05e2a9}')!
Tools.MoveClassChange comment: 'DolphinMoveClassChange is a Dolphin specific class change that invokes the ClassBuilder to move a class under a new superclass.'!
!Tools.MoveClassChange categoriesForClass!Refactory-Change Objects! !
!Tools.MoveClassChange methodsFor!

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
!Tools.MoveClassChange categoriesFor: #=!comparing!public! !
!Tools.MoveClassChange categoriesFor: #asUndoOperation!converting!public! !
!Tools.MoveClassChange categoriesFor: #changeString!printing!public! !
!Tools.MoveClassChange categoriesFor: #expression!private! !
!Tools.MoveClassChange categoriesFor: #primitiveExecute!public! !
!Tools.MoveClassChange categoriesFor: #superclassName!accessing!public! !
!Tools.MoveClassChange categoriesFor: #superclassName:!accessing!public! !

!Tools.MoveClassChange class methodsFor!

move: aClass toSuperclass: superClass 
	^(self new changeClass: aClass)
		superclassName: superClass fullName;
		yourself!

moveClassNamed: aSymbol toSuperClassNamed: superSymbol 
	^(self new changeClassName: aSymbol)
		superclassName: superSymbol;
		yourself! !
!Tools.MoveClassChange class categoriesFor: #move:toSuperclass:!instance creation!public! !
!Tools.MoveClassChange class categoriesFor: #moveClassNamed:toSuperClassNamed:!instance creation!public! !

