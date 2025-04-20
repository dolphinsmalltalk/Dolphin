"Filed out from Dolphin Smalltalk"!

ReadWriteStream subclass: #FileStream
	instanceVariableNames: 'file flags pageBase logicalFileSize offset'
	classVariableNames: 'BufferClasses BufferUpdatedMask DirtyBufferMask LimitsChangedMask OwnsFileMask PageSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FileStream guid: (GUID fromString: '{87b4c6ff-026e-11d3-9fd7-00a0cc3e4a32}')!

FileStream addClassConstant: 'BufferUpdatedMask' value: 16r3!
FileStream addClassConstant: 'DirtyBufferMask' value: 16r2!
FileStream addClassConstant: 'LimitsChangedMask' value: 16r1!
FileStream addClassConstant: 'OwnsFileMask' value: 16r100!
FileStream addClassConstant: 'PageSize' value: 16r2000!

FileStream comment: '`FileStream` is a specialized `ReadWriteStream` for streaming over binary and text files.

The collection instance variable inherited from `Stream` is used to hold a fixed size buffer representing a cached ''page'' of the actual file. This is flushed back to the file either when a new page is loaded, or when explictly requested by `flush` or `fullFlush`. The `readLimit` and `writeLimit` instance variables inherited from `PositionableStream` and `WriteStream` respectively have a different usage in this class than in their defining classes; they are the limits for the current "page" rather than the whole stream. The `readLimit` will always be equal to the page size, except on the last page of the file. The `writeLimit` is always equal to the page size. This use of the superclass instance variables allows us to use the stream primitives for very efficient access within the current page, which means that even single character I/O is reasonably fast.

`FileStream` can read and write files as binary or text. It supports a number of important text encodings, as follows:
	`#text`		- Default text encoding. When reading will attempt to deduce the encoding of the underlying file. When writing a new file, will write UTF-8 with a BOM.
	`#ansi`		- ANSI text, assumed encoded per the default Dolphin code page
	`#utf8`		- UTF-8 encoded text
	`#utf16le`		- UTF-16 encoded text		(not yet implemented)
	`#utf32`		- UTF-32 encoded text		(not yet implemented)

## Instance Variables:
  `file`			The `File` being streamed over.
  `flags`			`<integer>` flags such as whether the page buffer is dirty.
  `pageBase`		`<integer>` offset of the page currently in the buffer. Always a multiple of the page size, plus 1.
  `logicalFileSize`	`<integer>` size of the file. This is cached because it is expensive to determine dynamically.
  `offset`			`<integer>` offset of start of text data in a file if it has a BOM

## Class Variables:
  `BufferClasses`		`IdentityDictionary` mapping from symbolic encodings to the class of byte-object to be used for the page buffer with that encoding
  `BufferUpdatedMask`	`<integer>` flags set when a write to the page buffer occurs (combines the following two flags)
  `DirtyBufferMask`		`<integer>` flag set when the page buffer contains updated data that has not yet been written to disk
  `LimitsChangedMask`	`<integer>` flag set when a write to the page buffer has occurred that has not yet been reflected in the `lastPosition` and/or `readLimit`.
  `OwnsFileMask`		`<integer>` flag set if the file is owned by a `FileStream` and should be closed by it.
  `PageSize`			`<integer>` size of the page buffer used to hold part of the file contents in memory - chosen to be a reasonably efficient compromise for serial and random I/O.'!

!FileStream categoriesForClass!Collections-Streams!I/O-Streams! !

!FileStream methodsFor!

absolutePosition
	"Private - Answer the absolute (zero-based) position of the file pointer from the start of
	the file."

	^pageBase + position - 1!

atEnd
	"Answer true if the receiver is positioned at its logical end."

	^position >= readLimit and: 
			[self updateLimits.
			pageBase + position > logicalFileSize]!

basicNext
	"Answer the next integer element accessible by the receiver. For a text stream this will be 
	the code unit for the next character or partial character based on the underlying encoding.
	It may not necessarily be a full code point unless the encoding is fixed width (i.e. #ansi, or #utf32)."

	"Primitive failure reasons:
		AssertionFailure	- The receivers index or readLimit are not SmallInteger values
		OutOfBounds	- The next index is beyond the readLimit.
		OutOfBounds	- The next index is off the end of the stream buffer.
		NotSupported	- The buffer is not a supported type (i.e. ByteArray or String)."

	<primitive: 221>
	^self atEnd
		ifTrue: [self errorEndOfStream]
		ifFalse: 
			[self position: self position.
			collection basicAt: (position := position + 1)]!

basicNext: count into: aSequenceableCollection startingAt: startAt
	"Destructively replace the elements of the argument, aSequenceableCollection,
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
			[| lastPos lastPageStart startNextPage wholePagesSize writeOffset |
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
					flags := flags bitOr: BufferUpdatedMask]].
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

