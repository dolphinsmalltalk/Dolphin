"Filed out from Dolphin Smalltalk X6"!

IXMLDOMCharacterData subclass: #IXMLDOMComment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDOMComment guid: (IID fromString: '{2933BF88-7B36-11D2-B20E-00C04F983E60}')!
IXMLDOMComment comment: '<IXMLDOMComment> is a wrapper class for the COM interface ''MSXML.IXMLDOMComment'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent comments.'!
!IXMLDOMComment categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMComment methodsFor!

acceptVisitor: anXmlNodeVisitor 
	anXmlNodeVisitor acceptComment: self!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream basicPrint: self.
	[aStream nextPutAll: self xml]
		on: Error do: [:e | aStream nextPut: $(; print: bytes; nextPut: $)]

! !
!IXMLDOMComment categoriesFor: #acceptVisitor:!public!visitor! !
!IXMLDOMComment categoriesFor: #printOn:!printing!public! !

