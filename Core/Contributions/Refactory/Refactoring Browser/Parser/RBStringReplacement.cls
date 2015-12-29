"Filed out from Dolphin Smalltalk XP 2002 release 5.02"!

Object subclass: #RBStringReplacement
	instanceVariableNames: 'startPosition stopPosition string'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBStringReplacement guid: (GUID fromString: '{F2893320-1A6F-47E8-9052-EB2682FDB92C}')!
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
!RBStringReplacement categoriesFor: #startPosition!accessing!public! !
!RBStringReplacement categoriesFor: #startPosition:!accessing!private! !
!RBStringReplacement categoriesFor: #stopPosition!accessing!public! !
!RBStringReplacement categoriesFor: #stopPosition:!accessing!private! !
!RBStringReplacement categoriesFor: #string!accessing!public! !
!RBStringReplacement categoriesFor: #string:!accessing!private! !

!RBStringReplacement class methodsFor!

replaceFrom: startInteger to: stopInteger with: aString 
	^(self new)
		startPosition: startInteger;
		stopPosition: stopInteger;
		string: aString;
		yourself! !
!RBStringReplacement class categoriesFor: #replaceFrom:to:with:!instance creation!public! !

