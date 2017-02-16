"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #Crypt32Library
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinCryptConstants'
	classInstanceVariableNames: ''!
Crypt32Library guid: (GUID fromString: '{02C78993-BA10-47A1-953F-63F60B7693AB}')!
Crypt32Library comment: 'Crypt32Library is the <ExternalLibrary> class to represent the dynamic link library, ''Crypt32.dll''.It was generated generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Crypto API"

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("Crypt32.dll"), 
	uuid(02c78993-ba10-47a1-953f-63f60b7693ab), 
	helpstring("Crypto API")
]
module Crypt32
{
	const unsigned long CRYPTPROTECT_PROMPT_ON_UNPROTECT = 1;
	const unsigned long CRYPTPROTECT_PROMPT_ON_PROTECT = 2;
	const unsigned long CRYPTPROTECT_PROMPT_RESERVED = 4;
	const unsigned long CRYPTPROTECT_PROMPT_STRONG = 8;
	const unsigned long CRYPTPROTECT_PROMPT_REQUIRE_STRONG = 16;
	const unsigned long CRYPTPROTECT_UI_FORBIDDEN = 1;
	const unsigned long CRYPTPROTECT_LOCAL_MACHINE = 4;
	const unsigned long CRYPTPROTECT_CRED_SYNC = 8;
	const unsigned long CRYPTPROTECT_AUDIT = 16;
	const unsigned long CRYPTPROTECT_NO_RECOVERY = 32;
	const unsigned long CRYPTPROTECT_VERIFY_PROTECTION = 64;
	const unsigned long CRYPTPROTECT_CRED_REGENERATE = 128;
	const unsigned long CRYPTPROTECT_FIRST_RESERVED_FLAGVAL = 268435455;
	const unsigned long CRYPTPROTECT_LAST_RESERVED_FLAGVAL = 4294967295;
	const unsigned long CRYPTPROTECTMEMORY_BLOCK_SIZE = 16;
	const unsigned long CRYPTPROTECTMEMORY_SAME_PROCESS = 0;
	const unsigned long CRYPTPROTECTMEMORY_CROSS_PROCESS = 1;
	const unsigned long CRYPTPROTECTMEMORY_SAME_LOGON = 2;

	[entry(0x60000000)]
	BOOL __stdcall CryptProtectData(
		DATA_BLOB* pDataIn,
		LPCWSTR szDataDescr,
		DATA_BLOB* pOptionalEntropy,
		void* pvReserved,
		CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct,
		unsigned long dwFlags,
		DATA_BLOB* pDataOut);
	[entry(0x60000001)]
	BOOL __stdcall CryptUnprotectData(
		DATA_BLOB* pDataIn,
		LPWSTR* ppszDataDescr,
		DATA_BLOB* pOptionalEntropy,
		void* pvReserved,
		CRYPTPROTECT_PROMPTSTRUCT* pPromptStruct,
		unsigned long dwFlags,
		DATA_BLOB* pDataOut);
	[entry(0x60000002)]
	BOOL __stdcall CryptProtectMemory(
		LPVOID pDataIn,
		unsigned long cbDataIn,
		unsigned long dwFlags);
	[entry(0x60000003)]
	BOOL __stdcall CryptUnprotectMemory(
		LPVOID pDataIn,
		unsigned long cbDataIn,
		unsigned long dwFlags);
};
'!
!Crypt32Library categoriesForClass!Win32-Modules! !
!Crypt32Library methodsFor!

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

	<stdcall: bool CryptProtectData CRYPTOAPI_BLOB* lpwstr CRYPTOAPI_BLOB* void* CRYPTPROTECT_PROMPTSTRUCT* dword CRYPTOAPI_BLOB*>
	^self invalidCall!

cryptProtectMemory: pDataIn cbDataIn: cbDataIn dwFlags: dwFlags
	"Invoke the CryptProtectMemory() function of the module wrapped by the receiver.

		BOOL __stdcall CryptProtectMemory(
			LPVOID pDataIn,
			unsigned long cbDataIn,
			unsigned long dwFlags);"

	<stdcall: bool CryptProtectMemory void* dword dword>
	^self invalidCall!

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

	<stdcall: bool CryptUnprotectData CRYPTOAPI_BLOB* lpwstr* CRYPTOAPI_BLOB* void* CRYPTPROTECT_PROMPTSTRUCT* dword CRYPTOAPI_BLOB*>
	^self invalidCall!

cryptUnprotectMemory: pDataIn cbDataIn: cbDataIn dwFlags: dwFlags
	"Invoke the CryptUnprotectMemory() function of the module wrapped by the receiver.

		BOOL __stdcall CryptUnprotectMemory(
			LPVOID pDataIn,
			unsigned long cbDataIn,
			unsigned long dwFlags);"

	<stdcall: bool CryptUnprotectMemory void* dword dword>
	^self invalidCall! !
