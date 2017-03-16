"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #BROWSEINFO
	instanceVariableNames: 'title displayName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BROWSEINFO guid: (GUID fromString: '{87b4c5cc-026e-11d3-9fd7-00a0cc3e4a32}')!
BROWSEINFO comment: 'BROWSEINFO is an <ExternalStructure> class which represents the Windows common dialog structure of the same name.

BROWSEINFO is used in conjunction with the BrowseFolderDialog.'!
!BROWSEINFO categoriesForClass!External-Data-Structured-Win32! !
!BROWSEINFO methodsFor!

displayName
	"Answer selected folder's display name."

	^displayName trimNulls!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

hookFlag
	^0!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	displayName := File pathBuffer.
	self pszDisplayName: displayName!

lpfnHook: anObject 
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anObject!

lpszTitle: anObject 
	"Set the receiver's lpszTitle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszTitle) put: anObject yourAddress!

ownerView: aView
	"Set the owning window of the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull ifFalse: [self hwndOwner: hWnd].!

pidlRoot
	"Answer the receiver's pidlRoot field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #pidlRoot)!

pidlRoot: anObject 
	"Set the receiver's pidlRoot field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #pidlRoot) put: anObject!

pszDisplayName: anObject 
	"Set the receiver's pszDisplayName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pszDisplayName) put: anObject yourAddress!

title: text
	"Set the caption/prompt to be displayed in the receiver's dialog to the <String>, text.
	We must hold onto the string to prevent it being prematurely GC'd."

	self lpszTitle: (title := text)! !
!BROWSEINFO categoriesFor: #displayName!accessing!public! !
!BROWSEINFO categoriesFor: #flags!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #flags:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #hookFlag!constants!public! !
!BROWSEINFO categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #initialize:!initializing!private! !
!BROWSEINFO categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #lpszTitle:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #ownerView:!accessing!public! !
!BROWSEINFO categoriesFor: #pidlRoot!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #pidlRoot:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #pszDisplayName:!**compiled accessors**!public! !
!BROWSEINFO categoriesFor: #title:!accessing!public! !

!BROWSEINFO class methodsFor!

defineFields
	"Define the fields of the Win32 BROWSEINFO structure

		BROWSEINFO compileDefinition

	typedef struct _browseinfoA {
		HWND hwndOwner;			// Dialog owner
		LPCITEMIDLIST pidlRoot;		// Item list specifying root folder
		LPSTR pszDisplayName;		// _MAX_PATH sized buffer to receive selected folder
		LPCSTR lpszTitle;			// Caption/prompt text
		UINT ulFlags;				//  Option flags
		BFFCALLBACK  lpfn;			// Callback function address
		LPARAM lParam;			// extra info to be passed to callback
		int iImage;				// Image index of selected folder on return
		} BROWSEINFOA;"

	self
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #pidlRoot type: DWORDField new;
		defineField: #pszDisplayName type: (PointerField type: String) beWriteOnly;
		defineField: #lpszTitle type: (PointerField type: String) beWriteOnly;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lParam type: INT_PTRField filler;
		defineField: #iImage type: DWORDField filler! !
!BROWSEINFO class categoriesFor: #defineFields!initializing!public! !

