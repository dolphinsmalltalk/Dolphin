"Filed out from Dolphin Smalltalk 7"!

UI.FileDialog subclass: #'UI.FileOpenDialog'
	instanceVariableNames: 'maxFileCount'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FileOpenDialog guid: (Core.GUID fromString: '{87b4c6b5-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FileOpenDialog comment: 'FileOpenDialog is a <valueDialogPresenter> implementing the Windows GetOpenFileName common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen file.

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
!UI.FileOpenDialog categoriesForClass!MVP-Presenters! !
!UI.FileOpenDialog methodsFor!

basicShowModal
	"Private - Show a Open File dialog for the receiver."

	^ComDlgLibrary default getOpenFileName: winStruct!

defaultMaxFileCount
	"Private - Answers the default number of selections that are expected to fit into the buffer. If the maxFileCount is not set, then the FileOpenDialog is operated in single file mode."

	^1!

defaultStyle
	"Private - Answers the style for the receiver."

	^super defaultStyle bitOr: OFN_FILEMUSTEXIST!

maxFileCount
	^maxFileCount ifNil: [self defaultMaxFileCount] ifNotNil: [maxFileCount max: 10]!

maxFileCount: anInteger
	"Set the maximum number of files to be selected. Note that this is not a hard limit - it mainly affects the buffer size, so a larger or smaller number of files may fit depending on the length of the folder path and the file names.
	However, a maximum count of 1 is special in that it means the dialog will operate in single selection mode."

	maxFileCount := anInteger!

style
	"Answers the style flags to be used when the receiver is opened."

	^self maxFileCount > 1 ifTrue: [style | ##(OFN_ALLOWMULTISELECT | OFN_EXPLORER)] ifFalse: [style]! !
!UI.FileOpenDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!UI.FileOpenDialog categoriesFor: #defaultMaxFileCount!constants!private! !
!UI.FileOpenDialog categoriesFor: #defaultStyle!constants!private! !
!UI.FileOpenDialog categoriesFor: #maxFileCount!accessing!public! !
!UI.FileOpenDialog categoriesFor: #maxFileCount:!accessing!public! !
!UI.FileOpenDialog categoriesFor: #style!accessing!public! !

!UI.FileOpenDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !
!UI.FileOpenDialog class categoriesFor: #initialize!development!initializing!private! !

