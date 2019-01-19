"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #STARTUPINFOW
	instanceVariableNames: 'title desktop stdin stdout stderr'
	classVariableNames: '_OffsetOf_cbReserved2 _OffsetOf_dwFillAttribute _OffsetOf_dwFlags _OffsetOf_dwSize _OffsetOf_dwX _OffsetOf_dwXCountChars _OffsetOf_dwXSize _OffsetOf_dwY _OffsetOf_dwYCountChars _OffsetOf_dwYSize _OffsetOf_hStdError _OffsetOf_hStdInput _OffsetOf_hStdOutput _OffsetOf_lpDesktop _OffsetOf_lpReserved _OffsetOf_lpReserved2 _OffsetOf_lpTitle _OffsetOf_wShowWindow'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STARTUPINFOW guid: (GUID fromString: '{f44c9146-2b3f-11d3-8368-7a8b5a000000}')!
STARTUPINFOW addClassConstant: '_OffsetOf_cbReserved2' value: 16r32!
STARTUPINFOW addClassConstant: '_OffsetOf_dwFillAttribute' value: 16r28!
STARTUPINFOW addClassConstant: '_OffsetOf_dwFlags' value: 16r2C!
STARTUPINFOW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
STARTUPINFOW addClassConstant: '_OffsetOf_dwX' value: 16r10!
STARTUPINFOW addClassConstant: '_OffsetOf_dwXCountChars' value: 16r20!
STARTUPINFOW addClassConstant: '_OffsetOf_dwXSize' value: 16r18!
STARTUPINFOW addClassConstant: '_OffsetOf_dwY' value: 16r14!
STARTUPINFOW addClassConstant: '_OffsetOf_dwYCountChars' value: 16r24!
STARTUPINFOW addClassConstant: '_OffsetOf_dwYSize' value: 16r1C!
STARTUPINFOW addClassConstant: '_OffsetOf_hStdError' value: 16r40!
STARTUPINFOW addClassConstant: '_OffsetOf_hStdInput' value: 16r38!
STARTUPINFOW addClassConstant: '_OffsetOf_hStdOutput' value: 16r3C!
STARTUPINFOW addClassConstant: '_OffsetOf_lpDesktop' value: 16r8!
STARTUPINFOW addClassConstant: '_OffsetOf_lpReserved' value: 16r4!
STARTUPINFOW addClassConstant: '_OffsetOf_lpReserved2' value: 16r34!
STARTUPINFOW addClassConstant: '_OffsetOf_lpTitle' value: 16rC!
STARTUPINFOW addClassConstant: '_OffsetOf_wShowWindow' value: 16r30!
STARTUPINFOW comment: ''!
!STARTUPINFOW categoriesForClass!External-Data-Structured-Win32! !
!STARTUPINFOW methodsFor!

desktop: aString
	"Set the desktop identifier for the receiver to aString. We store down the String
	in an instance variable to prevent it being GC'd"

	desktop := aString asUtf16String.
	self lpDesktop: aString!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwX
	"Answer the <Integer> value of the receiver's 'dwX' field."

	^bytes dwordAtOffset: _OffsetOf_dwX!

dwX: anInteger
	"Set the receiver's 'dwX' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwX put: anInteger!

dwXSize
	"Answer the <Integer> value of the receiver's 'dwXSize' field."

	^bytes dwordAtOffset: _OffsetOf_dwXSize!

dwXSize: anInteger
	"Set the receiver's 'dwXSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwXSize put: anInteger!

dwY
	"Answer the <Integer> value of the receiver's 'dwY' field."

	^bytes dwordAtOffset: _OffsetOf_dwY!

dwY: anInteger
	"Set the receiver's 'dwY' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwY put: anInteger!

dwYSize
	"Answer the <Integer> value of the receiver's 'dwYSize' field."

	^bytes dwordAtOffset: _OffsetOf_dwYSize!

dwYSize: anInteger
	"Set the receiver's 'dwYSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwYSize put: anInteger!

hStdError: anInteger
	"Set the receiver's 'hStdError' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_hStdError put: anInteger!

hStdInput: anInteger
	"Set the receiver's 'hStdInput' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_hStdInput put: anInteger!

hStdOutput: anInteger
	"Set the receiver's 'hStdOutput' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_hStdOutput put: anInteger!

lpDesktop: anUtf16String
	"Set the receiver's 'lpDesktop' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpDesktop put: anUtf16String yourAddress!

