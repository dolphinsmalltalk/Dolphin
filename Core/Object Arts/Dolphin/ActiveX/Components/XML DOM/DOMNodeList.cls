﻿"Filed out from Dolphin Smalltalk 7"!

SequenceableCollection subclass: #DOMNodeList
	instanceVariableNames: 'interface'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOMNodeList guid: (GUID fromString: '{e1531d8f-7795-472d-83f8-24c7cd6c0947}')!
DOMNodeList comment: 'DOMNodeList is a <sequencedReadableCollection> wrapper around the MSXML <IXMLDOMNodeList> interface. Its purpose is to make all the power of Smalltalk sequenceable collections available on the much more limited DOM interface, and to provide seamless integration into the Smalltalk development environment (i.e. so that the node map prints, inspects, and acts like an array). 
All DOM interface methods that return an IXMLDOMNamedNodeMap have been modified to return a subinstance of this class.

Instance Variables:
	interface		<IXMLDOMNodeList>'!
!DOMNodeList categoriesForClass!Unclassified! !
!DOMNodeList methodsFor!

add: newElement 
	^self shouldNotImplement!

at: index
	"Answer the element of the receiver at the specified index. If the index
	is out of bounds, raise an exception.
	Implementation Note: Assume the collection uses zero based indices, they
	usually do."

	^self item: index-1

!

at: index put: newElement
	"OLE IEnums are immutable."

	^self shouldNotImplement!

basicFree
	"Private - Release any external resources held by the receiver."

	interface free!

free
	"Release an external resources held by the receiver."

	interface notNil ifTrue: [
		self basicFree.
		interface := nil]!

interface
	"Private - Answer the value of the receiver's ''interface'' instance variable."

	^interface!

interface: anObject
	"Private - Set the value of the receiver's ''interface'' instance variable to the argument, anObject."

	interface := anObject!

item: index 
	"Answer the <IXMLDOMNode> at the specified zero-based <integer> 
	index in the collection of nodes."

	^interface item: index!

length
	"Answer the number of nodes in the collection."

	^interface length!

nextNode
	"Get next node from iterator"

	^interface nextNode!

reset  
	"Reset the position of iterator."

	interface Reset
!

size
	"Answer the number of elements in the receiver."

	^self length!

species
	"Answer the class of object to be used when copying the receiver."

	^Array!

xml
	"Answer the XML text resulting from concatenating the XML of all the nodes in the collection."

	| stream |
	stream := String writeStream: 64.
	self do: [:each | stream nextPutAll: each xml].
	^stream contents! !
!DOMNodeList categoriesFor: #add:!adding!public! !
!DOMNodeList categoriesFor: #at:!accessing!public! !
!DOMNodeList categoriesFor: #at:put:!accessing!public! !
!DOMNodeList categoriesFor: #basicFree!private!realizing/unrealizing! !
!DOMNodeList categoriesFor: #free!public!realizing/unrealizing! !
!DOMNodeList categoriesFor: #interface!accessing!private! !
!DOMNodeList categoriesFor: #interface:!accessing!private! !
!DOMNodeList categoriesFor: #item:!properties!public! !
!DOMNodeList categoriesFor: #length!properties!public! !
!DOMNodeList categoriesFor: #nextNode!methods!public! !
!DOMNodeList categoriesFor: #reset!methods!public! !
!DOMNodeList categoriesFor: #size!accessing!public! !
!DOMNodeList categoriesFor: #species!constants!public! !
!DOMNodeList categoriesFor: #xml!accessing!public! !

!DOMNodeList class methodsFor!

on: anIXMLDOMNodeList
	"Answer a new instance of the receiver which implements the entire
	<sequencedReadableCollection> on the specified node list."

	^self new
		interface: anIXMLDOMNodeList

	! !
!DOMNodeList class categoriesFor: #on:!instance creation!public! !

