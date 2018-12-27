"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #CHARRANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CHARRANGE guid: (GUID fromString: '{3fd4e349-a730-484e-afb1-5f2fd9036259}')!
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

	^bytes sdwordAtOffset: ##(self offsetOf: #cpMax)!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #cpMax) put: anInteger!

cpMin
	"Answer the <Integer> value of the receiver's 'cpMin' field."

	^bytes sdwordAtOffset: 0!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger! !
!CHARRANGE categoriesFor: #asObject!accessing!public! !
!CHARRANGE categoriesFor: #cpMax!**compiled accessors**!public! !
!CHARRANGE categoriesFor: #cpMax:!**compiled accessors**!public! !
!CHARRANGE categoriesFor: #cpMin!**compiled accessors**!public! !
!CHARRANGE categoriesFor: #cpMin:!**compiled accessors**!public! !

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
!CHARRANGE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!CHARRANGE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

