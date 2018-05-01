"Filed out from Dolphin Smalltalk 7"!

SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream flags name oldFd fd crtlib'
	classVariableNames: 'ClassForEncoding Codecs DeviceMask ReadOnlyMask'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
StdioFileStream guid: (GUID fromString: '{7b8405b3-0819-421f-8110-ca2763bcb59a}')!
StdioFileStream isAbstract: true!
StdioFileStream addClassConstant: 'DeviceMask' value: 64!
StdioFileStream addClassConstant: 'ReadOnlyMask' value: 1!
StdioFileStream comment: 'StdioFileStream is a <FileStream> implemented over C runtime library stdio streams. FileStream itself should be used by preference in most cases.

Instance Variables:
	stream	<ExternalHandle>. FILE* stream handle.
	flags		<integer>. Various flags.
	name	<String>. Path of file. Can be nil, e.g. if connected to standard I/O handle
	oldFd	<integer>. Original file number associated with a stream. Used to restore the old file descriptor when the stream is closed.
	fd		<integer>. Current file number associated with the stream.

'!
!StdioFileStream categoriesForClass!Collections-Streams! !
!StdioFileStream methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses). The default is self."

	^stream!

atEnd
	"Answer whether the receiver is at the end of its values."

	^(crtlib feof: stream) or: 
			["feof returns non-zero only when an attempt has been made to read past the
			 end of stream. If attached to a file (as opposed to a device) we may be
			 positioned beyond the end of stream"
			self isDevice not and: [self position >= self size]]!

attach: anExternalHandle toFd: fdInteger mode: aString type: aSymbol
	"Private - Attach the stdio descriptor identified by fdInteger (usually one of 0=stdin,
	1=stdout, or 2-stderr) to the specified OS file, and open a stdio stream onto it in the
	specified stdio mode."

	| handle newFd |
	crtlib := CRTLibrary default.
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
		mode: aString!

basicNext
	"Private - Answer an <integer> in the range 0..255, being the next of the receiver's future sequence
	values."

	^self basicNextAvailable ifNil: [self errorEndOfStream]!

basicNext: anInteger
	"Private - Answer a <sequencedReadableCollection> containing the next anInteger number of objects
	accessible by the receiver."

	^self
		basicNext: anInteger
		into: (self contentsSpecies new: anInteger)
		startingAt: 1!

basicNext: countInteger into: aSequenceableCollection startingAt: startInteger
	"Private - Destructively replace the elements of the argument, aSequenceableCollection,
	(which must be some sort of byte object or <ExternalStructure> type object
	which holds bytes) in the interval (startAt..startAt+count-1) with the next, count, 
	elements of the receiver. Answer aSequenceableCollection."

	| read start |
	start := startInteger - 1.
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
	crtlib
		fwrite: aSequenceableCollection yourAddress + startInteger - 1
		size: aSequenceableCollection class elementSize
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

basicNextAvailable
	"Private - Answer the next raw element in the stream, or nil if at end."

	"Implementation note: If connected to device then is it possible for fgetc to both block and to return
	a value other than -1 even when feof() returns true. After a ^Z (EOF) character has been encountered in the
	input stream, feof() will subsequently return true. However, since the device stream is not actually at end,
	fgetc() will block awaiting further input when called. If further input is provided, this will be returned, even
	though feof() remains true. To avoid this contradictory behaviour we test up front for feof() (via #atEnd)
	and do not attempt to read further input."

	^(crtlib feof: stream)
		ifFalse: 
			[| ch |
			ch := crtlib fgetc: stream.
			ch == -1 ifFalse: [ch]]!

basicNextAvailable: anInteger
	"Private - Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	"Implementation Note: Override superclass for improved performance."

	| read buf elemSize |
	self atEnd ifTrue: [^self bufferClass new: 0].
	buf := self bufferClass newFixed: anInteger.
	elemSize := buf class elementSize.
	read := crtlib
				fread_s: buf
				bufferSize: buf size * elemSize
				elementSize: elemSize
				count: anInteger
				stream: stream.
	^read < anInteger ifTrue: [buf copyFrom: 1 to: read] ifFalse: [buf]!

basicNextPut: anInteger
	"Private - Store the byte <integer> (range 0..255) as the next element of the receiver."

	crtlib fputc: anInteger stream: stream.
	^anInteger!

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

errorNotPositionable
	^self error: 'The stdio stream is not positionable'!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^self subclassResponsibility!

fileno
	^fd!

fileSize
	^crtlib _filelengthi64: self fileno!

finalize
	self close!

flush
	"Flush any buffered modifications to the file."

	crtlib fflush: stream!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self isText not!

isDevice
	"Answer whether the CRT stream is connected to a device."

	^flags anyMask: DeviceMask!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	<gettableStream> protocol)."

	^true!

