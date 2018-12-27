"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #FONTDESC
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FONTDESC guid: (GUID fromString: '{73f5f101-a4da-11d3-b376-080046056106}')!
FONTDESC comment: 'FONTDESC is an <ExternalStructure> class to represent the OLE structure of the same name.

FONTDESC is similar to a LOGFONT in that it represents a logical description of a Font, although in this case an OLE Font object (see IFont and IFontDisp). FONTDESC is simpler than LOGFONT, however.'!
!FONTDESC categoriesForClass!External-Data-Structured-COM! !
!FONTDESC methodsFor!

cySize
	"Answer the <Integer> value of the receiver's 'cySize' field."

	^bytes sqwordAtOffset: ##(self offsetOf: #cySize)!

cySize: anInteger
	"Set the receiver's 'cySize' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: ##(self offsetOf: #cySize) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

faceName
	"Answer the font name."

	^self lpstrName asString!

faceName: fontName
	"Set the font name stored in the receiver."

	name := fontName asUtf16String.
	self lpstrName: name!

fItalic
	"Answer the <Boolean> value of the receiver's 'fItalic' field."

	^(bytes dwordAtOffset: ##(self offsetOf: #fItalic)) asBoolean!

fItalic: aBoolean
	"Set the receiver's 'fItalic' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: ##(self offsetOf: #fItalic) put: aBoolean asParameter!

fStrikethrough
	"Answer the <Boolean> value of the receiver's 'fStrikethrough' field."

	^(bytes dwordAtOffset: ##(self offsetOf: #fStrikethrough)) asBoolean!

fStrikethrough: aBoolean
	"Set the receiver's 'fStrikethrough' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: ##(self offsetOf: #fStrikethrough) put: aBoolean asParameter!

fUnderline
	"Answer the <Boolean> value of the receiver's 'fUnderline' field."

	^(bytes dwordAtOffset: ##(self offsetOf: #fUnderline)) asBoolean!

fUnderline: aBoolean
	"Set the receiver's 'fUnderline' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: ##(self offsetOf: #fUnderline) put: aBoolean asParameter!

lpstrName
	"Answer the <Utf16String> value of the receiver's 'lpstrName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrName))!

lpstrName: anUtf16String
	"Set the receiver's 'lpstrName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrName) put: anUtf16String yourAddress!

pointSize
	"Answer the point size of the font described by the receiver."

	^(self cySize / 10000) asScaledDecimal: 4!

pointSize: points
	"Set the point size of the font described by the receiver."

	self cySize: (points * 10000) asInteger!

sCharset
	"Answer the <Integer> value of the receiver's 'sCharset' field."

	^bytes swordAtOffset: ##(self offsetOf: #sCharset)!

sCharset: anInteger
	"Set the receiver's 'sCharset' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #sCharset) put: anInteger!

sWeight
	"Answer the <Integer> value of the receiver's 'sWeight' field."

	^bytes swordAtOffset: ##(self offsetOf: #sWeight)!

sWeight: anInteger
	"Set the receiver's 'sWeight' field to the value of the argument, anInteger"

	bytes swordAtOffset: ##(self offsetOf: #sWeight) put: anInteger! !
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
!FONTDESC class categoriesFor: #defineFields!initializing!public! !
!FONTDESC class categoriesFor: #fromFont:!instance creation!public! !
!FONTDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

