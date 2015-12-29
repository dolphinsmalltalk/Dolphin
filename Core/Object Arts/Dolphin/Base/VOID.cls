"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #VOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VOID guid: (GUID fromString: '{3BD81EBA-D20D-4BA1-AA22-FABAE10EC3B6}')!
VOID comment: 'VOID is an <ExternalStructure> class to represent unspecified, null, or opaque types. 

VOID is only useful in pointer form, and mainly intended to provided a unified type scheme for auto-generation of structures from type libraries.'!
!VOID categoriesForClass!External-Data-Unstructured! !
!VOID class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures. VOID is of course only valid when indirected."

	^self shouldNotImplement!

new
	"Answer a new instance of the receiver.
	Implementation Note: VOID and its are intended to represent pointers
	thus a reference is always required."

	^self newPointer! !
!VOID class categoriesFor: #fieldType!constants!development!private! !
!VOID class categoriesFor: #new!instance creation!public! !