isText
	"Answer whether the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	<puttableStream> protocol)."

	^(flags anyMask: ReadOnlyMask) not!

name
	^name ifNil: ['%<<1d>%>' expandMacrosWith: self fileno]!

next
	"Answer a <Character> or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values."

	^self subclassResponsibility!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

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

	^self bufferPrototype decodeNext: anInteger from: self!

nextPut: anObject
	"Store the <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	^self basicNextPut: anObject!

nextPutAll: aCollection 
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^aCollection appendToStream: self!

open: pathString mode: modeString
	| handle errno |
	handle := ExternalHandle new.
	errno := CRTLibrary default
				_wfopen_s: handle
				filename: pathString
				mode: modeString.
	errno ~~ 0 ifTrue: [^CRTError signalWith: errno].
	self
		setStream: handle
		name: pathString
		mode: modeString!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	^self subclassResponsibility!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	^self subclassResponsibility!

position
	"Answer the absolute (zero-based) position of the file pointer."

	^crtlib _ftelli64: stream!

position: anInteger
	"Set the receiver's current position reference for accessing the collection to the the
	argument, anInteger. If the argument is not within the bounds of the receiver's collection,
	or if the associated stdio stream is not positionable, report an error."

	self seek: SEEK_SET offset: anInteger!

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
		ifTrue: [CRTError signal]!

setStream: anExternalAddress name: aString mode: modeString
	stream := anExternalAddress asExternalHandle.
	flags := modeString first == $r ifTrue: [ReadOnlyMask] ifFalse: [0].
	name := aString.
	crtlib := CRTLibrary default.
	fd := crtlib _fileno: stream.
	self beFinalizable.
	(crtlib _isatty: fd)
		ifTrue: 
			[crtlib := CRTLibrary nonblocking.
			flags := flags bitOr: DeviceMask]!

setToEnd
	"Set the file pointer to the end of the file."

	self seek: SEEK_END offset: 0!

size
	"Answer the size of the file in bytes. Enquiring the size of streams connected
	to, for example, stdin is an error."

	| len |
	"We have to flush in order for any data written to the stream buffer past the previous end of file to be taken into account."
	self flush.
	^(len := self fileSize) < 0 ifTrue: [CRTError signal] ifFalse: [len]!

skip: anInteger
	"Adjust the receiver's position by the <integer> argument."

	"Note this adjusts the raw position. It should not be used when streaming over UTF encoded strings."

	self seek: SEEK_CUR offset: anInteger!

space
	"Store a space character as the next element of the receiver."

	self nextPut: $\x20!

tab
	"Store a tab character as the next element of the receiver."

	self nextPut: $\t!

tab: anInteger 
	"Append the specified number of tabs to the receiver."

	anInteger timesRepeat: [self tab]! !
