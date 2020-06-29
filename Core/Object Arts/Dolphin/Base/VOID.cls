"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #VOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VOID guid: (GUID fromString: '{3bd81eba-d20d-4ba1-aa22-fabae10ec3b6}')!
VOID comment: 'VOID is an <ExternalStructure> class to represent unspecified, null, or opaque types. 

VOID is only useful in pointer form, and mainly intended to provided a unified type scheme for auto-generation of structures from type libraries.'!
!VOID categoriesForClass!External-Data-Unstructured! !
!VOID class methodsFor!

getFieldNames
	^#()!

new
	"Answer a new instance of the receiver.
	Implementation Note: VOID and its are intended to represent pointers
	thus a reference is always required."

	^self newPointer! !
!VOID class categoriesFor: #getFieldNames!constants!private! !
!VOID class categoriesFor: #new!instance creation!public! !

