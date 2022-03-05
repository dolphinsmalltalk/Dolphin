"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #CHARRANGE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cpMax _OffsetOf_cpMin'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CHARRANGE guid: (GUID fromString: '{3fd4e349-a730-484e-afb1-5f2fd9036259}')!
CHARRANGE addClassConstant: '_OffsetOf_cpMax' value: 16r4!
CHARRANGE addClassConstant: '_OffsetOf_cpMin' value: 16r0!
CHARRANGE comment: '<CHARRANGE> is an <ExternalStructure> class to wrap the struct ''Win.CHARRANGE'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCHARRANGE {
	long cpMin;
	long cpMax;
} CHARRANGE;
'!
!CHARRANGE categoriesForClass!Win-Structs! !
!CHARRANGE methodsFor!

asObject
	"Answer the <Object> value represented by the receiver."

	^self cpMin to: self cpMax!

cpMax
	"Answer the <Integer> value of the receiver's 'cpMax' field."

	^bytes sdwordAtOffset: _OffsetOf_cpMax!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMax put: anInteger!

cpMin
	"Answer the <Integer> value of the receiver's 'cpMin' field."

	^bytes sdwordAtOffset: _OffsetOf_cpMin!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMin put: anInteger! !
!CHARRANGE categoriesForMethods!
asObject!accessing!public! !
cpMax!**compiled accessors**!public! !
cpMax:!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
!

!CHARRANGE class methodsFor!

defineFields
	"Define the fields of the CHARRANGE structure.
		CHARRANGE compileDefinition
	
		typedef 
		struct tagCHARRANGE {
			long cpMin;
			long cpMax;
		} CHARRANGE;
"

	self
		defineField: #cpMin type: SDWORDField new;
		defineField: #cpMax type: SDWORDField new!

getFieldNames
	^#(#cpMin #cpMax)! !
!CHARRANGE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

