"Filed out from Dolphin Smalltalk X6"!

DOMNamedNodeMap variableSubclass: #DOMEntitiesMap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOMEntitiesMap guid: (GUID fromString: '{E837C00B-9843-4AC2-B072-E44440ECAEC3}')!
DOMEntitiesMap comment: 'Specialized <DOMNamedNodeMap> which contains <IXMLDOMEntity >s. This is used to represent the dictionary of entities associated with an XML DOM document type. The keys and values are strings.'!
!DOMEntitiesMap categoriesForClass!Collections-Unordered! !
!DOMEntitiesMap methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^IXMLDOMEntity!

createNamedNode: aString 
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^self shouldNotImplement! !
!DOMEntitiesMap categoriesFor: #associationClass!constants!private! !
!DOMEntitiesMap categoriesFor: #createNamedNode:!helpers!private! !

