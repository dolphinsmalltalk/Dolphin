"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.File'
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: 'CheckModes NoCheckModes ShareModes'
	imports: #(#{OS.Win32Constants private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
		'AccessFlagsMask' -> -16r8.
		'OpenFlagsMask' -> 16r7
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
	(KernelLibrary default closeHandle: fh) ifFalse: [self signalOsError: false]!

beSparse
	"Instruct Windows to store the file in sparse form. This allows very very large files to be
	stored if they have large empty (zero) regions. This will throw an error if the file system
	does not support sparse files, or if the file has not been opened with write permissions."

	| bytesReturnedBuf |
	bytesReturnedBuf := External.DWORDBytes new.
	(KernelLibrary default
		deviceIoControl: self asParameter
		dwIoControlCode: FSCTL_SET_SPARSE
		lpInBuffer: nil
		nInBufferSize: 0
		lpOutBuffer: nil
		nOutBufferSize: 0
		lpBytesReturned: bytesReturnedBuf
		lpoverlapped: nil) ifFalse: [KernelLibrary default systemError]!

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
	^#(#disk #char #pipe) at: ((KernelLibrary default getFileType: self handle) bitAnd: 16rFFF)
		ifAbsent: [#unknown]!

flags: anInteger
	"Private - Save away the Win32 access and open flags."

	flags := anInteger!

flush
	"Force write modifications to disk (where possible).
	Signal a FileException if the operation fails."

	(KernelLibrary default flushFileBuffers: handle) ifFalse: [self signalOsError: false]!

free
	"Private - Close the file if it is not already closed.
	Signal a FileException if the operation fails."

	handle notNull
		ifTrue: [self basicFree]!

getTimes: ctime atime: atime mtime: mtime
	"Private - Get the receiver's time of creation, last access, and last modification, 
	all answered through the FILETIME arguments (which are treated as value holders
	and updated directly)."

	(KernelLibrary default
		getFileTime: self asParameter
		lpCreationTime: ctime
		lpLastAccessTime: atime
		lpLastWriteTime: mtime) ifFalse: [KernelLibrary default systemError]!

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
	
	[fh := KernelLibrary default
				createFile: spec
				dwDesiredAccess: self accessFlags
				dwSharedMode: shareFlags
				lpSecurityAttributes: self securityAttributes
				dwCreationDistribution: self openFlags
				dwFlagsAndAttributes: FILE_ATTRIBUTE_NORMAL
				hTemplateFile: nil.
	fh asSignedInteger == -1]
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

	| kernel size buf |
	kernel := KernelLibrary default.
	size := kernel
				getFinalPathNameByHandle: handle
				lpszFilePath: nil
				cchFilePath: 0
				dwFlags: 0.
	buf := Utf16String newFixed: size - 1.
	kernel
		getFinalPathNameByHandle: handle
		lpszFilePath: buf
		cchFilePath: size
		dwFlags: 0.
	^buf!

position
	"Answer the absolute Integer position of the reciver's file pointer
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
	^(KernelLibrary default
		readFile: handle
		lpBuffer: anAddress
		nNumberOfBytesToRead: bytesToReadInteger
		lpNumberOfBytesRead: intBuffer
		lpOverlapped: nil) ifTrue: [intBuffer dwordAtOffset: 0] ifFalse: [self signalOsError: false]!

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

	^(KernelLibrary default
		setFilePointerEx: handle
		liDistanceToMove: offsetInteger
		lpNewFilePointer: intBuffer
		dwMoveMethod: senseFlag)
			ifTrue: 
				["Although the theoretical NTFS file size limit is 2**64 - 1024, this API is
			limited to 2**63-1. Note that the lpNewFilePointer parameter is actually
			signed, although it should never be negative."
				intBuffer sqwordAtOffset: 0]
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

	^(KernelLibrary default getFileSizeEx: handle lpFileSize: intBuffer)
		ifTrue: [intBuffer qwordAtOffset: 0]
		ifFalse: [self signalOsError: false]!

size: anInteger
	"Set the size of the file to the <integer> argument number of bytes
	(can be used to truncate or extend a file)."

	self position: anInteger.
	(KernelLibrary default setEndOfFile: handle) ifFalse: [self signalOsError: false]!

sniffEncoding
	| ituResult buf count |
	buf := ByteArray newFixed: 1024.
	count := self
				reset;
				read: buf.
	ituResult := (ByteArray newFixed: 4)
				sdwordAtOffset: 0 put: -1;
				yourself.
	^((AdvApiLibrary default
		isTextUnicode: buf
		iSize: count
		lpiResult: ituResult) and: 
				[ituResult := ituResult dwordAtOffset: 0.
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
					"Do a minimal evaluation of the unknown encoding. If the first 1k reads as UTF-8 (allowing for that fact that we may have truncated the final character) then assume it is UTF-8, otherwise some ANSI code page."
					utf8Stream := (Utf8String fromByteArray: buf) readStream.
					((utf8Stream skipTo: Character.Utf8Default) not or: [utf8Stream atEnd])
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
	^(KernelLibrary default
		writeFile: handle
		lpBuffer: aStringOrByteArrayOrAddress
		nNumberOfBytesToWrite: bytesToWriteInteger
		lpNumberOfBytesWritten: intBuffer
		lpOverlapped: nil) ifTrue: [intBuffer dwordAtOffset: 0] ifFalse: [self signalOsError: false]!

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
!Core.File categoriesFor: #accessFlags!accessing!private! !
!Core.File categoriesFor: #asParameter!converting!public! !
!Core.File categoriesFor: #atEnd!public!testing! !
!Core.File categoriesFor: #basicFree!private!realizing/unrealizing! !
!Core.File categoriesFor: #beSparse!converting!public! !
!Core.File categoriesFor: #checkBoundsOf:startingAt:for:!helpers!private! !
!Core.File categoriesFor: #close!operations!public! !
!Core.File categoriesFor: #creationTime!accessing!public! !
!Core.File categoriesFor: #delete!operations!private! !
!Core.File categoriesFor: #fileType!accessing!public! !
!Core.File categoriesFor: #flags:!accessing!private! !
!Core.File categoriesFor: #flush!operations!public! !
!Core.File categoriesFor: #free!private!realizing/unrealizing! !
!Core.File categoriesFor: #getTimes:atime:mtime:!accessing!private! !
!Core.File categoriesFor: #handle!accessing!public! !
!Core.File categoriesFor: #isReadable!public!testing! !
!Core.File categoriesFor: #isWriteable!public!testing! !
!Core.File categoriesFor: #lastAccessTime!accessing!public! !
!Core.File categoriesFor: #lastWriteTime!accessing!public! !
!Core.File categoriesFor: #name!accessing!public! !
!Core.File categoriesFor: #open!operations!public! !
!Core.File categoriesFor: #open:flags:share:!operations!private! !
!Core.File categoriesFor: #open:mode:check:share:!operations!public! !
!Core.File categoriesFor: #openFlags!accessing!private! !
!Core.File categoriesFor: #pathName!accessing!public! !
!Core.File categoriesFor: #position!positioning!public! !
!Core.File categoriesFor: #position:!operations!positioning!public! !
!Core.File categoriesFor: #printOn:!printing!public! !
!Core.File categoriesFor: #read:!operations!public! !
!Core.File categoriesFor: #read:count:!operations!public! !
!Core.File categoriesFor: #read:startingAt:count:!operations!public! !
!Core.File categoriesFor: #readByte!operations!public! !
!Core.File categoriesFor: #readWriteStream!public!streaming! !
!Core.File categoriesFor: #reset!positioning!public! !
!Core.File categoriesFor: #securityAttributes!accessing!public! !
!Core.File categoriesFor: #seek:sense:!positioning!public! !
!Core.File categoriesFor: #setHandle:flags:!initializing!private! !
!Core.File categoriesFor: #setToEnd!positioning!public! !
!Core.File categoriesFor: #shareFlags:!accessing!private! !
!Core.File categoriesFor: #signalOsError:!exceptions!private! !
!Core.File categoriesFor: #size!accessing!public! !
!Core.File categoriesFor: #size:!operations!public! !
!Core.File categoriesFor: #sniffEncoding!helpers!private! !
!Core.File categoriesFor: #spec:!accessing!private! !
!Core.File categoriesFor: #write:!operations!public! !
!Core.File categoriesFor: #write:count:!operations!public! !
!Core.File categoriesFor: #write:startingAt:count:!operations!public! !
!Core.File categoriesFor: #writeByte:!operations!public! !

Core.File methodProtocol: #'streamable File' attributes: #(#readOnly) selectors: #(#close #flush #isReadable #isWriteable #position: #read:count: #reset #size #write:count:)!

!Core.File class methodsFor!

appendPathDelimiter: aString 
	"Answer a <readableString> that is the argument with a path separator appended to create the correct syntax for
	a path. If aString already ends in a path separator then the answer is equivalent."

	(aString notEmpty 
		and: [self pathDelimiters identityIncludes: aString last]) 
			ifTrue: [^aString].
	^aString copyWith: self pathDelimiter!

attributes: aFileNameString
	^KernelLibrary default getFileAttributes: aFileNameString!

commonPrefixOf: pathString1 and: pathString2
	"Answer the <readableString> common prefix shared between the two paths.
	This will be empty if the paths share no common prefix."

	| prefix len path1 path2 |
	path1 := pathString1 asUtf16String.
	path2 := pathString2 asUtf16String.
	len := ShlwapiLibrary default
				pathCommonPrefix: path1
				pszFile2: path2
				achPath: nil.
	len == 0 ifTrue: [^''].
	prefix := Utf16String newFixed: len.
	ShlwapiLibrary default
		pathCommonPrefix: path1
		pszFile2: path2
		achPath: prefix.
	^prefix!

composePath: aPathString stem: aStemString extension: anExtensionString
	"Composes a full pathname from its components. The path or extension components 
	can be nil if necessary. The path can include the drive letter."

	^self makePath: {nil. aPathString. aStemString. anExtensionString}!

composePath: path subPath: subpath
	"Composes a full pathname from path and subpath components."

	| buffer |
	buffer := self pathBuffer.
	^ShlwapiLibrary default
		pathCombine: buffer
		lpszDir: path
		lpszFile: subpath!

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

	^anExtensionString first == $.
		ifTrue: [aStemString, anExtensionString]
		ifFalse: [aStemString, '.', anExtensionString]!

copy: oldFileNameString to: newFileNameString
	"Copy the file specified by oldFileNameString to newFileNameString.
	Signal a HostSystemError if the copy fails."

	#todo.	"Due to a VM bug, auto-conversion of Strings is not thread-safe in overlapped calls, so convert explicitly."
	(KernelLibrary default
		copyFile: oldFileNameString asUtf16String
		lpNewFileName: newFileNameString asUtf16String
		bfailIfExists: false)
			ifFalse: [KernelLibrary default systemError: Processor activeProcess lastError]!

createDirectory: path
	"Create a directory with the specified path.
	Answer whether the directory was actually created, or already existed.
	Raise a Win32Error if the call fails for any other reason than that the
	directory already exists."

	| kernel |
	kernel := KernelLibrary default.
	^(kernel createDirectory: path lpSecurityAttributes: nil) or: 
			[| err |
			err := kernel getLastError.
			err = Win32Errors.ERROR_ALREADY_EXISTS ifFalse: [^kernel systemError: err].
			false	"already existed"]!

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
					["Skip UNC machine name and share"
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
					(part := path copyFrom: 1 to: end - 1) last == $:
						ifFalse: 
							["Don't attempt to create the drive!!"
							created := self createDirectory: part]].
			pos := end + 1].
	^created!

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

	(KernelLibrary default deleteFile: aFileNameString) ifFalse: [KernelLibrary default systemError]!

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
	"For each file/directory matching the wildcarded string argument, matchString, 
	in the directory named, dirString, evaluate the monadic valuable, operation, with 
	a WIN32_FIND_DATA describing the file/directory as the argument."

	| lib handle findStruct |
	lib := KernelLibrary default.
	findStruct := WIN32_FIND_DATAW new.
	findStruct directory: dirString.
	handle := lib findFirstFile: (File composePath: dirString subPath: matchString)
				lpFindFileData: findStruct.
	handle = INVALID_HANDLE_VALUE
		ifTrue: 
			[| err |
			err := lib getLastError.
			^(err == Win32Errors.ERROR_FILE_NOT_FOUND or: [err == Win32Errors.ERROR_ACCESS_DENIED])
				ifTrue: [self]
				ifFalse: [lib systemError: err]].
	
	[| error |
	
	[operation value: findStruct.
	lib findNextFile: handle lpFindFileData: findStruct] whileTrue.
	error := lib getLastError.
	error == Win32Errors.ERROR_NO_MORE_FILES ifFalse: [^lib systemError: error]]
			ensure: [lib findClose: handle]!

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

	| fullpath len path kernel |
	path := aPathnameString asUtf16String.
	kernel := KernelLibrary default.
	(len := kernel
				getFullPathName: path
				nBufferLength: 0
				lpBuffer: nil
				lpFilePart: nil) == 0
		ifTrue: [kernel systemError].
	"Note: Returns the length including the terminating null"
	fullpath := Utf16String newFixed: len - 1.
	(kernel
		getFullPathName: path
		nBufferLength: len
		lpBuffer: fullpath
		lpFilePart: nil) == 0
		ifTrue: [kernel systemError].
	^fullpath!

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
		value: ##(IdentityDictionary new
				at: #read put: FILE_SHARE_READ;
				at: #write put: FILE_SHARE_WRITE;
				at: #readWrite put: FILE_SHARE_READ | FILE_SHARE_WRITE;
				at: #exclusive put: 0;
				shrink;
				yourself).
	self addClassConstant: 'CheckModes'
		value: ##(IdentityDictionary new
				at: #read put: OPEN_EXISTING | GENERIC_READ;
				at: #create put: CREATE_NEW | GENERIC_READ | GENERIC_WRITE;
				at: #open put: OPEN_EXISTING | GENERIC_READ | GENERIC_WRITE;
				at: #append put: OPEN_EXISTING | GENERIC_READ | GENERIC_WRITE;
				at: #truncate put: TRUNCATE_EXISTING | GENERIC_READ | GENERIC_WRITE;
				shrink;
				yourself
			"open will only ever open an existing file").
	"open will only ever open an existing file"
	"open will only ever open an existing file"
	self addClassConstant: 'NoCheckModes'
		value: ##(IdentityDictionary new
				at: #read put: OPEN_ALWAYS | GENERIC_READ;
				at: #create put: OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE;
				at: #open put: OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE;
				at: #append put: OPEN_ALWAYS | GENERIC_READ | GENERIC_WRITE;
				at: #truncate put: CREATE_ALWAYS | GENERIC_READ | GENERIC_WRITE;
				shrink;
				yourself
			"No check read is a bit of a nonsense, but ...")
	"No check read is a bit of a nonsense, but ..."
	"No check read is a bit of a nonsense, but ..."!

