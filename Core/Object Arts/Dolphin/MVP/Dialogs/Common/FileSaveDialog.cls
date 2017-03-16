"Filed out from Dolphin Smalltalk 7"!

FileDialog subclass: #FileSaveDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSaveDialog guid: (GUID fromString: '{87b4c6b6-026e-11d3-9fd7-00a0cc3e4a32}')!
FileSaveDialog comment: 'FileSaveDialog is a <valueDialogPresenter> implementing the Windows GetSaveFileName common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen file.'!
!FileSaveDialog categoriesForClass!MVP-Presenters! !
!FileSaveDialog methodsFor!

commonDialogSelector
	"Private - Answer the selector to use to get the result."

	^#getSaveFileName:
!

overwritePrompt

	self style: self style | OFN_OVERWRITEPROMPT.
! !
!FileSaveDialog categoriesFor: #commonDialogSelector!constants!private! !
!FileSaveDialog categoriesFor: #overwritePrompt!public! !

!FileSaveDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !
!FileSaveDialog class categoriesFor: #initialize!initializing!private! !

