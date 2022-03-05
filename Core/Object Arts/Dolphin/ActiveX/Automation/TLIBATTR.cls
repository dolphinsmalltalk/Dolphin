"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #TLIBATTR
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_guid _OffsetOf_lcid _OffsetOf_syskind _OffsetOf_wLibFlags _OffsetOf_wMajorVerNum _OffsetOf_wMinorVerNum'
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
TLIBATTR guid: (GUID fromString: '{c06f3b71-0868-11d3-93af-00a024ca708a}')!
TLIBATTR addClassConstant: '_OffsetOf_guid' value: 16r0!
TLIBATTR addClassConstant: '_OffsetOf_lcid' value: 16r10!
TLIBATTR addClassConstant: '_OffsetOf_syskind' value: 16r14!
TLIBATTR addClassConstant: '_OffsetOf_wLibFlags' value: 16r1C!
TLIBATTR addClassConstant: '_OffsetOf_wMajorVerNum' value: 16r18!
TLIBATTR addClassConstant: '_OffsetOf_wMinorVerNum' value: 16r1A!
TLIBATTR comment: 'TLIBATTR is an ExternalStructure class to represent the OLE Automation TLIBATTR structure.

TLIBATTR is a simple structure containing basic descriptive details about a type library, namely:
	its LIBID		(#guid)
	its locale id	(#lcid)
	its target OS id	(#syskind)
	is version		(#wMajorVerName and #wMinorVerNum)
	and some flags	(#wLibFlags)

TLIBATTR is probably only of interest for the purposes of browsing type libraries and is of no obvious use in applications.'!
!TLIBATTR categoriesForClass!External-Data-Structured-COM! !
!TLIBATTR methodsFor!

comparisonSize
	"Private - Answer the number of bytes of the receiver to use in comparisons.
	We exclude the flags and 2-bytes of padding used to pack to an 8-byte boundary.
	The former are not material to the comparison, and the latter could include any 
	old junk and therefore make the comparison fail."

	^28!

guid
	"Answer the <GUID> value of the receiver's 'guid' field."

	^GUID fromAddress: bytes yourAddress!

hasDiskImage
	"Answer whether the receiver describes a type library loaded
	from a disk image."

	^self wLibFlags anyMask: LIBFLAG_FHASDISKIMAGE!

isControl
	"Answer whether the receiver describes a type library which in turn
	describes controls. Such type libraries should only not be displayed
	in contexts where non-visual objects are required."

	^self wLibFlags anyMask: LIBFLAG_FCONTROL!

isHidden
	"Answer whether the receiver describes a hidden type library, not intended for
	display to users."

	^self wLibFlags anyMask: LIBFLAG_FHIDDEN!

isRestricted
	"Answer whether the receiver describes a type library whose use
	is restricted, and which should not, therefore, be displayed ot users."

	^self wLibFlags anyMask: LIBFLAG_FRESTRICTED!

lcid
	"Answer the <Integer> value of the receiver's 'lcid' field."

	^bytes dwordAtOffset: _OffsetOf_lcid!

version
	"Answer an N.N version string for the receiver."

	^self wMajorVerNum displayString, '.', self wMinorVerNum displayString!

wLibFlags
	"Answer the <Integer> value of the receiver's 'wLibFlags' field."

	^bytes wordAtOffset: _OffsetOf_wLibFlags!

wMajorVerNum
	"Answer the <Integer> value of the receiver's 'wMajorVerNum' field."

	^bytes wordAtOffset: _OffsetOf_wMajorVerNum!

wMinorVerNum
	"Answer the <Integer> value of the receiver's 'wMinorVerNum' field."

	^bytes wordAtOffset: _OffsetOf_wMinorVerNum! !
!TLIBATTR categoriesForMethods!
comparisonSize!accessing!private! !
guid!**compiled accessors**!public! !
hasDiskImage!public!testing! !
isControl!public!testing! !
isHidden!public!testing! !
isRestricted!public!testing! !
lcid!**compiled accessors**!public! !
version!accessing-version!public! !
wLibFlags!**compiled accessors**!public! !
wMajorVerNum!**compiled accessors**!public! !
wMinorVerNum!**compiled accessors**!public! !
!

!TLIBATTR class methodsFor!

defineFields
	"Define the fields of the TLIBATTR structure.

		TLIBATTR compileDefinition.

		struct  TLIBATTR
		{
			GUID guid;
			LCID lcid;
			SYSKIND syskind;
			WORD wMajorVerNum;
			WORD wMinorVerNum;
			WORD wLibFlags;
		};

		enum SYSKIND {
			SYS_WIN16	= 0,
			SYS_WIN32	= SYS_WIN16 + 1,
			SYS_MAC		= SYS_WIN32 + 1
		}	SYSKIND;

		enum LIBFLAGS	{
			LIBFLAG_FRESTRICTED		= 0x1,
			LIBFLAG_FCONTROL		= 0x2,
			LIBFLAG_FHIDDEN		= 0x4,
			LIBFLAG_FHASDISKIMAGE	= 0x8
		};

	"

	self
		defineField: #guid			type: (StructureField type: GUID) beReadOnly;
		defineField: #lcid				type: DWORDField readOnly;
		defineField: #syskind			type: SDWORDField filler;		"Always Win32"
		defineField: #wMajorVerNum	type: WORDField readOnly;
		defineField: #wMinorVerNum	type: WORDField readOnly;
		defineField: #wLibFlags		type: WORDField readOnly!

getFieldNames
	^#(#guid #lcid #wMajorVerNum #wMinorVerNum #wLibFlags)! !
!TLIBATTR class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

