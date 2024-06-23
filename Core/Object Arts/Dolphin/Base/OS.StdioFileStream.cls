"Filed out from Dolphin Smalltalk"!

Core.SequencedStream
	subclass: #'OS.StdioFileStream'
	instanceVariableNames: 'stream flags name oldFd fd crtlib locale'
	classVariableNames: ''
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'AccessModeMask' -> 16r3.
			'CreationModeMask' -> 16r700.
			'DefaultReadFlags' -> 16r40.
			'DefaultReadWriteFlags' -> 16r22.
			'DeviceMask' -> 16r400000.
			'NonBlockingMask' -> 16r800000.
			'ReadingMask' -> 16r2000000.
			'ShareModeMask' -> 16rF0.
			'ShareModes' -> (IdentityDictionary
						withAll: { #exclusive -> 16r10. #read -> 16r20. #readWrite -> 16r40. #write -> 16r30 }).
			'TranslationModeMask' -> 16r7C000.
			'WritingMask' -> 16r1000000
		}!

OS.StdioFileStream guid: (Core.GUID fromString: '{7b8405b3-0819-421f-8110-ca2763bcb59a}')!

OS.StdioFileStream isNonInstantiable: true!

OS.StdioFileStream comment: '`OS.StdioFileStream` is the abstract class of `<FileStream>`s implemented over C runtime library stdio streams. 

The `OS.StdioFileStream` hierarchy is intended for cases where a C stdio stream is required (e.g. for stdin, stdout, stderr). `Core.FileStream` itself should be used by preference in most cases as it behaves more predictably and with considerably better performance.

## Instance Variables:
  `stream`		`External.Handle`. FILE* stream handle.
  `flags`		`<integer>`. Various flags.
  `name`		`String`. Path of file. Can be nil, e.g. if connected to standard I/O handle
  `oldFd`		`<integer>`. Original file number associated with a stream. Used to restore the old file descriptor when the stream is closed.
  `fd`			`<integer>`. Current file number associated with the stream.
  `crtlib`		`CRTLibrary` to use with the stream, can be blocking or non-blocking.
  `locale`		`Locale` for internationalisation of input/output.

## Class Constants:
  `DeviceMask` 		`<integer>` flags mask set when the stream is connected to a device (as opposed to a file).
  `NonBlockingMask`	`<integer>` flags mask, set for overlapped reads.
  `ReadingMask`		`<integer>` flags mask set when the stream is in Reading state (see [Stream States](https://learn.microsoft.com/en-us/cpp/c-runtime-library/stream-states?view=msvc-170))
  `ReadOnlyMask`		`<integer>` flags mask set for streams opened in read-only mode.
  `WritingMask`		`<integer>` flags mask set when the stream is in Writing state'!

!OS.StdioFileStream categoriesForClass!Collections-Streams! !

!OS.StdioFileStream methodsFor!

accessMode
	^flags bitAnd: AccessModeMask!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses). The default is self."

	^stream!

atEnd
	"Answer whether the receiver is at the end of its values."

	^(crtlib feof: stream) or: 
			["feof returns non-zero only when an attempt has been made to read past the
			 end of stream. If attached to a file (as opposed to a device) we may be
			 positioned beyond the end of stream. The only reliable way to tell is to 
			attempt to read another character."
			self isDevice not and: [self basicPeek isNil]]!

attach: anExternalHandle toFd: fdInteger mode: aString
	"Private - Attach the stdio descriptor identified by fdInteger (usually one of 0=stdin,
	1=stdout, or 2-stderr) to the specified OS file, and open a stdio stream onto it in the
	specified stdio mode."

	| handle newFd |
	crtlib := Ucrt.
	"1. dup the existing use of fdInteger"
	oldFd := crtlib _dup: fdInteger.
	oldFd < 0 ifTrue: [CRTError signal].
	"2: Attach an fd to the provided OS file handle"
	newFd := crtlib _open_osfhandle: anExternalHandle flags: 0.
	newFd < 0 ifTrue: [CRTError signal].
	"3: Redirect target fd to the OS file"
	(crtlib _dup2: newFd handle2: fdInteger) < 0 ifTrue: [CRTError signal].
	"4: Dispose of the fd created in step 2 and dup'd in step 3 so we don't leak it and the duplicate OS handle it contains"
	(crtlib _close: newFd) < 0 ifTrue: [CRTError signal].
	"5: Finally open a stdio stream onto the fd"
	(handle := crtlib _fdopen: fdInteger mode: aString) isNil ifTrue: [CRTError signal].
	self
		setStream: handle
		name: nil
		flags: (self flagsFromMode: aString) | self class translationMode!

basicNext
	"Private - Answer an <integer> in the range 0..255, being the next of the receiver's future sequence
	values."

	^self basicNextAvailable ifNil: [self errorEndOfStream]!

basicNext: anInteger
	"Private - Answer a <sequencedReadableCollection> containing the next anInteger number of objects
	accessible by the receiver."

	^self
		basicNext: anInteger
		into: (self bufferClass new: anInteger)
		startingAt: 1!

basicNext: countInteger into: aSequenceableCollection startingAt: startInteger
	"Private - Destructively replace the elements of the argument, aSequenceableCollection,
	(which must be some sort of byte object or <ExternalStructure> type object
	which holds bytes) in the interval (startAt..startAt+count-1) with the next, count, 
	elements of the receiver. Answer aSequenceableCollection."

	| read start |
	start := startInteger - 1.
	self prepareToRead.
	read := crtlib
				fread_s: aSequenceableCollection yourAddress + start
				bufferSize: aSequenceableCollection byteSize - start
				elementSize: self bufferClass elementSize
				count: countInteger
				stream: stream.
	read = countInteger ifFalse: [^self errorEndOfStream].
	^aSequenceableCollection!

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| end |
	(end := startInteger + countInteger - 1) > aSequenceableCollection size
		ifTrue: [self errorSubscriptBounds: end].
	self prepareToWrite.
	crtlib
		fwrite: aSequenceableCollection yourAddress + startInteger - 1
		size: aSequenceableCollection class elementSize
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

basicNextAvailable
	"Private - Answer the next raw element in the stream, or nil if at end."

	"Implementation note: If connected to device then is it possible for fgetc to both block and to return a value other than -1 even when feof() returns true. After a ^Z (EOF) character has been encountered in the input stream, feof() will subsequently return true. However, since the device stream is not actually at end, fgetc() will block awaiting further input when called. If further input is provided, this will be returned, even though feof() remains true. To avoid this contradictory behaviour we test up front for feof(), and do not attempt to read further input if it returns true."

	^(crtlib feof: stream) ifFalse: [self getchar]!

basicNextAvailable: anInteger
	"Private - Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	"Implementation Note: Override superclass for improved performance."

	| read buf elemSize |
	self atEnd ifTrue: [^self bufferClass new: 0].
	buf := self bufferClass newFixed: anInteger.
	elemSize := buf class elementSize.
	self prepareToRead.
	read := crtlib
				fread_s: buf
				bufferSize: buf size * elemSize
				elementSize: elemSize
				count: anInteger
				stream: stream.
	^read < anInteger ifTrue: [buf copyFrom: 1 to: read] ifFalse: [buf]!

basicNextPut: anInteger
	"Private - Store the byte <integer> (range 0..255) as the next element of the receiver."

	self prepareToWrite.
	crtlib fputc: anInteger stream: stream.
	^anInteger!

basicPeek
	^self getchar ifNotNil: [:ch | self ungetchar: ch]!

basicUpTo: anObject
	"Private - Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	| newStream elem |
	newStream := self contentsSpecies writeStream: 32.
	[(elem := self nextAvailable) isNil or: [elem = anObject]] whileFalse: [newStream nextPut: elem].
	^newStream contents!

bufferClass
	"Answer the class used to encode the stdio buffer."

	^self contentsSpecies!

bufferPrototype
	"Private - Answer a prototypical instance of the type of collection over which this class streams."

	^self bufferClass empty!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state. Answer the receiver."

	| stdFd |
	stream isNull ifTrue: [^self].
	self beUnfinalizable.
	stdFd := self fileno.
	crtlib fclose: stream.
	stream := nil.
	oldFd isNil
		ifFalse: 
			["Restore original stdio stream from saved descriptor"
			crtlib
				_dup2: oldFd handle2: stdFd;
				_close: oldFd.
			oldFd := nil]!

contents
	"Answer a <String> or <ByteArray> containing the complete contents of the file
	accessed by the receiver."

	self reset.
	^self upToEnd!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^self subclassResponsibility!

creationMode
	^flags bitAnd: CreationModeMask!

do: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's future sequence values, terminating only when there are no more future sequence values (i.e. the stream is at an	end)."

	"Overridden because #atEnd check is expensive on stdio streams."

	| ch |
	[(ch := self nextAvailable) isNil] whileFalse: [aMonadicValuable value: ch]!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^self subclassResponsibility!

fileno
	^fd!

fileSize
	^crtlib _filelengthi64: self fileno!

finalize
	self close!

flagsFromMode: aString
	^((aString includes: $+) not and: [aString first == $r])
		ifTrue: 
			["For _wfopen_s, the default sharing mode when opening a file for reading is FILE_SHARE_READ (allow others to read too)"
			##(_O_RDONLY | _SH_SECURE)]
		ifFalse: 
			["For _wfopen_s, the default sharing mode when opening a file for writing is exclusive (no sharing)"
			##(_O_RDWR | _SH_SECURE)]!

flush
	"Flush any buffered modifications to the file."

	flags := flags bitAnd: ##(WritingMask bitInvert).
	crtlib fflush: stream!

getchar
	| ch |
	self prepareToRead.
	ch := crtlib fgetc: stream.
	^ch == -1 ifFalse: [ch]!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self isText not!

isDevice
	"Answer whether the CRT stream is connected to a device."

	^flags anyMask: DeviceMask!

isNonBlocking
	"Answer whether this StdioFileStream is using the non-blocking CRT library to perform I/O. This should usually be the case for device streams (e.g. stdin) so that reading/writing does not block the entire image. It should usually not be the case for streams attached to files, because there is significant overhead to the overlapped call mechanism."

	^crtlib isNonBlocking!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	<gettableStream> protocol)."

	^true!

isText
	"Answer whether the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the <puttableStream> protocol)."

	^self accessMode ~~ _O_RDONLY!

locale
	"Answer the <Locale> to be used when emitting or reaading localisable data to/from this stream."

	^locale ?? Locale.UserDefault!

locale: aLocale
	"Set the <Locale> to be used when emitting or reaading localisable data to/from this stream."

	locale := aLocale!

modeModifiers
	^self subclassResponsibility!

name
	^name
		ifNil: 
			[String writeStream
				nextPut: $<;
				display: self fileno;
				nextPut: $>;
				contents]!

next
	"Answer a <Character> or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values."

	^self subclassResponsibility!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	^self subclassResponsibility!

nextAvailable
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Answer nil if at EOF."

	^self bufferPrototype decodeNextFrom: self!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. Generally, the answer will be
	a collection of the same class as the one accessed by the receiver (though this is
	determined by the receiver), and will contain anInteger elements, or as many as are left in
	the receiver's collection."

	^self bufferPrototype decodeNextAvailable: anInteger from: self!

nextPut: anObject
	"Store the <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	^self basicNextPut: anObject!

nextPutAll: aCollection 
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^aCollection appendToStream: self!

open: pathString mode: modeString flags: anInteger
	(Ucrt
		_wfsopen: pathString
		mode: modeString , self modeModifiers
		shflag: (anInteger bitAnd: ShareModeMask))
			ifNil: [CRTError signal]
			ifNotNil: 
				[:handle |
				self
					setStream: handle
					name: pathString
					flags: anInteger]!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	^self subclassResponsibility!

position
	"Answer the absolute (zero-based) position of the file pointer."

	^crtlib _ftelli64: stream!

position: anInteger
	"Set the receiver's current position reference for accessing the collection to the the
	argument, anInteger. If the argument is not within the bounds of the receiver's collection,
	or if the associated stdio stream is not positionable, report an error."

	self seek: SEEK_SET offset: anInteger!

prepareToRead
	"Private - If the stream was in writing mode, flush. Enter reading mode. See [Stream states](https://learn.microsoft.com/en-us/cpp/c-runtime-library/stream-states?view=msvc-170)"

	(flags allMask: WritingMask) ifTrue: [self flush].
	"Any subsequent write will now require an intervening call to a file-positioning function to leave reading mode."
	flags := flags bitOr: ReadingMask!

prepareToWrite
	"Private - If the stream was in reading mode, flush. Enter writing mode. See [Stream states](https://learn.microsoft.com/en-us/cpp/c-runtime-library/stream-states?view=msvc-170)"

	(flags allMask: ReadingMask)
		ifTrue: 
			["fflush doesn't work for transitioning out of Reading mode in the way that it is supposed to. [I've reported the bug to Microsoft](https://developercommunity.visualstudio.com/t/fflush-may-not-clear-stream-Reading-stat/10327689), and it looks it might even get fixed. In meantime fseek will do the trick."
			self seek: SEEK_CUR offset: 0].
	"Any subsequent read will now require an intervening call to fflush or a file-positioning function to leave writing mode"
	flags := flags bitOr: WritingMask!

reset
	"Set the receiver's position reference to the beginning of the collection. Raise an error if
	the stream is not positionable, e.g. it is connected to a console device."

	self isDevice ifTrue: [self errorNotPositionable] ifFalse: [self position: 0]!

seek: originInteger offset: offsetInteger
	self isDevice ifTrue: [^self errorNotPositionable].
	(crtlib
		_fseeki64: stream
		offset: offsetInteger
		origin: originInteger) ~~ 0
		ifTrue: [CRTError signal].
	"File-positioning function implicitly syncs the buffer"
	flags := flags bitAnd: ##((ReadingMask | WritingMask) bitInvert)!

setStream: anExternalAddress name: aString flags: anInteger
	| oshandle filetype |
	stream := anExternalAddress asExternalHandle.
	flags := anInteger.
	name := aString.
	crtlib := (flags allMask: NonBlockingMask) ifTrue: [CRTLibrary nonblocking] ifFalse: [Ucrt].
	fd := crtlib _fileno: stream.
	self beFinalizable.
	"Examine the underlying OS file handle to determine the file type"
	oshandle := crtlib _get_osfhandle: fd.
	filetype := Kernel32 getFileType: oshandle.
	((filetype == Win32Constants.FILE_TYPE_CHAR and: 
			[flags := flags bitOr: DeviceMask.
			true])
		or: [filetype == Win32Constants.FILE_TYPE_PIPE])
			ifTrue: 
				[flags := flags bitOr: NonBlockingMask.
				crtlib := CRTLibrary nonblocking].
	(crtlib _setmode: fd mode: self translationMode) < 0
		ifTrue: [self error: 'Unable to set translation mode ' , self translationMode printString].
	^self!

setToEnd
	"Set the file pointer to the end of the file."

	self seek: SEEK_END offset: 0!

shareFlags
	| deny |
	deny := self shareMode.
	^##(LookupTable withAll: {
				_SH_DENYRW -> 0.
				_SH_DENYWR -> Win32Constants.FILE_SHARE_READ.
				_SH_DENYRD -> Win32Constants.FILE_SHARE_WRITE.
				_SH_DENYNO -> (Win32Constants.FILE_SHARE_READ | Win32Constants.FILE_SHARE_WRITE)
			})
		at: deny!

