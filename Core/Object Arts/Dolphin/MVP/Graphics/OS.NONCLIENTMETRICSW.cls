"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.NONCLIENTMETRICSW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NONCLIENTMETRICSW_Size' -> 16r1F8.
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

iCaptionHeight
	"Answer the <Integer> value of the receiver's 'iCaptionHeight' field."

	^bytes int32AtOffset: _OffsetOf_iCaptionHeight!

iMenuHeight
	"Answer the <Integer> value of the receiver's 'iMenuHeight' field."

	^bytes int32AtOffset: _OffsetOf_iMenuHeight!

iMenuWidth
	"Answer the <Integer> value of the receiver's 'iMenuWidth' field."

	^bytes int32AtOffset: _OffsetOf_iMenuWidth!

iPaddedBorderWidth
	"Answer the <Integer> value of the receiver's 'iPaddedBorderWidth' field."

	^bytes int32AtOffset: _OffsetOf_iPaddedBorderWidth!

iScrollHeight
	"Answer the <Integer> value of the receiver's 'iScrollHeight' field."

	^bytes int32AtOffset: _OffsetOf_iScrollHeight!

iScrollWidth
	"Answer the <Integer> value of the receiver's 'iScrollWidth' field."

	^bytes int32AtOffset: _OffsetOf_iScrollWidth!

lfMenuFont
	"Answer the <LOGFONTW> value of the receiver's 'lfMenuFont' field."

	^LOGFONTW fromAddress: bytes yourAddress + _OffsetOf_lfMenuFont! !
!OS.NONCLIENTMETRICSW categoriesForMethods!
iCaptionHeight!**compiled accessors**!public! !
iMenuHeight!**compiled accessors**!public! !
iMenuWidth!**compiled accessors**!public! !
iPaddedBorderWidth!**compiled accessors**!public! !
iScrollHeight!**compiled accessors**!public! !
iScrollWidth!**compiled accessors**!public! !
lfMenuFont!**compiled accessors**!public! !
!

!OS.NONCLIENTMETRICSW class methodsFor!

byteSize
	^_NONCLIENTMETRICSW_Size!

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

	super defineFields.
	self
		defineField: #iBorderWidth type: Int32Field uncompiled;
		defineField: #iScrollWidth type: Int32Field readOnly;
		defineField: #iScrollHeight type: Int32Field readOnly;
		defineField: #iCaptionWidth type: Int32Field uncompiled;
		defineField: #iCaptionHeight type: Int32Field readOnly;
		defineField: #lfCationFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iSmCaptionWidth type: Int32Field uncompiled;
		defineField: #iSmCaptionHeight type: Int32Field uncompiled;
		defineField: #lfSmCaptionFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iMenuWidth type: Int32Field readOnly;
		defineField: #iMenuHeight type: Int32Field readOnly;
		defineField: #lfMenuFont type: (StructureField type: LOGFONTW) beReadOnly;
		defineField: #lfStatusFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #lfMessageFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iPaddedBorderWidth type: Int32Field readOnly!

getFieldNames
	^#(#dwSize #iBorderWidth #iScrollWidth #iScrollHeight #iCaptionWidth #iCaptionHeight #lfCationFont #iSmCaptionWidth #iSmCaptionHeight #lfSmCaptionFont #iMenuWidth #iMenuHeight #lfMenuFont #lfStatusFont #lfMessageFont #iPaddedBorderWidth)! !
!OS.NONCLIENTMETRICSW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

