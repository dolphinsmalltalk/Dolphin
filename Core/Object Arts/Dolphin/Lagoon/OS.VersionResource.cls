"Filed out from Dolphin Smalltalk 7"!

Object subclass: #VersionResource
	instanceVariableNames: 'fixedInfo stringTables translations'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
VersionResource guid: (GUID fromString: '{b76ab5bc-4ba7-40d2-88fe-6a76d28fc30b}')!
VersionResource comment: ''!
!VersionResource categoriesForClass!System-Support! !
!VersionResource methodsFor!

bumpProductVersion
	| decodedVersion |
	decodedVersion := self decodeVersionString: self productVersion.
	decodedVersion at: 3 put: (decodedVersion at: 3) + 1.
	self setProductVersions: decodedVersion.
	self fileVersion: self productVersion!

decodeVersionString: versionString 
	"Private - Answer a fource element <array> of 16-bit unsigned <integer>s, being the most to
	least significant version numbers composed from the <readableString> argument, which is
	expected to consist of up to four integers, separated by any non-numeric separator
	characters, e.g. 1.2.3.4"

	| words stream i |
	words := WORDArray new: 4.
	stream := versionString readStream.
	i := 0.
	[i < words size and: [stream skipWhile: [:c | c isDigit not]]] whileTrue: 
			[i := i + 1.
			words at: i put: (Integer readFrom: stream)].
	^words!

fileVersion
	"Answer the <readableString> file version number for the receiver."

	^self fixedInfo fileVersionString!

fileVersion: versionString 
	"Set the file version number for the receiver from the <readableString> 
	argument, expected to consist of up to four integer components separated
	by any non-numeric characters."

	self setFileVersions: (self decodeVersionString: versionString)!

fixedInfo
	"Answer the value of the receiver's ''fixedInfo'' instance variable."

	^fixedInfo!

initialize
	"Private - Initialize the receiver's instance variables."

	translations := OrderedCollection new.
	stringTables := LookupTable new!

languageId
	"Answer the <integer> Win32 language id of the version resource.
	Note: This is actually the LCID of the first string table in the version resource, but according to MSDN
	a DLL that supports multiple languages should have one version resource per language, rather than 
	multiple languages in the version resource, and therefore we assume that only one language is used in 
	the receiver."

	self stringTables keysDo: [:s | ^Integer readFrom: (s leftString: 4) readStream radix: 16].
	^0!

pack
	"Private - Create and answer a binary version resource containing the information held
	by the receiver. This will be a <ByteArray> which can be written directly back into
	an executable/dll with the UpdateResource() API."

	| target |
	target := ByteArray writeStream: 2048.
	self writeVersionInfoTo: target.
	^target contents!

productVersion
	"Answer the <readableString> product version number for the receiver."

	^self fixedInfo productVersionString!

productVersion: versionString 
	"Set the product version number for the receiver from the <readableString> argument,
	expected to consist of up to four integer components separated by any non-numeric
	characters."

	self setProductVersions: (self decodeVersionString: versionString)!

readFromModule: anExternalResourceLibrary 
	"Private - Read and unpack the version resource from the specified module.
	Answer the receiver if the library contained a version resource, else nil."

	| address |
	address := self class getVersionResourceOfModule: anExternalResourceLibrary.
	"If address is null then module does not contain a version resource"
	^address notNull 
		ifTrue: 
			[self unpack: address.
			self]!

setFileVersions: anArray 
	self fixedInfo versionAtOffset: 8 put: anArray.
	stringTables 
		do: [:table | (table includesKey: 'FileVersion') ifTrue: [table at: 'FileVersion' put: self fileVersion]]!

setProductVersions: anArray 
	self fixedInfo versionAtOffset: 16 put: anArray.
	stringTables do: 
			[:table | 
			(table includesKey: 'ProductVersion') ifTrue: [table at: 'ProductVersion' put: self productVersion]]!

stringTables
	"Answer the value of the receiver's ''stringTables'' instance variable."

	^stringTables!

stringTables: aLookupTable
	"Set the receiver's version string tables."

	stringTables := aLookupTable!

translations
	"Answer the value of the receiver's ''translations'' instance variable."

	^translations!

translations: anOrderedCollection
	"Set the value of the receiver's ''translations'' instance variable."

	translations := anOrderedCollection!

