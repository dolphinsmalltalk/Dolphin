"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #OUTLINETEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_otmAscent _OffsetOf_otmDescent _OffsetOf_otmEMSquare _OffsetOf_otmFiller _OffsetOf_otmfsSelection _OffsetOf_otmfsType _OffsetOf_otmItalicAngle _OffsetOf_otmLineGap _OffsetOf_otmMacAscent _OffsetOf_otmMacDescent _OffsetOf_otmMacLineGap _OffsetOf_otmPanoseNumber _OffsetOf_otmpFaceName _OffsetOf_otmpFamilyName _OffsetOf_otmpFullName _OffsetOf_otmpStyleName _OffsetOf_otmptSubscriptOffset _OffsetOf_otmptSubscriptSize _OffsetOf_otmptSuperscriptOffset _OffsetOf_otmptSuperscriptSize _OffsetOf_otmrcFontBox _OffsetOf_otmsCapEmHeight _OffsetOf_otmsCharSlopeRise _OffsetOf_otmsCharSlopeRun _OffsetOf_otmsStrikeoutPosition _OffsetOf_otmsStrikeoutSize _OffsetOf_otmsUnderscorePosition _OffsetOf_otmsUnderscoreSize _OffsetOf_otmsXHeight _OffsetOf_otmTextMetrics _OffsetOf_otmusMinimumPPEM'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OUTLINETEXTMETRICW guid: (GUID fromString: '{52831a87-901f-4a84-894b-ab539352b71f}')!

OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmAscent' value: 16r64!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmDescent' value: 16r68!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmEMSquare' value: 16r60!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmFiller' value: 16r40!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmfsSelection' value: 16r4C!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmfsType' value: 16r50!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmItalicAngle' value: 16r5C!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmLineGap' value: 16r6C!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmMacAscent' value: 16r88!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmMacDescent' value: 16r8C!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmMacLineGap' value: 16r90!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmPanoseNumber' value: 16r41!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmpFaceName' value: 16rCC!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmpFamilyName' value: 16rC8!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmpFullName' value: 16rD4!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmpStyleName' value: 16rD0!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmptSubscriptOffset' value: 16rA0!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmptSubscriptSize' value: 16r98!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmptSuperscriptOffset' value: 16rB0!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmptSuperscriptSize' value: 16rA8!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmrcFontBox' value: 16r78!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsCapEmHeight' value: 16r70!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsCharSlopeRise' value: 16r54!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsCharSlopeRun' value: 16r58!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsStrikeoutPosition' value: 16rBC!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsStrikeoutSize' value: 16rB8!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsUnderscorePosition' value: 16rC4!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsUnderscoreSize' value: 16rC0!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmsXHeight' value: 16r74!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmTextMetrics' value: 16r4!
OUTLINETEXTMETRICW addClassConstant: '_OffsetOf_otmusMinimumPPEM' value: 16r94!

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

!OUTLINETEXTMETRICW categoriesForMethods!
dwSize:!**compiled accessors**!public! !
faceName!accessing!public! !
familyName!accessing!public! !
fullName!accessing!public! !
otmAscent!**compiled accessors**!public! !
otmDescent!**compiled accessors**!public! !
otmEMSquare!**compiled accessors**!public! !
otmfsSelection!**compiled accessors**!public! !
otmfsType!**compiled accessors**!public! !
otmItalicAngle!**compiled accessors**!public! !
otmLineGap!**compiled accessors**!public! !
otmMacAscent!**compiled accessors**!public! !
otmMacDescent!**compiled accessors**!public! !
otmMacLineGap!**compiled accessors**!public! !
otmPanoseNumber!**compiled accessors**!public! !
otmpFaceName!**compiled accessors**!public! !
otmpFamilyName!**compiled accessors**!public! !
otmpFullName!**compiled accessors**!public! !
otmpStyleName!**compiled accessors**!public! !
otmptSubscriptOffset!**compiled accessors**!public! !
otmptSubscriptSize!**compiled accessors**!public! !
otmptSuperscriptOffset!**compiled accessors**!public! !
otmptSuperscriptSize!**compiled accessors**!public! !
otmrcFontBox!**compiled accessors**!public! !
otmsCapEmHeight!**compiled accessors**!public! !
otmsCharSlopeRise!**compiled accessors**!public! !
otmsCharSlopeRun!**compiled accessors**!public! !
otmsStrikeoutPosition!**compiled accessors**!public! !
otmsStrikeoutSize!**compiled accessors**!public! !
otmsUnderscorePosition!**compiled accessors**!public! !
otmsUnderscoreSize!**compiled accessors**!public! !
otmsXHeight!**compiled accessors**!public! !
otmTextMetrics!**compiled accessors**!public! !
otmusMinimumPPEM!**compiled accessors**!public! !
styleName!accessing!public! !
!

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

!OUTLINETEXTMETRICW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

