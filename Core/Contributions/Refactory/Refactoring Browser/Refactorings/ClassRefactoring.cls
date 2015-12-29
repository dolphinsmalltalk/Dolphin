"Filed out from Dolphin Smalltalk X6"!

Refactoring subclass: #ClassRefactoring
	instanceVariableNames: 'className'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassRefactoring guid: (GUID fromString: '{50C0A330-C04D-4855-A513-F97929846E0F}')!
ClassRefactoring comment: ''!
!ClassRefactoring categoriesForClass!Refactory-Refactorings! !
!ClassRefactoring methodsFor!

className
	^className!

className: aString 
	className := aString asSymbol! !
!ClassRefactoring categoriesFor: #className!accessing!public! !
!ClassRefactoring categoriesFor: #className:!accessing!public! !

!ClassRefactoring class methodsFor!

className: aName
	^self new className: aName!

model: aRBNamespace className: aName 
	^(self new)
		model: aRBNamespace;
		className: aName;
		yourself! !
!ClassRefactoring class categoriesFor: #className:!instance creation!public! !
!ClassRefactoring class categoriesFor: #model:className:!instance creation!public! !

