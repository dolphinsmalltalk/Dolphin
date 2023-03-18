"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.ColorPalette'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_ColorPalette_Size' -> 16rC.
		'_OffsetOf_Count' -> 16r4.
		'_OffsetOf_Entries' -> 16r8.
		'_OffsetOf_Flags' -> 16r0
	}!
Graphics.Gdiplus.ColorPalette guid: (Core.GUID fromString: '{585419f2-d5ab-4e85-bf56-56d115cbe7b2}')!
Graphics.Gdiplus.ColorPalette comment: '<GpColorPalette> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorPalette'' from type information in the ''GDI+ Library 1.0'' library.

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
!Graphics.Gdiplus.ColorPalette methodsFor!

asArray
	^self Entries!

byteSize
	"Same approach as BITMAPINFO>>byteSize."

	^super byteSize + ((self Count - 1) * 4)!

Count
	"Answer the <Integer> value of the receiver's 'Count' field."

	^bytes uint32AtOffset: _OffsetOf_Count!

Count: anInteger
	"Set the receiver's 'Count' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Count put: anInteger!

Entries
	"Answer the <ARGBArray> value of the receiver's 'Entries' field."

	^ARGBArray fromAddress: bytes yourAddress + _OffsetOf_Entries length: self Count!

Entries: anARGBArray
	"Set the receiver's 'Entries' field to the value of the argument, anARGBArray"

	| size |
	size := anARGBArray byteSize.
	anARGBArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Entries + 1)
		to: _OffsetOf_Entries + size
		startingAt: 1.
	self Count: anARGBArray size!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes uint32AtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags put: anInteger! !
!Graphics.Gdiplus.ColorPalette categoriesForMethods!
asArray!converting!public! !
byteSize!accessing!public! !
Count!**compiled accessors**!public! !
Count:!**compiled accessors**!public! !
Entries!**compiled accessors**!public! !
Entries:!**compiled accessors**!public! !
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.ColorPalette class methodsFor!

byteSize
	^_ColorPalette_Size!

defineFields
	"Define the fields of the ColorPalette structure.

	ColorPalette compileDefinition

		typedef [uuid(585419f2-d5ab-4e85-bf56-56d115cbe7b2)]
		struct tagColorPalette {
			[helpstring('Palette flags')] unsigned int Flags;
			[helpstring('Number of color entries')] unsigned int Count;
			[size_is('Count')] ARGB Entries[1];
		} ColorPalette;
"

	self
		defineField: #Flags type: UInt32Field new offset: 0;
		defineField: #Count type: UInt32Field new offset: 4;
		defineField: #Entries type: (ArrayField type: ARGBArray lengthField: #Count) offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#Flags #Count #Entries)! !
!Graphics.Gdiplus.ColorPalette class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

