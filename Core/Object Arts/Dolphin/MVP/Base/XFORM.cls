"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #XFORM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XFORM guid: (GUID fromString: '{94B29AFB-539E-4F6E-81D0-ED7AEB51F4FF}')!
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
	"Answer the receiver's eDx field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eDx)!

eDx: anObject 
	"Set the receiver's eDx field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eDx) put: anObject!

eDy
	"Answer the receiver's eDy field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eDy)!

eDy: anObject 
	"Set the receiver's eDy field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eDy) put: anObject!

eM11
	"Answer the receiver's eM11 field as a Smalltalk object."

	^bytes floatAtOffset: 0!

eM11: anObject 
	"Set the receiver's eM11 field to the value of anObject."

	bytes floatAtOffset: 0 put: anObject!

eM12
	"Answer the receiver's eM12 field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eM12)!

eM12: anObject 
	"Set the receiver's eM12 field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eM12) put: anObject!

eM21
	"Answer the receiver's eM21 field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eM21)!

eM21: anObject 
	"Set the receiver's eM21 field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eM21) put: anObject!

eM22
	"Answer the receiver's eM22 field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eM22)!

eM22: anObject 
	"Set the receiver's eM22 field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eM22) put: anObject! !
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
		defineField: #eDy type: FLOATField new! !
!XFORM class categoriesFor: #defineFields!**auto generated**!initializing!public! !

