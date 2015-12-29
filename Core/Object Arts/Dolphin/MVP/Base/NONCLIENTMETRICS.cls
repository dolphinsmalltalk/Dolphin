"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #NONCLIENTMETRICS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NONCLIENTMETRICS guid: (GUID fromString: '{87B4C602-026E-11D3-9FD7-00A0CC3E4A32}')!
NONCLIENTMETRICS comment: '<NONCLIENTMETRICS> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

From MSDN: "The NONCLIENTMETRICS structure contains the scalable metrics associated with the nonclient area of a nonminimized window. This structure is used by the SPI_GETNONCLIENTMETRICS and SPI_SETNONCLIENTMETRICS actions of SystemParametersInfo."'!
!NONCLIENTMETRICS categoriesForClass!External-Data-Structured-Win32! !
!NONCLIENTMETRICS methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

iCaptionHeight
	"Answer the receiver's iCaptionHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iCaptionHeight)!

iMenuHeight
	"Answer the receiver's iMenuHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iMenuHeight)!

iMenuWidth
	"Answer the receiver's iMenuWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iMenuWidth)!

iScrollHeight
	"Answer the receiver's iScrollHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iScrollHeight)!

iScrollWidth
	"Answer the receiver's iScrollWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iScrollWidth)!

lfMenuFont
	"Answer the receiver's lfMenuFont field as a Smalltalk object."

	^LOGFONT fromAddress: bytes yourAddress + ##(self offsetOf: #lfMenuFont)! !
!NONCLIENTMETRICS categoriesFor: #dwSize:!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #iCaptionHeight!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #iMenuHeight!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #iMenuWidth!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #iScrollHeight!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #iScrollWidth!**compiled accessors**!public! !
!NONCLIENTMETRICS categoriesFor: #lfMenuFont!**compiled accessors**!public! !

!NONCLIENTMETRICS class methodsFor!

defineFields
	"Define the fields of the Win32 NONCLIENTMETRICS structure.

		NONCLIENTMETRICS compileDefinition

	typedef struct tagNONCLIENTMETRICS   
		UINT		cbSize; 
		int		iBorderWidth; 
		int		iScrollWidth; 
		int		iScrollHeight; 
		int		iCaptionWidth; 
		int		iCaptionHeight; 
		LOGFONT	lfCaptionFont; 
		int		iSmCaptionWidth; 
		int		iSmCaptionHeight; 
		LOGFONT	lfSmCaptionFont; 
		int		iMenuWidth; 
		int		iMenuHeight; 
		LOGFONT	lfMenuFont; 
		LOGFONT	lfStatusFont; 
		LOGFONT	lfMessageFont; 
	 NONCLIENTMETRICS, FAR* LPNONCLIENTMETRICS; "

	self 
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #iBorderWidth type: SDWORDField uncompiled;
		defineField: #iScrollWidth type: SDWORDField readOnly;
		defineField: #iScrollHeight type: SDWORDField readOnly;
		defineField: #iCaptionWidth type: SDWORDField uncompiled;
		defineField: #iCaptionHeight type: SDWORDField readOnly;
		defineField: #lfCationFont type: (StructureField type: LOGFONT) beUncompiled;
		defineField: #iSmCaptionWidth type: SDWORDField uncompiled;
		defineField: #iSmCaptionHeight type: SDWORDField uncompiled;
		defineField: #lfSmCaptionFont type: (StructureField type: LOGFONT) beUncompiled;
		defineField: #iMenuWidth type: SDWORDField readOnly;
		defineField: #iMenuHeight type: SDWORDField readOnly;
		defineField: #lfMenuFont type: (StructureField type: LOGFONT) beReadOnly;
		defineField: #lfStatusFont type: (StructureField type: LOGFONT) beUncompiled;
		defineField: #lfMessageFont type: (StructureField type: LOGFONT) beUncompiled! !
!NONCLIENTMETRICS class categoriesFor: #defineFields!initializing!public! !

