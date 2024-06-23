"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.TOOLINFOW'
	instanceVariableNames: 'text'
	classVariableNames: ''
	imports: #(#{OS.TooltipConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hinst' -> 16r20.
			'_OffsetOf_hwnd' -> 16r8.
			'_OffsetOf_lParam' -> 16r28.
			'_OffsetOf_lpReserved' -> 16r2C.
			'_OffsetOf_lpszText' -> 16r24.
			'_OffsetOf_rect' -> 16r10.
			'_OffsetOf_uFlags' -> 16r4.
			'_OffsetOf_uId' -> 16rC.
			'_TOOLINFOW_Size' -> 16r30
		}!

OS.TOOLINFOW guid: (Core.GUID fromString: '{87b4c617-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.TOOLINFOW comment: 'TOOLINFOW is an <ExternalStructure> class to represent the Win32 structure of the same name.

This structure is used in conjunction with the tooltips.

Instance Variables:
	text	<String>. Used to maintain a reference to the tip text string to prevent its premature GC.

'!

!OS.TOOLINFOW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !

!OS.TOOLINFOW methodsFor!

hinst
	"Answer the <Handle> value of the receiver's 'hinst' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hinst) asExternalHandle!

hwnd
	"Answer the <Handle> value of the receiver's 'hwnd' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwnd) asExternalHandle!

hwnd: aHandle
	"Set the receiver's 'hwnd' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: aHandle!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: _OffsetOf_lParam!

lpszText: anUtf16String
	"Set the receiver's 'lpszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszText put: anUtf16String yourAddress!

printOn: aStream
	"Append a debugging representation of the receiver to aStream."

	| flags |
	aStream
		basicPrint: self;
		nextPutAll: '(uFlags='.
	flags := self uFlags.
	flags
		printOn: aStream
		base: 16
		showRadix: true.
	aStream
		nextPutAll: ', hwnd=';
		print: (UI.View fromHandle: self hwnd);
		nextPutAll: ', tool='.
	(flags allMask: TTF_IDISHWND)
		ifFalse: 
			[aStream
				print: self uId;
				nextPutAll: ', rect=';
				display: self rect]
		ifTrue: [aStream print: (UI.View fromHandle: self uId)].
	aStream nextPut: $)!

rect
	"Answer the <RECTL> value of the receiver's 'rect' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rect!

rect: aRECTL
	"Set the receiver's 'rect' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rect + 1)
		to: ##(_OffsetOf_rect + RECTL._RECTL_Size)
		startingAt: 1!

text: aString
	"Set the tool-tip text of the receiver to the <String> argument."

	"Implementation Note: We must retain a reference to the String to ensure it is not
	garbage collected, so we store it into the 'text' inst var maintained for that purpose."

	text := aString asUtf16String.
	self lpszText: text!

textCallback
	"Sets this item into callback mode for the item text."

	self lpszText: LPSTR_TEXTCALLBACK
!

uFlags
	"Answer the <Integer> value of the receiver's 'uFlags' field."

	^bytes uint32AtOffset: _OffsetOf_uFlags!

uFlags: anInteger
	"Set the receiver's 'uFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_uFlags put: anInteger!

uId
	"Answer the <Integer> value of the receiver's 'uId' field."

	^bytes uintPtrAtOffset: _OffsetOf_uId!

uId: anInteger
	"Set the receiver's 'uId' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_uId put: anInteger! !

!OS.TOOLINFOW categoriesForMethods!
hinst!**compiled accessors**!public! !
hwnd!**compiled accessors**!public! !
hwnd:!**compiled accessors**!public! !
lParam!**compiled accessors**!public! !
lpszText:!**compiled accessors**!public! !
printOn:!development!printing!public! !
rect!**compiled accessors**!public! !
rect:!**compiled accessors**!public! !
text:!accessing!public! !
textCallback!accessing!public! !
uFlags!**compiled accessors**!public! !
uFlags:!**compiled accessors**!public! !
uId!**compiled accessors**!public! !
uId:!**compiled accessors**!public! !
!

!OS.TOOLINFOW class methodsFor!

byteSize
	^_TOOLINFOW_Size!

defineFields
	"Define the fields of the TOOLINFOW structure.
		self compileDefinition
	
		typedef 		struct tagTOOLINFOW {
			unsigned int cbSize;
			unsigned int uFlags;
			unsigned long hwnd;
			UINT_PTR uId;
			RECTL rect;
			HINSTANCE hinst;
			LPWSTR lpszText;
			LPARAM lParam;
			void* lpReserved;
		} TOOLINFOW;
"

	super defineFields.
	self
		defineField: #uFlags type: UInt32Field new;
		defineField: #hwnd type: HANDLEField new;
		defineField: #uId type: UIntPtrField new;
		defineField: #rect type: (StructureField type: RECTL);
		defineField: #hinst type: HANDLEField readOnly;
		defineField: #lpszText type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lParam type: IntPtrField readOnly;
		defineField: #lpReserved type: LPVOIDField filler!

getFieldNames
	^#(#dwSize #uFlags #hwnd #uId #rect #hinst #lpszText #lParam)! !

!OS.TOOLINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

