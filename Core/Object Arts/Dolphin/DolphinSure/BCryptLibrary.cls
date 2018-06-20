"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #BCryptLibrary
	instanceVariableNames: 'shaAlgorithmHandle'
	classVariableNames: ''
	poolDictionaries: 'BCryptConstants'
	classInstanceVariableNames: ''!
BCryptLibrary guid: (GUID fromString: '{84b3c6ee-a194-413c-8071-95953a50412e}')!
BCryptLibrary comment: '"Windows BCrypt (Cryptography Next Generation, CNG) library.
  Replacement for DolphinSureCryptoLibrary class and DLL."'!
!BCryptLibrary categoriesForClass!External-Libraries! !
!BCryptLibrary methodsFor!

closeAlgorithmProvider: aAlgorithmHandle flags: aFlags
	"The BCryptCloseAlgorithmProvider function closes an algorithm provider.

	NTSTATUS WINAPI BCryptCloseAlgorithmProvider(
		_Inout_	BCRYPT_ALG_HANDLE	hAlgorithm,
		_In_		ULONG				dwFlags );"

	<stdcall: dword BCryptCloseAlgorithmProvider handle dword>
	^ self invalidCall.!

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

	<stdcall: dword BCryptCreateHash handle handle* byte* dword byte* dword dword>
	^ self invalidCall.!

destroyHash: aHashHandle
	"The BCryptDestroyHash function closes an algorithm provider.

	NTSTATUS WINAPI BCryptDestroyHash(
		_Inout_	BCRYPT_HASH_HANDLE	hHash );"

	<stdcall: dword BCryptDestroyHash handle>
	^ self invalidCall.!

finishHash: aHashHandle output: aOutput outputSize: aOutputSize flags: aFlags
	"The BCryptFinishHash function retrieves the hash or Message Authentication Code (MAC) value for the data accumulated from prior calls to BCryptHashData.

	NTSTATUS WINAPI BCryptFinishHash(
		_Inout_	BCRYPT_HASH_HANDLE	hHash,
		_Out_	PUCHAR				pbOutput,
		_In_		ULONG				cbOutput,
		_In_		ULONG				dwFlags );"

	<stdcall: dword BCryptFinishHash handle byte* dword dword>
	^ self invalidCall.!

getProperty: aHandle property: aProperty output: aOutput outputSize: aOutputSize resultSize: aResultSize flags: aFlags
	"The BCryptGetProperty function retrieves the value of a named property for a BCrypt object.

	NTSTATUS WINAPI BCryptGetProperty(
		_In_		BCRYPT_HANDLE	hObject,
		_In_		LPCWSTR			pszProperty,
		_Out_	PUCHAR			pbOutput,
		_In_		ULONG			cbOutput,
		_Out_	ULONG			*pcbResult,
		_In_		ULONG			dwFlags ); "

	<stdcall: dword BCryptGetProperty handle lpwstr byte* dword dword* dword>
	^ self invalidCall.!

hashData: aHashHandle input: aInput inputSize: aInputSize flags: aFlags
	"The BCryptHashData function performs a one way hash or Message Authentication Code (MAC) on a data buffer.

	NTSTATUS WINAPI BCryptHashData(
		_Inout_	BCRYPT_HASH_HANDLE	hHash,
		_In_		PUCHAR				pbInput,
		_In_		ULONG				cbInput,
		_In_		ULONG				dwFlags );"

	<stdcall: dword BCryptHashData handle byte* dword dword>
	^ self invalidCall.!

openAlgorithmProvider: aHandle id: anId implementation: anImplementation flags: aFlags
	"The BCryptOpenAlgorithmProvider function loads and initializes a BCrypt provider.

	NTSTATUS WINAPI BCryptOpenAlgorithmProvider(
		_Out_	BCRYPT_ALG_HANDLE*	phAlgorithm,
		_In_		LPCWSTR				pszAlgId,
		_In_		LPCWSTR				pszImplementation,
		_In_		DWORD				dwFlags );"

	<stdcall: dword BCryptOpenAlgorithmProvider handle* lpwstr lpwstr dword>
	^ self invalidCall.!

