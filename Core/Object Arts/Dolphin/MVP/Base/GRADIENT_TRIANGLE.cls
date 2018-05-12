"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #GRADIENT_TRIANGLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GRADIENT_TRIANGLE guid: (GUID fromString: '{55c55d30-6be7-45da-86bb-0f8bea48586a}')!
GRADIENT_TRIANGLE comment: '<GRADIENT_TRIANGLE> is an <ExternalStructure> class to wrap the struct ''Win32.GRADIENT_TRIANGLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Specifies the index of three vertices in the pVertex array in the GradientFill function. These three vertices form one triangle."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(55C55D30-6BE7-45DA-86BB-0F8BEA48586A), helpstring("Specifies the index of three vertices in the pVertex array in the GradientFill function. These three vertices form one triangle.")]
struct tagGRADIENT_TRIANGLE {
	ULONG Vertex1;
	ULONG Vertex2;
	ULONG Vertex3;
} GRADIENT_TRIANGLE;
'!
!GRADIENT_TRIANGLE categoriesForClass!Win32-Structs! !
!GRADIENT_TRIANGLE methodsFor!

Vertex1
	"Answer the receiver's Vertex1 field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

Vertex1: anObject 
	"Set the receiver's Vertex1 field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Vertex2
	"Answer the receiver's Vertex2 field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Vertex2)!

Vertex2: anObject 
	"Set the receiver's Vertex2 field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Vertex2) put: anObject!

Vertex3
	"Answer the receiver's Vertex3 field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Vertex3)!

Vertex3: anObject 
	"Set the receiver's Vertex3 field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Vertex3) put: anObject! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex1!**compiled accessors**!public! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex1:!**compiled accessors**!public! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex2!**compiled accessors**!public! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex2:!**compiled accessors**!public! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex3!**compiled accessors**!public! !
!GRADIENT_TRIANGLE categoriesFor: #Vertex3:!**compiled accessors**!public! !

!GRADIENT_TRIANGLE class methodsFor!

defineFields
	"Define the fields of the GRADIENT_TRIANGLE structure.

	GRADIENT_TRIANGLE  compileDefinition

		typedef [uuid(55C55D30-6BE7-45DA-86BB-0F8BEA48586A), helpstring('Specifies the index of three vertices in the pVertex array in the GradientFill function. These three vertices form one triangle.')]
		struct tagGRADIENT_TRIANGLE {
			ULONG Vertex1;
			ULONG Vertex2;
			ULONG Vertex3;
		} GRADIENT_TRIANGLE;
"

	self
		defineField: #Vertex1 type: DWORDField new;
		defineField: #Vertex2 type: DWORDField new;
		defineField: #Vertex3 type: DWORDField new! !
!GRADIENT_TRIANGLE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

