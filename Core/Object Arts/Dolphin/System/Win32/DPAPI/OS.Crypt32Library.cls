"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.Crypt32Library'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'CRYPTPROTECT_AUDIT' -> 16r10.
			'CRYPTPROTECT_CRED_REGENERATE' -> 16r80.
			'CRYPTPROTECT_CRED_SYNC' -> 16r8.
			'CRYPTPROTECT_FIRST_RESERVED_FLAGVAL' -> 16rFFFFFFF.
			'CRYPTPROTECT_LAST_RESERVED_FLAGVAL' -> 16rFFFFFFFF.
			'CRYPTPROTECT_LOCAL_MACHINE' -> 16r4.
			'CRYPTPROTECT_NO_RECOVERY' -> 16r20.
			'CRYPTPROTECT_PROMPT_ON_PROTECT' -> 16r2.
			'CRYPTPROTECT_PROMPT_ON_UNPROTECT' -> 16r1.
			'CRYPTPROTECT_PROMPT_REQUIRE_STRONG' -> 16r10.
			'CRYPTPROTECT_PROMPT_RESERVED' -> 16r4.
			'CRYPTPROTECT_PROMPT_STRONG' -> 16r8.
			'CRYPTPROTECT_UI_FORBIDDEN' -> 16r1.
			'CRYPTPROTECT_VERIFY_PROTECTION' -> 16r40.
			'CRYPTPROTECTMEMORY_BLOCK_SIZE' -> 16r10.
			'CRYPTPROTECTMEMORY_CROSS_PROCESS' -> 16r1.
			'CRYPTPROTECTMEMORY_SAME_LOGON' -> 16r2.
			'CRYPTPROTECTMEMORY_SAME_PROCESS' -> 16r0
		}!

OS.Crypt32Library guid: (Core.GUID fromString: '{02c78993-ba10-47a1-953f-63f60b7693ab}')!

OS.Crypt32Library comment: 'Crypt32Library is the <ExternalLibrary> class to represent the dynamic link library, ''Crypt32.dll''. It was generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Crypto API"

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.
'!

!OS.Crypt32Library categoriesForClass!Win32-Modules! !

!OS.Crypt32Library methodsFor!

cryptProtectData: pDataIn szDataDescr: szDataDescr pOptionalEntropy: pOptionalEntropy pvReserved: pvReserved pPromptStruct: pPromptStruct dwFlags: dwFlags pDataOut: pDataOut
	"Invoke the CryptProtectData() function of the module wrapped by the receiver.

		BOOL __stdcall CryptProtectData(
			DATA_BLOB* pDataIn,
			LPCWSTR szDataDescr,
			DATA_BLOB* pOptionalEntropy,
			void* pvReserved,
			CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct,
			unsigned long dwFlags,
			DATA_BLOB* pDataOut);"

	<stdcall: bool CryptProtectData CRYPTOAPI_BLOB* lpwstr CRYPTOAPI_BLOB* void* CRYPTPROTECT_PROMPTSTRUCT* uint32 CRYPTOAPI_BLOB*>
	^self invalidCall: _failureCode!

cryptProtectMemory: pDataIn cbDataIn: cbDataIn dwFlags: dwFlags
	"Invoke the CryptProtectMemory() function of the module wrapped by the receiver.

		BOOL __stdcall CryptProtectMemory(
			LPVOID pDataIn,
			unsigned long cbDataIn,
			unsigned long dwFlags);"

	<stdcall: bool CryptProtectMemory void* uint32 uint32>
	^self invalidCall: _failureCode!

cryptUnprotectData: pDataIn ppszDataDescr: ppszDataDescr pOptionalEntropy: pOptionalEntropy pvReserved: pvReserved pPromptStruct: pPromptStruct dwFlags: dwFlags pDataOut: pDataOut
	"Invoke the CryptUnprotectData() function of the module wrapped by the receiver.

		BOOL __stdcall CryptUnprotectData(
			DATA_BLOB* pDataIn,
			LPWSTR* ppszDataDescr,
			DATA_BLOB* pOptionalEntropy,
			void* pvReserved,
			CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct,
			unsigned long dwFlags,
			DATA_BLOB* pDataOut);"

	<stdcall: bool CryptUnprotectData CRYPTOAPI_BLOB* lpwstr* CRYPTOAPI_BLOB* void* CRYPTPROTECT_PROMPTSTRUCT* uint32 CRYPTOAPI_BLOB*>
	^self invalidCall: _failureCode!

cryptUnprotectMemory: pDataIn cbDataIn: cbDataIn dwFlags: dwFlags
	"Invoke the CryptUnprotectMemory() function of the module wrapped by the receiver.

		BOOL __stdcall CryptUnprotectMemory(
			LPVOID pDataIn,
			unsigned long cbDataIn,
			unsigned long dwFlags);"

	<stdcall: bool CryptUnprotectMemory void* uint32 uint32>
	^self invalidCall: _failureCode! !

!OS.Crypt32Library categoriesForMethods!
cryptProtectData:szDataDescr:pOptionalEntropy:pvReserved:pPromptStruct:dwFlags:pDataOut:!**auto generated**!public!win32 functions-security and identity! !
cryptProtectMemory:cbDataIn:dwFlags:!**auto generated**!public!win32 functions-security and identity! !
cryptUnprotectData:ppszDataDescr:pOptionalEntropy:pvReserved:pPromptStruct:dwFlags:pDataOut:!**auto generated**!public!win32 functions-security and identity! !
cryptUnprotectMemory:cbDataIn:dwFlags:!**auto generated**!public!win32 functions-security and identity! !
!

