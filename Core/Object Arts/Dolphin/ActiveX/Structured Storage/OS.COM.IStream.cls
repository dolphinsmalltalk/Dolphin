"Filed out from Dolphin Smalltalk 7"!

OS.COM.ISequentialStream subclass: #'OS.COM.IStream'
	instanceVariableNames: 'name mode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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

	<virtual stdcall: hresult 9 dword>
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

	<virtual stdcall: hresult 8 IStream* qword qword* qword*>
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
	OLELibrary default getHGlobalFromStream: self phglobal: hglobal.
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

	<virtual stdcall: hresult 11 qword qword dword>
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
	OLELibrary default readClassStm: self pclsid: answer.
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

	OLELibrary default writeClassStm: self rclsid: aCLSID!

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
	position := ULARGE_INTEGER new.
	self 
		Seek: 0
		dwOrigin: STREAM_SEEK_CUR
		plibNewPosition: position.
	^position asInteger!

position: anInteger 
	"Seek to the specified position in the receiver's stream."

	| newPosition |
	newPosition := ULARGE_INTEGER new.
	self 
		Seek: anInteger
		dwOrigin: STREAM_SEEK_SET
		plibNewPosition: newPosition.
	newPosition asInteger ~= anInteger ifTrue: [self errorSubscriptBounds: anInteger]!

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

	<virtual stdcall: hresult 6 sqword dword qword*>
	^self invalidCall: _failureCode!

SetSize: libNewSize
	"Invoke the SetSize() method of the object wrapped by the receiver.
	
		HRESULT __stdcall SetSize(
			[in] ULARGE_INTEGER libNewSize);
	"

	<virtual stdcall: hresult 7 qword>
	^self invalidCall: _failureCode!

setToEnd
	"Set the receivers position reference to the end of the collection."

	^self position: self size!

size
	"Answer the current size of the receiver's stream."

	| struct |
	struct := STATSTG new.
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
	struct := STATSTG new.
	self Stat: struct grfStatFlag: STATFLAG_DEFAULT.
	^struct!

Stat: pstatstg grfStatFlag: grfStatFlag
	"Invoke the Stat() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Stat(
			[out] STATSTG* pstatstg,
			[in] unsigned long grfStatFlag);
	"

	<virtual stdcall: hresult 13 STATSTG* dword>
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

	<virtual stdcall: hresult 12 qword qword dword>
	^self invalidCall: _failureCode! !
!OS.COM.IStream categoriesFor: #at:!accessing!public! !
!OS.COM.IStream categoriesFor: #at:put:!accessing!public! !
!OS.COM.IStream categoriesFor: #atEnd!public!testing! !
!OS.COM.IStream categoriesFor: #cacheStats!helpers!private! !
!OS.COM.IStream categoriesFor: #Clone:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #Commit:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #contents!accessing!public! !
!OS.COM.IStream categoriesFor: #copy!copying!public! !
!OS.COM.IStream categoriesFor: #copyFrom:to:!copying!public! !
!OS.COM.IStream categoriesFor: #CopyTo:cb:pcbRead:pcbWritten:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #copyTo:count:!copying!public! !
!OS.COM.IStream categoriesFor: #cr!accessing!public! !
!OS.COM.IStream categoriesFor: #do:!public! !
!OS.COM.IStream categoriesFor: #fastFlush!operations!public! !
!OS.COM.IStream categoriesFor: #flush!operations!public! !
!OS.COM.IStream categoriesFor: #grow!accessing!private! !
!OS.COM.IStream categoriesFor: #handle!accessing!public! !
!OS.COM.IStream categoriesFor: #isEmpty!public!testing! !
!OS.COM.IStream categoriesFor: #isReadable!public!testing! !
!OS.COM.IStream categoriesFor: #isWriteable!public!testing! !
!OS.COM.IStream categoriesFor: #lockFrom:to:!operations!public! !
!OS.COM.IStream categoriesFor: #lockFrom:to:type:!operations!public! !
!OS.COM.IStream categoriesFor: #LockRegion:cb:dwLockType:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #mode!accessing!public! !
!OS.COM.IStream categoriesFor: #name!accessing!public! !
!OS.COM.IStream categoriesFor: #nextCLSID!accessing!public! !
!OS.COM.IStream categoriesFor: #nextLine!accessing!public! !
!OS.COM.IStream categoriesFor: #nextPutCLSID:!accessing!public! !
!OS.COM.IStream categoriesFor: #notEmpty!public!testing! !
!OS.COM.IStream categoriesFor: #peek!accessing!public! !
!OS.COM.IStream categoriesFor: #peekFor:!accessing!public! !
!OS.COM.IStream categoriesFor: #position!accessing!public! !
!OS.COM.IStream categoriesFor: #position:!accessing!public! !
!OS.COM.IStream categoriesFor: #reset!accessing!public! !
!OS.COM.IStream categoriesFor: #resize:!accessing!public! !
!OS.COM.IStream categoriesFor: #Revert!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #rollback!operations!public! !
!OS.COM.IStream categoriesFor: #Seek:dwOrigin:plibNewPosition:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #SetSize:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #setToEnd!positioning!public! !
!OS.COM.IStream categoriesFor: #size!accessing!public! !
!OS.COM.IStream categoriesFor: #skip:!positioning!public! !
!OS.COM.IStream categoriesFor: #space!accessing!public! !
!OS.COM.IStream categoriesFor: #stat!accessing!public! !
!OS.COM.IStream categoriesFor: #Stat:grfStatFlag:!**auto generated**!primitives!public! !
!OS.COM.IStream categoriesFor: #tab!accessing!public! !
!OS.COM.IStream categoriesFor: #unlockFrom:to:!operations!public! !
!OS.COM.IStream categoriesFor: #unlockFrom:to:type:!operations!public! !
!OS.COM.IStream categoriesFor: #UnlockRegion:cb:dwLockType:!**auto generated**!primitives!public! !

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

	^(ShlwapiLibrary default shCreateMemStream: aByteArray cbInit: aByteArray size)
		ifNil: [Win32Error signal]
		ifNotNil: 
			[:stm |
			stm
				beFinalizable;
				yourself]!

onHGLOBAL
	"Answer an instance of the receiver which is writing to the system provided
	ILockBytes implementation on top of a global memory handle."

	^self onHGLOBAL: nil!

onHGLOBAL: hGlobal
	"Answer a pointer instance of the receiver to an ILockBytes on top of the block of 
	global memory identified by the argument, hGlobal."

	| answer |
	answer := self newPointer.
	OLELibrary default
		createStreamOnHGlobal: hGlobal
		fDeleteOnRelease: true
		ppstm: answer.
	^answer!

onURL: urlString
	"Answer a new instance of the receiver on the file, web page, etc, with the specified
	URL."

	| answer |
	answer := self newPointer.
	URLMonLibrary default
		urlOpenBlockingStream: nil
		szURL: urlString
		ppStream: answer
		dwReserved: 0
		lpfnCB: nil.
	^answer! !
!OS.COM.IStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!OS.COM.IStream class categoriesFor: #fromBytes:!instance creation!public! !
!OS.COM.IStream class categoriesFor: #onHGLOBAL!instance creation!public! !
!OS.COM.IStream class categoriesFor: #onHGLOBAL:!instance creation!public! !
!OS.COM.IStream class categoriesFor: #onURL:!instance creation!public! !

