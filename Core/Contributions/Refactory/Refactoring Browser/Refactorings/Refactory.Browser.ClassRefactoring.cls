"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Refactoring subclass: #'Refactory.Browser.ClassRefactoring'
	instanceVariableNames: 'className'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassRefactoring guid: (Core.GUID fromString: '{50c0a330-c04d-4855-a513-f97929846e0f}')!
Refactory.Browser.ClassRefactoring comment: ''!
!Refactory.Browser.ClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ClassRefactoring methodsFor!

className
	^className!

className: aString 
	className := aString asSymbol! !
!Refactory.Browser.ClassRefactoring categoriesFor: #className!accessing!public! !
!Refactory.Browser.ClassRefactoring categoriesFor: #className:!accessing!public! !

!Refactory.Browser.ClassRefactoring class methodsFor!

className: aName
	^self new className: aName!

model: aRBNamespace className: aName 
	^(self new)
		model: aRBNamespace;
		className: aName;
		yourself! !
!Refactory.Browser.ClassRefactoring class categoriesFor: #className:!instance creation!public! !
!Refactory.Browser.ClassRefactoring class categoriesFor: #model:className:!instance creation!public! !

