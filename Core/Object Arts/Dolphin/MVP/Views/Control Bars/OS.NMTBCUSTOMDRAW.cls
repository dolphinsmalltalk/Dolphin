"Filed out from Dolphin Smalltalk"!

OS.NMCUSTOMDRAW
	subclass: #'OS.NMTBCUSTOMDRAW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NMTBCUSTOMDRAW_Size' -> 16r70.
			'_OffsetOf_clrBtnFace' -> 16r48.
			'_OffsetOf_clrBtnHighlight' -> 16r4C.
			'_OffsetOf_clrHighlightHotTrack' -> 16r50.
			'_OffsetOf_clrMark' -> 16r40.
			'_OffsetOf_clrText' -> 16r3C.
			'_OffsetOf_clrTextHighlight' -> 16r44.
			'_OffsetOf_hbrLines' -> 16r34.
			'_OffsetOf_hbrMonoDither' -> 16r30.
			'_OffsetOf_hpenLines' -> 16r38.
			'_OffsetOf_iListGap' -> 16r6C.
			'_OffsetOf_nHLStringBkMode' -> 16r68.
			'_OffsetOf_nStringBkMode' -> 16r64.
			'_OffsetOf_rcText' -> 16r54
		}!

OS.NMTBCUSTOMDRAW guid: (Core.GUID fromString: '{720c57fd-6d0a-49f5-bca8-648125016ddb}')!

