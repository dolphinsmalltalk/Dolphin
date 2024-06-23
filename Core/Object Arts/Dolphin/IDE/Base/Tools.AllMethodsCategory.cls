"Filed out from Dolphin Smalltalk"!

Tools.VirtualMethodCategory
	subclass: #'Tools.AllMethodsCategory'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.AllMethodsCategory guid: (Core.GUID fromString: '{9f018e33-e5e0-4806-a700-6b15a55681e5}')!

Tools.AllMethodsCategory comment: 'AllMethodsCategory is a virtual method category class the dynamically generated membership of which includes all methods.

Instance Variables:
	None

Class Variables:
	None'!

!Tools.AllMethodsCategory categoriesForClass!System-Support! !

!Tools.AllMethodsCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	The 'All' methods category includes all methods!!"

	^true! !

!Tools.AllMethodsCategory categoriesForMethods!
includesMethod:!public!testing! !
!

!Tools.AllMethodsCategory class methodsFor!

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

!Tools.AllMethodsCategory class categoriesForMethods!
current!accessing!public! !
initialize!initializing!private! !
newNamed:!instance creation!private! !
uninitialize!class hierarchy-removing!private! !
!