shareMode
	| shflag |
	shflag := flags bitAnd: ShareModeMask.
	^shflag == _SH_SECURE
		ifTrue: [self isWriteable ifTrue: [_SH_DENYRW] ifFalse: [_SH_DENYWR]]
		ifFalse: [shflag]!

size
	"Answer the size of the file in bytes. Enquiring the size of streams connected
	to, for example, stdin is an error."

	| len |
	"We may have to flush in order for any data written to the stream buffer past the previous end of file to be taken into account."
	(flags allMask: WritingMask) ifTrue: [self flush].
	^(len := self fileSize) < 0 ifTrue: [CRTError signal] ifFalse: [len]!

skip: anInteger
	"Adjust the receiver's position by the <integer> argument."

	"Note this adjusts the raw position. It should not be used when streaming over UTF encoded strings."

	self seek: SEEK_CUR offset: anInteger!

translationMode
	^flags bitAnd: TranslationModeMask!

ungetchar: aCodeUnit
	crtlib ungetc: aCodeUnit stream: stream.
	^aCodeUnit!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	^self bufferPrototype decodeFrom: self upTo: anObject! !

!OS.StdioFileStream categoriesForMethods!
accessMode!public!testing! !
asParameter!converting!public! !
atEnd!public!testing! !
attach:toFd:mode:!initializing!private! !
basicNext!accessing!private! !
basicNext:!accessing!private! !
basicNext:into:startingAt:!accessing!private! !
basicNext:putAll:startingAt:!accessing!private! !
basicNextAvailable!accessing!private! !
basicNextAvailable:!accessing!private! !
basicNextPut:!accessing!private! !
basicPeek!accessing!private! !
basicUpTo:!accessing!private! !
bufferClass!constants!private! !
bufferPrototype!constants!private! !
close!operations!public! !
contents!accessing!public! !
contentsSpecies!constants!private! !
creationMode!accessing!private! !
do:!enumerating!public! !
externalType!accessing!public! !
fileno!accessing!private! !
fileSize!accessing!public! !
finalize!finalizing!private! !
flagsFromMode:!helpers!private! !
flush!buffer!public! !
getchar!accessing!private! !
isBinary!public!testing! !
isDevice!public!testing! !
isNonBlocking!public!testing! !
isReadable!public!testing! !
isText!public!testing! !
isWriteable!public!testing! !
locale!accessing!public! !
locale:!accessing!public! !
modeModifiers!constants!private! !
name!accessing!public! !
next!accessing!public! !
next:putAll:startingAt:!accessing!public! !
nextAvailable!accessing!public! !
nextAvailable:!accessing!public! !
nextPut:!accessing!public! !
nextPutAll:!accessing!public! !
open:mode:flags:!instance creation!private! !
peek!accessing!public! !
position!accessing!public! !
position:!positioning!public! !
prepareToRead!helpers!private! !
prepareToWrite!helpers!private! !
reset!positioning!public! !
seek:offset:!helpers!positioning!private! !
setStream:name:flags:!initializing!private! !
setToEnd!positioning!public! !
shareFlags!accessing!private! !
shareMode!accessing!private! !
size!accessing!public! !
skip:!positioning!public! !
translationMode!accessing!private! !
ungetchar:!accessing!private! !
upTo:!accessing!public! !
!

