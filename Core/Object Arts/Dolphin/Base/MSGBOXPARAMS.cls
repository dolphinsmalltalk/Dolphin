"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #MSGBOXPARAMS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
MSGBOXPARAMS guid: (GUID fromString: '{87B4C600-026E-11D3-9FD7-00A0CC3E4A32}')!
MSGBOXPARAMS comment: 'MSGBOXPARAMS is an <ExternalStructure> class which represents the Windows structure of the same name.

MSGBOXPARAMS is used to contain configuration details for Message Boxes.

Instance Variables:
	iconId	<integer> or <String> id of icon to be displayed in the box
	text	<String> Text to be display in box (address stored in struct, so need to prevent premature GC)
	caption 	<String> Caption of box (ditto)
	owner	<ExternalHandle>. Handle of owner view'!
!MSGBOXPARAMS categoriesForClass!External-Data-Structured-Win32! !
!MSGBOXPARAMS methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwStyle: anObject 
	"Set the receiver's dwStyle field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwStyle) put: anObject!

hInstance: anObject 
	"Set the receiver's hInstance field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hInstance) put: anObject!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

lpszCaption: anObject 
	"Set the receiver's lpszCaption field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszCaption) put: anObject yourAddress!

lpszIcon: anObject 
	"Set the receiver's lpszIcon field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lpszIcon) put: anObject!

lpszText: anObject 
	"Set the receiver's lpszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszText) put: anObject yourAddress! !
!MSGBOXPARAMS categoriesFor: #dwSize:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #dwStyle:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #hInstance:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #lpszCaption:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #lpszIcon:!**compiled accessors**!public! !
!MSGBOXPARAMS categoriesFor: #lpszText:!**compiled accessors**!public! !

!MSGBOXPARAMS class methodsFor!

defineFields
	"Define the fields of the Win32 MSGBOXPARAMS structure.

		MSGBOXPARAMS compileDefinition

	typedef struct {
			UINT cbSize;
			HWND hwndOwner;
			HINSTANCE hInstance;
			LPCSTR lpszText;
			LPCSTR lpszCaption;
			DWORD dwStyle;
			LPCSTR lpszIcon;
			DWORD dwContextHelpId;
			MSGBOXCALLBACK lpfnMsgBoxCallback;
			DWORD dwLanguageId;
		} MSGBOXPARAMS, *PMSGBOXPARAMS, FAR *LPMSGBOXPARAMS; 
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #hInstance type: DWORDField writeOnly;
		defineField: #lpszText type: (PointerField type: String) beWriteOnly;
		defineField: #lpszCaption type: (PointerField type: String) beWriteOnly;
		defineField: #dwStyle type: DWORDField writeOnly;
		defineField: #lpszIcon type: DWORDField writeOnly;
		beUncompiled;
		defineField: #dwContextHelpId type: DWORDField filler;
		defineField: #lpfnMsgBoxCallback type: DWORDField filler;
		defineField: #dwLanguageId type: DWORDField writeOnly
	"This field can hold a string, or an integer resource id"! !
!MSGBOXPARAMS class categoriesFor: #defineFields!initializing!public! !

