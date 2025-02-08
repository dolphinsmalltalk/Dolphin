"Filed out from Dolphin Smalltalk"!

Core.ExternalWriteStream
	subclass: #'Core.FileWriteStream'
	instanceVariableNames: 'offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'NoBom' -> 16r200. 'OwnsFile' -> 16r100 }!

Core.FileWriteStream guid: (Core.GUID fromString: '{4198e257-aab7-46c0-a9f7-68d48c80a044}')!

Core.FileWriteStream comment: '`FileWriteStream` provides minimal overhead buffered output to an underlying `<streamable File>`, e.g. an instance of `File`. Unlike `FileStream` it is write-only, and not positionable. This means it can be used to buffer output to a file handle that is itself not readable/positionable. Also unlike `FileStream`, `FileWriteStream` does support writing of UTF-16 encoded text files.

## Example usage:

We cannot open `CONOUT$` with a normal `FileStream` because it provides serial write access only (i.e. it is not readable or positionable). We can use a `FileWriteStream` on it though. There is already a standard mechanism to write to stdout through the stdio CRT streams that the `SessionManager` provides, but writing directly to `CONOUT$` instead bypasses the CRT and so does have lower overhead, and allows console output even when stdout has been redirected.

```
	"Ensure the console window is open"
	SessionManager current stdioStreams.
	stdout := FileWriteStream write: ''CONOUT$'' type: #utf8.
	"Ensure the output code page is 65001 so we can write UTF-8 directly"
	OS.Kernel32 setConsoleOutputCP: OS.NlsConstants.CP_UTF8.
	stdout nextPutAll: ''Hello 🐬 world''; cr; flush.
	stdout close
```

## Instance Variables:
  `offset`		`<integer>`. Implicit offset because of any BOM, after which the file content starts.

## Class Constants:
  `NoBom`	`<integer>` flag indicating that when writing to a new textual medium, no UTF BOM should be emitted.
  `OwnsFile`	`<integer>` flag. Synonym for inherited `OwnsMedium`.
'!

!Core.FileWriteStream methodsFor!

atEnd
	"Answer whether the receiver is at the end of the underlying fle."

	self flush.
	^medium atEnd!

contents
	"Answer the contents of the underlying `<streamable File>`.
	Note that if the underlying file was created/truncated by this FileWriteStream, then any BoM is excluded from the reported position and contents. This is not true if appending to an existing file."

	| size contents pos |
	self flush.
	"The size will always be in bytes"
	size := medium size // elementSize - offset.
	contents := self contentsSpecies new: size.
	pos := medium position.
	medium
		position: offset * elementSize;
		read: contents count: size * elementSize;
		position: pos.
	^contents!

file
	"Answer the underlying `<streamable File>`."

	^medium!

fullFlush
	"Flush any buffered modifications to the file and force the file to disk."

	self flush.
	medium flush.!

medium: aStreamableFile buffer: aByteObject flags: anInteger
	super
		medium: aStreamableFile
		buffer: aByteObject
		flags: (aStreamableFile fileType == #disk
				ifTrue: [anInteger]
				ifFalse: 
					["We don't want to write a BOM to console streams, pipes, sockets, etc"
					anInteger bitOr: NoBom]).
	offset := ((flags anyMask: NoBom) or: [medium position ~~ 0])
				ifTrue: [0]
				ifFalse: 
					[aByteObject emitEncodingMarkerOn: self.
					position].
	^self!

mediumPosition
	^super mediumPosition - offset!

mediumPosition: anInteger
	super mediumPosition: (offset + anInteger)!

name
	"Answer the name of the file to which the receiver is attached."
	
	^medium name!

ownsFile
	"Answer whether the receiver is considered to own the underlying file and will close it when itself closed."

	^self ownsMedium!

ownsFile: aBoolean
	"Set whether the receiver is considered to own the underlying file and will close it when itself closed."

	self ownsMedium: aBoolean!

reset
	"Reset the position of the receiver to be at the beginning of the underlying `<streamable File>`. The existing content is not truncated, although further output may overwrite it. This may fail if the underlying file is not positionable, e.g. it is a character device."

	self position: 0!

setToEnd
	"Set the file pointer to the end of the file after flushing any buffered data to it."

	self flush.
	medium setToEnd! !

