"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #NOTIFYICONDATAW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NOTIFYICONDATAW guid: (GUID fromString: '{70cb825f-18f0-4968-9638-a8444b0bd805}')!
NOTIFYICONDATAW comment: ''!
!NOTIFYICONDATAW categoriesForClass!No category! !
!NOTIFYICONDATAW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

hIcon: anExternalHandle
	"Set the receiver's 'hIcon' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hIcon) put: anExternalHandle!

hWnd: anExternalHandle
	"Set the receiver's 'hWnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hWnd) put: anExternalHandle!

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

	^Utf16String fromAddress: bytes yourAddress + ##(self offsetOf: #szTip)!

szTip: anUtf16String
	"Set the receiver's 'szTip' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(63 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szTip) + 1)
		to: ##(self offsetOf: #szTip) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #szTip) + size put: 0!

tipText: aString
	"Set the receiver's szTip (tip text) field."

	self szTip: aString.
	self uFlags: (self uFlags bitOr: NIF_TIP)!

uCallbackMessage: anInteger
	"Set the receiver's 'uCallbackMessage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #uCallbackMessage) put: anInteger!

uFlags
	"Answer the <Integer> value of the receiver's 'uFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)!

uFlags: anInteger
	"Set the receiver's 'uFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #uFlags) put: anInteger!

uID: anInteger
	"Set the receiver's 'uID' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #uID) put: anInteger! !
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
		defineField: #szTip type: (StringField type: Utf16String length: 64)! !
!NOTIFYICONDATAW class categoriesFor: #defineFields!initializing!public! !

