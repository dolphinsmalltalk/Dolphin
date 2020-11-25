"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISequentialStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'OLEStructuredStorageConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ISequentialStream guid: (IID fromString: '{0c733a30-2a1c-11ce-ade5-00aa0044773d}')!
ISequentialStream comment: 'ISequentialStream is a COMInterface class to wrap the standard COM interface of the same name.

ISequentialStream is an abstraction of a simple byte-oriented stream for reading, writing blocks of bytes, with the notion of a current position, although ISequentialStream itself defines no functions to access that position. ISequentialStream is somewhat similar to, though more limited than, <ReadWriteStream> and therefore we implement some of the protocol of that class here on top of the raw ISequentialStream member functions.

ISequentialStream is rather abstract, and starts to get more interesting in the subclass, IStream.'!
!ISequentialStream categoriesForClass!COM-Interfaces! !
!ISequentialStream methodsFor!

close
	"Implement the File protocol close method by committing any changes and
	then releasing the interface."

	self
		flush;
		free!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^ByteArray!

errorEndOfStream
	"Raise an error to the effect that an attempt was made to read off the
	end of the collection over which the receiver is streaming."

	^Stream endOfStreamSignal signalWith: self!

flush
	"Flush the stream to its backing store."

	!

next
	"Attempt to read the next byte from the receiver."

	^(self next: 1) first!

next: anInteger 
	"Attempt to read the next anInteger bytes from the receiver.
	Raise an exception if an attempt is made to read off the end of the stream."

	| elems |
	elems := self nextAvailable: anInteger.
	elems size = anInteger ifFalse: [^self errorEndOfStream].
	^elems!

next: size putAll: aByteObject startingAt: start 
	"Append countInteger elements of aByteObject from startInteger
	to the receiver. Answer aByteObject ."

	self 
		Write: aByteObject yourAddress + start - 1
		cb: size
		pcbWritten: nil.
	^aByteObject!

nextAvailable: anInteger 
	"Answer up to anInteger elements of the receiver's collection.
	Generally, the answer will be a collection of the same class as the one
	accessed by the receiver (though this is determined by the receiver), and 
	will contain anInteger elements, or	as many as are left in the receiver's collection."

	| buf read |
	buf := self contentsSpecies new: anInteger.
	read := self read: buf count: anInteger.
	^buf resize: read!

nextMatchFor: anObject 
	"Access the next object and answer whether it is equal to the argument, anObject.
	Raise an EndOfStream exception (via #next) if there are no more elements in the receiver."

	^anObject = self next!

nextPut: newElement 
	"Attempt to write the specified byte as the next item on the receiver's stream.
	This will not be terribly efficient."

	self nextPutAll: (self contentsSpecies with: newElement).
	^newElement!

nextPutAll: aByteObject 
	"Attempt to write the specified buffer into the receiver's stream.
	Answer the argument."

	self 
		Write: aByteObject
		cb: aByteObject size
		pcbWritten: nil.
	^aByteObject!

nextSDWORD
	"Answer a 32-bit signed integer constructed from the host system
	representation contained in the next 4 bytes on the receiver."

	^(self next: 4) sdwordAtOffset: 0!

nextSDWORDPut: anInteger 
	"Append a 32-bit signed integer in 2's complement representation 
	as the next 4 bytes on the receiver."

	self nextPutAll: (SDWORD fromInteger: anInteger).
	^anInteger!

Read: pv cb: cb pcbRead: pcbRead
	"Invoke the Read() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Read(
			[out] byte* pv,
			[in] unsigned long cb,
			[out] unsigned long* pcbRead);
	"

	<virtual stdcall: hresult 4 sbyte* dword dword*>
	^self invalidCall: _failureCode!

read: buffer count: anInteger 
	"Attempt to read the specified number of bytes from the receiver's stream
	into the supplied buffer. Answer the actual number of bytes read.
	N.B. This purposely simulates the File>>read:count: method in order to
	be able to connect FileStreams to IStreams (which are the Structured Storage
	equivalent of Files)"

	| read |
	read := DWORDBytes new.
	self 
		Read: buffer
		cb: anInteger
		pcbRead: read.
	^read asInteger!

skipTo: anObject 
	"Set the receivers position reference to be past the next occurrence of the
	argument, anObject, in the collection. Answer whether such an occurrence existed."

	
	[| next |
	next := self nextAvailable: 1.
	next isEmpty ifTrue: [^false].
	next first = anObject] 
			whileFalse.
	^true!

upTo: anObject 
	"Answer a collection of elements starting with the next element accessed
	by the receiver, and up to, not inclusive of, the next element that is 
	equal to anObject. Positions the stream after anObject if found.
	If anObject is not in the collection, answer the entire rest of the collection.
	If the receiver is at its end, answer an empty Collection."

	| newStream nextObject |
	newStream := self contentsSpecies writeStream: 128.
	
	[| next |
	next := self nextAvailable: 1.
	next isEmpty or: [(nextObject := next first) = anObject]] 
			whileFalse: [newStream nextPut: nextObject].
	^newStream contents!

Write: pv cb: cb pcbWritten: pcbWritten
	"Invoke the Write() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Write(
			[in] byte* pv,
			[in] unsigned long cb,
			[out] unsigned long* pcbWritten);

	"

	<virtual stdcall: hresult 5 sbyte* dword dword*>
	^self invalidCall: _failureCode!

write: buffer count: anInteger 
	"Attempt to write the specified number of bytes into the receiver's stream
	from the supplied buffer. Answer the actual number of bytes written."

	| written |
	written := DWORDBytes new.
	self 
		Write: buffer
		cb: anInteger
		pcbWritten: written.
	^written asInteger! !
!ISequentialStream categoriesFor: #close!operations!public! !
!ISequentialStream categoriesFor: #contentsSpecies!accessing!private! !
!ISequentialStream categoriesFor: #errorEndOfStream!exceptions!public! !
!ISequentialStream categoriesFor: #flush!operations!public! !
!ISequentialStream categoriesFor: #next!accessing!public! !
!ISequentialStream categoriesFor: #next:!accessing!public! !
!ISequentialStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!ISequentialStream categoriesFor: #nextAvailable:!accessing!public! !
!ISequentialStream categoriesFor: #nextMatchFor:!accessing!public! !
!ISequentialStream categoriesFor: #nextPut:!accessing!public! !
!ISequentialStream categoriesFor: #nextPutAll:!accessing!public! !
!ISequentialStream categoriesFor: #nextSDWORD!binary filing!public! !
!ISequentialStream categoriesFor: #nextSDWORDPut:!binary filing!public! !
!ISequentialStream categoriesFor: #Read:cb:pcbRead:!**auto generated**!primitives!public! !
!ISequentialStream categoriesFor: #read:count:!accessing!public! !
!ISequentialStream categoriesFor: #skipTo:!positioning!public! !
!ISequentialStream categoriesFor: #upTo:!accessing!public! !
!ISequentialStream categoriesFor: #Write:cb:pcbWritten:!**auto generated**!primitives!public! !
!ISequentialStream categoriesFor: #write:count:!accessing!public! !

ISequentialStream methodProtocol: #ISequentialStream attributes: #(#readOnly) selectors: #(#Read:cb:pcbRead: #Write:cb:pcbWritten:)!

!ISequentialStream class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.ISequentialStream'
		ISequentialStream defineTemplate
	"

	self
		defineFunction: #Read:cb:pcbRead: argumentTypes: 'sbyte* dword dword*';
		defineFunction: #Write:cb:pcbWritten: argumentTypes: 'sbyte* dword dword*'! !
!ISequentialStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

