"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #OUTLINETEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_otmAscent' -> 16r64.
		'_OffsetOf_otmDescent' -> 16r68.
		'_OffsetOf_otmEMSquare' -> 16r60.
		'_OffsetOf_otmFiller' -> 16r40.
		'_OffsetOf_otmfsSelection' -> 16r4C.
		'_OffsetOf_otmfsType' -> 16r50.
		'_OffsetOf_otmItalicAngle' -> 16r5C.
		'_OffsetOf_otmLineGap' -> 16r6C.
		'_OffsetOf_otmMacAscent' -> 16r88.
		'_OffsetOf_otmMacDescent' -> 16r8C.
		'_OffsetOf_otmMacLineGap' -> 16r90.
		'_OffsetOf_otmPanoseNumber' -> 16r41.
		'_OffsetOf_otmpFaceName' -> 16rCC.
		'_OffsetOf_otmpFamilyName' -> 16rC8.
		'_OffsetOf_otmpFullName' -> 16rD4.
		'_OffsetOf_otmpStyleName' -> 16rD0.
		'_OffsetOf_otmptSubscriptOffset' -> 16rA0.
		'_OffsetOf_otmptSubscriptSize' -> 16r98.
		'_OffsetOf_otmptSuperscriptOffset' -> 16rB0.
		'_OffsetOf_otmptSuperscriptSize' -> 16rA8.
		'_OffsetOf_otmrcFontBox' -> 16r78.
		'_OffsetOf_otmsCapEmHeight' -> 16r70.
		'_OffsetOf_otmsCharSlopeRise' -> 16r54.
		'_OffsetOf_otmsCharSlopeRun' -> 16r58.
		'_OffsetOf_otmsStrikeoutPosition' -> 16rBC.
		'_OffsetOf_otmsStrikeoutSize' -> 16rB8.
		'_OffsetOf_otmsUnderscorePosition' -> 16rC4.
		'_OffsetOf_otmsUnderscoreSize' -> 16rC0.
		'_OffsetOf_otmsXHeight' -> 16r74.
		'_OffsetOf_otmTextMetrics' -> 16r4.
		'_OffsetOf_otmusMinimumPPEM' -> 16r94
	}!
OUTLINETEXTMETRICW guid: (GUID fromString: '{52831a87-901f-4a84-894b-ab539352b71f}')!
OUTLINETEXTMETRICW comment: '<OUTLINETEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.OUTLINETEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.'!
!OUTLINETEXTMETRICW categoriesForClass!Win-Structs! !
!OUTLINETEXTMETRICW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

faceName
	"Answer the receiver's <readableString> font face name."
	
	^Utf16String fromAddress: bytes yourAddress + self otmpFaceName!

familyName
	"Answer the receiver's <readableString> font family name."
	
	^Utf16String fromAddress: bytes yourAddress + self otmpFamilyName!

fullName
	"Answer the receiver's <readableString> full font name."
	
	^Utf16String fromAddress: bytes yourAddress + self otmpFullName!

otmAscent
	"Answer the <Integer> value of the receiver's 'otmAscent' field."

	^bytes sdwordAtOffset: _OffsetOf_otmAscent!

otmDescent
	"Answer the <Integer> value of the receiver's 'otmDescent' field."

	^bytes sdwordAtOffset: _OffsetOf_otmDescent!

otmEMSquare
	"Answer the <Integer> value of the receiver's 'otmEMSquare' field."

	^bytes dwordAtOffset: _OffsetOf_otmEMSquare!

otmfsSelection
	"Answer the <Integer> value of the receiver's 'otmfsSelection' field."

	^bytes dwordAtOffset: _OffsetOf_otmfsSelection!

otmfsType
	"Answer the <Integer> value of the receiver's 'otmfsType' field."

	^bytes dwordAtOffset: _OffsetOf_otmfsType!

otmItalicAngle
	"Answer the <Integer> value of the receiver's 'otmItalicAngle' field."

	^bytes sdwordAtOffset: _OffsetOf_otmItalicAngle!

otmLineGap
	"Answer the <Integer> value of the receiver's 'otmLineGap' field."

	^bytes dwordAtOffset: _OffsetOf_otmLineGap!

otmMacAscent
	"Answer the <Integer> value of the receiver's 'otmMacAscent' field."

	^bytes sdwordAtOffset: _OffsetOf_otmMacAscent!

otmMacDescent
	"Answer the <Integer> value of the receiver's 'otmMacDescent' field."

	^bytes sdwordAtOffset: _OffsetOf_otmMacDescent!

otmMacLineGap
	"Answer the <Integer> value of the receiver's 'otmMacLineGap' field."

	^bytes dwordAtOffset: _OffsetOf_otmMacLineGap!

