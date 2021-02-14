"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.COM.OLEStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.OLEConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.OLEStructure guid: (Core.GUID fromString: '{87b4c59a-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.OLEStructure isNonInstantiable: true!
OS.COM.OLEStructure comment: '`OS.COM.OLEStructure` is an `External.Structure` the primary purpose of which is to group all OLE/COM related structure classes. OLEStructure also provides the basic boilerplate initialization needed for structures which have a ''sizeof'' member at offset 0 (see `OS.COM.LICINFO` for an example).'!
!OS.COM.OLEStructure categoriesForClass!External-Data-Structured-COM! !
!OS.COM.OLEStructure methodsFor!

dwSize: anInteger
	"Store the size of the structure into itself (a common feature of Win32 structures,
	but unfortunately not all, so the default is to do nothing)"!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !
!OS.COM.OLEStructure categoriesFor: #dwSize:!initializing!public! !
!OS.COM.OLEStructure categoriesFor: #initialize:!initializing!private! !

