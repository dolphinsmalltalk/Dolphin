"Filed out from Dolphin Smalltalk"!

ExternalSize subclass: #SIZE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cx _OffsetOf_cy'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SIZE guid: (GUID fromString: '{3bfb9cb3-8eba-450f-9479-ba75abeb8463}')!

SIZE addClassConstant: '_OffsetOf_cx' value: 16r0!
SIZE addClassConstant: '_OffsetOf_cy' value: 16r4!

SIZE comment: '`SIZE` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name. `SIZE` is used in many places to represent a 2-dimensional distance where the x and y dimensions are expressed as 32-bit signed integers. `SIZEL` is an alias for the same class/structure.'!

!SIZE categoriesForClass!Win32-Structs! !

!SIZE methodsFor!

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

!SIZE categoriesForMethods!
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
cy!**compiled accessors**!public! !
cy:!**compiled accessors**!public! !
height!accessing!public! !
height:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!SIZE class methodsFor!

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

uninitialize
	"Private - Unitialize the receiver as it is about to be removed from the system.
	Make sure our alias disappears with us."

	self environment removeKey: #SIZEL ifAbsent: []!

width: cx height: cy 
	"Answer a new instance of the receiver representing the Point whose cartesian coordinates
	are the arguments.

	Implementation Note: For performance reasons avoid going through all the <ExternalStructure>
	framework methods."

	^self basicNew bytes: ((ByteArray newFixed: 8)
				sdwordAtOffset: 0 put: cx;
				sdwordAtOffset: 4 put: cy;
				yourself)! !

!SIZE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
uninitialize!class hierarchy-removing!private! !
width:height:!instance creation!public! !
!

