"Filed out from Dolphin Smalltalk"!

Canvas subclass: #PrinterCanvas
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PrinterCanvas guid: (GUID fromString: '{87b4c4ff-026e-11d3-9fd7-00a0cc3e4a32}')!
PrinterCanvas comment: ''!
!PrinterCanvas categoriesForClass!Graphics-Drawing! !
!PrinterCanvas methodsFor!

basicFree
	"Private - Free the external resources associated with the receiver."

	self endPage; endDoc.
	super basicFree!

endDoc
	"Signal the end of the current document."

	GDILibrary default endDoc: self asParameter
!

endPage
	"Signal the end of the current page."

	GDILibrary default endPage: self asParameter

!

startDoc
	"Signal the start of a new document."

	self startDocNamed: SessionManager current applicationName!

startDocNamed: aString
	| struct |
	struct := DOCINFOW new.
	struct docName: aString.
	GDILibrary default startDoc: self asParameter lpdi: struct!

startPage
	"Signal the start of a new page."

	GDILibrary default startPage: self asParameter! !
!PrinterCanvas categoriesForMethods!
basicFree!private!realizing/unrealizing! !
endDoc!operations!public! !
endPage!operations!public! !
startDoc!operations!public! !
startDocNamed:!operations!public! !
startPage!operations!public! !
!

!PrinterCanvas class methodsFor!

icon
	^##(self) defaultIcon! !
!PrinterCanvas class categoriesForMethods!
icon!constants!development!public! !
!

