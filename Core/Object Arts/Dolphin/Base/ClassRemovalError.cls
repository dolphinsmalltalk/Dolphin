"Filed out from Dolphin Smalltalk"!

Error subclass: #ClassRemovalError
	instanceVariableNames: 'originalError'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassRemovalError guid: (GUID fromString: '{4ed2ccc0-5e2b-42a1-8bef-a537219efec2}')!

ClassRemovalError comment: ''!

!ClassRemovalError categoriesForClass!System-Support! !

!ClassRemovalError methodsFor!

isResumable
	"Answer whether the receiver represents a resumable error. 
	An individual problem removing a class is not considered fatal, 
	so allow resumption to attempt so the class can be removed regardless."

	^true!

originalError
	"Answer the original <Error>, or nil if none."

	^originalError!

originalError: anError
	"Set the original <Error> which occurred when attempting to remove the class
	in the receivers tag field."

	originalError := anError! !

!ClassRemovalError categoriesForMethods!
isResumable!public!testing! !
originalError!accessing!public! !
originalError:!accessing!public! !
!

