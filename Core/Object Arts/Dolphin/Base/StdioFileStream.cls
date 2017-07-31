"Filed out from Dolphin Smalltalk 7"!

SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream isText name oldFd'
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
StdioFileStream guid: (GUID fromString: '{7b8405b3-0819-421f-8110-ca2763bcb59a}')!
StdioFileStream comment: 'StdioFileStream is a <FileStream> implemented over C runtime library stdio streams. Its main purpose is to wrap the stdin, stdout, and stderr streams in console applications, and it is not intended for general use. In order to avoid blocking the main Dolphin thread when attempting to read from stdin, the CRT stream I/O calls are overlapped (i.e. run on a threadpool thread), which makes them rather slow. FileStream itself should be used by preference in most cases.

Instance Variables:
	stream	<ExternalHandle>. FILE* stream handle.
	isText	<Boolean>. Whether or not this is a text stream.
	name	<String>. Path of file. Can be nil, e.g. if connected to standard I/O handle

'!
!StdioFileStream categoriesForClass!Collections-Streams! !
!StdioFileStream methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses). The default is self."

	^stream!

atEnd
	"Answer whether the receiver cannot access any more objects"

	| crt |
	crt := CRTLibrary default.
	^(crt feof: stream) ~~ 0 or: 
			["feof returns non-zero only when an attempt has been made to read past the end of stream, so we have to peek."
			| ch |
			(ch := crt fgetc: stream) == -1 or: 
					[crt ungetc: ch stream: stream.
					false]]!

attach: anExternalHandle toFd: fdInteger mode: aSymbol text: aBoolean 
	"Private - Attach the stdio descriptor identified by fdInteger (usually one of 0=stdin,
	1=stdout, or 2-stderr) to the specified OS file, and open a stdio stream onto it in the
	specified read/write and text/binary modes (usual Smalltalk FileStream conventions for the
	interpretation of the mode and text parameters applies)."

	| newFd crt |
	crt := CRTLibrary default.
	"1: Preserve the existing file descriptor (fd) for later restoration by dup'ing it"
	oldFd := crt _dup: fdInteger.
	oldFd < 0 ifTrue: [CRTError signal].
	"2: Attach an fd to the provided OS file handle"
	newFd := crt _open_osfhandle: anExternalHandle flags: 0.
	newFd < 0 ifTrue: [CRTError signal].
	"3: Redirect target fd to the OS file"
	(crt _dup2: newFd handle2: fdInteger) < 0 ifTrue: [CRTError signal].
	"4: Dispose of the fd created in step 2 and dup'd in step 3 so we don't leak it and the duplicate OS handle it contains"
	(crt _close: newFd) < 0 ifTrue: [CRTError signal].
	"5: Finally open a stdio stream onto the target fd"
	stream := crt _fdopen: fdInteger
				mode: (aSymbol == #read ifTrue: ['r'] ifFalse: ['w']) , (aBoolean ifTrue: ['t'] ifFalse: ['b']).
	stream isNil ifTrue: [CRTError signal].
	isText := aBoolean.
	self beFinalizable!

basicPrint: anObject 
	anObject basicPrintOn: self!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state. Answer the receiver."

	| stdFd |
	stream isNull ifTrue: [^self].
	self beUnfinalizable.
	stdFd := self fileno.
	CRTLibrary default fclose: stream.
	stream := nil.
	oldFd isNil 
		ifFalse: 
			["Restore original stdio stream from saved descriptor"
			(CRTLibrary default)
				_dup2: oldFd handle2: stdFd;
				_close: oldFd.
			oldFd := nil]!

contents
	"Answer a <String> or <ByteArray> containing the complete contents of the file
	accessed by the receiver."

	| len |
	self reset.
	len := CRTLibrary default _filelength: self fileno.
	^len == -1 ifTrue: [self upToEnd] ifFalse: [self next: len]!

contentsSpecies
	^isText ifTrue: [String] ifFalse: [ByteArray]!

cr
	"Store the line delimiter character sequence (as required by
	the environment) as the next element(s) of the receiver."

	"Implementation Note: Assumes the receiver is in text mode, and 
	will translate the single LF character to a CR/LF pair on output."

	self nextPut: $\n!

crtab
	"Append a line-delimiter and a tab to the receiver."

	self cr; tab!

