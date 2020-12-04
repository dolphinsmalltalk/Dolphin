"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.UDACCEL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_nInc' -> 16r4.
		'_OffsetOf_nSec' -> 16r0
	}!
OS.UDACCEL guid: (Core.GUID fromString: '{425d0ea4-542e-11d3-998b-d5ca2c3c1d61}')!
OS.UDACCEL comment: '<UDACCEL> is an <ExternalStructure> class to wrap the struct ''UpDownLib.UDACCEL'' from type information in the ''Microsoft Windows Up-Down Control'' library.'!
!OS.UDACCEL categoriesForClass!External-Data-Structured-Win32! !
!OS.UDACCEL methodsFor!

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
!OS.UDACCEL categoriesFor: #nInc!**compiled accessors**!public! !
!OS.UDACCEL categoriesFor: #nInc:!**compiled accessors**!public! !
!OS.UDACCEL categoriesFor: #nSec!**compiled accessors**!public! !
!OS.UDACCEL categoriesFor: #nSec:!**compiled accessors**!public! !

!OS.UDACCEL class methodsFor!

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
!OS.UDACCEL class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.UDACCEL class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

