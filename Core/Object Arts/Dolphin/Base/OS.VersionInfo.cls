"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.VersionInfo'
	instanceVariableNames: 'fileInfo prefix fixedInfo'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.VersionInfo guid: (Core.GUID fromString: '{87b4c4cb-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.VersionInfo comment: 'VersionInfo is a wrapper class to simplify access to Win32 DLL and EXE version information.

For example:

	VersionInfo forPath: ''notepad.exe''	"Ctrl+I"

Instance Variables:
	fileInfo		<ByteArray>. Buffer containing the raw version information resource.
	prefix		<String>. Prefix used to access language specific information from the version info. string table.
	fixedInfo		<VS_FIXEDFILEINFO>. The basic version information which is always present.'!
!OS.VersionInfo categoriesForClass!System-Support! !
!OS.VersionInfo methodsFor!

at: valueName
	"Answer the named version information from the receiver."

	| lpstr len |
	lpstr := External.Address new.
	len := self queryValue: self prefix , valueName into: lpstr.
	^len == 0 ifTrue: [''] ifFalse: [Utf16String fromAddress: lpstr]!

comments
	^self at: 'Comments'!

fileDescription
	"Answer the <readableString> file name from the receiver."

	^self at: 'FileDescription'!

fileInfo: bytes
	"Private - Set the version data block to the <ByteArray>, bytes."

	fileInfo := bytes!

fileVersion
	"Answer the 64-bit <integer> file version."

	^self fixedInfo fileVersion!

fileVersionString
	"Answer a String in the form N.N.N.N which specifies the version number of the file."

	^self fixedInfo fileVersionString!

fixedInfo
	"Answer a <VS_FIXEDFILEINFO> containing the standard (fixed)
	version info from the receiver.
	Implementation Note: Cache it for later use."

	fixedInfo isNil
		ifTrue: [fixedInfo := self getFixedInfo].
	^fixedInfo!

formatVersionString: format
	"Answer a version string formatted as per the Win32 format string, format."

	| major minor |
	major := self productMajor.
	minor := self productMinor.
	^format formatWithArguments: {self productName.
				major highWord.
				major lowWord.
				minor highWord.
				minor lowWord}!

getFixedInfo
	"Private - Answer a <VS_FIXEDFILEINFO> containing the standard (fixed)
	version info from the receiver."

	| info lib dwLen |
	dwLen := UInt32Bytes new.
	info := VS_FIXEDFILEINFO newPointer.
	lib := VersionLibrary default.
	^(lib
		verQueryValue: fileInfo
		lpSubBlock: '\'
		lplpBuffer: info
		puLen: dwLen) ifTrue: [info] ifFalse: [lib systemError]!

getTranslationInfo
	"Private - Get the language/code-page id from the version info block."

	| lpvi len |
	lpvi := External.Address new.
	len := self queryValue: '\VarFileInfo\Translation' into: lpvi.
	self assert: [len >= 4].
	^'%04x%04x' sprintfWith: (lpvi uint16AtOffset: 0) with: (lpvi uint16AtOffset: 2)!

legalCopyright
	"Answer the <readableString> copyright notice from the receiver."

	^self at: 'LegalCopyright'
!

prefix
	"Private - Answer the <readableString> prefix to be prepended to names in
	order to extract them from the version information."

	prefix isNil
		ifTrue: [prefix := '\StringFileInfo\', self getTranslationInfo, '\'].
	^prefix!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self fileDescription;
		nextPutAll: ', File: ';
		print: self fileVersionString;
		nextPutAll: ', Product: ';
		print: self productVersionString;
		nextPut: $)!

productMajor
	"Answer the <integer> major version number of the product."

	^self fixedInfo dwProductVersionMS!

productMinor
	"Answer the <integer> minor version number of the product."

	^self fixedInfo dwProductVersionLS!

productName
	"Answer the <readableString> product name from the receiver."

	^self at: 'ProductName'!

productVersionString
	"Answer the ProductVersion field of the version info. Preferably this will be in SemVer form (M.N.P[-prerel+buildmeta])"

	^self at: 'ProductVersion'!

queryValue: name into: buf
	"Private - Get the language/code-page id from the version info block."

	| dwLen |
	dwLen := UInt32Bytes fromInteger: 123.
	VersionLibrary default
		verQueryValue: fileInfo
		lpSubBlock: name
		lplpBuffer: buf
		puLen: dwLen.
	^dwLen asInteger!

specialBuild
	"Answer the <readableString> product name from the receiver."

	^self at: 'SpecialBuild'! !
!OS.VersionInfo categoriesForMethods!
at:!accessing!public! !
comments!accessing!public! !
fileDescription!accessing!public! !
fileInfo:!accessing!private! !
fileVersion!public! !
fileVersionString!accessing!public! !
fixedInfo!accessing!public! !
formatVersionString:!operations!public! !
getFixedInfo!accessing!private! !
getTranslationInfo!accessing!private! !
legalCopyright!accessing!public! !
prefix!accessing!private! !
printOn:!printing!public! !
productMajor!accessing!public! !
productMinor!accessing!public! !
productName!accessing!public! !
productVersionString!accessing!public! !
queryValue:into:!accessing!private! !
specialBuild!accessing!public! !
!

!OS.VersionInfo class methodsFor!

forPath: path
	"Answer a new instance of the receiver which can be used to query the version
	information of the file with the specified path."

	^self new
		fileInfo: (VersionLibrary default getFileVersionInfo: path);
		yourself!

uninitialize
	"Assist the version library in departing this world"

	#{VersionLibrary} ifDefined: [:lib | lib closeDefault]! !
!OS.VersionInfo class categoriesForMethods!
forPath:!instance creation!public! !
uninitialize!class hierarchy-removing!public! !
!