isDirectory: aString
	"Answer true if there is a directory whose path is given by aString."

	| attribs |
	attribs := self attributes: aString.
	^attribs ~= -1 and: [attribs allMask: FILE_ATTRIBUTE_DIRECTORY]!

isRelativePath: aFileNameString
	"Answers true if aFileNameString is a relative path with no absolute components"

	^ShlwapiLibrary default pathIsRelative: aFileNameString!

isRootPath: aString
	"Answer whether the <String> argument is a root path, e.g. 'c:\'"

	^ShlwapiLibrary default pathIsRoot: aString!

isWriteable: aString
	"Answer whether the file at the specified path is writeable. If there is no such file, then
	the answer will be true. If there file exists then the answer is based on file's attributes
	- i.e. whether or not it has the read-only flag set. Note that file permissions are not
	taken into account, so even if the answer is true a subsequent attempt to open the file for
	writing may fail."

	| attributes |
	attributes := KernelLibrary default getFileAttributes: aString.
	^(attributes ~= -1 and: [attributes allMask: FILE_ATTRIBUTE_READONLY]) not!

isWriteable: aFileNameString set: aBoolean
	"Set the writeable state of aFileNameString to aBoolean. Answers true if the
	operation succeeds"

	| mode |
	mode := aBoolean ifTrue: [CRTConstants._S_IWRITE] ifFalse: [CRTConstants._S_IREAD].
	^(CRTLibrary default _chmod: aFileNameString pmode: mode) = 0!

