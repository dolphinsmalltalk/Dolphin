"Filed out from Dolphin Smalltalk"!

Graphics.Canvas
	subclass: #'Graphics.PrinterCanvas'
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

	Gdi32 endDoc: self asParameter!

endPage
	"Signal the end of the current page."

	Gdi32 endPage: self asParameter!

startDoc
	"Signal the start of a new document."

	self startDocNamed: SessionManager current applicationName!

startDocNamed: aString
	| struct |
	struct := DOCINFOW new.
	struct docName: aString.
	Gdi32 startDoc: self asParameter lpdi: struct!

startPage
	"Signal the start of a new page."

	Gdi32 startPage: self asParameter! !

!Graphics.PrinterCanvas categoriesForMethods!
basicFree!private!realizing/unrealizing! !
endDoc!operations!public! !
endPage!operations!public! !
startDoc!operations!public! !
startDocNamed:!operations!public! !
startPage!operations!public! !
!

!Graphics.PrinterCanvas class methodsFor!

icon
	^##(self) defaultIcon! !

!Graphics.PrinterCanvas class categoriesForMethods!
icon!constants!development!public! !
!

