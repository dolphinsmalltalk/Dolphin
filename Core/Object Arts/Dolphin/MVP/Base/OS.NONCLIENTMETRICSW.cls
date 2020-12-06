"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.NONCLIENTMETRICSW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_iBorderWidth' -> 16r4.
		'_OffsetOf_iCaptionHeight' -> 16r14.
		'_OffsetOf_iCaptionWidth' -> 16r10.
		'_OffsetOf_iMenuHeight' -> 16rDC.
		'_OffsetOf_iMenuWidth' -> 16rD8.
		'_OffsetOf_iPaddedBorderWidth' -> 16r1F4.
		'_OffsetOf_iScrollHeight' -> 16rC.
		'_OffsetOf_iScrollWidth' -> 16r8.
		'_OffsetOf_iSmCaptionHeight' -> 16r78.
		'_OffsetOf_iSmCaptionWidth' -> 16r74.
		'_OffsetOf_lfCationFont' -> 16r18.
		'_OffsetOf_lfMenuFont' -> 16rE0.
		'_OffsetOf_lfMessageFont' -> 16r198.
		'_OffsetOf_lfSmCaptionFont' -> 16r7C.
		'_OffsetOf_lfStatusFont' -> 16r13C
	}!
OS.NONCLIENTMETRICSW guid: (Core.GUID fromString: '{87b4c602-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.NONCLIENTMETRICSW comment: '<NONCLIENTMETRICSW> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

From MSDN: "The NONCLIENTMETRICS structure contains the scalable metrics associated with the nonclient area of a nonminimized window. This structure is used by the SPI_GETNONCLIENTMETRICS and SPI_SETNONCLIENTMETRICS actions of SystemParametersInfo."'!
!OS.NONCLIENTMETRICSW categoriesForClass!External-Data-Structured-Win32! !
!OS.NONCLIENTMETRICSW methodsFor!

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

lfMenuFont
	"Answer the <LOGFONTW> value of the receiver's 'lfMenuFont' field."

	^LOGFONTW fromAddress: bytes yourAddress + _OffsetOf_lfMenuFont! !
!OS.NONCLIENTMETRICSW categoriesFor: #dwSize:!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iCaptionHeight!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iMenuHeight!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iMenuWidth!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iPaddedBorderWidth!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iScrollHeight!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #iScrollWidth!**compiled accessors**!public! !
!OS.NONCLIENTMETRICSW categoriesFor: #lfMenuFont!**compiled accessors**!public! !

!OS.NONCLIENTMETRICSW class methodsFor!

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
		defineField: #lfCationFont type: (StructureField type: LOGFONTW) beUncompiled;
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
	^#(#dwSize #iBorderWidth #iScrollWidth #iScrollHeight #iCaptionWidth #iCaptionHeight #lfCationFont #iSmCaptionWidth #iSmCaptionHeight #lfSmCaptionFont #iMenuWidth #iMenuHeight #lfMenuFont #lfStatusFont #lfMessageFont #iPaddedBorderWidth)! !
!OS.NONCLIENTMETRICSW class categoriesFor: #defineFields!public!template definition! !
!OS.NONCLIENTMETRICSW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

