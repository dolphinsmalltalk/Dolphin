"Filed out from Dolphin Smalltalk X6"!

Canvas subclass: #PrinterCanvas
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PrinterCanvas guid: (GUID fromString: '{87B4C4FF-026E-11D3-9FD7-00A0CC3E4A32}')!
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
	struct := DOCINFO new.
	struct lpszDocName: aString.
	GDILibrary default startDoc: self asParameter lpdi: struct!

startPage
	"Signal the start of a new page."

	GDILibrary default startPage: self asParameter! !
!PrinterCanvas categoriesFor: #basicFree!private!realizing/unrealizing! !
!PrinterCanvas categoriesFor: #endDoc!operations!public! !
!PrinterCanvas categoriesFor: #endPage!operations!public! !
!PrinterCanvas categoriesFor: #startDoc!operations!public! !
!PrinterCanvas categoriesFor: #startDocNamed:!operations!public! !
!PrinterCanvas categoriesFor: #startPage!operations!public! !

!PrinterCanvas class methodsFor!

icon
	^Icon fromId: 17 in: (ExternalResourceLibrary open: 'Shell32')! !
!PrinterCanvas class categoriesFor: #icon!constants!development!public! !

