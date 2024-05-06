"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #FLASHWINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFlags _OffsetOf_dwSize _OffsetOf_dwTimeout _OffsetOf_hwnd _OffsetOf_uCount'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FLASHWINFO guid: (GUID fromString: '{2a5e4594-f531-486b-a082-17686b820cd4}')!

FLASHWINFO addClassConstant: '_OffsetOf_dwFlags' value: 16r8!
FLASHWINFO addClassConstant: '_OffsetOf_dwSize' value: 16r0!
FLASHWINFO addClassConstant: '_OffsetOf_dwTimeout' value: 16r10!
FLASHWINFO addClassConstant: '_OffsetOf_hwnd' value: 16r4!
FLASHWINFO addClassConstant: '_OffsetOf_uCount' value: 16rC!

FLASHWINFO comment: 'FLASHWINFO is the class of <ExternalStructure> which represent the Win32 structure of the same name.

FLASHWINFO is used to pass parameters to the FlashWindowEx() API call.

Instance Variables:
	None'!

!FLASHWINFO categoriesForClass!External-Data-Structured-Win32! !

!FLASHWINFO methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwTimeout: anInteger
	"Set the receiver's 'dwTimeout' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwTimeout put: anInteger!

hwnd: anExternalHandle
	"Set the receiver's 'hwnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: anExternalHandle!

uCount: anInteger
	"Set the receiver's 'uCount' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uCount put: anInteger! !

!FLASHWINFO categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dwTimeout:!**compiled accessors**!public! !
hwnd:!**compiled accessors**!public! !
uCount:!**compiled accessors**!public! !
!

!FLASHWINFO class methodsFor!

defineFields
	"Define the fields of the Win32 FLASHWINFO structure.

		self compileDefinition

		typedef struct {
			UINT  cbSize;
			HWND  hwnd;
			DWORD dwFlags;
			UINT  uCount;
			DWORD dwTimeout;
		} FLASHWINFO;
	"

	self 
		defineField: #dwSize		type: DWORDField writeOnly beOverride;
		defineField: #hwnd		type: HANDLEField writeOnly;
		defineField: #dwFlags		type: DWORDField new;
		defineField: #uCount		type: DWORDField writeOnly;
		defineField: #dwTimeout	type: DWORDField writeOnly!

getFieldNames
	^#(#dwSize #hwnd #dwFlags #uCount #dwTimeout)! !

!FLASHWINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