!StdioFileStream categoriesFor: #asParameter!converting!public! !
!StdioFileStream categoriesFor: #atEnd!public!testing! !
!StdioFileStream categoriesFor: #attach:toFd:mode:type:!initializing!private! !
!StdioFileStream categoriesFor: #basicNext!accessing!private! !
!StdioFileStream categoriesFor: #basicNext:!accessing!private! !
!StdioFileStream categoriesFor: #basicNext:into:startingAt:!accessing!private! !
!StdioFileStream categoriesFor: #basicNext:putAll:startingAt:!accessing!private! !
!StdioFileStream categoriesFor: #basicNextAvailable!accessing!private! !
!StdioFileStream categoriesFor: #basicNextAvailable:!accessing!private! !
!StdioFileStream categoriesFor: #basicNextPut:!accessing!private! !
!StdioFileStream categoriesFor: #bufferClass!constants!private! !
!StdioFileStream categoriesFor: #bufferPrototype!constants!private! !
!StdioFileStream categoriesFor: #close!operations!public! !
!StdioFileStream categoriesFor: #contents!accessing!public! !
!StdioFileStream categoriesFor: #contentsSpecies!constants!private! !
!StdioFileStream categoriesFor: #errorNotPositionable!exceptions!private! !
!StdioFileStream categoriesFor: #externalType!accessing!public! !
!StdioFileStream categoriesFor: #fileno!accessing!private! !
!StdioFileStream categoriesFor: #fileSize!accessing!public! !
!StdioFileStream categoriesFor: #finalize!finalizing!private! !
!StdioFileStream categoriesFor: #flush!buffer!public! !
!StdioFileStream categoriesFor: #isBinary!public!testing! !
!StdioFileStream categoriesFor: #isDevice!public!testing! !
!StdioFileStream categoriesFor: #isReadable!public!testing! !
!StdioFileStream categoriesFor: #isText!public!testing! !
!StdioFileStream categoriesFor: #isWriteable!public!testing! !
!StdioFileStream categoriesFor: #name!accessing!public! !
!StdioFileStream categoriesFor: #next!accessing!public! !
!StdioFileStream categoriesFor: #next:put:!accessing!public! !
!StdioFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioFileStream categoriesFor: #nextAvailable:!accessing!public! !
!StdioFileStream categoriesFor: #nextPut:!accessing!public! !
!StdioFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioFileStream categoriesFor: #open:mode:!instance creation!private! !
!StdioFileStream categoriesFor: #peek!accessing!public! !
!StdioFileStream categoriesFor: #peekFor:!accessing!public! !
!StdioFileStream categoriesFor: #position!accessing!public! !
!StdioFileStream categoriesFor: #position:!positioning!public! !
!StdioFileStream categoriesFor: #reset!positioning!public! !
!StdioFileStream categoriesFor: #seek:offset:!helpers!positioning!private! !
!StdioFileStream categoriesFor: #setStream:name:mode:!initializing!private! !
!StdioFileStream categoriesFor: #setToEnd!positioning!public! !
!StdioFileStream categoriesFor: #size!accessing!public! !
!StdioFileStream categoriesFor: #skip:!positioning!public! !
!StdioFileStream categoriesFor: #space!constants!public! !
!StdioFileStream categoriesFor: #tab!accessing!public! !
!StdioFileStream categoriesFor: #tab:!accessing!public! !

StdioFileStream methodProtocol: #collectionStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
StdioFileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
StdioFileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!

!StdioFileStream class methodsFor!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol type: aSymbol
	"Answer a new instance of the receiver representing a text stdio stream with the file
	descriptor, fdInteger, attached to the OS file handle, anExternalHandle, The <symbol>
	argument identifies the manner in which the file is opened, #read for a read-only stream
	(e.g. stdin), or any other mode integer for a writable stream."

	^(self classForEncoding: aSymbol) basicNew
		attach: anExternalHandle
		toFd: fdInteger
		mode: (self attachMode: modeSymbol)
		type: #text!

