"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.OUTLINETEXTMETRICW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
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
			'_OffsetOf_otmusMinimumPPEM' -> 16r94.
			'_OUTLINETEXTMETRICW_Size' -> 16rD8
		}!
OS.OUTLINETEXTMETRICW guid: (Core.GUID fromString: '{52831a87-901f-4a84-894b-ab539352b71f}')!
OS.OUTLINETEXTMETRICW comment: '<OUTLINETEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.OUTLINETEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.'!
!OS.OUTLINETEXTMETRICW categoriesForClass!Win-Structs! !
!OS.OUTLINETEXTMETRICW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

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

	^bytes int32AtOffset: _OffsetOf_otmAscent!

otmDescent
	"Answer the <Integer> value of the receiver's 'otmDescent' field."

	^bytes int32AtOffset: _OffsetOf_otmDescent!

otmEMSquare
	"Answer the <Integer> value of the receiver's 'otmEMSquare' field."

	^bytes uint32AtOffset: _OffsetOf_otmEMSquare!

otmfsSelection
	"Answer the <Integer> value of the receiver's 'otmfsSelection' field."

	^bytes uint32AtOffset: _OffsetOf_otmfsSelection!

otmfsType
	"Answer the <Integer> value of the receiver's 'otmfsType' field."

	^bytes uint32AtOffset: _OffsetOf_otmfsType!

otmItalicAngle
	"Answer the <Integer> value of the receiver's 'otmItalicAngle' field."

	^bytes int32AtOffset: _OffsetOf_otmItalicAngle!

otmLineGap
	"Answer the <Integer> value of the receiver's 'otmLineGap' field."

	^bytes uint32AtOffset: _OffsetOf_otmLineGap!

otmMacAscent
	"Answer the <Integer> value of the receiver's 'otmMacAscent' field."

	^bytes int32AtOffset: _OffsetOf_otmMacAscent!

otmMacDescent
	"Answer the <Integer> value of the receiver's 'otmMacDescent' field."

	^bytes int32AtOffset: _OffsetOf_otmMacDescent!

otmMacLineGap
	"Answer the <Integer> value of the receiver's 'otmMacLineGap' field."

	^bytes uint32AtOffset: _OffsetOf_otmMacLineGap!

otmPanoseNumber
	"Answer the <PANOSE> value of the receiver's 'otmPanoseNumber' field."

	^PANOSE fromAddress: bytes yourAddress + _OffsetOf_otmPanoseNumber!

otmpFaceName
	"Answer the <Integer> value of the receiver's 'otmpFaceName' field."

	^bytes uint32AtOffset: _OffsetOf_otmpFaceName!

otmpFamilyName
	"Answer the <Integer> value of the receiver's 'otmpFamilyName' field."

	^bytes uint32AtOffset: _OffsetOf_otmpFamilyName!

otmpFullName
	"Answer the <Integer> value of the receiver's 'otmpFullName' field."

	^bytes uint32AtOffset: _OffsetOf_otmpFullName!

otmpStyleName
	"Answer the <Integer> value of the receiver's 'otmpStyleName' field."

	^bytes uint32AtOffset: _OffsetOf_otmpStyleName!

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
	"Answer the <RECTL> value of the receiver's 'otmrcFontBox' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_otmrcFontBox!

otmsCapEmHeight
	"Answer the <Integer> value of the receiver's 'otmsCapEmHeight' field."

	^bytes uint32AtOffset: _OffsetOf_otmsCapEmHeight!

otmsCharSlopeRise
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRise' field."

	^bytes int32AtOffset: _OffsetOf_otmsCharSlopeRise!

otmsCharSlopeRun
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRun' field."

	^bytes int32AtOffset: _OffsetOf_otmsCharSlopeRun!

otmsStrikeoutPosition
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutPosition' field."

	^bytes int32AtOffset: _OffsetOf_otmsStrikeoutPosition!

otmsStrikeoutSize
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutSize' field."

	^bytes uint32AtOffset: _OffsetOf_otmsStrikeoutSize!

otmsUnderscorePosition
	"Answer the <Integer> value of the receiver's 'otmsUnderscorePosition' field."

	^bytes int32AtOffset: _OffsetOf_otmsUnderscorePosition!

otmsUnderscoreSize
	"Answer the <Integer> value of the receiver's 'otmsUnderscoreSize' field."

	^bytes int32AtOffset: _OffsetOf_otmsUnderscoreSize!

