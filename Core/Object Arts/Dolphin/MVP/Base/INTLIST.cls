"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #INTLIST
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INTLIST guid: (GUID fromString: '{24FFD88C-23BE-4634-A857-33EFB048F734}')!
INTLIST comment: '<INTLIST> is an <ExternalStructure> class to wrap the struct ''Win32.INTLIST'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Contains an array or list of int data items from a visual style."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(24FFD88C-23BE-4634-A857-33EFB048F734), helpstring("Contains an array or list of int data items from a visual style.")]
struct tagINTLIST {
	[helpstring("Number of values in the list (max 10).")] int iValueCount;
	[helpstring("List of integers.")] int iValues[10];
} INTLIST;
'!
!INTLIST categoriesForClass!Win32-Structs! !
!INTLIST methodsFor!

iValueCount
	"Answer the receiver's iValueCount field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

iValueCount: anObject 
	"Set the receiver's iValueCount field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

iValues
	"Answer the receiver's iValues field as a Smalltalk object."

	^SDWORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #iValues) length: self iValueCount!

iValues: anObject 
	"Set the receiver's iValues field to the value of anObject."

	| size |
	size := anObject byteSize min: self iValueCount * ##(SDWORDArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #iValues) + 1)
		to: ##(self offsetOf: #iValues) + size
		startingAt: 1! !
!INTLIST categoriesFor: #iValueCount!**compiled accessors**!public! !
!INTLIST categoriesFor: #iValueCount:!**compiled accessors**!public! !
!INTLIST categoriesFor: #iValues!**compiled accessors**!public! !
!INTLIST categoriesFor: #iValues:!**compiled accessors**!public! !

!INTLIST class methodsFor!

defineFields
	"Define the fields of the INTLIST structure.
		INTLIST compileDefinition
	
		typedef [uuid(24FFD88C-23BE-4634-A857-33EFB048F734), helpstring('Contains an array or list of int data items from a visual style.')]
		struct tagINTLIST {
			[helpstring('Number of values in the list (max 10).')] int iValueCount;
			[helpstring('List of integers.')] int iValues[10];
		} INTLIST;
"

	self
		defineField: #iValueCount type: SDWORDField new;
		defineField: #iValues type: (ConformantArrayField type: SDWORDArray length: #iValueCount)! !
!INTLIST class categoriesFor: #defineFields!initializing!public! !

