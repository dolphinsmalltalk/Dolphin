"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractRect
	subclass: #'Graphics.Gdiplus.Rect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_height' -> 16rC.
			'_OffsetOf_width' -> 16r8.
			'_OffsetOf_x' -> 16r0.
			'_OffsetOf_y' -> 16r4.
			'_Rect_Size' -> 16r10
		}!
Graphics.Gdiplus.Rect guid: (Core.GUID fromString: '{6971c1a9-6a91-4a18-a526-2beac92d4746}')!
Graphics.Gdiplus.Rect comment: '`Rect` is an `External.Structure` class to wrap the struct ''Gdiplus.Rect'' from type information in the ''GDI+ Library 1.10'' library, and represents a rectangle in a 2D coordinate system (integer coordinates).

Note that rectangles in GDI+ follow the convention of specifying an origin and extent, not origin and corner.

IDL definition follows:

typedef [uuid(9A449C4A-8AE9-45D9-B94D-1E1D91FEDCD5)]
struct tagRectF {
	long x;
	long y;
	long width;
	long height;
} RectF;'!
!Graphics.Gdiplus.Rect methodsFor!

height
	"Answer the <Integer> value of the receiver's 'height' field."

	^bytes int32AtOffset: _OffsetOf_height!

height: anInteger
	"Set the receiver's 'height' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_height put: anInteger!

width
	"Answer the <Integer> value of the receiver's 'width' field."

	^bytes int32AtOffset: _OffsetOf_width!

width: anInteger
	"Set the receiver's 'width' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_width put: anInteger!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes int32AtOffset: _OffsetOf_x!

x: anInteger
	"Set the receiver's 'x' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_x put: anInteger!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes int32AtOffset: _OffsetOf_y!

y: anInteger
	"Set the receiver's 'y' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_y put: anInteger! !
!Graphics.Gdiplus.Rect categoriesForMethods!
height!**compiled accessors**!public! !
height:!**compiled accessors**!public! !
width!**compiled accessors**!public! !
width:!**compiled accessors**!public! !
x!**compiled accessors**!public! !
x:!**compiled accessors**!public! !
y!**compiled accessors**!public! !
y:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.Rect class methodsFor!

byteSize
	^_Rect_Size!

defineFields
	"Define the fields of the GpRect structure.
		GpRect compileDefinition
	"

	self
		defineField: #x type: Int32Field new;
		defineField: #y type: Int32Field new;
		defineField: #width type: Int32Field new;
		defineField: #height type: Int32Field new!

left: left top: top width: width height: height
	"Answer a new instance of the receiver with the specified origin and extent."

	^self basicNew bytes: ((ByteArray newFixed: _Rect_Size)
				int32AtOffset: _OffsetOf_x put: left;
				int32AtOffset: _OffsetOf_y put: top;
				int32AtOffset: _OffsetOf_width put: width;
				int32AtOffset: _OffsetOf_height put: height;
				yourself)! !
!Graphics.Gdiplus.Rect class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
left:top:width:height:!instance creation!public! !
!

