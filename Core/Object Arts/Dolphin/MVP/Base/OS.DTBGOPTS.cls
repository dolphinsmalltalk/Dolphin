"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.DTBGOPTS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_DTBGOPTS_Size' -> 16r18.
		'_OffsetOf_dwFlags' -> 16r4.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_rcClip' -> 16r8
	}!
OS.DTBGOPTS guid: (Core.GUID fromString: '{cdf611d8-4c3f-48a1-b3eb-fd222762e69b}')!
OS.DTBGOPTS comment: '<DTBGOPTS> is an <ExternalStructure> class to wrap the struct ''Win32.DTBGOPTS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Defines the options for the DrawThemeBackgroundEx function."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(CDF611D8-4C3F-48A1-B3EB-FD222762E69B), helpstring("Defines the options for the DrawThemeBackgroundEx function.")]
struct tagDTBGOPTS {
	[helpstring("size of the struct")] unsigned long dwSize;
	[helpstring("which options have been specified")] unsigned long dwFlags;
	[helpstring("clipping rectangle")] RECT rcClip;
} DTBGOPTS;
'!
!OS.DTBGOPTS categoriesForClass!Win32-Structs! !
!OS.DTBGOPTS methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize
	"Answer the <Integer> value of the receiver's 'dwSize' field."

	^bytes uint32AtOffset: _OffsetOf_dwSize!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

rcClip
	"Answer the <RECTL> value of the receiver's 'rcClip' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcClip!

rcClip: aRECTL
	"Set the receiver's 'rcClip' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcClip + 1)
		to: ##(_OffsetOf_rcClip + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.DTBGOPTS categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
rcClip!**compiled accessors**!public! !
rcClip:!**compiled accessors**!public! !
!

!OS.DTBGOPTS class methodsFor!

byteSize
	^_DTBGOPTS_Size!

defineFields
	"Define the fields of the DTBGOPTS structure.
		DTBGOPTS compileDefinition
	
		typedef [uuid(CDF611D8-4C3F-48A1-B3EB-FD222762E69B), helpstring('Defines the options for the DrawThemeBackgroundEx function.')]
		struct tagDTBGOPTS {
			[helpstring('size of the struct')] unsigned long dwSize;
			[helpstring('which options have been specified')] unsigned long dwFlags;
			[helpstring('clipping rectangle')] RECTL rcClip;
		} DTBGOPTS;
"

	self
		defineField: #dwSize type: UInt32Field new;
		defineField: #dwFlags type: UInt32Field new;
		defineField: #rcClip type: (StructureField type: RECTL)!

getFieldNames
	^#(#dwSize #dwFlags #rcClip)! !
!OS.DTBGOPTS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

