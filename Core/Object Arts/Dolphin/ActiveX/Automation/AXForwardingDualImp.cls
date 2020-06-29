"Filed out from Dolphin Smalltalk 7"!

AXDualImp subclass: #AXForwardingDualImp
	instanceVariableNames: 'interfaceClass server'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXForwardingDualImp guid: (GUID fromString: '{609232b8-a27b-4709-941c-128cd9948bda}')!
AXForwardingDualImp comment: ''!
!AXForwardingDualImp categoriesForClass!Unclassified! !
!AXForwardingDualImp methodsFor!

interfaceClass
	"Answer the interface class which is implemented by the receiver."

	^interfaceClass!

interfaceClass: anObject
	"Set the value of the receiver's ''interfaceClass'' instance variable to the argument, anObject."

	interfaceClass := anObject!

server
	"Answer the server object on behalf of which the receiver is implementing an
	interface or interfaces. By default this is the receiver itself, but subclasses
	may implement interfaces on behalf of other objects in order that any particular
	server object can support any number of interfaces with different implementors."

	^server ?? self!

server: anObject
	"Set the server object on behalf of which the receiver is implementing an
	interface or interfaces. Any invocations of methods in the dual interface
	represented by the receiver will be forwarded to this object, assuming the
	the server is set before the interface is queried."

	server := anObject! !
!AXForwardingDualImp categoriesFor: #interfaceClass!accessing!public! !
!AXForwardingDualImp categoriesFor: #interfaceClass:!accessing!public! !
!AXForwardingDualImp categoriesFor: #server!accessing!public! !
!AXForwardingDualImp categoriesFor: #server:!accessing!public! !

