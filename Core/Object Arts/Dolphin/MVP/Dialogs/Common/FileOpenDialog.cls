"Filed out from Dolphin Smalltalk X6"!

FileDialog subclass: #FileOpenDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileOpenDialog guid: (GUID fromString: '{87B4C6B5-026E-11D3-9FD7-00A0CC3E4A32}')!
FileOpenDialog comment: 'FileOpenDialog is a <valueDialogPresenter> implementing the Windows GetOpenFileName common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen file.

The following example illustrates the use of a validation block to limit the choice of file that the user can make:

dialog := FileOpenDialog new.
dialog
	caption: ''Choose a writeable text file'';
	fileTypes: (Array with: FileDialog textFilesType with: FileDialog allFilesType);
	validationBlock: 
			[:path | 
			(File isWriteable: path) or: 
					[MessageBox errorMsg: ''Sorry but that file is not writeable. Please choose another.''.
					false]];
	showModal'!
!FileOpenDialog categoriesForClass!MVP-Presenters! !
!FileOpenDialog methodsFor!

commonDialogSelector
	"Private - Answer the selector to use to get the result."

	^#getOpenFileName:
!

defaultStyle
	"Answers the style for the receiver."

	^super defaultStyle bitOr: OFN_FILEMUSTEXIST! !
!FileOpenDialog categoriesFor: #commonDialogSelector!constants!private! !
!FileOpenDialog categoriesFor: #defaultStyle!constants!public! !

!FileOpenDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !
!FileOpenDialog class categoriesFor: #initialize!initializing!private! !

