"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TOOLINFOW
	instanceVariableNames: 'text'
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_hinst _OffsetOf_hwnd _OffsetOf_lParam _OffsetOf_lpReserved _OffsetOf_lpszText _OffsetOf_rect _OffsetOf_uFlags _OffsetOf_uId'
	poolDictionaries: 'TooltipConstants'
	classInstanceVariableNames: ''!
TOOLINFOW guid: (GUID fromString: '{87b4c617-026e-11d3-9fd7-00a0cc3e4a32}')!
TOOLINFOW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
TOOLINFOW addClassConstant: '_OffsetOf_hinst' value: 16r20!
TOOLINFOW addClassConstant: '_OffsetOf_hwnd' value: 16r8!
TOOLINFOW addClassConstant: '_OffsetOf_lParam' value: 16r28!
TOOLINFOW addClassConstant: '_OffsetOf_lpReserved' value: 16r2C!
TOOLINFOW addClassConstant: '_OffsetOf_lpszText' value: 16r24!
TOOLINFOW addClassConstant: '_OffsetOf_rect' value: 16r10!
TOOLINFOW addClassConstant: '_OffsetOf_uFlags' value: 16r4!
TOOLINFOW addClassConstant: '_OffsetOf_uId' value: 16rC!
TOOLINFOW comment: 'TOOLINFOA is an <ExternalStructure> class to represent the Win32 structure of the same name.

This structure is used in conjunction with the tooltips.

Instance Variables:
	text	<String>. Used to maintain a reference to the tip text string to prevent its premature GC.

'!
!TOOLINFOW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TOOLINFOW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hinst
	"Answer the <ExternalHandle> value of the receiver's 'hinst' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hinst) asExternalHandle!

hwnd
	"Answer the <ExternalHandle> value of the receiver's 'hwnd' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwnd) asExternalHandle!

hwnd: anExternalHandle
	"Set the receiver's 'hwnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: anExternalHandle!

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
	flags printOn: aStream base: 16 showRadix: true.
	aStream
		nextPutAll: ', hwnd=';
		print: (View fromHandle: self hwnd);
		nextPutAll: ', tool='.
	(flags allMask: TTF_IDISHWND) 
		ifFalse: 
			[aStream
				print: self uId;
				nextPutAll: ', rect=';
				display: self rect]
		ifTrue: [aStream print: (View fromHandle: self uId)].
	aStream nextPut: $)!

rect
	"Answer the <RECT> value of the receiver's 'rect' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rect!

rect: aRECT
	"Set the receiver's 'rect' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rect + 1)
		to: ##(_OffsetOf_rect + RECT basicByteSize)
		startingAt: 1!

text: aString
	"Set the tool-tip text of the receiver to the <String> argument."

	"Implementation Note: We must retain a reference to the String to ensure it is not
	garbage collect, so we store it into the 'text' inst var maintained for that purpose."

	text := aString asUtf16String.
	self lpszText: text!

textCallback
	"Sets this item into callback mode for the item text."

	self lpszText: LPSTR_TEXTCALLBACK
!

uFlags
	"Answer the <Integer> value of the receiver's 'uFlags' field."

	^bytes dwordAtOffset: _OffsetOf_uFlags!

uFlags: anInteger
	"Set the receiver's 'uFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_uFlags put: anInteger!

uId
	"Answer the <Integer> value of the receiver's 'uId' field."

	^bytes uintPtrAtOffset: _OffsetOf_uId!

uId: anInteger
	"Set the receiver's 'uId' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_uId put: anInteger! !
!TOOLINFOW categoriesForMethods!
dwSize:!**compiled accessors**!public! !
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

!TOOLINFOW class methodsFor!

defineFields
	"Define the fields of the TOOLINFO structure.
		self compileDefinition
	
		typedef 		struct tagTOOLINFOW {
			unsigned int cbSize;
			unsigned int uFlags;
			unsigned long hwnd;
			UINT_PTR uId;
			RECT rect;
			HINSTANCE hinst;
			LPWSTR lpszText;
			LPARAM lParam;
			void* lpReserved;
		} TOOLINFOW;
"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #uFlags type: DWORDField new;
		defineField: #hwnd type: HANDLEField new;
		defineField: #uId type: UINT_PTRField new;
		defineField: #rect type: (StructureField type: RECT);
		defineField: #hinst type: HANDLEField readOnly;
		defineField: #lpszText type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lParam type: INT_PTRField readOnly;
		defineField: #lpReserved type: LPVOIDField filler!

getFieldNames
	^#(#dwSize #uFlags #hwnd #uId #rect #hinst #lpszText #lParam)! !
!TOOLINFOW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

