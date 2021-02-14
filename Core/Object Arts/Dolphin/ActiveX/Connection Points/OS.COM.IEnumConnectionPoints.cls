"Filed out from Dolphin Smalltalk 7"!

OS.COM.IEnumUnknown subclass: #'OS.COM.IEnumConnectionPoints'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IEnumConnectionPoints guid: (OS.COM.IID fromString: '{b196b285-bab4-101a-b69c-00aa00341d07}')!
OS.COM.IEnumConnectionPoints comment: '<IEnumConnectionPoints> is a wrapper class for the custom interface ''OBJIDL.IEnumConnectionPoints'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

IEnumConnections is used to enumerate details (via the CONNECTDATA structure) of connection points available in a connection point container.'!
!OS.COM.IEnumConnectionPoints categoriesForClass!COM-Interfaces! !
!OS.COM.IEnumConnectionPoints class methodsFor!

defineFunctions
	"Declare the virtual function table for the receiver.
		self defineTemplate
	"

	"This method only present to prevent auto-generation from a type library"!

elementClass
	"Answer the class of element enumerated by the receiver."

	^IConnectionPoint! !
!OS.COM.IEnumConnectionPoints class categoriesFor: #defineFunctions!initializing!public! !
!OS.COM.IEnumConnectionPoints class categoriesFor: #elementClass!constants!public! !