OS.NMTBCUSTOMDRAW comment: '`NMTBCUSTOMDRAW` is an `External.Structure` class to wrap the struct ''Win32.NMTBCUSTOMDRAW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(720c57fd-6d0a-49f5-bca8-648125016ddb)]
struct tagNMTBCUSTOMDRAW {
	NMCUSTOMDRAW nmcd;
	wireHBRUSH hbrMonoDither;
	wireHBRUSH hbrLines;
	wireHPEN* hpenLines;
	unsigned long clrText;
	unsigned long clrMark;
	unsigned long clrTextHighlight;
	unsigned long clrBtnFace;
	unsigned long clrBtnHighlight;
	unsigned long clrHighlightHotTrack;
	RECT rcText;
	int nStringBkMode;
	int nHLStringBkMode;
	int iListGap;
} NMTBCUSTOMDRAW;
```
'!

!OS.NMTBCUSTOMDRAW categoriesForClass!Win32-Structs! !

!OS.NMTBCUSTOMDRAW methodsFor!

clrBtnFace
	"Answer the <Graphics.Color> value of the receiver's 'clrBtnFace' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrBtnFace)!

clrBtnFace: aColor
	"Set the receiver's 'clrBtnFace' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrBtnFace put: aColor asCOLORREF!

clrBtnHighlight
	"Answer the <Graphics.Color> value of the receiver's 'clrBtnHighlight' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrBtnHighlight)!

clrBtnHighlight: aColor
	"Set the receiver's 'clrBtnHighlight' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrBtnHighlight put: aColor asCOLORREF!

clrHighlightHotTrack
	"Answer the <Graphics.Color> value of the receiver's 'clrHighlightHotTrack' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrHighlightHotTrack)!

clrHighlightHotTrack: aColor
	"Set the receiver's 'clrHighlightHotTrack' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrHighlightHotTrack put: aColor asCOLORREF!

clrMark
	"Answer the <Graphics.Color> value of the receiver's 'clrMark' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrMark)!

clrMark: aColor
	"Set the receiver's 'clrMark' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrMark put: aColor asCOLORREF!

clrText
	"Answer the <Graphics.Color> value of the receiver's 'clrText' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrText)!

clrText: aColor
	"Set the receiver's 'clrText' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrText put: aColor asCOLORREF!

clrTextHighlight
	"Answer the <Graphics.Color> value of the receiver's 'clrTextHighlight' field."

	^Graphics.Color fromCOLORREF: (bytes uint32AtOffset: _OffsetOf_clrTextHighlight)!

clrTextHighlight: aColor
	"Set the receiver's 'clrTextHighlight' field to the value of the argument, aColor"

	bytes uint32AtOffset: _OffsetOf_clrTextHighlight put: aColor asCOLORREF!

hbrLines
	"Answer the <Handle> value of the receiver's 'hbrLines' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbrLines) asExternalHandle!

hbrLines: aHandle
	"Set the receiver's 'hbrLines' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbrLines put: aHandle!

hbrMonoDither
	"Answer the <Handle> value of the receiver's 'hbrMonoDither' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hbrMonoDither) asExternalHandle!

hbrMonoDither: aHandle
	"Set the receiver's 'hbrMonoDither' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hbrMonoDither put: aHandle!

hpenLines
	"Answer the <Handle> value of the receiver's 'hpenLines' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hpenLines) asExternalHandle!

hpenLines: aHandle
	"Set the receiver's 'hpenLines' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hpenLines put: aHandle!

iListGap
	"Answer the <Integer> value of the receiver's 'iListGap' field."

	^bytes int32AtOffset: _OffsetOf_iListGap!

iListGap: anInteger
	"Set the receiver's 'iListGap' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iListGap put: anInteger!

nHLStringBkMode
	"Answer the <Integer> value of the receiver's 'nHLStringBkMode' field."

	^bytes int32AtOffset: _OffsetOf_nHLStringBkMode!

nHLStringBkMode: anInteger
	"Set the receiver's 'nHLStringBkMode' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nHLStringBkMode put: anInteger!

nStringBkMode
	"Answer the <Integer> value of the receiver's 'nStringBkMode' field."

	^bytes int32AtOffset: _OffsetOf_nStringBkMode!

nStringBkMode: anInteger
	"Set the receiver's 'nStringBkMode' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_nStringBkMode put: anInteger!

rcText
	"Answer the <RECTL> value of the receiver's 'rcText' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcText!

rcText: aRECTL
	"Set the receiver's 'rcText' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcText + 1)
		to: ##(_OffsetOf_rcText + RECTL._RECTL_Size)
		startingAt: 1! !

!OS.NMTBCUSTOMDRAW categoriesForMethods!
clrBtnFace!**compiled accessors**!public! !
clrBtnFace:!**compiled accessors**!public! !
clrBtnHighlight!**compiled accessors**!public! !
clrBtnHighlight:!**compiled accessors**!public! !
clrHighlightHotTrack!**compiled accessors**!public! !
clrHighlightHotTrack:!**compiled accessors**!public! !
clrMark!**compiled accessors**!public! !
clrMark:!**compiled accessors**!public! !
clrText!**compiled accessors**!public! !
clrText:!**compiled accessors**!public! !
clrTextHighlight!**compiled accessors**!public! !
clrTextHighlight:!**compiled accessors**!public! !
hbrLines!**compiled accessors**!public! !
hbrLines:!**compiled accessors**!public! !
hbrMonoDither!**compiled accessors**!public! !
hbrMonoDither:!**compiled accessors**!public! !
hpenLines!**compiled accessors**!public! !
hpenLines:!**compiled accessors**!public! !
iListGap!**compiled accessors**!public! !
iListGap:!**compiled accessors**!public! !
nHLStringBkMode!**compiled accessors**!public! !
nHLStringBkMode:!**compiled accessors**!public! !
nStringBkMode!**compiled accessors**!public! !
nStringBkMode:!**compiled accessors**!public! !
rcText!**compiled accessors**!public! !
rcText:!**compiled accessors**!public! !
!

!OS.NMTBCUSTOMDRAW class methodsFor!

byteSize
	^_NMTBCUSTOMDRAW_Size!

defineFields
	"Define the fields of the NMTBCUSTOMDRAW structure.

	NMTBCUSTOMDRAW compileDefinition

		typedef [uuid(720c57fd-6d0a-49f5-bca8-648125016ddb)]
		struct tagNMTBCUSTOMDRAW {
			NMCUSTOMDRAW nmcd;
			HBRUSH hbrMonoDither;
			HBRUSH hbrLines;
			HPEN* hpenLines;
			unsigned long clrText;
			unsigned long clrMark;
			unsigned long clrTextHighlight;
			unsigned long clrBtnFace;
			unsigned long clrBtnHighlight;
			unsigned long clrHighlightHotTrack;
			RECT rcText;
			int nStringBkMode;
			int nHLStringBkMode;
			int iListGap;
		} NMTBCUSTOMDRAW;
"

	super defineFields.
	self
		defineField: #hbrMonoDither type: HANDLEField new offset: 48;
		defineField: #hbrLines type: HANDLEField new offset: 52;
		defineField: #hpenLines type: HANDLEField new offset: 56;
		defineField: #clrText type: COLORREFField new offset: 60;
		defineField: #clrMark type: COLORREFField new offset: 64;
		defineField: #clrTextHighlight type: COLORREFField new offset: 68;
		defineField: #clrBtnFace type: COLORREFField new offset: 72;
		defineField: #clrBtnHighlight type: COLORREFField new offset: 76;
		defineField: #clrHighlightHotTrack type: COLORREFField new offset: 80;
		defineField: #rcText type: (StructureField type: RECTL) offset: 84;
		defineField: #nStringBkMode type: Int32Field new offset: 100;
		defineField: #nHLStringBkMode type: Int32Field new offset: 104;
		defineField: #iListGap type: Int32Field new offset: 108.
	self byteSize: 112!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam #hbrMonoDither #hbrLines #hpenLines #clrText #clrMark #clrTextHighlight #clrBtnFace #clrBtnHighlight #clrHighlightHotTrack #rcText #nStringBkMode #nHLStringBkMode #iListGap)! !

!OS.NMTBCUSTOMDRAW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

