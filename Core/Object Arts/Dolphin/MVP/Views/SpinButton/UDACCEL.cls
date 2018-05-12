"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #UDACCEL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UDACCEL guid: (GUID fromString: '{425d0ea4-542e-11d3-998b-d5ca2c3c1d61}')!
UDACCEL comment: '<UDACCEL> is an <ExternalStructure> class to wrap the struct ''UpDownLib.UDACCEL'' from type information in the ''Microsoft Windows Up-Down Control'' library.'!
!UDACCEL categoriesForClass!External-Data-Structured-Win32! !
!UDACCEL methodsFor!

nInc
	"Answer the receiver's nInc field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

nInc: anObject
	"Set the receiver's nInc field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

nSec
	"Answer the receiver's nSec field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

nSec: anObject
	"Set the receiver's nSec field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!UDACCEL categoriesFor: #nInc!**compiled accessors**!public! !
!UDACCEL categoriesFor: #nInc:!**compiled accessors**!public! !
!UDACCEL categoriesFor: #nSec!**compiled accessors**!public! !
!UDACCEL categoriesFor: #nSec:!**compiled accessors**!public! !

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
		defineField: #nInc type: DWORDField new! !
!UDACCEL class categoriesFor: #defineFields!**auto generated**!initializing!public! !