OS.StdioFileStream methodProtocol: #collectionStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
OS.StdioFileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
OS.StdioFileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!

!OS.StdioFileStream class methodsFor!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol
	"Answer a new sub-instance of the receiver representing a text stdio stream with the file descriptor, fdInteger, attached to the OS file handle, anExternalHandle.
	The modeSymbol argument identifies the manner in which the file is opened, #read for a read-only stream (e.g. stdin), or any other mode integer for a writable stream."

	^self basicNew
		attach: anExternalHandle
		toFd: fdInteger
		mode: (self attachMode: modeSymbol)!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol type: typeSymbol
	"Answer a new instance of the receiver representing a text stdio stream with the file descriptor, fdInteger, attached to the OS file handle, anExternalHandle, 
	The <symbol> argument, modeSymbol, identifies the manner in which the file is opened, #read for a read-only stream (e.g. stdin), or any other mode integer for a writable stream.
	The <symbol> argument, typeSymbol, identifies the content type; one of #binary (to read/write raw bytes), #text (for text translation mode, sniffing the encoding from the current file content), or one of the valid String encodings - see String.Encodings."

	^(self classForEncoding: typeSymbol)
		attach: anExternalHandle
		toFd: fdInteger
		mode: modeSymbol!

attachMode: modeSymbol
	^String with: (modeSymbol == #read ifTrue: [$r] ifFalse: [$w]) with: self encodingMode!

classForEncoding: aSymbol
	^(self encodingClasses lookup: aSymbol) ifNil: [self error: 'Unsupported encoding ' , aSymbol]!

encodingClasses
	^##(IdentityDictionary new
		at: #binary put: StdioBinaryFileStream;
		at: #ansi put: StdioAnsiFileStream;
		at: #text put: StdioAnsiFileStream;
		at: #utf8 put: StdioUtf8FileStream;
		at: #utf16le put: StdioUtf16FileStream;
		yourself)!

