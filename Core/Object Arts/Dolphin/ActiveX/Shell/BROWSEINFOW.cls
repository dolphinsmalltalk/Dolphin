"Filed out from Dolphin Smalltalk"!

CommonDialogStructure subclass: #BROWSEINFOW
	instanceVariableNames: 'title displayName'
	classVariableNames: '_OffsetOf_flags _OffsetOf_hwndOwner _OffsetOf_iImage _OffsetOf_lParam _OffsetOf_lpfnHook _OffsetOf_lpszTitle _OffsetOf_pidlRoot _OffsetOf_pszDisplayName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BROWSEINFOW guid: (GUID fromString: '{87b4c5cc-026e-11d3-9fd7-00a0cc3e4a32}')!

BROWSEINFOW addClassConstant: '_OffsetOf_flags' value: 16r10!
BROWSEINFOW addClassConstant: '_OffsetOf_hwndOwner' value: 16r0!
BROWSEINFOW addClassConstant: '_OffsetOf_iImage' value: 16r1C!
BROWSEINFOW addClassConstant: '_OffsetOf_lParam' value: 16r18!
BROWSEINFOW addClassConstant: '_OffsetOf_lpfnHook' value: 16r14!
BROWSEINFOW addClassConstant: '_OffsetOf_lpszTitle' value: 16rC!
BROWSEINFOW addClassConstant: '_OffsetOf_pidlRoot' value: 16r4!
BROWSEINFOW addClassConstant: '_OffsetOf_pszDisplayName' value: 16r8!

BROWSEINFOW comment: 'BROWSEINFO is an <ExternalStructure> class which represents the Windows common dialog structure of the same name.

BROWSEINFO is used in conjunction with the BrowseFolderDialog.'!

!BROWSEINFOW categoriesForClass!External-Data-Structured-Win32! !

!BROWSEINFOW methodsFor!

displayName
	"Answer selected folder's display name."

	^displayName trimNulls!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

hookFlag
	^0!

hwndOwner: anInteger
	"Set the receiver's 'hwndOwner' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hwndOwner put: anInteger!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	displayName := File pathBuffer.
	self pszDisplayName: displayName!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

lpszTitle: anUtf16String
	"Set the receiver's 'lpszTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszTitle put: anUtf16String yourAddress!

ownerView: aView
	"Set the owning window of the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

pidlRoot
	"Answer the <Integer> value of the receiver's 'pidlRoot' field."

	^bytes dwordAtOffset: _OffsetOf_pidlRoot!

pidlRoot: anInteger
	"Set the receiver's 'pidlRoot' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_pidlRoot put: anInteger!

pszDisplayName: anUtf16String
	"Set the receiver's 'pszDisplayName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszDisplayName put: anUtf16String yourAddress!

title: text
	"Set the caption/prompt to be displayed in the receiver's dialog to the <String>, text.
	We must hold onto the string to prevent it being prematurely GC'd."

	self lpszTitle: (title := text asUtf16String)! !

!BROWSEINFOW categoriesForMethods!
displayName!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hookFlag!constants!public! !
hwndOwner:!**compiled accessors**!public! !
initialize:!initializing!private! !
lpfnHook:!**compiled accessors**!public! !
lpszTitle:!**compiled accessors**!public! !
ownerView:!accessing!public! !
pidlRoot!**compiled accessors**!public! !
pidlRoot:!**compiled accessors**!public! !
pszDisplayName:!**compiled accessors**!public! !
title:!accessing!public! !
!

!BROWSEINFOW class methodsFor!

defineFields
	"Define the fields of the Win32 BROWSEINFOW structure

		self compileDefinition

	typedef struct _browseinfoW {
		HWND hwndOwner;			// Dialog owner
		LPCITEMIDLIST pidlRoot;		// Item list specifying root folder
		LPWSTR pszDisplayName;		// _MAX_PATH sized buffer to receive selected folder
		LPCWSTR lpszTitle;			// Caption/prompt text
		UINT ulFlags;				//  Option flags
		BFFCALLBACK  lpfn;			// Callback function address
		LPARAM lParam;			// extra info to be passed to callback
		int iImage;				// Image index of selected folder on return
		} BROWSEINFOW;"

	self
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #pidlRoot type: DWORDField new;
		defineField: #pszDisplayName type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpszTitle type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lParam type: INT_PTRField filler;
		defineField: #iImage type: DWORDField filler!

getFieldNames
	^#(#hwndOwner #pidlRoot #pszDisplayName #lpszTitle #flags #lpfnHook)! !

!BROWSEINFOW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