unpack: anExternalAddress 
	"Private - Unpack the version resource into its constituents."

	| vsVersionInfo versionInfoSize offset |
	offset := 0.
	vsVersionInfo := VS_VERSION_INFO_HEADER fromAddress: anExternalAddress.
	self assert: [vsVersionInfo key = 'VS_VERSION_INFO'].
	fixedInfo := VS_FIXEDFILEINFO 
				fromBytes: (ByteArray fromAddress: anExternalAddress asInteger + vsVersionInfo valueOffset
						length: vsVersionInfo wValueLength).
	offset := vsVersionInfo childrenOffset.
	versionInfoSize := vsVersionInfo wLength.
	"There should follow zero or one StringFileInfo blocks and then zero or one VarFileInfo blocks"
	[offset < versionInfoSize] whileTrue: 
			[| infoBlock key |
			self assert: [offset \\ 4 = 0].
			infoBlock := VS_VERSION_INFO_HEADER fromAddress: anExternalAddress asInteger + offset.
			self assert: [infoBlock wLength > 0].
			key := infoBlock key.
			key = 'StringFileInfo' 
				ifTrue: [self unpackStringFileInfo: infoBlock]
				ifFalse: 
					[key = 'VarFileInfo' 
						ifTrue: [self unpackVarFileInfo: infoBlock]
						ifFalse: [Notification signal: 'Unrecognised version resource block of type ' , key]].
			offset := offset + infoBlock wLength roundUpTo: 4]!

unpackStringFileInfo: aZVersionBlockHeader 
	"Private - Unpack a StringFileInfo block."

	| base length offset |
	self assert: [aZVersionBlockHeader key = 'StringFileInfo'].
	base := aZVersionBlockHeader yourAddress asInteger.
	self assert: [base \\ 4 = 0].
	length := aZVersionBlockHeader wLength.
	offset := aZVersionBlockHeader childrenOffset.
	[offset < length] whileTrue: 
			[| stringTableHeader |
			self assert: [offset \\ 4 = 0].
			stringTableHeader := VS_VERSION_INFO_HEADER 
						fromAddress: base asInteger + offset.
			self unpackStringTable: stringTableHeader.
			offset := offset + stringTableHeader wLength roundUpTo: 4]!

unpackStringTable: aZVersionBlockHeader 
	"Private - Unpack a StringTable block."

	| base length offset strings |
	strings := self stringTables at: aZVersionBlockHeader key
				ifAbsentPut: [LookupTable new].
	base := aZVersionBlockHeader yourAddress asInteger.
	length := aZVersionBlockHeader wLength.
	offset := aZVersionBlockHeader childrenOffset.
	[offset < length] whileTrue: 
			[| stringHeader value |
			stringHeader := VS_VERSION_INFO_HEADER fromAddress: base + offset.
			value := stringHeader valueString.
			strings at: stringHeader key put: value.
			offset := offset + stringHeader wLength roundUpTo: 4]!

unpackVar: aVS_INFO_HEADER 
	| varPairs |
	self assert: [aVS_INFO_HEADER key = 'Translation'].
	varPairs := aVS_INFO_HEADER valueDWORDs.
	self translations add: varPairs copy!

unpackVarFileInfo: aZVersionBlockHeader 
	"Private - Unpack a VarFileInfo block."

	| base length offset |
	self assert: [aZVersionBlockHeader key = 'VarFileInfo'].
	base := aZVersionBlockHeader yourAddress asInteger.
	self assert: [base \\ 4 = 0].
	length := aZVersionBlockHeader wLength.
	offset := aZVersionBlockHeader childrenOffset.
	[offset < length] whileTrue: 
			[| varHeader |
			self assert: [offset \\ 4 = 0].
			varHeader := VS_VERSION_INFO_HEADER fromAddress: base asInteger + offset.
			self unpackVar: varHeader.
			offset := offset + varHeader wLength]!

updateFile: aString 
	KernelLibrary default updateResourcesOf: aString do: [:hUpdate | self updateResource: hUpdate]!

updateResource: anExternalHandle
	"Update the version resource of the module on which the argument, anExternalHandle, is a resource update handle."

	| resourceBytes |
	resourceBytes := self pack.
	(KernelLibrary default
		updateResource: anExternalHandle
		lpType: RT_VERSION
		lpName: 1
		wLanguage: self languageId
		lpData: resourceBytes
		cbData: resourceBytes size)
			ifFalse: [KernelLibrary default systemError]!

writeBinaryHeaderTo: aWriteStream key: keyString value: valueBytes
	"Private - Append a VS_VERSION_INFO header block of wType 1 (text) to the <puttableStream>, 
	target (which must be a byte stream). The wLength member is left as zero to be filled in later. Answer 
	the position of the start of the block."

	^self 
		writeHeaderTo: aWriteStream
		type: 0
		key: keyString
		value: valueBytes
		length: valueBytes size!

