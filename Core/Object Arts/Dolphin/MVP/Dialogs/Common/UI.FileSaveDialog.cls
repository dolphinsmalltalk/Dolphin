"Filed out from Dolphin Smalltalk 7"!

UI.FileDialog subclass: #'UI.FileSaveDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FileSaveDialog guid: (Core.GUID fromString: '{87b4c6b6-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FileSaveDialog comment: 'FileSaveDialog is a <valueDialogPresenter> implementing the Windows GetSaveFileName common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen file.'!
!UI.FileSaveDialog categoriesForClass!MVP-Presenters! !
!UI.FileSaveDialog methodsFor!

basicShowModal
	"Private - Show a File Save dialog for the receiver."

	^ComDlgLibrary default getSaveFileName: winStruct!

overwritePrompt

	self style: self style | OFN_OVERWRITEPROMPT.
! !
!UI.FileSaveDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!UI.FileSaveDialog categoriesFor: #overwritePrompt!public! !

!UI.FileSaveDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !
!UI.FileSaveDialog class categoriesFor: #initialize!development!initializing!private! !

