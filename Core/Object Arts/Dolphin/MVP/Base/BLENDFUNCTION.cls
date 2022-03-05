"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #BLENDFUNCTION
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_AlphaFormat _OffsetOf_BlendFlags _OffsetOf_BlendOp _OffsetOf_SourceConstantAlpha'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BLENDFUNCTION guid: (GUID fromString: '{18e4db2f-bc13-4088-8c0d-df249d0bb979}')!
BLENDFUNCTION addClassConstant: '_OffsetOf_AlphaFormat' value: 16r3!
BLENDFUNCTION addClassConstant: '_OffsetOf_BlendFlags' value: 16r1!
BLENDFUNCTION addClassConstant: '_OffsetOf_BlendOp' value: 16r0!
BLENDFUNCTION addClassConstant: '_OffsetOf_SourceConstantAlpha' value: 16r2!
BLENDFUNCTION comment: '<BLENDFUNCTION> is an <ExternalStructure> class to wrap the struct ''Win32.BLENDFUNCTION'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

IDL definition follows:

typedef [uuid(18E4DB2F-BC13-4088-8C0D-DF249D0BB979)]
struct tagBLENDFUNCTION {
	BYTE BlendOp;
	BYTE BlendFlags;
	BYTE SourceConstantAlpha;
	BYTE AlphaFormat;
} BLENDFUNCTION;
'!
!BLENDFUNCTION categoriesForClass!Win32-Structs! !
!BLENDFUNCTION methodsFor!

AlphaFormat
	"Answer the <Integer> value of the receiver's 'AlphaFormat' field."

	^bytes byteAtOffset: _OffsetOf_AlphaFormat!

AlphaFormat: anInteger
	"Set the receiver's 'AlphaFormat' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_AlphaFormat put: anInteger!

blend: aNumber 
	"Sets the fractional blend of the receiver to <Number> argument, which must be in the range 0..1"

	self SourceConstantAlpha: (aNumber * 255) rounded!

BlendFlags
	"Answer the <Integer> value of the receiver's 'BlendFlags' field."

	^bytes byteAtOffset: _OffsetOf_BlendFlags!

BlendFlags: anInteger
	"Set the receiver's 'BlendFlags' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_BlendFlags put: anInteger!

BlendOp
	"Answer the <Integer> value of the receiver's 'BlendOp' field."

	^bytes byteAtOffset: _OffsetOf_BlendOp!

BlendOp: anInteger
	"Set the receiver's 'BlendOp' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_BlendOp put: anInteger!

blendPercentage: aNumber 
	"Sets the percentage blend of the receiver to <Number> argument, which must be in the range 0..100"

	self SourceConstantAlpha: (aNumber * 255 / 100) truncated!

initialize
	super initialize.
	self usePerPixelAlpha: true.
	self BlendOp: AC_SRC_OVER!

SourceConstantAlpha
	"Answer the <Integer> value of the receiver's 'SourceConstantAlpha' field."

	^bytes byteAtOffset: _OffsetOf_SourceConstantAlpha!

SourceConstantAlpha: anInteger
	"Set the receiver's 'SourceConstantAlpha' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_SourceConstantAlpha put: anInteger!

usePerPixelAlpha: aBoolean 
	"Determines whether the source bitmaps alpha channel should be used when performing the
	blend. If not then only the constant alpha is used."

	self AlphaFormat: (aBoolean ifTrue: [AC_SRC_ALPHA] ifFalse: [0])! !
!BLENDFUNCTION categoriesForMethods!
AlphaFormat!**compiled accessors**!public! !
AlphaFormat:!**compiled accessors**!public! !
blend:!accessing!public! !
BlendFlags!**compiled accessors**!public! !
BlendFlags:!**compiled accessors**!public! !
BlendOp!**compiled accessors**!public! !
BlendOp:!**compiled accessors**!public! !
blendPercentage:!accessing!public! !
initialize!initializing!public! !
SourceConstantAlpha!**compiled accessors**!public! !
SourceConstantAlpha:!**compiled accessors**!public! !
usePerPixelAlpha:!accessing!public! !
!

!BLENDFUNCTION class methodsFor!

blend: aNumber 
	"Answers an instance of the receiver set up to specify a blend of a constant
	fractional amount, specified by the <Number> argument."

	^(self new)
		blend: aNumber;
		yourself!

defineFields
	"Define the fields of the BLENDFUNCTION structure.

	BLENDFUNCTION  compileDefinition

		typedef [uuid(18E4DB2F-BC13-4088-8C0D-DF249D0BB979)]
		struct tagBLENDFUNCTION {
			BYTE BlendOp;
			BYTE BlendFlags;
			BYTE SourceConstantAlpha;
			BYTE AlphaFormat;
		} BLENDFUNCTION;
"

	self
		defineField: #BlendOp type: BYTEField new;
		defineField: #BlendFlags type: BYTEField new;
		defineField: #SourceConstantAlpha type: BYTEField new;
		defineField: #AlphaFormat type: BYTEField new!

getFieldNames
	^#(#BlendOp #BlendFlags #SourceConstantAlpha #AlphaFormat)! !
!BLENDFUNCTION class categoriesForMethods!
blend:!instance creation!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

