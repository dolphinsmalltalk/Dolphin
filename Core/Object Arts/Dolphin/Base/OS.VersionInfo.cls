"Filed out from Dolphin Smalltalk 7"!

Object subclass: #VersionInfo
	instanceVariableNames: 'fileInfo prefix fixedInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VersionInfo guid: (GUID fromString: '{87b4c4cb-026e-11d3-9fd7-00a0cc3e4a32}')!
VersionInfo comment: 'VersionInfo is a wrapper class to simplify access to Win32 DLL and EXE version information.

For example:

	VersionInfo forPath: ''notepad.exe''	"Ctrl+I"

Instance Variables:
	fileInfo		<ByteArray>. Buffer containing the raw version information resource.
	prefix		<String>. Prefix used to access language specific information from the version info. string table.
	fixedInfo		<VS_FIXEDFILEINFO>. The basic version information which is always present.'!
!VersionInfo categoriesForClass!System-Support! !
!VersionInfo methodsFor!

at: valueName
	"Answer the named version information from the receiver."

	| lpstr len |
	lpstr := ExternalAddress new.
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
	dwLen := DWORDBytes new.
	info := VS_FIXEDFILEINFO newPointer.
	lib := VersionLibrary default.
	^(lib verQueryValue: fileInfo lpSubBlock: '\' lplpBuffer: info puLen: dwLen)
		ifTrue: [info]
		ifFalse: [lib systemError]!

getTranslationInfo
	"Private - Get the language/code-page id from the version info block."

	| lpvi len |
	lpvi := ExternalAddress new.
	len := self queryValue: '\VarFileInfo\Translation' into: lpvi.
	self assert: [len >= 4].
	^'%04x%04x' sprintfWith: (lpvi wordAtOffset: 0) with: (lpvi wordAtOffset: 2)!

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

	^self at: 'ProductVersion'!

queryValue: name into: buf
	"Private - Get the language/code-page id from the version info block."

	| dwLen |
	dwLen := DWORDBytes fromInteger: 123.
	VersionLibrary default verQueryValue: fileInfo lpSubBlock: name lplpBuffer: buf puLen: dwLen.
	^dwLen asInteger!

specialBuild
	"Answer the <readableString> product name from the receiver."

	^self at: 'SpecialBuild'! !
!VersionInfo categoriesFor: #at:!accessing!public! !
!VersionInfo categoriesFor: #comments!accessing!public! !
!VersionInfo categoriesFor: #fileDescription!accessing!public! !
!VersionInfo categoriesFor: #fileInfo:!accessing!private! !
!VersionInfo categoriesFor: #fileVersion!public! !
!VersionInfo categoriesFor: #fileVersionString!accessing!public! !
!VersionInfo categoriesFor: #fixedInfo!accessing!public! !
!VersionInfo categoriesFor: #formatVersionString:!operations!public! !
!VersionInfo categoriesFor: #getFixedInfo!accessing!private! !
!VersionInfo categoriesFor: #getTranslationInfo!accessing!private! !
!VersionInfo categoriesFor: #legalCopyright!accessing!public! !
!VersionInfo categoriesFor: #prefix!accessing!private! !
!VersionInfo categoriesFor: #productMajor!accessing!public! !
!VersionInfo categoriesFor: #productMinor!accessing!public! !
!VersionInfo categoriesFor: #productName!accessing!public! !
!VersionInfo categoriesFor: #productVersionString!accessing!public! !
!VersionInfo categoriesFor: #queryValue:into:!accessing!private! !
!VersionInfo categoriesFor: #specialBuild!accessing!public! !

!VersionInfo class methodsFor!

forPath: path
	"Answer a new instance of the receiver which can be used to query the version
	information of the file with the specified path."

	^self new
		fileInfo: (VersionLibrary default getFileVersionInfo: path);
		yourself		!

uninitialize
	"Assist the version library in departing this world"

	#{VersionLibrary} ifDefined: [:lib | lib closeDefault]! !
!VersionInfo class categoriesFor: #forPath:!instance creation!public! !
!VersionInfo class categoriesFor: #uninitialize!class hierarchy-removing!public! !

