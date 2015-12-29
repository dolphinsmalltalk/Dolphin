"Filed out from Dolphin Smalltalk X6"!

DOMNamedNodeMap variableSubclass: #DOMAttributeMap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOMAttributeMap guid: (GUID fromString: '{A514645C-F053-4BE4-87C8-99381EC1C930}')!
DOMAttributeMap comment: 'Specialized <DOMNamedNodeMap> which contains <IXMLDOMAttribute>s. This is used to represent the dictionary of attributes associated with a DOM node. The keys and values are strings.'!
!DOMAttributeMap categoriesForClass!Collections-Unordered! !
!DOMAttributeMap methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^IXMLDOMAttribute!

createNamedNode: key
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^parentNode ownerDocument createAttribute: key! !
!DOMAttributeMap categoriesFor: #associationClass!constants!private! !
!DOMAttributeMap categoriesFor: #createNamedNode:!helpers!private! !

