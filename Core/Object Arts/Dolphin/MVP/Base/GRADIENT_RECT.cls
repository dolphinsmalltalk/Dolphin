"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #GRADIENT_RECT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lowerRight _OffsetOf_upperLeft'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GRADIENT_RECT guid: (GUID fromString: '{01040b06-a9e6-4438-8a6b-a8502a2c7794}')!

GRADIENT_RECT addClassConstant: '_OffsetOf_lowerRight' value: 16r4!
GRADIENT_RECT addClassConstant: '_OffsetOf_upperLeft' value: 16r0!

GRADIENT_RECT comment: '<GRADIENT_RECT> is an <ExternalStructure> class to wrap the struct ''Win32.GRADIENT_RECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Specifies the index of two vertices in the pVertex array in the GradientFill function. These two vertices form the upper-left and lower-right boundaries of a rectangle."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(01040B06-A9E6-4438-8A6B-A8502A2C7794), helpstring("Specifies the index of two vertices in the pVertex array in the GradientFill function. These two vertices form the upper-left and lower-right boundaries of a rectangle.")]
struct tagGRADIENT_RECT {
	ULONG UpperLeft;
	ULONG LowerRight;
} GRADIENT_RECT;
'!

!GRADIENT_RECT categoriesForClass!Win32-Structs! !

!GRADIENT_RECT methodsFor!

lowerRight
	"Answer the <Integer> value of the receiver's 'lowerRight' field."

	^bytes dwordAtOffset: _OffsetOf_lowerRight!

lowerRight: anInteger
	"Set the receiver's 'lowerRight' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lowerRight put: anInteger!

upperLeft
	"Answer the <Integer> value of the receiver's 'upperLeft' field."

	^bytes dwordAtOffset: _OffsetOf_upperLeft!

upperLeft: anInteger
	"Set the receiver's 'upperLeft' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_upperLeft put: anInteger! !

!GRADIENT_RECT categoriesForMethods!
lowerRight!**compiled accessors**!public! !
lowerRight:!**compiled accessors**!public! !
upperLeft!**compiled accessors**!public! !
upperLeft:!**compiled accessors**!public! !
!

!GRADIENT_RECT class methodsFor!

defineFields
	"Define the fields of the GRADIENT_RECT structure.

	GRADIENT_RECT  compileDefinition

		typedef [uuid(01040B06-A9E6-4438-8A6B-A8502A2C7794), helpstring('Specifies the index of two vertices in the pVertex array in the GradientFill function. These two vertices form the upper-left and lower-right boundaries of a rectangle.')]
		struct tagGRADIENT_RECT {
			ULONG UpperLeft;
			ULONG LowerRight;
		} GRADIENT_RECT;
"

	self
		defineField: #upperLeft type: DWORDField new;
		defineField: #lowerRight type: DWORDField new!

getFieldNames
	^#(#upperLeft #lowerRight)! !

!GRADIENT_RECT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

