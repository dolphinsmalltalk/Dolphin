"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #FONTDESC
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cySize' -> 16r8.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_fItalic' -> 16r14.
		'_OffsetOf_fStrikethrough' -> 16r1C.
		'_OffsetOf_fUnderline' -> 16r18.
		'_OffsetOf_lpstrName' -> 16r4.
		'_OffsetOf_sCharset' -> 16r12.
		'_OffsetOf_sWeight' -> 16r10
	}!
FONTDESC guid: (GUID fromString: '{73f5f101-a4da-11d3-b376-080046056106}')!
FONTDESC comment: 'FONTDESC is an <ExternalStructure> class to represent the OLE structure of the same name.

FONTDESC is similar to a LOGFONT in that it represents a logical description of a Font, although in this case an OLE Font object (see IFont and IFontDisp). FONTDESC is simpler than LOGFONT, however.'!
!FONTDESC categoriesForClass!External-Data-Structured-COM! !
!FONTDESC methodsFor!

cySize
	"Answer the <Integer> value of the receiver's 'cySize' field."

	^bytes sqwordAtOffset: _OffsetOf_cySize!

cySize: anInteger
	"Set the receiver's 'cySize' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: _OffsetOf_cySize put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

faceName
	"Answer the font name."

	^self lpstrName asString!

faceName: fontName
	"Set the font name stored in the receiver."

	name := fontName asUtf16String.
	self lpstrName: name!

fItalic
	"Answer the <Boolean> value of the receiver's 'fItalic' field."

	^(bytes dwordAtOffset: _OffsetOf_fItalic) asBoolean!

fItalic: aBoolean
	"Set the receiver's 'fItalic' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_fItalic put: aBoolean asParameter!

fStrikethrough
	"Answer the <Boolean> value of the receiver's 'fStrikethrough' field."

	^(bytes dwordAtOffset: _OffsetOf_fStrikethrough) asBoolean!

fStrikethrough: aBoolean
	"Set the receiver's 'fStrikethrough' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_fStrikethrough put: aBoolean asParameter!

fUnderline
	"Answer the <Boolean> value of the receiver's 'fUnderline' field."

	^(bytes dwordAtOffset: _OffsetOf_fUnderline) asBoolean!

fUnderline: aBoolean
	"Set the receiver's 'fUnderline' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_fUnderline put: aBoolean asParameter!

lpstrName
	"Answer the <Utf16String> value of the receiver's 'lpstrName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpstrName)!

lpstrName: anUtf16String
	"Set the receiver's 'lpstrName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrName put: anUtf16String yourAddress!

pointSize
	"Answer the point size of the font described by the receiver."

	^(self cySize / 10000) asScaledDecimal: 4!

pointSize: points
	"Set the point size of the font described by the receiver."

	self cySize: (points * 10000) asInteger!

sCharset
	"Answer the <Integer> value of the receiver's 'sCharset' field."

	^bytes swordAtOffset: _OffsetOf_sCharset!

sCharset: anInteger
	"Set the receiver's 'sCharset' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_sCharset put: anInteger!

sWeight
	"Answer the <Integer> value of the receiver's 'sWeight' field."

	^bytes swordAtOffset: _OffsetOf_sWeight!

sWeight: anInteger
	"Set the receiver's 'sWeight' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_sWeight put: anInteger! !
!FONTDESC categoriesFor: #cySize!**compiled accessors**!public! !
!FONTDESC categoriesFor: #cySize:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #dwSize:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #faceName!accessing!public! !
!FONTDESC categoriesFor: #faceName:!accessing!public! !
!FONTDESC categoriesFor: #fItalic!**compiled accessors**!public! !
!FONTDESC categoriesFor: #fItalic:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #fStrikethrough!**compiled accessors**!public! !
!FONTDESC categoriesFor: #fStrikethrough:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #fUnderline!**compiled accessors**!public! !
!FONTDESC categoriesFor: #fUnderline:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #lpstrName!**compiled accessors**!public! !
!FONTDESC categoriesFor: #lpstrName:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #pointSize!accessing!public! !
!FONTDESC categoriesFor: #pointSize:!accessing!public! !
!FONTDESC categoriesFor: #sCharset!**compiled accessors**!public! !
!FONTDESC categoriesFor: #sCharset:!**compiled accessors**!public! !
!FONTDESC categoriesFor: #sWeight!**compiled accessors**!public! !
!FONTDESC categoriesFor: #sWeight:!**compiled accessors**!public! !

!FONTDESC class methodsFor!

defineFields
	"Define the fields of the FONTDESC structure.

		FONTDESC compileDefinition.

		typedef struct tagFONTDESC
		{
			UINT cbSizeofstruct;
			LPOLESTR lpstrName;
			CY cySize;
			SHORT sWeight;
			SHORT sCharset;
			BOOL fItalic;
			BOOL fUnderline;
			BOOL fStrikethrough;
		} FONTDESC, FAR* LPFONTDESC;
	"

	self
		defineField: #dwSize type: DWORDField writeOnly;	"Renamed from cbSizeOfStruct"
		defineField: #lpstrName type: (PointerField type: Utf16String);
		defineField: #cySize type:  SQWORDField new;
		defineField: #sWeight type: SWORDField new;
		defineField: #sCharset type: SWORDField new;
		defineField: #fItalic type: BOOLField new;
		defineField: #fUnderline type: BOOLField new;
		defineField: #fStrikethrough type: BOOLField new
!

fromFont: font
	"Answer a new instance of the receiver populated with details from the <Font>, font."

	| lf fd |
	lf := font logFont.
	fd := self new.
	fd faceName: lf faceName.
	fd sWeight: lf lfWeight.
	fd sCharset: lf lfCharSet.
	fd fItalic: lf lfItalic.
	fd fUnderline: lf lfUnderline.
	fd fStrikethrough: lf lfStrikeOut.
	fd pointSize: font pointSize.
	^fd!

getFieldNames
	^#(#dwSize #lpstrName #cySize #sWeight #sCharset #fItalic #fUnderline #fStrikethrough)! !
!FONTDESC class categoriesFor: #defineFields!public!template definition! !
!FONTDESC class categoriesFor: #fromFont:!instance creation!public! !
!FONTDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

