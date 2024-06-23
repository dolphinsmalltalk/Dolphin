"Filed out from Dolphin Smalltalk"!

OS.COM.ISequentialStream
	subclass: #'OS.COM.IStream'
	instanceVariableNames: 'name mode'
	classVariableNames: ''
	imports: #(#{OS.COM.StorageConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'WriteOpenModes'
				-> (IdentityDictionary withAll: { #append -> 16r11. #create -> 16r11. #truncate -> 16r1011 })
		}!

OS.COM.IStream guid: (OS.COM.IID fromString: '{0000000c-0000-0000-c000-000000000046}')!

OS.COM.IStream comment: 'IStream is a COMInterface class to wrap the standard OLE/COM structured storage interface of the same name.

IStream expands on ISequentialStream to offer the ability to access and adjust the current stream position, and to lock ranges of bytes in the underlying device (ILockBytes). It also offers transactional control, "directory" information, and copying. IStream is widely implmented and (in particular) used by COM objects for persistent storage purposes, marshalling, etc.

This interface class was originally automatically generated from a type library itself generated from the MS IDL file ''objidl.idl''. Our implementation also adds additional streaming capabilites in order that IStream pointers can be used interchangeably with standard Smalltalk streams, e.g. as a destination for binary filing. In fact IStream implements the ANSI standard stream protocols <puttableStream> and <gettableStream>.

We have also implemented the <streamableFile> protocol on IStreams so that a <FileStream> can be layered on top to take advantage of the latters high-performance buffering. This significantly reduces the number of calls made through the interface, and is the preferred mode of operation in most cases as it is much more efficient. It also allows the IStream to be treated as a gettable text stream (we only support binary streams for reading here).

Example:
	stm := IStream onHGLOBAL.		"Create an OLE stream onto a block of memory..."
	''Hello'' binaryStoreOn: stm.		"...STB an object onto it..."
	stm reset.				"...rewind..."
	(STBInFiler on: stm) next.		"...rehydrate the STB''d object..."
	stm close.				"...finally, close the stream (though finalization would do this anyway."'!

!OS.COM.IStream categoriesForClass!COM-Interfaces! !

!OS.COM.IStream methodsFor!

at: anInteger 
	"Answer the byte at the specified index in the receiver."

	self position: anInteger - 1.
	^self next!

at: anInteger put: aByte 
	"Write the specified byte at the specified position in the receiver."

	self position: anInteger - 1.
	self nextPut: aByte.
	^aByte!

atEnd
	"Answer whether the receiver cannot access any more objects."

	^self position >= self size!

cacheStats
	"Private - Cache some read only stats about the receiving stream."

	| statstg |
	statstg := self stat.
	name := statstg name asString.
	mode := statstg grfMode.
	statstg free!

Clone: ppstm
	"Invoke the Clone() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Clone(
			[out] IStream** ppstm);
	"

	<virtual stdcall: hresult 14 IStream**>
	^self invalidCall: _failureCode!

Commit: grfCommitFlags
	"Invoke the Commit() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Commit(
			[in] unsigned long grfCommitFlags);
	"

	<virtual stdcall: hresult 9 uint32>
	^self invalidCall: _failureCode!

contents
	"Answer a <collection> containing the complete contents of the stream."

	^self copyFrom: 1 to: self size!

copy
	"Answer a copy of the receiver referencing the same stream, but with an 
	independent positio pointer (created with the IStream::Clone() method)."

	| clone |
	clone := self class new.
	self Clone: clone.
	^clone!

copyFrom: startInteger to: stopInteger 
	"Attempt to read the specified range of bytes from the receiver."

	self position: startInteger - 1.
	^self next: stopInteger - startInteger + 1!

CopyTo: pstm cb: cb pcbRead: pcbRead pcbWritten: pcbWritten
	"Invoke the CopyTo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CopyTo(
			[in] IStream* pstm,
			[in] ULARGE_INTEGER cb,
			[out] ULARGE_INTEGER* pcbRead,
			[out] ULARGE_INTEGER* pcbWritten);
	"

	<virtual stdcall: hresult 8 IStream* uint64 uint64* uint64*>
	^self invalidCall: _failureCode!

