"Filed out from Dolphin Smalltalk X6"!

FileDialog subclass: #FileSaveDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSaveDialog guid: (GUID fromString: '{87B4C6B6-026E-11D3-9FD7-00A0CC3E4A32}')!
FileSaveDialog comment: 'FileSaveDialog is a <valueDialogPresenter> implementing the Windows GetSaveFileName common dialog. The associated <valueModel> contains a <readableString> indicating the path of the chosen file.'!
!FileSaveDialog categoriesForClass!MVP-Presenters! !
!FileSaveDialog methodsFor!

commonDialogSelector
	"Private - Answer the selector to use to get the result."

	^#getSaveFileName:
! !
!FileSaveDialog categoriesFor: #commonDialogSelector!constants!private! !

!FileSaveDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !
!FileSaveDialog class categoriesFor: #initialize!initializing!private! !

