"Filed out from Dolphin Smalltalk"!

Object subclass: #RBStringReplacement
	instanceVariableNames: 'startPosition stopPosition string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBStringReplacement guid: (GUID fromString: '{f2893320-1a6f-47e8-9052-eb2682fdb92c}')!

RBStringReplacement comment: 'Private class used to represent a text replacement in the Refactoring Browser.'!

!RBStringReplacement categoriesForClass!Kernel-Objects! !

!RBStringReplacement methodsFor!

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

!RBStringReplacement categoriesForMethods!
startPosition!accessing!public! !
startPosition:!accessing!private! !
stopPosition!accessing!public! !
stopPosition:!accessing!private! !
string!accessing!public! !
string:!accessing!private! !
!

!RBStringReplacement class methodsFor!

replaceFrom: startInteger to: stopInteger with: aString 
	^(self new)
		startPosition: startInteger;
		stopPosition: stopInteger;
		string: aString;
		yourself! !

!RBStringReplacement class categoriesForMethods!
replaceFrom:to:with:!instance creation!public! !
!

