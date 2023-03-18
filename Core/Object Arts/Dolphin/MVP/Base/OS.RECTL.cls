"Filed out from Dolphin Smalltalk"!

External.RECT subclass: #'OS.RECTL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bottom' -> 16rC.
		'_OffsetOf_left' -> 16r0.
		'_OffsetOf_right' -> 16r8.
		'_OffsetOf_top' -> 16r4.
		'_RECTL_Size' -> 16r10
	}!
OS.RECTL guid: (Core.GUID fromString: '{0a6e055d-001b-4817-b07d-fe982ca46330}')!
OS.RECTL comment: '`RECT` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name.

The `RECT` structure is used in many places in the Windows API to represent a rectangle consisting of 32-bit co-ordinates for top-left and bottom-right corners. `RECTL` is an alias for the same class/structure. `RECT` supports conversions to and from the Smalltalk `Rectangle` class.'!
!OS.RECTL categoriesForClass!Win32-Structs! !
!OS.RECTL methodsFor!

asRectangle
	"Answer a new Rectangle that matches the receiver."

	"Implementation Note: This is used so much during layout, that it is worth providing an inlined implementation as an optimization."

	^Graphics.Rectangle
		origin: (bytes int32AtOffset: _OffsetOf_left) @ (bytes int32AtOffset: _OffsetOf_top)
		corner: (bytes int32AtOffset: _OffsetOf_right) @ (bytes int32AtOffset: _OffsetOf_bottom)!

bottom
	"Answer the <Integer> value of the receiver's 'bottom' field."

	^bytes int32AtOffset: _OffsetOf_bottom!

bottom: anInteger
	"Set the receiver's 'bottom' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_bottom put: anInteger!

bottomRight
	"Answer a Point representing the bottom right position of the receiver."

	^(bytes int32AtOffset: _OffsetOf_right) @ (bytes int32AtOffset: _OffsetOf_bottom)!

extent
	"Answer a Point representing the extent of the receiver. The x coordinate is the width and the y coordinate is the height."

	"Override as an optimisation"

	^((bytes int32AtOffset: _OffsetOf_right) - (bytes int32AtOffset: _OffsetOf_left))
		@ ((bytes int32AtOffset: _OffsetOf_bottom) - (bytes int32AtOffset: _OffsetOf_top))!

left
	"Answer the <Integer> value of the receiver's 'left' field."

	^bytes int32AtOffset: _OffsetOf_left!

left: anInteger
	"Set the receiver's 'left' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_left put: anInteger!

right
	"Answer the <Integer> value of the receiver's 'right' field."

	^bytes int32AtOffset: _OffsetOf_right!

right: anInteger
	"Set the receiver's 'right' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_right put: anInteger!

top
	"Answer the <Integer> value of the receiver's 'top' field."

	^bytes int32AtOffset: _OffsetOf_top!

top: anInteger
	"Set the receiver's 'top' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_top put: anInteger! !
!OS.RECTL categoriesForMethods!
asRectangle!converting!public! !
bottom!**compiled accessors**!public! !
bottom:!**compiled accessors**!public! !
bottomRight!accessing!public! !
extent!accessing!public! !
left!**compiled accessors**!public! !
left:!**compiled accessors**!public! !
right!**compiled accessors**!public! !
right:!**compiled accessors**!public! !
top!**compiled accessors**!public! !
top:!**compiled accessors**!public! !
!

!OS.RECTL class methodsFor!

byteSize
	^_RECTL_Size!

defineFields
	"Define the fields of the RECTL structure.
		RECTL compileDefinition
	
		typedef 		struct tagRECT {
			long left;
			long top;
			long right;
			long bottom;
		} RECTL;

	"

	self
		defineField: #left type: Int32Field new;
		defineField: #top type: Int32Field new;
		defineField: #right type: Int32Field new;
		defineField: #bottom type: Int32Field new!

extent: newExtent
	"Answer a new instance of the receiver with zero origin and the specified extent."

	^self basicNew bytes: ((ByteArray newFixed: _RECTL_Size)
				int32AtOffset: _OffsetOf_right put: newExtent x;
				int32AtOffset: _OffsetOf_bottom put: newExtent y;
				yourself)!

getFieldNames
	^#(#left #top #right #bottom)!

left: leftInteger top: topInteger right: rightInteger bottom: bottomInteger
	"Answer a new instance of the receiver with the specified position
	corner positions."

	"Implementation Note: For performance reasons do this all with low-level
	inline code."

	^self basicNew bytes: ((ByteArray newFixed: _RECTL_Size)
				int32AtOffset: _OffsetOf_left put: leftInteger;
				int32AtOffset: _OffsetOf_top put: topInteger;
				int32AtOffset: _OffsetOf_right put: rightInteger;
				int32AtOffset: _OffsetOf_bottom put: bottomInteger;
				yourself)!

width: widthInteger
	"Answer a new instance of the receiver with zero origin and height, and the specified width."

	^self basicNew bytes: ((ByteArray newFixed: _RECTL_Size)
				int32AtOffset: _OffsetOf_right put: widthInteger;
				yourself)!

width: widthInteger height: heightInteger
	"Answer a new instance of the receiver with zero origin and the specified width and height."

	^self basicNew bytes: ((ByteArray newFixed: _RECTL_Size)
				int32AtOffset: _OffsetOf_right put: widthInteger;
				int32AtOffset: _OffsetOf_bottom put: heightInteger;
				yourself)! !
!OS.RECTL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
extent:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
left:top:right:bottom:!instance creation!public! !
width:!instance creation!public! !
width:height:!instance creation!public! !
!

