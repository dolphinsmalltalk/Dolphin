"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #FONTDESC
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FONTDESC guid: (GUID fromString: '{73F5F101-A4DA-11D3-B376-080046056106}')!
FONTDESC comment: 'FONTDESC is an <ExternalStructure> class to represent the OLE structure of the same name.

FONTDESC is similar to a LOGFONT in that it represents a logical description of a Font, although in this case an OLE Font object (see IFont and IFontDisp). FONTDESC is simpler than LOGFONT, however.'!
!FONTDESC categoriesForClass!External-Data-Structured-COM! !
!FONTDESC methodsFor!

cySize
	"Answer the receiver's cySize field as a Smalltalk object."

	^bytes sqwordAtOffset: ##(self offsetOf: #cySize)!

cySize: anObject 
	"Set the receiver's cySize field to the value of anObject."

	bytes sqwordAtOffset: ##(self offsetOf: #cySize) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

faceName
	"Answer the font name."

	^self lpstrName asString!

faceName: fontName
	"Set the font name stored in the receiver."

	name := fontName asUnicodeString.
	self lpstrName: name!

fItalic
	"Answer the receiver's fItalic field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fItalic)) asBoolean!

fItalic: anObject 
	"Set the receiver's fItalic field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fItalic) put: anObject asParameter!

fStrikethrough
	"Answer the receiver's fStrikethrough field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fStrikethrough)) asBoolean!

fStrikethrough: anObject 
	"Set the receiver's fStrikethrough field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fStrikethrough) put: anObject asParameter!

fUnderline
	"Answer the receiver's fUnderline field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fUnderline)) asBoolean!

fUnderline: anObject 
	"Set the receiver's fUnderline field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fUnderline) put: anObject asParameter!

lpstrName
	"Answer the receiver's lpstrName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrName))!

lpstrName: anObject 
	"Set the receiver's lpstrName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrName) put: anObject yourAddress!

pointSize
	"Answer the point size of the font described by the receiver."

	^(self cySize / 10000) asScaledDecimal: 4!

pointSize: points
	"Set the point size of the font described by the receiver."

	self cySize: (points * 10000) asInteger!

sCharset
	"Answer the receiver's sCharset field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #sCharset)!

sCharset: anObject 
	"Set the receiver's sCharset field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #sCharset) put: anObject!

sWeight
	"Answer the receiver's sWeight field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #sWeight)!

sWeight: anObject 
	"Set the receiver's sWeight field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #sWeight) put: anObject! !
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
		defineField: #lpstrName type: (PointerField type: UnicodeString);
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
	^fd! !
!FONTDESC class categoriesFor: #defineFields!initializing!public! !
!FONTDESC class categoriesFor: #fromFont:!instance creation!public! !

