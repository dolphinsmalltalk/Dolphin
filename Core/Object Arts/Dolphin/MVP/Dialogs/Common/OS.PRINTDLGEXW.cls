"Filed out from Dolphin Smalltalk"!

OS.PrintDialogStructure
	subclass: #'OS.PRINTDLGEXW'
	instanceVariableNames: 'printRanges callback'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwResultAction' -> 16r50.
			'_OffsetOf_ExclusionFlags' -> 16r1C.
			'_OffsetOf_flags' -> 16r14.
			'_OffsetOf_Flags2' -> 16r18.
			'_OffsetOf_hDC' -> 16r10.
			'_OffsetOf_hInstance' -> 16r38.
			'_OffsetOf_lpCallback' -> 16r40.
			'_OffsetOf_lphPropertyPages' -> 16r48.
			'_OffsetOf_lpPageRanges' -> 16r28.
			'_OffsetOf_lpPrintTemplateName' -> 16r3C.
			'_OffsetOf_nCopies' -> 16r34.
			'_OffsetOf_nMaxPage' -> 16r30.
			'_OffsetOf_nMaxPageRanges' -> 16r24.
			'_OffsetOf_nMinPage' -> 16r2C.
			'_OffsetOf_nPageRanges' -> 16r20.
			'_OffsetOf_nPropertyPages' -> 16r44.
			'_OffsetOf_nStartPage' -> 16r4C.
			'_PRINTDLGEXW_Size' -> 16r54
		}!

OS.PRINTDLGEXW guid: (Core.GUID fromString: '{46f06e70-1bb5-4b02-98ee-6ab442f3b43f}')!

OS.PRINTDLGEXW comment: '<PRINTDLGEX> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTDLGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
struct tagPRINTDLGEX {
	DWORD lStructSize;
	HWND hwndOwner;
	HGLOBAL hDevMode;
	HGLOBAL hDevNames;
	HDC HDC;
	DWORD flags;
	DWORD Flags2;
	DWORD ExclusionFlags;
	DWORD nPageRanges;
	DWORD nMaxPageRanges;
	PRINTPAGERANGE* lpPageRanges;
	DWORD nMinPage;
	DWORD nMaxPage;
	DWORD nCopies;
	HINSTANCE HINSTANCE;
	LPCSTR lpPrintTemplateName;
	IUnknown* lpCallback;
	DWORD nPropertyPages;
	HPROPSHEETPAGE* lphPropertyPages;
	DWORD nStartPage;
	DWORD dwResultAction;
} PRINTDLGEX;
'!

!OS.PRINTDLGEXW categoriesForClass!Win32-Structs! !

!OS.PRINTDLGEXW methodsFor!

basicFree
	callback free.
	callback := nil.
	^super basicFree!

disablePrintSelectionOnly
	"Disable the 'Selection' radio button, used to choose to print the selected text in the souce, e.g. because there was no selection."

	self maskIn: PD_NOSELECTION!

dwResultAction
	"Answer the <Integer> value of the receiver's 'dwResultAction' field."

	^bytes uint32AtOffset: _OffsetOf_dwResultAction!

ExclusionFlags
	"Answer the <Integer> value of the receiver's 'ExclusionFlags' field."

	^bytes uint32AtOffset: _OffsetOf_ExclusionFlags!

ExclusionFlags: anInteger
	"Set the receiver's 'ExclusionFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ExclusionFlags put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

Flags2
	"Answer the <Integer> value of the receiver's 'Flags2' field."

	^bytes uint32AtOffset: _OffsetOf_Flags2!

Flags2: anInteger
	"Set the receiver's 'Flags2' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags2 put: anInteger!

hDC
	"Answer the <Handle> value of the receiver's 'hDC' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hDC) asExternalHandle!

hDC: aHandle
	"Set the receiver's 'hDC' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hDC put: aHandle!

hInstance: aHandle
	"Set the receiver's 'hInstance' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hInstance put: aHandle!

initialize
	super initialize.
	self
		initializePrintRanges: 32;
		nStartPage: START_PAGE_GENERAL;
		nCopies: 1!

