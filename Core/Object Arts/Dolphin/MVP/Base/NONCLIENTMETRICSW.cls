"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #NONCLIENTMETRICSW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_iBorderWidth _OffsetOf_iCaptionHeight _OffsetOf_iCaptionWidth _OffsetOf_iMenuHeight _OffsetOf_iMenuWidth _OffsetOf_iPaddedBorderWidth _OffsetOf_iScrollHeight _OffsetOf_iScrollWidth _OffsetOf_iSmCaptionHeight _OffsetOf_iSmCaptionWidth _OffsetOf_lfCaptionFont _OffsetOf_lfMenuFont _OffsetOf_lfMessageFont _OffsetOf_lfSmCaptionFont _OffsetOf_lfStatusFont'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NONCLIENTMETRICSW guid: (GUID fromString: '{87b4c602-026e-11d3-9fd7-00a0cc3e4a32}')!

NONCLIENTMETRICSW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iBorderWidth' value: 16r4!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iCaptionHeight' value: 16r14!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iCaptionWidth' value: 16r10!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iMenuHeight' value: 16rDC!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iMenuWidth' value: 16rD8!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iPaddedBorderWidth' value: 16r1F4!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iScrollHeight' value: 16rC!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iScrollWidth' value: 16r8!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iSmCaptionHeight' value: 16r78!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_iSmCaptionWidth' value: 16r74!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_lfCaptionFont' value: 16r18!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_lfMenuFont' value: 16rE0!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_lfMessageFont' value: 16r198!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_lfSmCaptionFont' value: 16r7C!
NONCLIENTMETRICSW addClassConstant: '_OffsetOf_lfStatusFont' value: 16r13C!

NONCLIENTMETRICSW comment: '<NONCLIENTMETRICSW> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

From MSDN: "The NONCLIENTMETRICS structure contains the scalable metrics associated with the nonclient area of a nonminimized window. This structure is used by the SPI_GETNONCLIENTMETRICS and SPI_SETNONCLIENTMETRICS actions of SystemParametersInfo."'!

!NONCLIENTMETRICSW categoriesForClass!External-Data-Structured-Win32! !

!NONCLIENTMETRICSW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

iCaptionHeight
	"Answer the <Integer> value of the receiver's 'iCaptionHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_iCaptionHeight!

iMenuHeight
	"Answer the <Integer> value of the receiver's 'iMenuHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_iMenuHeight!

iMenuWidth
	"Answer the <Integer> value of the receiver's 'iMenuWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_iMenuWidth!

iPaddedBorderWidth
	"Answer the <Integer> value of the receiver's 'iPaddedBorderWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_iPaddedBorderWidth!

iScrollHeight
	"Answer the <Integer> value of the receiver's 'iScrollHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_iScrollHeight!

iScrollWidth
	"Answer the <Integer> value of the receiver's 'iScrollWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_iScrollWidth!

lfCaptionFont
	"Answer the <LOGFONTW> value of the receiver's 'lfCaptionFont' field."

	^LOGFONTW fromAddress: bytes yourAddress + _OffsetOf_lfCaptionFont!

lfMenuFont
	"Answer the <LOGFONTW> value of the receiver's 'lfMenuFont' field."

	^LOGFONTW fromAddress: bytes yourAddress + _OffsetOf_lfMenuFont! !

!NONCLIENTMETRICSW categoriesForMethods!
dwSize:!**compiled accessors**!public! !
iCaptionHeight!**compiled accessors**!public! !
iMenuHeight!**compiled accessors**!public! !
iMenuWidth!**compiled accessors**!public! !
iPaddedBorderWidth!**compiled accessors**!public! !
iScrollHeight!**compiled accessors**!public! !
iScrollWidth!**compiled accessors**!public! !
lfCaptionFont!**compiled accessors**!public! !
lfMenuFont!**compiled accessors**!public! !
!

!NONCLIENTMETRICSW class methodsFor!

defineFields
	"Define the fields of the Win32 NONCLIENTMETRICSW structure.

		self compileDefinition

	typedef struct tagNONCLIENTMETRICS   
		UINT		cbSize; 
		int		iBorderWidth; 
		int		iScrollWidth; 
		int		iScrollHeight; 
		int		iCaptionWidth; 
		int		iCaptionHeight; 
		LOGFONTW	lfCaptionFont; 
		int		iSmCaptionWidth; 
		int		iSmCaptionHeight; 
		LOGFONTW	lfSmCaptionFont; 
		int		iMenuWidth; 
		int		iMenuHeight; 
		LOGFONTW	lfMenuFont; 
		LOGFONTW	lfStatusFont; 
		LOGFONTW	lfMessageFont; 
		int		iPaddedBorderWidth;
	 NONCLIENTMETRICSW, FAR* LPNONCLIENTMETRICS; "

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #iBorderWidth type: SDWORDField uncompiled;
		defineField: #iScrollWidth type: SDWORDField readOnly;
		defineField: #iScrollHeight type: SDWORDField readOnly;
		defineField: #iCaptionWidth type: SDWORDField uncompiled;
		defineField: #iCaptionHeight type: SDWORDField readOnly;
		defineField: #lfCaptionFont type: (StructureField type: LOGFONTW) beReadOnly;
		defineField: #iSmCaptionWidth type: SDWORDField uncompiled;
		defineField: #iSmCaptionHeight type: SDWORDField uncompiled;
		defineField: #lfSmCaptionFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iMenuWidth type: SDWORDField readOnly;
		defineField: #iMenuHeight type: SDWORDField readOnly;
		defineField: #lfMenuFont type: (StructureField type: LOGFONTW) beReadOnly;
		defineField: #lfStatusFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #lfMessageFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iPaddedBorderWidth type: SDWORDField readOnly!

getFieldNames
	^#(#dwSize #iBorderWidth #iScrollWidth #iScrollHeight #iCaptionWidth #iCaptionHeight #lfCaptionFont #iSmCaptionWidth #iSmCaptionHeight #lfSmCaptionFont #iMenuWidth #iMenuHeight #lfMenuFont #lfStatusFont #lfMessageFont #iPaddedBorderWidth)! !

!NONCLIENTMETRICSW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

