"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DTBGOPTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTBGOPTS guid: (GUID fromString: '{cdf611d8-4c3f-48a1-b3eb-fd222762e69b}')!
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

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anInteger!

dwSize
	"Answer the <Integer> value of the receiver's 'dwSize' field."

	^bytes dwordAtOffset: 0!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

rcClip
	"Answer the <RECT> value of the receiver's 'rcClip' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcClip)!

rcClip: aRECT
	"Set the receiver's 'rcClip' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcClip) + 1)
		to: ##((self offsetOf: #rcClip) + RECT basicByteSize)
		startingAt: 1! !
!DTBGOPTS categoriesFor: #dwFlags!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwFlags:!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwSize!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwSize:!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #rcClip!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #rcClip:!**compiled accessors**!public! !

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
!DTBGOPTS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!DTBGOPTS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

