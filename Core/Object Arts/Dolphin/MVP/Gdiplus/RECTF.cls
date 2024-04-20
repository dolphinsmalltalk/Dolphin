"Filed out from Dolphin Smalltalk"!

ExternalRectangle subclass: #RECTF
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_height _OffsetOf_width _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RECTF guid: (GUID fromString: '{9a449c4a-8ae9-45d9-b94d-1e1d91fedcd5}')!

RECTF addClassConstant: '_OffsetOf_height' value: 16rC!
RECTF addClassConstant: '_OffsetOf_width' value: 16r8!
RECTF addClassConstant: '_OffsetOf_x' value: 16r0!
RECTF addClassConstant: '_OffsetOf_y' value: 16r4!

RECTF comment: '<RECTF> is an <ExternalStructure> class to wrap the struct ''Gdiplus.RECTF'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
struct tagRECTF {
	float x;
	float y;
	float Width;
	float Height;
} RECTF;
'!

!RECTF categoriesForClass!Unclassified! !

!RECTF methodsFor!

asRectangle
	^self x @ self y extent: self width @ self height!

bottom
	^self y + self height!

bottom: aNumber
	self height: aNumber - self y!

extent: aPoint
	"Set the extent of the receiver to aPoint. (The origin remains the same and the corner stays in the same quadrant it was in relative to the origin point. If aPoint contains any negative value, the result is undefined)."

	self
		width: aPoint x;
		height: aPoint y!

height
	"Answer the <Float> value of the receiver's 'height' field."

	^bytes floatAtOffset: _OffsetOf_height!

height: aFloat
	"Set the receiver's 'height' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_height put: aFloat!

left
	^self x!

left: aNumber
	"Sets the position of the receiver's left edge."

	"The corner is not expected to move, so the width must change."

	self width: self width + (self x - aNumber).
	self x: aNumber!

right
	^self x + self width!

right: aNumber
	self width: aNumber - self x!

scaleBy: aMagnitude
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier."

	| p |
	p := self topLeft * aMagnitude.
	self
		x: p x;
		y: p y.
	p := self extent * aMagnitude.
	self
		width: p x;
		height: p y!

scaledBy: anArithmeticValue
	"Answer a new <rectangle> representing the receiver with origin and corner multiplied by the <ArithmeticValue> argument. Uses the #vertex:vertex: constructor in order to create a normalised rectangle"

	^self species vertex: self topLeft * anArithmeticValue vertex: self bottomRight * anArithmeticValue!

scaleToDpi: desiredInteger from: currentInteger
	"Scale the receiver in-place by from the DPI represented by the first <integer> argument to that represented by the second integer argument."

	| scale |
	scale := desiredInteger asFloat / currentInteger.
	bytes
		floatAtOffset: _OffsetOf_x put: (bytes floatAtOffset: _OffsetOf_x) * scale;
		floatAtOffset: _OffsetOf_y put: (bytes floatAtOffset: _OffsetOf_y) * scale;
		floatAtOffset: _OffsetOf_width put: (bytes floatAtOffset: _OffsetOf_width) * scale;
		floatAtOffset: _OffsetOf_height put: (bytes floatAtOffset: _OffsetOf_height) * scale!

top
	^self y!

top: aNumber
	self height: self height + (self y - aNumber).
	self y: aNumber!

width
	"Answer the <Float> value of the receiver's 'width' field."

	^bytes floatAtOffset: _OffsetOf_width!

width: aFloat
	"Set the receiver's 'width' field to the value of the argument, aFloat"

	bytes floatAtOffset: _OffsetOf_width put: aFloat!

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

!RECTF categoriesForMethods!
asRectangle!converting!public! !
bottom!accessing!public! !
bottom:!accessing!public! !
extent:!accessing!public! !
height!**compiled accessors**!public! !
height:!**compiled accessors**!public! !
left!accessing!public! !
left:!accessing!public! !
right!accessing!public! !
right:!accessing!public! !
scaleBy:!public!transforming! !
scaledBy:!public! !
scaleToDpi:from:!public!transforming! !
top!accessing!public! !
top:!accessing!public! !
width!**compiled accessors**!public! !
width:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!RECTF class methodsFor!

defineFields
	"Define the fields of the RECTF structure.
		RECTF compileDefinition
	
		typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
		struct tagRECTF {
			float x;
			float y;
			float Width;
			float Height;
		} RECTF;
"

	self
		defineField: #x type: FLOATField new;
		defineField: #y type: FLOATField new;
		defineField: #width type: FLOATField new;
		defineField: #height type: FLOATField new!

getFieldNames
	^#(#x #y #width #height)!

left: left top: top right: right bottom: bottom
	"Answer a new instance of the receiver with the specified position corner positions."

	^self
		left: left
		top: top
		width: right - left
		height: bottom - top!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified origin and extent."

	^self basicNew bytes: ((ByteArray newFixed: 16)
				floatAtOffset: 0 put: left;
				floatAtOffset: 4 put: top;
				floatAtOffset: 8 put: width;
				floatAtOffset: 12 put: height;
				yourself)!

marshal: aRectangle
	"Answer the argument marshalled as an instance of the receiver."

	self == aRectangle class ifTrue: [^aRectangle].
	^self
		left: aRectangle left
		top: aRectangle top
		width: aRectangle width
		height: aRectangle height!

newBuffer
	^self basicNew bytes: (ByteArray newFixed: 16)! !

!RECTF class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
left:top:right:bottom:!instance creation!public! !
left:top:width:height:!instance creation!public! !
marshal:!instance creation!public! !
newBuffer!instance creation!public! !
!

