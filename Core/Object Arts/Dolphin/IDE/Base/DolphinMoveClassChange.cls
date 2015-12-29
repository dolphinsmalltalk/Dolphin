"Filed out from Dolphin Smalltalk X6"!

RefactoryClassChange subclass: #DolphinMoveClassChange
	instanceVariableNames: 'superclassName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinMoveClassChange guid: (GUID fromString: '{BC59A55B-44A6-46B0-BEAD-8E1FBF05E2A9}')!
DolphinMoveClassChange comment: 'DolphinMoveClassChange is a Dolphin specific class change that invokes the ClassBuilder to move a class under a new superclass.'!
!DolphinMoveClassChange categoriesForClass!Refactory-Change Objects! !
!DolphinMoveClassChange methodsFor!

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
	#moveClass:toSuperclass: keywords with: (Array with: self changeClassName with: superclassName)
		do: 
			[:eachKeyword :eachArg | 
			stream
				space;
				display: eachKeyword;
				space;
				display: eachArg].
	^stream contents!

initialize
	super initialize.
	isMeta := false!

primitiveExecute
	^self changeClass compilerClass evaluate: self expression logged: true!

superclassName
	^superclassName!

superclassName: aString 
	superclassName := aString asSymbol! !
!DolphinMoveClassChange categoriesFor: #=!comparing!public! !
!DolphinMoveClassChange categoriesFor: #asUndoOperation!converting!public! !
!DolphinMoveClassChange categoriesFor: #changeString!printing!public! !
!DolphinMoveClassChange categoriesFor: #expression!private! !
!DolphinMoveClassChange categoriesFor: #initialize!initialize/release!private! !
!DolphinMoveClassChange categoriesFor: #primitiveExecute!public! !
!DolphinMoveClassChange categoriesFor: #superclassName!accessing!public! !
!DolphinMoveClassChange categoriesFor: #superclassName:!accessing!public! !

!DolphinMoveClassChange class methodsFor!

move: aClass toSuperclass: superClass 
	^(self new changeClass: aClass)
		superclassName: superClass name;
		yourself!

moveClassNamed: aSymbol toSuperClassNamed: superSymbol 
	^(self new changeClassName: aSymbol)
		superclassName: superSymbol;
		yourself! !
!DolphinMoveClassChange class categoriesFor: #move:toSuperclass:!instance creation!public! !
!DolphinMoveClassChange class categoriesFor: #moveClassNamed:toSuperClassNamed:!instance creation!public! !

