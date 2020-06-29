"Filed out from Dolphin Smalltalk 7"!

IXMLDOMCharacterData subclass: #IXMLDOMComment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMComment guid: (IID fromString: '{2933bf88-7b36-11d2-b20e-00c04f983e60}')!
IXMLDOMComment comment: '<IXMLDOMComment> is a wrapper class for the COM interface ''MSXML.IXMLDOMComment'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent comments.'!
!IXMLDOMComment categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMComment methodsFor!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream basicPrint: self.
	[aStream nextPutAll: self xml]
		on: Error do: [:e | aStream nextPut: $(; print: bytes; nextPut: $)]

! !
!IXMLDOMComment categoriesFor: #printOn:!development!printing!public! !

