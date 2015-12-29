"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #GpPathData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpPathData guid: (GUID fromString: '{411A9CB7-6ABC-4F55-AA9A-82C7E0D44142}')!
GpPathData comment: '<GpPathData> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpPathData'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(411A9CB7-6ABC-4F55-AA9A-82C7E0D44142)]
struct tagGpPathData {
	int count;
	POINTF* points;
	BYTE* types;
} GpPathData;
'!
!GpPathData categoriesForClass!Unclassified! !
!GpPathData methodsFor!

Count
	"Answer the receiver's Count field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

Count: anObject
	"Set the receiver's Count field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

Points
	"Answer the receiver's Points field as a Smalltalk object."

	^POINTF fromAddress: (bytes sdwordAtOffset: 4)!

Points: anObject
	"Set the receiver's Points field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject yourAddress!

Types
	"Answer the receiver's Types field as a Smalltalk object."

	^BYTE fromAddress: (bytes sdwordAtOffset: 8)!

Types: anObject
	"Set the receiver's Types field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject yourAddress! !
!GpPathData categoriesFor: #Count!**compiled accessors**!public! !
!GpPathData categoriesFor: #Count:!**compiled accessors**!public! !
!GpPathData categoriesFor: #Points!**compiled accessors**!public! !
!GpPathData categoriesFor: #Points:!**compiled accessors**!public! !
!GpPathData categoriesFor: #Types!**compiled accessors**!public! !
!GpPathData categoriesFor: #Types:!**compiled accessors**!public! !

!GpPathData class methodsFor!

defineFields
	"Define the fields of the GpPathData structure.
		GpPathData compileDefinition
	
		typedef [uuid(411A9CB7-6ABC-4F55-AA9A-82C7E0D44142)]
		struct tagGpPathData {
			int Count;
			POINTF* Points;
			BYTE* Types;
		} GpPathData;
"

	self
		defineField: #Count type: SDWORDField new offset: 0;
		defineField: #Points type: (PointerField type: POINTF) offset: 4;
		defineField: #Types type: (PointerField type: BYTE) offset: 8.
	self byteSize: 12! !
!GpPathData class categoriesFor: #defineFields!**auto generated**!initializing!public! !