copyTo: anIStream count: size 
	"Copy the specified number of bytes in the receiver from the current
	position to anIStream at its current position."

	self 
		CopyTo: anIStream
		cb: size
		pcbRead: nil
		pcbWritten: nil!

cr
	"Store the line delimiter character sequence (as required by
	the environment) as the next element(s) of the receiver.
	This is part of the implementation of the ANSI standard <puttableStream> protocol, which we
	choose to implement on IStreams. It is only really a valid operation for text streams."

	self nextPutAll: String lineDelimiter!

do: arg1
	"This is an auto-generated target implementation for the protocol <gettableStream>
	and remains to be correctly implemented."

	^Error notYetImplemented!

fastFlush
	"Perform a standard flush to OS disk cache. Despite the name, this is no more 
	dangerous than a normal file I/O flush, which does precisely this (i.e. flushes
	memory buffers to the OS, which we assume will be more reliable than the application).
	Use NT instead of Win95, and this should be quite safe enough."

	self Commit: STGC_DANGEROUSLYCOMMITMERELYTODISKCACHE!

flush
	"Perform a safe flush which is guaranteed to make it to the file if
	the Commit() call returns. The system provided compound file implementation
	does not (according to the help) provide transactioning for streams, so this
	is effectively a Nop."

	self Commit: STGC_DEFAULT!

grow
	"Private - Increase the size of the receiver appropriately."

	| size |
	size := self size.
	self resize: size + (size max: 2)!

handle
	"Answer the global memory handle used for the receiver's
	underlying storage (only valid if the receiver was created
	with CreateStreamOnHGlobal())."

	| hglobal |
	hglobal := External.Handle new.
	Ole32 getHGlobalFromStream: self phglobal: hglobal.
	^hglobal!

isEmpty
	"Answer whether there are any sequence values in the receiver."

	^self size == 0!

isReadable
	"Answer whether the receiver is readable. This is always true for IStreams
	(the value of STGM_READ is zero)."

	^true!

isWriteable
	"Answer whether the receiver is readable. This is always true for IStreams
	(the value of STGM_READ is zero)."

	^self mode anyMask: ##(STGM_WRITE | STGM_READWRITE)!

lockFrom: start to: end 
	"Obtain an exclusive lock on the specified range of bytes in the receiver."

	self 
		lockFrom: start
		to: end
		type: LOCK_EXCLUSIVE!

lockFrom: start to: end type: dwLockType 
	"Obtain an exclusive lock on the specified range of bytes in the receiver."

	self 
		LockRegion: start - 1
		cb: end - start + 1
		dwLockType: dwLockType!

LockRegion: libOffset cb: cb dwLockType: dwLockType
	"Invoke the LockRegion() method of the object wrapped by the receiver.
	
		HRESULT __stdcall LockRegion(
			[in] ULARGE_INTEGER libOffset,
			[in] ULARGE_INTEGER cb,
			[in] unsigned long dwLockType);

	"

	<virtual stdcall: hresult 11 uint64 uint64 uint32>
	^self invalidCall: _failureCode!

mode
	"Answer the access mode flags of the receiving stream."

	mode isNil ifTrue: [self cacheStats].
	^mode!

name
	"Answer the name of the receiving stream."

	name isNil ifTrue: [self cacheStats].
	^name!

nextCLSID
	"Answer a CLSID read from the data in the receiving stream (of course if this
	relies on their being a valid CLSID at the current position)."

	| answer |
	answer := CLSID newNull.
	Ole32 readClassStm: self pclsid: answer.
	^answer!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered. N.B. This method currently assumes that the line delimiter consists of
	two characters."

	| result eol1 eol2 delim |
	delim := String lineDelimiter.
	eol1 := delim first.
	eol2 := delim last.
	result := self upTo: eol1.
	[self atEnd or: [self peekFor: eol2]] 
		whileFalse: [result := result , (String with: eol1) , (self upTo: eol1)].
	^result!

