"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SAXHandler
	instanceVariableNames: 'document driver eod'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SAXHandler guid: (GUID fromString: '{5f6867fa-780a-49f2-972e-9f8c0676ddd0}')!
SAXHandler comment: ''!
!SAXHandler categoriesForClass!XML-Parser! !
!SAXHandler methodsFor!

characters: aString
	"This call corresponds to the Java SAX call
	characters(char[] ch, int start, int length)."!

checkEOD
	"Check if the document shouldn't be ended already"
	self eod
		ifTrue: [self driver errorExpected: 'No more data expected,']!

comment: commentString
	"This call corresponds to the Java SAX ext call
	comment(char[] ch, int start, int length)."!

document
	^document!

document: aDocument
	document := aDocument!

documentAttributes: attributeList!

driver
	^driver!

driver: aDriver
	driver := aDriver.
	driver saxHandler: self!

endDocument
	"This call corresponds to the Java SAX call
	endDocument()."
	eod := true!

endElement: elementName
!

endElement: elementName namespaceURI: namespaceURI qualifiedName: qualifiedName
	"This call corresponds to the Java SAX call
	endElement(java.lang.String namespaceURI, java.lang.String localName, java.lang.String qName).
	By default this call is mapped to the following more convenient call:"

	self endElement: elementName!

endEntity: entityName
	"This call corresponds to the Java SAX ext call
	endEntity(java.lang.String name)."!

endPrefixMapping: prefix
	"This call corresonds to the Java SAX call
	endPrefixMapping(java.lang.String prefix)."!

eod
	^eod!

ignorableWhitespace: aString
	"This call corresonds to the Java SAX call
	ignorableWhitespace(char[] ch, int start, int length)."!

initialize
	super initialize.
	eod := false!

parseDocument
	[self driver nextEntity isNil or: [self eod]] whileFalse!

processingInstruction: piName data: dataString
	"This call corresonds to the Java SAX call
	processingInstruction(java.lang.String target, java.lang.String data)."!

resolveEntity: publicID systemID: systemID
	"This call corresonds to the Java SAX call
	resolveEntity(java.lang.String publicId, java.lang.String systemId)."!

skippedEntity: aString
	"This call corresonds to the Java SAX call
	skippedEntity(java.lang.String name)."!

startCData
	"This call corresponds to the Java SAX ext call
	startCData()."!

startDocument
	"This call corresonds to the Java SAX call
	startDocument()."!

startDTD: declName publicID: publicID systemID: systemID
	"This call corresponds to the Java SAX ext call
	startDTD(java.lang.String name, java.lang.String publicId, java.lang.String systemId)."!

startElement: elementName attributeList: attributeList
!

startElement: elementName namespaceURI: namespaceURI qualifiedName: qualifiedName attributeList: attributeList
	"This call corresonds to the Java SAX call
	startElement(java.lang.String namespaceURI, java.lang.String localName, java.lang.String qName, Attributes atts).
	By default this call is mapped to the following more convenient call:"

	self startElement: elementName attributeList: attributeList!

startEntity: entityName
	"This call corresponds to the Java SAX ext call
	startEntity(java.lang.String name)."!

startPrefixMapping: prefix uri: uri
	"This call corresonds to the Java SAX call
	startPrefixMapping(java.lang.String prefix, java.lang.String uri)."! !
