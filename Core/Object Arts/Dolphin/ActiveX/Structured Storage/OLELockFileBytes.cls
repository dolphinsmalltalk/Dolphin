"Filed out from Dolphin Smalltalk"!

OLELockBytesAbstract subclass: #OLELockFileBytes
	instanceVariableNames: 'file'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OLELockFileBytes guid: (GUID fromString: '{043e5261-ad92-11d3-b376-080046056106}')!

OLELockFileBytes comment: 'OLELockFileBytes is an implementation of the <ILockBytes> interface on to an arbitrary <File>. It is useful because the system does not provide a standard implementation of ILockBytes against a file, which makes it difficult to connect an <IStream> to an arbitrary file without first copying its contents into a global memory block.'!

!OLELockFileBytes categoriesForClass!COM-Implementations! !

!OLELockFileBytes methodsFor!

contents
	"Answer the contents of the receiver (the byte array)"

	^file contents!

copyBytesInto: buf from: start to: end 
	"Private - Copy the range of bytes from the receiver starting at the one-based
	<integer> offset, start, to the one-based <integer> offset, end, into the <ByteArray>
	(or memory pointed at by an <ExternalAddress>), buf.
	Answer the number of bytes which were actually copied."

	| count |
	count := end - start + 1.
	file
		position: start - 1;
		read: buf count: count.
	^count!

file
	"Private - Answer the value of the receiver's ''file'' instance variable."

	^file!

file: anObject 
	"Private - Set the value of the receiver's ''file'' instance variable to the argument, anObject."

	file := anObject!

replaceFrom: start to: end with: pBuf 
	"Private - Replace bytes of the receive in the specified range with those
	from memory at the <ExternalAddress>, pBuf. This supports the 
	ILockBytes::WriteAt( ) method."

	file
		position: start - 1;
		write: pBuf count: end - start + 1!

size
	"Answer the size of the byte array represented by the receiver."

	^file size!

Stat: pstatstg grfStatFlag: grfStatFlag 
	"Private - Implement the ILockBytes::Stat() interface function."

	super Stat: pstatstg grfStatFlag: grfStatFlag.
	file 
		getTimes: pstatstg ctime
		atime: pstatstg atime
		mtime: pstatstg mtime.
	(grfStatFlag allMask: STATFLAG_NONAME) ifFalse: [pstatstg name: file name].
	^S_OK! !

!OLELockFileBytes categoriesForMethods!
contents!accessing!public! !
copyBytesInto:from:to:!COM Interfaces-ILockBytes!private! !
file!accessing!private! !
file:!accessing!private! !
replaceFrom:to:with:!COM Interfaces-ILockBytes!private! !
size!accessing!public! !
Stat:grfStatFlag:!COM Interfaces-ILockBytes!private! !
!

!OLELockFileBytes class methodsFor!

on: aFile 
	"Answer an <ILockBytes> on a new instance of the receiver attached to the 
	open <File>, aFile."

	^(self new)
		file: aFile;
		queryInterface: ILockBytes! !

!OLELockFileBytes class categoriesForMethods!
on:!instance creation!public! !
!

