"Filed out from Dolphin Smalltalk X6"!

Object subclass: #XmlDomVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlDomVisitor guid: (GUID fromString: '{92CF165D-8533-4F76-9F0A-FF1C520339F4}')!
XmlDomVisitor comment: ''!
!XmlDomVisitor categoriesForClass!Kernel-Objects! !
!XmlDomVisitor methodsFor!

acceptAttribute: anIXMLDOMAttribute 
!

acceptCDATA: anIXMLDOMCDATASection 
	self acceptCharacterData: anIXMLDOMCDATASection!

acceptCharacterData: anIXMLDOMCharacterData 
	"Main override point for common handling of character data nodes such as comments, CDATA, and text."

	!

acceptComment: anIXMLDOMComment 
	self acceptCharacterData: anIXMLDOMComment!

acceptDocument: anIXMLDOMDocument 
	self visitNodeChildren: anIXMLDOMDocument!

acceptDocumentType: anIXMLDOMDocumentType 
	!

acceptElement: anIXMLDOMElement 
	self visitNodeChildren: anIXMLDOMElement!

acceptEntity: anIXMLDOMEntity
	self visitNodeChildren: anIXMLDOMEntity!

acceptEntityReference: anIXMLDOMEntityReference 
	!

acceptNode: anIXMLDOMNode 
	self visitNodeChildren: anIXMLDOMNode!

acceptNotation: anIXMLDOMNotation
	!

acceptProcessingInstruction: anIXMLDOMProcessingInstruction 
!

acceptText: anIXMLDOMText 
	self acceptCharacterData: anIXMLDOMText!

visitNode: anIXMLDOMNode
	anIXMLDOMNode acceptVisitor: self!

visitNodeChildren: anIXMLDOMNode 
	self visitNodes: anIXMLDOMNode childNodes!

visitNodes: aCollection 
	aCollection do: [:each | self visitNode: each]! !
!XmlDomVisitor categoriesFor: #acceptAttribute:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptCDATA:!public! !
!XmlDomVisitor categoriesFor: #acceptCharacterData:!private! !
!XmlDomVisitor categoriesFor: #acceptComment:!public! !
!XmlDomVisitor categoriesFor: #acceptDocument:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptDocumentType:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptElement:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptEntity:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptEntityReference:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptNode:!private!visiting! !
!XmlDomVisitor categoriesFor: #acceptNotation:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptProcessingInstruction:!public!visiting! !
!XmlDomVisitor categoriesFor: #acceptText:!public! !
!XmlDomVisitor categoriesFor: #visitNode:!public!visiting! !
!XmlDomVisitor categoriesFor: #visitNodeChildren:!private!visiting! !
!XmlDomVisitor categoriesFor: #visitNodes:!private!visiting! !

