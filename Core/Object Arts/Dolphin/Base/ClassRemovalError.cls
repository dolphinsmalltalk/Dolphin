"Filed out from Dolphin Smalltalk X6"!

Error subclass: #ClassRemovalError
	instanceVariableNames: 'originalError '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassRemovalError guid: (GUID fromString: '{4ED2CCC0-5E2B-42A1-8BEF-A537219EFEC2}')!
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
!ClassRemovalError categoriesFor: #isResumable!public!testing! !
!ClassRemovalError categoriesFor: #originalError!accessing!public! !
!ClassRemovalError categoriesFor: #originalError:!accessing!public! !

