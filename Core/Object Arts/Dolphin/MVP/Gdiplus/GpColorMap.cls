"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpColorMap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_newColor' -> 16r4.
		'_OffsetOf_oldColor' -> 16r0
	}!
GpColorMap guid: (GUID fromString: '{16b02cc4-3683-4fdc-8bdc-c450ef3137b2}')!
GpColorMap comment: '<GpColorMap> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorMap'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(16B02CC4-3683-4FDC-8BDC-C450EF3137B2)]
struct tagGpColorMap {
	unsigned long oldColor;
	unsigned long newColor;
} GpColorMap;
'!
!GpColorMap categoriesForClass!Unclassified! !
!GpColorMap methodsFor!

newColor
	"Answer the <Integer> value of the receiver's 'newColor' field."

	^bytes dwordAtOffset: _OffsetOf_newColor!

newColor: anInteger
	"Set the receiver's 'newColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_newColor put: anInteger!

oldColor
	"Answer the <Integer> value of the receiver's 'oldColor' field."

	^bytes dwordAtOffset: _OffsetOf_oldColor!

oldColor: anInteger
	"Set the receiver's 'oldColor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_oldColor put: anInteger! !
!GpColorMap categoriesFor: #newColor!**compiled accessors**!public! !
!GpColorMap categoriesFor: #newColor:!**compiled accessors**!public! !
!GpColorMap categoriesFor: #oldColor!**compiled accessors**!public! !
!GpColorMap categoriesFor: #oldColor:!**compiled accessors**!public! !

!GpColorMap class methodsFor!

defineFields
	"Define the fields of the GpColorMap structure.
		GpColorMap compileDefinition
	
		typedef [uuid(16B02CC4-3683-4FDC-8BDC-C450EF3137B2)]
		struct tagGpColorMap {
			unsigned long oldColor;
			unsigned long newColor;
		} GpColorMap;
"

	self
		defineField: #oldColor type: DWORDField new offset: 0;
		defineField: #newColor type: DWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#oldColor #newColor)! !
!GpColorMap class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!GpColorMap class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

