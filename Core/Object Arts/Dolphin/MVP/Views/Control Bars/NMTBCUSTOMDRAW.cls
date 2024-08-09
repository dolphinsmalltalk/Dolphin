"Filed out from Dolphin Smalltalk"!

NMCUSTOMDRAW subclass: #NMTBCUSTOMDRAW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_clrBtnFace _OffsetOf_clrBtnHighlight _OffsetOf_clrHighlightHotTrack _OffsetOf_clrMark _OffsetOf_clrText _OffsetOf_clrTextHighlight _OffsetOf_hbrLines _OffsetOf_hbrMonoDither _OffsetOf_hpenLines _OffsetOf_iListGap _OffsetOf_nHLStringBkMode _OffsetOf_nStringBkMode _OffsetOf_rcText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMTBCUSTOMDRAW guid: (GUID fromString: '{720c57fd-6d0a-49f5-bca8-648125016ddb}')!

NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrBtnFace' value: 16r48!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrBtnHighlight' value: 16r4C!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrHighlightHotTrack' value: 16r50!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrMark' value: 16r40!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrText' value: 16r3C!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_clrTextHighlight' value: 16r44!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_hbrLines' value: 16r34!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_hbrMonoDither' value: 16r30!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_hpenLines' value: 16r38!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_iListGap' value: 16r6C!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_nHLStringBkMode' value: 16r68!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_nStringBkMode' value: 16r64!
NMTBCUSTOMDRAW addClassConstant: '_OffsetOf_rcText' value: 16r54!

NMTBCUSTOMDRAW comment: '`NMTBCUSTOMDRAW` is an `External.Structure` class to wrap the struct ''Win32.NMTBCUSTOMDRAW'' from type information in the ''Win32 API'' library.

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

!NMTBCUSTOMDRAW categoriesForClass!Win32-Structs! !

!NMTBCUSTOMDRAW methodsFor!

clrBtnFace
	"Answer the <Color> value of the receiver's 'clrBtnFace' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrBtnFace)!

clrBtnFace: aColor
	"Set the receiver's 'clrBtnFace' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrBtnFace put: aColor asCOLORREF!

clrBtnHighlight
	"Answer the <Color> value of the receiver's 'clrBtnHighlight' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrBtnHighlight)!

clrBtnHighlight: aColor
	"Set the receiver's 'clrBtnHighlight' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrBtnHighlight put: aColor asCOLORREF!

clrHighlightHotTrack
	"Answer the <Color> value of the receiver's 'clrHighlightHotTrack' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrHighlightHotTrack)!

clrHighlightHotTrack: aColor
	"Set the receiver's 'clrHighlightHotTrack' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrHighlightHotTrack put: aColor asCOLORREF!

clrMark
	"Answer the <Color> value of the receiver's 'clrMark' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrMark)!

clrMark: aColor
	"Set the receiver's 'clrMark' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrMark put: aColor asCOLORREF!

clrText
	"Answer the <Color> value of the receiver's 'clrText' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrText)!

clrText: aColor
	"Set the receiver's 'clrText' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrText put: aColor asCOLORREF!

clrTextHighlight
	"Answer the <Color> value of the receiver's 'clrTextHighlight' field."

	^Color fromCOLORREF: (bytes dwordAtOffset: _OffsetOf_clrTextHighlight)!

clrTextHighlight: aColor
	"Set the receiver's 'clrTextHighlight' field to the value of the argument, aColor"

	bytes dwordAtOffset: _OffsetOf_clrTextHighlight put: aColor asCOLORREF!

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

	^bytes sdwordAtOffset: _OffsetOf_iListGap!

iListGap: anInteger
	"Set the receiver's 'iListGap' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iListGap put: anInteger!

nHLStringBkMode
	"Answer the <Integer> value of the receiver's 'nHLStringBkMode' field."

	^bytes sdwordAtOffset: _OffsetOf_nHLStringBkMode!

nHLStringBkMode: anInteger
	"Set the receiver's 'nHLStringBkMode' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_nHLStringBkMode put: anInteger!

nStringBkMode
	"Answer the <Integer> value of the receiver's 'nStringBkMode' field."

	^bytes sdwordAtOffset: _OffsetOf_nStringBkMode!

nStringBkMode: anInteger
	"Set the receiver's 'nStringBkMode' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_nStringBkMode put: anInteger!

rcText
	"Answer the <RECTL> value of the receiver's 'rcText' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcText!

rcText: aRECT
	"Set the receiver's 'rcText' field to the value of the argument, aRECTL"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcText + 1)
		to: ##(_OffsetOf_rcText + RECT byteSize)
		startingAt: 1! !

!NMTBCUSTOMDRAW categoriesForMethods!
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

!NMTBCUSTOMDRAW class methodsFor!

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
		defineField: #rcText type: (StructureField type: RECT) offset: 84;
		defineField: #nStringBkMode type: SDWORDField new offset: 100;
		defineField: #nHLStringBkMode type: SDWORDField new offset: 104;
		defineField: #iListGap type: SDWORDField new offset: 108.
	self byteSize: 112!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam #hbrMonoDither #hbrLines #hpenLines #clrText #clrMark #clrTextHighlight #clrBtnFace #clrBtnHighlight #clrHighlightHotTrack #rcText #nStringBkMode #nHLStringBkMode #iListGap)! !

!NMTBCUSTOMDRAW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

