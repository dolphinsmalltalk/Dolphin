"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #VS_FIXEDFILEINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFileDateLS _OffsetOf_dwFileDateMS _OffsetOf_dwFileFlags _OffsetOf_dwFileFlagsMask _OffsetOf_dwFileOS _OffsetOf_dwFileSubtype _OffsetOf_dwFileType _OffsetOf_dwFileVersionLS _OffsetOf_dwFileVersionMS _OffsetOf_dwProductVersionLS _OffsetOf_dwProductVersionMS _OffsetOf_dwSignature _OffsetOf_dwStrucVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VS_FIXEDFILEINFO guid: (GUID fromString: '{87b4c619-026e-11d3-9fd7-00a0cc3e4a32}')!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileDateLS' value: 16r30!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileDateMS' value: 16r2C!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileFlags' value: 16r1C!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileFlagsMask' value: 16r18!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileOS' value: 16r20!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileSubtype' value: 16r28!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileType' value: 16r24!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileVersionLS' value: 16rC!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwFileVersionMS' value: 16r8!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwProductVersionLS' value: 16r14!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwProductVersionMS' value: 16r10!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwSignature' value: 16r0!
VS_FIXEDFILEINFO addClassConstant: '_OffsetOf_dwStrucVersion' value: 16r4!
VS_FIXEDFILEINFO comment: 'VS_FIXEDFILEINFO is an ExternalStructure class to represent the Win32 structure of the same name.

This structure is used in conjunction with the Windows version information library (Version.DLL) to access standard version information such as the product major and minor version numbers from the resources of exes and dlls.

See also the VersionInfo and VersionLibrary classes.'!
!VS_FIXEDFILEINFO categoriesForClass!External-Data-Structured-Win32! !
!VS_FIXEDFILEINFO methodsFor!

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
!VS_FIXEDFILEINFO categoriesForMethods!
dwFileVersionLS!**compiled accessors**!public! !
dwFileVersionMS!**compiled accessors**!public! !
dwProductVersionLS!**compiled accessors**!public! !
dwProductVersionMS!**compiled accessors**!public! !
fileVersion!accessing!public! !
fileVersionComponents!accessing!public! !
fileVersionString!accessing!public! !
formatFileVersionString:!operations!public! !
formatProductVersionString:!operations!public! !
productVersionString!accessing!public! !
versionAtOffset:put:!accessing!private! !
!

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
!

getFieldNames
	^#(#dwStrucVersion #dwFileVersionMS #dwFileVersionLS #dwProductVersionMS #dwProductVersionLS #dwFileFlagsMask #dwFileFlags #dwFileOS #dwFileType #dwFileSubtype #dwFileDateMS #dwFileDateLS)! !
!VS_FIXEDFILEINFO class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

