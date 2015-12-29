"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #OLEStructure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'OLEConstants'
	classInstanceVariableNames: ''!
OLEStructure guid: (GUID fromString: '{87B4C59A-026E-11D3-9FD7-00A0CC3E4A32}')!
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

