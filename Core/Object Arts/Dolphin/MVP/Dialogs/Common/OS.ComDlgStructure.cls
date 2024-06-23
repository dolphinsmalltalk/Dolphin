"Filed out from Dolphin Smalltalk"!

OS.CommonDialogStructure
	subclass: #'OS.ComDlgStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_dwSize' -> 16r0. '_OffsetOf_hwndOwner' -> 16r4 }!

OS.ComDlgStructure guid: (Core.GUID fromString: '{fcbc1b04-6568-446c-9834-30421964d8b3}')!

OS.ComDlgStructure isNonInstantiable: true!

OS.ComDlgStructure comment: ''!

!OS.ComDlgStructure methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

hwndOwnerOffset
	^_OffsetOf_hwndOwner!

initialize: anInteger
	"Private - Initialize the state of the receiver."

	super initialize: anInteger.
	self dwSize: anInteger! !

!OS.ComDlgStructure categoriesForMethods!
dwSize:!**compiled accessors**!public! !
hwndOwnerOffset!constants!private! !
initialize:!initializing!private! !
!

!OS.ComDlgStructure class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self
		defineField: #dwSize type: UInt32Field writeOnly;
		defineField: #hwndOwner type: HANDLEField new beUncompiled! !

!OS.ComDlgStructure class categoriesForMethods!
defineFields!public!template definition! !
!

