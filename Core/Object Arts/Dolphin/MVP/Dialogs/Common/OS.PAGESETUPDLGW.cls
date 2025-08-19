"Filed out from Dolphin Smalltalk"!

OS.PrintDialogStructure
	subclass: #'OS.PAGESETUPDLGW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.PrintDialogConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_flags' -> 16r10.
			'_OffsetOf_hInstance' -> 16r3C.
			'_OffsetOf_hPageSetupTemplate' -> 16r50.
			'_OffsetOf_lCustData' -> 16r40.
			'_OffsetOf_lpfnHook' -> 16r44.
			'_OffsetOf_lpfnPagePaintHook' -> 16r48.
			'_OffsetOf_lpPageSetupTemplateName' -> 16r4C.
			'_OffsetOf_ptPaperSize' -> 16r14.
			'_OffsetOf_rtMargin' -> 16r2C.
			'_OffsetOf_rtMinMargin' -> 16r1C.
			'_PAGESETUPDLGW_Size' -> 16r54
		}!

OS.PAGESETUPDLGW guid: (Core.GUID fromString: '{c96162d4-5dd4-43d1-a305-e90d67357d91}')!

OS.PAGESETUPDLGW comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!OS.PAGESETUPDLGW categoriesForClass!IDB Goodies! !

!OS.PAGESETUPDLGW methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hookFlag
	^PSD_ENABLEPAGEPAINTHOOK!

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

margins
	^self rtMargin asRectangle!

margins: aRectangle
	self
		rtMargin: (RECTL marshal: aRectangle);
		maskIn: PSD_MARGINS!

minMargins
	^self rtMinMargin asRectangle!

minMargins: aRectangle
	self
		rtMinMargin: aRectangle;
		maskIn: PSD_MINMARGINS!

paperSize
	^self ptPaperSize asPoint!

ptPaperSize
	"Answer the <POINTL> value of the receiver's 'ptPaperSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_ptPaperSize!

ptPaperSize: aPOINTL
	"Set the receiver's 'ptPaperSize' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ptPaperSize + 1)
		to: ##(_OffsetOf_ptPaperSize + POINTL._POINTL_Size)
		startingAt: 1!

returnDefaultFlag
	^PSD_RETURNDEFAULT!

rtMargin
	"Answer the <RECTL> value of the receiver's 'rtMargin' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rtMargin!

rtMargin: aRECTL
	"Set the receiver's 'rtMargin' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rtMargin + 1)
		to: ##(_OffsetOf_rtMargin + RECTL._RECTL_Size)
		startingAt: 1!

rtMinMargin
	"Answer the <RECTL> value of the receiver's 'rtMinMargin' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rtMinMargin!

rtMinMargin: aRECTL
	"Set the receiver's 'rtMinMargin' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rtMinMargin + 1)
		to: ##(_OffsetOf_rtMinMargin + RECTL._RECTL_Size)
		startingAt: 1! !

!OS.PAGESETUPDLGW categoriesForMethods!
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hookFlag!constants!private! !
lpfnHook:!**compiled accessors**!public! !
margins!accessing!public! !
margins:!accessing!public! !
minMargins!accessing!public! !
minMargins:!accessing!public! !
paperSize!accessing!public! !
ptPaperSize!**compiled accessors**!public! !
ptPaperSize:!**compiled accessors**!public! !
returnDefaultFlag!accessing!constants!private! !
rtMargin!**compiled accessors**!public! !
rtMargin:!**compiled accessors**!public! !
rtMinMargin!**compiled accessors**!public! !
rtMinMargin:!**compiled accessors**!public! !
!

!OS.PAGESETUPDLGW class methodsFor!

byteSize
	^_PAGESETUPDLGW_Size!

defineFields
	"Define the fields of the Win32 PAGESETUPDLG structure.

		self compileDefinition

	typedef struct tagPSD { 
		DWORD lStructSize; 
		HWND hwndOwner; 
		HGLOBAL hDevMode; 
		HGLOBAL hDevNames; 
		DWORD Flags; 
		POINT ptPaperSize; 
		RECT rtMinMargin; 
		RECT rtMargin; 
		HINSTANCE hInstance; 
		LPARAM lCustData; 
		LPPAGESETUPHOOK lpfnPageSetupHook; 
		LPPAGEPAINTHOOK lpfnPagePaintHook; 
		LPCTSTR lpPageSetupTemplateName; 
		HGLOBAL hPageSetupTemplate; } PAGESETUPDLG, *LPPAGESETUPDLG; "

	super defineFields.
	self
		defineField: #flags type: UInt32Field new;
		defineField: #ptPaperSize type: (StructureField type: POINTL);
		defineField: #rtMinMargin type: (StructureField type: RECTL);
		defineField: #rtMargin type: (StructureField type: RECTL);
		defineField: #hInstance type: HANDLEField filler;
		defineField: #lCustData type: UIntPtrField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpfnPagePaintHook type: LPVOIDField filler;
		defineField: #lpPageSetupTemplateName type: (PointerField type: Utf16String) beFiller;
		defineField: #hPageSetupTemplate type: HANDLEField filler!

getFieldNames
	^#(#dwSize #hwndOwner #hDevMode #hDevNames #flags #ptPaperSize #rtMinMargin #rtMargin #lpfnHook)!

packing
	"Answer the default packing for instances of the receiver.
	This is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment
	(e.g. ints align to 32-bit boundaries), and it is the smaller of the
	packing and the natural alignment which is used to decide the
	padding necessary for the field in the structure.
	PRINTDLG is an old Win16 structure with byte packing."

	^1! !

!OS.PAGESETUPDLGW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
packing!constants!public! !
!

