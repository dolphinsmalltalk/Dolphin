"Filed out from Dolphin Smalltalk 7"!

MSXML.DOMNamedNodeMap variableSubclass: #'MSXML.DOMEntitiesMap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.DOMEntitiesMap guid: (Core.GUID fromString: '{e837c00b-9843-4ac2-b072-e44440ecaec3}')!
MSXML.DOMEntitiesMap comment: 'Specialized <DOMNamedNodeMap> which contains <IXMLDOMEntity >s. This is used to represent the dictionary of entities associated with an XML DOM document type. The keys and values are strings.'!
!MSXML.DOMEntitiesMap categoriesForClass!Collections-Unordered! !
!MSXML.DOMEntitiesMap methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^IXMLDOMEntity!

createNamedNode: aString 
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^self shouldNotImplement! !
!MSXML.DOMEntitiesMap categoriesFor: #associationClass!constants!private! !
!MSXML.DOMEntitiesMap categoriesFor: #createNamedNode:!helpers!private! !

