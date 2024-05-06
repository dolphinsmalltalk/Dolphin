"Filed out from Dolphin Smalltalk"!

Object subclass: #XmlDomVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!XmlDomVisitor categoriesForMethods!
visitAttribute:!public!visiting! !
visitCDATA:!public! !
visitCharacterData:!private! !
visitComment:!public! !
visitDocument:!public!visiting! !
visitDocumentType:!public!visiting! !
visitDomNode:!private!visiting! !
visitElement:!public!visiting! !
visitEntity:!public!visiting! !
visitEntityReference:!public!visiting! !
visitNode:!public!visiting! !
visitNodeChildren:!private!visiting! !
visitNodes:!private!visiting! !
visitNotation:!public!visiting! !
visitProcessingInstruction:!public!visiting! !
visitText:!public! !
!