writeBlockSizeTo: target at: blockStart
	"Private - Update the wLength member of the VS_VERSION_INFO block header
	at position, blockStart, in the <puttableStream>, target (which must be a byte stream),
	to be the difference between the current stream position and blockStart."

	| blockSize |
	blockSize := target position - blockStart.
	target
		position: blockStart; 
		nextPutAll: (WORD fromInteger: blockSize) bytes; 
		setToEnd
!

writeHeaderTo: aWriteStream type: wType key: keyString value: valueBytes length: wValueLength
	"Private - Append a VS_VERSION_INFO header block to the <puttableStream>, target (which
	must be a byte stream). The wLength member is left as zero to be filled in later. 
	Note that the wValueLength argument might be the byte size or number of words.
	Answer the position of the start of the block."

	| blockStart szKey word keySize wLength |
	aWriteStream padTo: 4 put: 0.
	blockStart := aWriteStream position.
	szKey := keyString asUtf16String.
	keySize := szKey byteSize.
	wLength := (6 + keySize roundUpTo: 4) + valueBytes size.
	word := WORD new.
	aWriteStream
		nextPutAll: (word value: wLength) bytes;
		nextPutAll: (word value: wValueLength) bytes;
		nextPutAll: (word value: wType) bytes;
		next: keySize
			putAll: szKey yourAddress asExternalAddress
			startingAt: 1;
		padTo: 4 put: 0;
		nextPutAll: valueBytes.	"wLength may be updated later"
	^blockStart!

writeStringFileInfoTo: target 
	"Private - Append a StringFileInfo block to the <puttableStream>, target (which
	must be a byte stream), containing the receiver's version string tables."

	| blockStart |
	self assert: [self stringTables notEmpty].
	blockStart := self 
				writeTextHeaderTo: target
				key: 'StringFileInfo'
				value: ''.
	self
		writeStringTablesTo: target;
		writeBlockSizeTo: target at: blockStart!

writeStrings: aLookupTable to: target
	"Private - Append String blocks containing the receiver's version info strings to
	the <puttableStream>, target (which must be a byte stream)."

	aLookupTable keys asArray sort do: [:key |
		self writeTextHeaderTo: target key: key value: (aLookupTable at: key)].

!

writeStringTablesTo: target 
	"Private - Append StringTable blocks containing the receiver's string tables to
	the <puttableStream>, target (which must be a byte stream)."

	self stringTables keys asArray sort do: 
			[:languageId | 
			| blockStart |
			blockStart := self 
						writeTextHeaderTo: target
						key: languageId
						value: ''.
			self writeStrings: (self stringTables at: languageId) to: target.
			self writeBlockSizeTo: target at: blockStart]!

writeTextHeaderTo: aWriteStream key: keyString value: valueString
	"Private - Append a VS_VERSION_INFO header block of wType 1 (text) to the <puttableStream>, 
	target (which must be a byte stream). The wLength member is left as zero to be filled in later. Answer 
	the position of the start of the block."

	^valueString isEmpty
		ifTrue: 
			[self
				writeHeaderTo: aWriteStream
				type: 1
				key: keyString
				value: #[]
				length: 0]
		ifFalse: 
			[| valueBytes length szValue |
			szValue := valueString asUtf16String.
			length := valueString size + 1.
			valueBytes := ByteArray fromAddress: szValue yourAddress length: length << 1.
			self
				writeHeaderTo: aWriteStream
				type: 1
				key: keyString
				value: valueBytes
				length: length]!

writeTranslationsTo: aWriteStream
	"Private - Append String blocks containing the receiver's version info strings to
	the <puttableStream>, target (which must be a byte stream)."

	self translations do: 
			[:each | 
			self 
				writeBinaryHeaderTo: aWriteStream
				key: 'Translation'
				value: each bytes]!

writeVarFileInfoTo: target
	"Private - Append a StringFileInfo block to the <puttableStream>, target (which
	must be a byte stream)."

	| blockStart |
	self assert: [self translations notEmpty].
	blockStart := self writeTextHeaderTo: target key: 'VarFileInfo' value: ''.

	self
		writeTranslationsTo: target;
		writeBlockSizeTo: target at: blockStart!

writeVersionInfoTo: aWriteStream 
	"Private - Append a VS_VERSION_INFO block to the <puttableStream>, target (which
	must be a byte stream)."

	| blockStart |
	blockStart := self 
				writeBinaryHeaderTo: aWriteStream
				key: 'VS_VERSION_INFO'
				value: self fixedInfo bytes.
	self stringTables notEmpty ifTrue: [self writeStringFileInfoTo: aWriteStream].
	self translations notEmpty ifTrue: [self writeVarFileInfoTo: aWriteStream].
	self writeBlockSizeTo: aWriteStream at: blockStart! !
