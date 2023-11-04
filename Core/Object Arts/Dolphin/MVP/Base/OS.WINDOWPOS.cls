"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.WINDOWPOS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cx' -> 16r10.
			'_OffsetOf_cy' -> 16r14.
			'_OffsetOf_flags' -> 16r18.
			'_OffsetOf_hwnd' -> 16r0.
			'_OffsetOf_hwndInsertAfter' -> 16r4.
			'_OffsetOf_x' -> 16r8.
			'_OffsetOf_y' -> 16rC.
			'_WINDOWPOS_Size' -> 16r1C
		}!
OS.WINDOWPOS guid: (Core.GUID fromString: '{cd69a071-3606-11d3-93bd-00a024ca708a}')!
OS.WINDOWPOS comment: ''!
!OS.WINDOWPOS categoriesForClass!External-Data-Structured-Win32! !
!OS.WINDOWPOS methodsFor!

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

extent
	^Graphics.Point x: (bytes int32AtOffset: _OffsetOf_cx) y: (bytes int32AtOffset: _OffsetOf_cy)!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

hwndInsertAfter
	"Answer the <Integer> value of the receiver's 'hwndInsertAfter' field."

	^bytes uint32AtOffset: _OffsetOf_hwndInsertAfter!

isRectangleChanged
	^(self flags allMask: ##(Win32Constants.SWP_NOMOVE bitOr: Win32Constants.SWP_NOSIZE)) not!

position
	^self x @ self y!

rectangle
	^self position extent: self extent!

x
	"Answer the <Integer> value of the receiver's 'x' field."

	^bytes int32AtOffset: _OffsetOf_x!

y
	"Answer the <Integer> value of the receiver's 'y' field."

	^bytes int32AtOffset: _OffsetOf_y! !
!OS.WINDOWPOS categoriesForMethods!
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
cy!**compiled accessors**!public! !
cy:!**compiled accessors**!public! !
extent!accessing!public! !
flags!**compiled accessors**!public! !
hwndInsertAfter!**compiled accessors**!public! !
isRectangleChanged!public!testing! !
position!accessing!public! !
rectangle!accessing!public! !
x!**compiled accessors**!public! !
y!**compiled accessors**!public! !
!

!OS.WINDOWPOS class methodsFor!

byteSize
	^_WINDOWPOS_Size!

defineFields
	"Define the layout of the Win32 WINDOWPOS structure.

		WINDOWPOS compileDefinition

		typedef struct _WINDOWPOS {
			HWND hwnd;
			HWND hwndInsertAfter;
			int x;
			int y;
			int cx;
			int cy;
			UINT flags; } WINDOWPOS; 
	"

	self
		defineField: #hwnd type: UInt32Field filler;
		defineField: #hwndInsertAfter type: UInt32Field readOnly;
		defineField: #x type: Int32Field readOnly;
		defineField: #y type: Int32Field readOnly;
		defineField: #cx type: Int32Field new;
		defineField: #cy type: Int32Field new;
		defineField: #flags type: UInt32Field readOnly!

getFieldNames
	^#(#hwndInsertAfter #x #y #cx #cy #flags)! !
!OS.WINDOWPOS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

