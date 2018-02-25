"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #NONCLIENTMETRICSW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NONCLIENTMETRICSW guid: (GUID fromString: '{87b4c602-026e-11d3-9fd7-00a0cc3e4a32}')!
NONCLIENTMETRICSW comment: '<NONCLIENTMETRICSW> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

From MSDN: "The NONCLIENTMETRICS structure contains the scalable metrics associated with the nonclient area of a nonminimized window. This structure is used by the SPI_GETNONCLIENTMETRICS and SPI_SETNONCLIENTMETRICS actions of SystemParametersInfo."'!
!NONCLIENTMETRICSW categoriesForClass!External-Data-Structured-Win32! !
!NONCLIENTMETRICSW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

iCaptionHeight
	"Answer the <Integer> value of the receiver's 'iCaptionHeight' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iCaptionHeight)!

iMenuHeight
	"Answer the <Integer> value of the receiver's 'iMenuHeight' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iMenuHeight)!

iMenuWidth
	"Answer the <Integer> value of the receiver's 'iMenuWidth' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iMenuWidth)!

iPaddedBorderWidth
	"Answer the <Integer> value of the receiver's 'iPaddedBorderWidth' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iPaddedBorderWidth)!

iScrollHeight
	"Answer the <Integer> value of the receiver's 'iScrollHeight' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iScrollHeight)!

iScrollWidth
	"Answer the <Integer> value of the receiver's 'iScrollWidth' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iScrollWidth)!

lfMenuFont
	"Answer the <LOGFONTW> value of the receiver's 'lfMenuFont' field."

	^LOGFONTW fromAddress: bytes yourAddress + ##(self offsetOf: #lfMenuFont)! !
!NONCLIENTMETRICSW categoriesFor: #dwSize:!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iCaptionHeight!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iMenuHeight!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iMenuWidth!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iPaddedBorderWidth!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iScrollHeight!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #iScrollWidth!**compiled accessors**!public! !
!NONCLIENTMETRICSW categoriesFor: #lfMenuFont!**compiled accessors**!public! !

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
		defineField: #lfCationFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iSmCaptionWidth type: SDWORDField uncompiled;
		defineField: #iSmCaptionHeight type: SDWORDField uncompiled;
		defineField: #lfSmCaptionFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iMenuWidth type: SDWORDField readOnly;
		defineField: #iMenuHeight type: SDWORDField readOnly;
		defineField: #lfMenuFont type: (StructureField type: LOGFONTW) beReadOnly;
		defineField: #lfStatusFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #lfMessageFont type: (StructureField type: LOGFONTW) beUncompiled;
		defineField: #iPaddedBorderWidth type: SDWORDField readOnly! !
!NONCLIENTMETRICSW class categoriesFor: #defineFields!initializing!public! !

