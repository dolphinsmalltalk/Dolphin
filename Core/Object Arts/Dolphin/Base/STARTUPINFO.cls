"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #STARTUPINFO
	instanceVariableNames: 'title desktop stdin stdout stderr'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STARTUPINFO guid: (GUID fromString: '{F44C9146-2B3F-11D3-8368-7A8B5A000000}')!
STARTUPINFO comment: ''!
!STARTUPINFO categoriesForClass!External-Data-Structured-Win32! !
!STARTUPINFO methodsFor!

desktop: aString
	"Set the desktop identifier for the receiver to aString. We store down the String
	in an instance variable to prevent it being GC'd"

	desktop := aString.
	self lpDesktop: aString!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwX
	"Answer the receiver's dwX field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwX)!

dwX: anObject 
	"Set the receiver's dwX field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwX) put: anObject!

dwXSize
	"Answer the receiver's dwXSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwXSize)!

dwXSize: anObject 
	"Set the receiver's dwXSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwXSize) put: anObject!

dwY
	"Answer the receiver's dwY field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwY)!

dwY: anObject 
	"Set the receiver's dwY field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwY) put: anObject!

dwYSize
	"Answer the receiver's dwYSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwYSize)!

dwYSize: anObject 
	"Set the receiver's dwYSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwYSize) put: anObject!

hStdError: anObject 
	"Set the receiver's hStdError field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hStdError) put: anObject!

hStdInput: anObject 
	"Set the receiver's hStdInput field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hStdInput) put: anObject!

hStdOutput: anObject 
	"Set the receiver's hStdOutput field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hStdOutput) put: anObject!

lpDesktop: anObject 
	"Set the receiver's lpDesktop field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpDesktop) put: anObject yourAddress!

lpTitle
	"Answer the receiver's lpTitle field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpTitle))!

lpTitle: anObject 
	"Set the receiver's lpTitle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpTitle) put: anObject yourAddress!

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

	title := aString.
	self lpTitle: aString!

wShowWindow
	"Answer the receiver's wShowWindow field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wShowWindow)!

wShowWindow: anObject 
	"Set the receiver's wShowWindow field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wShowWindow) put: anObject! !
!STARTUPINFO categoriesFor: #desktop:!accessing!public! !
!STARTUPINFO categoriesFor: #dwFlags!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwFlags:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwX!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwX:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwXSize!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwXSize:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwY!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwY:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwYSize!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #dwYSize:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #hStdError:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #hStdInput:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #hStdOutput:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #lpDesktop:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #lpTitle!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #lpTitle:!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #stderr:!accessing!public! !
!STARTUPINFO categoriesFor: #stdin:!accessing!public! !
!STARTUPINFO categoriesFor: #stdout:!accessing!public! !
!STARTUPINFO categoriesFor: #title:!accessing!public! !
!STARTUPINFO categoriesFor: #wShowWindow!**compiled accessors**!public! !
!STARTUPINFO categoriesFor: #wShowWindow:!**compiled accessors**!public! !

!STARTUPINFO class methodsFor!

defineFields
	"Define the layout of the Win32 STARTUPINFO structure.

		STARTUPINFO compileDefinition

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
		defineField: #lpReserved type: (PointerField type: String) beFiller;
		defineField: #lpDesktop type: (PointerField type: String) beWriteOnly;
		defineField: #lpTitle type: (PointerField type: String);
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
		defineField: #hStdError type: UINT_PTRField writeOnly! !
!STARTUPINFO class categoriesFor: #defineFields!automatic generation!public! !

