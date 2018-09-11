"Filed out from Dolphin Smalltalk 7"!

ExternalSize subclass: #SIZE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SIZE guid: (GUID fromString: '{3bfb9cb3-8eba-450f-9479-ba75abeb8463}')!
SIZE comment: '`SIZE` is an `ExternalStructure` class to wrap the standard Win32 structure of the same name. `SIZE` is used in many places to represent a 2-dimensional distance where the x and y dimensions are expressed as 32-bit signed integers. `SIZEL` is an alias for the same class/structure.'!
!SIZE categoriesForClass!Win32-Structs! !
!SIZE methodsFor!

cx
	"Answer the receiver's cx field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

cx: anObject 
	"Set the receiver's cx field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

cy
	"Answer the receiver's cy field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cy)!

cy: anObject 
	"Set the receiver's cy field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cy) put: anObject!

height
	^bytes sdwordAtOffset: ##(self offsetOf: #cy)!

height: anObject
	bytes sdwordAtOffset: ##(self offsetOf: #cy) put: anObject!

width
	^bytes sdwordAtOffset: 0!

width: anObject
	bytes sdwordAtOffset: 0 put: anObject! !
!SIZE categoriesFor: #cx!**compiled accessors**!public! !
!SIZE categoriesFor: #cx:!**compiled accessors**!public! !
!SIZE categoriesFor: #cy!**compiled accessors**!public! !
!SIZE categoriesFor: #cy:!**compiled accessors**!public! !
!SIZE categoriesFor: #height!accessing!public! !
!SIZE categoriesFor: #height:!accessing!public! !
!SIZE categoriesFor: #width!accessing!public! !
!SIZE categoriesFor: #width:!accessing!public! !

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
!SIZE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SIZE class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!SIZE class categoriesFor: #width:height:!instance creation!public! !

