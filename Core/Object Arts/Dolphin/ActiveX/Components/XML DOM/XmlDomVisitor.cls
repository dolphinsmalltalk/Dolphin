"Filed out from Dolphin Smalltalk 7"!

Object subclass: #XmlDomVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
XmlDomVisitor guid: (GUID fromString: '{92cf165d-8533-4f76-9f0a-ff1c520339f4}')!
XmlDomVisitor isAbstract: true!
XmlDomVisitor comment: 'Abstract visitor for IXMLDOMDocument node tree.'!
!XmlDomVisitor categoriesForClass!Kernel-Objects! !
!XmlDomVisitor methodsFor!

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
!XmlDomVisitor categoriesFor: #visitAttribute:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitCDATA:!public! !
!XmlDomVisitor categoriesFor: #visitCharacterData:!private! !
!XmlDomVisitor categoriesFor: #visitComment:!public! !
!XmlDomVisitor categoriesFor: #visitDocument:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitDocumentType:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitDomNode:!private!visiting! !
!XmlDomVisitor categoriesFor: #visitElement:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitEntity:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitEntityReference:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitNode:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitNodeChildren:!private!visiting! !
!XmlDomVisitor categoriesFor: #visitNodes:!private!visiting! !
!XmlDomVisitor categoriesFor: #visitNotation:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitProcessingInstruction:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitText:!public! !

