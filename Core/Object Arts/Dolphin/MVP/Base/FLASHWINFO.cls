"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #FLASHWINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFlags' -> 16r8.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwTimeout' -> 16r10.
		'_OffsetOf_hwnd' -> 16r4.
		'_OffsetOf_uCount' -> 16rC
	}!
FLASHWINFO guid: (GUID fromString: '{2a5e4594-f531-486b-a082-17686b820cd4}')!
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
!FLASHWINFO categoriesFor: #dwFlags!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwFlags:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwTimeout:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #hwnd:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #uCount:!**compiled accessors**!public! !

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
!FLASHWINFO class categoriesFor: #defineFields!public!template definition! !
!FLASHWINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

