"Filed out from Dolphin Smalltalk 7"!

External.SIZE subclass: #'OS.SIZEL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cx' -> 16r0.
		'_OffsetOf_cy' -> 16r4
	}!
OS.SIZEL guid: (Core.GUID fromString: '{3bfb9cb3-8eba-450f-9479-ba75abeb8463}')!
OS.SIZEL comment: '`SIZE` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name. `SIZE` is used in many places to represent a 2-dimensional distance where the x and y dimensions are expressed as 32-bit signed integers. `SIZEL` is an alias for the same class/structure.'!
!OS.SIZEL categoriesForClass!Win32-Structs! !
!OS.SIZEL methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes sdwordAtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cx put: anInteger!

cy
	"Answer the <Integer> value of the receiver's 'cy' field."

	^bytes sdwordAtOffset: _OffsetOf_cy!

cy: anInteger
	"Set the receiver's 'cy' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cy put: anInteger!

height
	^bytes sdwordAtOffset: _OffsetOf_cy!

height: anObject
	bytes sdwordAtOffset: _OffsetOf_cy put: anObject!

width
	^bytes sdwordAtOffset: _OffsetOf_cx!

width: anObject
	bytes sdwordAtOffset: _OffsetOf_cx put: anObject! !
!OS.SIZEL categoriesFor: #cx!**compiled accessors**!public! !
!OS.SIZEL categoriesFor: #cx:!**compiled accessors**!public! !
!OS.SIZEL categoriesFor: #cy!**compiled accessors**!public! !
!OS.SIZEL categoriesFor: #cy:!**compiled accessors**!public! !
!OS.SIZEL categoriesFor: #height!accessing!public! !
!OS.SIZEL categoriesFor: #height:!accessing!public! !
!OS.SIZEL categoriesFor: #width!accessing!public! !
!OS.SIZEL categoriesFor: #width:!accessing!public! !

!OS.SIZEL class methodsFor!

defineFields
	"Define the fields of the SIZEL structure.
		SIZEL compileDefinition
	
		typedef 		struct tagSIZEL {
			long cx;
			long cy;
		} SIZEL;

	"

	self
		defineField: #cx type: SDWORDField new;
		defineField: #cy type: SDWORDField new!

getFieldNames
	^#(#cx #cy)!

width: cx height: cy
	"Answer a new instance of the receiver representing the Point whose cartesian coordinates
	are the arguments.

	Implementation Note: For performance reasons avoid going through all the <ExternalStructure>
	framework methods."

	^self basicNew bytes: ((ByteArray newFixed: 8)
				sdwordAtOffset: 0 put: cx;
				sdwordAtOffset: 4 put: cy;
				yourself)! !
!OS.SIZEL class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.SIZEL class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.SIZEL class categoriesFor: #width:height:!instance creation!public! !

