"Filed out from Dolphin Smalltalk"!

Refactoring subclass: #ClassRefactoring
	instanceVariableNames: 'className'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassRefactoring guid: (GUID fromString: '{50c0a330-c04d-4855-a513-f97929846e0f}')!

ClassRefactoring comment: ''!

!ClassRefactoring categoriesForClass!Refactory-Refactorings! !

!ClassRefactoring methodsFor!

className
	^className!

className: aString 
	className := aString asSymbol! !

!ClassRefactoring categoriesForMethods!
className!accessing!public! !
className:!accessing!public! !
!

!ClassRefactoring class methodsFor!

className: aName
	^self new className: aName!

model: aRBNamespace className: aName 
	^(self new)
		model: aRBNamespace;
		className: aName;
		yourself! !

!ClassRefactoring class categoriesForMethods!
className:!instance creation!public! !
model:className:!instance creation!public! !
!

