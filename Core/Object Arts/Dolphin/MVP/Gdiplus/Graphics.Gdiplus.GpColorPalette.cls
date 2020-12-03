"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'Graphics.Gdiplus.GpColorPalette'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Count' -> 16r4.
		'_OffsetOf_Entries' -> 16r8.
		'_OffsetOf_Flags' -> 16r0
	}!
Graphics.Gdiplus.GpColorPalette guid: (Core.GUID fromString: '{585419f2-d5ab-4e85-bf56-56d115cbe7b2}')!
Graphics.Gdiplus.GpColorPalette comment: '<GpColorPalette> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorPalette'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(585419F2-D5AB-4E85-BF56-56D115CBE7B2)]
struct tagGpColorPalette {
	unsigned int flags;
	unsigned int count;
	unsigned long Entries[1];
} GpColorPalette;
'!
!Graphics.Gdiplus.GpColorPalette categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GpColorPalette methodsFor!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes dwordAtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Count put: anInteger!

Entries
	"Answer the receiver's Entries field as a Smalltalk object."

	"Implementation Note: We must define this manually because there is no field type for a
	variable length DWORDArray."

	^DWORDArray fromAddress: bytes yourAddress + 8 length: self Count!

Entries: anObject 
	"Set the receiver's Entries field to the value of anObject."

	"Implementation Note: We must define this manually because there is no field type for a
	variable length DWORDArray."

	| size |
	size := anObject byteSize.
	anObject 
		replaceBytesOf: bytes
		from: 9
		to: 8 + size
		startingAt: 1!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Count!**compiled accessors**!public! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Count:!**compiled accessors**!public! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Entries!accessing!public! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Entries:!accessing!public! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Flags!**compiled accessors**!public! !
!Graphics.Gdiplus.GpColorPalette categoriesFor: #Flags:!**compiled accessors**!public! !

!Graphics.Gdiplus.GpColorPalette class methodsFor!

defineFields
	"Define the fields of the GpColorPalette structure.
		GpColorPalette compileDefinition
	
		typedef [uuid(585419F2-D5AB-4E85-BF56-56D115CBE7B2)]
		struct tagGpColorPalette {
			[helpstring('Palette flags')] unsigned int Flags;
			[helpstring('Number of color entries')] unsigned int Count;
			[helpstring('Palette color entries')] unsigned long Entries[1];
		} GpColorPalette;
"

	self
		defineField: #Flags
			type: DWORDField new
			offset: 0;
		defineField: #Count
			type: DWORDField new
			offset: 4;
		defineField: #Entries
			type: (ArrayField type: DWORDArray length: 1)
			offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Flags #Count #Entries)! !
!Graphics.Gdiplus.GpColorPalette class categoriesFor: #defineFields!public!template definition! !
!Graphics.Gdiplus.GpColorPalette class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

