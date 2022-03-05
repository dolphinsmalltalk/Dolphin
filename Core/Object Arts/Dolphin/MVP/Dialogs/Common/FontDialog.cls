"Filed out from Dolphin Smalltalk"!

CommonDialog subclass: #FontDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FontDialog guid: (GUID fromString: '{87b4c6b3-026e-11d3-9fd7-00a0cc3e4a32}')!
FontDialog comment: 'FontDialog is a <valueDialogPresenter> implementing the Windows ChooseFont common dialog. The associated <valueModel> contains the <Font> chosen.

Instance Variables:
	logFont		<LOGFONT> holding the logical font information for the font chosen.


'!
!FontDialog categoriesForClass!MVP-Presenters! !
!FontDialog methodsFor!

basicShowModal
	"Private - Show the common Font dialog."

	^ComDlgLibrary default chooseFont: self winStruct asParameter!

extractResult: result 
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	result ifFalse: [^self].
	self value: (Font fromLogFont: self winStruct logFont).
	self apply!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self winStruct maskIn: ##(CF_SCREENFONTS | CF_INITTOLOGFONTSTRUCT)!

model: aValueModel
	"Set the model of the receiver to be aValueModel."

	| font lf lfw |
	super model: aValueModel.
	font := self value ifNil: [Font default].
	"Might be a legacy Font instance with a LOGFONTA description, but we need a LOGFONTW"
	lf := font logFont.
	lfw := LOGFONTW new.
	lfw replaceFrom: 1 to: lf byteSize with: lf bytes startingAt: 1.
	lfw faceName: lf faceName.
	self winStruct logFont: lfw!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^CHOOSEFONTW! !
!FontDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
extractResult:!helpers!private! !
initialize!public! !
model:!public! !
winStructClass!constants!private! !
!

!FontDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Font system asValue
!

icon
	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	hookHandlers := IdentityDictionary new.
	hookHandlers at: WM_INITDIALOG put: #wmInitDialog:wParam:lParam:! !
!FontDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!development!initializing!private! !
!