crtab: anInteger 
	"Append a line-delimiter and the specified number of tabs to the receiver."

	self
		cr;
		tab: anInteger!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^self isText ifFalse: [#binary] ifTrue: [#text]!

fileno
	^CRTLibrary default _fileno: stream!

finalize
	self close!

flush
	"Flush any buffered modifications to the file."

	CRTLibrary default fflush: stream!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self isText not!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	<gettableStream> protocol)."

	^true!

isText
	"Answer whether if the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^isText!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	<puttableStream> protocol)."

	^true!

name
	^name ifNil: ['%<<1d>%>' expandMacrosWith: self fileno]!

next
	"Answer a <Character> or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values."

	| ch |
	ch := CRTLibrary default fgetc: stream.
	^ch == -1
		ifTrue: [self errorEndOfStream]
		ifFalse: [isText ifTrue: [Character value: ch] ifFalse: [ch]]!

next: countInteger into: aSequenceableCollection startingAt: startInteger
	"Destructively replace the elements of the argument, aSequenceableCollection,
	(which must be some sort of byte object or <ExternalStructure> type object
	which holds bytes) in the interval (startAt..startAt+count-1) with the next, count, 
	elements of the receiver. Answer aSequenceableCollection."

	| read elemSize offset |
	elemSize := aSequenceableCollection class elementSize.
	offset := (startInteger - 1) * elemSize.
	read := CRTLibrary default
				fread_s: aSequenceableCollection yourAddress + offset
				bufferSize: aSequenceableCollection byteSize - offset
				elementSize: elemSize
				count: countInteger
				stream: stream.
	read = countInteger ifFalse: [^self errorEndOfStream].
	^aSequenceableCollection!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger 
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	CRTLibrary default 
		fwrite: aSequenceableCollection yourAddress + startInteger - 1
		size: aSequenceableCollection class elementSize
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	"Implementation Note: Override superclass for improved performance. The superclass method is
	particularly slow for StdioFileStream because the atEnd test has to peek the stream because
	feof() returns false until one has read off the end of the stream (or read the Ctrl+Z
	character)."

	| read buf bufClass |
	bufClass := self contentsSpecies.
	buf := bufClass newFixed: anInteger.
	read := CRTLibrary default
				fread_s: buf
				bufferSize: buf byteSize
				elementSize: bufClass elementSize
				count: anInteger
				stream: stream.
	^read < anInteger ifTrue: [buf copyFrom: 1 to: read] ifFalse: [buf]!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	| buf answer len last |
	isText ifFalse: [self error: 'Invalid operation for binary streams'].
	buf := String new: 128.
	answer := ''.
	
	[| part |
	part := CRTLibrary default 
				fgets: buf
				n: buf byteSize
				stream: stream.
	part isNil 
		ifTrue: 
			["Hit eof"

			^answer , buf trimNulls].
	answer := answer , part.
	part size = 128] 
			whileTrue.
	len := answer size.
	"Strip off the line terminator, allowing for binary or text mode"
	last := answer at: len.
	^last == $\n
		ifTrue: 
			[(len > 1 and: [(answer at: len - 1) == $\r]) 
				ifTrue: [answer copyFrom: 1 to: len - 2]
				ifFalse: [answer copyFrom: 1 to: len - 1]]
		ifFalse: [last == $\r ifTrue: [answer copyFrom: 1 to: len - 1] ifFalse: [answer]]!

nextOrNil
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	| ch |
	ch := CRTLibrary default fgetc: stream.
	^ch == -1
		ifFalse: [isText ifTrue: [Character value: ch] ifFalse: [ch]]!

nextPut: anObject 
	"Store the <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	CRTLibrary default fputc: anObject asInteger stream: stream.
	^anObject!

nextPutAll: aCollection 
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^aCollection appendToStream: self!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	| ch |
	ch := CRTLibrary default fgetc: stream.
	^ch == -1
		ifFalse: 
			[CRTLibrary default ungetc: ch stream: stream.
			isText ifTrue: [Character value: ch] ifFalse: [ch]]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	| ch |
	ch := CRTLibrary default fgetc: stream.
	^ch ~~ -1
		and: [anObject asInteger == ch or: 
					[CRTLibrary default ungetc: ch stream: stream.
					false]]!

