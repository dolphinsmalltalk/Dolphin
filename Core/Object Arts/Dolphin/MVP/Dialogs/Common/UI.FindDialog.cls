"Filed out from Dolphin Smalltalk"!

UI.CommonDialog
	subclass: #'UI.FindDialog'
	instanceVariableNames: 'findWhatBuf findDetails'
	classVariableNames: 'HookHandlers'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.FindDialog guid: (Core.GUID fromString: '{87b4c6b2-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.FindDialog comment: 'FindDialog is a <valueDialogPresenter> implementing the Windows FindText common dialog. The dialog must be associated with an owner view capable of responding to the <textFinder> protocol. It will then remain on-screen until dismissed and will forward <FindEvent>s to the owner via its #onFind: event handler.

Instance Variables:
	findWhat		<readableString> or nil, specifying the text to search for.

'!

!UI.FindDialog categoriesForClass!MVP-Presenters! !

!UI.FindDialog methodsFor!

basicShowModal
	"Private - Create and show a new FindText dialog."

	^ComDlg32 findText: self winStruct asParameter!

extractResult: anExternalHandle
	"Private - Extract and apply the result from the parameter structure passed to the Win32 API
	associated with this common dialog, immediately after the call to that API."

	| dialog |
	anExternalHandle isNil ifTrue: [^nil].
	dialog := self view.
	self assert: [dialog handle = anExternalHandle].
	dialog subclassWindow.
	SessionManager.Current inputState windowAt: anExternalHandle put: dialog!

fdFlags
	| fdFlags |
	fdFlags := FR_ENABLEHOOK.
	findDetails isForwards ifTrue: [fdFlags := fdFlags maskSet: FR_DOWN].
	findDetails isCaseSensitive ifTrue: [fdFlags := fdFlags maskSet: FR_MATCHCASE].
	findDetails isWholeWord ifTrue: [fdFlags := fdFlags maskSet: FR_WHOLEWORD].
	^fdFlags!

findWhat
	"Private - Answer the receiver's findWhat String."

	^findWhatBuf!

findWhat: aString 
	"Private - Set the receiver's findWhat String to include aString."

	| size wide|
	findDetails pattern: aString.
	wide := aString asUtf16String.
	size := self findWhat size min: wide size.
	self findWhat 
		replaceFrom: 1
		to: size
		with: wide
		startingAt: 1!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	findWhatBuf := Utf16String newFixed: 256.
	findDetails := self class defaultModel!

prepareStruct
	"Private - Initialize the parameter structure to be passed to the Win32 API associated with
	this common dialog, immediately prior to the call to that API."

	(self winStruct)
		lpstrFindWhat: self findWhat;
		maskIn: self fdFlags;
		wFindWhatLen: self findWhat size!

setFindDetails: aFindDetails 
	findDetails := aFindDetails.
	self findWhat: aFindDetails pattern!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^FINDREPLACEW! !

!UI.FindDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
extractResult:!helpers!private! !
fdFlags!accessing!private! !
findWhat!accessing!private! !
findWhat:!accessing!private! !
initialize!initializing!private! !
prepareStruct!helpers!private! !
setFindDetails:!accessing!private! !
winStructClass!constants!private! !
!

!UI.FindDialog class methodsFor!

defaultModel
	^FindDetails new!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks!

ownerView: aView
	"Create and show a new instance of the receiver with
	aView as the owner."

	^self new
		initialize;
		ownerView: aView;
		showModal;
		yourself!

ownerView: aView findWhat: findString
	"Create and show a new instance of the receiver with
	aView as the owner. Pre-populate the dialog with the
	argument findString."

	^self new
		ownerView: aView;
		findWhat: findString;
		showModal;
		yourself!

showModeless: aView on: aFindDetails 
	| dialog |
	dialog := (self new)
				setFindDetails: aFindDetails;
				ownerView: aView.
	"N.B. Doesn't really show as a modal dialog"
	dialog showModal! !

!UI.FindDialog class categoriesForMethods!
defaultModel!public! !
initialize!development!initializing!private! !
ownerView:!instance creation!public! !
ownerView:findWhat:!instance creation!public! !
showModeless:on:!public! !
!

