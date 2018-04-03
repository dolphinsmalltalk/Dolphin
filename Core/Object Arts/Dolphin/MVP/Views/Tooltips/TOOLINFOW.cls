"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TOOLINFOW
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: 'TooltipConstants'
	classInstanceVariableNames: ''!
TOOLINFOW guid: (GUID fromString: '{87b4c617-026e-11d3-9fd7-00a0cc3e4a32}')!
TOOLINFOW comment: 'TOOLINFOA is an <ExternalStructure> class to represent the Win32 structure of the same name.

This structure is used in conjunction with the tooltips.

Instance Variables:
	text	<String>. Used to maintain a reference to the tip text string to prevent its premature GC.

'!
!TOOLINFOW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TOOLINFOW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

hinst
	"Answer the <ExternalHandle> value of the receiver's 'hinst' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hinst)) asExternalHandle!

hwnd
	"Answer the <ExternalHandle> value of the receiver's 'hwnd' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwnd)) asExternalHandle!

hwnd: anExternalHandle
	"Set the receiver's 'hwnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hwnd) put: anExternalHandle!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes intPtrAtOffset: ##(self offsetOf: #lParam)!

lpszText: anUtf16String
	"Set the receiver's 'lpszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszText) put: anUtf16String yourAddress!

printOn: aStream 
	"Append a debugging representation of the receiver to aStream."

	| flags |
	aStream
		basicPrint: self;
		nextPutAll: '(uFlags='.
	flags := self uFlags.
	flags printOn: aStream base: 16.
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

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rect)!

rect: aRECT
	"Set the receiver's 'rect' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rect) + 1)
		to: ##((self offsetOf: #rect) + RECT basicByteSize)
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

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)!

uFlags: anInteger
	"Set the receiver's 'uFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #uFlags) put: anInteger!

uId
	"Answer the <Integer> value of the receiver's 'uId' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #uId)!

uId: anInteger
	"Set the receiver's 'uId' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: ##(self offsetOf: #uId) put: anInteger! !
!TOOLINFOW categoriesFor: #dwSize:!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #hinst!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #hwnd!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #hwnd:!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #lParam!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #lpszText:!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #printOn:!development!printing!public! !
!TOOLINFOW categoriesFor: #rect!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #rect:!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #text:!accessing!public! !
!TOOLINFOW categoriesFor: #textCallback!accessing!public! !
!TOOLINFOW categoriesFor: #uFlags!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #uFlags:!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #uId!**compiled accessors**!public! !
!TOOLINFOW categoriesFor: #uId:!**compiled accessors**!public! !

!TOOLINFOW class methodsFor!

defineFields
	"Define the fields of the TOOLINFOA structure.
		TOOLINFOA compileDefinition
	
		typedef 		struct tagTOOLINFOA {
			unsigned int cbSize;
			unsigned int uFlags;
			unsigned long hwnd;
			UINT_PTR uId;
			RECT rect;
			HINSTANCE hinst;
			LPSTR lpszText;
			LPARAM lParam;
			void* lpReserved;
		} TOOLINFOA;
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
		defineField: #lpReserved type: LPVOIDField filler! !
!TOOLINFOW class categoriesFor: #defineFields!initializing!public! !

