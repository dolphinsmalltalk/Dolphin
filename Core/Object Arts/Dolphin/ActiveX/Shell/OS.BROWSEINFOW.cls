"Filed out from Dolphin Smalltalk"!

OS.CommonDialogStructure
	subclass: #'OS.BROWSEINFOW'
	instanceVariableNames: 'title displayName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BROWSEINFOW_Size' -> 16r20.
			'_OffsetOf_flags' -> 16r10.
			'_OffsetOf_hwndOwner' -> 16r0.
			'_OffsetOf_iImage' -> 16r1C.
			'_OffsetOf_lParam' -> 16r18.
			'_OffsetOf_lpfnHook' -> 16r14.
			'_OffsetOf_lpszTitle' -> 16rC.
			'_OffsetOf_pidlRoot' -> 16r4.
			'_OffsetOf_pszDisplayName' -> 16r8
		}!

OS.BROWSEINFOW guid: (Core.GUID fromString: '{87b4c5cc-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.BROWSEINFOW comment: 'BROWSEINFO is an <ExternalStructure> class which represents the Windows common dialog structure of the same name.

BROWSEINFO is used in conjunction with the BrowseFolderDialog.'!

!OS.BROWSEINFOW categoriesForClass!External-Data-Structured-Win32! !

!OS.BROWSEINFOW methodsFor!

displayName
	"Answer selected folder's display name."

	^displayName trimNulls!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hwndOwnerOffset
	^_OffsetOf_hwndOwner!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	#todo.	"Support long filenames? Not sure we can as seems to be an API limitation."
	displayName := Utf16String newFixed: Win32Constants.MAX_PATH.
	self pszDisplayName: displayName!

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

lpszTitle: anUtf16String
	"Set the receiver's 'lpszTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszTitle put: anUtf16String yourAddress!

pidlRoot
	"Answer the <Integer> value of the receiver's 'pidlRoot' field."

	^bytes uint32AtOffset: _OffsetOf_pidlRoot!

pidlRoot: anInteger
	"Set the receiver's 'pidlRoot' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_pidlRoot put: anInteger!

pszDisplayName: anUtf16String
	"Set the receiver's 'pszDisplayName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszDisplayName put: anUtf16String yourAddress!

title: text
	"Set the caption/prompt to be displayed in the receiver's dialog to the <String>, text.
	We must hold onto the string to prevent it being prematurely GC'd."

	self lpszTitle: (title := text asUtf16String)! !

!OS.BROWSEINFOW categoriesForMethods!
displayName!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hwndOwnerOffset!constants!private! !
initialize:!initializing!private! !
lpfnHook:!**compiled accessors**!public! !
lpszTitle:!**compiled accessors**!public! !
pidlRoot!**compiled accessors**!public! !
pidlRoot:!**compiled accessors**!public! !
pszDisplayName:!**compiled accessors**!public! !
title:!accessing!public! !
!

!OS.BROWSEINFOW class methodsFor!

byteSize
	^_BROWSEINFOW_Size!

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
		defineField: #hwndOwner type: HANDLEField new beUncompiled;
		defineField: #pidlRoot type: UInt32Field new;
		defineField: #pszDisplayName type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpszTitle type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lParam type: IntPtrField filler;
		defineField: #iImage type: UInt32Field filler!

getFieldNames
	^#(#hwndOwner #pidlRoot #pszDisplayName #lpszTitle #flags #lpfnHook)! !

!OS.BROWSEINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

