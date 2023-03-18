"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.FLASHWINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_FLASHWINFO_Size' -> 16r14.
		'_OffsetOf_dwFlags' -> 16r8.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwTimeout' -> 16r10.
		'_OffsetOf_hwnd' -> 16r4.
		'_OffsetOf_uCount' -> 16rC
	}!
OS.FLASHWINFO guid: (Core.GUID fromString: '{2a5e4594-f531-486b-a082-17686b820cd4}')!
OS.FLASHWINFO comment: 'FLASHWINFO is the class of <ExternalStructure> which represent the Win32 structure of the same name.

FLASHWINFO is used to pass parameters to the FlashWindowEx() API call.

Instance Variables:
	None'!
!OS.FLASHWINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.FLASHWINFO methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

dwTimeout: anInteger
	"Set the receiver's 'dwTimeout' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwTimeout put: anInteger!

hwnd: anExternalHandle
	"Set the receiver's 'hwnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: anExternalHandle!

uCount: anInteger
	"Set the receiver's 'uCount' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_uCount put: anInteger! !
!OS.FLASHWINFO categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dwTimeout:!**compiled accessors**!public! !
hwnd:!**compiled accessors**!public! !
uCount:!**compiled accessors**!public! !
!

!OS.FLASHWINFO class methodsFor!

byteSize
	^_FLASHWINFO_Size!

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
		defineField: #dwSize type: UInt32Field writeOnly beOverride;
		defineField: #hwnd type: HANDLEField writeOnly;
		defineField: #dwFlags type: UInt32Field new;
		defineField: #uCount type: UInt32Field writeOnly;
		defineField: #dwTimeout type: UInt32Field writeOnly!

getFieldNames
	^#(#dwSize #hwnd #dwFlags #uCount #dwTimeout)! !
!OS.FLASHWINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

