"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #GRADIENT_RECT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GRADIENT_RECT guid: (GUID fromString: '{01040b06-a9e6-4438-8a6b-a8502a2c7794}')!
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
	"Answer the receiver's lowerRight field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lowerRight)!

lowerRight: anObject 
	"Set the receiver's lowerRight field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lowerRight) put: anObject!

upperLeft
	"Answer the receiver's upperLeft field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

upperLeft: anObject 
	"Set the receiver's upperLeft field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!GRADIENT_RECT categoriesFor: #lowerRight!**compiled accessors**!public! !
!GRADIENT_RECT categoriesFor: #lowerRight:!**compiled accessors**!public! !
!GRADIENT_RECT categoriesFor: #upperLeft!**compiled accessors**!public! !
!GRADIENT_RECT categoriesFor: #upperLeft:!**compiled accessors**!public! !

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
		defineField: #lowerRight type: DWORDField new! !
!GRADIENT_RECT class categoriesFor: #defineFields!initializing!public! !