beBinary
	"Treat the elements of the stream as bytes (Integers)."

	#deprecated.	"Only works correctly for switching from AnsiString"
	(collection isKindOf: UtfEncodedString)
		ifTrue: [self error: 'Unable to switch from UTF encoded content to binary'].
	collection := collection asByteArray!

beText
	"Treat the elements of the stream as Characters."

	collection := collection asString!

bufferClassFor: aFile mode: modeSymbol type: encSymbol
	| bufClass encoding |
	encoding := encSymbol == #text
				ifTrue: [aFile size == 0 ifTrue: [#utf8] ifFalse: [String encodingName: aFile sniffEncoding]]
				ifFalse: [encSymbol].
	bufClass := BufferClasses lookup: encoding.
	bufClass isNil ifTrue: [self error: 'Unsupported encoding ' , encoding printString].
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
	"Answer a <symbol> which represents the external stream type of the receiver."

	^self isBinary ifTrue: [#binary] ifFalse: [#text]!

file
	"Answer the <File> instance over which the receiver is streaming."

	^file!

file: aFile mode: modeSymbol type: encSymbol
	| bufClass buffer |
	aFile isReadable ifFalse: [self error: 'must be attached to a readable file'].
	bufClass := self
				bufferClassFor: aFile
				mode: modeSymbol
				type: encSymbol.
	buffer := bufClass new: PageSize / bufClass elementSize.
	self
		on: buffer file: aFile;
		initialRead;
		yourself.
	(logicalFileSize == 0 and: [modeSymbol ~~ #read]) ifTrue: [buffer emitEncodingMarkerOn: self].
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

growCollection
	"Private - The buffer of a FileStream is fixed at the page size. The collection is effectively a fixed size buffer, 
	and the writeLimit is always the page size."

	^self shouldNotImplement!

initialRead
	"Private - Initialise the new instance's buffer and establish the file size."

	self readPageFor: 0.
	logicalFileSize := file size.
	collection skipEncodingMarkerFrom: self!

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
	"Private - Answer the name of the file to which the receiver is attached."
	
	^file name!

next
	"Answer the receiver's next element, a <Character> if #isText is
	true otherwise an <integer>. Signal an exception if we are atEnd."
	
	<primitive: 65>
	^self atEnd
		ifTrue: [self errorEndOfStream]
		ifFalse: [
			self position: self position.
			collection decodeNextFrom: self]!

next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
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
			[| lastPos lastPageStart startNextPage wholePagesSize writeOffset |
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
					flags := flags bitOr: BufferUpdatedMask]].
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	<primitive: 65>
	^self atEnd
		ifFalse: 
			[self position: self position.
			collection decodeNextFrom: self]!

nextPut: anIntegerOrCharacter
	"Write anIntegerOrCharacter to the receiver and answer the argument."

	"Implementation Note: Inline the #beDirty operation as a performance optimization."

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

on: aCollection file: aFile
	super on: aCollection.
	file := aFile.
	self beFinalizable.
	flags := 0.
	offset := 0!

ownsFile
	^flags anyMask: OwnsFileMask!

ownsFile: aBoolean
	flags := flags mask: OwnsFileMask set: aBoolean!

pagePosition
	"Private - Answer the current <integer> position in the buffer."

	^position!

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

primitiveNextPutAll: aCollection
	<primitive: 173>
	^aCollection appendToStream: self!

readPageFor: anInteger
	"Private - Read the page containing position anInteger and record the pageBase
	and readLimit. The readLimit will be equal to the page size unless there are insufficient
	elements. The writeLimit is always equal to the page/buffer size."

	"PageSize must be power of 2, so can avoid division here."

	pageBase := (anInteger + offset bitAnd: ##((PageSize - 1) bitInvert)) + 1.
	readLimit := file
				position: pageBase - 1;
				read: collection count: PageSize.
	readLimit == PageSize
		ifFalse: 
			["Zero out the remainder of the buffer to clear any data read for the
			 previously visited page. This is necessary in case we position beyond the
			 current end of file and write some data - we don't want stale data from the
			 previous page showing through."
			KernelLibrary default zeroMemory: collection yourAddress + readLimit length: PageSize - readLimit]!

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

!FileStream categoriesForMethods!
absolutePosition!accessing!private! !
atEnd!public!testing! !
basicNext!accessing!public! !
basicNext:into:startingAt:!accessing!public! !
basicNext:putAll:startingAt:!accessing!private! !
basicNextPut:!accessing!private! !
basicUpTo:!accessing!private! !
beBinary!modes!public! !
beText!modes!public! !
bufferClassFor:mode:type:!instance creation!private! !
close!operations!public! !
contents!accessing!public! !
externalType!accessing!public! !
file!accessing!public! !
file:mode:type:!instance creation!private! !
flush!buffer!public! !
free!operations!public! !
fullFlush!buffer!public! !
growCollection!operations!private! !
initialRead!buffer!private! !
isBinary!public!testing! !
isBufferDirty!buffer!private! !
isText!public!testing! !
isWriteable!public!testing! !
lastPosition!accessing!private! !
makeBufferOfSize:!buffer!private! !
name!accessing!private! !
next!accessing!public! !
next:putAll:startingAt:!accessing!public! !
nextAvailable!accessing!public! !
nextPut:!accessing!public! !
nextPutAll:!accessing!public! !
on:file:!initializing!private! !
ownsFile!accessing!public! !
ownsFile:!accessing!public! !
pagePosition!accessing!private! !
position!accessing!public! !
position:!accessing!positioning!public! !
primitiveBasicNextPut:!accessing!private! !
primitiveNextPut:!accessing!private! !
primitiveNextPutAll:!accessing!private! !
readPageFor:!buffer!private! !
reset!positioning!public! !
setToEnd!positioning!public! !
size!accessing!public! !
skip:!positioning!public! !
updateLimits!accessing!positioning!private! !
writePage!helpers!private! !
!

FileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
FileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!
FileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!FileStream class methodsFor!

bufferSize
	"Answer the size of the buffer to be used."

	^PageSize!

file: aFile mode: modeSymbol type: encSymbol
	^self basicNew
		file: aFile
		mode: modeSymbol
		type: encSymbol!

initialize
	"Private - Initialize class variables of the receiver."

	"Flag set when a write to the buffer has occurred that has not yet been reflected in the lastPosition and/or read limit."

	self addClassConstant: 'LimitsChangedMask' value: 16r1.
	"Flag set when the buffer contains updated data that has not yet been written to disk"
	self addClassConstant: 'DirtyBufferMask' value: 16r2.
	"Flags set when a write to the buffer occurs (both the above flags)."
	self addClassConstant: 'BufferUpdatedMask' value: 16r3.
	"Flag set if the file is owned by a FileStream and should be closed by it."
	self addClassConstant: 'OwnsFileMask' value: 16r100.

	"The size of buffer used to hold part of the file contents in memory - chosen to be a
	reasonably efficient compromise for serial and random I/O."
	self addClassConstant: 'PageSize' value: 8192.
	#todo.	"#utf16le->Utf16String and #utf32 ->Utf32String to be added when implemented."
	self addClassConstant: 'BufferClasses'
		value: (IdentityDictionary new
				at: #utf8 put: Utf8String;
				at: #binary put: ByteArray;
				at: #ansi put: AnsiString;
				yourself)!

on: aFile
	"Answer an intance of the receiver attached to the open file aFile."

	^self on: aFile text: true!

on: aFile text: aBoolean
	"Answer an intance of the receiver attached to the open file aFile, in
	binary or text mode depending on the argument, aBoolean."

	^self on: aFile type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: aFile type: aSymbol
	"Answer an intance of the receiver attached to the open file, aFile, configured to read in
	the encoding specified by the <Symbol> argument. See the class comment for more details on
	possible the encodings."

	^self
		file: aFile
		mode: #create
		type: aSymbol!

open: aString mode: modeSymbol check: checkBoolean type: encSymbol
	"Private - Answer an instance of the receiver opened on aString for accessMode access with
	encoding specified by the <Symbol>, encSymbol , reporting errors if the file can't be opened
	(though file exist/file does not exist error notifications depend on the value of
	checkBoolean). By default we share for read only."

	| file |
	file := File
				open: aString
				mode: modeSymbol
				check: checkBoolean
				share: #readWrite.
	^(self
		file: file
		mode: modeSymbol
		type: encSymbol)
		ownsFile: true;
		yourself!

read: fileId
	"Answer an instance of the receiver whose future sequence values consist
	of the textual contents of the file identified by the <readableString> path, fileId."

	^self read: fileId type: #text!

read: aString text: aBoolean
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file named, aString, and whose access is character
	based or binary, depending on the argument aBoolean. Raise an exception
	if the file does not exist."

	^self read: aString type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

read: fileId type: fileType
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file identified by the <readableString>, fileId, and 
	whose external stream type and sequence value type is determined by the
	<symbol> argument, fileType (i.e. one of #binary, #text, #utf8, #utf16, or #utf32)."

	^self
		open: fileId
		mode: #read
		check: true
		type: fileType!

readWrite: aString
	"Answer an instance of the receiver opened on aFileName."

	^self
		open: aString
		mode: #create
		check: false
		type: #text!

readWrite: aString text: aBoolean
	"Answer an instance of the receiver opened on aFileName."

	^self
		open: aString
		mode: #create
		check: false
		type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

write: fileId
	"Answer an instance of the receiver opened on a new or truncated file 
	identified by the <readableString> path, fileId."

	^self write: fileId mode: #truncate!

write: fileId mode: mode
	"Answer a new instance of the receiver open on the textual contents of
	the file identified by the <readableString> path, fileId.
	See #write:mode:check:type: for a description of the mode argument."

	^self
		write: fileId
		mode: mode
		check: false
		type: #text!

write: aString mode: aSymbol check: checkBoolean text: textBoolean
	"Open a file for write access (in fact our filestreams required read/write
	access for buffering, so the result is actually a read/write file stream).
	The mode symbol, modeSymbol, determines what file opening mode to use when 
	opening the file (see File for further details).
	The check flag, checkBoolean, determines whether or not errors are reported 
	if the file does or does not exist (depending on the mode). The text flag,
	textBoolean, determines whether or not the new instance is initially configured
	to read the file as if it contains Characters or bytes."

	^self
		write: aString
		mode: aSymbol
		check: checkBoolean
		type: (textBoolean ifTrue: [#text] ifFalse: [#binary])!

write: fileId mode: mode check: check type: fileType
	"Answer a new instance of the receiver open on the contents of
	the file identified by the <readableString> path, fileId.
	The <symbol> argument, mode, identifies the manner in which the file
	is opened. 

	The mode may be one of:
		#create 		create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its start.

	See also the File class for further information on the mode.

	The <boolean> argument, check, determines whether or not errors are reported 
	if the file does or does not exist (depending on the mode). The <symbol>, type,
	specifies the data encoding (binary or text) for which the new instance is 
	configured."
	
	"Implementation Note: Dolphin's FileStreams require read access for buffering, so result is
	actually a read/write file stream."

	^self
		open: fileId
		mode: mode
		check: check
		type: fileType!

write: fileId mode: mode type: type
	"Answer a new instance of the receiver open on the textual contents of
	the file identified by the <readableString> path, fileId.
	See #write:mode:check:type: for a description of the mode and type arguments."

	^self
		write: fileId
		mode: mode
		check: false
		type: type!

write: aString text: aBoolean
	"Create a new file/truncate an existing file for write access (in fact our 
	filestreams require read/write access for buffering, so the result is actually 
	a read/write file stream) through the receiver. The stream will expect text
	or binary depending on the value of aBoolean."

	^self write: aString 
		mode: #truncate
		check: false
		text: aBoolean!

write: aString type: aSymbol
	"Create a new file/truncate an existing file identified by the <readableString>, aString,
	for write access (in fact our filestreams require read/write access for buffering, so the
	result is actually a read/write file stream) through the receiver. The sequence value type
	is determined by the <symbol> argument, fileType (i.e. one of #binary, #text, #utf8, #utf16le,
	or #utf32)."

	^self
		write: aString
		mode: #truncate
		check: false
		type: aSymbol! !

!FileStream class categoriesForMethods!
bufferSize!constants!public! !
file:mode:type:!instance creation!private! !
initialize!development!initializing!private! !
on:!instance creation!public! !
on:text:!instance creation!public! !
on:type:!instance creation!public! !
open:mode:check:type:!instance creation!private! !
read:!instance creation!public! !
read:text:!instance creation!public! !
read:type:!instance creation!public! !
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

FileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

