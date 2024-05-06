"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #UDACCEL
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_nInc _OffsetOf_nSec'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UDACCEL guid: (GUID fromString: '{425d0ea4-542e-11d3-998b-d5ca2c3c1d61}')!

UDACCEL addClassConstant: '_OffsetOf_nInc' value: 16r4!
UDACCEL addClassConstant: '_OffsetOf_nSec' value: 16r0!

UDACCEL comment: '<UDACCEL> is an <ExternalStructure> class to wrap the struct ''UpDownLib.UDACCEL'' from type information in the ''Microsoft Windows Up-Down Control'' library.'!

!UDACCEL categoriesForClass!External-Data-Structured-Win32! !

!UDACCEL methodsFor!

nInc
	"Answer the <Integer> value of the receiver's 'nInc' field."

	^bytes dwordAtOffset: _OffsetOf_nInc!

nInc: anInteger
	"Set the receiver's 'nInc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nInc put: anInteger!

nSec
	"Answer the <Integer> value of the receiver's 'nSec' field."

	^bytes dwordAtOffset: _OffsetOf_nSec!

nSec: anInteger
	"Set the receiver's 'nSec' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nSec put: anInteger! !

!UDACCEL categoriesForMethods!
nInc!**compiled accessors**!public! !
nInc:!**compiled accessors**!public! !
nSec!**compiled accessors**!public! !
nSec:!**compiled accessors**!public! !
!

!UDACCEL class methodsFor!

defineFields
	"Define the fields of the UDACCEL structure.
		UDACCEL compileDefinition
	
		typedef 		struct tagUDACCEL {
			unsigned int nSec;
			unsigned int nInc;
		} UDACCEL;
"

	self
		defineField: #nSec type: DWORDField new;
		defineField: #nInc type: DWORDField new!

getFieldNames
	^#(#nSec #nInc)! !

!UDACCEL class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

