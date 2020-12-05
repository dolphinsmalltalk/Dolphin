"Filed out from Dolphin Smalltalk 7"!

MSXML.DOMNamedNodeMap variableSubclass: #'MSXML.DOMNotationsMap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.DOMNotationsMap guid: (Core.GUID fromString: '{5b277829-84b8-4926-9ada-5e4893b363bf}')!
MSXML.DOMNotationsMap comment: 'Specialized <DOMNamedNodeMap> which contains <IXMLDOMNotation>s. This is used to represent the dictionary of notations associated with an XML DOM document type. The keys and values are strings.'!
!MSXML.DOMNotationsMap categoriesForClass!Collections-Unordered! !
!MSXML.DOMNotationsMap methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^IXMLDOMNotation!

createNamedNode: aString 
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^self shouldNotImplement! !
!MSXML.DOMNotationsMap categoriesFor: #associationClass!constants!private! !
!MSXML.DOMNotationsMap categoriesFor: #createNamedNode:!helpers!private! !

