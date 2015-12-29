"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #WNDCLASS
	instanceVariableNames: 'menuName className'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WNDCLASS guid: (GUID fromString: '{87B4C61C-026E-11D3-9FD7-00A0CC3E4A32}')!
WNDCLASS comment: 'WNDCLASS is the class of <ExternalStructure> which represent the Windows structure of the same name. It is used to retrieve and specify Windows "Class" information, e.g. when registering a window class.
'!
!WNDCLASS categoriesForClass!External-Data-Structured-Win32! !
!WNDCLASS methodsFor!

className: aString
	"Set the receiver's className and lpszClassName fields to aString.
	Use this method to ensure the class name is not garbage collected
	while the receiver is alive"

	className := aString.
	self lpszClassName: aString!

hbrBackground: anObject 
	"Set the receiver's hbrBackground field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hbrBackground) put: anObject!

hCursor: anObject 
	"Set the receiver's hCursor field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hCursor) put: anObject!

hIcon: anObject 
	"Set the receiver's hIcon field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hIcon) put: anObject!

hInstance: anObject 
	"Set the receiver's hInstance field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #hInstance) put: anObject!

lpfnWndProc: anObject 
	"Set the receiver's lpfnWndProc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lpfnWndProc) put: anObject!

lpszClassName: anObject 
	"Set the receiver's lpszClassName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszClassName) put: anObject yourAddress!

lpszMenuName: anObject 
	"Set the receiver's lpszMenuName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszMenuName) put: anObject yourAddress!

menuName: aString
	"Set the receiver's menuName and lpszMenuName fields to aString.
	Use this method to ensure the menu name is not garbage collected
	while the receiver is alive"

	menuName := aString.
	self lpszMenuName: aString!

style: anObject 
	"Set the receiver's style field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!WNDCLASS categoriesFor: #className:!accessing!public! !
!WNDCLASS categoriesFor: #hbrBackground:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hCursor:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hIcon:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #hInstance:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpfnWndProc:!**compiled accessors**!public! !
!WNDCLASS categoriesFor: #lpszClassName:!**compiled accessors**!public! !
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
			int		cbClsExtra; 
			int		cbWndExtra; 
			HANDLE	hInstance; 
			HICON	hIcon; 
			HCURSOR	hCursor; 
			HBRUSH	hbrBackground; 
			LPCTSTR	lpszMenuName; 
			LPCTSTR	lpszClassName; 
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
		defineField: #lpszMenuName type: (PointerField type: String) beWriteOnly;
		defineField: #lpszClassName type: (PointerField type: String) beWriteOnly! !
!WNDCLASS class categoriesFor: #defineFields!initializing!public! !

