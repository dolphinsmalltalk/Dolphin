"Filed out from Dolphin Smalltalk 7"!

ReadWriteStream subclass: #FileStream
	instanceVariableNames: 'file flags pageBase logicalFileSize'
	classVariableNames: 'BufferUpdatedMask DirtyBufferMask LimitsChangedMask PageSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileStream guid: (GUID fromString: '{87b4c6ff-026e-11d3-9fd7-00a0cc3e4a32}')!
FileStream addClassConstant: 'BufferUpdatedMask' value: 3!
FileStream addClassConstant: 'DirtyBufferMask' value: 2!
FileStream addClassConstant: 'LimitsChangedMask' value: 1!
FileStream addClassConstant: 'PageSize' value: 8192!
FileStream comment: 'FileStream is a specialized <ReadWriteStream> for streaming over binary and text files.

The collection instance variable inherited from <Stream> is used to hold a fixed size buffer representing a cached ''page'' of the actual file. This is flushed back to the file either when a new page is loaded, or when explictly requested by #flush or #fullFlush. The readLimit and writeLimit instance variables inherited from <PositionableStream> and <WriteStream> respectively have a different usage in this class than in their defining classes; they are the limits for the current "page" rather than the whole stream. The readLimit will always be equal to the page size, except on the last page of the file. The writeLimit is always equal to the page size. This use of the superclass instance variables allows us to use the stream primitives for every efficient access within the current page, which means that even single character I/O is reasonably fast..

Instance Variables:
	file			The <File> being streamed over.
	flags			<integer> flags such as whether the page buffer is dirty.
	pageBase		<integer> offset of the page currently in the buffer. Always a multiple of the page size, plus 1.
	logicalFileSize	<integer> size of the file. This is cached because it is expensive to determine dynamically.
'!
!FileStream categoriesForClass!Collections-Streams!I/O-Streams! !
!FileStream methodsFor!

atEnd
	"Answer true if the receiver is positioned at its logical end."

	^position >= readLimit and: [pageBase + position > self lastPosition]

!

beBinary
	"Treat the elements of the stream as bytes (Integers)."

	collection := collection asByteArray!

beText
	"Treat the elements of the stream as Characters."

	collection := collection asString!

close
	"Write any outstanding changes to the file and close it."

	file notNil ifFalse: [^self].
	self
		flush;
		beUnfinalizable.
	file close.
	file := nil!

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
		reset;
		read: contents count: size.
	^contents!

externalType
	"Answer a <symbol> which represents the external stream type of the receiver."

	^self isBinary ifTrue: [#binary] ifFalse: [#text]!

file
	"Answer the <File> instance over which the receiver is streaming."

	^file!

file: aStreamableFile
	"Private - Set the file instance var to aFile."

	file := aStreamableFile!

finalize
	"Private - The receiver is about to be GC'd, flush any updates to the underlying medium."

	self flush.
	"Note that we can't actually close the File, because we don't know that we opened it."
	file := nil

!

flush
	"Flush any buffered modifications to the file."

	(flags anyMask: DirtyBufferMask) ifTrue: [self writePage]!

fullFlush
	"Flush any buffered modifications to the file and
	force the file to disk."

	self flush.
	file flush.!

growCollection
	"Private - The buffer of a FileStream is fixed at the page size. The collection is effectively a fixed size buffer, 
	and the writeLimit is always the page size."

	^self shouldNotImplement!

initialize
	"Private - Initialise the new instance."

	self beFinalizable.
	flags := 0.
	super initialize!

initialRead
	"Private - Initialise the new instance's buffer and establish the file size."

	self readPageFor: 0.
	logicalFileSize := file size.!

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
	^logicalFileSize!

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
			collection at: (position := position + 1)]!

next: count into: aSequenceableCollection startingAt: startAt
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

nextOrNil
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	<primitive: 65>
	^self atEnd
		ifFalse: 
			[self position: self position.
			collection at: (position := position + 1)]!

