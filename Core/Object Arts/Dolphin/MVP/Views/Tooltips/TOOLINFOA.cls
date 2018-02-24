"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TOOLINFOA
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: 'TooltipConstants'
	classInstanceVariableNames: ''!
TOOLINFOA guid: (GUID fromString: '{87b4c617-026e-11d3-9fd7-00a0cc3e4a32}')!
TOOLINFOA comment: 'TOOLINFOA is an <ExternalStructure> class to represent the Win32 structure of the same name.

This structure is used in conjunction with the tooltips.

Instance Variables:
	text	<String>. Used to maintain a reference to the tip text string to prevent its premature GC.

'!
!TOOLINFOA categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TOOLINFOA methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

hinst
	"Answer the receiver's hinst field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hinst)) asExternalHandle!

hwnd
	"Answer the receiver's hwnd field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwnd)) asExternalHandle!

hwnd: anObject 
	"Set the receiver's hwnd field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwnd) put: anObject!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes intPtrAtOffset: ##(self offsetOf: #lParam)!

lpszText: anObject 
	"Set the receiver's lpszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszText) put: anObject yourAddress!

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
	"Answer the receiver's rect field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rect)!

rect: anObject 
	"Set the receiver's rect field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rect) + 1)
		to: ##((self offsetOf: #rect) + RECT basicByteSize)
		startingAt: 1!

text: aString
	"Set the tool-tip text of the receiver to the <String> argument."

	"Implementation Note: We must retain a reference to the String to ensure it is not
	garbage collect, so we store it into the 'text' inst var maintained for that purpose."

	text := aString asAnsiString.
	self lpszText: aString!

textCallback
	"Sets this item into callback mode for the item text."

	self lpszText: LPSTR_TEXTCALLBACK
!

uFlags
	"Answer the receiver's uFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)!

uFlags: anObject 
	"Set the receiver's uFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #uFlags) put: anObject!

uId
	"Answer the receiver's uId field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #uId)!

uId: anObject 
	"Set the receiver's uId field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #uId) put: anObject! !
!TOOLINFOA categoriesFor: #dwSize:!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #hinst!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #hwnd!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #hwnd:!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #lParam!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #lpszText:!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #printOn:!development!printing!public! !
!TOOLINFOA categoriesFor: #rect!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #rect:!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #text:!accessing!public! !
!TOOLINFOA categoriesFor: #textCallback!accessing!public! !
!TOOLINFOA categoriesFor: #uFlags!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #uFlags:!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #uId!**compiled accessors**!public! !
!TOOLINFOA categoriesFor: #uId:!**compiled accessors**!public! !

!TOOLINFOA class methodsFor!

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
		defineField: #lpszText type: (PointerField type: String) beWriteOnly;
		defineField: #lParam type: INT_PTRField readOnly;
		defineField: #lpReserved type: LPVOIDField filler! !
!TOOLINFOA class categoriesFor: #defineFields!initializing!public! !

