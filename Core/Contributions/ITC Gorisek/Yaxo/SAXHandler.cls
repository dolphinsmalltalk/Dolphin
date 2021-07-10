"Filed out from Dolphin Smalltalk"!

Object subclass: #SAXHandler
	instanceVariableNames: 'document driver eod'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!SAXHandler categoriesForMethods!
characters:!content!public! !
checkEOD!content!public! !
comment:!lexical!public! !
document!accessing!public! !
document:!accessing!public! !
documentAttributes:!content!public! !
driver!accessing!public! !
driver:!accessing!public! !
endDocument!content!public! !
endElement:!content!public! !
endElement:namespaceURI:qualifiedName:!content!public! !
endEntity:!lexical!public! !
endPrefixMapping:!content!public! !
eod!accessing!public! !
ignorableWhitespace:!content!public! !
initialize!initialize!public! !
parseDocument!parsing!public! !
processingInstruction:data:!content!public! !
resolveEntity:systemID:!entity!public! !
skippedEntity:!content!public! !
startCData!lexical!public! !
startDocument!content!public! !
startDTD:publicID:systemID:!lexical!public! !
startElement:attributeList:!content!public! !
startElement:namespaceURI:qualifiedName:attributeList:!content!public! !
startEntity:!lexical!public! !
startPrefixMapping:uri:!content!public! !
!

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
!SAXHandler class categoriesForMethods!
convertWideStream:!helpers!public! !
new!instance creation!public! !
on:!instance creation!public! !
parseDocumentFrom:!instance creation!public! !
parseDocumentFromFileNamed:!instance creation!public! !
parseDocumentFromFileNamed:readIntoMemory:!instance creation!public! !
parseDTDFrom:!instance creation!public! !
!

