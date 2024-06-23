"Filed out from Dolphin Smalltalk"!

External.POINT
	subclass: #'External.POINTF'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_x' -> 16r0. '_OffsetOf_y' -> 16r4. '_POINTF_Size' -> 16r8 }!

External.POINTF guid: (Core.GUID fromString: '{c6f719de-eec5-45f6-bd44-71200f76bd34}')!

External.POINTF comment: '`POINTF` is an `ExternalStructure` class to wrap the struct of the same name.

`POINTF` is a cartesian coordinate with single precision floating point x and y values.'!

!External.POINTF categoriesForClass!External-Data-Structured! !

!External.POINTF methodsFor!

asUInt32
	"Answer the receiver in a form suitable for passing or returning as a 32-bit value (i.e. a 32-bit integer)."

	^self shouldNotImplement!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning as a  machine-word sized (32 or 64-bit) value."

	^self shouldNotImplement!

ceiling
	"Answer a new Point with the x and y values of the receiver truncated
	toward positive infinity."

	^self x ceiling @ self y ceiling!

floor
	"Answer a new <Point> with the x and y values of the receiver truncated toward negative infinity."

	^self x floor @ self y floor!

isZero
	"Answer whether the receiver is equal to Point zero."

	^(bytes uint64AtOffset: 0) == 0!

rounded
	"Answer a new Point with the x and y values of the receiver rounded."

	^self x rounded @ self y rounded!

truncated
	"Answer a new Point with the x and y values of the receiver truncated toward zero"

	^self x truncated @ self y truncated!

x
	"Answer the <Float> value of the receiver's 'x' field."

	^bytes floatAtOffset: _OffsetOf_x!

x: aFloat
	"Set the receiver's 'x' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_x put: aFloat!

y
	"Answer the <Float> value of the receiver's 'y' field."

	^bytes floatAtOffset: _OffsetOf_y!

y: aFloat
	"Set the receiver's 'y' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_y put: aFloat! !

!External.POINTF categoriesForMethods!
asUInt32!converting!public! !
asUIntPtr!converting!public! !
ceiling!public!truncation and round off! !
floor!public!truncation and round off! !
isZero!public!testing! !
rounded!public!truncation and round off! !
truncated!public!truncation and round off! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!External.POINTF class methodsFor!

arrayType
	"Private - Answer the class of object (typically an <ExternalArray> subclass) to be used to 
	represent arrays of the receiver's field type in other structures."

	^POINTFArray!

byteSize
	^_POINTF_Size!

defineFields
	"Define the fields of the POINTF structure.
		POINTF compileDefinition
	
		typedef 		struct tagPOINTF {
			single x;
			single y;
		} POINTF;

	"

	self
		defineField: #x type: FLOATField new;
		defineField: #y type: FLOATField new!

x: x y: y
	"Answer a new instance of the receiver representing the Point whose 
	cartesian coordinates are the arguments.
	Implementation Note: For performance reasons avoid going through
	all the <ExternalStructure> framework methods."

	^self basicNew bytes: ((ByteArray newFixed: _POINTF_Size)
				floatAtOffset: _OffsetOf_x put: x;
				floatAtOffset: _OffsetOf_y put: y;
				yourself)! !

!External.POINTF class categoriesForMethods!
arrayType!constants!private! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
x:y:!instance creation!public! !
!