position
	"Answer the absolute (zero-based) position of the file pointer."

	^CRTLibrary default ftell: stream!

position: anInteger 
	"Set the receiver's current position reference for accessing the collection
	to the the argument, anInteger. If the argument is not within the bounds of
	the receiver's collection, report an error."

	CRTLibrary default 
		fseek: stream
		offset: anInteger
		origin: SEEK_SET!

reset
	"Set the receiver's position reference to the beginning of the collection"

	CRTLibrary default rewind: stream!

setStream: anExternalAddress isText: aBoolean name: aString 
	stream := anExternalAddress asExternalHandle.
	isText := aBoolean.
	name := aString.
	self beFinalizable!

setToEnd
	"Set the file pointer to the end of the file."

	CRTLibrary default 
		fseek: stream
		offset: 0
		origin: SEEK_END!

size
	"Answer the size of the file in bytes. Enquiring the size of streams connected
	to, for example, stdin is an error."

	| len |
	self flush.
	^(len := CRTLibrary default _filelength: self fileno) == -1 
		ifTrue: [CRTError signal]
		ifFalse: [len]!

skip: anInteger 
	"Adjust the receiver's position by the <integer> argument."

	CRTLibrary default 
		fseek: stream
		offset: anInteger
		origin: SEEK_CUR!

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
!StdioFileStream categoriesFor: #attach:toFd:mode:text:!initializing!private! !
!StdioFileStream categoriesFor: #basicPrint:!printing!private! !
!StdioFileStream categoriesFor: #close!operations!public! !
!StdioFileStream categoriesFor: #contents!accessing!public! !
!StdioFileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioFileStream categoriesFor: #cr!accessing!public! !
!StdioFileStream categoriesFor: #crtab!accessing!public! !
!StdioFileStream categoriesFor: #crtab:!accessing!public! !
!StdioFileStream categoriesFor: #externalType!accessing!public! !
!StdioFileStream categoriesFor: #fileno!accessing!private! !
!StdioFileStream categoriesFor: #finalize!finalizing!private! !
!StdioFileStream categoriesFor: #flush!buffer!public! !
!StdioFileStream categoriesFor: #isBinary!public!testing! !
!StdioFileStream categoriesFor: #isReadable!public!testing! !
!StdioFileStream categoriesFor: #isText!public!testing! !
!StdioFileStream categoriesFor: #isWriteable!public!testing! !
!StdioFileStream categoriesFor: #name!accessing!public! !
!StdioFileStream categoriesFor: #next!accessing!public! !
!StdioFileStream categoriesFor: #next:into:startingAt:!accessing!public! !
!StdioFileStream categoriesFor: #next:put:!accessing!public! !
!StdioFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioFileStream categoriesFor: #nextAvailable:!accessing!public! !
!StdioFileStream categoriesFor: #nextLine!accessing!public! !
!StdioFileStream categoriesFor: #nextOrNil!accessing!public! !
!StdioFileStream categoriesFor: #nextPut:!accessing!public! !
!StdioFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioFileStream categoriesFor: #peek!accessing!public! !
!StdioFileStream categoriesFor: #peekFor:!accessing!public! !
!StdioFileStream categoriesFor: #position!accessing!public! !
!StdioFileStream categoriesFor: #position:!positioning!public! !
!StdioFileStream categoriesFor: #reset!positioning!public! !
!StdioFileStream categoriesFor: #setStream:isText:name:!initializing!private! !
!StdioFileStream categoriesFor: #setToEnd!positioning!public! !
!StdioFileStream categoriesFor: #size!accessing!public! !
!StdioFileStream categoriesFor: #skip:!positioning!public! !
!StdioFileStream categoriesFor: #space!constants!public! !
!StdioFileStream categoriesFor: #tab!accessing!public! !
!StdioFileStream categoriesFor: #tab:!accessing!public! !

StdioFileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
StdioFileStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
StdioFileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!
StdioFileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!StdioFileStream class methodsFor!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol 
	"Answer a new instance of the receiver representing a text stdio stream with the file
	descriptor, fdInteger, attached to the OS file handle, anExternalHandle, The <symbol>
	argument identifies the manner in which the file is opened, #read for a read-only stream
	(e.g. stdin), or any other mode integer for a writable stream."

	^self 
		attach: anExternalHandle
		toFd: fdInteger
		mode: modeSymbol
		text: true!

