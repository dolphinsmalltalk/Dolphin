"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpBitmapData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpBitmapData guid: (GUID fromString: '{8b358d63-cec7-4ae5-87c2-72d86f11e109}')!
GpBitmapData comment: '<GpBitmapData> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpBitmapData'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8B358D63-CEC7-4AE5-87C2-72D86F11E109)]
struct tagGpBitmapData {
	unsigned int width;
	unsigned int height;
	int stride;
	int PixelFormat;
	void* scan0;
	unsigned int Reserved;
} GpBitmapData;
'!
!GpBitmapData categoriesForClass!Unclassified! !
!GpBitmapData methodsFor!

Height
	"Answer the receiver's Height field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

Height: anObject
	"Set the receiver's Height field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

PixelFormat
	"Answer the receiver's PixelFormat field as a Smalltalk object."

	^(bytes sdwordAtOffset: 12)!

PixelFormat: anObject
	"Set the receiver's PixelFormat field to the value of anObject."

	bytes sdwordAtOffset: 12 put: anObject!

Scan0
	"Answer the receiver's Scan0 field as a Smalltalk object."

	^(bytes dwordAtOffset: 16) asExternalAddress!

Scan0: anObject
	"Set the receiver's Scan0 field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

Stride
	"Answer the receiver's Stride field as a Smalltalk object."

	^(bytes sdwordAtOffset: 8)!

Stride: anObject
	"Set the receiver's Stride field to the value of anObject."

	bytes sdwordAtOffset: 8 put: anObject!

Width
	"Answer the receiver's Width field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

Width: anObject
	"Set the receiver's Width field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!GpBitmapData categoriesFor: #Height!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Height:!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #PixelFormat!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #PixelFormat:!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Scan0!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Scan0:!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Stride!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Stride:!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Width!**compiled accessors**!public! !
!GpBitmapData categoriesFor: #Width:!**compiled accessors**!public! !

!GpBitmapData class methodsFor!

defineFields
	"Define the fields of the GpBitmapData structure.
		GpBitmapData compileDefinition
	
		typedef [uuid(8B358D63-CEC7-4AE5-87C2-72D86F11E109)]
		struct tagGpBitmapData {
			unsigned int Width;
			unsigned int Height;
			int Stride;
			PixelFormat PixelFormat;
			void* Scan0;
			unsigned int Reserved;
		} GpBitmapData;
"

	self
		defineField: #Width type: DWORDField new offset: 0;
		defineField: #Height type: DWORDField new offset: 4;
		defineField: #Stride type: SDWORDField new offset: 8;
		defineField: #PixelFormat type: SDWORDField new offset: 12;
		defineField: #Scan0 type: LPVOIDField new offset: 16;
		defineField: #Reserved type: DWORDField filler offset: 20.
	self byteSize: 24! !
!GpBitmapData class categoriesFor: #defineFields!initializing!public! !

