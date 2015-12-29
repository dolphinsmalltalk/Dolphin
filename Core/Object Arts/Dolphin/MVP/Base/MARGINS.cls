"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #MARGINS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MARGINS guid: (GUID fromString: '{D92A9B7D-A1DC-4EF4-97E5-869E7A720A83}')!
MARGINS comment: '<MARGINS> is an <ExternalStructure> class to wrap the struct ''Win32.MARGINS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Defines the margins of windows that have visual styles applied."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D92A9B7D-A1DC-4EF4-97E5-869E7A720A83), helpstring("Defines the margins of windows that have visual styles applied.")]
struct tagMARGINS {
	[helpstring("Width of left border that retains its size")] int cxLeftWidth;
	[helpstring("Width of right border that retains its size")] int cxRightWidth;
	[helpstring("Height of top border that retains its size")] int cyTopHeight;
	[helpstring("Height of bottom border that retains its size")] int cyBottomHeight;
} MARGINS;
'!
!MARGINS categoriesForClass!Win32-Structs! !
!MARGINS methodsFor!

cxLeftWidth
	"Answer the receiver's cxLeftWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

cxLeftWidth: anObject 
	"Set the receiver's cxLeftWidth field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

cxRightWidth
	"Answer the receiver's cxRightWidth field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cxRightWidth)!

cxRightWidth: anObject 
	"Set the receiver's cxRightWidth field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cxRightWidth) put: anObject!

cyBottomHeight
	"Answer the receiver's cyBottomHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cyBottomHeight)!

cyBottomHeight: anObject 
	"Set the receiver's cyBottomHeight field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cyBottomHeight) put: anObject!

cyTopHeight
	"Answer the receiver's cyTopHeight field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cyTopHeight)!

cyTopHeight: anObject 
	"Set the receiver's cyTopHeight field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #cyTopHeight) put: anObject! !
!MARGINS categoriesFor: #cxLeftWidth!**compiled accessors**!public! !
!MARGINS categoriesFor: #cxLeftWidth:!**compiled accessors**!public! !
!MARGINS categoriesFor: #cxRightWidth!**compiled accessors**!public! !
!MARGINS categoriesFor: #cxRightWidth:!**compiled accessors**!public! !
!MARGINS categoriesFor: #cyBottomHeight!**compiled accessors**!public! !
!MARGINS categoriesFor: #cyBottomHeight:!**compiled accessors**!public! !
!MARGINS categoriesFor: #cyTopHeight!**compiled accessors**!public! !
!MARGINS categoriesFor: #cyTopHeight:!**compiled accessors**!public! !

!MARGINS class methodsFor!

defineFields
	"Define the fields of the MARGINS structure.
		MARGINS compileDefinition
	
		typedef [uuid(D92A9B7D-A1DC-4EF4-97E5-869E7A720A83), helpstring('Defines the margins of windows that have visual styles applied.')]
		struct tagMARGINS {
			[helpstring('Width of left border that retains its size')] int cxLeftWidth;
			[helpstring('Width of right border that retains its size')] int cxRightWidth;
			[helpstring('Height of top border that retains its size')] int cyTopHeight;
			[helpstring('Height of bottom border that retains its size')] int cyBottomHeight;
		} MARGINS;
"

	self
		defineField: #cxLeftWidth type: SDWORDField new;
		defineField: #cxRightWidth type: SDWORDField new;
		defineField: #cyTopHeight type: SDWORDField new;
		defineField: #cyBottomHeight type: SDWORDField new! !
!MARGINS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

