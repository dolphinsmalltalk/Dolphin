"Filed out from Dolphin Smalltalk"!

Core.ReadWriteStream
	subclass: #'Core.FileStream'
	instanceVariableNames: 'file flags pageBase logicalFileSize offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'BufferUpdatedMask' -> 16r3.
			'DirtyBufferMask' -> 16r2.
			'LimitsChangedMask' -> 16r1.
			'OwnsFile' -> 16r100.
			'PageSize' -> 16r2000
		}!

Core.FileStream guid: (Core.GUID fromString: '{87b4c6ff-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.FileStream comment: '`FileStream` is a specialized `ReadWriteStream` for streaming over binary and text files. It is designed to support random access, so expects that the underlying file is always readable and positionable. It will not work over file handles that support only serial access, such as pipes, sockets, or standard i/o handles.

The `collection` instance variable inherited from `Stream` is used to hold a fixed size buffer representing a cached ''page'' of the actual file. This is flushed back to the file either when a new page is loaded, or when explictly requested by `flush` or `fullFlush`. The `readLimit` and `writeLimit` instance variables inherited from `PositionableStream` and `WriteStream` respectively have a different usage in this class than in their defining classes; they are the limits for the current page rather than the whole stream. The `readLimit` will always be equal to the page size, except on the last page of the file. The `writeLimit` is always equal to the page size. This use of the superclass instance variables allows us to use the stream primitives for very efficient access within the current page, which means that even single character I/O is reasonably fast..

FileStream can read and write files as binary or text. It support the following encodings:
	`#ansi`		- Text encoded using the current ANSI code page (not that DBCS code pages are not properly supported because `AnsiString` does not support multi-byte characters)
	`#binary`		- Raw binary i/o.
	`#text`		- Default text encoding. When reading will attempt to deduce the encoding of the underlying file. When writing a new file, this is equivalent to `#utf8`.
	`#utf8`		- UTF-8 encoded text. When writing a new file, will write UTF-8 with a BOM.

Reading and writing of UTF-16 format text files is not supported (i.e. `#utf16le` and `#utf16be` encodings are not supported).

## Instance Variables:
  `file`			The `File` being streamed over. Must be readable and support random access.
  `flags`			`<integer>` flags such as whether the page buffer is dirty.
  `pageBase`		`<integer>` offset of the page currently in the buffer. Always a multiple of the page size, plus 1.
  `logicalFileSize`	`<integer>` size of the file. This is cached because it is expensive to determine dynamically.
  `offset`			`<integer>` offset from the start of the file at which the actual data begins. This is used to allow the presence of a BOM to be invisible to applications.

## Class Variables:
  `BufferUpdatedMask`	`<integer>` flags set when a write to the buffer occurs (both of the following two flags)
  `DirtyBufferMask`		`<integer>` flag set when the buffer contains updated data that has not yet been written to disk
  `LimitsChangedMask`	`<integer>` flag set when a write to the buffer has occurred that has not yet been reflected in the lastPosition and/or read limit.
  `OwnsFile`			`<integer>` flag set if the file is owned by a FileStream and should be closed by it.
  `PageSize`			`<integer>` size of the buffer used to hold part of the file contents in memory - chosen to be a reasonably efficient compromise for serial and random I/O.


'!

!Core.FileStream categoriesForClass!Collections-Streams!I/O-Streams! !

!Core.FileStream methodsFor!

absolutePosition
	"Private - Answer the absolute (zero-based) position of the file pointer from the start of
	the file."

	^pageBase + position - 1!

atEnd
	"Answer true if the receiver is positioned at its logical end."

	^position >= readLimit and: 
			[self updateLimits.
			pageBase + position > logicalFileSize]!

basicContentsSpecies
	"Private - Answer the class of Object to be used when answering collections of undecoded
	elements from the receiver."

	^ByteArray!

basicNext
	"Answer the next integer element accessible by the receiver. For a text stream this will be 
	the code unit for the next character or partial character based on the underlying encoding.
	It may not necessarily be a full code point unless the encoding is fixed width (i.e. #ansi, or #utf32)."

	"Primitive failure codes:
		AssertionFailure		The receivers position or readLimit are not SmallInteger values
		NotSupported			The receiver's collection is not an Array, String or ByteArray.
		OutOfBounds			position not in range 0<position<readLimit, or 
							the next position is beyond the end of the streamed over collection."

	<primitive: 221>
	^self atEnd
		ifTrue: [self errorEndOfStream]
		ifFalse: 
			[self position: self position.
			collection basicAt: (position := position + 1)]!

basicNext: count into: aSequenceableCollection startingAt: startAt
	"Private - Destructively replace the elements of the argument, aSequenceableCollection,
	in the interval (startAt..startAt+count-1) with the next, count, elements of
	the receiver. Answer aSequenceableCollection.
	Implementation Note: For efficiency we implement this as a loop which
	transfers as many elements as possible on each iteration, optimally a page
	at a time."

	| startOffset elemsRead |
	startOffset := startAt - 1.
	elemsRead := 0.
	[elemsRead < count] whileTrue: [ | blockSize tmp |
		self atEnd ifTrue: [self errorEndOfStream].
		blockSize := (readLimit - position) min: (count - elemsRead).
		tmp := elemsRead + blockSize.
		aSequenceableCollection
			replaceFrom: startAt + elemsRead
			to: startOffset + tmp
			with: collection
			startingAt: position + 1.
		"Reposition to the start of the next page (or the end of the file)"
		self position: self position + blockSize.
		elemsRead := tmp].
	^aSequenceableCollection!

basicNext: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| stop |
	stop := position + sizeInteger.
	stop <= PageSize
		ifTrue: 
			["The block fits into the current page and can be written directly to the buffer"
			sizeInteger > 0
				ifTrue: 
					[collection
						replaceFrom: position + 1
						to: stop
						with: aSequenceableCollection
						startingAt: startInteger.
					position := stop.
					flags := flags bitOr: BufferUpdatedMask]]
		ifFalse: 
			[self
				overflowBasicNext: sizeInteger
				putAll: aSequenceableCollection
				startingAt: startInteger].
	^aSequenceableCollection!

basicNextPut: anObject
	"Private - Write anObject as the next basic element of the stream. Answer anObject."

	"Implementation Note: Inline the #beDirty operation as a performance optimization."

	self primitiveBasicNextPut: anObject.
	flags := flags bitOr: BufferUpdatedMask.
	^anObject!

basicUpTo: anObject 
	"Private - Answer a <sequencedReadableCollection> of elements starting with the next element accessed
	by the receiver, and up to, but not inclusive of, the next element that is equal to the
	<Object>, anObject. Positions the stream after anObject if found. If anObject is not in the
	collection, answer the entire rest of the collection. If the receiver is at its end, then
	answer an empty collection. It is assumed that anObject requires only one element
	to be represented in the receiver's encoding. If this is not the case the results are undefined."

	| found answer |
	found := false.
	answer := self makeBufferOfSize: 0.
	[found or: [self atEnd]] whileFalse: 
			[| startIndex endIndex |
			self position: self position.
			startIndex := position + 1.
			position := collection 
						nextIndexOf: anObject
						from: startIndex
						to: readLimit.
			(found := position ~~ 0) 
				ifTrue: [endIndex := position - 1]
				ifFalse: [endIndex := position := readLimit].
			answer := answer , (collection copyFrom: startIndex to: endIndex)].
	^answer!

bufferClassFor: aFile type: encSymbol
	| bufClass encoding |
	encoding := encSymbol == #text
				ifTrue: [aFile size == 0 ifTrue: [#utf8] ifFalse: [String encodingName: aFile sniffEncoding]]
				ifFalse: [encSymbol].
	bufClass := ByteBufferClasses lookup: encoding.
	(bufClass isNil or: [bufClass == Utf16String])
		ifTrue: [self error: 'Unsupported encoding ' , encoding printString].
	^bufClass!

close
	"Write any outstanding changes to the file and, if the file is owned by this stream, close it."

	self
		beUnfinalizable;
		free!

contents
	"Answer the contents of the file. For a read-only file answer
	the entire contents. For a writeable file answer the contents
	up to the current position. This will be a <ByteArray> if #isBinary
	is true or a <String> if #isText is true."

	| size contents |
	size := self isWriteable ifTrue: [self position] ifFalse: [self lastPosition].
	contents := self makeBufferOfSize: size.
	self flush.
	file
		position: offset;
		read: contents count: size.
	^contents!

externalType
	"Answer a <symbol> which represents the external stream type of the receiver. This is an ANSI method and deliberately limited to the defined values (although the standard allows additional ones), but see also #encoding."

	^self isBinary ifTrue: [#binary] ifFalse: [#text]!

file
	"Answer the <File> instance over which the receiver is streaming."

	^file!

file: aFile mode: modeSymbol buffer: aSequenceableCollection flags: anInteger
	"Private - Initialize the receiver."

	self on: aSequenceableCollection.
	flags := anInteger.
	file := aFile.
	self beFinalizable.
	offset := 0.
	self readPageFor: 0.
	logicalFileSize := file size.
	collection skipEncodingMarkerFrom: self.
	(logicalFileSize == 0 and: [modeSymbol ~~ #read]) ifTrue: [collection emitEncodingMarkerOn: self].
	offset := position.
	modeSymbol == #append ifTrue: [self setToEnd]!

flush
	"Flush any buffered modifications to the file."

	(flags anyMask: DirtyBufferMask) ifTrue: [self writePage]!

free
	file isNil ifTrue: [^self].
	file handle isNull
		ifFalse: 
			[self flush.
			self ownsFile ifTrue: [file close]].
	file := nil!

fullFlush
	"Flush any buffered modifications to the file and
	force the file to disk."

	self flush.
	file flush.!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self collection class == ByteArray!

isBufferDirty
	"Private - Answer true if the receiver's buffer has been written to."

	^flags anyMask: DirtyBufferMask
!

isText
	"Answer whether if the receiver's data is characters.
	X3J20 (draft) includes rational as to why this message is not called #isCharacter."

	^self isBinary not!

isWriteable
	"Answer whether the receiver can be written to (i.e. it is streaming over a writeable file)."

	^file isWriteable!

lastPosition
	"Private - Answer last position in the file stream."

	"Ensure that any post-open file growth of writeable files is reflected."

	self updateLimits.
	^logicalFileSize - offset!

makeBufferOfSize: anInteger
	"Private - Answer a ByteArray or String of size anInteger depending on whether the receiver
	treats its contents as Characters or Bytes."

	^self contentsSpecies new: anInteger!

name
	"Answer the name of the file to which the receiver is attached."
	
	^file name!

nextAvailable
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the receiver's future sequence values. Answer nil if at EOF."

	<primitive: 65>
	^self atEnd
		ifFalse: 
			[self position: self position.
			self decodeNext]!

nextPut: anIntegerOrCharacter
	"Write anIntegerOrCharacter to the receiver and answer the argument."

	self primitiveNextPut: anIntegerOrCharacter.
	flags := flags bitOr: BufferUpdatedMask.
	^anIntegerOrCharacter!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	self primitiveNextPutAll: aCollection.
	flags := flags bitOr: BufferUpdatedMask.
	^aCollection
!

overflow: anInteger
	"Private - The buffer of a FileStream is fixed at the page size. The collection is effectively a fixed size buffer, 
	and the writeLimit is always the page size."

	^self shouldNotImplement!

overflowBasicNext: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	| startNextPage writeOffset lastPos lastPageStart wholePagesSize |
	lastPos := pageBase + position + sizeInteger - 1.
	writeOffset := PageSize - position.
	"Update and write current page"
	position < PageSize
		ifTrue: 
			[collection
				replaceFrom: position + 1
				to: PageSize
				with: aSequenceableCollection
				startingAt: startInteger.
			position := PageSize.
			flags := flags bitOr: BufferUpdatedMask].
	self flush.
	"Next write any whole pages"
	startNextPage := pageBase + PageSize.
	lastPageStart := (lastPos truncateTo: PageSize) + 1.
	wholePagesSize := lastPageStart - startNextPage.
	wholePagesSize > 0
		ifTrue: 
			[file position: startNextPage - 1.
			0 to: wholePagesSize // PageSize - 1
				do: 
					[:i |
					collection
						replaceFrom: 1
						to: PageSize
						with: aSequenceableCollection
						startingAt: startInteger + writeOffset + (i * PageSize).
					file write: collection count: PageSize].
			self assert: [file position = (lastPageStart - 1)]].

	"And finally buffer any trailing data having repositioned to the correct page"
	self readPageFor: lastPageStart.
	position := lastPos - lastPageStart + 1.
	position > 0
		ifTrue: 
			[collection
				replaceFrom: 1
				to: position
				with: aSequenceableCollection
				startingAt: startInteger + writeOffset + wholePagesSize.
			flags := flags bitOr: BufferUpdatedMask]!

ownsFile
	^flags anyMask: OwnsFile!

ownsFile: aBoolean
	flags := flags mask: OwnsFile set: aBoolean!

position
	"Answer the zero-based position of the stream pointer. Note that position zero is after an
	any BOM at the start of the stream."

	^pageBase + position - offset - 1!

position: anInteger
	"Move the receiver's logical position to absolute (zero-based) position anInteger."

	| pos |
	self updateLimits.
	pos := anInteger + offset + 1.
	(pos < pageBase or: [pos >= (pageBase + PageSize)])
		ifTrue: 
			["anInteger is not within the current page.
			Write out any changes to the current page buffer and read the one required."
			self
				flush;
				readPageFor: anInteger].
	position := pos - pageBase!

primitiveBasicNextPut: anInteger
	<primitive: 222>
	self position: self position.
	^collection basicAt: (position := position + 1) put: anInteger!

primitiveNextPut: anIntegerOrCharacter
	"Private - Write anIntegerOrCharacter to the receiver."

	<primitive: 66>
	self position: self position.
	^collection encodeOn: self put: anIntegerOrCharacter!

readPageFor: anInteger
	"Private - Read the page containing position anInteger and record the pageBase
	and readLimit. The readLimit will be equal to the page size unless there are insufficient
	elements. The writeLimit is always equal to the page/buffer size."

	"PageSize must be power of 2, so can avoid division here."

	pageBase := (anInteger + offset bitAnd: ##((PageSize - 1) bitInvert)) + 1.
	readLimit := file
				position: pageBase - 1;
				read: collection count: PageSize.
	readLimit == PageSize ifTrue: [^self].
	"Zero out the remainder of the buffer to clear any data read for the previously visited page. This is necessary in case we position beyond the current end of file and write some data - we don't want stale data from the previous page showing through."
	OS.Kernel32 zeroMemory: collection yourAddress + readLimit length: PageSize - readLimit!

reset
	self position: 0!

setToEnd
	"Set the file pointer to the end of the file. The current page is flushed and the last page in the file
	will be read, unless already on the last page."

	self position: self lastPosition
!

size
	^self lastPosition!

skip: anInteger
	"Adjust the receiver's position by anInteger ensuring that it remains
	within the bounds of the collection."

	"Note this adjusts the raw position. It should not be used when streaming over UTF encoded content."

	self position: ((self position + anInteger max: 0) min: self size - 1)!

underflow
	"Private - An attempt has been made to read off the end of the current page. If at the end of file, then this is an error. If not yet at end of file, then read the next page from the file so that the stream read can be tried again."

	self atEnd ifTrue: [^self errorEndOfStream].
	"Load the required page"
	self position: self position!

updateLimits
	"Private - Reconcile the stream position and read limit to include any data written since the last update."

	| absolute |
	(flags anyMask: LimitsChangedMask) ifFalse: [^self].
	flags := flags bitAnd: ##(LimitsChangedMask bitInvert).
	readLimit < position ifTrue: [readLimit := position].
	logicalFileSize < (absolute := self absolutePosition) ifTrue: [logicalFileSize := absolute]!

writePage
	self updateLimits.
	file
		position: pageBase - 1;
		write: collection count: readLimit.
	flags := flags bitAnd: ##(BufferUpdatedMask bitInvert)! !

!Core.FileStream categoriesForMethods!
absolutePosition!accessing!private! !
atEnd!public!testing! !
basicContentsSpecies!accessing!private! !
basicNext!public!reading! !
basicNext:into:startingAt:!private!reading! !
basicNext:putAll:startingAt:!private!writing! !
basicNextPut:!private!writing! !
basicUpTo:!private!reading! !
bufferClassFor:type:!instance creation!private! !
close!operations!public! !
contents!accessing!public! !
externalType!accessing!public! !
file!accessing!public! !
file:mode:buffer:flags:!initialization!private! !
flush!public!writing! !
free!operations!public! !
fullFlush!public!writing! !
isBinary!public!testing! !
isBufferDirty!private!testing! !
isText!public!testing! !
isWriteable!public!testing! !
lastPosition!accessing!private! !
makeBufferOfSize:!helpers!private! !
name!accessing!public! !
nextAvailable!public!reading! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
overflow:!private!writing! !
overflowBasicNext:putAll:startingAt:!private!writing! !
ownsFile!accessing!public! !
ownsFile:!accessing!public! !
position!accessing!public! !
position:!accessing!positioning!public! !
primitiveBasicNextPut:!private!writing! !
primitiveNextPut:!private!writing! !
readPageFor:!private!reading! !
reset!positioning!public! !
setToEnd!positioning!public! !
size!accessing!public! !
skip:!positioning!public! !
underflow!private!reading! !
updateLimits!positioning!private! !
writePage!helpers!private! !
!

Core.FileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
Core.FileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!
Core.FileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!Core.FileStream class methodsFor!

bufferClassFor: aFile type: encSymbol
	| bufClass encoding |
	encoding := encSymbol == #text
				ifTrue: [aFile size == 0 ifTrue: [#utf8] ifFalse: [String encodingName: aFile sniffEncoding]]
				ifFalse: [encSymbol].
	bufClass := ByteBufferClasses lookup: encoding.
	(bufClass isNil or: [bufClass == Utf16String])
		ifTrue: [self error: 'Unsupported encoding ' , encoding printString].
	^bufClass!

bufferSize
	"Answer the size of the buffer to be used."

	^PageSize!

file: aFile mode: modeSymbol type: encSymbol flags: anInteger
	| bufClass |
	aFile isReadable ifFalse: [self error: 'FileStreams can only be attached to readable files'].
	bufClass := self bufferClassFor: aFile type: encSymbol.
	^self basicNew
		file: aFile
		mode: modeSymbol
		buffer: (bufClass newFixed: PageSize / bufClass elementSize)
		flags: anInteger!

on: aFile
	"Answer an instance of the receiver attached to the open file aFile, for reading/writing UTF-8 encoded text."

	^self on: aFile text: true!

on: aFile text: aBoolean
	"Answer an instance of the receiver attached to the open file aFile, in binary or UTF-8 text mode depending on the argument, aBoolean."

	^self on: aFile type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: aFile type: aSymbol
	"Answer an instance of the receiver attached to the open file, aFile, configured to read in
	the encoding specified by the <Symbol> argument. See the class comment for more details on
	possible the encodings."

	^self
		file: aFile
		mode: #create
		type: aSymbol
		flags: 0!

open: aString mode: modeSymbol check: checkBoolean type: encodingSymbol share: shareSymbol
	"Answer an instance of the receiver opened on aString for modeSymbol access with encoding specified by the <Symbol>, encodingSymbol , reporting errors if the file can't be opened (though file exist/file does not exist error notifications depend on the value of checkBoolean). 
	The <Symbol>, shareSymbol, specifies the allowed concurrent access, and must be one of the following: 
		#read - others are permitted to open (or have opened) for reading
		#write - others are permitted to open (or have opened) for writing
		#readWrite - others are permitted to open (or have opened) for reading and writing
		#none - others are not permitted to open (or have opened) the file"

	^self
		file: (File
				open: aString
				mode: modeSymbol
				check: checkBoolean
				share: shareSymbol)
		mode: modeSymbol
		type: encodingSymbol
		flags: OwnsFile!

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

readWrite: aString
	"Answer an instance of the receiver whose initial future sequence values consist of the contents of the file at the path specified by the <readableString> argument, but which can also be written to.
		- The file is assumed to contain text. The content is sniffed to determine the encoding.
		- It is an error for the folder path to not exist. 
		- If the file does not exist, it is created and initially empty.
		- If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others are permitted to open the file for reading (or have already done so). An error is raised if the file is aready open for writing."

	^self readWrite: aString text: true!

readWrite: aString text: aBoolean
	"Answer an instance of the receiver whose initial future sequence values consist of the contents of the file at the path specified by the <readableString> first argument, but which can also be written to.
		- If the <boolean> 2nd argument is true, the file is assumed to contain text (i.e. Strings/Characters). The content will be sniffed to determine the encoding. If the argument is false, then the file is opened to read/write raw binary (bytes).
		- It is an error for the folder path to not exist. 
		- If the file does not exist, it is created and initially empty.
		- If the file does exist, it is opened and the stream is positioned at the beginning of the content
		- Others are permitted to open the file for reading (or have already done so). An error is raised if the file is aready open for writing."

	^self
		open: aString
		mode: #create
		check: false
		type: (aBoolean ifTrue: [#text] ifFalse: [#binary])
		share: #read!

write: aString
	"Answer a new instance of the receiver for writing a file at the path specified by the <readableString> argument.
		- The file will contain UTF-8 encoded text.
		- It is an error for the folder path to not exist. 
		- If the file already exists, it is truncated, otherwise a new file is created.
		- Others are permitted to open the file for reading. An error is raised if the file is aready open for writing."

	^self write: aString mode: #truncate!

write: aString mode: aSymbol
	"Answer a new instance of the receiver for writing UTF-8 text to a file at the path specified by the <readableString> argument.
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
	"Open a file for write access (in fact Filestreams required read/write access for buffering, so the result is actually a read/write file stream).
	- The mode symbol, modeSymbol, determines what file opening mode to use when opening the file (see File for further details).
	- The check flag, checkBoolean, determines whether or not errors are reported if the file does or does not exist (depending on the mode). 
	- The text flag, textBoolean, determines whether or not the new instance is initially configured to read the file as if it contains Characters or bytes."

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

	"Note: FileStreams require read access for buffering, so result is actually a read/write file stream. For write-only files, use FileWriteStream."

	^self
		open: aString
		mode: modeSymbol
		check: aBoolean
		type: encodingSymbol
		share: #read!

write: fileId mode: mode type: type
	"Answer a new instance of the receiver open on the textual contents of the file identified by the <readableString> path, fileId.
	See #write:mode:check:type: for a description of the mode and type arguments."

	^self
		write: fileId
		mode: mode
		check: false
		type: type!

write: aString text: aBoolean
	"Create a new file/truncate an existing file for write access (in fact Filestreams require read/write access for buffering, so the result is actually a read/write file stream) through the receiver. The stream will write UTF-8 text or binary depending on the value of aBoolean."

	^self write: aString 
		mode: #truncate
		check: false
		text: aBoolean!

write: aString type: aSymbol
	"Create a new file/truncate an existing file identified by the <readableString>, aString, for write access (in fact Filestreams require read/write access for buffering, so the result is actually a read/write file stream) through the receiver. The encoding is determined by the <symbol> argument, fileType (i.e. one of #binary, #text, #utf8, #utf16le, or #utf32)."

	^self
		write: aString
		mode: #truncate
		check: false
		type: aSymbol! !

!Core.FileStream class categoriesForMethods!
bufferClassFor:type:!instance creation!private! !
bufferSize!constants!public! !
file:mode:type:flags:!instance creation!private! !
on:!instance creation!public! !
on:text:!instance creation!public! !
on:type:!instance creation!public! !
open:mode:check:type:share:!instance creation!public! !
read:!instance creation!public! !
read:text:!instance creation!public! !
read:text:share:!instance creation!public! !
read:type:!instance creation!public! !
read:type:share:!instance creation!public! !
readWrite:!instance creation!public! !
readWrite:text:!instance creation!public! !
write:!instance creation!public! !
write:mode:!instance creation!public! !
write:mode:check:text:!instance creation!public! !
write:mode:check:type:!instance creation!public! !
write:mode:type:!instance creation!public! !
write:text:!instance creation!public! !
write:type:!public! !
!

Core.FileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

