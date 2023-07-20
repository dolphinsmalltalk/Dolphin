"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.File'
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
			'AccessFlagsMask' -> -16r8.
			'CheckModes'
				-> (IdentityDictionary withAll: {
								#append -> 16rC0000003.
								#create -> 16rC0000001.
								#open -> 16rC0000003.
								#read -> 16r80000003.
								#truncate -> 16rC0000005
							}).
			'NoCheckModes'
				-> (IdentityDictionary withAll: {
								#append -> 16rC0000004.
								#create -> 16rC0000004.
								#open -> 16rC0000004.
								#read -> 16r80000004.
								#truncate -> 16rC0000002
							}).
			'OpenFlagsMask' -> 16r7.
			'PathDelimiters' -> '/\'.
			'ShareModes' -> (IdentityDictionary
						withAll: { #exclusive -> 16r0. #read -> 16r1. #readWrite -> 16r3. #write -> 16r2 }).
			'SniffSize' -> 16r1000
		}!
Core.File guid: (Core.GUID fromString: '{87b4c48a-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.File comment: 'File is a class that exposes low-level (e.g. unbuffered) file I/O operations. It also includes a number of class side methods for manipulating file names and manipulating the file system.

Instance Variables:
	handle		<ExternalHandle>. The Win32 file handle.
	spec			<String>. The file path.
	flags			<Integer>. Win32 file open and access mode flags.
	shareFlags	<Integer>. Win32 file sharing mode flags.
	intBuffer		<ByteArray>. Buffer passed to API functions to receive integer output values.

Class Variables:
	CheckModes		<IdentityDictionary>
	OpenFlagsMask		<Integer>
	NoCheckModes		<IdentityDictionary>
	AccessFlagsMask	<Integer>
	ShareModes		<IdentityDictionary>

'!
!Core.File categoriesForClass!System-Support! !
!Core.File methodsFor!

accessFlags
	"Private - Answer the Win32 access mode flags."

	^flags bitAnd: AccessFlagsMask!

asParameter
	"Answer the external representation of the receiver."

	^handle!

atEnd
	"Answer a Boolean indicating whether we are at the file's end
	or signal a FileException if the operation fails."

	^self position = (self size - 1)
!

basicFree
	"Private - Close the file and nil the handle.
	Signal a FileException if the operation fails."

	| fh |
	fh := handle.
	handle := nil.
	(Kernel32 closeHandle: fh) ifFalse: [self signalOsError: false]!

beSparse
	"Instruct Windows to store the file in sparse form. This allows very very large files to be
	stored if they have large empty (zero) regions. This will throw an error if the file system
	does not support sparse files, or if the file has not been opened with write permissions."

	(Kernel32
		deviceIoControl: self asParameter
		dwIoControlCode: FSCTL_SET_SPARSE
		lpInBuffer: nil
		nInBufferSize: 0
		lpOutBuffer: nil
		nOutBufferSize: 0
		lpBytesReturned: intBuffer
		lpoverlapped: nil) ifFalse: [Kernel32 systemError]!

checkBoundsOf: aStringOrByteArray startingAt: startIndex for: bytesToTransferInteger
	"Private - Signal a FileException if the bounds of the transfer are out of range."

	bytesToTransferInteger == 0 ifFalse: [
		(startIndex < 1 or: [startIndex > aStringOrByteArray basicSize])
			ifTrue: [self error: 'Invalid array index'].
		startIndex + bytesToTransferInteger - 1 > aStringOrByteArray basicSize
			ifTrue: [self error: 'Buffer too small']]!

close
	"Close the file. The file can be reopened (depending on the access mode).
	Signal a FileException if an error occurs."

	self free; beUnfinalizable!

creationTime
	"Answer a <FILETIME> identifying the point in time at which some data was
	last written to the file associated with the receiver."

	| answer |
	answer := FILETIME new.
	self
		getTimes: answer
		atime: nil
		mtime: nil.
	^answer!

delete
	"Private - Close the receiver and delete the associated file.
	Useful for finishing with temporary files."

	self free.
	self class delete: spec!

fileType
	^#(#disk #char #pipe) at: ((Kernel32 getFileType: self handle) bitAnd: 16rFFF) ifAbsent: #unknown!

flags: anInteger
	"Private - Save away the Win32 access and open flags."

	flags := anInteger!

flush
	"Force write modifications to disk (where possible).
	Signal a FileException if the operation fails."

	(Kernel32 flushFileBuffers: handle) ifFalse: [self signalOsError: false]!

free
	"Private - Close the file if it is not already closed.
	Signal a FileException if the operation fails."

	handle isNull ifFalse: [self basicFree]!

getTimes: ctime atime: atime mtime: mtime
	"Private - Get the receiver's time of creation, last access, and last modification, 
	all answered through the FILETIME arguments (which are treated as value holders
	and updated directly)."

	(Kernel32
		getFileTime: self asParameter
		lpCreationTime: ctime
		lpLastAccessTime: atime
		lpLastWriteTime: mtime) ifFalse: [Kernel32 systemError]!

handle
	"Answer the file handle."

	^handle!

isReadable
	"Answer true if the file is readable."

	^flags anyMask: GENERIC_READ!

isWriteable
	"Answer whether the receiver can be written to."

	^flags anyMask: GENERIC_WRITE!

lastAccessTime
	"Answer a <FILETIME> identifying the point in time at which some data was
	last written to the file associated with the receiver."

	| answer |
	answer := FILETIME new.
	self
		getTimes: nil
		atime: answer
		mtime: nil.
	^answer!

lastWriteTime
	"Answer a <FILETIME> identifying the point in time at which some data was
	last written to the file associated with the receiver."

	| answer |
	answer := FILETIME new.
	self
		getTimes: nil
		atime: nil
		mtime: answer.
	^answer!

name
	"Answer the receiver's filename."

	^spec
!

open
	"Open, or reopen, the file described by the receiver with the receiver's
	access and sharing modes.
	 If the operation fails then a resumable FileException is signalled. If
	the exception is handled and resumed, then a further attempt is made
	to open the file. This allows for easy implementation of '	retry' style
	functionality."

	| fh |
	
	[fh := Kernel32
				createFile: spec
				dwDesiredAccess: self accessFlags
				dwSharedMode: shareFlags
				lpSecurityAttributes: self securityAttributes
				dwCreationDistribution: self openFlags
				dwFlagsAndAttributes: FILE_ATTRIBUTE_NORMAL
				hTemplateFile: nil.
	fh isInvalid]
			whileTrue: [self signalOsError: true].
	handle := fh.
	self beFinalizable!

open: aStringFileName flags: flagsInteger share: shareFlagsInteger
	"Private - Open the file described by aString using the specified
	Win32 access and open flags (bitOr'd together), and share flags"
	
	self
		free;
		spec: aStringFileName;
		flags: flagsInteger;
		shareFlags: shareFlagsInteger;
		open!

open: aString mode: modeSymbol check: aBoolean share: shareSymbol
	"Open a file for read and/or write access. The mode symbol, modeSymbol, determines
	what file opening mode to use when opening the file. modeSymbol can be one of
	the three ANSI (posix based) modes:

		#create	- 	open an existing file, or create a new file, for read/write,
					positioned at the beginning
		#append	- 	open an existing file, or create a new file, for read/write
					and position to the end
		#truncate	-	open an existing file truncating existing contents, or
					create a new file, for read/write.

	Or one of two additional modes:

		#read	-	open an existing file, or create a new file, for read-only access
		#open	-	open an existing file, or create a new file, for read/write access

	Although some of these modes are similar, and are sometimes synonyms, there may be subtle
	differences depending on the value of the check flag. The check flag, aBoolean,
	determines whether or not errors are reported according to the following rules:

		If mode = #create and the file exists
			If check = true raise an error, else use the existing file
		If mode = #append and the file does not exist
			If check = true raise an error, else create a new file
		If mode = #truncate and the file does not exist
			If check = true raise an error, else create a new file
		If mode = #read and the file does not exist
			If check = true raise an error, else create a new file (for read only)
		If mode = #open and the file does not exist
			If check = true raise an error, else create a new file (for read/write)

	The shareSymbol can be one of:
		#exclusive
		#read
		#write
		#readWrite"

	self open: aString
			flags: ((aBoolean ifTrue: [CheckModes] ifFalse: [NoCheckModes]) at: modeSymbol)
			share: (ShareModes at: shareSymbol).
	modeSymbol == #append
		ifTrue: [self setToEnd]!

openFlags
	"Private - Answer the Win32 creation mode flags."

	^flags bitAnd: OpenFlagsMask!

pathName
	"Answer the actual path name of the open file."

	^Kernel32 getFinalPathNameByHandle: handle!

position
	"Answer the absolute Integer position of the receiver's file pointer
	or signal a FileException if the operation fails."

	^self seek: 0 sense: FILE_CURRENT
!

position: anInteger 
	"Move the receiver's file pointer to the <integer> argument,
	which is a zero-based offset from the start of the file. 
	Answer the <integer> offset achieved or signal a <FileException> 
	if the operation fails."

	^self seek: anInteger sense: FILE_BEGIN!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: spec; space;
		print: handle;
		nextPut: $)!

read: aByteObject
	"Read into aStringOrByteArray a maximum of aByteObject size bytes
	from the file.
	Answer the number of bytes or signal a FileException if the operation fails."

	^self
		read: aByteObject
		count: aByteObject basicSize
!

read: anAddress count: bytesToReadInteger
	"Read a maximum of bytesToReadInteger bytes into anAddress from the file.

	It is not an error to read zero bytes.
	Answer the number of bytes read or signal a <FileException> if the operation fails."

	bytesToReadInteger == 0 ifTrue: [^0].
	^(Kernel32
		readFile: handle
		lpBuffer: anAddress
		nNumberOfBytesToRead: bytesToReadInteger
		lpNumberOfBytesRead: intBuffer
		lpOverlapped: nil) ifTrue: [intBuffer uint32AtOffset: 0] ifFalse: [self signalOsError: false]!

read: aStringOrByteArray startingAt: startIndex count: bytesToReadInteger
	"Read a maximum of bytesToReadInteger bytes from the file starting with aStringOrByteArray at: startIndex.

	It is not an error to read zero bytes.
	It is an error if aStringOrByteArray is shorter than startIndex + bytesToReadInteger - 1.
	Answer the number of bytes read or signal a FileException if the operaion fails."

	^self
		checkBoundsOf: aStringOrByteArray
		startingAt: startIndex
		for: bytesToReadInteger;

		read: aStringOrByteArray yourAddress + startIndex - 1
		count: bytesToReadInteger.

!

readByte
	"Answer the Integer value of the next byte from the file or nil if the receiver
	is positioned past the current EOF.
	Signal a FileException if an error occurs."

	| buffer |
	buffer := ByteArray new: 1.
	^(self read: buffer count: 1) == 0 ifTrue: [nil] ifFalse: [buffer at: 1]!

readWriteStream
	"Answer a FileStream on the receiver initially configured to read/write text."

	^FileStream on: self!

reset
	"Move the receiver's file pointer to the begining of the file.
	Signal a FileException if the operation fails."

	self position: 0
!

securityAttributes
	"Answer the <SECURITY_ATTRIBUTES> to be used when opening the file,
	or nil if the default security attributes are to be used.
	N.B. Must be nil (or NULL) on Win9X machines as only supported on NT."

	^nil!

seek: offsetInteger sense: senseFlag
	"Move the receiver's file pointer to the <integer> position, offsetInteger, relative to the
	postition indicated by the <integer> code senseFlagInteger. The sense flag must be one
	FILE_BEGIN, FILE_CURRENT, or FILE_END. Answer the absolute integer position achieved, or
	signal a FileException if the operation fails."

	"Note that it is not an error to advance the file position beyond the end of file, even for
	a file opened in read-only mode."

	^(Kernel32
		setFilePointerEx: handle
		liDistanceToMove: offsetInteger
		lpNewFilePointer: intBuffer
		dwMoveMethod: senseFlag)
			ifTrue: 
				["Although the theoretical NTFS file size limit is 2**64 - 1024, this API is
			limited to 2**63-1. Note that the lpNewFilePointer parameter is actually
			signed, although it should never be negative."
				intBuffer int64AtOffset: 0]
			ifFalse: [self signalOsError: false]!

setHandle: anExternalHandle flags: anInteger
	"Private - Set the handle inst var to aHandle."

	handle := anExternalHandle.
	flags := anInteger.
	intBuffer := ByteArray newFixed: 8!

setToEnd
	"Move the receiver's file pointer to the end of the file.
	Answer the absolute integer position achieved or
	signal a FileException if the operation fails."

	^self seek: 0 sense: FILE_END
!

shareFlags
	^shareFlags!

shareFlags: anInteger
	"Private - Save away the Win32 sharing mode."

	shareFlags := anInteger!

signalOsError: aBoolean
	"Private - Signal a FileException on this file with the current OS error.
	The <boolean> argument indicates whether the exception should be 
	resumable or not."

	^FileException signalOn: self resumable: aBoolean!

size
	"Answer the size of the file in bytes or signal a <FileException> if the operation fails."

	^(Kernel32 getFileSizeEx: handle lpFileSize: intBuffer)
		ifTrue: [intBuffer uint64AtOffset: 0]
		ifFalse: [self signalOsError: false]!

size: anInteger
	"Set the size of the file to the <integer> argument number of bytes
	(can be used to truncate or extend a file)."

	self position: anInteger.
	(Kernel32 setEndOfFile: handle) ifFalse: [self signalOsError: false]!

sniffEncoding
	| ituResult buf count |
	buf := ByteArray newFixed: SniffSize + 4.
	self reset.
	count := self read: buf count: SniffSize.
	buf int32AtOffset: SniffSize put: -1.
	^((AdvApi32
		isTextUnicode: buf
		iSize: count
		lpiResult: buf yourAddress + SniffSize) and: 
				[ituResult := buf uint32AtOffset: SniffSize.
				(ituResult anyMask: IS_TEXT_UNICODE_REVERSE_MASK)
					ifTrue: [self error: 'Unsupported unicode text encoding #utf16be'].
				"If the match is only statistical, then ignore it if there are less than 128 bytes as there are too many false positives for short ASCII sequences"
				count > 128 or: [(ituResult bitAnd: IS_TEXT_UNICODE_UNICODE_MASK) ~= IS_TEXT_UNICODE_STATISTICS]])
		ifTrue: 
			[self position: ((ituResult allMask: IS_TEXT_UNICODE_SIGNATURE) ifTrue: [2] ifFalse: [0]).
			String.EncodingUtf16]
		ifFalse: 
			["If it starts with the UTF-8 BOM ( #[16rEF 16rBB 16rBF]), then we can be 99% certain it is UTF-8"
			(buf beginsWith: Utf8String.Bom)
				ifTrue: 
					[self position: 3.
					String.EncodingUtf8]
				ifFalse: 
					[| utf8Stream |
					self reset.
					"Do a minimal evaluation of the unknown encoding. If the sniff block read as UTF-8 (allowing for that fact that we may have truncated the final character) then assume it is UTF-8, otherwise some ANSI code page."
					utf8Stream := (Utf8String fromByteArray: buf) readStream.
					((utf8Stream skipTo: Character.Replacement) not or: [utf8Stream atEnd])
						ifTrue: [String.EncodingUtf8]
						ifFalse: [String.EncodingAnsi]]]!

spec: aString
	"Private - Set the file path to the <readableString> argument."

	spec := aString!

write: aStringOrByteArray
	"Write all of aStringOrByteArray to the file.
	Answer the number of bytes written or signal a FileException if the operation fails."

	^self
		write: aStringOrByteArray
		count: aStringOrByteArray basicSize.!

write: aStringOrByteArrayOrAddress count: bytesToWriteInteger
	"Write bytesToWriteInteger bytes from aStringOrByteArrayOrAddress to the file.

	It is not an error to write zero bytes.
	Answer the number of bytes written or signal a <FileException> if the operation fails."

	bytesToWriteInteger == 0 ifTrue: [^0].
	^(Kernel32
		writeFile: handle
		lpBuffer: aStringOrByteArrayOrAddress
		nNumberOfBytesToWrite: bytesToWriteInteger
		lpNumberOfBytesWritten: intBuffer
		lpOverlapped: nil) ifTrue: [intBuffer uint32AtOffset: 0] ifFalse: [self signalOsError: false]!

write: aStringOrByteArray startingAt: startIndex count: bytesToWriteInteger
	"Write bytesToWriteInteger bytes to the file starting with aStringOrByteArray at: startIndex.

	It is not an error to write zero bytes.
	It is an error if aStringOrByteArray is shorter than startIndex + bytesToWriteInteger - 1.
	Answer the number of bytes written or signal a FileException if the operation fails."

	^self
		checkBoundsOf: aStringOrByteArray
			startingAt: startIndex
			for: bytesToWriteInteger;
		write: (External.Address fromInteger: aStringOrByteArray yourAddress + startIndex - 1)
			count: bytesToWriteInteger!

writeByte: anIntegerOrCharacter
	"Write the given byte to the file.
	Answer 1 or signal a FileException if the operation fails."

	^self write: (ByteArray with: anIntegerOrCharacter asInteger) count: 1! !
!Core.File categoriesForMethods!
accessFlags!accessing!private! !
asParameter!converting!public! !
atEnd!public!testing! !
basicFree!private!realizing/unrealizing! !
beSparse!converting!public! !
checkBoundsOf:startingAt:for:!helpers!private! !
close!operations!public! !
creationTime!accessing!public! !
delete!operations!private! !
fileType!accessing!public! !
flags:!accessing!private! !
flush!operations!public! !
free!private!realizing/unrealizing! !
getTimes:atime:mtime:!accessing!private! !
handle!accessing!public! !
isReadable!public!testing! !
isWriteable!public!testing! !
lastAccessTime!accessing!public! !
lastWriteTime!accessing!public! !
name!accessing!public! !
open!operations!public! !
open:flags:share:!operations!private! !
open:mode:check:share:!operations!public! !
openFlags!accessing!private! !
pathName!accessing!public! !
position!positioning!public! !
position:!operations!positioning!public! !
printOn:!printing!public! !
read:!operations!public! !
read:count:!operations!public! !
read:startingAt:count:!operations!public! !
readByte!operations!public! !
readWriteStream!public!streaming! !
reset!positioning!public! !
securityAttributes!accessing!public! !
seek:sense:!positioning!public! !
setHandle:flags:!initializing!private! !
setToEnd!positioning!public! !
shareFlags!accessing!private! !
shareFlags:!accessing!private! !
signalOsError:!exceptions!private! !
size!accessing!public! !
size:!operations!public! !
sniffEncoding!helpers!private! !
spec:!accessing!private! !
write:!operations!public! !
write:count:!operations!public! !
write:startingAt:count:!operations!public! !
writeByte:!operations!public! !
!

Core.File methodProtocol: #'streamable File' attributes: #(#readOnly) selectors: #(#close #flush #isReadable #isWriteable #position: #read:count: #reset #size #write:count:)!

!Core.File class methodsFor!

appendPathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator appended to create the correct syntax for
	a path. If aString already ends in a path separator then the answer is equivalent."

	| count |
	count := aString size.
	(count ~~ 0 and: [self pathDelimiters identityIncludes: (aString at: count)]) ifTrue: [^aString].
	^aString copyWith: self pathDelimiter!

attributes: aFileNameString
	^Kernel32 getFileAttributes: aFileNameString!

attributesEx: aString
	"Answer the <WIN32_FILE_ATTRIBUTE_DATA> for the file with the specified path, or nil if no such file exists."

	| attributes |
	attributes := WIN32_FILE_ATTRIBUTE_DATA newBuffer.
	^(KernelLibrary default
		getFileAttributesEx: aString
		fInfoLevelId: 0
		lpFileInformation: attributes) ifTrue: [attributes]!

canonicalizePath: aString
	"Converts the path <String> argument into a canonical form, removing any embedded '..' and '.' components, and adding a long path prefix if required."

	^PathCch pathCanonicalize: aString dwFlags: PATHCCH_ALLOW_LONG_PATHS!

commonPrefixOf: pathString1 and: pathString2
	"Answer the <readableString> common prefix shared between the two paths.
	This will be empty if the paths share no common prefix."

	| prefix len path1 path2 |
	path1 := pathString1 asUtf16String.
	path2 := pathString2 asUtf16String.
	len := Shlwapi
				pathCommonPrefix: path1
				pszFile2: path2
				achPath: nil.
	len == 0 ifTrue: [^''].
	prefix := Utf16String newFixed: len.
	Shlwapi
		pathCommonPrefix: path1
		pszFile2: path2
		achPath: prefix.
	^prefix!

composePath: aPathString stem: aStemString extension: anExtensionString
	"Composes a full pathname from its components. The path or extension components 
	can be nil if necessary. The path can include the drive letter."

	^self makePath: {nil. aPathString. aStemString. anExtensionString}!

composePath: pathString subPath: subpathString
	"Composes a full pathname from path and subpath components."

	^PathCch
		pathCombine: pathString
		pszMore: subpathString
		dwFlags: PATHCCH_ALLOW_LONG_PATHS!

composeShortStem: aStemString extension: anExtensionString 
	"Answer a String which is a file name abbreviated from aStemString and anExtensionString.
	Lower case vowels are dropped from the right of aStemString until it is less than
	or equal to 8 characters.
	If still longer than 8 chars, then other lowercase letters are dropped from the
	right of the stem until it is less than or equal to 8 characters."

	| stemResult extResult |
	stemResult := self shortenComponent: aStemString max: 8.
	extResult := self shortenComponent: anExtensionString max: 3.
	^self composeStem: stemResult extension: extResult!

composeStem: aStemString extension: anExtensionString
	"Composes a full pathname from aStemString and anExtensionString components.
	Implementation Note: This could be implemented in terms of #composePath:stem:extension:,
	which ultimately is implemented in terms of #makePath:, however it is a very frequently
	used method so an optimized version which takes advantage of private knowledge of
	how file names are constructed is warranted. Note that the dot separator may be
	specified in the extension, or not."

	^(anExtensionString at: 1) == $.
		ifTrue: [aStemString, anExtensionString]
		ifFalse: [aStemString, '.', anExtensionString]!

copy: oldFileNameString to: newFileNameString
	"Copy the file specified by oldFileNameString to newFileNameString.
	Signal a HostSystemError if the copy fails."

	Kernel32 copyFile: oldFileNameString to: newFileNameString!

createDirectory: path
	"Create a directory with the specified path. Answer whether the directory was actually created, or already existed.
	Raise a Win32Error if the call fails for any other reason than that the directory already exists."

	^Kernel32 createDirectory: path!

createDirectoryPath: path
	"Create a directory tree with the specified path - i.e. this will create a nested set of directories
	to any depth. Answer true if the final directory 	was actually created, or false if it already existed. 
	Raise a Win32Error if the call fails for any other reason than that the directory already exists.
	Implementation Note: This may attempt more directory creation operations than are necessary,
	(e.g. to create the root directory if a drive is specified) but such requests are ignored."

	| delims pos created len |
	created := false.
	len := path size.
	delims := self pathDelimiters.
	(path beginsWith: '\\')
		ifTrue: 
			[pos := 3.
			2 timesRepeat: 
					["Skip UNC machine name and share, or long path prefix"
					pos := path indexOfAnyOf: delims startingAt: pos.
					pos == 0 ifTrue: [^Win32Error signalWith: Win32Errors.ERROR_INVALID_NAME].
					pos := pos + 1]]
		ifFalse: [pos := 1].
	[pos <= len] whileTrue: 
			[| end |
			end := path indexOfAnyOf: delims startingAt: pos.
			end == 0 ifTrue: [end := len + 1].
			end == 1
				ifFalse: 
					[| part |
					(part := path copyFrom: 1 to: end - 1) lastCodeUnit == $:
						ifFalse: 
							["Don't attempt to create the drive!!"
							created := self createDirectory: part]].
			pos := end + 1].
	^created!

createTemporaryDirectory
	"Create a new, unique, temporary directory, and answer it's <readableString> path. It is the caller's responsibility to delete the directory when done."

	| path |
	path := self composePath: self tempPath subPath: GUID newUnique idlString.
	self createDirectory: path.
	^path!

default: pathString extension: extString
	"Defaults the extension of pathString to extString if there is no current extension.
	Answers the filename with new or existing extension."

	| i size |
	i := size := pathString size.
	
	[i == 0 or: 
			[| ch |
			ch := pathString at: i.
			ch == $.
				ifTrue: 
					["Extension delimiter located"
					^i = size
						ifTrue: 
							["Existing extension is empty"
							extString size == 0
								ifTrue: [pathString copyFrom: 1 to: i - 1]
								ifFalse: 
									[(extString at: 1) == $.
										ifTrue: [(pathString copyFrom: 1 to: i - 1) , extString]
										ifFalse: [(pathString copyFrom: 1 to: i) , extString]]]
						ifFalse: 
							["Existing non-empty extension, leave unchanged"
							pathString]].
			"If we find another path separator while searching backward, then there is no existing extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^extString size == 0
		ifTrue: [pathString]
		ifFalse: 
			[(extString at: 1) == $. ifTrue: [pathString , extString] ifFalse: [pathString , '.' , extString]]!

delete: aFileNameString
	"Deletes the file whose name is specified by aFileNameString.
	Signal a Win32Error if the operation fails."

	(Kernel32 deleteFile: aFileNameString) ifFalse: [Kernel32 systemError]!

deleteDirectory: aString
	"Recursively delete all files and folders within the specified directory, and
	remove the directory itself."

	self 
		forAll: '*.*'
		in: aString
		do: 
			[:each | 
			each isDirectory 
				ifTrue: 
					[| filename |
					filename := each fileName.
					(filename = '.' or: [filename = '..']) 
						ifFalse: [self deleteDirectory: each path]]
				ifFalse: [self delete: each path]].
	^self removeDirectory: aString!

exists: aFileNameString
	"Answer true if there is a file whose specification is given by aFileName."

	^(self attributes: aFileNameString) ~= -1!

extensionDelimiter
	"Answers the character that delimits a filename from its extension"

	^ $.!

fileSize: aString
	"Answer the <integer> byte size of the file with the specified path, or nil if no such file exists."

	^(self attributesEx: aString) ifNotNil: [:attributes | attributes fileSize]!

find: fileSpec
	"Answer a collection of WIN32_FIND_DATA structs for each file matching the 
	wildcarded path string, fileSpec. e.g:

		| list |
		list := ListPresenter show.
		list list: ((File find: '*.*') collect: [:s | s fileName])
	"

	| answer |
	answer := OrderedCollection new.
	self for: fileSpec do: [:s | answer add: s copy].
	^answer!

for: aString do: operation
	"For each file/directory matching the wildcarded path string argument, aString, 
	evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing 
	the file/directory as the argument."

	^self
		for: aString
		in: (File splitPathFrom: aString)
		do: operation!

for: matchString in: dirString do: operation
	"For each file/directory matching the wildcarded string argument, matchString, in the directory named, dirString, evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the file/directory as the argument."

	| hFind findStruct pattern |
	findStruct := WIN32_FIND_DATAW newBuffer.
	findStruct directory: dirString.
	pattern := self composePath: dirString subPath: matchString.
	hFind := Kernel32 findFirstFile: pattern lpFindFileData: findStruct.
	hFind isInvalid
		ifTrue: 
			[| err |
			err := Kernel32 getLastError.
			^(err == Win32Errors.ERROR_FILE_NOT_FOUND or: [err == Win32Errors.ERROR_ACCESS_DENIED])
				ifFalse: [Kernel32 systemError: err]].
	
	[| error |
	
	[operation value: findStruct.
	Kernel32 findNextFile: hFind lpFindFileData: findStruct] whileTrue.
	error := Kernel32 getLastError.
	error == Win32Errors.ERROR_NO_MORE_FILES ifFalse: [^Kernel32 systemError: error]]
			ensure: [Kernel32 findClose: hFind]!

forAll: matchString in: dirString do: operation
	"For each file or directory matching the wildcarded path string, fileSpec, 
	in and below the directory identified by the <readableString>, dir, evaluate 
	the <monadicValuable>, operation, with a WIN32_FIND_DATA describing 
	the file/directory as the argument."

	self 
		for: matchString
		in: dirString
		do: [:each | operation value: each].
	self forDirectoriesIn: dirString
		do: 
			[:each | 
			self 
				forAll: matchString
				in: each path
				do: operation]!

forAllDirectories: matchString in: pathString do: operation 
	"For each directory whose name matches the wildcarded <readableString> argument,
	matchString, in the directory identified by the <readableString> argument, pathString,
	(and recursively below that), evaluate the monadic valuable, operation, with a 
	WIN32_FIND_DATA describing the directory as the argument."

	"Implementation Note: The tree traversal is pre-order, depth-first."

	self 
		forDirectories: matchString
		in: pathString
		do: 
			[:each | 
			operation value: each.
			self 
				forAllDirectories: matchString
				in: each path
				do: operation]!

forAllDirectoriesIn: aString do: operation
	"For each directory in the directory identified by the <readableString> argument,
	and recursively below that, evaluate the monadic valuable, operation, with a 
	WIN32_FIND_DATA describing the directory as the argument.
	Implementation Note: The tree traversal is pre-order, depth-first."

	^self 
		forAllDirectories: '*.*'
		in: aString
		do: operation!

forDirectories: matchString in: dirString do: operation
	"For each directory in the directory identified by the <readableString> argument, 
	dir, evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the 
	directory as the argument."

	self 
		for: matchString
		in: dirString
		do: 
			[:each | 
			(each isDirectory and: 
					[| fileName |
					fileName := each fileName.
					fileName ~= '.' and: [fileName ~= '..']]) 
				ifTrue: [operation value: each]]!

forDirectoriesIn: aString do: operation
	"For each directory in the directory identified by the <readableString> argument 
	evaluate the monadic valuable, operation, with a WIN32_FIND_DATA describing the 
	directory as the argument."

	^self 
		forDirectories: '*.*'
		in: aString
		do: operation!

fromHandle: aHandle 
	"Answer a new instance of the receiver on the specified file handle.
	The instance will not automatically close the handle before it is GC'd (it assumes
	it does not own it)."

	^(super new)
		setHandle: aHandle asExternalHandle flags: ##(GENERIC_READ | GENERIC_WRITE);
		yourself!

fullPathOf: aPathnameString
	"Answers the full path of aPathnameString"

	^Kernel32 getFullPathName: aPathnameString!

fullPathOf: aPathnameString relativeTo: aBasePathString
	"Answers the full path of aPathnameString. If this is a truly relative
	path then it is formed as relative to aBasePathString"

	| actualPath |
	actualPath := (self isRelativePath: aPathnameString) 
		ifTrue: [self composePath: aBasePathString subPath: aPathnameString]
		ifFalse: [aPathnameString].
	^self fullPathOf: actualPath
!

initialize
	"Initialize the Class Variables of the receiver:
		File initialize

		OpenFlagsMask		Mask to extract the open mode flags.
		AccessFlagsMask	Mask to extract the access mode flags.
		ShareModes		Map between portable share mode symbols and Win32 flag values.
		CheckModes	 	Map between portable access mode symbols and Win32 flag values 
						with error checking.
		NoCheckModes		Ditto, without error checking."

	self addClassConstant: 'ShareModes'
		value: (IdentityDictionary withAll: {
						#read -> FILE_SHARE_READ.
						#readWrite -> (FILE_SHARE_READ | FILE_SHARE_WRITE).
						#write -> FILE_SHARE_WRITE.
						#exclusive -> 0
					}).
	"open will only ever open an existing file"
	self addClassConstant: 'CheckModes'
		value: (IdentityDictionary withAll: {
						#read -> (OPEN_EXISTING | GENERIC_READ).
						#create -> (CREATE_NEW | GENERIC_READ | GENERIC_WRITE).
						#open -> (OPEN_EXISTING | GENERIC_READ | GENERIC_WRITE).
						#append -> (OPEN_EXISTING | GENERIC_READ | GENERIC_WRITE).
						#truncate -> (TRUNCATE_EXISTING | GENERIC_READ | GENERIC_WRITE)
					}).
	"No check read is a bit of a nonsense, but ..."
	self addClassConstant: 'NoCheckModes'
		value: (IdentityDictionary withAll: {
						#read -> (OPEN_ALWAYS | GENERIC_READ).
						#create -> (OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE).
						#open -> (OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE).
						#append -> (OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE).
						#truncate -> (CREATE_ALWAYS | GENERIC_READ | GENERIC_WRITE)
					})!

isDirectory: aString
	"Answer true if there is a directory whose path is given by aString."

	| attribs |
	attribs := self attributes: aString.
	^attribs ~= -1 and: [attribs allMask: FILE_ATTRIBUTE_DIRECTORY]!

isRelativePath: aFileNameString
	"Answers true if aFileNameString is a relative path with no absolute components"

	^Shlwapi pathIsRelative: aFileNameString!

isRootPath: aString
	"Answer whether the <String> argument is a root path, e.g. 'c:\'"

	^PathCch pathCchIsRoot: aString!

isWriteable: aString
	"Answer whether the file at the specified path is writeable. If there is no such file, then
	the answer will be true. If there file exists then the answer is based on file's attributes
	- i.e. whether or not it has the read-only flag set. Note that file permissions are not
	taken into account, so even if the answer is true a subsequent attempt to open the file for
	writing may fail."

	| attributes |
	attributes := Kernel32 getFileAttributes: aString.
	^(attributes ~= -1 and: [attributes allMask: FILE_ATTRIBUTE_READONLY]) not!

isWriteable: aString set: aBoolean
	"Set the writeable state of the file with path, aString, to aBoolean. Answers true if the operation succeeds"

	| attributes |
	attributes := Kernel32 getFileAttributes: aString.
	attributes == -1 ifTrue: [Kernel32 systemError].
	(Kernel32 setFileAttributes: aString
		value: (attributes mask: FILE_ATTRIBUTE_READONLY set: aBoolean not))
			ifFalse: [Kernel32 systemError]!

lastWriteTime: aString
	"Answer a <FILETIME> representing the time when the file with the specified filename was last modified, or nil if no such file exists."

	^(self attributesEx: aString) ifNotNil: [:attributes | attributes ftLastWriteTime]!

locateFilename: aFilenameString in: searchPath 
	"Answers the full pathname of aFilenameString searched for in the ordered collection
	of paths provided in searchPath. If aFilenameString includes a directory then it is
	answered. Otherwise the file is searched for in the directories in searchPath. If the
	file is not found in any of these directories then aFilenameString is answered"

	(self splitPathFrom: aFilenameString) isEmpty 
		ifTrue: 
			[searchPath do: 
					[:each | 
					| fullpath |
					fullpath := self composePath: each subPath: aFilenameString.
					(self exists: fullpath) ifTrue: [^fullpath]]].
	^aFilenameString!

makePath: anArray
	"Composes a full pathname from its path, stem and extension components.
	The path and extension components can be nil or the empty string if the path
	does not have either of these components. The stem must be a non-empty String."

	| size drive dir fname ext path |
	size := 0.
	(anArray at: 1)
		ifNotNil: 
			[:d |
			"Assume the drive doesn't have the colon and that _makepath_s will add it"
			drive := d asUtf8String.
			size := drive size + 1].
	(anArray at: 2)
		ifNotNil: 
			[:d |
			"Assume the terminating path separator is missing"
			dir := d asUtf8String.
			size := size + dir size + 1].
	(anArray at: 3)
		ifNotNil: 
			[:f |
			fname := f asUtf8String.
			size := size + fname size].
	(anArray at: 4)
		ifNotNil: 
			[:e |
			"Assume the dot is missing"
			ext := e asUtf8String.
			size := size + ext size + 1].
	path := Utf8String newFixed: size.
	Ucrt
		_makepath_s: path
		bufferSize: size + 1
		drive: drive
		dir: dir
		fname: fname
		ext: ext.
	^path trimNulls!

new
	"Answer a new initialized instance of the receiver."

	^(super new)
		setHandle: nil flags: 0;
		yourself!

open: aString
	"Open the file described by aString for exclusive read/write access.
	Answer the new instance or signal a FileException if the operation fails."

	^self open: aString mode: #open!

open: aString mode: aSymbol
	"Open a file for exclusive read/write access. The mode symbol, aSymbol, determines what file
	opening mode to use when opening the file. Errors will be reported if an attempt is made to
	open a file which does not or does not exist, depending on the access mode (see
	open:mode:check:share: for the rules)."

	^self open: aString mode: aSymbol check: true!

open: aString mode: aSymbol check: aBoolean
	"Open a file for exclusive read/write access. The mode symbol, aSymbol, determines what file
	opening mode to use when opening the file. The check flag, aBoolean, determines whether or
	not errors are reported (see open:mode:check:share: for the rules)"

	"This method provides for ANSI (Posix) style file opening and is potentially
	more portable than those methods which require Win32 flags."

	^self open: aString mode: aSymbol check: aBoolean share: #exclusive!

open: aString mode: modeSymbol check: aBoolean share: shareSymbol
	"Open a file for read/write access. The mode symbol, modeSymbol, determines what file
	opening mode to use when opening the file. The check flag, aBoolean, determines whether or
	not errors are reported. See instance method for further details."

	^self new open: aString mode: modeSymbol check: aBoolean share: shareSymbol!

path: pathString extension: extString
	"Answer a full pathname with the specified extension, whether or not pathString already has
	an extension."

	| i |
	i := pathString size.
	
	[i == 0 or: 
			[| ch |
			ch := pathString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the existing extension"
					^extString size == 0
						ifTrue: 
							["New extension is empty, so just remove the existing one"
							pathString copyFrom: 1 to: i - 1]
						ifFalse: 
							[(extString at: 1) == $.
								ifTrue: [(pathString copyFrom: 1 to: i - 1) , extString]
								ifFalse: [(pathString copyFrom: 1 to: i) , extString]]].
			"If we find another path separator while searching backward, then there is no existing extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^extString size == 0
		ifTrue: [pathString]
		ifFalse: 
			[(extString at: 1) == $. ifTrue: [pathString , extString] ifFalse: [pathString , '.' , extString]]!

pathDelimiter
	"Answers the character that delimits a path (or parts thereof)"

	^ $\!

pathDelimiters
	"Answers the characters that can be used to delimits a path (or parts thereof).	
	Windows tends to accept the Unix delimiter, a forward slash, as well as its own
	back slash."

	^PathDelimiters!

readAllBytes: aString
	"Open the file at the specified path, read and answer all of the binary data it contains.
	The file is guaranteed to be closed, even if an exception occurs."

	| file |
	file := self
				open: aString
				mode: #read
				check: true
				share: #read.
	^
	[| size buffer |
	size := file size.
	buffer := ByteArray newFixed: size.
	file read: buffer count: size.
	buffer]
			ensure: [file close]!

readAllText: aString
	"Open the file at the specified path, read and answer all of the text it contains. The file
	is guaranteed to be closed, even if an exception occurs."

	| file |
	file := self
				open: aString
				mode: #read
				check: true
				share: #read.
	^
	[| size buffer bufferClass |
	bufferClass := {AnsiString. Utf8String. Utf16String} at: file sniffEncoding + 1.
	size := file size - file position.
	buffer := bufferClass newFixed: size / bufferClass elementSize.
	file read: buffer count: size.
	buffer]
			ensure: [file close]!

relativePathOf: aPathString to: aBasePathString
	"Answers the relative path of aPathString relative to aBasePathString.
	Note that if the last component of aBasePathString is to be considered a directory
	then there must be a trailing slash, otherwise the last component is ignored (it is
	treated as if it were a file name)."

	| relPath toPath |
	#todo. "Relative paths cannot be long, but the from/to paths theoretically could be. The API itself does not support long filenames, so will have to be replaced."
	relPath := Utf16String newFixed: MAX_PATH.
	toPath := aPathString asUtf16String.
	relPath := (Shlwapi
				pathRelativePathTo: relPath
				pszFrom: aBasePathString
				dwAttrFrom: 0
				pszTo: toPath
				dwAttrTo: 0) ifTrue: [relPath] ifFalse: [toPath].
	^(relPath beginsWith: '.\')
		ifTrue: [relPath copyFrom: 3 to: relPath strlen]
		ifFalse: [relPath trimNulls]!

removeDirectory: aString
	(Kernel32 removeDirectory: aString) ifFalse: [Kernel32 systemError]!

removeExtension: aString
	"Answer a <readableString> which is the path argument with the extension component removed."

	| i |
	i := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the extension"
					^aString copyFrom: 1 to: i - 1].
			"If we find another path separator while searching backward, then there is no extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^aString!

removePathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator at its end, if any, removed."

	| count |
	count := aString size.
	"In this case we know that the path delimiters only ever require one code unit (they are all ascii characters), so it is safe to work with code units"
	^(count ~~ 0 and: 
			[| ch |
			ch := aString at: count.
			ch == $\ or: [ch == $/]])
		ifTrue: [aString copyFrom: 1 to: count - 1]
		ifFalse: [aString]!

rename: oldFileNameString to: newFileNameString
	"Rename the file specified in oldFileNameString to newFileNameString.
	Signal a HostSystemError if the operation fails."

	(Kernel32 moveFile: oldFileNameString lpNewFileName: newFileNameString)
		ifFalse: [Kernel32 systemError]!

replacePath: filePath with: newPath
	"Replace the path component of the full path name, filePath, with the new path name,
	newPath, i.e. only the stem and extension remain intact."

	| oldPathComponents |
	oldPathComponents := self splitPath: filePath.
	oldPathComponents 
		at: 1 put: nil;			"new path can include drive letter"
		at: 2 put: newPath.
	^self makePath: oldPathComponents!

shortenComponent: aString max: anInteger 
	| abbreviated |
	abbreviated := aString.
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated select: [:c | c isAlphaNumeric]].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isVowel and: [c isLowercase and: [len > anInteger]]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger 
		ifTrue: 
			[| len |
			len := abbreviated size.
			abbreviated := abbreviated reverse.
			abbreviated := abbreviated select: 
							[:c | 
							| useChar |
							(c isLowerCase and: [len > anInteger]) 
								ifTrue: 
									[useChar := false.
									len := len - 1]
								ifFalse: [useChar := true].
							useChar].
			abbreviated := abbreviated reverse].
	abbreviated size > anInteger ifTrue: [abbreviated := abbreviated leftString: anInteger].
	^abbreviated!

shortPathOf: aPathnameString
	"Answers the short path version of aPathnameString"

	^Kernel32 getShortPathName: aPathnameString!

sniffEncoding: aString
	"Answer a best guess at the encoding of the file with the specified path. If the file does
	not exist, an exception is raised."

	| file encoding |
	file := self
				open: aString
				mode: #read
				check: true
				share: #read.
	encoding := file sniffEncoding.
	file close.
	^String encodingName: encoding!

splitDriveFrom: aString
	"Splits the pathname, aString, and answers the drive portion.
	Answers an empty string if there is no drive component in the path."

	| drive |
	Ucrt
		_splitpath_s: aString asUtf8String
		drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
		driveLen: ##(CRTConstants._MAX_DRIVE + 1)
		dir: nil
		dirLen: 0
		fname: nil
		fnameLen: 0
		ext: nil
		extLen: 0.
	^drive trimNulls!

splitExtensionFrom: aString
	"Splits aPathname string and answers the extension portion.
	Answers the empty string if there is no extension."

	| i size |
	i := size := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					["We've found the start of the extension"
					^aString copyFrom: i + 1 to: size].
			"If we find another path separator while searching backward, then there is no extension"
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	^''!

splitFilenameFrom: aString
	"Splits the pathname, aString, and answers the file name portion (including extension).
	Answers an empty string if there is no filename component in the path."

	| i size |
	i := size := aString size.
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
		whileFalse: [i := i - 1].
	^aString copyFrom: i + 1 to: size!

splitPath: aString
	"Splits the pathname, aString, into its path, stem and extension components and answers 
	a four element Array of these.
	Note: We use the C-runtime library to implement this, hence either backward or forward
	slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	| max path drive dir fname ext |
	"To avoid problems with long filenames, we use the length of the input string as the buffer
	sizes - clearly the component parts can never be larger than this.  In order to support
	Unicode paths, we work in UTF-8."
	path := aString asUtf8String.
	max := path size.
	max = 0 ifTrue: [^{''. ''. ''. ''}].
	Ucrt
		_splitpath_s: path
		drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
		driveLen: ##(CRTConstants._MAX_DRIVE + 1)
		dir: (dir := Utf8String new: max)
		dirLen: max + 1
		fname: (fname := Utf8String new: max)
		fnameLen: max + 1
		ext: (ext := Utf8String new: max)
		extLen: max + 1.
	"CRT function includes leading period on extension, which we don't"
	^{drive trimNulls.
		dir trimNulls.
		fname trimNulls.
		ext copyFrom: (ext first == $. ifTrue: [2] ifFalse: [1]) to: ext strlen}!

splitPathFrom: aString
	"Splits the <String> argument, assumed to be a file path, and answers the path portion (including the drive letter, if any, and the terminating path separator).
	Answers an  empty <String> if there is no path."

	| i |
	i := aString size.
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
		whileFalse: [i := i - 1].
	^aString copyFrom: 1 to: i !

splitStemFrom: aString
	"Answers the file stem component of the path <String> argument, or an empty string if there
	is none."

	| i size |
	i := size := aString size.
	
	[i == 0 or: 
			[| ch |
			ch := aString at: i.
			ch == $.
				ifTrue: 
					[| end |
					"There is a file extension - stem must precede that"
					end := i := i - 1.
					[i == 0 or: 
							[ch := aString at: i.
							ch == $\ or: [ch == $/ or: [ch == $:]]]]
						whileFalse: [i := i - 1].
					^aString copyFrom: i + 1 to: end].
			ch == $\ or: [ch == $/ or: [ch == $:]]]]
			whileFalse: [i := i - 1].
	"No extension"
	^aString copyFrom: i + 1 to: size!

temporary
	"Open a temporary file with a unique name generated by the system, for
	exclusive read/write access."

	^self open: self temporaryFilename!

temporaryFilename
	"Answer a new unique temporary filename in the logged on user's temp directory (see
	#tempPath). Note that this must create the file in order to ensure uniqueness. You are
	responsible for deleting the file when you have finished with it."
	
	^self temporaryFilenameWithPrefix: ''
	!

temporaryFilenameWithPrefix: prefixString
	"Answer a temporary filename built from prefixString in the user's temporary files directory. Note that this will create the temp file in order to guarantee uniqueness. You are responsible for deleting the file when it is no longer required. Signals a Win32Error if the operation fails, e.g. if the tempPath is longer than MAX_PATH-14 as the API does not support long filenames."

	^Kernel32 getTempFileName: self tempPath lpPrefixString: prefixString!

tempPath
	"Answer the path of the directory designated for temporary files on the host system."

	^Kernel32 getTempPath!

windowsDirectory
	"Answer the path of the Windows directory on the host computer for the current session. Note
	that under Terminal Server this will be the shared Windows directory, not the per-user
	Windows directory. See MSDN KB281316  for further information."

	^Kernel32 getSystemWindowsDirectory!

workingDirectory
	"Answer the current working directory. The result always has a trailing separator."

	| dir |
	dir := Kernel32 getCurrentDirectory.
	^dir lastCodeUnit == $\ ifTrue: [dir] ifFalse: [dir , '\']!

workingDirectory: aString
	"Set the current working directory."

	^Kernel32 setCurrentDirectory: aString! !
!Core.File class categoriesForMethods!
appendPathDelimiter:!filename manipulation!public!testing! !
attributes:!enquiries!public! !
attributesEx:!enquiries!public! !
canonicalizePath:!filename manipulation!public! !
commonPrefixOf:and:!filename manipulation!public! !
composePath:stem:extension:!filename manipulation!public! !
composePath:subPath:!filename manipulation!public! !
composeShortStem:extension:!filename manipulation!public! !
composeStem:extension:!filename manipulation!public! !
copy:to:!file operations!public! !
createDirectory:!file operations!public! !
createDirectoryPath:!file operations!public! !
createTemporaryDirectory!file operations!public! !
default:extension:!filename manipulation!public! !
delete:!file operations!public! !
deleteDirectory:!file operations!public! !
exists:!enquiries!public! !
extensionDelimiter!constants!public! !
fileSize:!enquiries!public! !
find:!public!searching! !
for:do:!enumerating!public! !
for:in:do:!enumerating!public! !
forAll:in:do:!enumerating!public! !
forAllDirectories:in:do:!enumerating!public! !
forAllDirectoriesIn:do:!enumerating!public! !
forDirectories:in:do:!enumerating!public! !
forDirectoriesIn:do:!enumerating!public! !
fromHandle:!instance creation!public! !
fullPathOf:!filename manipulation!public! !
fullPathOf:relativeTo:!filename manipulation!public! !
initialize!development!initializing!public! !
isDirectory:!enquiries!public! !
isRelativePath:!enquiries!public! !
isRootPath:!filename manipulation!public! !
isWriteable:!enquiries!public! !
isWriteable:set:!file operations!public! !
lastWriteTime:!enquiries!public! !
locateFilename:in:!filename manipulation!public! !
makePath:!filename manipulation!public! !
new!instance creation!public! !
open:!instance creation!public! !
open:mode:!instance creation!public! !
open:mode:check:!instance creation!public! !
open:mode:check:share:!instance creation!public! !
path:extension:!filename manipulation!public! !
pathDelimiter!constants!public! !
pathDelimiters!constants!public! !
readAllBytes:!file operations!public! !
readAllText:!file operations!public! !
relativePathOf:to:!filename manipulation!public! !
removeDirectory:!file operations!public! !
removeExtension:!filename manipulation!public! !
removePathDelimiter:!filename manipulation!public! !
rename:to:!file operations!public! !
replacePath:with:!filename manipulation!public! !
shortenComponent:max:!helpers!private! !
shortPathOf:!filename manipulation!public! !
sniffEncoding:!enquiries!public! !
splitDriveFrom:!filename manipulation!public! !
splitExtensionFrom:!filename manipulation!public! !
splitFilenameFrom:!filename manipulation!public! !
splitPath:!filename manipulation!public! !
splitPathFrom:!filename manipulation!public! !
splitStemFrom:!filename manipulation!public! !
temporary!instance creation!public! !
temporaryFilename!helpers!public! !
temporaryFilenameWithPrefix:!helpers!public! !
tempPath!enquiries!public! !
windowsDirectory!enquiries!public! !
workingDirectory!enquiries!public! !
workingDirectory:!file operations!public! !
!