!Core.FileWriteStream categoriesForMethods!
atEnd!public!testing! !
contents!public!reading! !
file!accessing!public! !
fullFlush!public!writing! !
medium:buffer:flags:!initializing!private! !
mediumPosition!positioning!private! !
mediumPosition:!positioning!private! !
name!accessing!public! !
ownsFile!public!testing! !
ownsFile:!initializing!public! !
reset!positioning!public! !
setToEnd!public! !
!

Core.FileWriteStream methodProtocol: #writeFileStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #externalType #flush #isBinary #isEmpty #isText #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!Core.FileWriteStream class methodsFor!

defaultEncoding
	^#utf8!

initialize
	bufferSize := 16r10000!

write: aString
	"Answer a new instance of the receiver for writing text to a file at the path specified by the <readableString> argument.
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
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument.
		- The text flag, textBoolean, determines whether or not the new instance is initially configured to read the file as if it contains Characters or bytes.
		- See #write:mode:check:type:share: for a description of the mode, and check arguments."

	^self
		write: aString
		mode: aSymbol
		check: checkBoolean
		type: (textBoolean ifTrue: [#text] ifFalse: [#binary])!

write: aString mode: modeSymbol check: aBoolean type: encodingSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument.
	See #write:mode:check:type:share: for a description of the mode, check and type arguments."

	^self
		write: aString
		mode: modeSymbol
		check: aBoolean
		type: encodingSymbol
		share: #read!

write: aString mode: modeSymbol check: aBoolean type: encodingSymbol share: shareSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument.
		- The <symbol> argument, modeSymbol, identifies the manner in which the file is opened, and may be one of:
			#create 	create a new file, position at its start.
			#append	open an existing file, position at its end (although note that in this case any BoM will be included in the reported position and in the contents)
			#truncate	create or open a file, position at its start.
		- See also the File class for further information on the mode.
		- The <boolean> third argument determines whether or not errors are reported if the file does or does not exist (depending on the mode). 
		- The <symbol>, encodingSymbol, specifies the data encoding (binary or text) for which the new instance is configured.
		- Others may be permitted to open the file for reading or writing (or have already done so), depending on the final <Symbol> argument, shareSymbol, one of #read, #write, #readWrite, #exclusive."

	| file buffer |
	"Allocate the buffer first so that we don't open the file if the encoding is unrecognised or not supported."
	buffer := self newBufferForEncoding: encodingSymbol.
	file := File
				open: aString
				mode: modeSymbol
				check: aBoolean
				share: shareSymbol.
	modeSymbol == #append ifTrue: [file setToEnd].
	^self
		on: file
		buffer: buffer
		flags: OwnsFile!

write: aString mode: modeSymbol type: encodingSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument, with mode and type specified by the two remaining <Symbol> arguments.
	See #write:mode:check:type:share: for a description of the mode and type arguments."

	^self
		write: aString
		mode: modeSymbol
		check: false
		type: encodingSymbol!

write: aString mode: modeSymbol type: encodingSymbol share: shareSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument, with mode and type specified by the two remaining <Symbol> arguments.
	See #write:mode:check:type:share: for a description of the mode, type and share arguments."

	^self
		write: aString
		mode: modeSymbol
		check: false
		type: encodingSymbol
		share: shareSymbol!

write: aString text: aBoolean
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument. The stream will write text or binary depending on the value of aBoolean."

	^self
		write: aString
		mode: #truncate
		check: false
		text: aBoolean!

write: aString type: aSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument.
	See #write:mode:check:type:share: for a description of the type argument."

	^self
		write: aString
		mode: #truncate
		type: aSymbol!

write: aString type: encodingSymbol share: shareSymbol
	"Answer a new instance of the receiver for writing to a file at the path specified by the <readableString> first argument.
	See #write:mode:check:type:share: for a description of the type and share arguments."

	^self
		write: aString
		mode: #truncate
		check: false
		type: encodingSymbol
		share: shareSymbol! !

!Core.FileWriteStream class categoriesForMethods!
defaultEncoding!constants!public! !
initialize!public! !
write:!instance creation!public! !
write:mode:!instance creation!public! !
write:mode:check:text:!instance creation!public! !
write:mode:check:type:!instance creation!public! !
write:mode:check:type:share:!instance creation!public! !
write:mode:type:!instance creation!public! !
write:mode:type:share:!instance creation!public! !
write:text:!instance creation!public! !
write:type:!instance creation!public! !
write:type:share:!instance creation!public! !
!

