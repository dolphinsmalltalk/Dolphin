"Filed out from Dolphin Smalltalk 7"!

UI.FindDialog subclass: #'UI.FindReplaceDialog'
	instanceVariableNames: 'replaceWith'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.FindReplaceDialog guid: (Core.GUID fromString: '{87b4c6b7-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FindReplaceDialog comment: 'FindReplaceDialog is a <valueDialogPresenter> implementing the Windows ReplaceText common dialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler. 

Instance Variables:
	replaceWith	<readableString> specifying the replacement text.

'!
!UI.FindReplaceDialog categoriesForClass!MVP-Presenters! !
!UI.FindReplaceDialog methodsFor!

basicShowModal
	"Private - Create and show a new FindReplace dialog."

	^ComDlgLibrary default replaceText: self winStruct asParameter!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	replaceWith := Utf16String newFixed: 256!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32
	API associated with this common dialog, immediately prior to the call
	to that API."

	(self winStruct)
		maskIn: FR_DOWN;
		lpstrFindWhat: self findWhat;
		wFindWhatLen: self findWhat size;
		lpstrReplaceWith: self replaceWith;
		wReplaceWithLen: self replaceWith size!

replaceWith
	"Private - Answer the receiver's replaceWith String."

	^replaceWith!

replaceWith: aString
	"Private - Set the receiver's replaceWith String to include aString."

	| size |
	size := self replaceWith size min: aString size.
	self replaceWith replaceFrom: 1 to: size with: aString.! !
!UI.FindReplaceDialog categoriesFor: #basicShowModal!private!realizing/unrealizing! !
!UI.FindReplaceDialog categoriesFor: #initialize!initializing!private! !
!UI.FindReplaceDialog categoriesFor: #prepareStruct!helpers!private! !
!UI.FindReplaceDialog categoriesFor: #replaceWith!accessing!private! !
!UI.FindReplaceDialog categoriesFor: #replaceWith:!accessing!private! !

!UI.FindReplaceDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks!

ownerView: aView findWhat: find replaceWith: replace
	"Create and show a new instance of the receiver with with a aView as the owner."

	^self new
		ownerView: aView;
		findWhat: find;
		replaceWith: replace;
		showModal;
		yourself! !
!UI.FindReplaceDialog class categoriesFor: #initialize!development!initializing!private! !
!UI.FindReplaceDialog class categoriesFor: #ownerView:findWhat:replaceWith:!constants!instance creation!public! !