otmPanoseNumber
	"Answer the <PANOSE> value of the receiver's 'otmPanoseNumber' field."

	^PANOSE fromAddress: bytes yourAddress + _OffsetOf_otmPanoseNumber!

otmpFaceName
	"Answer the <Integer> value of the receiver's 'otmpFaceName' field."

	^bytes dwordAtOffset: _OffsetOf_otmpFaceName!

otmpFamilyName
	"Answer the <Integer> value of the receiver's 'otmpFamilyName' field."

	^bytes dwordAtOffset: _OffsetOf_otmpFamilyName!

otmpFullName
	"Answer the <Integer> value of the receiver's 'otmpFullName' field."

	^bytes dwordAtOffset: _OffsetOf_otmpFullName!

otmpStyleName
	"Answer the <Integer> value of the receiver's 'otmpStyleName' field."

	^bytes dwordAtOffset: _OffsetOf_otmpStyleName!

otmptSubscriptOffset
	"Answer the <POINTL> value of the receiver's 'otmptSubscriptOffset' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_otmptSubscriptOffset!

otmptSubscriptSize
	"Answer the <POINTL> value of the receiver's 'otmptSubscriptSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_otmptSubscriptSize!

otmptSuperscriptOffset
	"Answer the <POINTL> value of the receiver's 'otmptSuperscriptOffset' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_otmptSuperscriptOffset!

otmptSuperscriptSize
	"Answer the <POINTL> value of the receiver's 'otmptSuperscriptSize' field."

	^POINTL fromAddress: bytes yourAddress + _OffsetOf_otmptSuperscriptSize!

otmrcFontBox
	"Answer the <RECT> value of the receiver's 'otmrcFontBox' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_otmrcFontBox!

otmsCapEmHeight
	"Answer the <Integer> value of the receiver's 'otmsCapEmHeight' field."

	^bytes dwordAtOffset: _OffsetOf_otmsCapEmHeight!

otmsCharSlopeRise
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRise' field."

	^bytes sdwordAtOffset: _OffsetOf_otmsCharSlopeRise!

otmsCharSlopeRun
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRun' field."

	^bytes sdwordAtOffset: _OffsetOf_otmsCharSlopeRun!

otmsStrikeoutPosition
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutPosition' field."

	^bytes sdwordAtOffset: _OffsetOf_otmsStrikeoutPosition!

otmsStrikeoutSize
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutSize' field."

	^bytes dwordAtOffset: _OffsetOf_otmsStrikeoutSize!

otmsUnderscorePosition
	"Answer the <Integer> value of the receiver's 'otmsUnderscorePosition' field."

	^bytes sdwordAtOffset: _OffsetOf_otmsUnderscorePosition!

otmsUnderscoreSize
	"Answer the <Integer> value of the receiver's 'otmsUnderscoreSize' field."

	^bytes sdwordAtOffset: _OffsetOf_otmsUnderscoreSize!

otmsXHeight
	"Answer the <Integer> value of the receiver's 'otmsXHeight' field."

	^bytes dwordAtOffset: _OffsetOf_otmsXHeight!

otmTextMetrics
	"Answer the <TEXTMETRICW> value of the receiver's 'otmTextMetrics' field."

	^TEXTMETRICW fromAddress: bytes yourAddress + _OffsetOf_otmTextMetrics!

otmusMinimumPPEM
	"Answer the <Integer> value of the receiver's 'otmusMinimumPPEM' field."

	^bytes dwordAtOffset: _OffsetOf_otmusMinimumPPEM!

styleName
	"Answer the receiver's <readableString> style name.
	This is the name that appears in the font dialog as the 'Font style', 
	e.g. regular, bold, italic, etc"

	^Utf16String fromAddress: bytes yourAddress + self otmpStyleName! !
!OUTLINETEXTMETRICW categoriesFor: #dwSize:!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #faceName!accessing!public! !
!OUTLINETEXTMETRICW categoriesFor: #familyName!accessing!public! !
!OUTLINETEXTMETRICW categoriesFor: #fullName!accessing!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmAscent!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmDescent!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmEMSquare!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmfsSelection!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmfsType!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmItalicAngle!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmLineGap!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmMacAscent!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmMacDescent!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmMacLineGap!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmPanoseNumber!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmpFaceName!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmpFamilyName!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmpFullName!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmpStyleName!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmptSubscriptOffset!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmptSubscriptSize!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmptSuperscriptOffset!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmptSuperscriptSize!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmrcFontBox!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsCapEmHeight!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsCharSlopeRise!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsCharSlopeRun!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsStrikeoutPosition!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsStrikeoutSize!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsUnderscorePosition!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsUnderscoreSize!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmsXHeight!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmTextMetrics!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #otmusMinimumPPEM!**compiled accessors**!public! !
!OUTLINETEXTMETRICW categoriesFor: #styleName!accessing!public! !

