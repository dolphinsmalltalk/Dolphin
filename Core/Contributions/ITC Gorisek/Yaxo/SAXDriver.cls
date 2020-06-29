"Filed out from Dolphin Smalltalk 7"!

XMLTokenizer subclass: #SAXDriver
	instanceVariableNames: 'saxHandler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SAXDriver categoriesFor: #handleCData:!handling tokens!public! !
!SAXDriver categoriesFor: #handleEndDocument!handling tokens!public! !
!SAXDriver categoriesFor: #handleEndTag:!handling tokens!public! !
!SAXDriver categoriesFor: #handlePCData:!handling tokens!public! !
!SAXDriver categoriesFor: #handlePI:data:!handling tokens!public! !
!SAXDriver categoriesFor: #handleStartDocument!handling tokens!public! !
!SAXDriver categoriesFor: #handleStartTag:attributes:!handling tokens!public! !
!SAXDriver categoriesFor: #handleXMLDecl:!handling tokens!public! !
!SAXDriver categoriesFor: #saxHandler!accessing!public! !
!SAXDriver categoriesFor: #saxHandler:!accessing!public! !