nextPut: anIntegerOrCharacter
	"Write anIntegerOrCharacter to the receiver and answer the argument."

	"Implementation Note: Inline the #beDirty operation as a performance optimization."

	self primitiveNextPut: anIntegerOrCharacter.
	flags := flags bitOr: BufferUpdatedMask.
	^anIntegerOrCharacter!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^aCollection appendToStream: self!

position
	"Answer the absolute (zero-based) position of the file pointer."

	^pageBase + position - 1!

position: anInteger
	"Move the receiver's logical position to absolute (zero-based) position anInteger."

	| pos |
	self updateLimits.
	pos := anInteger + 1.
	(pos < pageBase or: [pos >= (pageBase + PageSize)])
		ifTrue: 
			["anInteger is not within the current page.
			Write out any changes to the current page buffer and read the one required."
			self
				flush;
				readPageFor: anInteger].
	position := pos - pageBase!

primitiveNextPut: anIntegerOrCharacter
	"Private - Write anIntegerOrCharacter to the receiver."

	<primitive: 66>
	self position: self position.
	^collection at: (position := position + 1) put: anIntegerOrCharacter!

readPageFor: anInteger
	"Private - Read the page containing position anInteger and record the pageBase
	and readLimit. The readLimit will be equal to the page size unless there are insufficient
	elements. The writeLimit is always equal to the page/buffer size."

	"PageSize must be power of 2, so can avoid division here."

	pageBase := (anInteger bitAnd: ##((PageSize - 1) bitInvert)) + 1.
	readLimit := file
				position: pageBase - 1;
				read: collection count: PageSize!

reset
	self position: 0!

reverseContents
	"Answer the reversed contents of the receiver."

	^(self contents readStream) reverseContents
!

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

	self position: (((self position + anInteger) max: 0) min: self size - 1)
!

updateLimits
	"Private - Reconcile the stream position and read limit to include any data written since the last update."

	"The DataWritten flag indicates that some data has been written since the last update to the limits"

	(flags anyMask: LimitsChangedMask)
		ifTrue: 
			[| absolute |
			flags := flags bitAnd: ##(LimitsChangedMask bitInvert).
			readLimit < position ifTrue: [readLimit := position].
			logicalFileSize < (absolute := self position) ifTrue: [logicalFileSize := absolute]]!

upTo: anObject 
	"Answer a <sequencedReadableCollection> of elements starting with the next element accessed
	by the receiver, and up to, but not inclusive of, the next element that is equal to the
	<Object>, anObject. Positions the stream after anObject if found. If anObject is not in the
	collection, answer the entire rest of the collection. If the receiver is at its end, then
	answer an empty collection."

	| found answer |
	found := false.
	answer := self makeBufferOfSize: 0.
	[found or: [self atEnd]] whileFalse: 
			[| startIndex endIndex |
			self position: self position.
			startIndex := position + 1.
			position := collection 
						nextIdentityIndexOf: anObject
						from: startIndex
						to: readLimit.
			(found := position ~~ 0) 
				ifTrue: [endIndex := position - 1]
				ifFalse: [endIndex := position := readLimit].
			answer := answer , (collection copyFrom: startIndex to: endIndex)].
	^answer!

writePage
	self updateLimits.
	file
		position: pageBase - 1;
		write: collection count: readLimit.
	flags := flags bitAnd: ##(BufferUpdatedMask bitInvert)! !
!FileStream categoriesFor: #atEnd!public!testing! !
!FileStream categoriesFor: #beBinary!modes!public! !
!FileStream categoriesFor: #beText!modes!public! !
!FileStream categoriesFor: #close!operations!public! !
!FileStream categoriesFor: #contents!accessing!public! !
!FileStream categoriesFor: #externalType!accessing!public! !
!FileStream categoriesFor: #file!accessing!public! !
!FileStream categoriesFor: #file:!accessing!private! !
!FileStream categoriesFor: #finalize!finalizing!private! !
!FileStream categoriesFor: #flush!buffer!public! !
!FileStream categoriesFor: #fullFlush!buffer!public! !
!FileStream categoriesFor: #growCollection!operations!private! !
!FileStream categoriesFor: #initialize!initializing!private! !
!FileStream categoriesFor: #initialRead!buffer!private! !
!FileStream categoriesFor: #isBinary!public!testing! !
!FileStream categoriesFor: #isBufferDirty!buffer!private! !
!FileStream categoriesFor: #isText!public!testing! !
!FileStream categoriesFor: #isWriteable!public!testing! !
!FileStream categoriesFor: #lastPosition!accessing!private! !
!FileStream categoriesFor: #makeBufferOfSize:!buffer!private! !
!FileStream categoriesFor: #name!accessing!private! !
!FileStream categoriesFor: #next!accessing!public! !
!FileStream categoriesFor: #next:into:startingAt:!accessing!public! !
!FileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!FileStream categoriesFor: #nextOrNil!accessing!public! !
!FileStream categoriesFor: #nextPut:!accessing!public! !
!FileStream categoriesFor: #nextPutAll:!accessing!public! !
!FileStream categoriesFor: #position!accessing!public! !
!FileStream categoriesFor: #position:!accessing!positioning!public! !
!FileStream categoriesFor: #primitiveNextPut:!accessing!private! !
!FileStream categoriesFor: #readPageFor:!buffer!private! !
!FileStream categoriesFor: #reset!positioning!public! !
!FileStream categoriesFor: #reverseContents!accessing!public! !
!FileStream categoriesFor: #setToEnd!positioning!public! !
!FileStream categoriesFor: #size!accessing!public! !
!FileStream categoriesFor: #skip:!positioning!public! !
!FileStream categoriesFor: #updateLimits!accessing!positioning!private! !
!FileStream categoriesFor: #upTo:!accessing!public! !
!FileStream categoriesFor: #writePage!helpers!private! !

FileStream methodProtocol: #FileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #externalType #isBinary #isEmpty #isText #position #position: #reset #setToEnd)!
FileStream methodProtocol: #readFileStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #externalType #isBinary #isEmpty #isText #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!
FileStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!FileStream class methodsFor!

bufferSize
	"Answer the size of the buffer to be used."

	^PageSize!

initialize
	"Private - Initialize class variables of the receiver."

	"Flag set when a write to the buffer has occurred that has not yet been reflected in the lastPosition and/or read limit."
	self addClassConstant: 'LimitsChangedMask' value: 16r1.
	"Flag set when the buffer contains updated data that has not yet been written to disk"
	self addClassConstant: 'DirtyBufferMask' value: 16r2.
	"Flags set when a write to the buffer occurs (both the above flags)."
	self addClassConstant: 'BufferUpdatedMask' value: 16r3.

	"The size of buffer used to hold part of the file contents in memory - chosen to be a
	reasonably efficient compromise for serial and random I/O."
	self addClassConstant: 'PageSize' value: 8192!

on: aFile
	"Answer an intance of the receiver attached to the open file aFile."

	^self on: aFile text: true!

on: aFile text: aBoolean
	"Answer an intance of the receiver attached to the open file aFile, in
	binary or text mode depending on the argument, aBoolean."

	aFile isReadable ifFalse: [self error: 'must be attached to a readable file'].
	^self basicNew
		collection: ((aBoolean ifTrue: [String] ifFalse: [ByteArray]) new: PageSize);
		initialize;
		file: aFile;
		initialRead;
		yourself!

open: aString mode: aSymbol
	"Private - Answer an instance of the receiver opened on aString 
	for aSymbol text access. Signal a FileException if the file can't be opened."

	^self open: aString mode: aSymbol text: true!

open: aString mode: aSymbol check: checkBoolean text: textBoolean
	"Private - Answer an instance of the receiver opened on
	aString for accessMode access as binary or text depending on aBoolean,
	reporting errors if the file can't be opened (though file exist/file
	does not exist error notifications depend on the value of checkBoolean).
	By default we share for read only."

	| answer |
	answer := self on: (File 
						open: aString
						mode: aSymbol
						check: checkBoolean
						share: #readWrite)
				text: textBoolean.
	aSymbol == #append ifTrue: [answer setToEnd].
	^answer.
	#todo	"Default sharing should be #read, but causes problems with boot"!

open: aString mode: aSymbol text: aBoolean
	"Private - Answer an instance of the receiver opened on
	aString for accessMode access as binary or text depending on aBoolean.
	Signal a FileException if the file can't be opened."
 
	^self open: aString mode: aSymbol check: false text: aBoolean!

read: fileId
	"Answer an instance of the receiver whose future sequence values consist
	of the textual contents of the file identified by the <readableString> path, fileId."

	^self read: fileId text: true!

read: aString text: aBoolean
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file named, aString, and whose access is character
	based or binary, depending on the argument aBoolean. Raise an exception
	if the file does not exist."

	^self open: aString 
		mode: #read
		check: true
		text: aBoolean!

read: fileId type: fileType
	"Answer an instance of the receiver whose future sequence values consist
	of the contents of the file identified by the <readableString>, fileId, and 
	whose external stream type and sequence value type is determined by the
	<symbol> argument, fileType (i.e. either binary or text)."

	^self read: fileId text: (fileType == #text)!

readWrite: aString
	"Answer an instance of the receiver opened on aFileName."

	^self open: aString mode: #create!

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
		text: true!

write: aString mode: aSymbol check: checkBoolean text: textBoolean
	"Open a file for write access (in fact our filestreams required read/write
	access for buffering, so the result is actually a read/write file stream).
	The mode symbol, modeSymbol, determines what file opening mode to use when 
	opening the file (see File for further details).
	The check flag, checkBoolean, determines whether or not errors are reported 
	if the file does or does not exist (depending on the mode). The text flag,
	textBoolean, determines whether or not the new instance is initially configured
	to read the file as if it contains Characters or bytes."

	^self open: aString 
		mode: aSymbol
		check: checkBoolean
		text: textBoolean!

write: fileId mode: mode check: check type: fileType
	"Answer a new instance of the receiver open on the contents of
	the file identified by the <readableString> path, fileId.
	The <symbol> argument, mode, identifies the manner in which the file
	is opened. It may be one of:
		#create 	create a new file, position at its start.
		#append	open an existing file, position at its end.
		#truncate	create or open a file, position at its starte.
	See also the File class for further information on the mode.
	The <boolean> argument, check, determines whether or not errors are reported 
	if the file does or does not exist (depending on the mode). The <symbol>, type,
	specifies the external type (binary or text) for which the new instance is initially
	configured.
	Implementation Note: Dolphin's FileStreams require read access for
	buffering, so result is actually a read/write file stream."

	^self open: fileId 
		mode: mode
		check: check
		text: (fileType == #text)!

write: aString text: aBoolean
	"Create a new file/truncate an existing file for write access (in fact our 
	filestreams require read/write access for buffering, so the result is actually 
	a read/write file stream) through the receiver. The stream will expect characters
	or bytes depending on the value of aBoolean."

	^self write: aString 
		mode: #truncate
		check: false
		text: aBoolean! !
!FileStream class categoriesFor: #bufferSize!constants!public! !
!FileStream class categoriesFor: #initialize!development!initializing!private! !
!FileStream class categoriesFor: #on:!instance creation!public! !
!FileStream class categoriesFor: #on:text:!instance creation!public! !
!FileStream class categoriesFor: #open:mode:!instance creation!private! !
!FileStream class categoriesFor: #open:mode:check:text:!instance creation!private! !
!FileStream class categoriesFor: #open:mode:text:!instance creation!private! !
!FileStream class categoriesFor: #read:!instance creation!public! !
!FileStream class categoriesFor: #read:text:!instance creation!public! !
!FileStream class categoriesFor: #read:type:!instance creation!public! !
!FileStream class categoriesFor: #readWrite:!instance creation!public! !
!FileStream class categoriesFor: #write:!instance creation!public! !
!FileStream class categoriesFor: #write:mode:!instance creation!public! !
!FileStream class categoriesFor: #write:mode:check:text:!instance creation!public! !
!FileStream class categoriesFor: #write:mode:check:type:!instance creation!public! !
!FileStream class categoriesFor: #write:text:!instance creation!public! !

FileStream class methodProtocol: #'FileStream factory' attributes: #(#ansi #readOnly) selectors: #(#read: #read:type: #write: #write:mode: #write:mode:check:type:)!

