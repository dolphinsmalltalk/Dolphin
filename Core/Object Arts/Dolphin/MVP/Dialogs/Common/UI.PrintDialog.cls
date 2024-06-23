"Filed out from Dolphin Smalltalk"!

UI.PrintingDialog
	subclass: #'UI.PrintDialog'
	instanceVariableNames: 'dialogServices flags savedPreferLegacyPrintDialog'
	classVariableNames: ''
	imports: #(#{OS.PrintDialogConstants} #{OS.Win32Errors private})
	classInstanceVariableNames: ''
	classConstants: { 'UnifiedPrintDialogMask' -> 16r1 }!

UI.PrintDialog guid: (Core.GUID fromString: '{87b4c6b4-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.PrintDialog comment: 'PrintDialog is a <valueDialogPresenter> implementing the Windows PrintDlg common dialog. The associated <valueModel> contains an <integer> representing the device context handle (HDC) for the chosen printer.'!

!UI.PrintDialog categoriesForClass!MVP-Presenters! !

!UI.PrintDialog methodsFor!

basicShowModal
	"Private - Create and show a new Print dialog. Hang it off the receiver's parent view.
	Answer an new hDC on the selected printer. The hDC should be freed using
	DeleteDC()."

	savedPreferLegacyPrintDialog := self useLegacyPrintDialog
				ifTrue: [self setPreferLegacyPrintDialog: 1].
	^[ComDlg32 printDlgEx: self winStruct] ensure: [self revertPreferLegacyPrintDialog]!

clsid
	^nil!

copies
	"Answer the number of copies to be printed"

	^self winStruct nCopies.!

copies: anInteger
	"Set the number of copies to be printed"

	^self winStruct nCopies: anInteger.!

createHook
	^self queryInterface: COM.IPrintDialogCallback!

disablePrintSelectionOnly
	^self winStruct disablePrintSelectionOnly!

disconnect
	dialogServices free.
	dialogServices := nil.
	self winStruct lpfnHook: nil.
	hook free.
	hook := nil!

extractResult: result
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	self disconnect.
	self value: (self result == #print ifTrue: [self winStruct hDC]).
	self apply!

finalRelease
	"The last reference to the receiver (as a COM object) has been released."

	!

GetSite: riid ppvSite: ppvSite
	"Implement IObjectWithSite::GetSite()

		HRESULT __stdcall GetSite(
			[in]GUID* riid,
			[out]void** ppvSite);"

	^dialogServices
		ifNil: 
			[ppvSite value: 0.
			E_UNEXPECTED]
		ifNotNil: [dialogServices QueryInterface: riid ppvObject: ppvSite]!

HandleMessage: hDlg uMsg: uiMsg wParam: wParam lParam: lParam pResult: pResult
	view
		ifNil: 
			[self revertPreferLegacyPrintDialog.
			self attachHandle: (User32 getParent: hDlg)].
	(self class hookHandlers lookup: uiMsg)
		ifNotNil: 
			[:selector |
			pResult
				value: (self
						perform: selector
						with: uiMsg
						with: wParam
						with: lParam) asUIntPtr].
	"Return S_FALSE to tell the dialog to perform its default processing. S_OK would suppress."
	^S_FALSE!

InitDone
	"Helpstring: Called when PrintDlgEx has finished initializing the General page of the Print Property Sheet.

		HRESULT __stdcall InitDone();"

	self revertPreferLegacyPrintDialog.
	^S_FALSE!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := 0.
	self winStruct flags: ##(PD_RETURNDC | PD_USEDEVMODECOPIESANDCOLLATE | PD_COLLATE | PD_ALLPAGES)!

pageRange
	"Answers an Interval that dictates the page range to be printed"

	^self winStruct pageRange!

pageRange: anInterval
	"Sets anInterval to dictate the page range to be printed"

	self winStruct pageRange: anInterval!

pageRanges
	^self winStruct pageRanges!

pageRanges: aSequenceOfIntervals
	^self winStruct pageRanges: aSequenceOfIntervals!

printableRange: anInterval
	"Sets anInterval to dictate the page range available"

	self winStruct printableRange: anInterval!

queryInterface: anInterfaceClass
	"Answer a new interface which supports the specified interface protocol
	(usually a class), or nil if the receiver does not support the interface."

	^self queryInterface: anInterfaceClass ifNone: []
!

queryInterface: anInterfaceClass ifNone: exceptionHandler
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(self supportedInterfaces detect: [:ic | ic supportsInterface: anInterfaceClass] ifNone: nil)
		ifNil: [exceptionHandler value]
		ifNotNil: [:class | class on: self implementor: self]!

rangeMode
	^self winStruct rangeMode!

result
	^self winStruct result!

revertPreferLegacyPrintDialog
	savedPreferLegacyPrintDialog ifNil: [^self].
	self setPreferLegacyPrintDialog: savedPreferLegacyPrintDialog.
	savedPreferLegacyPrintDialog := nil!

SelectionChange
	^S_FALSE!

setPreferLegacyPrintDialog: anInteger
	"Private - In order to suppress/enable the Unified Print Dialog, we need to modify a value in the current user hive of the registry. Under the UnifiedPrintDialog key there is a PreferLegacyAppList setting that appears to allow the new dialog to be suppressed on a per-app basis, but it is a single value of indeterminate format (although a REG_MULTISZ setting containing the full path to the .exe seems to work). As a single value it is difficult to maintain, and frankly it is easier to just temporarily usurp the global suppression for legacy apps by setting the simpler PreferLegacyPrintDialog DWORD value. We change this back immediately the legacy dialog is open. If the value is not currently set, then we will leave it set to 0 so that the default behaviour of Windows 11 (i.e. to use the new dialog for other legacy apps) is maintained."

	| existing updRegKey |
	updRegKey := RegKey userRoot createKey: 'Software\Microsoft\Print\UnifiedPrintDialog'.
	existing := updRegKey valueAt: 'PreferLegacyPrintDialog' ifAbsent: 0.
	(anInteger notNil and: [existing ~= anInteger])
		ifTrue: [updRegKey dwordAt: 'PreferLegacyPrintDialog' put: anInteger].
	^existing!

SetSite: anIUnknown
	"Implement IObjectWithSite::SetSite(). Called by the print dialog to pass an IPrintDialogServices, and to null out on tear down.

		HRESULT __stdcall SetSite(
			[in]IUnknown* pUnkSite);"

	anIUnknown isNull
		ifTrue: [self disconnect]
		ifFalse: [dialogServices := anIUnknown queryInterface: COM.IPrintDialogServices].
	^S_OK!

setViewCaption: aString
	self view parentView caption: aString!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	We need only support the standard property notification sink interface since
	all other control container requirements are satisfied by the ATL host window
	that we are wrapping."

	^{ COM.IPrintDialogCallback. COM.IObjectWithSite }!

useLegacyPrintDialog
	"Answer whether the legacy Print Dialog should be used in preference to the new Unified Print Dialog (UPD). Although the UPD looks more in keeping with the general UI style of Windows 11, it (frankly) doesn't work very well for Win32 apps, e.g. the preview pane is always just blank and the page ranges, etc, don't respect the data passed in. The facility to change a setting such as the selected printer, Apply, and then Cancel, is also completely absent. The extensibility interfaces, IPrintDialogCallback and IPrintDialogServices, are also completely missing. For these reason we prefer to use the legacy dialog by default."

	^flags noMask: UnifiedPrintDialogMask!

useLegacyPrintDialog: aBoolean
	flags := flags mask: UnifiedPrintDialogMask set: aBoolean not!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^PRINTDLGEXW! !

!UI.PrintDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
clsid!accessing!public! !
copies!accessing!public! !
copies:!accessing!public! !
createHook!helpers!private! !
disablePrintSelectionOnly!modes!public! !
disconnect!private!realizing/unrealizing! !
extractResult:!helpers!private! !
finalRelease!public!realizing/unrealizing! !
GetSite:ppvSite:!COM Interfaces-IObjectWithSite!public! !
HandleMessage:uMsg:wParam:lParam:pResult:!COM Interfaces-IPrintDialogCallback!public! !
InitDone!COM Interfaces-IPrintDialogCallback!public! !
initialize!initializing!public! !
pageRange!accessing!public! !
pageRange:!accessing!public! !
pageRanges!accessing!public! !
pageRanges:!accessing!public! !
printableRange:!accessing!public! !
queryInterface:!accessing-interfaces!public! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
rangeMode!accessing!public! !
result!helpers!private! !
revertPreferLegacyPrintDialog!helpers!private! !
SelectionChange!COM Interfaces-IPrintDialogCallback!public! !
setPreferLegacyPrintDialog:!accessing!private! !
SetSite:!COM Interfaces-IObjectWithSite!public! !
setViewCaption:!accessing!private! !
supportedInterfaces!constants!public! !
useLegacyPrintDialog!accessing!public! !
useLegacyPrintDialog:!accessing!public! !
winStructClass!constants!private! !
!

UI.PrintDialog methodProtocol: #COMObject attributes: #(#readOnly) selectors: #(#clsid #finalRelease #queryInterface: #queryInterface:ifNone:)!
UI.PrintDialog methodProtocol: #IObjectWithSite attributes: #(#readOnly) selectors: #(#GetSite:ppvSite: #SetSite:)!
UI.PrintDialog methodProtocol: #IPrintDialogCallback attributes: #(#readOnly) selectors: #(#HandleMessage:uMsg:wParam:lParam:pResult: #InitDone #SelectionChange)!

!UI.PrintDialog class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self initializeDefaultHooks! !

!UI.PrintDialog class categoriesForMethods!
initialize!development!initializing!private! !
!

