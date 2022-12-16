"Filed out from Dolphin Smalltalk"!

External.POINT subclass: #'Graphics.Gdiplus.POINTF'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_x' -> 16r0.
		'_OffsetOf_y' -> 16r4.
		'_POINTF_Size' -> 16r8
	}!
Graphics.Gdiplus.POINTF guid: (Core.GUID fromString: '{c6f719de-eec5-45f6-bd44-71200f76bd34}')!
Graphics.Gdiplus.POINTF comment: '`POINTF` is an `ExternalStructure` class to wrap the struct of the same name.

`POINTF` is a cartesian coordinate with single precision floating point x and y values.'!
!Graphics.Gdiplus.POINTF categoriesForClass!External-Data-Structured! !
!Graphics.Gdiplus.POINTF methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning as a 32-bit value (i.e. a 32-bit integer)."

	^self shouldNotImplement!

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
!Graphics.Gdiplus.POINTF categoriesForMethods!
asDword!converting!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.POINTF class methodsFor!

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
!Graphics.Gdiplus.POINTF class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
x:y:!instance creation!public! !
!

