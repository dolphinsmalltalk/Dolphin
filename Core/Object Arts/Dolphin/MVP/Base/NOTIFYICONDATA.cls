"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #NOTIFYICONDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NOTIFYICONDATA guid: (GUID fromString: '{70CB825F-18F0-4968-9638-A8444B0BD805}')!
NOTIFYICONDATA comment: ''!
!NOTIFYICONDATA categoriesForClass!No category! !
!NOTIFYICONDATA methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

hIcon: anObject 
	"Set the receiver's hIcon field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hIcon) put: anObject!

hWnd: anObject 
	"Set the receiver's hWnd field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hWnd) put: anObject!

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
	"Answer the receiver's szTip field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #szTip)!

szTip: anObject 
	"Set the receiver's szTip field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: 63.
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #szTip) + 1)
		to: ##(self offsetOf: #szTip) + size
		startingAt: 1.
	bytes byteAtOffset: ##(self offsetOf: #szTip) + size put: 0!

tipText: aString
	"Set the receiver's szTip (tip text) field."

	self szTip: aString.
	self uFlags: (self uFlags bitOr: NIF_TIP)!

uCallbackMessage: anObject 
	"Set the receiver's uCallbackMessage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #uCallbackMessage) put: anObject!

uFlags
	"Answer the receiver's uFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)!

uFlags: anObject 
	"Set the receiver's uFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #uFlags) put: anObject!

uID: anObject 
	"Set the receiver's uID field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #uID) put: anObject! !
!NOTIFYICONDATA categoriesFor: #dwSize:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #hIcon:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #hWnd:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #icon:!accessing!public! !
!NOTIFYICONDATA categoriesFor: #message:!accessing!public! !
!NOTIFYICONDATA categoriesFor: #szTip!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #szTip:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #tipText:!accessing!public! !
!NOTIFYICONDATA categoriesFor: #uCallbackMessage:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #uFlags!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #uFlags:!**compiled accessors**!public! !
!NOTIFYICONDATA categoriesFor: #uID:!**compiled accessors**!public! !

!NOTIFYICONDATA class methodsFor!

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
			char szTip[64]; 
		} NOTIFYICONDATA;
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hWnd type: HANDLEField writeOnly;
		defineField: #uID type: DWORDField writeOnly;
		defineField: #uFlags type: DWORDField new;
		defineField: #uCallbackMessage type: DWORDField writeOnly;
		defineField: #hIcon type: HANDLEField writeOnly;
		defineField: #szTip type: (StringField length: 64)! !
!NOTIFYICONDATA class categoriesFor: #defineFields!initializing!public! !

