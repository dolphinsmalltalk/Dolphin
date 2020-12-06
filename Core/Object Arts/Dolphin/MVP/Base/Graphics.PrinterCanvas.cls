"Filed out from Dolphin Smalltalk 7"!

Graphics.Canvas subclass: #'Graphics.PrinterCanvas'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.PrinterCanvas guid: (Core.GUID fromString: '{87b4c4ff-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.PrinterCanvas comment: ''!
!Graphics.PrinterCanvas categoriesForClass!Graphics-Drawing! !
!Graphics.PrinterCanvas methodsFor!

basicFree
	"Private - Free the external resources associated with the receiver."

	self endPage; endDoc.
	super basicFree!

endDoc
	"Signal the end of the current document."

	GDILibrary default endDoc: self asParameter!

endPage
	"Signal the end of the current page."

	GDILibrary default endPage: self asParameter!

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
!Graphics.PrinterCanvas categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.PrinterCanvas categoriesFor: #endDoc!operations!public! !
!Graphics.PrinterCanvas categoriesFor: #endPage!operations!public! !
!Graphics.PrinterCanvas categoriesFor: #startDoc!operations!public! !
!Graphics.PrinterCanvas categoriesFor: #startDocNamed:!operations!public! !
!Graphics.PrinterCanvas categoriesFor: #startPage!operations!public! !

!Graphics.PrinterCanvas class methodsFor!

icon
	^##(self) defaultIcon! !
!Graphics.PrinterCanvas class categoriesFor: #icon!constants!development!public! !

