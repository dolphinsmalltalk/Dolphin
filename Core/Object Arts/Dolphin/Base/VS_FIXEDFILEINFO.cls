"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #VS_FIXEDFILEINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VS_FIXEDFILEINFO guid: (GUID fromString: '{87B4C619-026E-11D3-9FD7-00A0CC3E4A32}')!
VS_FIXEDFILEINFO comment: 'VS_FIXEDFILEINFO is an ExternalStructure class to represent the Win32 structure of the same name.

This structure is used in conjunction with the Windows version information library (Version.DLL) to access standard version information such as the product major and minor version numbers from the resources of exes and dlls.

See also the VersionInfo and VersionLibrary classes.'!
!VS_FIXEDFILEINFO categoriesForClass!External-Data-Structured-Win32! !
!VS_FIXEDFILEINFO methodsFor!

dwFileVersionLS
	"Answer the receiver's dwFileVersionLS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFileVersionLS)!

dwFileVersionMS
	"Answer the receiver's dwFileVersionMS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFileVersionMS)!

dwProductVersionLS
	"Answer the receiver's dwProductVersionLS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwProductVersionLS)!

dwProductVersionMS
	"Answer the receiver's dwProductVersionMS field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwProductVersionMS)!

fileVersionString
	"Answer a String in the form N.N.N.N which specifies the version number of the product."

	^self formatFileVersionString: '%1!!d!!.%2!!d!!.%3!!d!!.%4!!d!!'!

formatFileVersionString: format
	"Answer a version string formatted as per the Win32 format string, format."

	| major minor |
	major := self dwFileVersionMS.
	minor := self dwFileVersionLS.
	^format formatWithArguments: (Array 
				with: major highWord
				with: major lowWord
				with: minor highWord
				with: minor lowWord)!

formatProductVersionString: format
	"Answer a version string formatted as per the Win32 format string, format."

	| major minor |
	major := self dwProductVersionMS.
	minor := self dwProductVersionLS.
	^format formatWithArguments: (Array 
				with: major highWord
				with: major lowWord
				with: minor highWord
				with: minor lowWord)!

productVersionString
	"Answer a String in the form N.N.N.N which specifies the version number of the product."

	^self formatProductVersionString: '%1!!d!!.%2!!d!!.%3!!d!!.%4!!d!!'!

versionAtOffset: anInteger put: anArray 
	(1 to: 4 by: 2) do: 
			[:i | 
			| offset |
			offset := anInteger + ((i - 1) * 2).
			(self bytes)
				wordAtOffset: offset put: (anArray at: i + 1);
				wordAtOffset: offset + 2 put: (anArray at: i)]! !
!VS_FIXEDFILEINFO categoriesFor: #dwFileVersionLS!**compiled accessors**!public! !
!VS_FIXEDFILEINFO categoriesFor: #dwFileVersionMS!**compiled accessors**!public! !
!VS_FIXEDFILEINFO categoriesFor: #dwProductVersionLS!**compiled accessors**!public! !
!VS_FIXEDFILEINFO categoriesFor: #dwProductVersionMS!**compiled accessors**!public! !
!VS_FIXEDFILEINFO categoriesFor: #fileVersionString!accessing!public! !
!VS_FIXEDFILEINFO categoriesFor: #formatFileVersionString:!operations!public! !
!VS_FIXEDFILEINFO categoriesFor: #formatProductVersionString:!operations!public! !
!VS_FIXEDFILEINFO categoriesFor: #productVersionString!accessing!public! !
!VS_FIXEDFILEINFO categoriesFor: #versionAtOffset:put:!accessing!private! !

!VS_FIXEDFILEINFO class methodsFor!

defineFields
	"Private - Define the layout of the Win32 VS_FIXEDFILEINFO structure.
	
		VS_FIXEDFILEINFO compileDefinition
 
	typedef struct _VS_FIXEDFILEINFO   // vsffi 
		DWORD dwSignature; 
		DWORD dwStrucVersion; 
		DWORD dwFileVersionMS; 
		DWORD dwFileVersionLS; 
		DWORD dwProductVersionMS; 
		DWORD dwProductVersionLS; 
		DWORD dwFileFlagsMask; 
		DWORD dwFileFlags; 
		DWORD dwFileOS; 
		DWORD dwFileType; 
		DWORD dwFileSubtype; 
		DWORD dwFileDateMS; 
		DWORD dwFileDateLS; 
	} VS_FIXEDFILEINFO;"

	self
		defineField: #dwSignature type: DWORDField filler;
		defineField: #dwStrucVersion type: DWORDField readOnly beUncompiled;
		defineField: #dwFileVersionMS type: DWORDField readOnly;
		defineField: #dwFileVersionLS type: DWORDField readOnly;
		defineField: #dwProductVersionMS type: DWORDField readOnly;
		defineField: #dwProductVersionLS type: DWORDField readOnly;
		beUncompiled;
		defineField: #dwFileFlagsMask type: DWORDField readOnly;
		defineField: #dwFileFlags type: DWORDField readOnly;
		defineField: #dwFileOS type: DWORDField readOnly;
		defineField: #dwFileType type: DWORDField readOnly;
		defineField: #dwFileSubtype type: DWORDField readOnly;
		defineField: #dwFileDateMS type: DWORDField readOnly;
		defineField: #dwFileDateLS type: DWORDField readOnly
! !
!VS_FIXEDFILEINFO class categoriesFor: #defineFields!initializing!public! !