!VersionResource categoriesFor: #bumpProductVersion!operations!public! !
!VersionResource categoriesFor: #decodeVersionString:!helpers!private! !
!VersionResource categoriesFor: #fileVersion!accessing!public! !
!VersionResource categoriesFor: #fileVersion:!accessing!public! !
!VersionResource categoriesFor: #fixedInfo!accessing!public! !
!VersionResource categoriesFor: #initialize!initializing!private! !
!VersionResource categoriesFor: #languageId!accessing!public! !
!VersionResource categoriesFor: #pack!operations!private! !
!VersionResource categoriesFor: #productVersion!accessing!public! !
!VersionResource categoriesFor: #productVersion:!accessing!public! !
!VersionResource categoriesFor: #readFromModule:!initializing!public! !
!VersionResource categoriesFor: #setFileVersions:!accessing!private! !
!VersionResource categoriesFor: #setProductVersions:!accessing!private! !
!VersionResource categoriesFor: #stringTables!accessing!public! !
!VersionResource categoriesFor: #stringTables:!accessing!public! !
!VersionResource categoriesFor: #translations!accessing!public! !
!VersionResource categoriesFor: #translations:!accessing!public! !
!VersionResource categoriesFor: #unpack:!operations!public! !
!VersionResource categoriesFor: #unpackStringFileInfo:!helpers!public! !
!VersionResource categoriesFor: #unpackStringTable:!helpers!public! !
!VersionResource categoriesFor: #unpackVar:!helpers!private! !
!VersionResource categoriesFor: #unpackVarFileInfo:!helpers!public! !
!VersionResource categoriesFor: #updateFile:!operations!public! !
!VersionResource categoriesFor: #updateResource:!operations!public! !
!VersionResource categoriesFor: #writeBinaryHeaderTo:key:value:!helpers!private! !
!VersionResource categoriesFor: #writeBlockSizeTo:at:!helpers!private! !
!VersionResource categoriesFor: #writeHeaderTo:type:key:value:length:!helpers!private! !
!VersionResource categoriesFor: #writeStringFileInfoTo:!helpers!private! !
!VersionResource categoriesFor: #writeStrings:to:!helpers!private! !
!VersionResource categoriesFor: #writeStringTablesTo:!helpers!private! !
!VersionResource categoriesFor: #writeTextHeaderTo:key:value:!helpers!private! !
!VersionResource categoriesFor: #writeTranslationsTo:!helpers!private! !
!VersionResource categoriesFor: #writeVarFileInfoTo:!helpers!private! !
!VersionResource categoriesFor: #writeVersionInfoTo:!helpers!private! !

!VersionResource class methodsFor!

forModule: anExternalResourceLibrary 
	"Answer a new instance of the receiver which can be used to query the version
	information of the specified module."

	^self new readFromModule: anExternalResourceLibrary!

forPath: path
	"Answer a new instance of the receiver which can be used to query the version
	information of the file with the specified path.
	Implementation Note: ExternalResourceLibrary will not open a resource dll/exe 
	which does not have an extension, so must use ExternalLibrary"

	| lib answer |
	lib := DynamicLinkLibrary open: path.
	answer := self forModule: lib.
	lib close.
	^answer!

getVersionResourceOfModule: anExternalResourceLibrary
	"Private - Answer a pointer to the version resource in the specified module, or null if it doesn't have one.
	Note that there is no explicit call to unlock version resources."

	| kernel hFind hRes address |
	kernel := KernelLibrary default.
	(hFind := kernel 
				findResource: anExternalResourceLibrary asParameter
				lpName: 1
				lpType: RT_VERSION) isNull 
		ifTrue: [^nil].
	(hRes := kernel loadResource: anExternalResourceLibrary asParameter hResInfo: hFind) 
		isNull 
			ifTrue: 
				[self error: 'Unable to load version resource from module: ' 
							, anExternalResourceLibrary printString].
	(address := (kernel lockResource: hRes) asExternalAddress) isNull 
		ifTrue: 
			[self error: 'Unable to lock version resource from module: ' 
						, anExternalResourceLibrary printString].
	^address!

new
	^super new initialize! !
!VersionResource class categoriesFor: #forModule:!instance creation!public! !
!VersionResource class categoriesFor: #forPath:!instance creation!public! !
!VersionResource class categoriesFor: #getVersionResourceOfModule:!enquiries!private! !
!VersionResource class categoriesFor: #new!instance creation!public! !

