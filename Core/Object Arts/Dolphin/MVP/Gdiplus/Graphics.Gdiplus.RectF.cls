﻿"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractRect
	subclass: #'Graphics.Gdiplus.RectF'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_height' -> 16rC.
			'_OffsetOf_width' -> 16r8.
			'_OffsetOf_x' -> 16r0.
			'_OffsetOf_y' -> 16r4.
			'_RectF_Size' -> 16r10
		}!

Graphics.Gdiplus.RectF guid: (Core.GUID fromString: '{9a449c4a-8ae9-45d9-b94d-1e1d91fedcd5}')!

Graphics.Gdiplus.RectF comment: '`RectF` is an `External.Structure` class to wrap the struct ''Gdiplus.RectF'' from type information in the ''GDI+ Library 1.10'' library, and represents a rectangle in a 2D coordinate system (floating-point coordinates).

Note that rectangles in GDI+ follow the convention of specifying an origin and extent, not origin and corner.

IDL definition follows:

typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
struct tagRectF {
	float x;
	float y;
	float width;
	float height;
} RectF;
'!

!Graphics.Gdiplus.RectF methodsFor!

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

!Graphics.Gdiplus.RectF categoriesForMethods!
extent:!accessing!public! !
height!**compiled accessors**!public! !
height:!**compiled accessors**!public! !
scaledBy:!public! !
scaleToDpi:from:!public!transforming! !
width!**compiled accessors**!public! !
width:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.RectF class methodsFor!

byteSize
	^_RectF_Size!

defineFields
	"Define the fields of the RectF structure.
		RectF compileDefinition
	
		typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
		struct tagRectF {
			float x;
			float y;
			float width;
			float height;
		} RectF;
"

	self
		defineField: #x type: FLOATField new;
		defineField: #y type: FLOATField new;
		defineField: #width type: FLOATField new;
		defineField: #height type: FLOATField new!

getFieldNames
	^#(#x #y #width #height)!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified origin and extent."

	^self basicNew bytes: ((ByteArray newFixed: _RectF_Size)
				floatAtOffset: _OffsetOf_x put: left;
				floatAtOffset: _OffsetOf_y put: top;
				floatAtOffset: _OffsetOf_width put: width;
				floatAtOffset: _OffsetOf_height put: height;
				yourself)!

origin: aPoint
	"Answer a new instance of the receiver with the specified origin and zero extent."

	^self basicNew bytes: ((ByteArray newFixed: _RectF_Size)
				floatAtOffset: _OffsetOf_x put: aPoint x;
				floatAtOffset: _OffsetOf_y put: aPoint y;
				yourself)! !

!Graphics.Gdiplus.RectF class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
left:top:width:height:!instance creation!public! !
origin:!instance creation!public! !
!

