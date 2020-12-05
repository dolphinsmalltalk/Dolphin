"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'MSXML.XmlDomVisitor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.XmlDomVisitor guid: (Core.GUID fromString: '{92cf165d-8533-4f76-9f0a-ff1c520339f4}')!
MSXML.XmlDomVisitor isNonInstantiable: true!
MSXML.XmlDomVisitor comment: 'Abstract visitor for IXMLDOMDocument node tree.'!
!MSXML.XmlDomVisitor categoriesForClass!Kernel-Objects! !
!MSXML.XmlDomVisitor methodsFor!

visitAttribute: anIXMLDOMAttribute
	!

visitCDATA: anIXMLDOMCDATASection
	self visitCharacterData: anIXMLDOMCDATASection!

visitCharacterData: anIXMLDOMCharacterData
	"Main override point for common handling of character data nodes such as comments, CDATA, and text."

	!

visitComment: anIXMLDOMComment
	self visitCharacterData: anIXMLDOMComment!

visitDocument: anIXMLDOMDocument
	self visitNodeChildren: anIXMLDOMDocument!

visitDocumentType: anIXMLDOMDocumentType
	!

visitDomNode: anIXMLDOMNode
	self visitNodeChildren: anIXMLDOMNode!

visitElement: anIXMLDOMElement
	self visitNodeChildren: anIXMLDOMElement!

visitEntity: anIXMLDOMEntity
	self visitNodeChildren: anIXMLDOMEntity!

visitEntityReference: anIXMLDOMEntityReference
	!

visitNode: anIXMLDOMNode
	anIXMLDOMNode acceptVisitor: self!

visitNodeChildren: anIXMLDOMNode 
	self visitNodes: anIXMLDOMNode childNodes!

visitNodes: aCollection 
	aCollection do: [:each | self visitNode: each]!

visitNotation: anIXMLDOMNotation
	!

visitProcessingInstruction: anIXMLDOMProcessingInstruction
	!

visitText: anIXMLDOMText
	self visitCharacterData: anIXMLDOMText! !
!MSXML.XmlDomVisitor categoriesFor: #visitAttribute:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitCDATA:!public! !
!MSXML.XmlDomVisitor categoriesFor: #visitCharacterData:!private! !
!MSXML.XmlDomVisitor categoriesFor: #visitComment:!public! !
!MSXML.XmlDomVisitor categoriesFor: #visitDocument:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitDocumentType:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitDomNode:!private!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitElement:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitEntity:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitEntityReference:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitNode:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitNodeChildren:!private!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitNodes:!private!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitNotation:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitProcessingInstruction:!public!visiting! !
!MSXML.XmlDomVisitor categoriesFor: #visitText:!public! !

