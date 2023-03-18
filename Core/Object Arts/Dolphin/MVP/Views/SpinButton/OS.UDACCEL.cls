"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.UDACCEL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_nInc' -> 16r4.
		'_OffsetOf_nSec' -> 16r0.
		'_UDACCEL_Size' -> 16r8
	}!
OS.UDACCEL guid: (Core.GUID fromString: '{425d0ea4-542e-11d3-998b-d5ca2c3c1d61}')!
OS.UDACCEL comment: '<UDACCEL> is an <ExternalStructure> class to wrap the struct ''UpDownLib.UDACCEL'' from type information in the ''Microsoft Windows Up-Down Control'' library.'!
!OS.UDACCEL categoriesForClass!External-Data-Structured-Win32! !
!OS.UDACCEL methodsFor!

nInc
	"Answer the <Integer> value of the receiver's 'nInc' field."

	^bytes uint32AtOffset: _OffsetOf_nInc!

nInc: anInteger
	"Set the receiver's 'nInc' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nInc put: anInteger!

nSec
	"Answer the <Integer> value of the receiver's 'nSec' field."

	^bytes uint32AtOffset: _OffsetOf_nSec!

nSec: anInteger
	"Set the receiver's 'nSec' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nSec put: anInteger! !
!OS.UDACCEL categoriesForMethods!
nInc!**compiled accessors**!public! !
nInc:!**compiled accessors**!public! !
nSec!**compiled accessors**!public! !
nSec:!**compiled accessors**!public! !
!

!OS.UDACCEL class methodsFor!

byteSize
	^_UDACCEL_Size!

defineFields
	"Define the fields of the UDACCEL structure.
		UDACCEL compileDefinition
	
		typedef 		struct tagUDACCEL {
			unsigned int nSec;
			unsigned int nInc;
		} UDACCEL;
"

	self
		defineField: #nSec type: UInt32Field new;
		defineField: #nInc type: UInt32Field new!

getFieldNames
	^#(#nSec #nInc)! !
!OS.UDACCEL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