!SAXHandler categoriesFor: #characters:!content!public! !
!SAXHandler categoriesFor: #checkEOD!content!public! !
!SAXHandler categoriesFor: #comment:!lexical!public! !
!SAXHandler categoriesFor: #document!accessing!public! !
!SAXHandler categoriesFor: #document:!accessing!public! !
!SAXHandler categoriesFor: #documentAttributes:!content!public! !
!SAXHandler categoriesFor: #driver!accessing!public! !
!SAXHandler categoriesFor: #driver:!accessing!public! !
!SAXHandler categoriesFor: #endDocument!content!public! !
!SAXHandler categoriesFor: #endElement:!content!public! !
!SAXHandler categoriesFor: #endElement:namespaceURI:qualifiedName:!content!public! !
!SAXHandler categoriesFor: #endEntity:!lexical!public! !
!SAXHandler categoriesFor: #endPrefixMapping:!content!public! !
!SAXHandler categoriesFor: #eod!accessing!public! !
!SAXHandler categoriesFor: #ignorableWhitespace:!content!public! !
!SAXHandler categoriesFor: #initialize!initialize!public! !
!SAXHandler categoriesFor: #parseDocument!parsing!public! !
!SAXHandler categoriesFor: #processingInstruction:data:!content!public! !
!SAXHandler categoriesFor: #resolveEntity:systemID:!entity!public! !
!SAXHandler categoriesFor: #skippedEntity:!content!public! !
!SAXHandler categoriesFor: #startCData!lexical!public! !
!SAXHandler categoriesFor: #startDocument!content!public! !
!SAXHandler categoriesFor: #startDTD:publicID:systemID:!lexical!public! !
!SAXHandler categoriesFor: #startElement:attributeList:!content!public! !
!SAXHandler categoriesFor: #startElement:namespaceURI:qualifiedName:attributeList:!content!public! !
!SAXHandler categoriesFor: #startEntity:!lexical!public! !
!SAXHandler categoriesFor: #startPrefixMapping:uri:!content!public! !

!SAXHandler class methodsFor!

convertWideStream: aReadStream
	| wideString |
	#swYAXO.	"added to handle UTF-16"
	aReadStream
		next;
		next.
	wideString := aReadStream upToEnd.
	^(Utf16String fromAddress: wideString yourAddress length: wideString size // 2) 
		asString readStream!

new
	^super new initialize!

on: aStream
	| driver parser |
	driver := SAXDriver on: aStream.
	driver validation: true.
	parser := self new driver: driver.
	^parser!

parseDocumentFrom: aStream
	| driver parser stream |
	#swYAXO.	"changed to handle UTF-16"
	aStream atEnd 
		ifTrue: [SAXMalformedException signal: 'XML document must have a top level element'].
	stream := aStream peek codePoint >= 254 
				ifTrue: [self convertWideStream: aStream]
				ifFalse: [aStream].
	driver := SAXDriver on: stream.
	driver validating: true.
	parser := self new driver: driver.
	parser startDocument.
	parser parseDocument.
	^parser!

parseDocumentFromFileNamed: fileName
	^self parseDocumentFromFileNamed: fileName readIntoMemory: false!

parseDocumentFromFileNamed: fileName readIntoMemory: readIntoMemory
	| fs stream parser |
	#swYAXO.
	fs := FileStream read: fileName text: true.
	#swYAXO.	"Thanks to Barry Carr for this fix"
	readIntoMemory ifTrue: [stream := fs contents readStream] ifFalse: [stream := fs].
	[parser := self parseDocumentFrom: stream] ensure: [fs close].
	^parser!

parseDTDFrom: aStream
	| driver parser |
	driver := SAXDriver on: aStream.
	driver validation: true.
	driver startParsingMarkup.
	parser := self new driver: driver.
	parser startDocument.
	parser parseDocument.
	^parser! !
!SAXHandler class categoriesFor: #convertWideStream:!helpers!public! !
!SAXHandler class categoriesFor: #new!instance creation!public! !
!SAXHandler class categoriesFor: #on:!instance creation!public! !
!SAXHandler class categoriesFor: #parseDocumentFrom:!instance creation!public! !
!SAXHandler class categoriesFor: #parseDocumentFromFileNamed:!instance creation!public! !
!SAXHandler class categoriesFor: #parseDocumentFromFileNamed:readIntoMemory:!instance creation!public! !
!SAXHandler class categoriesFor: #parseDTDFrom:!instance creation!public! !

