"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #TLIBATTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
TLIBATTR guid: (GUID fromString: '{C06F3B71-0868-11D3-93AF-00A024CA708A}')!
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
	"Answer the receiver's guid field as a Smalltalk object."

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
	"Answer the receiver's lcid field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #lcid)!

version
	"Answer an N.N version string for the receiver."

	^self wMajorVerNum displayString, '.', self wMinorVerNum displayString!

wLibFlags
	"Answer the receiver's wLibFlags field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wLibFlags)!

wMajorVerNum
	"Answer the receiver's wMajorVerNum field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMajorVerNum)!

wMinorVerNum
	"Answer the receiver's wMinorVerNum field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMinorVerNum)! !
!TLIBATTR categoriesFor: #comparisonSize!accessing!private! !
!TLIBATTR categoriesFor: #guid!**compiled accessors**!public! !
!TLIBATTR categoriesFor: #hasDiskImage!public!testing! !
!TLIBATTR categoriesFor: #isControl!public!testing! !
!TLIBATTR categoriesFor: #isHidden!public!testing! !
!TLIBATTR categoriesFor: #isRestricted!public!testing! !
!TLIBATTR categoriesFor: #lcid!**compiled accessors**!public! !
!TLIBATTR categoriesFor: #version!accessing-version!public! !
!TLIBATTR categoriesFor: #wLibFlags!**compiled accessors**!public! !
!TLIBATTR categoriesFor: #wMajorVerNum!**compiled accessors**!public! !
!TLIBATTR categoriesFor: #wMinorVerNum!**compiled accessors**!public! !

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
		defineField: #wLibFlags		type: WORDField readOnly! !
!TLIBATTR class categoriesFor: #defineFields!initializing!public! !

