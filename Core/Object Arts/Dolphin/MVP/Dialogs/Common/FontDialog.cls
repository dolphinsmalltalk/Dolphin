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
	self value: (Font fromLogFont: self winStruct logFont dpi: SystemMetrics current dpi).
	self apply!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self winStruct maskIn: ##(CF_SCREENFONTS | CF_INITTOLOGFONTSTRUCT)!

model: aValueModel
	"Set the model of the receiver to be aValueModel."

	| font lf sysmetrics |
	super model: aValueModel.
	"Note that the LOGFONT we pass to the dialog must be scaled for the current system DPI, regardless of the DPI of the monitor where the dialog is opened."
	sysmetrics := SystemMetrics current.
	font := (self value ifNil: [sysmetrics iconTitleFont]) atDpi: sysmetrics dpi.
	lf := font logFont copy.
	"If the font's height is specified as cell height, ensure translated to character height."
	lf lfHeight > 0 ifTrue: [lf lfHeight: font pixelSize negated].
	self winStruct logFont: lf!

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

