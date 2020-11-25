"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #OLEStructure
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.OLEConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
OLEStructure guid: (Core.GUID fromString: '{87b4c59a-026e-11d3-9fd7-00a0cc3e4a32}')!
OLEStructure isNonInstantiable: true!
OLEStructure comment: 'OLEStructure is an <ExternalStructure> the primary purpose of which is to group all OLE/COM related structure classes. OLEStructure also provides the basic boilerplate initialization needed for structures which have a ''sizeof'' member at offset 0 (see LICINFO for an example).'!
!OLEStructure categoriesForClass!External-Data-Structured-COM! !
!OLEStructure methodsFor!

dwSize: anInteger
	"Store the size of the structure into itself (a common feature of Win32 structures,
	but unfortunately not all, so the default is to do nothing)"!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !
!OLEStructure categoriesFor: #dwSize:!initializing!public! !
!OLEStructure categoriesFor: #initialize:!initializing!private! !

