"Filed out from Dolphin Smalltalk 7"!

OS.COM.LockBytesAbstract subclass: #'OS.COM.LockBytes'
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.LockBytes guid: (Core.GUID fromString: '{87b4c541-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.LockBytes comment: 'OLELockBytes is an implementation of the ILockBytes interface on a Smalltalk <ByteArray>. It is primarily intended for testing and development purposes (it is a handy way to see exactly what is being written to a stream), and also as an example implementation of a system COM interface.

OLELockBytes is similar to the system provided ILockBytes implementation on top of a global memory handle, except that the underlying storage mechanism is a ByteArray and it is somewhat slower. It doesn''t support locking.'!
!OS.COM.LockBytes categoriesForClass!COM-Implementations! !
!OS.COM.LockBytes methodsFor!

bytes: anObject 
	"Private - Set the value of the receiver's ''bytes'' instance variable to the argument, anObject."

	bytes := anObject!

contents
	"Answer the contents of the receiver (the byte array)"

	^bytes!

copyBytesInto: buf from: start to: end 
	"Private - Copy the range of bytes from the receiver starting at the one-based
	<integer> offset, start, to the one-based <integer> offset, end, into the <ByteArray>
	(or memory pointed at by an <ExternalAddress>), buf.
	Answer the number of bytes which were actually copied."

	| count |
	count := end - start + 1.
	buf 
		replaceFrom: 1
		to: count
		with: bytes
		startingAt: start.
	^count!

initialize
	"Private - Initialize the receiver's state variables."

	bytes := ByteArray new!

replaceFrom: start to: end with: pBuf 
	"Private - Replace bytes of the receive in the specified range with those
	from memory at the <ExternalAddress>, pBuf. This supports the 
	ILockBytes::WriteAt( ) method."

	bytes 
		replaceFrom: start
		to: end
		with: pBuf
		startingAt: 1!

resize: anInteger 
	"Private - Resize the byte array to have the specified <integer> capacity."

	bytes resize: anInteger!

size
	"Answer the size of the byte array represented by the receiver."

	^bytes size!

WriteAt: offset pv: pBuf cb: cb pcbWritten: pcbWritten 
	"Private - Implement the ILockBytes::WriteAt() interface function.
	Note that we grow to fit if the requested write range is outside that currently
	allocated, and we always answer that we've written the requested number of bytes
	because, errors permitting, we will have. This should all be pretty fast as it
	largely involves primitive operations."

	| end |
	end := offset + cb.
	end > bytes size ifTrue: [self resize: end].
	self 
		replaceFrom: offset + 1
		to: end
		with: pBuf.
	pcbWritten value: cb.
	^S_OK! !
!OS.COM.LockBytes categoriesFor: #bytes:!accessing!private! !
!OS.COM.LockBytes categoriesFor: #contents!accessing!public! !
!OS.COM.LockBytes categoriesFor: #copyBytesInto:from:to:!COM Interfaces-ILockBytes!private! !
!OS.COM.LockBytes categoriesFor: #initialize!initializing!private! !
!OS.COM.LockBytes categoriesFor: #replaceFrom:to:with:!COM Interfaces-ILockBytes!private! !
!OS.COM.LockBytes categoriesFor: #resize:!COM Interfaces-ILockBytes!private! !
!OS.COM.LockBytes categoriesFor: #size!accessing!public! !
!OS.COM.LockBytes categoriesFor: #WriteAt:pv:cb:pcbWritten:!COM Interfaces-ILockBytes!private! !

!OS.COM.LockBytes class methodsFor!

on: bytes
	"Answer an <ILockBytes> on a new instance of the receiver operating
	on the <ByteArray>, bytes."

	^self basicNew
		bytes: bytes;
		queryInterface: ILockBytes! !
!OS.COM.LockBytes class categoriesFor: #on:!instance creation!public! !