!OS.Crypt32Library class methodsFor!

example1
	| encrypted decrypted original |
	original := 'Hello world'.
	encrypted := self protectData: original.
	decrypted := self unprotectData: encrypted.
	self assert: [decrypted = original]!

fileName
	"Answer the host system file name for the library."

	^'Crypt32'
!

protectData: aByteObject
	"Answer an encrypted representation for the current user of the data in the byte object
	argument, aByteObject."

	^self protectData: aByteObject additionalEntropy: nil!

protectData: aByteObject additionalEntropy: aByteArrayOrNil
	"Answer an encrypted representation for the current user of the data in the byte object
	argument, aByteObject. Additional entropy to increase the complexity of the encryption can
	be specified by providing a suitable <ByteArray> argument."

	^self
		protectData: aByteObject
		additionalEntropy: aByteArrayOrNil
		machineWide: false!

protectData: aByteObject additionalEntropy: aByteArrayOrNil machineWide: aBoolean
	"Answer an encrypted representation of the data in the byte object argument, aByteObject.
	Additional entropy to increase the complexity of the encryption can be specified by
	providing a suitable <ByteArray> as the second argument. The encrypted data is usually
	associated with the current user, but passing true as the <Boolean> argument will yield data
	associated with the machine context that can subsequently be decrypted by *any* process
	running for any principal. Machine-wide protection is normally only appropriate for service
	applications not running for a specific user."

	| unencrypted encrypted flags description answer entropy |
	unencrypted := CRYPTOAPI_BLOB fromBytes: aByteObject.
	encrypted := CRYPTOAPI_BLOB new.
	flags := CRYPTPROTECT_UI_FORBIDDEN.
	aBoolean ifTrue: [flags := flags | CRYPTPROTECT_LOCAL_MACHINE].
	description := aByteObject class name.
	entropy := aByteArrayOrNil ifNotNil: [CRYPTOAPI_BLOB fromBytes: aByteArrayOrNil].
	(self default
		cryptProtectData: unencrypted
		szDataDescr: description
		pOptionalEntropy: entropy
		pvReserved: nil
		pPromptStruct: nil
		dwFlags: flags
		pDataOut: encrypted) ifFalse: [^Win32Error signal].
	answer := encrypted data copy.
	"The encrypted data is allocated by the API function using LocalAlloc, so free it now to
	avoid generating finalizable garbage"
	encrypted free.
	^answer!

sharedVariableName
	^#{OS.Crypt32}!

unprotectData: aByteArray
	"Decrypt the per-user protected data in the <ByteArray> argument, assumed to have been
	previously encrypted using #protectData:"

	^self unprotectData: aByteArray additionalEntropy: nil!

unprotectData: dataByteArray additionalEntropy: aByteArrayOrNil
	"Decrypt the per-user protected data in the byte object argument, aByteObject, assumed to
	have been protected using one of the #protectData: family of methods. If additional entropy
	was supplied when the data was encrypted, the same entropy values must be provided as the
	<ByteArray> argument."

	^self
		unprotectData: dataByteArray
		additionalEntropy: aByteArrayOrNil
		machineWide: false!

unprotectData: aByteObject additionalEntropy: aByteArrayOrNil machineWide: aBoolean
	"Decrypt the protected data in the byte object argument, aByteObject, answering the
	decrypted data as an instance of the same class as that of the original data. Additional
	entropy to increase the complexity of the encryption can be specified by providing a
	suitable <ByteArray> argument. The encrypted data is usually associated with the current
	user, but passing true as the <Boolean> argument will yield data associated with the machine
	context that can subsequently be decrypted by *any* process running for any user.
	Machine-wide protection is, therefore, normally only appropriate for service applications
	not running for a specific user."

	| unencrypted encrypted flags description answer dataClass entropy size |
	encrypted := CRYPTOAPI_BLOB fromBytes: aByteObject.
	unencrypted := CRYPTOAPI_BLOB new.
	flags := CRYPTPROTECT_UI_FORBIDDEN.
	aBoolean ifTrue: [flags := flags | CRYPTPROTECT_LOCAL_MACHINE].
	description := aByteObject class name asUtf16String.
	description := Address new.
	entropy := aByteArrayOrNil ifNotNil: [CRYPTOAPI_BLOB fromBytes: aByteArrayOrNil].
	(self default
		cryptUnprotectData: encrypted
		ppszDataDescr: description
		pOptionalEntropy: entropy
		pvReserved: nil
		pPromptStruct: nil
		dwFlags: flags
		pDataOut: unencrypted) ifFalse: [^Win32Error signal].
	description := Utf16String fromAddress: description.
	dataClass := description asQualifiedReference valueOrNil ?? ByteArray.
	size := unencrypted cbData.
	answer := unencrypted data
				copy: dataClass
				from: 1
				to: size.
	unencrypted free.
	^answer! !

!OS.Crypt32Library class categoriesForMethods!
example1!examples!public! !
fileName!**auto generated**!constants!public! !
protectData:!operations!public! !
protectData:additionalEntropy:!operations!public! !
protectData:additionalEntropy:machineWide:!operations!public! !
sharedVariableName!constants!private! !
unprotectData:!operations!public! !
unprotectData:additionalEntropy:!operations!public! !
unprotectData:additionalEntropy:machineWide:!operations!public! !
!

