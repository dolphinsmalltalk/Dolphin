"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.CHARRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cpMax' -> 16r4.
		'_OffsetOf_cpMin' -> 16r0
	}!
OS.CHARRANGE guid: (Core.GUID fromString: '{3fd4e349-a730-484e-afb1-5f2fd9036259}')!
OS.CHARRANGE comment: '<CHARRANGE> is an <ExternalStructure> class to wrap the struct ''Win.CHARRANGE'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCHARRANGE {
	long cpMin;
	long cpMax;
} CHARRANGE;
'!
!OS.CHARRANGE categoriesForClass!Win-Structs! !
!OS.CHARRANGE methodsFor!

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
!OS.CHARRANGE categoriesFor: #asObject!accessing!public! !
!OS.CHARRANGE categoriesFor: #cpMax!**compiled accessors**!public! !
!OS.CHARRANGE categoriesFor: #cpMax:!**compiled accessors**!public! !
!OS.CHARRANGE categoriesFor: #cpMin!**compiled accessors**!public! !
!OS.CHARRANGE categoriesFor: #cpMin:!**compiled accessors**!public! !

!OS.CHARRANGE class methodsFor!

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
!OS.CHARRANGE class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.CHARRANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

