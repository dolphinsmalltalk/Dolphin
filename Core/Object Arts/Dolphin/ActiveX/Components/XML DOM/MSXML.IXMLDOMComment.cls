"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMCharacterData subclass: #'MSXML.IXMLDOMComment'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMComment guid: (OS.COM.IID fromString: '{2933bf88-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMComment comment: '<IXMLDOMComment> is a wrapper class for the COM interface ''MSXML.IXMLDOMComment'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent comments.'!
!MSXML.IXMLDOMComment categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMComment methodsFor!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream basicPrint: self.
	[aStream nextPutAll: self xml]
		on: Error do: [:e | aStream nextPut: $(; print: bytes; nextPut: $)]

! !
!MSXML.IXMLDOMComment categoriesFor: #printOn:!development!printing!public! !

