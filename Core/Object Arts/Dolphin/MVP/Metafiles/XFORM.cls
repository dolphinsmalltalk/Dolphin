"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #XFORM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_eDx' -> 16r10.
		'_OffsetOf_eDy' -> 16r14.
		'_OffsetOf_eM11' -> 16r0.
		'_OffsetOf_eM12' -> 16r4.
		'_OffsetOf_eM21' -> 16r8.
		'_OffsetOf_eM22' -> 16rC
	}!
XFORM guid: (GUID fromString: '{94b29afb-539e-4f6e-81d0-ed7aeb51f4ff}')!
XFORM comment: '<XFORM> is an <ExternalStructure> class to wrap the struct ''Win32.XFORM'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(94B29AFB-539E-4F6E-81D0-ED7AEB51F4FF)]
struct tagXFORM {
	float eM11;
	float eM12;
	float eM21;
	float eM22;
	float eDx;
	float eDy;
} XFORM;
'!
!XFORM categoriesForClass!Win32-Structs! !
!XFORM methodsFor!

eDx
	"Answer the <Float> value of the receiver's 'eDx' field."

	^bytes floatAtOffset: _OffsetOf_eDx!

eDx: aFloat
	"Set the receiver's 'eDx' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eDx put: aFloat!

eDy
	"Answer the <Float> value of the receiver's 'eDy' field."

	^bytes floatAtOffset: _OffsetOf_eDy!

eDy: aFloat
	"Set the receiver's 'eDy' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eDy put: aFloat!

eM11
	"Answer the <Float> value of the receiver's 'eM11' field."

	^bytes floatAtOffset: _OffsetOf_eM11!

eM11: aFloat
	"Set the receiver's 'eM11' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eM11 put: aFloat!

eM12
	"Answer the <Float> value of the receiver's 'eM12' field."

	^bytes floatAtOffset: _OffsetOf_eM12!

eM12: aFloat
	"Set the receiver's 'eM12' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eM12 put: aFloat!

eM21
	"Answer the <Float> value of the receiver's 'eM21' field."

	^bytes floatAtOffset: _OffsetOf_eM21!

eM21: aFloat
	"Set the receiver's 'eM21' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eM21 put: aFloat!

eM22
	"Answer the <Float> value of the receiver's 'eM22' field."

	^bytes floatAtOffset: _OffsetOf_eM22!

eM22: aFloat
	"Set the receiver's 'eM22' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_eM22 put: aFloat! !
!XFORM categoriesFor: #eDx!**compiled accessors**!public! !
!XFORM categoriesFor: #eDx:!**compiled accessors**!public! !
!XFORM categoriesFor: #eDy!**compiled accessors**!public! !
!XFORM categoriesFor: #eDy:!**compiled accessors**!public! !
!XFORM categoriesFor: #eM11!**compiled accessors**!public! !
!XFORM categoriesFor: #eM11:!**compiled accessors**!public! !
!XFORM categoriesFor: #eM12!**compiled accessors**!public! !
!XFORM categoriesFor: #eM12:!**compiled accessors**!public! !
!XFORM categoriesFor: #eM21!**compiled accessors**!public! !
!XFORM categoriesFor: #eM21:!**compiled accessors**!public! !
!XFORM categoriesFor: #eM22!**compiled accessors**!public! !
!XFORM categoriesFor: #eM22:!**compiled accessors**!public! !

!XFORM class methodsFor!

defineFields
	"Define the fields of the XFORM structure.

	XFORM  compileDefinition

		typedef [uuid(94B29AFB-539E-4F6E-81D0-ED7AEB51F4FF)]
		struct tagXFORM {
			float eM11;
			float eM12;
			float eM21;
			float eM22;
			float eDx;
			float eDy;
		} XFORM;
"

	self
		defineField: #eM11 type: FLOATField new;
		defineField: #eM12 type: FLOATField new;
		defineField: #eM21 type: FLOATField new;
		defineField: #eM22 type: FLOATField new;
		defineField: #eDx type: FLOATField new;
		defineField: #eDy type: FLOATField new!

getFieldNames
	^#(#eM11 #eM12 #eM21 #eM22 #eDx #eDy)! !
!XFORM class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!XFORM class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

