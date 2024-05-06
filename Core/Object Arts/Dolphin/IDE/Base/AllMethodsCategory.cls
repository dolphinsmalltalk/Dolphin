"Filed out from Dolphin Smalltalk"!

VirtualMethodCategory subclass: #AllMethodsCategory
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AllMethodsCategory guid: (GUID fromString: '{9f018e33-e5e0-4806-a700-6b15a55681e5}')!

AllMethodsCategory comment: 'AllMethodsCategory is a virtual method category class the dynamically generated membership of which includes all methods.

Instance Variables:
	None

Class Variables:
	None'!

!AllMethodsCategory categoriesForClass!System-Support! !

!AllMethodsCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	The 'All' methods category includes all methods!!"

	^true! !

!AllMethodsCategory categoriesForMethods!
includesMethod:!public!testing! !
!

!AllMethodsCategory class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^Current!

initialize
	"Private - Initialize the receiver.
		self initialize.
	"

	Current := super newNamed: 'All'!

newNamed: categoryName
	"Private - Answer a new subinstance of the receiver with the 
	<readableString> name, categoryName."

	^self shouldNotImplement!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil! !

!AllMethodsCategory class categoriesForMethods!
current!accessing!public! !
initialize!initializing!private! !
newNamed:!instance creation!private! !
uninitialize!class hierarchy-removing!private! !
!

