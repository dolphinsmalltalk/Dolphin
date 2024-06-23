"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.SizedStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private})
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_dwSize' -> 16r0 }!

OS.SizedStructure guid: (Core.GUID fromString: '{7575bf57-884e-4333-a593-eb3f9080c292}')!

OS.SizedStructure isNonInstantiable: true!

OS.SizedStructure comment: ''!

!OS.SizedStructure methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !

!OS.SizedStructure categoriesForMethods!
dwSize:!**compiled accessors**!public! !
initialize:!initializing!private! !
!

!OS.SizedStructure class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwSize type: UInt32Field writeOnly! !

!OS.SizedStructure class categoriesForMethods!
defineFields!public!template definition! !
!