attach: anExternalHandle toFd: fdInteger mode: modeSymbol text: aBoolean 
	"Answer a new instance of the receiver representing a stdio stream with the file descriptor,
	fdInteger, attached to the OS file handle, anExternalHandle, The <symbol> argument
	identifies the manner in which the file is opened, #read for a read-only stream (e.g.
	stdin), or any other mode integer for a writable stream. If aBoolean is true, then the
	stream is in text translation mode, if false it is in binary mode."

	^self basicNew 
		attach: anExternalHandle
		toFd: fdInteger
		mode: modeSymbol
		text: aBoolean!

fromHandle: anExternalHandle
	"Answer a new instance of the receiver on the specified stdio FILE pointer,
	assumed to be in text mode."

	^self basicNew 
		setStream: anExternalHandle
		isText: true
		name: nil!

read: aString 
	"Answer a new text mode instance of the receiver whose future sequence values consist
	of the textual contents of the file identified by the <readableString> argument."

	^self read: aString text: true!

read: aString text: aBoolean
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file named, aString, and whose access is character
	based or binary, depending on the <boolean> argument. Raise an exception
	if the file does not exist."

	| handle errno |
	handle := ExternalHandle new.
	^(errno := CRTLibrary default
				fopen_s: handle
				filename: aString
				mode: (aBoolean ifTrue: ['rt'] ifFalse: ['rb'])) == 0
		ifTrue: 
			[self basicNew
				setStream: handle
				isText: aBoolean
				name: aString]
		ifFalse: [CRTError signalWith: errno]!

read: aString type: aSymbol 
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file identified by the <readableString> argument, and 
	whose external stream type and sequence value type is determined by the
	<symbol> argument (i.e. either #binary or #text)."

	^self read: aString text: aSymbol == #text!

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

	| answer handle |
	checkBoolean
		ifTrue: 
			[| exists |
			exists := File exists: aString.
			aSymbol == #create
				ifTrue: [exists ifTrue: [self error: 'File already exists']]
				ifFalse: [exists ifFalse: [self error: 'File does not exist']]].
	"Note that Smalltalk #append mode is unlike the 'a' and 'a+' fopen() modes, because
	in Smalltalk the mode only controls the initial file position, and it is possible to overwrite
	the existing data by moving the stream pointer backwards. With the fopen() append
	modes it is not possible to overwrite the existing data."
	handle := ExternalHandle new.
	CRTLibrary default
		fopen_s: handle
		filename: aString
		mode: (aSymbol == #append ifTrue: ['r+'] ifFalse: ['w+'])
				, (textBoolean ifTrue: ['t'] ifFalse: ['b']).
	answer := (self basicNew)
				setStream: handle
					isText: textBoolean
					name: aString;
				yourself.
	aSymbol == #append ifTrue: [answer setToEnd].
	^answer!

write: fileId mode: mode check: aBoolean type: typeSymbol 
	"Answer a new instance of the receiver open on the contents of
	the file identified by the <readableString> argument.
	The first <symbol> argument identifies the manner in which the file
	is opened. It may be one of:
		#create 	create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its start.
	See also the File class for further information on the mode.
	The <boolean> argument determines whether or not errors are reported 
	if the file does or does not exist (depending on the mode). The final <symbol>
	argument specifies the external type (#binary or #text) for which the new instance 
	is initially configured."

	^self 
		write: fileId
		mode: mode
		check: aBoolean
		text: typeSymbol == #text!

write: aString text: aBoolean 
	"Create a new file/truncate an existing file for read/write access through the receiver.
	The stream will expect characters or bytes depending on the value of the <boolean>
	argument."

	^self 
		write: aString
		mode: #truncate
		check: false
		text: aBoolean! !
!StdioFileStream class categoriesFor: #attach:toFd:mode:!instance creation!public! !
!StdioFileStream class categoriesFor: #attach:toFd:mode:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #fromHandle:!instance creation!public! !
!StdioFileStream class categoriesFor: #read:!instance creation!public! !
!StdioFileStream class categoriesFor: #read:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #read:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:check:text:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:mode:check:type:!instance creation!public! !
!StdioFileStream class categoriesFor: #write:text:!instance creation!public! !

StdioFileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

