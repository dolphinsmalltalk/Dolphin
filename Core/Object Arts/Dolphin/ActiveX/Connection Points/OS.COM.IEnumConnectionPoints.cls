"Filed out from Dolphin Smalltalk 7"!

IEnumUnknown subclass: #IEnumConnectionPoints
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IEnumConnectionPoints guid: (IID fromString: '{b196b285-bab4-101a-b69c-00aa00341d07}')!
IEnumConnectionPoints comment: '<IEnumConnectionPoints> is a wrapper class for the custom interface ''OBJIDL.IEnumConnectionPoints'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

IEnumConnections is used to enumerate details (via the CONNECTDATA structure) of connection points available in a connection point container.'!
!IEnumConnectionPoints categoriesForClass!COM-Interfaces! !
!IEnumConnectionPoints class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IConnectionPoint! !
!IEnumConnectionPoints class categoriesFor: #defineFunctions!initializing!public! !
!IEnumConnectionPoints class categoriesFor: #elementClass!constants!public! !

