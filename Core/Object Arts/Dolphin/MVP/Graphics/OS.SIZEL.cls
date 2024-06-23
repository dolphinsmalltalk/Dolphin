"Filed out from Dolphin Smalltalk"!

External.SIZE
	subclass: #'OS.SIZEL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_cx' -> 16r0. '_OffsetOf_cy' -> 16r4. '_SIZEL_Size' -> 16r8 }!

OS.SIZEL guid: (Core.GUID fromString: '{3bfb9cb3-8eba-450f-9479-ba75abeb8463}')!

OS.SIZEL comment: '`SIZE` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name. `SIZE` is used in many places to represent a 2-dimensional distance where the x and y dimensions are expressed as 32-bit signed integers. `SIZEL` is an alias for the same class/structure.'!

!OS.SIZEL categoriesForClass!Win32-Structs! !

!OS.SIZEL methodsFor!

asPoint
	"Answer a suitable Smalltalk object to represent the receiver's value, in this case a <Point>."

	^Graphics.Point x: (bytes int32AtOffset: _OffsetOf_cx) y: (bytes int32AtOffset: _OffsetOf_cy)!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes int32AtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cx put: anInteger!

cy
	"Answer the <Integer> value of the receiver's 'cy' field."

	^bytes int32AtOffset: _OffsetOf_cy!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cy put: anInteger!

height
	^bytes int32AtOffset: _OffsetOf_cy!

height: anObject
	bytes int32AtOffset: _OffsetOf_cy put: anObject!

width
	^bytes int32AtOffset: _OffsetOf_cx!

width: anObject
	bytes int32AtOffset: _OffsetOf_cx put: anObject! !

!OS.SIZEL categoriesForMethods!
asPoint!converting!public! !
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
cy!**compiled accessors**!public! !
cy:!**compiled accessors**!public! !
height!accessing!public! !
height:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!OS.SIZEL class methodsFor!

byteSize
	^_SIZEL_Size!

defineFields
	"Define the fields of the SIZEL structure.
		SIZEL compileDefinition
	
		typedef 		struct tagSIZEL {
			long cx;
			long cy;
		} SIZEL;

	"

	self
		defineField: #cx type: Int32Field new;
		defineField: #cy type: Int32Field new!

getFieldNames
	^#(#cx #cy)!

width: cx height: cy
	"Answer a new instance of the receiver representing the Point whose cartesian coordinates
	are the arguments.

	Implementation Note: For performance reasons avoid going through all the <ExternalStructure>
	framework methods."

	^self basicNew bytes: ((ByteArray newFixed: _SIZEL_Size)
				int32AtOffset: _OffsetOf_cx put: cx;
				int32AtOffset: _OffsetOf_cy put: cy;
				yourself)! !

!OS.SIZEL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
width:height:!instance creation!public! !
!

