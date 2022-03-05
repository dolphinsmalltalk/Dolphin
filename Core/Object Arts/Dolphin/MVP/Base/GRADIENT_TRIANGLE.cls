"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #GRADIENT_TRIANGLE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Vertex1 _OffsetOf_Vertex2 _OffsetOf_Vertex3'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GRADIENT_TRIANGLE guid: (GUID fromString: '{55c55d30-6be7-45da-86bb-0f8bea48586a}')!
GRADIENT_TRIANGLE addClassConstant: '_OffsetOf_Vertex1' value: 16r0!
GRADIENT_TRIANGLE addClassConstant: '_OffsetOf_Vertex2' value: 16r4!
GRADIENT_TRIANGLE addClassConstant: '_OffsetOf_Vertex3' value: 16r8!
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
	"Answer the <Integer> value of the receiver's 'Vertex1' field."

	^bytes dwordAtOffset: _OffsetOf_Vertex1!

Vertex1: anInteger
	"Set the receiver's 'Vertex1' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Vertex1 put: anInteger!

Vertex2
	"Answer the <Integer> value of the receiver's 'Vertex2' field."

	^bytes dwordAtOffset: _OffsetOf_Vertex2!

Vertex2: anInteger
	"Set the receiver's 'Vertex2' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Vertex2 put: anInteger!

Vertex3
	"Answer the <Integer> value of the receiver's 'Vertex3' field."

	^bytes dwordAtOffset: _OffsetOf_Vertex3!

Vertex3: anInteger
	"Set the receiver's 'Vertex3' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Vertex3 put: anInteger! !
!GRADIENT_TRIANGLE categoriesForMethods!
Vertex1!**compiled accessors**!public! !
Vertex1:!**compiled accessors**!public! !
Vertex2!**compiled accessors**!public! !
Vertex2:!**compiled accessors**!public! !
Vertex3!**compiled accessors**!public! !
Vertex3:!**compiled accessors**!public! !
!

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
		defineField: #Vertex3 type: DWORDField new!

getFieldNames
	^#(#Vertex1 #Vertex2 #Vertex3)! !
!GRADIENT_TRIANGLE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

