"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #OLELockBytesAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'OLEStructuredStorageConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
OLELockBytesAbstract guid: (GUID fromString: '{043e5260-ad92-11d3-b376-080046056106}')!
OLELockBytesAbstract isAbstract: true!
OLELockBytesAbstract comment: 'OLELockBytesAbstract is an abstract superclass which provides common behaviour for implementations of the OLE Structured Storage <ILockBytes> interface. <ILockBytes> is the abstraction used by OLE to represent an array of bytes.
'!
!OLELockBytesAbstract categoriesForClass!COM-Implementations! !
!OLELockBytesAbstract methodsFor!

contents
	"Answer the contents of the receiver (the byte array)"

	^self subclassResponsibility!

copyBytesInto: buf from: start to: end 
	"Private - Copy the range of bytes from the receiver starting at the one-based
	<integer> offset, start, to the one-based <integer> offset, end, into the <ByteArray>
	(or memory pointed at by an <ExternalAddress>), buf.
	Answer the number of bytes which were actually copied."

	^self subclassResponsibility!

Flush
	"Private - Implement the ILockBytes::Flush() interface function.
	A sensible default implementation is to do nothing."

	^S_OK!

LockRegion: LockRegion cb: cb dwLockType: dwLockType 
	"Private - Implement the ILockBytes::LockRegion() interface function.
	Implementation Note: We do not support locking, but, despite what the help
	says we must not answer STG_E_INVALIDFUNCTION because it prevents
	our lock bytes from being acceptable to StgCreateDocfileOnILockBytes. So
	we do what the system's HGLOBAL implementation does, which also doesn't
	support locking, and lie by answering S_OK."

	^S_OK
	"	^STG_E_INVALIDFUNCTION"!

ReadAt: offset pv: pBuf cb: cb pcbRead: pcbRead 
	"Private - Implement the ILockBytes::ReadAt() interface function.
	We do not give an error if the request attempts to read out of bounds
	but instead read as much as we can, answering the number of bytes
	actually read through the sizeOut parameter (a DWORD*)."

	| max |
	max := self size.
	pcbRead value: (self 
				copyBytesInto: pBuf
				from: (offset + 1 min: max)
				to: (offset + cb min: max)).
	^S_OK!

replaceFrom: start to: end with: pBuf 
	"Private - Replace bytes of the receive in the specified range with those
	from memory at the <ExternalAddress>, pBuf. This supports the 
	ILockBytes::WriteAt( ) method."

	^self subclassResponsibility!

resize: anInteger 
	"Private - Resize the byte array to have the specified <integer> capacity.
	This may be just a hint, as some byte arrays are dynamically growable
	so do nothing at this level."

	!

SetSize: anInteger 
	"Private - Implement the ILockBytes::SetSize() interface function.
	This is a hint to preallocate the specified amount of space."

	self resize: anInteger.
	^S_OK!

size
	"Answer the size of the byte array represented by the receiver."

	^self subclassResponsibility!

Stat: pstatstg grfStatFlag: grfStatFlag 
	"Private - Implement the ILockBytes::Stat() interface function.
	There is fairly little information we can usefully provide at this 
	level (just the type and size). We ignore the flag completely."

	pstatstg class init: pstatstg.
	pstatstg
		type: STGTY_LOCKBYTES;
		cbSize: self size.
	^S_OK!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^#(##(ILockBytes))!

UnlockRegion: UnlockRegion cb: cb dwLockType: dwLockType 
	"Private - Implement the ILockBytes::UnlockRegion() interface function.
	See LockRegion."

	^S_OK
	"	^STG_E_INVALIDFUNCTION"!

WriteAt: offset pv: pBuf cb: cb pcbWritten: pcbWritten 
	"Private - Implement the ILockBytes::WriteAt() interface function.
	Note that we grow to fit if the requested write range is outside that currently
	allocated, and we always answer that we've written the requested number of bytes
	because, errors permitting, we will have. This should all be pretty fast as it
	largely involves primitive operations."

	| end |
	end := offset + cb.
	end > self size ifTrue: [self resize: end].
	self 
		replaceFrom: offset + 1
		to: end
		with: pBuf.
	pcbWritten value: cb.
	^S_OK! !
!OLELockBytesAbstract categoriesFor: #contents!accessing!public! !
!OLELockBytesAbstract categoriesFor: #copyBytesInto:from:to:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #Flush!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #LockRegion:cb:dwLockType:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #ReadAt:pv:cb:pcbRead:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #replaceFrom:to:with:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #resize:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #SetSize:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #size!accessing!public! !
!OLELockBytesAbstract categoriesFor: #Stat:grfStatFlag:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #supportedInterfaces!constants!public! !
!OLELockBytesAbstract categoriesFor: #UnlockRegion:cb:dwLockType:!COM Interfaces-ILockBytes!private! !
!OLELockBytesAbstract categoriesFor: #WriteAt:pv:cb:pcbWritten:!COM Interfaces-ILockBytes!private! !

OLELockBytesAbstract methodProtocol: #ILockBytes attributes: #() selectors: #(#Flush #LockRegion:cb:dwLockType: #ReadAt:pv:cb:pcbRead: #SetSize: #Stat:grfStatFlag: #UnlockRegion:cb:dwLockType: #WriteAt:pv:cb:pcbWritten:)!

