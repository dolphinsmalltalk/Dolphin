"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRANGLEARC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRANGLEARC guid: (GUID fromString: '{76825af3-ec74-45d6-8539-0c31f3e069b9}')!
EMRANGLEARC comment: '<EMRANGLEARC> is an <ExternalStructure> class to wrap the struct ''Win32.EMRANGLEARC'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(76825AF3-EC74-45D6-8539-0C31F3E069B9)]
struct tagEMRANGLEARC {
	EMR EMR;
	POINTL ptlCenter;
	DWORD nRadius;
	float eStartAngle;
	float eSweepAngle;
} EMRANGLEARC;
'!
!EMRANGLEARC categoriesForClass!Win32-Structs! !
!EMRANGLEARC methodsFor!

eStartAngle
	"Answer the receiver's eStartAngle field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eStartAngle)!

eStartAngle: anObject 
	"Set the receiver's eStartAngle field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eStartAngle) put: anObject!

eSweepAngle
	"Answer the receiver's eSweepAngle field as a Smalltalk object."

	^bytes floatAtOffset: ##(self offsetOf: #eSweepAngle)!

eSweepAngle: anObject 
	"Set the receiver's eSweepAngle field to the value of anObject."

	bytes floatAtOffset: ##(self offsetOf: #eSweepAngle) put: anObject!

nRadius
	"Answer the receiver's nRadius field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nRadius)!

nRadius: anObject 
	"Set the receiver's nRadius field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nRadius) put: anObject!

ptlCenter
	"Answer the receiver's ptlCenter field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptlCenter)!

ptlCenter: anObject 
	"Set the receiver's ptlCenter field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ptlCenter) + 1)
		to: ##((self offsetOf: #ptlCenter) + POINTL basicByteSize)
		startingAt: 1! !
!EMRANGLEARC categoriesFor: #eStartAngle!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #eStartAngle:!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #eSweepAngle!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #eSweepAngle:!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #nRadius!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #nRadius:!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #ptlCenter!**compiled accessors**!public! !
!EMRANGLEARC categoriesFor: #ptlCenter:!**compiled accessors**!public! !

!EMRANGLEARC class methodsFor!

defineFields
	"Define the fields of the EMRANGLEARC structure.

	EMRANGLEARC  compileDefinition

		typedef [uuid(76825AF3-EC74-45D6-8539-0C31F3E069B9)]
		struct tagEMRANGLEARC {
			EMR EMR;
			POINTL ptlCenter;
			DWORD nRadius;
			float eStartAngle;
			float eSweepAngle;
		} EMRANGLEARC;
"

	super defineFields.
	self
		defineField: #ptlCenter type: (StructureField type: POINTL) offset: 8;
		defineField: #nRadius type: DWORDField new offset: 16;
		defineField: #eStartAngle type: FLOATField new offset: 20;
		defineField: #eSweepAngle type: FLOATField new offset: 24.
	self byteSize: 28!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^Array with: EMR_ANGLEARC! !
!EMRANGLEARC class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRANGLEARC class categoriesFor: #iTypes!constants!public! !

