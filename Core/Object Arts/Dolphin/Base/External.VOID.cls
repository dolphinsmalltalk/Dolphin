"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'External.VOID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.VOID guid: (Core.GUID fromString: '{3bd81eba-d20d-4ba1-aa22-fabae10ec3b6}')!

External.VOID comment: 'VOID is an <ExternalStructure> class to represent unspecified, null, or opaque types. 

VOID is only useful in pointer form, and mainly intended to provided a unified type scheme for auto-generation of structures from type libraries.'!

!External.VOID categoriesForClass!External-Data-Unstructured! !

!External.VOID class methodsFor!

getFieldNames
	^#()!

new
	"Answer a new instance of the receiver.
	Implementation Note: VOID and its are intended to represent pointers
	thus a reference is always required."

	^self newPointer! !

!External.VOID class categoriesForMethods!
getFieldNames!constants!private! !
new!instance creation!public! !
!