nextPutCLSID: aCLSID
	"Append the specified CLSID to the specified stream.
	N.B. By convention this should be done before the associated data is streamed."

	Ole32 writeClassStm: self rclsid: aCLSID!

notEmpty
	"Answer whether there are any sequence values in the receiver."

	^self isEmpty not!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	| next |
	next := self nextAvailable: 1.
	^next notEmpty 
		ifTrue: 
			[self skip: -1.
			next first]!

peekFor: anObject 
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	^self peek = anObject 
		ifTrue: 
			[self next.
			true]
		ifFalse: [false]!

position
	"Answer the current position in the receiver's stream."

	| position |
	position := ByteArray newFixed: 8.
	self 
		Seek: 0
		dwOrigin: STREAM_SEEK_CUR
		plibNewPosition: position.
	^position uint64AtOffset: 0!

position: anInteger 
	"Seek to the specified position in the receiver's stream."

	| newPosition |
	newPosition := ByteArray newFixed: 8.
	self 
		Seek: anInteger
		dwOrigin: STREAM_SEEK_SET
		plibNewPosition: newPosition.
	(newPosition uint64AtOffset: 0) ~= anInteger ifTrue: [self errorSubscriptBounds: anInteger]!

reset
	"Set the receiver back to the beginning."

	self position: 0!

resize: anInteger 
	"Set the size of the receiver's stream to that specified"

	self SetSize: anInteger!

Revert
	"Invoke the Revert() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Revert();
	"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode!

rollback
	"Rollback modifications to the receiver since the last checkpoint."

	self Revert!

Seek: dlibMove dwOrigin: dwOrigin plibNewPosition: plibNewPosition
	"Invoke the Seek() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Seek(
			[in] LARGE_INTEGER dlibMove,
			[in] unsigned long dwOrigin,
			[out] ULARGE_INTEGER* plibNewPosition);
	"

	<virtual stdcall: hresult 6 int64 uint32 uint64*>
	^self invalidCall: _failureCode!

SetSize: libNewSize
	"Invoke the SetSize() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetSize(
			[in] ULARGE_INTEGER libNewSize);
	"

	<virtual stdcall: hresult 7 uint64>
	^self invalidCall: _failureCode!

setToEnd
	"Set the receiver's position reference to the end of the collection."

	^self position: self size!

size
	"Answer the current size of the receiver's stream."

	| struct |
	struct := STATSTG newBuffer.
	struct beUnfinalizable.
	self Stat: struct grfStatFlag: STATFLAG_NONAME.
	^struct cbSize!

skip: deltaInteger
	"Adjust the receiver's position by the <integer> argument, or as far as possible
	remaining within the receiver's bounds."

	"Note this adjusts the raw position. It should not be used when streaming over UTF encoded strings."

	self
		Seek: deltaInteger
		dwOrigin: STREAM_SEEK_CUR
		plibNewPosition: nil!

space
	"Store a space character as the next element of the receiver.
	This is part of the implementation of the ANSI standard <puttableStream> protocol, which we
	choose to implement on IStreams. It is only really a valid operation for text streams."

	self nextPut: $\x20!

stat
	"Answer a STATSTG structure populated with stats for the receiver.
	Simplified wrapper around #Stat:grfStateFlag:."

	| struct |
	struct := STATSTG newBuffer.
	self Stat: struct grfStatFlag: STATFLAG_DEFAULT.
	^struct!

Stat: pstatstg grfStatFlag: grfStatFlag
	"Invoke the Stat() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Stat(
			[out] STATSTG* pstatstg,
			[in] unsigned long grfStatFlag);
	"

	<virtual stdcall: hresult 13 STATSTG* uint32>
	^self invalidCall: _failureCode!

