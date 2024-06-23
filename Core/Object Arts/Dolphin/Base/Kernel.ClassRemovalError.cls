"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Kernel.ClassRemovalError'
	instanceVariableNames: 'originalError'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ClassRemovalError guid: (Core.GUID fromString: '{4ed2ccc0-5e2b-42a1-8bef-a537219efec2}')!

Kernel.ClassRemovalError comment: ''!

!Kernel.ClassRemovalError categoriesForClass!System-Support! !

!Kernel.ClassRemovalError methodsFor!

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
	in the receiver's tag field."

	originalError := anError! !

!Kernel.ClassRemovalError categoriesForMethods!
isResumable!public!testing! !
originalError!accessing!public! !
originalError:!accessing!public! !
!

