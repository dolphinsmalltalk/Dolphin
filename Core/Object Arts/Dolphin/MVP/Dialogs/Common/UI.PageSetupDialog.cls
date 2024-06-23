"Filed out from Dolphin Smalltalk"!

UI.PrintingDialog
	subclass: #'UI.PageSetupDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.PageSetupDialog guid: (Core.GUID fromString: '{e5275a3e-c87b-40b6-b33e-d8348055f22b}')!

UI.PageSetupDialog comment: ''!

!UI.PageSetupDialog methodsFor!

basicShowModal
	"Private - Create and show a new Print dialog. Hang it off the receiver's parent view.
	Answer an new hDC on the selected printer. The hDC should be freed using
	DeleteDC()."

	^ComDlg32 pageSetupDlg: self winStruct!

extractResult: result
	"Private - Extract and apply the result from the parameter structure 
	passed to the Win32 API associated with this common dialog, immediately 
	after the call to that API."

	self value: (result ifTrue: [self winStruct]).
	self apply!

margins
	^self winStruct margins!

margins: aRectangle
	self winStruct margins: aRectangle!

winStructClass
	"Private - Answer the class to use for the receiver's associated windows parameter structure."

	^PAGESETUPDLGW! !

!UI.PageSetupDialog categoriesForMethods!
basicShowModal!private!realizing/unrealizing! !
extractResult:!helpers!private! !
margins!accessing!public! !
margins:!accessing!public! !
winStructClass!constants!private! !
!

