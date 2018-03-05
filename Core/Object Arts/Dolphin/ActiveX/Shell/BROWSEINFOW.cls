"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #BROWSEINFOW
	instanceVariableNames: 'title displayName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BROWSEINFOW guid: (GUID fromString: '{87b4c5cc-026e-11d3-9fd7-00a0cc3e4a32}')!
BROWSEINFOW comment: 'BROWSEINFO is an <ExternalStructure> class which represents the Windows common dialog structure of the same name.

BROWSEINFO is used in conjunction with the BrowseFolderDialog.'!
!BROWSEINFOW categoriesForClass!External-Data-Structured-Win32! !
!BROWSEINFOW methodsFor!

displayName
	"Answer selected folder's display name."

	^displayName trimNulls!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

hookFlag
	^0!

hwndOwner: anInteger
	"Set the receiver's 'hwndOwner' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	displayName := Utf16String new: File maxPath.
	self pszDisplayName: displayName!

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anExternalAddress!

lpszTitle: anUtf16String
	"Set the receiver's 'lpszTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszTitle) put: anUtf16String yourAddress!

ownerView: aView
	"Set the owning window of the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

pidlRoot
	"Answer the <Integer> value of the receiver's 'pidlRoot' field."

	^bytes dwordAtOffset: ##(self offsetOf: #pidlRoot)!

pidlRoot: anInteger
	"Set the receiver's 'pidlRoot' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #pidlRoot) put: anInteger!

pszDisplayName: anUtf16String
	"Set the receiver's 'pszDisplayName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #pszDisplayName) put: anUtf16String yourAddress!

title: text
	"Set the caption/prompt to be displayed in the receiver's dialog to the <String>, text.
	We must hold onto the string to prevent it being prematurely GC'd."

	self lpszTitle: (title := text asUtf16String)! !
!BROWSEINFOW categoriesFor: #displayName!accessing!public! !
!BROWSEINFOW categoriesFor: #flags!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #flags:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #hookFlag!constants!public! !
!BROWSEINFOW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #initialize:!initializing!private! !
!BROWSEINFOW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #lpszTitle:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #ownerView:!accessing!public! !
!BROWSEINFOW categoriesFor: #pidlRoot!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #pidlRoot:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #pszDisplayName:!**compiled accessors**!public! !
!BROWSEINFOW categoriesFor: #title:!accessing!public! !

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
		defineField: #iImage type: DWORDField filler! !
!BROWSEINFOW class categoriesFor: #defineFields!initializing!public! !