shaAlgorithmHandle
	"Answer internal handle. to the SHA1 algorithm.
	Create it, if it was not allocated yet.
	This handle is never freed, because re-creating it is expensive."

	| status |

	( shaAlgorithmHandle isNil or: [ shaAlgorithmHandle value = 0 ] ) ifTrue: [
		shaAlgorithmHandle := ExternalHandle new.

		status := self openAlgorithmProvider: shaAlgorithmHandle id: BCRYPT_SHA1_ALGORITHM implementation: nil flags: 0.
		( self statusFailed: status ) ifTrue: [ 
			self error: 'BCrypt>>openAlgorithmProvider failed: ', ( status printStringRadix: 16 showRadix: false ) ] ].

	^ shaAlgorithmHandle.!

shaCreate
	"Creates a SHA context. In BCrypt terms, the context is the hash handle."

	| hashHandle status |

	hashHandle := ExternalHandle new.
	status := self createHash: self shaAlgorithmHandle hashHandle: hashHandle hashObject: nil hashObjectSize: 0 secret: 0 secretSize: 0 flags: 0.
	( self statusFailed: status ) ifTrue: [ 
		self error: 'BCrypt>>createHash: failed: ', ( status printStringRadix: 16 showRadix: false ) ].

	^ hashHandle.!

shaDestroy: aHashHandle
	"Destroys the argument SHA handle (context)."

	| status | 

	status := self destroyHash: aHashHandle.
	( self statusFailed: status ) ifTrue: [ 
		self error: 'BCrypt>>destroyHash failed: ', ( status printStringRadix: 16 showRadix: false ) ].
!

shaGetHash: aHashHandle
	"Answer the computed hash for the argument SHA handle.
	 The answer will be a ByteArray of 20 bytes for SHA1"

	| hash status |

	hash := ByteArray new: 20.
	status := self finishHash: aHashHandle output: hash outputSize: hash size flags: 0.
	( self statusFailed: status ) ifTrue: [ 
		self error: 'BCrypt>>finishHash failed: ', ( status printStringRadix: 16 showRadix: false ) ].

	^ hash.!

shaHashBuffer: aHashHandle buffer: buffer
	"Hash the contents in of ByteArray buffer in the currently open hash context."

	| status | 

	status := self hashData: aHashHandle input: buffer inputSize: buffer size flags: 0.
	( self statusFailed: status ) ifTrue: [ 
		self error: 'BCrypt>>hashData failed: ', ( status printStringRadix: 16 showRadix: false ) ].
!

statusFailed: aStatus
	"Answer true if the argument NTSTATUS indicates a fail value."

	^ aStatus >= 16r80000000.! !
!BCryptLibrary categoriesFor: #closeAlgorithmProvider:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #createHash:hashHandle:hashObject:hashObjectSize:secret:secretSize:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #destroyHash:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #finishHash:output:outputSize:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #getProperty:property:output:outputSize:resultSize:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #hashData:input:inputSize:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #openAlgorithmProvider:id:implementation:flags:!public!win32 functions-bcrypt library! !
!BCryptLibrary categoriesFor: #shaAlgorithmHandle!hashing!public! !
!BCryptLibrary categoriesFor: #shaCreate!hashing!public! !
!BCryptLibrary categoriesFor: #shaDestroy:!hashing!public! !
!BCryptLibrary categoriesFor: #shaGetHash:!hashing!public! !
!BCryptLibrary categoriesFor: #shaHashBuffer:buffer:!hashing!public! !
!BCryptLibrary categoriesFor: #statusFailed:!error handling!hashing!public! !

!BCryptLibrary class methodsFor!

fileName
	"Answer the host system file name for the library"

	^ 'BCrypt'! !
!BCryptLibrary class categoriesFor: #fileName!constants!public! !

