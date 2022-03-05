"Filed out from Dolphin Smalltalk"!

CommonDialog subclass: #PrintDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'PrintDialogConstants'
	classInstanceVariableNames: ''!
PrintDialog guid: (GUID fromString: '{87b4c6b4-026e-11d3-9fd7-00a0cc3e4a32}')!
PrintDialog comment: 'PrintDialog is a <valueDialogPresenter> implementing the Windows PrintDlg common dialog. The associated <valueModel> contains an <integer> representing the device context handle (HDC) for the chosen printer.'!
!PrintDialog categoriesForClass!MVP-Presenters! !
!PrintDialog methodsFor!

basicShowModal
	"Private - Create and show a new Print dialog. Hang it off the receiver's parent view.
	Answer an new hDC on the selected printer. The hDC should be freed using
	DeleteDC()."

	^ComDlgLibrary default printDlg: self winStruct asParameter!

copies
	"Answer the number of copies to be printed"

	^self winStruct nCopies.!

copies: anInteger
	"Set the number of copies to be printed"

	^self winStruct nCopies: anInteger.!

extractResult: result 
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	result ifFalse: [^self checkError].
	self value: self winStruct hDC.
	self apply!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self winStruct maskIn: ##(PD_RETURNDC | PD_USEDEVMODECOPIES | PD_COLLATE)!

pageRange: anInterval
	"Sets aInterval to dicate the page range available"

	self winStruct 
		nMinPage: anInterval first;
		nMaxPage: anInterval last.
!

printRange
	"Answers an Interval that dicates the page range to be printed"

	^self winStruct nFromPage to: self winStruct nToPage.!

printRange: anInterval
	"Sets aInterval to dicate the page range to be printed"

	self winStruct 
		nFromPage: anInterval first;
		nToPage: anInterval last.
!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^PRINTDLGW! !
!PrintDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
copies!accessing!public! !
copies:!accessing!public! !
extractResult:!helpers!private! !
initialize!public! !
pageRange:!accessing!public! !
printRange!accessing!public! !
printRange:!accessing!public! !
winStructClass!constants!private! !
!

