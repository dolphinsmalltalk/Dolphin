"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.TBMETRICS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ToolbarConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cxBarPad' -> 16r10.
			'_OffsetOf_cxButtonSpacing' -> 16r18.
			'_OffsetOf_cxPad' -> 16r8.
			'_OffsetOf_cyBarPad' -> 16r14.
			'_OffsetOf_cyButtonSpacing' -> 16r1C.
			'_OffsetOf_cyPad' -> 16rC.
			'_OffsetOf_dwMask' -> 16r4.
			'_TBMETRICS_Size' -> 16r20
		}!

OS.TBMETRICS guid: (Core.GUID fromString: '{b296885b-f712-4cd1-8e2d-ed9f6e347004}')!

OS.TBMETRICS comment: '`OS.TBMETRICS` is an `ExternalStructure` class to wrap the struct ''Win32.OS.TBMETRICS'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(b296885b-f712-4cd1-8e2d-ed9f6e347004)]
struct tagOS.TBMETRICS {
	unsigned int cbSize;
	DWORD dwMask;
	int cxPad;
	int cyPad;
	int cxBarPad;
	int cyBarPad;
	int cxButtonSpacing;
	int cyButtonSpacing;
} OS.TBMETRICS;
```
'!

!OS.TBMETRICS categoriesForClass!Win32-Structs! !

!OS.TBMETRICS methodsFor!

buttonSpacing
	^self cxButtonSpacing @ self cyButtonSpacing!

buttonSpacing: aPoint
	self
		cxButtonSpacing: aPoint x;
		cyButtonSpacing: aPoint y;
		dwMask: (self dwMask bitOr: TBMF_BUTTONSPACING)!

cxButtonSpacing
	"Answer the <Integer> value of the receiver's 'cxButtonSpacing' field."

	^bytes int32AtOffset: _OffsetOf_cxButtonSpacing!

cxButtonSpacing: anInteger
	"Set the receiver's 'cxButtonSpacing' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxButtonSpacing put: anInteger!

cxPad
	"Answer the <Integer> value of the receiver's 'cxPad' field."

	^bytes int32AtOffset: _OffsetOf_cxPad!

cxPad: anInteger
	"Set the receiver's 'cxPad' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cxPad put: anInteger!

cyButtonSpacing
	"Answer the <Integer> value of the receiver's 'cyButtonSpacing' field."

	^bytes int32AtOffset: _OffsetOf_cyButtonSpacing!

cyButtonSpacing: anInteger
	"Set the receiver's 'cyButtonSpacing' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cyButtonSpacing put: anInteger!

cyPad
	"Answer the <Integer> value of the receiver's 'cyPad' field."

	^bytes int32AtOffset: _OffsetOf_cyPad!

cyPad: anInteger
	"Set the receiver's 'cyPad' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_cyPad put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMask put: anInteger!

padding: aPoint
	self
		cxPad: aPoint x;
		cyPad: aPoint y;
		dwMask: (self dwMask bitOr: TBMF_PAD)! !

!OS.TBMETRICS categoriesForMethods!
buttonSpacing!accessing!public! !
buttonSpacing:!accessing!public! !
cxButtonSpacing!**compiled accessors**!public! !
cxButtonSpacing:!**compiled accessors**!public! !
cxPad!**compiled accessors**!public! !
cxPad:!**compiled accessors**!public! !
cyButtonSpacing!**compiled accessors**!public! !
cyButtonSpacing:!**compiled accessors**!public! !
cyPad!**compiled accessors**!public! !
cyPad:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
padding:!accessing!public! !
!

!OS.TBMETRICS class methodsFor!

byteSize
	^_TBMETRICS_Size!

defineFields
	"Define the fields of the OS.TBMETRICS structure.

	OS.TBMETRICS compileDefinition

		typedef [uuid(b296885b-f712-4cd1-8e2d-ed9f6e347004)]
		struct tagOS.TBMETRICS {
			unsigned int cbSize;
			DWORD dwMask;
			int cxPad;
			int cyPad;
			int cxBarPad;
			int cyBarPad;
			int cxButtonSpacing;
			int cyButtonSpacing;
		} OS.TBMETRICS;
"


	super defineFields.
	self
		defineField: #dwMask type: UInt32Field new offset: 4;
		defineField: #cxPad type: Int32Field new offset: 8;
		defineField: #cyPad type: Int32Field new offset: 12;
		defineField: #cxBarPad type: Int32Field uncompiled offset: 16;
		defineField: #cyBarPad type: Int32Field uncompiled offset: 20;
		defineField: #cxButtonSpacing type: Int32Field new offset: 24;
		defineField: #cyButtonSpacing type: Int32Field new offset: 28.
	self byteSize: 32!

getFieldNames
	^#(#dwSize #dwMask #cxPad #cyPad #cxBarPad #cyBarPad #cxButtonSpacing #cyButtonSpacing)! !

!OS.TBMETRICS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

