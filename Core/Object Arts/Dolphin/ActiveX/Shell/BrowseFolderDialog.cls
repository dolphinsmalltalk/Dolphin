"Filed out from Dolphin Smalltalk"!

CommonDialog subclass: #BrowseFolderDialog
	instanceVariableNames: 'style bfFlags'
	classVariableNames: 'InitializedMask'
	poolDictionaries: 'ShellConstants'
	classInstanceVariableNames: ''!

BrowseFolderDialog guid: (GUID fromString: '{87b4c6af-026e-11d3-9fd7-00a0cc3e4a32}')!

BrowseFolderDialog comment: 'BrowserFolderDialog is a <valueDialogPresenter> implementing the Windows SHBrowseForFolder common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen folder.

Instance Variables:
	style	<integer> Windows style flags for the common dialog.
	bfFlags	<integer>. Various flags.

Class Variables:
	InitializedMask	<integer>. Bit mask for isInitialized flag.

Example Usage:
	BrowseFolderDialog new 
		caption: ''Dolphin Smalltalk'';
		title: ''Please select a folder'';
		root: ''c:\windows'';			"Root of tree"
		value: ''c:\windows\system'';		"Initial selection"
		showModal'!

!BrowseFolderDialog categoriesForClass!MVP-Presenters! !

!BrowseFolderDialog methodsFor!

basicShowModal
	"Private - Open a common folder browse dialog."

	^ShellLibrary default SHBrowseForFolder: winStruct!

caption: aString 
	"Sets the caption for the receiver to aString"

	self winStruct title: aString!

defaultStyle
	"Private - Answers the default style for the receiver."

	^##(BIF_RETURNONLYFSDIRS | BIF_DONTGOBELOWDOMAIN | BIF_RETURNFSANCESTORS | BIF_USENEWUI)	"| BIF_STATUSTEXT"!

extractResult: idList
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	| pathname |
	idList isNull ifTrue: [self value: nil. ^nil].
	pathname := self pathFromIDList: idList.
	"WindowsShellMemory free: idList."
	pathname notNil ifTrue: [
		self value: pathname.
		self apply].!

initialize
	"Private - Initialize the receiver"

	super initialize.
	bfFlags := 0.
	self style: self defaultStyle!

isInitialized
	"Private - Answer whether the dialog has been initialized."

	^bfFlags allMask: InitializedMask!

iunknown: hWnd wParam: wParam lParam: lParam 
	"Private - Handler for BFFM_IUNKNOWN message sent through hook. lParam is the
	IUnknown*interface."

	!

pathFromIDList: idList 
	"Private - Answer the <readableString> path corresponding to the IDLIST
	argument."

	^ShellLibrary default pathFromIDList: idList!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32
	API associated with this common dialog, immediately prior to the call
	to that API."

	self winStruct maskIn: self style!

root: path
	"Sets the root for the receiver to the <readableString>, path."
	
	| pi |
	pi := ShellLibrary default getDesktopFolder.
	self winStruct pidlRoot: (pi pidlFromPath: path).
	pi free!

selChanged: msg wParam: anObject lParam: pidl 
	"Private - Handler for BFFM_SELCHANGED message sent through hook. A #valueChanged event will
	be triggered off the receiver's model, so we don't need to trigger any further event
	directly."

	| path |
	path := self pathFromIDList: pidl.
	self isInitialized ifTrue: [self value: path].
	^0!

style
	"Answers the style for the receiver."
	
	^style!

style: anInteger
	"Set the style for the receiver to anInteger which is assumed to contained one or more
	BIF_XXX constants."
	
	style := anInteger!

title: aString 
	"Sets the title for the receiver to the <readableString> argument. Note that this does not
	affect the caption of the dialog box (which can be changed by setting the #caption: in the
	normal way) but is a prompt displayed inside the dialog."

	self winStruct title: aString!

validateFailed: msgInteger wParam: wParam lParam: lParam 
	"Private - Handler for BFFM_VALIDATEFAILEDW message sent through hook. lParam is address of
	data which failed validation (i.e. path string). Answer 0 to dismiss dialog, non-zero to
	leave open."

	| badPath |
	badPath := Utf16String fromAddress: lParam.
	^1!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^BROWSEINFOW!

wmInitDialog: msgInteger wParam: wParam lParam: lParam
	"Private - Handler for BFFM_INITIALIZED message sent through callback.
	Set up the initially selected folder to the starting value of the receiver's model."

	| path |
	super
		wmInitDialog: msgInteger
		wParam: wParam
		lParam: lParam.
	path := self value.
	(path notNil and: [path notEmpty])
		ifTrue: 
			[view
				sendMessage: BFFM_SETSELECTIONW
				wParam: true asParameter
				szParam: path].
	bfFlags := bfFlags mask: InitializedMask set: true.
	^0! !

!BrowseFolderDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
caption:!accessing!public! !
defaultStyle!constants!private! !
extractResult:!operations!private! !
initialize!initializing!private! !
isInitialized!private!testing! !
iunknown:wParam:lParam:!event handling!private! !
pathFromIDList:!helpers!private! !
prepareStruct!helpers!private! !
root:!accessing!public! !
selChanged:wParam:lParam:!event handling!private! !
style!accessing!public! !
style:!accessing!public! !
title:!accessing!public! !
validateFailed:wParam:lParam:!event handling!private! !
winStructClass!constants!private! !
wmInitDialog:wParam:lParam:!event handling!private! !
!

!BrowseFolderDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asValue
!

icon
	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	hookHandlers := Array new: 5.
	hookHandlers
		at: BFFM_INITIALIZED put: #wmInitDialog:wParam:lParam:;
		at: BFFM_SELCHANGED put: #selChanged:wParam:lParam:;
		at: BFFM_VALIDATEFAILEDA put: #validateFailed:wParam:lParam:;
		at: 4 put: nil;
		at: BFFM_IUNKNOWN put: #iunknown:wParam:lParam:.
	InitializedMask := 16r1! !

!BrowseFolderDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!initializing!private! !
!