tab
	"Store a tab character as the next element of the receiver.
	This is part of the implementation of the ANSI standard <puttableStream> protocol, which we
	choose to implement on IStreams. It is only really a valid operation for text streams."

	self nextPut: $\t!

unlockFrom: start to: end 
	"Relinquish an exclusive lock on the specified range of bytes in the receiver."

	self 
		unlockFrom: start
		to: end
		type: LOCK_EXCLUSIVE!

unlockFrom: start to: end type: dwLockType 
	"Relinquish an exclusive lock on the specified range of bytes in the receiver."

	self 
		LockRegion: start - 1
		cb: end - start + 1
		dwLockType: dwLockType!

UnlockRegion: libOffset cb: cb dwLockType: dwLockType
	"Invoke the UnlockRegion() method of the object wrapped by the receiver.
	
		HRESULT __stdcall UnlockRegion(
			[in] ULARGE_INTEGER libOffset,
			[in] ULARGE_INTEGER cb,
			[in] unsigned long dwLockType);
	"

	<virtual stdcall: hresult 12 uint64 uint64 uint32>
	^self invalidCall: _failureCode!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from the
	current position to the end)."

	^self next: self size - self position! !

!OS.COM.IStream categoriesForMethods!
at:!accessing!public! !
at:put:!accessing!public! !
atEnd!public!testing! !
cacheStats!helpers!private! !
Clone:!**auto generated**!COM Interfaces-IStream!primitives!public! !
Commit:!**auto generated**!COM Interfaces-IStream!primitives!public! !
contents!accessing!public! !
copy!copying!public! !
copyFrom:to:!copying!public! !
CopyTo:cb:pcbRead:pcbWritten:!**auto generated**!COM Interfaces-IStream!primitives!public! !
copyTo:count:!copying!public! !
cr!accessing!public! !
do:!public! !
fastFlush!operations!public! !
flush!operations!public! !
grow!accessing!private! !
handle!accessing!public! !
isEmpty!public!testing! !
isReadable!public!testing! !
isWriteable!public!testing! !
lockFrom:to:!operations!public! !
lockFrom:to:type:!operations!public! !
LockRegion:cb:dwLockType:!**auto generated**!COM Interfaces-IStream!primitives!public! !
mode!accessing!public! !
name!accessing!public! !
nextCLSID!accessing!public! !
nextLine!accessing!public! !
nextPutCLSID:!accessing!public! !
notEmpty!public!testing! !
peek!accessing!public! !
peekFor:!accessing!public! !
position!accessing!public! !
position:!accessing!public! !
reset!accessing!public! !
resize:!accessing!public! !
Revert!**auto generated**!COM Interfaces-IStream!primitives!public! !
rollback!operations!public! !
Seek:dwOrigin:plibNewPosition:!**auto generated**!COM Interfaces-IStream!primitives!public! !
SetSize:!**auto generated**!COM Interfaces-IStream!primitives!public! !
setToEnd!positioning!public! !
size!accessing!public! !
skip:!positioning!public! !
space!accessing!public! !
stat!accessing!public! !
Stat:grfStatFlag:!**auto generated**!COM Interfaces-IStream!primitives!public! !
tab!accessing!public! !
unlockFrom:to:!operations!public! !
unlockFrom:to:type:!operations!public! !
UnlockRegion:cb:dwLockType:!**auto generated**!COM Interfaces-IStream!primitives!public! !
upToEnd!accessing!public! !
!

OS.COM.IStream methodProtocol: #gettableStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #do: #next #next: #nextLine #nextMatchFor: #peek #peekFor: #skip: #skipTo: #upTo:)!
OS.COM.IStream methodProtocol: #IStream attributes: #(#readOnly) selectors: #(#Commit: #CopyTo:cb:pcbRead:pcbWritten: #LockRegion:cb:dwLockType: #Read:cb:pcbRead: #Revert #Seek:dwOrigin:plibNewPosition: #SetSize: #Stat:grfStatFlag: #UnlockRegion:cb:dwLockType: #Write:cb:pcbWritten:)!
OS.COM.IStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
OS.COM.IStream methodProtocol: #'streamable File' attributes: #(#readOnly) selectors: #(#close #flush #isReadable #isWriteable #position: #read:count: #reset #size #write:count:)!

