﻿"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'OS.BCryptLibrary'
	instanceVariableNames: 'shaAlgorithmHandle'
	classVariableNames: ''
	imports: #(#{OS.BCryptConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.BCryptLibrary guid: (Core.GUID fromString: '{84b3c6ee-a194-413c-8071-95953a50412e}')!
OS.BCryptLibrary comment: '"Windows BCrypt (Cryptography Next Generation, CNG) library.
  Replacement for DolphinSureCryptoLibrary class and DLL."'!
!OS.BCryptLibrary categoriesForClass!External-Libraries! !
!OS.BCryptLibrary methodsFor!

closeAlgorithmProvider: aAlgorithmHandle flags: aFlags
	"The BCryptCloseAlgorithmProvider function closes an algorithm provider.

	NTSTATUS WINAPI BCryptCloseAlgorithmProvider(
		_Inout_	BCRYPT_ALG_HANDLE	hAlgorithm,
		_In_		ULONG				dwFlags );"

	<stdcall: ntstatus BCryptCloseAlgorithmProvider handle uint32>
	^self invalidCall: _failureCode!

createHash: aAlgorithmHandle hashHandle: aHashHandle hashObject: aHashObject hashObjectSize: aHashObjectSize secret: aSecret secretSize: aSecretSize flags: aFlags
	"The The BCryptCreateHash function is called to create a hash or Message Authentication Code (MAC) object.

	NTSTATUS WINAPI BCryptCreateHash(
		_Inout_	BCRYPT_ALG_HANDLE	hAlgorithm,
		_Out_	BCRYPT_HASH_HANDLE*	phHash,
		_Out_	PUCHAR				pbHashObject,
		_In_opt_	ULONG				cbHashObject,
		_In_opt_	PUCHAR				pbSecret,
		_In_		ULONG				cbSecret,
		_In_		ULONG				dwFlags );"

	<stdcall: ntstatus BCryptCreateHash handle handle* uint8* uint32 uint8* uint32 uint32>
	^self invalidCall: _failureCode!

destroyHash: aHashHandle
	"The BCryptDestroyHash function closes an algorithm provider.

	NTSTATUS WINAPI BCryptDestroyHash(
		_Inout_	BCRYPT_HASH_HANDLE	hHash );"

	<stdcall: ntstatus BCryptDestroyHash handle>
	^self invalidCall: _failureCode!

finishHash: aHashHandle output: aOutput outputSize: aOutputSize flags: aFlags
	"The BCryptFinishHash function retrieves the hash or Message Authentication Code (MAC) value for the data accumulated from prior calls to BCryptHashData.

	NTSTATUS WINAPI BCryptFinishHash(
		_Inout_	BCRYPT_HASH_HANDLE	hHash,
		_Out_	PUCHAR				pbOutput,
		_In_		ULONG				cbOutput,
		_In_		ULONG				dwFlags );"

	<stdcall: ntstatus BCryptFinishHash handle uint8* uint32 uint32>
	^self invalidCall: _failureCode!

getProperty: aHandle property: aProperty output: aOutput outputSize: aOutputSize resultSize: aResultSize flags: aFlags
	"The BCryptGetProperty function retrieves the value of a named property for a BCrypt object.

	NTSTATUS WINAPI BCryptGetProperty(
		_In_		BCRYPT_HANDLE	hObject,
		_In_		LPCWSTR			pszProperty,
		_Out_	PUCHAR			pbOutput,
		_In_		ULONG			cbOutput,
		_Out_	ULONG			*pcbResult,
		_In_		ULONG			dwFlags ); "

	<stdcall: ntstatus BCryptGetProperty handle lpwstr uint8* uint32 uint32* uint32>
	^self invalidCall: _failureCode!

hashData: aHashHandle input: aInput inputSize: aInputSize flags: aFlags
	"The BCryptHashData function performs a one way hash or Message Authentication Code (MAC) on a data buffer.

	NTSTATUS WINAPI BCryptHashData(
		_Inout_	BCRYPT_HASH_HANDLE	hHash,
		_In_		PUCHAR				pbInput,
		_In_		ULONG				cbInput,
		_In_		ULONG				dwFlags );"

	<stdcall: ntstatus BCryptHashData handle uint8* uint32 uint32>
	^self invalidCall: _failureCode!

openAlgorithmProvider: aHandle id: anId implementation: anImplementation flags: aFlags
	"The BCryptOpenAlgorithmProvider function loads and initializes a BCrypt provider.

	NTSTATUS WINAPI BCryptOpenAlgorithmProvider(
		_Out_	BCRYPT_ALG_HANDLE*	phAlgorithm,
		_In_		LPCWSTR				pszAlgId,
		_In_		LPCWSTR				pszImplementation,
		_In_		DWORD				dwFlags );"

	<stdcall: ntstatus BCryptOpenAlgorithmProvider handle* lpwstr lpwstr uint32>
	^self invalidCall: _failureCode!

shaAlgorithmHandle
	"Answer internal handle. to the SHA1 algorithm.
	Create it, if it was not allocated yet.
	This handle is never freed, because re-creating it is expensive."

	(shaAlgorithmHandle isNil or: [shaAlgorithmHandle value = 0])
		ifTrue: 
			[shaAlgorithmHandle := Handle new.
			self
				openAlgorithmProvider: shaAlgorithmHandle
				id: BCRYPT_SHA1_ALGORITHM
				implementation: nil
				flags: 0].
	^shaAlgorithmHandle!

shaCreate
	"Creates a SHA context. In BCrypt terms, the context is the hash handle."

	| hashHandle |
	hashHandle := Handle new.
	self
		createHash: self shaAlgorithmHandle
		hashHandle: hashHandle
		hashObject: nil
		hashObjectSize: 0
		secret: 0
		secretSize: 0
		flags: 0.
	^hashHandle!

shaDestroy: aHashHandle
	"Destroys the argument SHA handle (context)."

	self destroyHash: aHashHandle!

shaGetHash: aHashHandle
	"Answer the computed hash for the argument SHA handle.
	 The answer will be a ByteArray of 20 bytes for SHA1"

	| hash |
	hash := ByteArray new: 20.
	self
		finishHash: aHashHandle
		output: hash
		outputSize: hash size
		flags: 0.
	^hash!

shaHashBuffer: aHashHandle buffer: buffer
	"Hash the contents in of ByteArray buffer in the currently open hash context."

	self
		hashData: aHashHandle
		input: buffer
		inputSize: buffer size
		flags: 0! !
!OS.BCryptLibrary categoriesForMethods!
closeAlgorithmProvider:flags:!public!win32 functions-bcrypt library! !
createHash:hashHandle:hashObject:hashObjectSize:secret:secretSize:flags:!public!win32 functions-bcrypt library! !
destroyHash:!public!win32 functions-bcrypt library! !
finishHash:output:outputSize:flags:!public!win32 functions-bcrypt library! !
getProperty:property:output:outputSize:resultSize:flags:!public!win32 functions-bcrypt library! !
hashData:input:inputSize:flags:!public!win32 functions-bcrypt library! !
openAlgorithmProvider:id:implementation:flags:!public!win32 functions-bcrypt library! !
shaAlgorithmHandle!hashing!public! !
shaCreate!hashing!public! !
shaDestroy:!hashing!public! !
shaGetHash:!hashing!public! !
shaHashBuffer:buffer:!hashing!public! !
!

!OS.BCryptLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^ 'BCrypt'!

sharedVariableName
	^#{BCrypt}! !
!OS.BCryptLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

