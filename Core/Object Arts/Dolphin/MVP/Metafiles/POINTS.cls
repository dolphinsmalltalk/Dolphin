"Filed out from Dolphin Smalltalk 7"!

POINTL subclass: #POINTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
POINTS guid: (GUID fromString: '{3278b910-3376-47e3-be99-02afe78a6230}')!
POINTS comment: '<POINTS> is an <ExternalStructure> class to wrap the struct ''Win32.POINTS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(3278B910-3376-47E3-BE99-02AFE78A6230)]
struct tagPOINTS {
	short x;
	short y;
} POINTS;
'!
!POINTS categoriesForClass!Win32-Structs! !
!POINTS methodsFor!

asDword
	"Answer the receiver in a form suitable for passing or returning 
	as a 32-bit value (i.e. a 32-bit integer)."

	^bytes dwordAtOffset: 0!

asUIntPtr
	"Answer the receiver in a form suitable for passing or returning 
	as a  machine-word sized (32 or 64-bit) value."

	"Implementation Note: The compiler will optimise out the condition because it is constant."

	^VMConstants.IsWin64 ifTrue: [self asPoint asUIntPtr] ifFalse: [bytes dwordAtOffset: 0]!

x
	"Answer the receiver's x field as a Smalltalk object."

	^bytes swordAtOffset: 0!

x: anObject 
	"Set the receiver's x field to the value of anObject."

	bytes swordAtOffset: 0 put: anObject!

y
	"Answer the receiver's y field as a Smalltalk object."

	^bytes swordAtOffset: ##(self offsetOf: #y)!

y: anObject 
	"Set the receiver's y field to the value of anObject."

	bytes swordAtOffset: ##(self offsetOf: #y) put: anObject! !
!POINTS categoriesFor: #asDword!converting!public! !
!POINTS categoriesFor: #asUIntPtr!converting!public! !
!POINTS categoriesFor: #x!**compiled accessors**!public! !
!POINTS categoriesFor: #x:!**compiled accessors**!public! !
!POINTS categoriesFor: #y!**compiled accessors**!public! !
!POINTS categoriesFor: #y:!**compiled accessors**!public! !

!POINTS class methodsFor!

defineFields
	"Define the fields of the POINTS structure.

	POINTS  compileDefinition

		typedef [uuid(3278B910-3376-47E3-BE99-02AFE78A6230)]
		struct tagPOINTS {
			short x;
			short y;
		} POINTS;
"

	self
		defineField: #x type: SWORDField new beOverride;
		defineField: #y type: SWORDField new beOverride!

x: x y: y 
	^self basicNew bytes: ((ByteArray newFixed: 4)
				swordAtOffset: 0 put: x;
				swordAtOffset: 2 put: y;
				yourself)! !
!POINTS class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!POINTS class categoriesFor: #x:y:!instance creation!public! !