!Crypt32Library categoriesFor: #cryptProtectData:szDataDescr:pOptionalEntropy:pvReserved:pPromptStruct:dwFlags:pDataOut:!**auto generated**!public! !
!Crypt32Library categoriesFor: #cryptProtectMemory:cbDataIn:dwFlags:!**auto generated**!public! !
!Crypt32Library categoriesFor: #cryptUnprotectData:ppszDataDescr:pOptionalEntropy:pvReserved:pPromptStruct:dwFlags:pDataOut:!**auto generated**!public! !
!Crypt32Library categoriesFor: #cryptUnprotectMemory:cbDataIn:dwFlags:!**auto generated**!public! !

!Crypt32Library class methodsFor!

example1
	| encrypted decrypted |
	encrypted := self protectData: 'Hello world'.
	decrypted := self unprotectData: encrypted!

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

protectData: aByteObject additionalEntropy: aByteArray machineWide: aBoolean
	"Answer an encrypted representation of the data in the byte object argument, aByteObject.
	Additional entropy to increase the complexity of the encryption can be specified by
	providing a suitable <ByteArray> argument.. The encrypted data is usually associated with
	the current user, but passing true as the <Boolean> argument will yield data associated with
	the machine context that can subsequently be decrypted by any process running for any
	principal. Machine-wide protection is normally only appropriate for service applications not
	running for a specific user."

	| unencrypted encrypted flags description answer |
	unencrypted := CRYPTOAPI_BLOB fromBytes: aByteObject.
	encrypted := CRYPTOAPI_BLOB new.
	flags := WinCryptConstants.CRYPTPROTECT_UI_FORBIDDEN.
	aBoolean ifTrue: [flags := flags | WinCryptConstants.CRYPTPROTECT_LOCAL_MACHINE].
	description := aByteObject class name asUnicodeString.
	(self default
		cryptProtectData: unencrypted
		szDataDescr: description
		pOptionalEntropy: aByteArray
		pvReserved: nil
		pPromptStruct: nil
		dwFlags: flags
		pDataOut: encrypted) ifFalse: [^Win32Error signal].
	answer := encrypted data copy.
	encrypted free.
	^answer!

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

unprotectData: aByteObject additionalEntropy: aByteArray machineWide: aBoolean
	"Decrypt the protected data in the <ByteArray> argument, dataByteArray.
	Additional entropy to increase the complexity of the encryption can be specified by
	providing a suitable <ByteArray> argument.. The encrypted data is usually associated with
	the current user, but passing true as the <Boolean> argument will yield data associated with
	the machine context that can subsequently be decrypted by any process running for any
	principal. Machine-wide protection is normally only appropriate for service applications not
	running for a specific user."

	| unencrypted encrypted flags description answer dataClass |
	encrypted := CRYPTOAPI_BLOB fromBytes: aByteObject.
	unencrypted := CRYPTOAPI_BLOB new.
	flags := WinCryptConstants.CRYPTPROTECT_UI_FORBIDDEN.
	aBoolean ifTrue: [flags := flags | WinCryptConstants.CRYPTPROTECT_LOCAL_MACHINE].
	description := aByteObject class name asUnicodeString.
	description := ExternalAddress new.
	(self default
		cryptUnprotectData: encrypted
		ppszDataDescr: description
		pOptionalEntropy: aByteArray
		pvReserved: nil
		pPromptStruct: nil
		dwFlags: flags
		pDataOut: unencrypted) ifFalse: [^Win32Error signal].
	description := UnicodeString fromAddress: description.
	dataClass := Smalltalk at: description asString ifAbsent: [ByteArray].
	answer := unencrypted data.
	answer := answer
				copy: dataClass
				from: 1
				to: answer byteSize.
	unencrypted free.
	^answer! !
!Crypt32Library class categoriesFor: #example1!examples!must strip!public! !
!Crypt32Library class categoriesFor: #fileName!**auto generated**!constants!public! !
!Crypt32Library class categoriesFor: #protectData:!operations!public! !
!Crypt32Library class categoriesFor: #protectData:additionalEntropy:!operations!public! !
!Crypt32Library class categoriesFor: #protectData:additionalEntropy:machineWide:!operations!public! !
!Crypt32Library class categoriesFor: #unprotectData:!operations!public! !
!Crypt32Library class categoriesFor: #unprotectData:additionalEntropy:!operations!public! !
!Crypt32Library class categoriesFor: #unprotectData:additionalEntropy:machineWide:!operations!public! !