!OUTLINETEXTMETRICW class methodsFor!

defineFields
	"Define the fields of the OUTLINETEXTMETRICW structure.
		self compileDefinition
	
		typedef 
		struct tagOUTLINETEXTMETRIC {
			int otmSize;
			TEXTMETRICW otmTextMetrics;
			BYTE otmFiller;
			PANOSE otmPanoseNumber;
			UINT otmfsSelection;
			UINT otmfsType;
			int otmsCharSlopeRise;
			int otmsCharSlopeRun;
			int otmItalicAngle;
			UINT otmEMSquare;
			int otmAscent;
			int otmDescent;
			UINT otmLineGap;
			UINT otmsCapEmHeight;
			UINT otmsXHeight;
			RECT otmrcFontBox;
			int otmMacAscent;
			int otmMacDescent;
			UINT otmMacLineGap;
			UINT otmusMinimumPPEM;
			POINTL otmptSubscriptSize;
			POINTL otmptSubscriptOffset;
			POINTL otmptSuperscriptSize;
			POINTL otmptSuperscriptOffset;
			UINT otmsStrikeoutSize;
			int otmsStrikeoutPosition;
			int otmsUnderscoreSize;
			int otmsUnderscorePosition;
			LPSTR otmpFamilyName;
			LPSTR otmpFaceName;
			LPSTR otmpStyleName;
			LPSTR otmpFullName;
		} OUTLINETEXTMETRICW;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #otmTextMetrics type: (StructureField type: TEXTMETRICW) beReadOnly;
		defineField: #otmFiller type: BYTEField filler;
		defineField: #otmPanoseNumber type: (StructureField type: PANOSE) beReadOnly;
		defineField: #otmfsSelection type: DWORDField readOnly;
		defineField: #otmfsType type: DWORDField readOnly;
		defineField: #otmsCharSlopeRise type: SDWORDField readOnly;
		defineField: #otmsCharSlopeRun type: SDWORDField readOnly;
		defineField: #otmItalicAngle type: SDWORDField readOnly;
		defineField: #otmEMSquare type: DWORDField readOnly;
		defineField: #otmAscent type: SDWORDField readOnly;
		defineField: #otmDescent type: SDWORDField readOnly;
		defineField: #otmLineGap type: DWORDField readOnly;
		defineField: #otmsCapEmHeight type: DWORDField readOnly;
		defineField: #otmsXHeight type: DWORDField readOnly;
		defineField: #otmrcFontBox type: (StructureField type: RECT) beReadOnly;
		defineField: #otmMacAscent type: SDWORDField readOnly;
		defineField: #otmMacDescent type: SDWORDField readOnly;
		defineField: #otmMacLineGap type: DWORDField readOnly;
		defineField: #otmusMinimumPPEM type: DWORDField readOnly;
		defineField: #otmptSubscriptSize type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSubscriptOffset type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSuperscriptSize type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSuperscriptOffset type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmsStrikeoutSize type: DWORDField readOnly;
		defineField: #otmsStrikeoutPosition type: SDWORDField readOnly;
		defineField: #otmsUnderscoreSize type: SDWORDField readOnly;
		defineField: #otmsUnderscorePosition type: SDWORDField readOnly;
		defineField: #otmpFamilyName type: DWORDField readOnly;
		defineField: #otmpFaceName type: DWORDField readOnly;
		defineField: #otmpStyleName type: DWORDField readOnly;
		defineField: #otmpFullName type: DWORDField readOnly
	"See MSDN article KB84132 - the otmp strings will be allocated after the above fields"!

getFieldNames
	^#(#dwSize #otmTextMetrics #otmPanoseNumber #otmfsSelection #otmfsType #otmsCharSlopeRise #otmsCharSlopeRun #otmItalicAngle #otmEMSquare #otmAscent #otmDescent #otmLineGap #otmsCapEmHeight #otmsXHeight #otmrcFontBox #otmMacAscent #otmMacDescent #otmMacLineGap #otmusMinimumPPEM #otmptSubscriptSize #otmptSubscriptOffset #otmptSuperscriptSize #otmptSuperscriptOffset #otmsStrikeoutSize #otmsStrikeoutPosition #otmsUnderscoreSize #otmsUnderscorePosition #otmpFamilyName #otmpFaceName #otmpStyleName #otmpFullName)! !
!OUTLINETEXTMETRICW class categoriesFor: #defineFields!public!template definition! !
!OUTLINETEXTMETRICW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

