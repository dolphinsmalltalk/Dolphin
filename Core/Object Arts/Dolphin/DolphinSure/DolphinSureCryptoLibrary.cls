"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #DolphinSureCryptoLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSureCryptoLibrary guid: (GUID fromString: '{f030bc36-e69b-4268-a9e2-e3eed659edd8}')!
DolphinSureCryptoLibrary comment: 'DolphinSureCryptoLibrary is the ExternalLibrary class to represent the DolphinSureCrypto DLL. It contains cryptographic functions, currently to implement the Secure Hash Algorithm (SHA) described in the U.S. government''s Secure Hash Standard (SHS). This standard is described in FIPS PUB 180-1, "SECURE HASH STANDARD", April 17, 1995. The algorithm contained in this DLL was implemented from the description on p. 442 of ''Applied Cryptography: Protocols, Algorithms, and Source Code in C'' by Bruce Scheier, Wiley, 1996.'!
!DolphinSureCryptoLibrary categoriesForClass!External-Libraries-Cryptography! !
!DolphinSureCryptoLibrary methodsFor!

shaCreate
	"Creates an SHA context and answers the context

	lpvoid SHACreate()"

	<cdecl: lpvoid SHACreate>
	^self invalidCall



!

shaDestroy: context
	"Destroys a SHA context 

	void SHADestroy(LPVOID context)"

	<cdecl: void SHADestroy lpvoid>
	^self invalidCall



!

shaGetHash: context lpHashBytes: hash
	"Gets the computed hash for the SHA context specified by context into a ByteArray
	of 20 bytes at lpHashBytes.

	void SHAGetHash(LPVOID  handle, LPVOID hash)"

	<cdecl: void SHAGetHash lpvoid lpvoid>
	^self invalidCall



!

shaHashBuffer: context lpBuffer: buf dwLen: count
	"Adds the context of buffer to the hash being generated in context

	void SHAHashBuffer(LPVOID  handle, BYTE* buf DWORD count)"

	<cdecl: void SHAHashBuffer lpvoid lpvoid dword>
	^self invalidCall



! !
!DolphinSureCryptoLibrary categoriesFor: #shaCreate!hashing!public! !
!DolphinSureCryptoLibrary categoriesFor: #shaDestroy:!hashing!public! !
!DolphinSureCryptoLibrary categoriesFor: #shaGetHash:lpHashBytes:!hashing!public! !
!DolphinSureCryptoLibrary categoriesFor: #shaHashBuffer:lpBuffer:dwLen:!hashing!public! !

!DolphinSureCryptoLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^'DolphinSureCrypto'! !
!DolphinSureCryptoLibrary class categoriesFor: #fileName!constants!public! !

