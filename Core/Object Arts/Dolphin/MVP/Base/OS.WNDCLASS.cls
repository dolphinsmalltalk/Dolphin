"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WNDCLASS
	instanceVariableNames: 'menuName className'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbClsExtra' -> 16r8.
		'_OffsetOf_cbWndExtra' -> 16rC.
		'_OffsetOf_hbrBackground' -> 16r1C.
		'_OffsetOf_hCursor' -> 16r18.
		'_OffsetOf_hIcon' -> 16r14.
		'_OffsetOf_hInstance' -> 16r10.
		'_OffsetOf_lpfnWndProc' -> 16r4.
		'_OffsetOf_lpszClassName' -> 16r24.
		'_OffsetOf_lpszMenuName' -> 16r20.
		'_OffsetOf_style' -> 16r0
	}!
WNDCLASS guid: (GUID fromString: '{87b4c61c-026e-11d3-9fd7-00a0cc3e4a32}')!
WNDCLASS comment: 'WNDCLASS is the class of <ExternalStructure> which represent the Windows structure of the same name. It is used to retrieve and specify Windows "Class" information, e.g. when registering a window class.
'!
!WNDCLASS categoriesForClass!External-Data-Structured-Win32! !
!WNDCLASS methodsFor!

className: aString
	"Set the receiver's className and lpszClassName fields to aString.
	Use this method to ensure the class name is not garbage collected
	while the receiver is alive"

	className := aString asUtf16String.
	self lpszClassName: className!

hbrBackground: anInteger
	"Set the receiver's 'hbrBackground' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hbrBackground put: anInteger!

hCursor: anInteger
	"Set the receiver's 'hCursor' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hCursor put: anInteger!

hIcon: anInteger
	"Set the receiver's 'hIcon' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hIcon put: anInteger!

hInstance: anInteger
	"Set the receiver's 'hInstance' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hInstance put: anInteger!

lpfnWndProc: anInteger
	"Set the receiver's 'lpfnWndProc' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lpfnWndProc put: anInteger!

lpszClassName
	"Answer the <Utf16String> value of the receiver's 'lpszClassName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszClassName)!

lpszClassName: anUtf16String
	"Set the receiver's 'lpszClassName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszClassName put: anUtf16String yourAddress!

lpszMenuName
	"Answer the <Utf16String> value of the receiver's 'lpszMenuName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszMenuName)!

lpszMenuName: anUtf16String
	"Set the receiver's 'lpszMenuName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszMenuName put: anUtf16String yourAddress!

menuName: aString
	"Set the receiver's menuName and lpszMenuName fields to aString.
	Use this method to ensure the menu name is not garbage collected
	while the receiver is alive"

	menuName := aString asUtf16String.
	self lpszMenuName: menuName!

style: anInteger
	"Set the receiver's 'style' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_style put: anInteger! !
!WNDCLASS categoriesFor: #className:!accessing!public! !
!WNDCLASS categoriesFor: #hbrBackground:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hCursor:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hIcon:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hInstance:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpfnWndProc:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpszClassName!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpszClassName:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpszMenuName!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpszMenuName:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #menuName:!accessing!public! !
!WNDCLASS categoriesFor: #style:!**compiled accessors**!public! !

!WNDCLASS class methodsFor!

defineFields
	"Define the layout of the Win32 WNDCLASS structure. Currently to avoid
	wasting space, the structure is set up for registering classes only
	(i.e. the fields are fillers or write only). Furthermore it is not
	compiled at present.

	WNDCLASS compileDefinition

		typedef struct _WNDCLASS {
			UINT		style; 
			WNDPROC	lpfnWndProc; 
			int			cbClsExtra; 
			int			cbWndExtra; 
			HINSTANCE	hInstance; 
			HICON		hIcon; 
			HCURSOR	hCursor; 
			HBRUSH	hbrBackground; 
			LPCWSTR	lpszMenuName; 
			LPCWSTR	lpszClassName; 
		} WNDCLASS; "

	self 
		defineField: #style type: DWORDField writeOnly;
		defineField: #lpfnWndProc type: DWORDField writeOnly;
		defineField: #cbClsExtra type: SDWORDField filler;
		defineField: #cbWndExtra type: SDWORDField filler;
		defineField: #hInstance type: DWORDField writeOnly;
		defineField: #hIcon type: DWORDField writeOnly;
		defineField: #hCursor type: DWORDField writeOnly;
		defineField: #hbrBackground type: DWORDField writeOnly;
		defineField: #lpszMenuName type: (PointerField type: Utf16String);
		defineField: #lpszClassName type: (PointerField type: Utf16String)!

getFieldNames
	^#(#style #lpfnWndProc #hInstance #hIcon #hCursor #hbrBackground #lpszMenuName #lpszClassName)! !
!WNDCLASS class categoriesFor: #defineFields!public!template definition! !
!WNDCLASS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