!OS.COM.IStream class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IStream'
		IStream defineTemplate
	"

	self
		defineFunction: #Seek:dwOrigin:plibNewPosition: argumentTypes: 'sqword dword qword*';
		defineFunction: #SetSize: argumentTypes: 'qword';
		defineFunction: #CopyTo:cb:pcbRead:pcbWritten: argumentTypes: 'IStream* qword qword* qword*';
		defineFunction: #Commit: argumentTypes: 'dword';
		defineFunction: #Revert;
		defineFunction: #LockRegion:cb:dwLockType: argumentTypes: 'qword qword dword';
		defineFunction: #UnlockRegion:cb:dwLockType: argumentTypes: 'qword qword dword';
		defineFunction: #Stat:grfStatFlag: argumentTypes: 'STATSTG* dword';
		defineFunction: #Clone: argumentTypes: 'IStream**'!

fromBytes: aByteArray
	"Answer a pointer instance of the receiver that can be used to stream over a copy of the bytes in the argument."

	| stream |
	stream := Shlwapi shCreateMemStream: aByteArray cbInit: aByteArray size.
	stream
		ifNil: 
			["If SHCreateMemStream returns NULL, it was unable to allocate the necessary memory. Callers should assume the cause is E_OUTOFMEMORY"
			^(HRESULTError fromInteger: E_OUTOFMEMORY) signal].
	^stream
		beFinalizable;
		yourself!

onHGLOBAL
	"Answer an instance of the receiver which is writing to the system provided
	ILockBytes implementation on top of a global memory handle."

	^self onHGLOBAL: nil!

onHGLOBAL: hGlobal
	"Answer a pointer instance of the receiver to an ILockBytes on top of the block of 
	global memory identified by the argument, hGlobal."

	| answer |
	answer := self newPointer.
	Ole32
		createStreamOnHGlobal: hGlobal
		fDeleteOnRelease: true
		ppstm: answer.
	^answer!

read: aString
	"Answer an instance of the receiver for streaming over the contents of the file whose file system path is specified by the readableString> argument."

	| instance |
	instance := self newPointer.
	Shlwapi
		shCreateStreamOnFileEx: aString
		grfMode: ##(STGM_READ | STGM_SHARE_DENY_WRITE)
		dwAttributes: FILE_ATTRIBUTE_NORMAL
		fCreate: false
		pstmTemplate: nil
		ppstm: instance.
	^instance!

write: aString
	"Answer an instance of the receiver for writing to a new or existing file whose file system path is specified by the readableString> argument.
	If the file doest not exist, it is created. If the file does exist, it is truncated."

	^self write: aString mode: #truncate!

write: aString mode: aSymbol
	"Answer a new instance of the receiver open to write to the file identified by the <readableString> first argument.
	The open mode is specified by the <Symbol> 2nd argument, and may be one of:
		#create - create a new file, position at its start.
		#append - open an existing file, position at its end.
		#truncate	- create or open a file, position at its start."

	| instance |
	instance := self newPointer.
	Shlwapi
		shCreateStreamOnFileEx: aString
		grfMode: (WriteOpenModes at: aSymbol)
		dwAttributes: FILE_ATTRIBUTE_NORMAL
		fCreate: aSymbol ~~ #append
		pstmTemplate: nil
		ppstm: instance.
	aSymbol == #append ifTrue: [instance setToEnd].
	^instance! !

!OS.COM.IStream class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
fromBytes:!instance creation!public! !
onHGLOBAL!instance creation!public! !
onHGLOBAL:!instance creation!public! !
read:!instance creation!public! !
write:!instance creation!public! !
write:mode:!instance creation!public! !
!

