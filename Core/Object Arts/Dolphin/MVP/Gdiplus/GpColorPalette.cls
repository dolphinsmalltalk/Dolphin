"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpColorPalette
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Count _OffsetOf_Entries _OffsetOf_Flags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpColorPalette guid: (GUID fromString: '{585419f2-d5ab-4e85-bf56-56d115cbe7b2}')!

GpColorPalette addClassConstant: '_OffsetOf_Count' value: 16r4!
GpColorPalette addClassConstant: '_OffsetOf_Entries' value: 16r8!
GpColorPalette addClassConstant: '_OffsetOf_Flags' value: 16r0!

GpColorPalette comment: '<GpColorPalette> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorPalette'' from type information in the ''GDI+ Library 1.0'' library.

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

!GpColorPalette categoriesForClass!Unclassified! !

!GpColorPalette methodsFor!

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

!GpColorPalette categoriesForMethods!
Count!**compiled accessors**!public! !
Count:!**compiled accessors**!public! !
Entries!accessing!public! !
Entries:!accessing!public! !
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
!

!GpColorPalette class methodsFor!

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

!GpColorPalette class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