otmsXHeight
	"Answer the <Integer> value of the receiver's 'otmsXHeight' field."

	^bytes uint32AtOffset: _OffsetOf_otmsXHeight!

otmTextMetrics
	"Answer the <TEXTMETRICW> value of the receiver's 'otmTextMetrics' field."

	^TEXTMETRICW fromAddress: bytes yourAddress + _OffsetOf_otmTextMetrics!

otmusMinimumPPEM
	"Answer the <Integer> value of the receiver's 'otmusMinimumPPEM' field."

	^bytes uint32AtOffset: _OffsetOf_otmusMinimumPPEM!

styleName
	"Answer the receiver's <readableString> style name.
	This is the name that appears in the font dialog as the 'Font style', 
	e.g. regular, bold, italic, etc"

	^Utf16String fromAddress: bytes yourAddress + self otmpStyleName! !
!OS.OUTLINETEXTMETRICW categoriesForMethods!
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

!OS.OUTLINETEXTMETRICW class methodsFor!

byteSize
	^_OUTLINETEXTMETRICW_Size!

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
			RECTL otmrcFontBox;
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
		defineField: #dwSize type: UInt32Field writeOnly beOverride;
		defineField: #otmTextMetrics type: (StructureField type: TEXTMETRICW) beReadOnly;
		defineField: #otmFiller type: UInt8Field filler;
		defineField: #otmPanoseNumber type: (StructureField type: PANOSE) beReadOnly;
		defineField: #otmfsSelection type: UInt32Field readOnly;
		defineField: #otmfsType type: UInt32Field readOnly;
		defineField: #otmsCharSlopeRise type: Int32Field readOnly;
		defineField: #otmsCharSlopeRun type: Int32Field readOnly;
		defineField: #otmItalicAngle type: Int32Field readOnly;
		defineField: #otmEMSquare type: UInt32Field readOnly;
		defineField: #otmAscent type: Int32Field readOnly;
		defineField: #otmDescent type: Int32Field readOnly;
		defineField: #otmLineGap type: UInt32Field readOnly;
		defineField: #otmsCapEmHeight type: UInt32Field readOnly;
		defineField: #otmsXHeight type: UInt32Field readOnly;
		defineField: #otmrcFontBox type: (StructureField type: RECTL) beReadOnly;
		defineField: #otmMacAscent type: Int32Field readOnly;
		defineField: #otmMacDescent type: Int32Field readOnly;
		defineField: #otmMacLineGap type: UInt32Field readOnly;
		defineField: #otmusMinimumPPEM type: UInt32Field readOnly;
		defineField: #otmptSubscriptSize type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSubscriptOffset type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSuperscriptSize type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmptSuperscriptOffset type: (StructureField type: POINTL) beReadOnly;
		defineField: #otmsStrikeoutSize type: UInt32Field readOnly;
		defineField: #otmsStrikeoutPosition type: Int32Field readOnly;
		defineField: #otmsUnderscoreSize type: Int32Field readOnly;
		defineField: #otmsUnderscorePosition type: Int32Field readOnly;
		defineField: #otmpFamilyName type: UInt32Field readOnly;
		defineField: #otmpFaceName type: UInt32Field readOnly;
		defineField: #otmpStyleName type: UInt32Field readOnly;
		defineField: #otmpFullName type: UInt32Field readOnly
	"See MSDN article KB84132 - the otmp strings will be allocated after the above fields"!

getFieldNames
	^#(#dwSize #otmTextMetrics #otmPanoseNumber #otmfsSelection #otmfsType #otmsCharSlopeRise #otmsCharSlopeRun #otmItalicAngle #otmEMSquare #otmAscent #otmDescent #otmLineGap #otmsCapEmHeight #otmsXHeight #otmrcFontBox #otmMacAscent #otmMacDescent #otmMacLineGap #otmusMinimumPPEM #otmptSubscriptSize #otmptSubscriptOffset #otmptSuperscriptSize #otmptSuperscriptOffset #otmsStrikeoutSize #otmsStrikeoutPosition #otmsUnderscoreSize #otmsUnderscorePosition #otmpFamilyName #otmpFaceName #otmpStyleName #otmpFullName)! !
!OS.OUTLINETEXTMETRICW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

