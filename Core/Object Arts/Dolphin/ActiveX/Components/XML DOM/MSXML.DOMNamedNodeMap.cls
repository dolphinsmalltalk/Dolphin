"Filed out from Dolphin Smalltalk 7"!

Core.Dictionary variableSubclass: #DOMNamedNodeMap
	instanceVariableNames: 'interface parentNode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
DOMNamedNodeMap guid: (Core.GUID fromString: '{20534a81-bce6-43d4-bb64-1ad3b4aa39d9}')!
DOMNamedNodeMap isNonInstantiable: true!
DOMNamedNodeMap comment: 'DOMNamedNodeMap is a hashed collection wrapper class for the MSXML <IXMLDOMNamedNodeMap> interface. Its purpose is to make all the power of Smalltalk dictionaries available on the much more limited DOM interface, and to provide seamless integration into the Smalltalk development environment (i.e. so that the node map prints, inspects, and acts like a dictionary). DOMNamedNodeMap itself is abstract, and has a number of subclasses employed to specialize it to particular types of named node. The most important of these is probably <DOMAttributeMap>, which implements dictionary behaviour for manipulating the XML attributes of a node.

All DOM interface methods that return an IXMLDOMNamedNodeMap have been modified to return a subinstance of this class.

Instance Variables:
	interface		<IXMLDOMNamedNodeMap>
	parentNode	<IXMLDOMNode> subinstance.

'!
!DOMNamedNodeMap categoriesForClass!Collections-Unordered! !
!DOMNamedNodeMap methodsFor!

add: namedNode
	"Include the <association> conforming <IXMLDOMNode> argument, newElement, as one of the receiver's 
	elements. Answer newElement."

	self setNamedItem: namedNode.
	^namedNode!

associationAt: key ifAbsent: exceptionHandler 
	"Answer the association named by the argument, key. If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler."

	| node |
	node := self getNamedItem: key.
	^node ifNil: [exceptionHandler value]!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the <association> protocol."

	^self subclassResponsibility!

associations
	"Answer a <sequencedReadableCollection> containing the receiver's associations.
	Although DOMNodeList is a <sequencedReadableCollection> callers will tend to assume
	that the collection is a copy, so we convert it to an OrderedCollection here."

	^(DOMNodeList on: interface) asOrderedCollection!

associationsDo: operation
	"Evaluate the monadic valuable, operation, for each of the receiver's 
	key/value mappings."

	(DOMNodeList on: interface) do: [:node | operation value: node]!

at: key ifAbsent: operation
	"Answer the value named by the <Object> argument, key.  If key is not found,
	answer the result of evaluating the <niladicValuable>, operation."

	^(self associationAt: key ifAbsent: [^operation value]) value!

at: key put: newElement 
	"Store the <Object> argument newElement at the <Object>
	key, in the receiver. Answer newElement."

	"Implementation Note: Because some nodes may be read-only (e.g. namespace nodes in 
	the attributes map), we must set the value of a new node before adding it to the map."

	(self associationAt: key ifAbsent: []) 
		ifNil: 
			[| node |
			node := self createNamedNode: key.
			node value: newElement.
			self add: node]
		ifNotNil: [:node | node value: newElement].
	^newElement!

copyElementsInto: newMe
	"Private - Should not be sent to the receiver."

	^self shouldNotImplement!

createNamedNode: key
	"Private - Instantiate and answer a new named node of the type contained in the receiver."

	^self subclassResponsibility!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the 
	receiver's elements."

	self associationsDo: [:node | operation value: node value]!

getNamedItem: name
	"Look up a node in the map by name."

	"It is tempting to create an interface pointer of the correct, specialized, class here, but
	that would not be correct as the interface is spec'd as returning an IXMLDOMNode, 
	and in fact if we try to shortcut query interface a GPF results if we subsequently
	attempt to set the value of the interface (say)"

	^interface getNamedItem: name!

hash: anObject max: anInteger
	"Private - This message should not be sent, if it is then there is probably another superclass method that
	needs overriding."

	^self shouldNotImplement!

includesKey: key
	"Answer whether the receiver has a key equal to the <Object>
	argument, key"

	^(self getNamedItem: key) notNil!

interface
	"Private - Answer the value of the receiver's ''interface'' instance variable."

	^interface!

item: index
	"Answer the <IXMLDOMNode> at the specified zero-based <integer> 
	index in the collection of nodes."

	^interface item: index!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver.
	The key/values pairs do not have to be visited in any particular order, but in the case#
	of the DOM the collection is ordered."

	^self associationsDo: [:node | operation value: node key value: node value]!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: 'number of nodes in the collection'"

	^interface length!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	^(self associationAt: keyObject ifAbsent: []) ifNotNil: [:assoc | assoc value]!

