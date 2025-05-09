﻿"Filed out from Dolphin Smalltalk"!

MSXML.DOMNamedNodeMap
	variableSubclass: #'MSXML.DOMAttributeMap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.DOMAttributeMap guid: (Core.GUID fromString: '{a514645c-f053-4be4-87c8-99381ec1c930}')!

MSXML.DOMAttributeMap comment: 'Specialized <DOMNamedNodeMap> which contains <IXMLDOMAttribute>s. This is used to represent the dictionary of attributes associated with a DOM node. The keys and values are strings.'!

!MSXML.DOMAttributeMap categoriesForClass!Collections-Unordered! !

!MSXML.DOMAttributeMap methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^IXMLDOMAttribute!

createNamedNode: key
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^parentNode ownerDocument createAttribute: key! !

!MSXML.DOMAttributeMap categoriesForMethods!
associationClass!constants!private! !
createNamedNode:!helpers!private! !
!

