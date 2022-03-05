"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #DTBGOPTS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFlags _OffsetOf_dwSize _OffsetOf_rcClip'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTBGOPTS guid: (GUID fromString: '{cdf611d8-4c3f-48a1-b3eb-fd222762e69b}')!
DTBGOPTS addClassConstant: '_OffsetOf_dwFlags' value: 16r4!
DTBGOPTS addClassConstant: '_OffsetOf_dwSize' value: 16r0!
DTBGOPTS addClassConstant: '_OffsetOf_rcClip' value: 16r8!
DTBGOPTS comment: '<DTBGOPTS> is an <ExternalStructure> class to wrap the struct ''Win32.DTBGOPTS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!DTBGOPTS categoriesForClass!Win32-Structs! !
!DTBGOPTS methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize
	"Answer the <Integer> value of the receiver's 'dwSize' field."

	^bytes dwordAtOffset: _OffsetOf_dwSize!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

rcClip
	"Answer the <RECT> value of the receiver's 'rcClip' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcClip!

rcClip: aRECT
	"Set the receiver's 'rcClip' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcClip + 1)
		to: ##(_OffsetOf_rcClip + RECT basicByteSize)
		startingAt: 1! !
!DTBGOPTS categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
rcClip!**compiled accessors**!public! !
rcClip:!**compiled accessors**!public! !
!

!DTBGOPTS class methodsFor!

defineFields
	"Define the fields of the DTBGOPTS structure.
		DTBGOPTS compileDefinition
	
		typedef [uuid(CDF611D8-4C3F-48A1-B3EB-FD222762E69B), helpstring('Defines the options for the DrawThemeBackgroundEx function.')]
		struct tagDTBGOPTS {
			[helpstring('size of the struct')] unsigned long dwSize;
			[helpstring('which options have been specified')] unsigned long dwFlags;
			[helpstring('clipping rectangle')] RECT rcClip;
		} DTBGOPTS;
"

	self
		defineField: #dwSize type: DWORDField new;
		defineField: #dwFlags type: DWORDField new;
		defineField: #rcClip type: (StructureField type: RECT)!

getFieldNames
	^#(#dwSize #dwFlags #rcClip)! !
!DTBGOPTS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