lastWriteTime: aString
	"Answer a <FILETIME> representing the time when the file with the specified filename was
	last modified, or nil if no such file exists."

	| file |
	(self exists: aString) ifFalse: [^nil].
	file := File
				open: aString
				mode: #read
				check: true
				share: #read.
	^[file lastWriteTime] ensure: [file close]!

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

	| size drive dir fname ext path errno |
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
	^(errno := CRTLibrary default
				_makepath_s: path
				bufferSize: size + 1
				drive: drive
				dir: dir
				fname: fname
				ext: ext) == 0
		ifTrue: [path trimNulls]
		ifFalse: [CRTError signalWith: errno]!

maxPath
	"Answers the maximum number of characters in a file pathname"

	^CRTConstants._MAX_PATH!

new
	"Answer a new initialized instance of the receiver."

	^(super new)
		setHandle: nil flags: 0;
		yourself!

open: aString
	"Open the file described by aString for exclusive read/write access.
	Answer the the new instance or signal a FileException if the operation fails."

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

pathBuffer
	"Answer a buffer of sufficient size to contain a full path."

	^Utf16String newFixed: self maxPath!

pathDelimiter
	"Answers the character that delimits a path (or parts thereof)"

	^ $\!

pathDelimiters
	"Answers the characters that can be used to delimits a path (or parts thereof).	
	Windows tends to accept the Unix delimiter, a forward slash, as well as its own
	back slash."

	^'/\'!

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
	relPath := self pathBuffer.
	toPath := aPathString asUtf16String.
	relPath := (ShlwapiLibrary default
				pathRelativePathTo: relPath
				pszFrom: aBasePathString
				dwAttrFrom: 0
				pszTo: toPath
				dwAttrTo: 0) ifTrue: [relPath] ifFalse: [toPath].
	^(relPath beginsWith: '.\')
		ifTrue: [relPath copyFrom: 3 to: relPath strlen]
		ifFalse: [relPath trimNulls]!

removeDirectory: aString
	(KernelLibrary default removeDirectory: aString) ifFalse: [KernelLibrary default systemError]!

removeExtension: aString
	"Answer a <readableString> which is the path argument with the extension component removed."

	| drive dir fname errno max path crt |
	path := aString asUtf8String.
	max := path size.
	crt := CRTLibrary default.
	(errno := crt
				_splitpath_s: path
				drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
				driveLen: ##(CRTConstants._MAX_DRIVE + 1)
				dir: (dir := Utf8String new: max)
				dirLen: max + 1
				fname: (fname := Utf8String new: max)
				fnameLen: max + 1
				ext: nil
				extLen: 0) == 0
		ifTrue: 
			[| unextended |
			(errno := crt
						_makepath_s: (unextended := Utf8String new: max)
						bufferSize: max + 1
						drive: drive
						dir: dir
						fname: fname
						ext: nil) == 0
				ifTrue: [^unextended trimNulls]].
	^CRTError signalWith: errno!

removePathDelimiter: aString
	"Answer a <readableString> that is the argument with a path separator at its end, if any, removed."

	^(aString notEmpty 
		and: [self pathDelimiters identityIncludes: aString last]) 
			ifTrue: [aString allButLast]
			ifFalse: [aString]!

rename: oldFileNameString to: newFileNameString
	"Rename the file specified in oldFileNameString to newFileNameString.
	Signal a HostSystemError if the operation fails."

	(KernelLibrary default moveFile: oldFileNameString lpNewFileName: newFileNameString)
		ifFalse: [KernelLibrary default systemError]!

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

	| shortpath path len |
	path := aPathnameString asUtf16String.
	len := path size.
	shortpath := Utf16String newFixed: len.
	(KernelLibrary default
		getShortPathName: path
		lpszShortPath: shortpath
		cchBuffer: len + 1) == 0
		ifTrue: [KernelLibrary default systemError].
	^shortpath trimNulls!

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

	| drive errno |
	^(errno := CRTLibrary default
				_splitpath_s: aString asUtf8String
				drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
				driveLen: ##(CRTConstants._MAX_DRIVE + 1)
				dir: nil
				dirLen: 0
				fname: nil
				fnameLen: 0
				ext: nil
				extLen: 0) == 0
		ifTrue: [drive trimNulls]
		ifFalse: [CRTError signalWith: errno]!

splitExtensionFrom: aString
	"Splits aPathname string and answers the extension portion.
	Answers the empty string if there is no extension."

	| ext errno path len crt |
	path := aString asUtf8String.
	(len := path size) == 0 ifTrue: [^''].
	crt := CRTLibrary default.
	(errno := crt
				_splitpath_s: path
				drive: nil
				driveLen: 0
				dir: nil
				dirLen: 0
				fname: nil
				fnameLen: 0
				ext: (ext := Utf8String new: len)
				extLen: len + 1) == 0
		ifFalse: [^CRTError signalWith: errno].
	"CRT function includes leading period on extension, which we don't"
	^ext copyFrom: (ext first == $. ifTrue: [2] ifFalse: [1]) to: ext strlen!

splitFilenameFrom: aString
	"Splits the pathname, aString, and answers the file name portion (including extension).
	Answers an empty string if there is no filename component in the path."

	| fname ext errno max path |
	path := aString asUtf8String.
	max := path size.
	(errno := CRTLibrary default
				_splitpath_s: path
				drive: nil
				driveLen: 0
				dir: nil
				dirLen: 0
				fname: (fname := Utf8String new: max)
				fnameLen: max + 1
				ext: (ext := Utf8String new: max)
				extLen: max + 1) == 0
		ifTrue: 
			[(errno := CRTLibrary default
						strcat_s: fname
						bufferSize: max + 1
						strSource: ext) == 0
				ifTrue: [^fname trimNulls]].
	^CRTError signalWith: errno!

splitPath: aString
	"Splits the pathname, aString, into its path, stem and extension components and answers 
	a four element Array of these.
	Note: We use the C-runtime library to implement this, hence either backward or forward
	slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	| max path drive dir fname ext errno crt |
	"To avoid problems with long filenames, we use the length of the input string as the buffer
	sizes - clearly the component parts can never be larger than this.  In order to support
	Unicode paths, we work in UTF-8."
	path := aString asUtf8String.
	max := path size.
	max = 0 ifTrue: [^{''. ''. ''. ''}].
	crt := CRTLibrary default.
	^(errno := crt
				_splitpath_s: path
				drive: (drive := Utf8String new: CRTConstants._MAX_DRIVE)
				driveLen: ##(CRTConstants._MAX_DRIVE + 1)
				dir: (dir := Utf8String new: max)
				dirLen: max + 1
				fname: (fname := Utf8String new: max)
				fnameLen: max + 1
				ext: (ext := Utf8String new: max)
				extLen: max + 1) == 0
		ifTrue: 
			["CRT function includes leading period on extension, which we don't"
			{drive trimNulls.
				dir trimNulls.
				fname trimNulls.
				ext copyFrom: (ext first == $. ifTrue: [2] ifFalse: [1]) to: ext strlen}]
		ifFalse: [CRTError signalWith: errno]!

splitPathFrom: aPathnameString
	"Splits aPathname string and answers the path portion (including the drive letter, if any).
	Answers an  empty <String> if there is no path."

	"Implementation Note: We use the CRT library _splitpath() function because the Win32
	API call, PathRemoveFileSpec() does not treat $/ as a path delimiter (only backslash).
	Also this is carefully implemented to minimise allocations and maximise speed."

	| drive dir errno path len |
	path := aPathnameString asUtf8String.
	len := path size.
	"Deliberately allocate extra space for the drive letter buffer so we can strcat to it later."
	(errno := CRTLibrary default
				_splitpath_s: path
				drive: (drive := Utf8String new: len)
				driveLen: ##(CRTConstants._MAX_DRIVE + 1)
				dir: (dir := Utf8String new: len)
				dirLen: len + 1
				fname: nil
				fnameLen: 0
				ext: nil
				extLen: 0) == 0
		ifTrue: 
			[(errno := CRTLibrary default
						strcat_s: drive
						bufferSize: len + 1
						strSource: dir) == 0
				ifTrue: [^drive trimNulls]].
	^CRTError signalWith: errno!

splitStemFrom: aString
	"Answers the file stem component of the path <String> argument, or an empty string if there
	is none."

	| fname errno path len |
	path := aString asUtf8String.
	len := path size.
	^(errno := CRTLibrary default
				_splitpath_s: path
				drive: nil
				driveLen: 0
				dir: nil
				dirLen: 0
				fname: (fname := Utf8String new: len)
				fnameLen: len + 1
				ext: nil
				extLen: 0) == 0
		ifTrue: [fname trimNulls]
		ifFalse: [CRTError signalWith: errno]!

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
	"Answer a temporary filename built from prefixString in the user's temporary files
	directory. Note that this will create the temp file in order to guarantee uniqueness. You
	are responsible for deleting the file when it is no longer required. Signals a Win32Error if
	the operation fails."

	| returnBuf |
	returnBuf := self pathBuffer.
	(KernelLibrary default
		getTempFileName: self tempPath
		lpPrefixString: prefixString
		uUnique: 0
		lpTempFileName: returnBuf) == 0
		ifTrue: [^KernelLibrary default systemError].
	^returnBuf trimNulls!

tempPath
	"Answer the path of the directory designated for temporary files on the host system."

	| buf len lib |
	lib := KernelLibrary default.
	(len := lib getTempPath: 0 lpBuffer: nil) == 0 ifTrue: [lib systemError].
	buf := Utf16String newFixed: len - 1.
	(lib getTempPath: len lpBuffer: buf) == 0 ifTrue: [lib systemError].
	^buf!

windowsDirectory
	"Answer the path of the Windows directory on the host computer for the current session. Note
	that under Terminal Server this will be the shared Windows directory, not the per-user
	Windows directory. See MSDN KB281316  for further information."

	| len path |
	len := KernelLibrary default getSystemWindowsDirectory: nil uSize: 0.
	len == 0 ifTrue: [^KernelLibrary default systemError].
	path := Utf16String newFixed: len - 1.
	len := KernelLibrary default getSystemWindowsDirectory: path uSize: len.
	^path!

workingDirectory
	"Answer the current working directory."

	| buf dir |
	buf := CRTLibrary default _wgetcwd: nil maxlen: 0.
	dir := Utf16String fromAddress: buf.
	CRTLibrary default free: buf.
	^dir last = $\ ifTrue: [dir] ifFalse: [dir copyWith: $\]!

workingDirectory: aString
	"Set the current working directory."

	^CRTLibrary default _chdir: aString! !
!Core.File class categoriesFor: #appendPathDelimiter:!filename manipulation!public!testing! !
!Core.File class categoriesFor: #attributes:!file operations!public! !
!Core.File class categoriesFor: #commonPrefixOf:and:!filename manipulation!public! !
!Core.File class categoriesFor: #composePath:stem:extension:!filename manipulation!public! !
!Core.File class categoriesFor: #composePath:subPath:!filename manipulation!public! !
!Core.File class categoriesFor: #composeShortStem:extension:!filename manipulation!public! !
!Core.File class categoriesFor: #composeStem:extension:!filename manipulation!public! !
!Core.File class categoriesFor: #copy:to:!file operations!public! !
!Core.File class categoriesFor: #createDirectory:!file operations!public! !
!Core.File class categoriesFor: #createDirectoryPath:!file operations!public! !
!Core.File class categoriesFor: #default:extension:!filename manipulation!public! !
!Core.File class categoriesFor: #delete:!file operations!public! !
!Core.File class categoriesFor: #deleteDirectory:!file operations!public! !
!Core.File class categoriesFor: #exists:!file operations!public! !
!Core.File class categoriesFor: #extensionDelimiter!constants!public! !
!Core.File class categoriesFor: #find:!public!searching! !
!Core.File class categoriesFor: #for:do:!enumerating!public! !
!Core.File class categoriesFor: #for:in:do:!enumerating!public! !
!Core.File class categoriesFor: #forAll:in:do:!enumerating!public! !
!Core.File class categoriesFor: #forAllDirectories:in:do:!enumerating!public! !
!Core.File class categoriesFor: #forAllDirectoriesIn:do:!enumerating!public! !
!Core.File class categoriesFor: #forDirectories:in:do:!enumerating!public! !
!Core.File class categoriesFor: #forDirectoriesIn:do:!enumerating!public! !
!Core.File class categoriesFor: #fromHandle:!instance creation!public! !
!Core.File class categoriesFor: #fullPathOf:!filename manipulation!public! !
!Core.File class categoriesFor: #fullPathOf:relativeTo:!filename manipulation!public! !
!Core.File class categoriesFor: #initialize!development!initializing!public! !
!Core.File class categoriesFor: #isDirectory:!public!testing! !
!Core.File class categoriesFor: #isRelativePath:!filename manipulation!public!testing! !
!Core.File class categoriesFor: #isRootPath:!filename manipulation!public! !
!Core.File class categoriesFor: #isWriteable:!public!testing! !
!Core.File class categoriesFor: #isWriteable:set:!file operations!public! !
!Core.File class categoriesFor: #lastWriteTime:!enquiries!public! !
!Core.File class categoriesFor: #locateFilename:in:!filename manipulation!public! !
!Core.File class categoriesFor: #makePath:!filename manipulation!public! !
!Core.File class categoriesFor: #maxPath!constants!public! !
!Core.File class categoriesFor: #new!instance creation!public! !
!Core.File class categoriesFor: #open:!instance creation!public! !
!Core.File class categoriesFor: #open:mode:!instance creation!public! !
!Core.File class categoriesFor: #open:mode:check:!instance creation!public! !
!Core.File class categoriesFor: #open:mode:check:share:!instance creation!public! !
!Core.File class categoriesFor: #path:extension:!filename manipulation!public! !
!Core.File class categoriesFor: #pathBuffer!helpers!public! !
!Core.File class categoriesFor: #pathDelimiter!constants!public! !
!Core.File class categoriesFor: #pathDelimiters!constants!public! !
!Core.File class categoriesFor: #readAllBytes:!file operations!public! !
!Core.File class categoriesFor: #readAllText:!file operations!public! !
!Core.File class categoriesFor: #relativePathOf:to:!filename manipulation!public! !
!Core.File class categoriesFor: #removeDirectory:!file operations!public! !
!Core.File class categoriesFor: #removeExtension:!filename manipulation!public! !
!Core.File class categoriesFor: #removePathDelimiter:!filename manipulation!public!testing! !
!Core.File class categoriesFor: #rename:to:!file operations!public! !
!Core.File class categoriesFor: #replacePath:with:!filename manipulation!public! !
!Core.File class categoriesFor: #shortenComponent:max:!helpers!private! !
!Core.File class categoriesFor: #shortPathOf:!filename manipulation!public! !
!Core.File class categoriesFor: #sniffEncoding:!public! !
!Core.File class categoriesFor: #splitDriveFrom:!filename manipulation!public! !
!Core.File class categoriesFor: #splitExtensionFrom:!filename manipulation!public! !
!Core.File class categoriesFor: #splitFilenameFrom:!filename manipulation!public! !
!Core.File class categoriesFor: #splitPath:!filename manipulation!public! !
!Core.File class categoriesFor: #splitPathFrom:!filename manipulation!public! !
!Core.File class categoriesFor: #splitStemFrom:!filename manipulation!public! !
!Core.File class categoriesFor: #temporary!instance creation!public! !
!Core.File class categoriesFor: #temporaryFilename!filename manipulation!public! !
!Core.File class categoriesFor: #temporaryFilenameWithPrefix:!filename manipulation!public! !
!Core.File class categoriesFor: #tempPath!filename manipulation!public! !
!Core.File class categoriesFor: #windowsDirectory!accessing!public! !
!Core.File class categoriesFor: #workingDirectory!file operations!public! !
!Core.File class categoriesFor: #workingDirectory:!file operations!public! !