initializePrintRanges: anInteger
	printRanges := StructureArray length: anInteger elementClass: PRINTPAGERANGE.
	self
		lpPageRanges: printRanges yourAddress;
		nMaxPageRanges: printRanges size;
		nPageRanges: 0!

lpCallback: anIUnknown
	"Set the receiver's 'lpCallback' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: _OffsetOf_lpCallback put: anIUnknown yourAddress!

lpfnHook: anIUnknown
	self lpCallback: anIUnknown.
	callback := anIUnknown!

lpPageRanges: aPRINTPAGERANGE
	"Set the receiver's 'lpPageRanges' field to the value of the argument, aPRINTPAGERANGE"

	bytes uintPtrAtOffset: _OffsetOf_lpPageRanges put: aPRINTPAGERANGE yourAddress!

lpPrintTemplateName: anUtf16String
	"Set the receiver's 'lpPrintTemplateName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpPrintTemplateName put: anUtf16String yourAddress!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes uint32AtOffset: _OffsetOf_nCopies!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nCopies put: anInteger!

nMaxPage
	"Answer the <Integer> value of the receiver's 'nMaxPage' field."

	^bytes uint32AtOffset: _OffsetOf_nMaxPage!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nMaxPage put: anInteger!

nMaxPageRanges
	"Answer the <Integer> value of the receiver's 'nMaxPageRanges' field."

	^bytes uint32AtOffset: _OffsetOf_nMaxPageRanges!

nMaxPageRanges: anInteger
	"Set the receiver's 'nMaxPageRanges' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nMaxPageRanges put: anInteger!

nMinPage
	"Answer the <Integer> value of the receiver's 'nMinPage' field."

	^bytes uint32AtOffset: _OffsetOf_nMinPage!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nMinPage put: anInteger!

nPageRanges
	"Answer the <Integer> value of the receiver's 'nPageRanges' field."

	^bytes uint32AtOffset: _OffsetOf_nPageRanges!

nPageRanges: anInteger
	"Set the receiver's 'nPageRanges' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nPageRanges put: anInteger!

nStartPage: anInteger
	"Set the receiver's 'nStartPage' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nStartPage put: anInteger!

pageRange
	^self pageRanges single!