encodingMode
	^self subclassResponsibility!

encodingType
	"Answer the standard encoding to use when attaching streams of this class. 
	Although this ought to be #binary at this level (untranslated binary being the most general), for historical compatibility it is not."

	^#text!

fromHandle: aFILE
	"Answer a new sub-instance of the receiver on the specified stdio FILE pointer, assumed to be for RW access and connected to a device or pipe."

	"This method will likely be deprecated in future because the name is unclear as to the type of handle expected as an argument. In this case the 'handle' is actually a CRT FILE pointer, and not an OS file handle."

	^self
		newForEncoding: self encodingType
		iostream: aFILE
		name: nil
		flags: DefaultReadWriteFlags!

initialize
	"
	self initialize
	"

	self addClassConstant: 'AccessModeMask' value: _O_RDONLY | _O_WRONLY | _O_RDWR.
	self addClassConstant: 'TranslationModeMask'
		value: _O_TEXT | _O_BINARY | _O_WTEXT | _O_U16TEXT | _O_U8TEXT.
	self addClassConstant: 'CreationModeMask' value: _O_CREAT | _O_TRUNC | _O_EXCL.
	self addClassConstant: 'ShareModeMask'
		value: _SH_DENYRW | _SH_DENYWR | _SH_DENYRD | _SH_DENYNO | _SH_SECURE.
	self addClassConstant: 'ShareModes'
		value: (IdentityDictionary withAll: {
						#read -> _SH_DENYWR.
						#readWrite -> _SH_DENYNO.
						#write -> _SH_DENYRD.
						#exclusive -> _SH_DENYRW
					}).
	self addClassConstant: 'DefaultReadWriteFlags' value: _O_RDWR | _SH_DENYWR.
	self addClassConstant: 'DefaultReadFlags' value: _O_RDONLY | _SH_DENYNO!

