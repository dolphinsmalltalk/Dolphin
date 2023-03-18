"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.VS_FIXEDFILEINFO'
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
			'_OffsetOf_dwStrucVersion' -> 16r4.
			'_VS_FIXEDFILEINFO_Size' -> 16r34
		}!
OS.VS_FIXEDFILEINFO guid: (Core.GUID fromString: '{87b4c619-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.VS_FIXEDFILEINFO comment: 'VS_FIXEDFILEINFO is an ExternalStructure class to represent the Win32 structure of the same name.

This structure is used in conjunction with the Windows version information library (Version.DLL) to access standard version information such as the product major and minor version numbers from the resources of exes and dlls.

See also the VersionInfo and VersionLibrary classes.'!
!OS.VS_FIXEDFILEINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.VS_FIXEDFILEINFO methodsFor!

dwFileVersionLS
	"Answer the <Integer> value of the receiver's 'dwFileVersionLS' field."

	^bytes uint32AtOffset: _OffsetOf_dwFileVersionLS!

dwFileVersionMS
	"Answer the <Integer> value of the receiver's 'dwFileVersionMS' field."

	^bytes uint32AtOffset: _OffsetOf_dwFileVersionMS!

dwProductVersionLS
	"Answer the <Integer> value of the receiver's 'dwProductVersionLS' field."

	^bytes uint32AtOffset: _OffsetOf_dwProductVersionLS!

dwProductVersionMS
	"Answer the <Integer> value of the receiver's 'dwProductVersionMS' field."

	^bytes uint32AtOffset: _OffsetOf_dwProductVersionMS!

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
				uint16AtOffset: offset put: (anArray at: i + 1);
				uint16AtOffset: offset + 2 put: (anArray at: i)]! !
!OS.VS_FIXEDFILEINFO categoriesForMethods!
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

!OS.VS_FIXEDFILEINFO class methodsFor!

byteSize
	^_VS_FIXEDFILEINFO_Size!

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
		defineField: #dwSignature type: UInt32Field filler;
		defineField: #dwStrucVersion type: UInt32Field readOnly beUncompiled;
		defineField: #dwFileVersionMS type: UInt32Field readOnly;
		defineField: #dwFileVersionLS type: UInt32Field readOnly;
		defineField: #dwProductVersionMS type: UInt32Field readOnly;
		defineField: #dwProductVersionLS type: UInt32Field readOnly;
		beUncompiled;
		defineField: #dwFileFlagsMask type: UInt32Field readOnly;
		defineField: #dwFileFlags type: UInt32Field readOnly;
		defineField: #dwFileOS type: UInt32Field readOnly;
		defineField: #dwFileType type: UInt32Field readOnly;
		defineField: #dwFileSubtype type: UInt32Field readOnly;
		defineField: #dwFileDateMS type: UInt32Field readOnly;
		defineField: #dwFileDateLS type: UInt32Field readOnly!

getFieldNames
	^#(#dwStrucVersion #dwFileVersionMS #dwFileVersionLS #dwProductVersionMS #dwProductVersionLS #dwFileFlagsMask #dwFileFlags #dwFileOS #dwFileType #dwFileSubtype #dwFileDateMS #dwFileDateLS)! !
!OS.VS_FIXEDFILEINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