attachMode: modeSymbol
	^String with: (modeSymbol == #read ifTrue: [$r] ifFalse: [$w]) with: self encodingMode!

classForEncoding: typeSymbol
	^(ClassForEncoding lookup: typeSymbol) ifNil: [self error: 'Unsupported encoding ' , typeSymbol]!

encodingMode
	^$b!

fromHandle: anExternalHandle
	"Answer a new instance of the receiver on the specified stdio FILE pointer,
	assumed to be in text mode."

	#todo "Can we determine the encoding?".
	^self
		newStream: anExternalHandle
		name: nil
		type: #text
		mode: 'w+'!

initialize
	self addClassConstant: 'ReadOnlyMask' value: 16r01.
	self addClassConstant: 'DeviceMask' value: 16r40.
	self addClassConstant: 'EncodingMask' value: 16r78.
	self addClassConstant: 'ClassForEncoding'
		value: (IdentityDictionary new
				at: #binary put: StdioBinaryFileStream;
				at: #ansi put: StdioAnsiFileStream;
				at: #text put: StdioAnsiFileStream;
				at: #utf8 put: StdioUtf8FileStream;
				at: #utf16le put: StdioUtf16FileStream;
				yourself)!

newStream: anExternalHandle name: nameString type: aSymbol mode: modeString
	^(self classForEncoding: aSymbol) basicNew
		setStream: anExternalHandle
		name: nameString
		mode: modeString!

on: aFile
	"Answer an intance of the receiver attached to the open file aFile."

	^self on: aFile text: true!

on: aFile text: aBoolean
	"Answer an intance of the receiver attached to the open file aFile, in binary or text mode
	depending on the argument, aBoolean."

	^self on: aFile type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: aFile type: aSymbol
	"Answer an intance of the receiver attached to the open file aFile, in binary or text mode
	depending on the argument, aBoolean."

	| kernel oshandle proc crt fd handle mode encoding |
	aFile isReadable ifFalse: [self error: 'must be attached to a readable file'].
	encoding := aSymbol == #text ifTrue: [String encodingName: aFile sniffEncoding] ifFalse: [aSymbol].
	oshandle := ExternalHandle new.
	kernel := KernelLibrary default.
	proc := kernel getCurrentProcess.
	(kernel
		duplicateHandle: proc
		hSourceHandle: aFile asParameter
		hTargetProcessHandle: proc
		lpTargetHandle: oshandle
		dwDesiredAccess: 0
		bInheritHandle: false
		dwOptions: Win32Constants.DUPLICATE_SAME_ACCESS) ifFalse: [KernelLibrary default systemError].
	crt := CRTLibrary default.
	fd := crt _open_osfhandle: oshandle flags: 0.
	aFile isWriteable ifTrue: [mode := 'r+'] ifFalse: [mode := 'r'].
	encoding == #binary ifTrue: [mode := mode copyWith: $t] ifFalse: [mode := mode copyWith: $b].
	handle := crt _fdopen: fd mode: mode.
	handle isNil ifTrue: [CRTError signal].
	^self
		newStream: handle
		name: aFile name
		type: encoding
		mode: mode!

open: fileId mode: modeSymbol check: aBoolean type: typeSymbol
	| stream encoding path exists mode |
	path := fileId asUtf16String.
	exists := File exists: fileId.
	modeSymbol == #create
		ifTrue: 
			["open an existing file, or create a new file, for read/write, positioned at the beginning. 
		If check = true and file exists raise an error, else use the existing file"
			mode := exists
						ifTrue: 
							[aBoolean ifTrue: [self error: 'File already exists'].
							'r+']
						ifFalse: ['w+']].
	"Note that Smalltalk #append mode is unlike the 'a' and 'a+' fopen() modes, because
	in Smalltalk the mode only controls the initial file position, and it is possible to overwrite
	the existing data by moving the stream pointer backwards. With the fopen() append
	modes it is not possible to overwrite the existing data."
	(modeSymbol == #append or: [modeSymbol == #open])
		ifTrue: 
			[(aBoolean and: [exists not]) ifTrue: [CRTError signalWith: 2].
			mode := exists ifTrue: ['r+'] ifFalse: ['w+']].
	modeSymbol == #truncate
		ifTrue: 
			[(aBoolean and: [exists not]) ifTrue: [CRTError signalWith: 2].
			mode := 'w+'].
	modeSymbol == #read ifTrue: [mode := 'r'].
	encoding := typeSymbol == #text
				ifTrue: [exists ifTrue: [String encodingName: (File sniffEncoding: path)] ifFalse: [#ansi]]
				ifFalse: [typeSymbol].
	encoding == #binary
		ifTrue: [mode := mode copyWith: $b]
		ifFalse: 
			[encoding == #utf8 ifTrue: [mode := mode , 't, ccs=UTF-8'].
			encoding == #utf16le ifTrue: [mode := mode , 't, ccs=UTF-16LE']].
	stream := (self classForEncoding: encoding) basicNew.
	stream open: path mode: mode.
	modeSymbol == #append ifTrue: [stream setToEnd].
	^stream!

read: aString 
	"Answer a new text mode instance of the receiver whose future sequence values consist
	of the textual contents of the file identified by the <readableString> argument."

	^self read: aString text: true!

read: aString text: aBoolean
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file named, aString, and whose access is character
	based or binary, depending on the <boolean> argument. Raise an exception
	if the file does not exist."

	^self read: aString type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

read: aString type: aSymbol
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file named, aString, and whose access is character
	based or binary, depending on the <boolean> argument. Raise an exception
	if the file does not exist."

	^self open: aString mode: #read check: true type: aSymbol!

write: aString 
	"Answer a new text mode instance of the receiver opened on a new or truncated file 
	identified by the <readableString> argument."

	^self write: aString mode: #truncate!

write: aString mode: aSymbol 
	"Answer a new instance of the receiver open on the textual contents of
	the file identified by the <readableString> argument.
	See #write:mode:check:type: for a description of the mode <symbol> 
	argument."

	^self 
		write: aString
		mode: aSymbol
		check: false
		text: true!

write: aString mode: aSymbol check: checkBoolean text: textBoolean
	"Answer a new instance of the receiver open on the contents of
	the file identified by the <readableString> argument.
	The <symbol> argument identifies the manner in which the file is opened.
	It may be one of:
		#create 	create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its start.
	See also the File class for further information on the mode.
	The first <boolean> argument determines whether or not  errors are reported 
	if the file does or does not exist (depending on the mode). 
	The final <boolean> argument specifies the external type (#binary or #text) 
	for which the new instance is initially configured."

	^self
		write: aString
		mode: aSymbol
		check: checkBoolean
		type: (textBoolean ifTrue: [#text] ifFalse: [#binary])!

write: fileId mode: modeSymbol check: aBoolean type: typeSymbol
	"Answer a new instance of the receiver open on the contents of the file identified by the
	<readableString> argument. The first <symbol> argument identifies the manner in which the
	file is opened. See the File class for details.

	The <boolean> argument determines whether or not errors are reported if the file does or
	does not exist (depending on the mode).

	The final <symbol> argument specifies the external type (#binary or #text) for which the new
	instance is initially configured."

	^self
		open: fileId
		mode: modeSymbol
		check: aBoolean
		type: typeSymbol!

write: aString text: aBoolean 
	"Create a new file/truncate an existing file for read/write access through the receiver.
	The stream will expect characters or bytes depending on the value of the <boolean>
	argument."

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
!StdioFileStream class categoriesFor: #attach:toFd:mode:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #attachMode:!helpers!private! !
!StdioFileStream class categoriesFor: #classForEncoding:!helpers!private! !
!StdioFileStream class categoriesFor: #encodingMode!constants!private! !
!StdioFileStream class categoriesFor: #fromHandle:!instance creation!public! !
!StdioFileStream class categoriesFor: #initialize!development!initializing!public! !
!StdioFileStream class categoriesFor: #newStream:name:type:mode:!instance creation!private! !
!StdioFileStream class categoriesFor: #on:!instance creation!public! !
!StdioFileStream class categoriesFor: #on:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #on:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #open:mode:check:type:!instance creation!private! !
!StdioFileStream class categoriesFor: #read:!instance creation!public! !
!StdioFileStream class categoriesFor: #read:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #read:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:check:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:check:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:type:!public! !

StdioFileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

