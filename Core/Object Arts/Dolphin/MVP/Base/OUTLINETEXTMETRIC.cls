"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #OUTLINETEXTMETRIC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OUTLINETEXTMETRIC guid: (GUID fromString: '{52831A87-901F-4A84-894B-AB539352B71F}')!
OUTLINETEXTMETRIC comment: '<OUTLINETEXTMETRIC> is an <ExternalStructure> class to wrap the struct ''Win.OUTLINETEXTMETRIC'' from type information in the ''Windows API (ANSI)'' library.'!
!OUTLINETEXTMETRIC categoriesForClass!Win-Structs! !
!OUTLINETEXTMETRIC methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

faceName
	"Answer the receiver's <readableString> font face name."
	
	^String fromAddress: bytes yourAddress + self otmpFaceName!

familyName
	"Answer the receiver's <readableString> font family name."
	
	^String fromAddress: bytes yourAddress + self otmpFamilyName!

fullName
	"Answer the receiver's <readableString> full font name."
	
	^String fromAddress: bytes yourAddress + self otmpFullName!

otmAscent
	"Answer the receiver's otmAscent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmAscent)!

otmDescent
	"Answer the receiver's otmDescent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmDescent)!

otmEMSquare
	"Answer the receiver's otmEMSquare field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmEMSquare)!

otmfsSelection
	"Answer the receiver's otmfsSelection field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmfsSelection)!

otmfsType
	"Answer the receiver's otmfsType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmfsType)!

otmItalicAngle
	"Answer the receiver's otmItalicAngle field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmItalicAngle)!

otmLineGap
	"Answer the receiver's otmLineGap field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmLineGap)!

otmMacAscent
	"Answer the receiver's otmMacAscent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmMacAscent)!

otmMacDescent
	"Answer the receiver's otmMacDescent field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmMacDescent)!

otmMacLineGap
	"Answer the receiver's otmMacLineGap field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmMacLineGap)!

otmPanoseNumber
	"Answer the receiver's otmPanoseNumber field as a Smalltalk object."

	^PANOSE fromAddress: bytes yourAddress + ##(self offsetOf: #otmPanoseNumber)!

otmpFaceName
	"Answer the receiver's otmpFaceName field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFaceName)!

otmpFamilyName
	"Answer the receiver's otmpFamilyName field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFamilyName)!

otmpFullName
	"Answer the receiver's otmpFullName field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpFullName)!

otmpStyleName
	"Answer the receiver's otmpStyleName field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmpStyleName)!

otmptSubscriptOffset
	"Answer the receiver's otmptSubscriptOffset field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSubscriptOffset)!

otmptSubscriptSize
	"Answer the receiver's otmptSubscriptSize field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSubscriptSize)!

otmptSuperscriptOffset
	"Answer the receiver's otmptSuperscriptOffset field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSuperscriptOffset)!

otmptSuperscriptSize
	"Answer the receiver's otmptSuperscriptSize field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #otmptSuperscriptSize)!

otmrcFontBox
	"Answer the receiver's otmrcFontBox field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #otmrcFontBox)!

otmsCapEmHeight
	"Answer the receiver's otmsCapEmHeight field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsCapEmHeight)!

otmsCharSlopeRise
	"Answer the receiver's otmsCharSlopeRise field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsCharSlopeRise)!

otmsCharSlopeRun
	"Answer the receiver's otmsCharSlopeRun field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsCharSlopeRun)!

otmsStrikeoutPosition
	"Answer the receiver's otmsStrikeoutPosition field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsStrikeoutPosition)!

otmsStrikeoutSize
	"Answer the receiver's otmsStrikeoutSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsStrikeoutSize)!

otmsUnderscorePosition
	"Answer the receiver's otmsUnderscorePosition field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsUnderscorePosition)!

otmsUnderscoreSize
	"Answer the receiver's otmsUnderscoreSize field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #otmsUnderscoreSize)!

otmsXHeight
	"Answer the receiver's otmsXHeight field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmsXHeight)!

otmTextMetrics
	"Answer the receiver's otmTextMetrics field as a Smalltalk object."

	^TEXTMETRIC fromAddress: bytes yourAddress + ##(self offsetOf: #otmTextMetrics)!

otmusMinimumPPEM
	"Answer the receiver's otmusMinimumPPEM field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #otmusMinimumPPEM)!

styleName
	"Answer the receiver's <readableString> style name.
	This is the name that appears in the font dialog as the 'Font style', 
	e.g. regular, bold, italic, etc"

	^String fromAddress: bytes yourAddress + self otmpStyleName! !
!OUTLINETEXTMETRIC categoriesFor: #dwSize:!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #faceName!accessing!public! !
!OUTLINETEXTMETRIC categoriesFor: #familyName!accessing!public! !
!OUTLINETEXTMETRIC categoriesFor: #fullName!accessing!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmAscent!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmDescent!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmEMSquare!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmfsSelection!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmfsType!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmItalicAngle!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmLineGap!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmMacAscent!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmMacDescent!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmMacLineGap!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmPanoseNumber!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmpFaceName!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmpFamilyName!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmpFullName!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmpStyleName!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmptSubscriptOffset!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmptSubscriptSize!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmptSuperscriptOffset!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmptSuperscriptSize!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmrcFontBox!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsCapEmHeight!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsCharSlopeRise!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsCharSlopeRun!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsStrikeoutPosition!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsStrikeoutSize!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsUnderscorePosition!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsUnderscoreSize!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmsXHeight!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmTextMetrics!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #otmusMinimumPPEM!**compiled accessors**!public! !
!OUTLINETEXTMETRIC categoriesFor: #styleName!accessing!public! !

!OUTLINETEXTMETRIC class methodsFor!

defineFields
	"Define the fields of the OUTLINETEXTMETRIC structure.
		OUTLINETEXTMETRIC compileDefinition
	
		typedef 
		struct tagOUTLINETEXTMETRIC {
			int otmSize;
			TEXTMETRIC otmTextMetrics;
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
		} OUTLINETEXTMETRIC;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #otmTextMetrics type: (StructureField type: TEXTMETRIC) beReadOnly;
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
		defineField: #otmpFullName type: DWORDField readOnly.
	"See MSDN article KB84132 - the otmp strings will be allocated after the above fields"! !
!OUTLINETEXTMETRIC class categoriesFor: #defineFields!initializing!public! !

