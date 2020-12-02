"Filed out from Dolphin Smalltalk 7"!

GUID variableByteSubclass: #UUID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UUID guid: (GUID fromString: '{ad5fb5be-d9b1-44b0-9209-6d360fd900c8}')!
UUID comment: ''!
!UUID categoriesForClass!Unclassified! !
!UUID class methodsFor!

new
	"Answer a new unique instance of the receiver."

	^self newUnique!

nilUUID
	^self newNull! !
!UUID class categoriesFor: #new!instance creation!public! !
!UUID class categoriesFor: #nilUUID!public! !