nextNode
	"Answer the <IXMLDOMNode> result of invoking the COM Object's nextNode() method.
	Helpstring: 'get next node from iterator'"

	^interface nextNode!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements."

	"Implementation note: We don't want to inherit the Dictionary implementation as this is a
	proxy for an XML DOM object."

	^self!

privateAt: index put: newObject
	"Private - Should not be sent to the receiver."

	^self shouldNotImplement!

removeIndex: anInteger
	"Private - Should not be sent to the receiver."

	^self shouldNotImplement!

removeKey: key ifAbsent: operation 
	"Remove the <Object> key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the <niladicValuable>,
	operation. Otherwise, answer the value named by key."

	| node |
	node := self removeNamedItem: key.
	^node ifNil: [operation value]!

removeNamedItem: name 
	"Remove the named item, answering a node pointer on it or nil if it is not
	in the map."

	^interface removeNamedItem: name!

removeQualifiedItem: baseName namespaceURI: namespaceURI
	"Remove an item by name and namespace, answering a node pointer on it or nil if it is not
	in the map."

	^interface removeQualifiedItem: baseName namespaceURI: namespaceURI!

reset  
	"Reset the position of iterator."

	interface Reset
!

setInterface: anIXMLDOMNamedNodeMap parentNode: anIXMLDOMNode
	"Private - Set the value of the receiver's ''interface'' instance variable to the argument, anObject."

	interface := anIXMLDOMNamedNodeMap.
	parentNode := anIXMLDOMNode!

setNamedItem: newItem
	"Set, and answer, an item by name."

	^interface setNamedItem: newItem!

size
	"Answer an <integer> specifying the number of elements in the receiver."

	^self length!

uncheckedAdd: newObject
	"Private - Should not be sent to the receiver."

	^self shouldNotImplement! !
!DOMNamedNodeMap categoriesFor: #add:!adding!public! !
!DOMNamedNodeMap categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #associationClass!constants!private! !
!DOMNamedNodeMap categoriesFor: #associations!accessing!public! !
!DOMNamedNodeMap categoriesFor: #associationsDo:!enumerating!public! !
!DOMNamedNodeMap categoriesFor: #at:ifAbsent:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #at:put:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #copyElementsInto:!adding!private! !
!DOMNamedNodeMap categoriesFor: #createNamedNode:!helpers!private! !
!DOMNamedNodeMap categoriesFor: #do:!enumerating!public! !
!DOMNamedNodeMap categoriesFor: #getNamedItem:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #hash:max:!private!searching! !
!DOMNamedNodeMap categoriesFor: #includesKey:!public!searching! !
!DOMNamedNodeMap categoriesFor: #interface!accessing!private! !
!DOMNamedNodeMap categoriesFor: #item:!properties!public! !
!DOMNamedNodeMap categoriesFor: #keysAndValuesDo:!enumerating!public! !
!DOMNamedNodeMap categoriesFor: #length!properties!public! !
!DOMNamedNodeMap categoriesFor: #lookup:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #nextNode!accessing!public! !
!DOMNamedNodeMap categoriesFor: #postCopy!copying!public! !
!DOMNamedNodeMap categoriesFor: #privateAt:put:!accessing!private! !
!DOMNamedNodeMap categoriesFor: #removeIndex:!private!removing! !
!DOMNamedNodeMap categoriesFor: #removeKey:ifAbsent:!public!removing! !
!DOMNamedNodeMap categoriesFor: #removeNamedItem:!public!removing! !
!DOMNamedNodeMap categoriesFor: #removeQualifiedItem:namespaceURI:!public!removing! !
!DOMNamedNodeMap categoriesFor: #reset!enumerating!public! !
!DOMNamedNodeMap categoriesFor: #setInterface:parentNode:!accessing!private! !
!DOMNamedNodeMap categoriesFor: #setNamedItem:!accessing!public! !
!DOMNamedNodeMap categoriesFor: #size!accessing!public! !
!DOMNamedNodeMap categoriesFor: #uncheckedAdd:!adding!private! !

!DOMNamedNodeMap class methodsFor!

onInterface: anIXMLDOMNamedNodeMap parentNode: anIXMLDOMNode
	"Answer a new instance of the receiver which implements the entire
	<sequencedReadableCollection> on the specified named node map."

	^self new
		setInterface: anIXMLDOMNamedNodeMap parentNode: anIXMLDOMNode

	! !
!DOMNamedNodeMap class categoriesFor: #onInterface:parentNode:!instance creation!public! !

