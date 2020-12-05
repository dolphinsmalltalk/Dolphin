"Filed out from Dolphin Smalltalk 7"!

Core.GUID variableByteSubclass: #'STON.Tests.UUID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.UUID guid: (Core.GUID fromString: '{ad5fb5be-d9b1-44b0-9209-6d360fd900c8}')!
STON.Tests.UUID comment: ''!
!STON.Tests.UUID categoriesForClass!Unclassified! !
!STON.Tests.UUID class methodsFor!

new
	"Answer a new unique instance of the receiver."

	^self newUnique!

nilUUID
	^self newNull! !
!STON.Tests.UUID class categoriesFor: #new!instance creation!public! !
!STON.Tests.UUID class categoriesFor: #nilUUID!public! !