lpTitle
	"Answer the <Utf16String> value of the receiver's 'lpTitle' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpTitle)!

lpTitle: anUtf16String
	"Set the receiver's 'lpTitle' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpTitle put: anUtf16String yourAddress!

stderr: aFile
	"Set the hStdError descriptor to aFile. We store down the File
	in an instance variable to prevent it being GC'd"

	stderr := aFile.
	self hStdError: stderr asParameter!

stdin: aFile
	"Set the hStdInput descriptor to aFile. We store down the File
	in an instance variable to prevent it being GC'd"

	stdin := aFile.
	self hStdInput: stdin asParameter!

stdout: aFile
	"Set the hStdOutput descriptor to aFile. We store down the File
	in an instance variable to prevent it being GC'd"

	stdout := aFile.
	self hStdOutput: stdout asParameter!

title: aString
	"Set the title for the receiver to aString. We store down the String
	in an instance variable to prevent it being GC'd"

	title := aString asUtf16String.
	self lpTitle: aString!

wShowWindow
	"Answer the <Integer> value of the receiver's 'wShowWindow' field."

	^bytes wordAtOffset: _OffsetOf_wShowWindow!

wShowWindow: anInteger
	"Set the receiver's 'wShowWindow' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wShowWindow put: anInteger! !
!STARTUPINFOW categoriesFor: #desktop:!accessing!public! !
!STARTUPINFOW categoriesFor: #dwFlags!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwFlags:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwSize:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwX!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwX:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwXSize!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwXSize:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwY!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwY:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwYSize!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #dwYSize:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #hStdError:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #hStdInput:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #hStdOutput:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #lpDesktop:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #lpTitle!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #lpTitle:!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #stderr:!accessing!public! !
!STARTUPINFOW categoriesFor: #stdin:!accessing!public! !
!STARTUPINFOW categoriesFor: #stdout:!accessing!public! !
!STARTUPINFOW categoriesFor: #title:!accessing!public! !
!STARTUPINFOW categoriesFor: #wShowWindow!**compiled accessors**!public! !
!STARTUPINFOW categoriesFor: #wShowWindow:!**compiled accessors**!public! !

!STARTUPINFOW class methodsFor!

defineFields
	"Define the layout of the Win32 STARTUPINFOW structure.

		self compileDefinition

	typedef struct _STARTUPINFO { 
	    DWORD   cb; 
	    LPTSTR  lpReserved; 
	    LPTSTR  lpDesktop; 
	    LPTSTR  lpTitle; 
	    DWORD   dwX; 
	    DWORD   dwY; 
	    DWORD   dwXSize; 
	    DWORD   dwYSize; 
	    DWORD   dwXCountChars; 
	    DWORD   dwYCountChars; 
	    DWORD   dwFillAttribute; 
	    DWORD   dwFlags; 
	    WORD    wShowWindow; 
	    WORD    cbReserved2; 
	    LPBYTE  lpReserved2; 
	    HANDLE  hStdInput; 
	    HANDLE  hStdOutput; 
	    HANDLE  hStdError; 
	} STARTUPINFO, *LPSTARTUPINFO;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #lpReserved type: (PointerField type: Utf16String) beFiller;
		defineField: #lpDesktop type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpTitle type: (PointerField type: Utf16String);
		defineField: #dwX type: DWORDField new;
		defineField: #dwY type: DWORDField new;
		defineField: #dwXSize type: DWORDField new;
		defineField: #dwYSize type: DWORDField new;
		defineField: #dwXCountChars type: DWORDField new beUncompiled;
		defineField: #dwYCountChars type: DWORDField new beUncompiled;
		defineField: #dwFillAttribute type: DWORDField new beUncompiled;
		defineField: #dwFlags type: DWORDField new;
		defineField: #wShowWindow type: WORDField new;
		defineField: #cbReserved2 type: WORDField filler;
		defineField: #lpReserved2 type: LPVOIDField filler;
		defineField: #hStdInput type: UINT_PTRField writeOnly;
		defineField: #hStdOutput type: UINT_PTRField writeOnly;
		defineField: #hStdError type: UINT_PTRField writeOnly!

getFieldNames
	^#(#dwSize #lpDesktop #lpTitle #dwX #dwY #dwXSize #dwYSize #dwXCountChars #dwYCountChars #dwFillAttribute #dwFlags #wShowWindow #hStdInput #hStdOutput #hStdError)! !
!STARTUPINFOW class categoriesFor: #defineFields!automatic generation!public! !
!STARTUPINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

