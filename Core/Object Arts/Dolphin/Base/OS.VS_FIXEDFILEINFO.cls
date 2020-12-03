"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.VS_FIXEDFILEINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFileDateLS' -> 16r30.
		'_OffsetOf_dwFileDateMS' -> 16r2C.
		'_OffsetOf_dwFileFlags' -> 16r1C.
		'_OffsetOf_dwFileFlagsMask' -> 16r18.
		'_OffsetOf_dwFileOS' -> 16r20.
		'_OffsetOf_dwFileSubtype' -> 16r28.
		'_OffsetOf_dwFileType' -> 16r24.
		'_OffsetOf_dwFileVersionLS' -> 16rC.
		'_OffsetOf_dwFileVersionMS' -> 16r8.
		'_OffsetOf_dwProductVersionLS' -> 16r14.
		'_OffsetOf_dwProductVersionMS' -> 16r10.
		'_OffsetOf_dwSignature' -> 16r0.
		'_OffsetOf_dwStrucVersion' -> 16r4
	}!
OS.VS_FIXEDFILEINFO guid: (Core.GUID fromString: '{87b4c619-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.VS_FIXEDFILEINFO comment: 'VS_FIXEDFILEINFO is an ExternalStructure class to represent the Win32 structure of the same name.

This structure is used in conjunction with the Windows version information library (Version.DLL) to access standard version information such as the product major and minor version numbers from the resources of exes and dlls.

See also the VersionInfo and VersionLibrary classes.'!
!OS.VS_FIXEDFILEINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.VS_FIXEDFILEINFO methodsFor!

dwFileVersionLS
	"Answer the <Integer> value of the receiver's 'dwFileVersionLS' field."

	^bytes dwordAtOffset: _OffsetOf_dwFileVersionLS!

dwFileVersionMS
	"Answer the <Integer> value of the receiver's 'dwFileVersionMS' field."

	^bytes dwordAtOffset: _OffsetOf_dwFileVersionMS!

dwProductVersionLS
	"Answer the <Integer> value of the receiver's 'dwProductVersionLS' field."

	^bytes dwordAtOffset: _OffsetOf_dwProductVersionLS!

dwProductVersionMS
	"Answer the <Integer> value of the receiver's 'dwProductVersionMS' field."

	^bytes dwordAtOffset: _OffsetOf_dwProductVersionMS!

fileVersion
	"Answer the 64-bit <integer> file version."

	^(self dwFileVersionMS << 32) + self dwFileVersionLS!

fileVersionComponents
	"Answer a four element <Array> of <Integer> representing the file version components in
	order from major to minor."

	| major minor |
	major := self dwFileVersionMS.
	minor := self dwFileVersionLS.
	^{major highWord. major lowWord. minor highWord. minor lowWord}!

fileVersionString
	"Answer a String in the form N.N.N.N which specifies the version number of the product."

	^self formatFileVersionString: '%1!!d!!.%2!!d!!.%3!!d!!.%4!!d!!'!

formatFileVersionString: format
	"Answer a version string formatted as per the Win32 format string, format."

	^format formatWithArguments: self fileVersionComponents!

formatProductVersionString: format
	"Answer a version string formatted as per the Win32 format string, format."

	| major minor |
	major := self dwProductVersionMS.
	minor := self dwProductVersionLS.
	^format formatWithArguments: {major highWord. major lowWord. minor highWord. minor lowWord}!

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
!OS.VS_FIXEDFILEINFO categoriesFor: #dwFileVersionLS!**compiled accessors**!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #dwFileVersionMS!**compiled accessors**!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #dwProductVersionLS!**compiled accessors**!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #dwProductVersionMS!**compiled accessors**!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #fileVersion!accessing!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #fileVersionComponents!accessing!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #fileVersionString!accessing!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #formatFileVersionString:!operations!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #formatProductVersionString:!operations!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #productVersionString!accessing!public! !
!OS.VS_FIXEDFILEINFO categoriesFor: #versionAtOffset:put:!accessing!private! !

!OS.VS_FIXEDFILEINFO class methodsFor!

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
		defineField: #dwFileDateLS type: DWORDField readOnly!

getFieldNames
	^#(#dwStrucVersion #dwFileVersionMS #dwFileVersionLS #dwProductVersionMS #dwProductVersionLS #dwFileFlagsMask #dwFileFlags #dwFileOS #dwFileType #dwFileSubtype #dwFileDateMS #dwFileDateLS)! !
!OS.VS_FIXEDFILEINFO class categoriesFor: #defineFields!public!template definition! !
!OS.VS_FIXEDFILEINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

