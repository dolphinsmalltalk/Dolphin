"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #OUTLINETEXTMETRICW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OUTLINETEXTMETRICW guid: (GUID fromString: '{52831a87-901f-4a84-894b-ab539352b71f}')!
OUTLINETEXTMETRICW comment: '<OUTLINETEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.OUTLINETEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.'!
!OUTLINETEXTMETRICW categoriesForClass!Win-Structs! !
!OUTLINETEXTMETRICW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

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

	^bytes sdwordAtOffset: ##(self offsetOf: #otmAscent)!

otmDescent
	"Answer the <Integer> value of the receiver's 'otmDescent' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmDescent)!

otmEMSquare
	"Answer the <Integer> value of the receiver's 'otmEMSquare' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmEMSquare)!

otmfsSelection
	"Answer the <Integer> value of the receiver's 'otmfsSelection' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmfsSelection)!

otmfsType
	"Answer the <Integer> value of the receiver's 'otmfsType' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmfsType)!

otmItalicAngle
	"Answer the <Integer> value of the receiver's 'otmItalicAngle' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmItalicAngle)!

otmLineGap
	"Answer the <Integer> value of the receiver's 'otmLineGap' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmLineGap)!

otmMacAscent
	"Answer the <Integer> value of the receiver's 'otmMacAscent' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmMacAscent)!

otmMacDescent
	"Answer the <Integer> value of the receiver's 'otmMacDescent' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmMacDescent)!

otmMacLineGap
	"Answer the <Integer> value of the receiver's 'otmMacLineGap' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmMacLineGap)!

otmPanoseNumber
	"Answer the <PANOSE> value of the receiver's 'otmPanoseNumber' field."

	^PANOSE fromAddress: bytes yourAddress + ##(self offsetOf: #otmPanoseNumber)!

otmpFaceName
	"Answer the <Integer> value of the receiver's 'otmpFaceName' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFaceName)!

otmpFamilyName
	"Answer the <Integer> value of the receiver's 'otmpFamilyName' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFamilyName)!

otmpFullName
	"Answer the <Integer> value of the receiver's 'otmpFullName' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFullName)!

otmpStyleName
	"Answer the <Integer> value of the receiver's 'otmpStyleName' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpStyleName)!

otmptSubscriptOffset
	"Answer the <POINTL> value of the receiver's 'otmptSubscriptOffset' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSubscriptOffset)!

otmptSubscriptSize
	"Answer the <POINTL> value of the receiver's 'otmptSubscriptSize' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSubscriptSize)!

otmptSuperscriptOffset
	"Answer the <POINTL> value of the receiver's 'otmptSuperscriptOffset' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSuperscriptOffset)!

otmptSuperscriptSize
	"Answer the <POINTL> value of the receiver's 'otmptSuperscriptSize' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSuperscriptSize)!

otmrcFontBox
	"Answer the <RECT> value of the receiver's 'otmrcFontBox' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #otmrcFontBox)!

otmsCapEmHeight
	"Answer the <Integer> value of the receiver's 'otmsCapEmHeight' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsCapEmHeight)!

otmsCharSlopeRise
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRise' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsCharSlopeRise)!

otmsCharSlopeRun
	"Answer the <Integer> value of the receiver's 'otmsCharSlopeRun' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsCharSlopeRun)!

otmsStrikeoutPosition
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutPosition' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsStrikeoutPosition)!

otmsStrikeoutSize
	"Answer the <Integer> value of the receiver's 'otmsStrikeoutSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsStrikeoutSize)!

otmsUnderscorePosition
	"Answer the <Integer> value of the receiver's 'otmsUnderscorePosition' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsUnderscorePosition)!

otmsUnderscoreSize
	"Answer the <Integer> value of the receiver's 'otmsUnderscoreSize' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsUnderscoreSize)!

otmsXHeight
	"Answer the <Integer> value of the receiver's 'otmsXHeight' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsXHeight)!

otmTextMetrics
	"Answer the <TEXTMETRICW> value of the receiver's 'otmTextMetrics' field."

	^TEXTMETRICW fromAddress: bytes yourAddress + ##(self offsetOf: #otmTextMetrics)!

otmusMinimumPPEM
	"Answer the <Integer> value of the receiver's 'otmusMinimumPPEM' field."

	^bytes dwordAtOffset: ##(self offsetOf: #otmusMinimumPPEM)!

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
	"See MSDN article KB84132 - the otmp strings will be allocated after the above fields"! !
!OUTLINETEXTMETRICW class categoriesFor: #defineFields!initializing!public! !

