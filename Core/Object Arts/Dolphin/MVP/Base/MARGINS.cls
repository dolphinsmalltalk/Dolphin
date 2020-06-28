"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MARGINS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cxLeftWidth' -> 16r0.
		'_OffsetOf_cxRightWidth' -> 16r4.
		'_OffsetOf_cyBottomHeight' -> 16rC.
		'_OffsetOf_cyTopHeight' -> 16r8
	}!
MARGINS guid: (GUID fromString: '{d92a9b7d-a1dc-4ef4-97e5-869e7a720a83}')!
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
	"Answer the <Integer> value of the receiver's 'cxLeftWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_cxLeftWidth!

cxLeftWidth: anInteger
	"Set the receiver's 'cxLeftWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxLeftWidth put: anInteger!

cxRightWidth
	"Answer the <Integer> value of the receiver's 'cxRightWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_cxRightWidth!

cxRightWidth: anInteger
	"Set the receiver's 'cxRightWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cxRightWidth put: anInteger!

cyBottomHeight
	"Answer the <Integer> value of the receiver's 'cyBottomHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_cyBottomHeight!

cyBottomHeight: anInteger
	"Set the receiver's 'cyBottomHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyBottomHeight put: anInteger!

cyTopHeight
	"Answer the <Integer> value of the receiver's 'cyTopHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_cyTopHeight!

cyTopHeight: anInteger
	"Set the receiver's 'cyTopHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cyTopHeight put: anInteger! !
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
		defineField: #cyBottomHeight type: SDWORDField new!

getFieldNames
	^#(#cxLeftWidth #cxRightWidth #cyTopHeight #cyBottomHeight)! !
!MARGINS class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!MARGINS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

