"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpBitmapData
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Height' -> 16r4.
		'_OffsetOf_PixelFormat' -> 16rC.
		'_OffsetOf_Reserved' -> 16r14.
		'_OffsetOf_Scan0' -> 16r10.
		'_OffsetOf_Stride' -> 16r8.
		'_OffsetOf_Width' -> 16r0
	}!
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
	"Answer the <Integer> value of the receiver's 'Height' field."

	^bytes dwordAtOffset: _OffsetOf_Height!

Height: anInteger
	"Set the receiver's 'Height' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Height put: anInteger!

PixelFormat
	"Answer the <Integer> value of the receiver's 'PixelFormat' field."

	^bytes sdwordAtOffset: _OffsetOf_PixelFormat!

PixelFormat: anInteger
	"Set the receiver's 'PixelFormat' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_PixelFormat put: anInteger!

Scan0
	"Answer the <ExternalAddress> value of the receiver's 'Scan0' field."

	^(bytes uintPtrAtOffset: _OffsetOf_Scan0) asExternalAddress!

Scan0: anExternalAddress
	"Set the receiver's 'Scan0' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_Scan0 put: anExternalAddress!

Stride
	"Answer the <Integer> value of the receiver's 'Stride' field."

	^bytes sdwordAtOffset: _OffsetOf_Stride!

Stride: anInteger
	"Set the receiver's 'Stride' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_Stride put: anInteger!

Width
	"Answer the <Integer> value of the receiver's 'Width' field."

	^bytes dwordAtOffset: _OffsetOf_Width!

Width: anInteger
	"Set the receiver's 'Width' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Width put: anInteger! !
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
	self byteSize: 24!

getFieldNames
	^#(#Width #Height #Stride #PixelFormat #Scan0)! !
!GpBitmapData class categoriesFor: #defineFields!public!template definition! !
!GpBitmapData class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

