"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.BLENDFUNCTION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BLENDFUNCTION_Size' -> 16r4.
			'_OffsetOf_AlphaFormat' -> 16r3.
			'_OffsetOf_BlendFlags' -> 16r1.
			'_OffsetOf_BlendOp' -> 16r0.
			'_OffsetOf_SourceConstantAlpha' -> 16r2
		}!
OS.BLENDFUNCTION guid: (Core.GUID fromString: '{18e4db2f-bc13-4088-8c0d-df249d0bb979}')!
OS.BLENDFUNCTION comment: '<BLENDFUNCTION> is an <ExternalStructure> class to wrap the struct ''Win32.BLENDFUNCTION'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

IDL definition follows:

typedef [uuid(18E4DB2F-BC13-4088-8C0D-DF249D0BB979)]
struct tagBLENDFUNCTION {
	BYTE BlendOp;
	BYTE BlendFlags;
	BYTE SourceConstantAlpha;
	BYTE AlphaFormat;
} BLENDFUNCTION;
'!
!OS.BLENDFUNCTION categoriesForClass!Win32-Structs! !
!OS.BLENDFUNCTION methodsFor!

AlphaFormat
	"Answer the <Integer> value of the receiver's 'AlphaFormat' field."

	^bytes uint8AtOffset: _OffsetOf_AlphaFormat!

AlphaFormat: anInteger
	"Set the receiver's 'AlphaFormat' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_AlphaFormat put: anInteger!

blend: aNumber 
	"Sets the fractional blend of the receiver to <Number> argument, which must be in the range 0..1"

	self SourceConstantAlpha: (aNumber * 255) rounded!

BlendFlags
	"Answer the <Integer> value of the receiver's 'BlendFlags' field."

	^bytes uint8AtOffset: _OffsetOf_BlendFlags!

BlendFlags: anInteger
	"Set the receiver's 'BlendFlags' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_BlendFlags put: anInteger!

BlendOp
	"Answer the <Integer> value of the receiver's 'BlendOp' field."

	^bytes uint8AtOffset: _OffsetOf_BlendOp!

BlendOp: anInteger
	"Set the receiver's 'BlendOp' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_BlendOp put: anInteger!

blendPercentage: aNumber
	"Sets the percentage blend of the receiver to <Number> argument, which must be in the range 0..100"

	self SourceConstantAlpha: aNumber * 255 // 100!

initialize
	super initialize.
	self usePerPixelAlpha: true.
	"AC_SRC_OVER = 0, so is the default BlendOp"!

SourceConstantAlpha
	"Answer the <Integer> value of the receiver's 'SourceConstantAlpha' field."

	^bytes uint8AtOffset: _OffsetOf_SourceConstantAlpha!

SourceConstantAlpha: anInteger
	"Set the receiver's 'SourceConstantAlpha' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_SourceConstantAlpha put: anInteger!

usePerPixelAlpha: aBoolean 
	"Determines whether the source bitmaps alpha channel should be used when performing the
	blend. If not then only the constant alpha is used."

	self AlphaFormat: (aBoolean ifTrue: [OS.Win32Constants.AC_SRC_ALPHA] ifFalse: [0])! !
!OS.BLENDFUNCTION categoriesForMethods!
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

!OS.BLENDFUNCTION class methodsFor!

blend: aNumber 
	"Answers an instance of the receiver set up to specify a blend of a constant
	fractional amount, specified by the <Number> argument."

	^(self new)
		blend: aNumber;
		yourself!

byteSize
	^_BLENDFUNCTION_Size!

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
		defineField: #BlendOp type: UInt8Field new;
		defineField: #BlendFlags type: UInt8Field new;
		defineField: #SourceConstantAlpha type: UInt8Field new;
		defineField: #AlphaFormat type: UInt8Field new!

getFieldNames
	^#(#BlendOp #BlendFlags #SourceConstantAlpha #AlphaFormat)! !
!OS.BLENDFUNCTION class categoriesForMethods!
blend:!instance creation!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

