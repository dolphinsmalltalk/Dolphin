"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RBStringReplacement'
	instanceVariableNames: 'startPosition stopPosition string'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBStringReplacement guid: (Core.GUID fromString: '{f2893320-1a6f-47e8-9052-eb2682fdb92c}')!
Refactory.Browser.RBStringReplacement comment: 'Private class used to represent a text replacement in the Refactoring Browser.'!
!Refactory.Browser.RBStringReplacement categoriesForClass!Kernel-Objects! !
!Refactory.Browser.RBStringReplacement methodsFor!

startPosition
	^startPosition!

startPosition: anInteger 
	startPosition := anInteger!

stopPosition
	^stopPosition!

stopPosition: anInteger 
	stopPosition := anInteger!

string
	^string!

string: aString 
	string := aString! !
!Refactory.Browser.RBStringReplacement categoriesFor: #startPosition!accessing!public! !
!Refactory.Browser.RBStringReplacement categoriesFor: #startPosition:!accessing!private! !
!Refactory.Browser.RBStringReplacement categoriesFor: #stopPosition!accessing!public! !
!Refactory.Browser.RBStringReplacement categoriesFor: #stopPosition:!accessing!private! !
!Refactory.Browser.RBStringReplacement categoriesFor: #string!accessing!public! !
!Refactory.Browser.RBStringReplacement categoriesFor: #string:!accessing!private! !

!Refactory.Browser.RBStringReplacement class methodsFor!

replaceFrom: startInteger to: stopInteger with: aString 
	^(self new)
		startPosition: startInteger;
		stopPosition: stopInteger;
		string: aString;
		yourself! !
!Refactory.Browser.RBStringReplacement class categoriesFor: #replaceFrom:to:with:!instance creation!public! !

