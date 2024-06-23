"Filed out from Dolphin Smalltalk"!

XMLTokenizer subclass: #SAXDriver
	instanceVariableNames: 'saxHandler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SAXDriver guid: (GUID fromString: '{3102df00-a9b7-41d1-9524-c0c87736c600}')!

SAXDriver comment: ''!

!SAXDriver categoriesForClass!XML-Parser! !

!SAXDriver methodsFor!

handleCData: aString
	self saxHandler
		checkEOD; 
		characters: aString!

handleEndDocument
	self saxHandler endDocument!

handleEndTag: aString
	self saxHandler
		checkEOD; 
		endElement: aString!

handlePCData: aString
	self saxHandler
		checkEOD; 
		characters: aString!

handlePI: piTarget data: piData
	self saxHandler
		checkEOD; 
		processingInstruction: piTarget data: piData!

handleStartDocument
	self saxHandler startDocument!

handleStartTag: elementName attributes: attributeList
	self saxHandler
		checkEOD; 
		startElement: elementName namespaceURI: nil qualifiedName: nil attributeList: attributeList!

handleXMLDecl: attributes
	self saxHandler
		checkEOD; 
		documentAttributes: attributes!

saxHandler
	^saxHandler!

saxHandler: aHandler
	saxHandler := aHandler! !

!SAXDriver categoriesForMethods!
handleCData:!handling tokens!public! !
handleEndDocument!handling tokens!public! !
handleEndTag:!handling tokens!public! !
handlePCData:!handling tokens!public! !
handlePI:data:!handling tokens!public! !
handleStartDocument!handling tokens!public! !
handleStartTag:attributes:!handling tokens!public! !
handleXMLDecl:!handling tokens!public! !
saxHandler!accessing!public! !
saxHandler:!accessing!public! !
!