newForEncoding: aSymbol iostream: aHandle name: aString flags: anInteger
	| concreteClass |
	concreteClass := self classForEncoding: aSymbol.
	^concreteClass basicNew
		setStream: aHandle
		name: aString
		flags: anInteger | concreteClass translationMode!

on: aFile
	"Answer an instance of the receiver attached to the open <File>, aFile."

	^self on: aFile text: true!

on: aFile text: aBoolean
	"Answer a new instance of the receiver attached to the open file <File>, aFile, in binary or text mode depending on the <Boolean> argument, aBoolean."

	^self on: aFile type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: aFile type: aSymbol
	"Answer a new concrete sub-instance of the receiver attached to the open <File>, aFile, with content type named by the <Symbol>, aSymbol.
	Valid content types are #binary, to read/write raw bytes, #text (for text translation mode - sniffing the current encoding) or one of the valid String encodings - see String.Encodings."

	| oshandle proc fd mode encoding flags |
	aFile isReadable ifFalse: [self error: 'must be attached to a readable file'].
	encoding := aSymbol == #text ifTrue: [String encodingName: aFile sniffEncoding] ifFalse: [aSymbol].
	oshandle := External.Handle new.
	proc := Kernel32 getCurrentProcess.
	(Kernel32
		duplicateHandle: proc
		hSourceHandle: aFile asParameter
		hTargetProcessHandle: proc
		lpTargetHandle: oshandle
		dwDesiredAccess: 0
		bInheritHandle: false
		dwOptions: Win32Constants.DUPLICATE_SAME_ACCESS) ifFalse: [Kernel32 systemError].
	fd := Ucrt _open_osfhandle: oshandle flags: 0.
	mode := aFile isWriteable
				ifTrue: 
					[flags := DefaultReadWriteFlags.
					'r+']
				ifFalse: 
					[flags := DefaultReadFlags.
					'r'].
	^(Ucrt _fdopen: fd mode: mode , (encoding == #binary ifTrue: ['b'] ifFalse: ['t']))
		ifNil: [CRTError signal]
		ifNotNil: 
			[:handle |
			self
				newForEncoding: encoding
				iostream: handle
				name: aFile name
				flags: flags]!

open: aString mode: modeSymbol check: aBoolean type: encodingSymbol share: shareSymbol
	"Private - Open a file with _wfsopen"

	| instance path exists mode flags concreteClass |
	path := aString asUtf16String.
	exists := (Kernel32 getFileAttributes: aString) ~= -1.
	modeSymbol == #create
		ifTrue: 
			["open an existing file, or create a new file, for read/write, positioned at the beginning. "
			aBoolean
				ifTrue: 
					["Check exists mode - raise error if file exists, otherwise create a new empty one for read/write"
					mode := 'w+x'.
					flags := ##(_O_RDWR | _O_CREAT | _O_EXCL)]
				ifFalse: 
					["No check exists mode - if file exists, open at its start, otherwise create a new empty one for read/write"
					mode := exists ifTrue: ['r+'] ifFalse: ['w+'].
					flags := ##(_O_RDWR | _O_CREAT)]].
	"Note that Smalltalk #append mode is unlike the 'a' and 'a+' fopen() modes, because in Smalltalk the mode only controls the initial file position, and it is possible to overwrite the existing data by moving the stream pointer backwards. With the fopen() append modes it is not possible to overwrite the existing data, so we don't use a+ for #append."
	(modeSymbol == #append or: [modeSymbol == #open])
		ifTrue: 
			[mode := aBoolean | exists ifTrue: ['r+'] ifFalse: ['w+'].
			flags := _O_RDWR].
	modeSymbol == #truncate
		ifTrue: 
			[(aBoolean and: [exists not]) ifTrue: [^CRTError signalWith: ENOENT].
			mode := 'w+'.
			flags := ##(_O_RDWR | _O_CREAT | _O_TRUNC)].
	modeSymbol == #read
		ifTrue: 
			[mode := 'r'.
			flags := _O_RDONLY].
	concreteClass := encodingSymbol == #text
				ifTrue: 
					[exists ifTrue: [self classForEncoding: (File sniffEncoding: path)] ifFalse: [StdioAnsiFileStream]]
				ifFalse: [self classForEncoding: encodingSymbol].
	instance := concreteClass basicNew
				open: path
					mode: mode
					flags: ((flags bitOr: (ShareModes at: shareSymbol)) bitOr: concreteClass translationMode);
				yourself.
	modeSymbol == #append ifTrue: [instance setToEnd].
	^instance!

openFd: fdInteger mode: modeSymbol
	| flags mode |
	mode := modeSymbol == #read
				ifTrue: 
					[flags := DefaultReadFlags.
					'r']
				ifFalse: 
					[flags := DefaultReadWriteFlags.
					'w'].
	^self
		newForEncoding: self encodingType
		iostream: (Ucrt _fdopen: fdInteger mode: (mode copyWith: self encodingMode))
		name: nil
		flags: flags!

read: aString
	"Answer a new instance of the receiver whose future sequence values consist of the textual contents of the file at the path specified by the <readableString> argument.
		- It is an error for the file or its folder path to not exist. If the file does exist, it is opened and the stream is positioned at the beginning of the content.
		- Others are permitted to open the file for reading or writing (or have already done so)."

	^self read: aString type: #text!

read: aString text: aBoolean
	"Answer an instance of the receiver whose future sequence values consist of the contents of the file at the path specified by the <readableString> first argument.
		- If the <boolean> 2nd argument is true, the file is assumed to contain text (i.e. Strings/Characters). The content will be sniffed to determine the encoding. If the argument is false, then the file is opened to read/write raw binary (bytes).
		- It is an error for the file or its folder path to not exist. If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others are permitted to open the file for reading or writing (or have already done so)."

	^self
		read: aString
		text: aBoolean
		share: #read!

read: aString text: aBoolean share: aSymbol
	"Answer an instance of the receiver whose future sequence values consist of the contents of the file at the path specified by the <readableString> first argument.
		- If the <boolean> 2nd argument is true, the file is assumed to contain text (i.e. Strings/Characters). The content will be sniffed to determine the encoding. If the argument is false, then the file is opened to read/write raw binary (bytes).
		- It is an error for the file or its folder path to not exist. If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others may be permitted to open the file for reading or writing (or have already done so), depending on the final <Symbol> argument, shareSymbol, one of #read, #write, #readWrite, #exclusive."

	^self read: aString type: (aBoolean ifTrue: [#text] ifFalse: [#binary]) share: aSymbol!

read: aString type: encodingSymbol
	"Answer a new instance of the receiver whose future sequence values consist of the contents of the file at the path specified by the <readableString> first argument.
		- The encoding of the content is assumed to be that specified by the <Symbol> second argument, one of #binary, #text, #utf8, #utf16, or #utf32.
		- For #text encoding, the file is sniffed to determine the actual (or likely) text encoding.
		- It is an error for the file or its folder path to not exist. If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others are permitted to open the file for reading (or have already done so)."

	^self
		read: aString
		type: encodingSymbol
		share: #read!

read: aString type: encodingSymbol share: shareSymbol
	"Answer an instance of the receiver whose future sequence values consist of the contents of the file at the path specified by the <readableString> first argument.
		- The encoding of the content is assumed to be that specified by the <Symbol> second argument, one of #binary, #text, #utf8, #utf16, or #utf32.
		- For #text encoding, the file is sniffed to determine the actual (or likely) text encoding.
		- It is an error for the file or its folder path to not exist. If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others may be permitted to open the file for reading or writing (or have already done so), depending on the final <Symbol> argument, shareSymbol, one of #read, #write, #readWrite, #exclusive."

	^self
		open: aString
		mode: #read
		check: true
		type: encodingSymbol
		share: shareSymbol!

translationMode
	^self subclassResponsibility!

write: aString
	"Answer a new instance of the receiver for writing a file at the path specified by the <readableString> argument.
		- The file will contain text.
		- It is an error for the folder path to not exist. 
		- If the file already exists, it is truncated, otherwise a new file is created.
		- Others are permitted to open the file for reading. An error is raised if the file is aready open for writing."

	^self write: aString mode: #truncate!

write: aString mode: aSymbol
	"Answer a new instance of the receiver for writing a file at the path specified by the <readableString> argument.
		- The content is encoded per the <Symbol> argument. See #write:mode:check:type: for a description of the encoding options.
		- It is an error for the directory in which the file is to be written not to exist. 
		- If the file already exists, it is truncated, otherwise a new file is created.
		- Others are permitted to open the file for reading. An error is raised if the file is aready open for writing."

	^self
		write: aString
		mode: aSymbol
		check: false
		type: #text!

write: aString mode: aSymbol check: checkBoolean text: textBoolean
	"Answer a new instance of the receiver open on the contents of the file identified by the <readableString> argument.
	The <symbol> argument identifies the manner in which the file is opened.
	It may be one of:
		#create 	create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its start.
	See also the File class for further information on the mode.
	The first <boolean> argument determines whether or not  errors are reported if the file does or does not exist (depending on the mode). 
	The final <boolean> argument specifies the external type (#binary or #text) for which the new instance is initially configured."

	^self
		write: aString
		mode: aSymbol
		check: checkBoolean
		type: (textBoolean ifTrue: [#text] ifFalse: [#binary])!

write: aString mode: modeSymbol check: aBoolean type: encodingSymbol
	"Answer a new instance of the receiver for writing to the file identified at the path specified by the <readableString> first argument.
	- The <symbol> argument, modeSymbol, identifies the manner in which the file is opened, and may be one of:
		#create 	create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its start.
	- See also the File class for further information on the mode.
	- The <boolean> third argument determines whether or not errors are reported if the file does or does not exist (depending on the mode). 
	- The <symbol>, encodingSymbol, specifies the data encoding (binary or text) for which the new instance is configured.
	- Others are permitted to open the file for reading (or have already done so). An error is raised if the file is aready open for writing."

	^self
		open: aString
		mode: modeSymbol
		check: aBoolean
		type: encodingSymbol
		share: #read!

write: aString text: aBoolean 
	"Create a new file/truncate an existing file for read/write access through the receiver.
	The stream will expect characters or bytes depending on the value of the <boolean> argument."

	^self 
		write: aString
		mode: #truncate
		check: false
		text: aBoolean!

write: aString type: aSymbol
	"Create a new file/truncate an existing file identified by the <readableString>, aString,
	for write access (in fact our filestreams require read/write access for buffering, so the
	result is actually a read/write file stream) through the receiver. The sequence value type
	is determined by the <symbol> argument, fileType (i.e. one of #binary, #text, #utf8, #utf16,
	or #utf32)."

	^self
		write: aString
		mode: #truncate
		check: false
		type: aSymbol! !

!OS.StdioFileStream class categoriesForMethods!
attach:toFd:mode:!instance creation!public! !
attach:toFd:mode:type:!instance creation!public! !
attachMode:!helpers!private! !
classForEncoding:!helpers!private! !
encodingClasses!constants!private! !
encodingMode!constants!private! !
encodingType!constants!public! !
fromHandle:!instance creation!public! !
initialize!class initialization!development!public! !
newForEncoding:iostream:name:flags:!instance creation!private! !
on:!instance creation!public! !
on:text:!instance creation!public! !
on:type:!instance creation!public! !
open:mode:check:type:share:!instance creation!private! !
openFd:mode:!instance creation!public! !
read:!instance creation!public! !
read:text:!instance creation!public! !
read:text:share:!instance creation!public! !
read:type:!instance creation!public! !
read:type:share:!instance creation!public! !
translationMode!constants!private! !
write:!instance creation!public! !
write:mode:!instance creation!public! !
write:mode:check:text:!instance creation!public! !
write:mode:check:type:!instance creation!public! !
write:text:!instance creation!public! !
write:type:!instance creation!public! !
!

OS.StdioFileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

