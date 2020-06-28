"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #NOTIFYICONDATAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_hIcon' -> 16r14.
		'_OffsetOf_hWnd' -> 16r4.
		'_OffsetOf_szTip' -> 16r18.
		'_OffsetOf_uCallbackMessage' -> 16r10.
		'_OffsetOf_uFlags' -> 16rC.
		'_OffsetOf_uID' -> 16r8
	}!
NOTIFYICONDATAW guid: (GUID fromString: '{70cb825f-18f0-4968-9638-a8444b0bd805}')!
NOTIFYICONDATAW comment: ''!
!NOTIFYICONDATAW categoriesForClass!No category! !
!NOTIFYICONDATAW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hIcon: anExternalHandle
	"Set the receiver's 'hIcon' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hIcon put: anExternalHandle!

hWnd: anExternalHandle
	"Set the receiver's 'hWnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hWnd put: anExternalHandle!

icon: anIconOrHandle
	"Set the receiver's hIcon field."

	self hIcon: anIconOrHandle asParameter.
	self uFlags: (self uFlags bitOr: NIF_ICON)!

message: anIntegerMessageNumber
	"Set the receiver's uCallbackMessage (message sent to window when mouse over
	the icon in the taskbar) field."

	self uCallbackMessage: anIntegerMessageNumber.
	self uFlags: (self uFlags bitOr: NIF_MESSAGE)!

szTip
	"Answer the <Utf16String> value of the receiver's 'szTip' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szTip!

szTip: anUtf16String
	"Set the receiver's 'szTip' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(63 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szTip + 1)
		to: _OffsetOf_szTip + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_szTip + size put: 0!

tipText: aString
	"Set the receiver's szTip (tip text) field."

	self szTip: aString.
	self uFlags: (self uFlags bitOr: NIF_TIP)!

uCallbackMessage: anInteger
	"Set the receiver's 'uCallbackMessage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uCallbackMessage put: anInteger!

uFlags
	"Answer the <Integer> value of the receiver's 'uFlags' field."

	^bytes dwordAtOffset: _OffsetOf_uFlags!

uFlags: anInteger
	"Set the receiver's 'uFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uFlags put: anInteger!

uID: anInteger
	"Set the receiver's 'uID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uID put: anInteger! !
!NOTIFYICONDATAW categoriesFor: #dwSize:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #hIcon:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #hWnd:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #icon:!accessing!public! !
!NOTIFYICONDATAW categoriesFor: #message:!accessing!public! !
!NOTIFYICONDATAW categoriesFor: #szTip!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #szTip:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #tipText:!accessing!public! !
!NOTIFYICONDATAW categoriesFor: #uCallbackMessage:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #uFlags!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #uFlags:!**compiled accessors**!public! !
!NOTIFYICONDATAW categoriesFor: #uID:!**compiled accessors**!public! !

!NOTIFYICONDATAW class methodsFor!

defineFields
	"Define the fields of the NOTIFYICONDATA 'structure'.
		self compileDefinition

		struct {
			DWORD cbSize; 
			HWND hWnd; 
			UINT uID; 
			UINT uFlags; 
			UINT uCallbackMessage; 
			HICON hIcon; 
			WCHAR szTip[64]; 
		} NOTIFYICONDATA;
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hWnd type: HANDLEField writeOnly;
		defineField: #uID type: DWORDField writeOnly;
		defineField: #uFlags type: DWORDField new;
		defineField: #uCallbackMessage type: DWORDField writeOnly;
		defineField: #hIcon type: HANDLEField writeOnly;
		defineField: #szTip type: (StringField type: Utf16String length: 64)!

getFieldNames
	^#(#dwSize #hWnd #uID #uFlags #uCallbackMessage #hIcon #szTip)! !
!NOTIFYICONDATAW class categoriesFor: #defineFields!public!template definition! !
!NOTIFYICONDATAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