pageRange: anInterval
	self pageRanges: (anInterval isEmpty ifTrue: [#()] ifFalse: [{ anInterval }])!

pageRanges
	(self flags allMask: PD_PAGENUMS) ifFalse: [^#()].
	^(1 to: self nPageRanges) collect: 
			[:i |
			| range |
			range := printRanges at: i.
			range nFromPage to: range nToPage]!

pageRanges: aSequenceOfIntervals
	| ranges count |
	 ranges := aSequenceOfIntervals ?? #().
	count := ranges size.
	count > self nMaxPageRanges ifTrue: [self initializePrintRanges: count].
	ranges keysAndValuesDo: 
			[:i :each |
			(printRanges at: i)
				nFromPage: each start;
				nToPage: each stop].
	self nPageRanges: count.
	count == 0 ifFalse: [self maskIn: PD_PAGENUMS]!

printableRange
	^self nMinPage to: self nMaxPage!

printableRange: anInterval
	self
		nMinPage: anInterval first;
		nMaxPage: anInterval last!

rangeMode
	| flags |
	flags :=self flags.
	(flags allMask: PD_SELECTION) ifTrue: [^#selectionOnly].
	(flags allMask: PD_PAGENUMS) ifTrue: [^#pageRanges].
	(flags allMask: PD_CURRENTPAGE) ifTrue: [^#currentPage].
	^#allPages!

result
	^#(#cancel #print #apply) at: self dwResultAction + 1!

returnDefaultFlag
	^PD_RETURNDEFAULT!

shouldPrintSelectionOnly
	^self flags allMask: PD_SELECTION! !

!OS.PRINTDLGEXW categoriesForMethods!
basicFree!private!realizing/unrealizing! !
disablePrintSelectionOnly!modes!public! !
dwResultAction!**compiled accessors**!public! !
ExclusionFlags!**compiled accessors**!public! !
ExclusionFlags:!**compiled accessors**!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
Flags2!**compiled accessors**!public! !
Flags2:!**compiled accessors**!public! !
hDC!**compiled accessors**!public! !
hDC:!**compiled accessors**!public! !
hInstance:!**compiled accessors**!public! !
initialize!initializing!public! !
initializePrintRanges:!initializing!private! !
lpCallback:!**compiled accessors**!public! !
lpfnHook:!initializing!private! !
lpPageRanges:!**compiled accessors**!public! !
lpPrintTemplateName:!**compiled accessors**!public! !
nCopies!**compiled accessors**!public! !
nCopies:!**compiled accessors**!public! !
nMaxPage!**compiled accessors**!public! !
nMaxPage:!**compiled accessors**!public! !
nMaxPageRanges!**compiled accessors**!public! !
nMaxPageRanges:!**compiled accessors**!public! !
nMinPage!**compiled accessors**!public! !
nMinPage:!**compiled accessors**!public! !
nPageRanges!**compiled accessors**!public! !
nPageRanges:!**compiled accessors**!public! !
nStartPage:!**compiled accessors**!public! !
pageRange!accessing!public! !
pageRange:!accessing!public! !
pageRanges!accessing!public! !
pageRanges:!accessing!public! !
printableRange!accessing!public! !
printableRange:!accessing!public! !
rangeMode!modes!public! !
result!accessing!public! !
returnDefaultFlag!accessing!constants!private! !
shouldPrintSelectionOnly!modes!public! !
!

!OS.PRINTDLGEXW class methodsFor!

byteSize
	^_PRINTDLGEXW_Size!

defineFields
	"Define the fields of the PRINTDLGEX structure.

	self compileDefinition

		typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
		struct tagPRINTDLGEX {
			DWORD lStructSize;
			HWND hwndOwner;
			HGLOBAL hDevMode;
			HGLOBAL hDevNames;
			HDC HDC;
			DWORD flags;
			DWORD Flags2;
			DWORD ExclusionFlags;
			DWORD nPageRanges;
			DWORD nMaxPageRanges;
			PRINTPAGERANGE* lpPageRanges;
			DWORD nMinPage;
			DWORD nMaxPage;
			DWORD nCopies;
			HINSTANCE HINSTANCE;
			LPCSTR lpPrintTemplateName;
			IUnknown* lpCallback;
			DWORD nPropertyPages;
			HPROPSHEETPAGE* lphPropertyPages;
			DWORD nStartPage;
			DWORD dwResultAction;
		} PRINTDLGEX;
"

	super defineFields.
	self
		defineField: #hDC type: HANDLEField new;
		defineField: #flags type: UInt32Field new;
		defineField: #Flags2 type: UInt32Field new;
		defineField: #ExclusionFlags type: UInt32Field new;
		defineField: #nPageRanges type: UInt32Field new;
		defineField: #nMaxPageRanges type: UInt32Field new;
		defineField: #lpPageRanges type: (PointerField type: PRINTPAGERANGE) beWriteOnly;
		defineField: #nMinPage type: UInt32Field new;
		defineField: #nMaxPage type: UInt32Field new;
		defineField: #nCopies type: UInt32Field new;
		defineField: #hInstance type: HANDLEField writeOnly;
		defineField: #lpPrintTemplateName type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpCallback type: (PointerField type: COM.IUnknown) beWriteOnly;
		defineField: #nPropertyPages type: UInt32Field filler;
		defineField: #lphPropertyPages type: (PointerField type: Handle) beFiller;
		defineField: #nStartPage type: UInt32Field writeOnly;
		defineField: #dwResultAction type: UInt32Field readOnly!

getFieldNames
	^#(#dwSize #hwndOwner #hDevMode #hDevNames #hDC #flags #Flags2 #ExclusionFlags #nPageRanges #nMaxPageRanges #lpPageRanges #nMinPage #nMaxPage #nCopies #hInstance #lpPrintTemplateName #lpCallback #nStartPage #dwResultAction)! !

!OS.PRINTDLGEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

