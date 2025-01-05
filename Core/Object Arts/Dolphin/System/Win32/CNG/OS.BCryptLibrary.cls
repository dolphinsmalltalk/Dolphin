"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.BCryptLibrary'
	instanceVariableNames: 'algorithmHandles'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'AlgorithmPseudoHandles'
				-> (LookupTable withAll: {
								'AES-CMAC' -> 16r101.
								'AES-GMAC' -> 16r111.
								'CAPI_KDF' -> 16r321.
								'CHACHA20_POLY1305' -> 16r3A1.
								'CSHAKE128' -> 16r411.
								'CSHAKE256' -> 16r421.
								'DH' -> 16r281.
								'DSA' -> 16r2D1.
								'ECDH' -> 16r291.
								'ECDH_P256' -> 16r2A1.
								'ECDH_P384' -> 16r2B1.
								'ECDH_P521' -> 16r2C1.
								'ECDSA' -> 16rF1.
								'ECDSA_P256' -> 16r2E1.
								'ECDSA_P384' -> 16r2F1.
								'ECDSA_P521' -> 16r301.
								'HKDF' -> 16r391.
								'KMAC128' -> 16r431.
								'KMAC256' -> 16r441.
								'MD2' -> 16r1.
								'MD4' -> 16r11.
								'MD5' -> 16r21.
								'PBKDF2' -> 16r331.
								'RC4' -> 16r71.
								'RNG' -> 16r81.
								'RSA' -> 16rE1.
								'RSA_SIGN' -> 16r311.
								'SHA1' -> 16r31.
								'SHA256' -> 16r41.
								'SHA3-256' -> 16r3B1.
								'SHA3-384' -> 16r3C1.
								'SHA3-512' -> 16r3D1.
								'SHA384' -> 16r51.
								'SHA512' -> 16r61.
								'SP800_108_CTR_HMAC' -> 16r341.
								'SP800_56A_CONCAT' -> 16r351.
								'TLS1_1_KDF' -> 16r361.
								'TLS1_2_KDF' -> 16r371.
								'XTS-AES' -> 16r381
							}).
			'BCRYPT_3DES_112_ALGORITHM' -> '3DES_112'.
			'BCRYPT_3DES_112_CBC_ALG_HANDLE' -> 16r171.
			'BCRYPT_3DES_112_CFB_ALG_HANDLE' -> 16r191.
			'BCRYPT_3DES_112_ECB_ALG_HANDLE' -> 16r181.
			'BCRYPT_3DES_ALGORITHM' -> '3DES'.
			'BCRYPT_3DES_CBC_ALG_HANDLE' -> 16r141.
			'BCRYPT_3DES_CFB_ALG_HANDLE' -> 16r161.
			'BCRYPT_3DES_ECB_ALG_HANDLE' -> 16r151.
			'BCRYPT_AES_ALGORITHM' -> 'AES'.
			'BCRYPT_AES_CBC_ALG_HANDLE' -> 16r1A1.
			'BCRYPT_AES_CCM_ALG_HANDLE' -> 16r1D1.
			'BCRYPT_AES_CFB_ALG_HANDLE' -> 16r1C1.
			'BCRYPT_AES_CMAC_ALG_HANDLE' -> 16r101.
			'BCRYPT_AES_CMAC_ALGORITHM' -> 'AES-CMAC'.
			'BCRYPT_AES_ECB_ALG_HANDLE' -> 16r1B1.
			'BCRYPT_AES_GCM_ALG_HANDLE' -> 16r1E1.
			'BCRYPT_AES_GMAC_ALG_HANDLE' -> 16r111.
			'BCRYPT_AES_GMAC_ALGORITHM' -> 'AES-GMAC'.
			'BCRYPT_AES_KWP_ALG_HANDLE' -> 16r451.
			'BCRYPT_ALG_HANDLE_HMAC_FLAG' -> 16r8.
			'BCRYPT_ALGORITHM_NAME' -> 'AlgorithmName'.
			'BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION' -> 16r4.
			'BCRYPT_AUTH_TAG_LENGTH' -> 'AuthTagLength'.
			'BCRYPT_BLOCK_LENGTH' -> 'BlockLength'.
			'BCRYPT_BLOCK_PADDING' -> 16r1.
			'BCRYPT_BLOCK_SIZE_LIST' -> 'BlockSizeList'.
			'BCRYPT_CAPI_AES_FLAG' -> 16r10.
			'BCRYPT_CAPI_KDF_ALG_HANDLE' -> 16r321.
			'BCRYPT_CAPI_KDF_ALGORITHM' -> 'CAPI_KDF'.
			'BCRYPT_CHACHA20_POLY1305_ALG_HANDLE' -> 16r3A1.
			'BCRYPT_CHACHA20_POLY1305_ALGORITHM' -> 'CHACHA20_POLY1305'.
			'BCRYPT_CHAIN_MODE_CBC' -> 'ChainingModeCBC'.
			'BCRYPT_CHAIN_MODE_CCM' -> 'ChainingModeCCM'.
			'BCRYPT_CHAIN_MODE_CFB' -> 'ChainingModeCFB'.
			'BCRYPT_CHAIN_MODE_ECB' -> 'ChainingModeECB'.
			'BCRYPT_CHAIN_MODE_GCM' -> 'ChainingModeGCM'.
			'BCRYPT_CHAIN_MODE_NA' -> 'ChainingModeN/A'.
			'BCRYPT_CHAINING_MODE' -> 'ChainingMode'.
			'BCRYPT_CIPHER_OPERATION' -> 16r1.
			'BCRYPT_CSHAKE128_ALG_HANDLE' -> 16r411.
			'BCRYPT_CSHAKE128_ALGORITHM' -> 'CSHAKE128'.
			'BCRYPT_CSHAKE256_ALG_HANDLE' -> 16r421.
			'BCRYPT_CSHAKE256_ALGORITHM' -> 'CSHAKE256'.
			'BCRYPT_DES_ALGORITHM' -> 'DES'.
			'BCRYPT_DES_CBC_ALG_HANDLE' -> 16r1F1.
			'BCRYPT_DES_CFB_ALG_HANDLE' -> 16r211.
			'BCRYPT_DES_ECB_ALG_HANDLE' -> 16r201.
			'BCRYPT_DESX_ALGORITHM' -> 'DESX'.
			'BCRYPT_DESX_CBC_ALG_HANDLE' -> 16r221.
			'BCRYPT_DESX_CFB_ALG_HANDLE' -> 16r241.
			'BCRYPT_DESX_ECB_ALG_HANDLE' -> 16r231.
			'BCRYPT_DH_ALG_HANDLE' -> 16r281.
			'BCRYPT_DH_ALGORITHM' -> 'DH'.
			'BCRYPT_DSA_ALG_HANDLE' -> 16r2D1.
			'BCRYPT_DSA_ALGORITHM' -> 'DSA'.
			'BCRYPT_ECDH_ALG_HANDLE' -> 16r291.
			'BCRYPT_ECDH_ALGORITHM' -> 'ECDH'.
			'BCRYPT_ECDH_P256_ALG_HANDLE' -> 16r2A1.
			'BCRYPT_ECDH_P256_ALGORITHM' -> 'ECDH_P256'.
			'BCRYPT_ECDH_P384_ALG_HANDLE' -> 16r2B1.
			'BCRYPT_ECDH_P384_ALGORITHM' -> 'ECDH_P384'.
			'BCRYPT_ECDH_P521_ALG_HANDLE' -> 16r2C1.
			'BCRYPT_ECDH_P521_ALGORITHM' -> 'ECDH_P521'.
			'BCRYPT_ECDSA_ALG_HANDLE' -> 16rF1.
			'BCRYPT_ECDSA_ALGORITHM' -> 'ECDSA'.
			'BCRYPT_ECDSA_P256_ALG_HANDLE' -> 16r2E1.
			'BCRYPT_ECDSA_P256_ALGORITHM' -> 'ECDSA_P256'.
			'BCRYPT_ECDSA_P384_ALG_HANDLE' -> 16r2F1.
			'BCRYPT_ECDSA_P384_ALGORITHM' -> 'ECDSA_P384'.
			'BCRYPT_ECDSA_P521_ALG_HANDLE' -> 16r301.
			'BCRYPT_ECDSA_P521_ALGORITHM' -> 'ECDSA_P521'.
			'BCRYPT_EFFECTIVE_KEY_LENGTH' -> 'EffectiveKeyLength'.
			'BCRYPT_GENERATE_IV' -> 16r20.
			'BCRYPT_HASH_BLOCK_LENGTH' -> 'HashBlockLength'.
			'BCRYPT_HASH_LENGTH' -> 'HashDigestLength'.
			'BCRYPT_HASH_OID_LIST' -> 'HashOIDList'.
			'BCRYPT_HASH_OPERATION' -> 16r2.
			'BCRYPT_HASH_REUSABLE_FLAG' -> 16r20.
			'BCRYPT_HKDF_ALG_HANDLE' -> 16r391.
			'BCRYPT_HKDF_ALGORITHM' -> 'HKDF'.
			'BCRYPT_HKDF_HASH_ALGORITHM' -> 'HkdfHashAlgorithm'.
			'BCRYPT_HKDF_PRK_AND_FINALIZE' -> 'HkdfPrkAndFinalize'.
			'BCRYPT_HKDF_SALT_AND_FINALIZE' -> 'HkdfSaltAndFinalize'.
			'BCRYPT_HMAC_MD2_ALG_HANDLE' -> 16r121.
			'BCRYPT_HMAC_MD4_ALG_HANDLE' -> 16r131.
			'BCRYPT_HMAC_MD5_ALG_HANDLE' -> 16r91.
			'BCRYPT_HMAC_SHA1_ALG_HANDLE' -> 16rA1.
			'BCRYPT_HMAC_SHA256_ALG_HANDLE' -> 16rB1.
			'BCRYPT_HMAC_SHA3_256_ALG_HANDLE' -> 16r3E1.
			'BCRYPT_HMAC_SHA3_384_ALG_HANDLE' -> 16r3F1.
			'BCRYPT_HMAC_SHA3_512_ALG_HANDLE' -> 16r401.
			'BCRYPT_HMAC_SHA384_ALG_HANDLE' -> 16rC1.
			'BCRYPT_HMAC_SHA512_ALG_HANDLE' -> 16rD1.
			'BCRYPT_INITIALIZATION_VECTOR' -> 'IV'.
			'BCRYPT_IS_IFX_TPM_WEAK_KEY' -> 'IsIfxTpmWeakKey'.
			'BCRYPT_IS_KEYED_HASH' -> 'IsKeyedHash'.
			'BCRYPT_IS_REUSABLE_HASH' -> 'IsReusableHash'.
			'BCRYPT_KEY_DERIVATION_OPERATION' -> 16r40.
			'BCRYPT_KEY_LENGTH' -> 'KeyLength'.
			'BCRYPT_KEY_LENGTHS' -> 'KeyLengths'.
			'BCRYPT_KEY_OBJECT_LENGTH' -> 'KeyObjectLength'.
			'BCRYPT_KEY_STRENGTH' -> 'KeyStrength'.
			'BCRYPT_KMAC128_ALG_HANDLE' -> 16r431.
			'BCRYPT_KMAC128_ALGORITHM' -> 'KMAC128'.
			'BCRYPT_KMAC256_ALG_HANDLE' -> 16r441.
			'BCRYPT_KMAC256_ALGORITHM' -> 'KMAC256'.
			'BCRYPT_MD2_ALG_HANDLE' -> 16r1.
			'BCRYPT_MD2_ALGORITHM' -> 'MD2'.
			'BCRYPT_MD4_ALG_HANDLE' -> 16r11.
			'BCRYPT_MD4_ALGORITHM' -> 'MD4'.
			'BCRYPT_MD5_ALG_HANDLE' -> 16r21.
			'BCRYPT_MD5_ALGORITHM' -> 'MD5'.
			'BCRYPT_MESSAGE_BLOCK_LENGTH' -> 'MessageBlockLength'.
			'BCRYPT_MULTI_FLAG' -> 16r40.
			'BCRYPT_MULTI_OBJECT_LENGTH' -> 'MultiObjectLength'.
			'BCRYPT_OBJECT_LENGTH' -> 'ObjectLength'.
			'BCRYPT_PAD_NONE' -> 16r1.
			'BCRYPT_PAD_OAEP' -> 16r4.
			'BCRYPT_PAD_PKCS1' -> 16r2.
			'BCRYPT_PAD_PKCS1_OPTIONAL_HASH_OID' -> 16r10.
			'BCRYPT_PAD_PSS' -> 16r8.
			'BCRYPT_PADDING_SCHEMES' -> 'PaddingSchemes'.
			'BCRYPT_PBKDF2_ALG_HANDLE' -> 16r331.
			'BCRYPT_PBKDF2_ALGORITHM' -> 'PBKDF2'.
			'BCRYPT_PCP_PLATFORM_TYPE_PROPERTY' -> 'PCP_PLATFORM_TYPE'.
			'BCRYPT_PCP_PROVIDER_VERSION_PROPERTY' -> 'PCP_PROVIDER_VERSION'.
			'BCRYPT_PRIMITIVE_TYPE' -> 'PrimitiveType'.
			'BCRYPT_PROV_DISPATCH' -> 16r1.
			'BCRYPT_PROVIDER_HANDLE' -> 'ProviderHandle'.
			'BCRYPT_PUBLIC_KEY_LENGTH' -> 'PublicKeyLength'.
			'BCRYPT_RC2_ALGORITHM' -> 'RC2'.
			'BCRYPT_RC2_CBC_ALG_HANDLE' -> 16r251.
			'BCRYPT_RC2_CFB_ALG_HANDLE' -> 16r271.
			'BCRYPT_RC2_ECB_ALG_HANDLE' -> 16r261.
			'BCRYPT_RC4_ALG_HANDLE' -> 16r71.
			'BCRYPT_RC4_ALGORITHM' -> 'RC4'.
			'BCRYPT_RNG_ALG_HANDLE' -> 16r81.
			'BCRYPT_RNG_ALGORITHM' -> 'RNG'.
			'BCRYPT_RNG_DUAL_EC_ALGORITHM' -> 'DUALECRNG'.
			'BCRYPT_RNG_FIPS186_DSA_ALGORITHM' -> 'FIPS186DSARNG'.
			'BCRYPT_RNG_OPERATION' -> 16r20.
			'BCRYPT_RSA_ALG_HANDLE' -> 16rE1.
			'BCRYPT_RSA_ALGORITHM' -> 'RSA'.
			'BCRYPT_RSA_SIGN_ALG_HANDLE' -> 16r311.
			'BCRYPT_RSA_SIGN_ALGORITHM' -> 'RSA_SIGN'.
			'BCRYPT_SECRET_AGREEMENT_OPERATION' -> 16r8.
			'BCRYPT_SHA1_ALG_HANDLE' -> 16r31.
			'BCRYPT_SHA1_ALGORITHM' -> 'SHA1'.
			'BCRYPT_SHA256_ALG_HANDLE' -> 16r41.
			'BCRYPT_SHA256_ALGORITHM' -> 'SHA256'.
			'BCRYPT_SHA3_256_ALG_HANDLE' -> 16r3B1.
			'BCRYPT_SHA3_256_ALGORITHM' -> 'SHA3-256'.
			'BCRYPT_SHA3_384_ALG_HANDLE' -> 16r3C1.
			'BCRYPT_SHA3_384_ALGORITHM' -> 'SHA3-384'.
			'BCRYPT_SHA3_512_ALG_HANDLE' -> 16r3D1.
			'BCRYPT_SHA3_512_ALGORITHM' -> 'SHA3-512'.
			'BCRYPT_SHA384_ALG_HANDLE' -> 16r51.
			'BCRYPT_SHA384_ALGORITHM' -> 'SHA384'.
			'BCRYPT_SHA512_ALG_HANDLE' -> 16r61.
			'BCRYPT_SHA512_ALGORITHM' -> 'SHA512'.
			'BCRYPT_SIGNATURE_LENGTH' -> 'SignatureLength'.
			'BCRYPT_SIGNATURE_OPERATION' -> 16r10.
			'BCRYPT_SP800108_CTR_HMAC_ALG_HANDLE' -> 16r341.
			'BCRYPT_SP800108_CTR_HMAC_ALGORITHM' -> 'SP800_108_CTR_HMAC'.
			'BCRYPT_SP80056A_CONCAT_ALG_HANDLE' -> 16r351.
			'BCRYPT_SP80056A_CONCAT_ALGORITHM' -> 'SP800_56A_CONCAT'.
			'BCRYPT_SUPPORTED_PAD_OAEP' -> 16r8.
			'BCRYPT_SUPPORTED_PAD_PKCS1_ENC' -> 16r2.
			'BCRYPT_SUPPORTED_PAD_PKCS1_SIG' -> 16r4.
			'BCRYPT_SUPPORTED_PAD_PSS' -> 16r10.
			'BCRYPT_SUPPORTED_PAD_ROUTER' -> 16r1.
			'BCRYPT_TLS1_1_KDF_ALG_HANDLE' -> 16r361.
			'BCRYPT_TLS1_1_KDF_ALGORITHM' -> 'TLS1_1_KDF'.
			'BCRYPT_TLS1_2_KDF_ALG_HANDLE' -> 16r371.
			'BCRYPT_TLS1_2_KDF_ALGORITHM' -> 'TLS1_2_KDF'.
			'BCRYPT_XTS_AES_ALG_HANDLE' -> 16r381.
			'BCRYPT_XTS_AES_ALGORITHM' -> 'XTS-AES'.
			'BCRYPTBUFFER_VERSION' -> 16r0.
			'MS_PLATFORM_CRYPTO_PROVIDER' -> 'Microsoft Platform Crypto Provider'.
			'MS_PRIMITIVE_PROVIDER' -> 'Microsoft Primitive Provider'
		}!

OS.BCryptLibrary guid: (Core.GUID fromString: '{204c379f-30d5-4a94-b981-fbfc55dbe3fc}')!

OS.BCryptLibrary comment: '"Windows BCrypt (Cryptography Next Generation, CNG) library.
  Replacement for DolphinSureCryptoLibrary class and DLL."'!

!OS.BCryptLibrary categoriesForClass!External-Libraries! !

!OS.BCryptLibrary methodsFor!

algorithmHandles
	^algorithmHandles ifNil: [algorithmHandles := AlgorithmPseudoHandles copy]!

availableHashAlgorithms
	"Answer an array of the names of all the available hash algorithms:

		BCrypt availableHashAlgorithms 
			=> #('SHA256' 'SHA384' 'SHA512' 'SHA1' 'MD5' 'MD4' 'MD2' 'AES-GMAC' 'AES-CMAC' 'SHA3-256' 'SHA3-384' 'SHA3-512' 'CSHAKE128' 'CSHAKE256' 'KMAC128' 'KMAC256')

	On older Win11 installations SHA-3 and some other algorithms may not be available."

	| pAlgList algCount |
	pAlgList := Address new.
	algCount := UInt32Bytes new.
	self
		bCryptEnumAlgorithms: BCRYPT_HASH_OPERATION
		pAlgCount: algCount
		ppAlgList: pAlgList
		dwFlags: 0.
	^
	[(StructureArray
		fromAddress: pAlgList
		length: algCount asInteger
		elementClass: BCRYPT_ALGORITHM_IDENTIFIER) collect: [:each | each pszName asUtf8String]]
			ensure: [self bCryptFreeBuffer: pAlgList]!

bCryptCloseAlgorithmProvider: hAlgorithm dwFlags: dwFlags
	"Invoke the BCryptCloseAlgorithmProvider() function of the module wrapped by the receiver.
	Helpstring: Closes an algorithm provider.

		NTSTATUS __stdcall BCryptCloseAlgorithmProvider(
			BCRYPT_ALG_HANDLE hAlgorithm,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptCloseAlgorithmProvider handle uint32>
	^self invalidCall: _failureCode!

bCryptCreateHash: hAlgorithm phHash: phHash pbHashObject: pbHashObject cbHashObject: cbHashObject pbSecret: pbSecret cbSecret: cbSecret dwFlags: dwFlags
	"Invoke the BCryptCreateHash() function of the module wrapped by the receiver.
	Helpstring: Create a hash or Message Authentication Code (MAC) object.

		NTSTATUS __stdcall BCryptCreateHash(
			BCRYPT_ALG_HANDLE hAlgorithm,
			BCRYPT_HASH_HANDLE* phHash,
			UCHAR* pbHashObject,
			ULONG cbHashObject,
			UCHAR* pbSecret,
			ULONG cbSecret,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptCreateHash handle handle* uint8* uint32 uint8* uint32 uint32>
	^self invalidCall: _failureCode!

bCryptDestroyHash: hHash
	"Invoke the BCryptDestroyHash() function of the module wrapped by the receiver.
	Helpstring: Destroys a hash or Message Authentication Code (MAC) object.

		NTSTATUS __stdcall BCryptDestroyHash(
			BCRYPT_HASH_HANDLE hHash);"

	<stdcall: NTSTATUS BCryptDestroyHash handle>
	^self invalidCall: _failureCode!

bCryptDuplicateHash: hHash phNewHash: phNewHash pbHashObject: pbHashObject cbHashObject: cbHashObject dwFlags: dwFlags
	"Invoke the BCryptDuplicateHash() function of the module wrapped by the receiver.
	Helpstring: Duplicates an existing hash or Message Authentication Code (MAC) object. The duplicate object contains all state and data contained in the original object at the point of duplication.

		NTSTATUS __stdcall BCryptDuplicateHash(
			BCRYPT_HASH_HANDLE hHash,
			BCRYPT_HASH_HANDLE* phNewHash,
			UCHAR* pbHashObject,
			ULONG cbHashObject,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptDuplicateHash handle handle* uint8* uint32 uint32>
	^self invalidCall: _failureCode!

bCryptEnumAlgorithms: dwAlgOperations pAlgCount: pAlgCount ppAlgList: ppAlgList dwFlags: dwFlags
	"Invoke the BCryptEnumAlgorithms() function of the module wrapped by the receiver.
	Helpstring: Gets a list of the registered algorithm identifiers.

		void __stdcall BCryptEnumAlgorithms(
			ULONG dwAlgOperations,
			ULONG* pAlgCount,
			BCRYPT_ALGORITHM_IDENTIFIER** ppAlgList,
			ULONG dwFlags);"

	<stdcall: void BCryptEnumAlgorithms uint32 uint32* BCRYPT_ALGORITHM_IDENTIFIER** uint32>
	^self invalidCall: _failureCode!

bCryptEnumProviders: pszAlgId pImplCount: pImplCount ppImplList: ppImplList dwFlags: dwFlags
	"Invoke the BCryptEnumProviders() function of the module wrapped by the receiver.
	Helpstring: Obtains all of the CNG providers that support a specified algorithm..

		void __stdcall BCryptEnumProviders(
			LPCWSTR pszAlgId,
			ULONG* pImplCount,
			BCRYPT_PROVIDER_NAME** ppImplList,
			ULONG dwFlags);"

	<stdcall: void BCryptEnumProviders lpwstr uint32* BCRYPT_PROVIDER_NAME** uint32>
	^self invalidCall: _failureCode!

bCryptFinishHash: hHash pbOutput: pbOutput cbOutput: cbOutput dwFlags: dwFlags
	"Invoke the BCryptFinishHash() function of the module wrapped by the receiver.
	Helpstring: Retrieves the hash or Message Authentication Code (MAC) value for the data accumulated from prior calls to BCryptHashData.

		NTSTATUS __stdcall BCryptFinishHash(
			BCRYPT_HASH_HANDLE hHash,
			UCHAR* pbOutput,
			ULONG cbOutput,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptFinishHash handle uint8* uint32 uint32>
	^self invalidCall: _failureCode!

bCryptFreeBuffer: pvBuffer
	"Invoke the BCryptFreeBuffer() function of the module wrapped by the receiver.
	Helpstring: Free memory that was allocated by one of the CNG functions.

		void __stdcall BCryptFreeBuffer(
			void* pvBuffer);"

	<stdcall: void BCryptFreeBuffer void*>
	^self invalidCall: _failureCode!

bCryptGetProperty: hObject pszProperty: pszProperty pbOutput: pbOutput cbOutput: cbOutput pcbResult: pcbResult dwFlags: dwFlags
	"Invoke the BCryptGetProperty() function of the module wrapped by the receiver.
	Helpstring: Retrieves the value of a named property for a CNG object.

		NTSTATUS __stdcall BCryptGetProperty(
			BCRYPT_HANDLE hObject,
			LPCWSTR pszProperty,
			UCHAR* pbOutput,
			ULONG cbOutput,
			ULONG* pcbResult,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptGetProperty handle lpwstr uint8* uint32 uint32* uint32>
	^self invalidCall: _failureCode!

bCryptHash: hAlgorithm pbSecret: pbSecret cbSecret: cbSecret pbInput: pbInput cbInput: cbInput pbOutput: pbOutput cbOutput: cbOutput
	"Invoke the BCryptHash() function of the module wrapped by the receiver.
	Helpstring: Performs a single hash computation. This is a convenience function that wraps calls to BCryptCreateHash, BCryptHashData, BCryptFinishHash, and BCryptDestroyHash.

		NTSTATUS __stdcall BCryptHash(
			BCRYPT_ALG_HANDLE hAlgorithm,
			UCHAR* pbSecret,
			ULONG cbSecret,
			UCHAR* pbInput,
			ULONG cbInput,
			UCHAR* pbOutput,
			ULONG cbOutput);"

	<stdcall: NTSTATUS BCryptHash handle uint8* uint32 uint8* uint32 uint8* uint32>
	^self invalidCall: _failureCode!

bCryptHashData: hHash pbInput: pbInput cbInput: cbInput dwFlags: dwFlags
	"Invoke the BCryptHashData() function of the module wrapped by the receiver.
	Helpstring: Performs a one way hash or Message Authentication Code (MAC) on a data buffer.

		NTSTATUS __stdcall BCryptHashData(
			BCRYPT_HASH_HANDLE hHash,
			UCHAR* pbInput,
			ULONG cbInput,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptHashData handle uint8* uint32 uint32>
	^self invalidCall: _failureCode!

bCryptOpenAlgorithmProvider: phAlgorithm pszAlgId: pszAlgId pszImplementation: pszImplementation dwFlags: dwFlags
	"Invoke the BCryptOpenAlgorithmProvider() function of the module wrapped by the receiver.
	Helpstring: Loads and initializes a CNG provider.

		NTSTATUS __stdcall BCryptOpenAlgorithmProvider(
			BCRYPT_ALG_HANDLE* phAlgorithm,
			LPCWSTR pszAlgId,
			LPCWSTR pszImplementation,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptOpenAlgorithmProvider handle* lpwstr lpwstr uint32>
	^self invalidCall: _failureCode!

bCryptSetProperty: hObject pszProperty: pszProperty pbInput: pbInput cbInput: cbInput dwFlags: dwFlags
	"Invoke the BCryptSetProperty() function of the module wrapped by the receiver.
	Helpstring: Sets the value of a named property for a CNG object.

		NTSTATUS __stdcall BCryptSetProperty(
			BCRYPT_HANDLE hObject,
			LPCWSTR pszProperty,
			UCHAR* pbInput,
			ULONG cbInput,
			ULONG dwFlags);"

	<stdcall: NTSTATUS BCryptSetProperty handle lpwstr uint8* uint32 uint32>
	^self invalidCall: _failureCode!

close
	self closeAlgorithms.
	^super close!

closeAlgorithms
	algorithmHandles ifNil: [^self].
	algorithmHandles do: 
			[:each |
			"The pseudo-handles are all odd integer values"
			each asInteger even ifTrue: [self bCryptCloseAlgorithmProvider: each dwFlags: 0]].
	algorithmHandles := nil!

createHash: algHandle
	| hashHandle |
	hashHandle := Handle new.
	self
		bCryptCreateHash: algHandle
		phHash: hashHandle
		pbHashObject: nil
		cbHashObject: 0
		pbSecret: 0
		cbSecret: 0
		dwFlags: 0.
	^hashHandle!

createNamedHash: aString
	^self createHash: (self getProviderHandle: aString)!

getProviderHandle: aString
	^(self algorithmHandles lookup: aString)
		ifNil: 
			[| hAlgo |
			hAlgo := Handle new.
			self
				bCryptOpenAlgorithmProvider: hAlgo
				pszAlgId: aString
				pszImplementation: MS_PRIMITIVE_PROVIDER
				dwFlags: 0.
			algorithmHandles at: aString put: hAlgo]!

hash: aByteArray algorithm: aHandle
	"Answer a <ByteArray> representing the hash value of the first argument when hashed with the algorithm with the handle that is the 2nd argument."

	| buf |
	buf := ByteArray newFixed: 8.
	self
		bCryptGetProperty: aHandle
		pszProperty: BCRYPT_HASH_LENGTH
		pbOutput: buf
		cbOutput: 4
		pcbResult: buf yourAddress + 4
		dwFlags: 0.
	^self
		hash: aByteArray
		algorithm: aHandle
		length: (buf uint32AtOffset: 0)!

hash: aByteArray algorithm: aHandle length: anInteger
	| hashBytes |
	hashBytes := ByteArray newFixed: anInteger.
	self
		bCryptHash: aHandle
		pbSecret: nil
		cbSecret: 0
		pbInput: aByteArray
		cbInput: aByteArray size
		pbOutput: hashBytes
		cbOutput: anInteger.
	^hashBytes!

hash: aByteArray algorithmName: aString
	"Answer a <ByteArray> representing the hash value of the first argument when hashed with the algorithm named the the <String> second argument."

	^self hash: aByteArray algorithm: (self getProviderHandle: aString)!

md5Hash: aByteArray
	"Answer a 16-byte <ByteArray> containing the MD5 hash of the <ByteArray> argument. Note that this is definitely not suitable for cryptographic purposes."

	^self
		hash: aByteArray
		algorithm: BCRYPT_MD5_ALG_HANDLE
		length: 16!

providersOfAlgorithm: aString
	"Answer an array of the names of all providers of the specified algorithm.
		BCrypt providersOfAlgorithm: 'SHA256'
			=> #('Microsoft Primitive Provider')
	"

	| pList count |
	pList := Address new.
	count := UInt32Bytes new.
	self bCryptEnumProviders: aString pImplCount: count ppImplList: pList dwFlags: 0.
	^
	[(StructureArray
		fromAddress: pList
		length: count asInteger
		elementClass: BCRYPT_PROVIDER_NAME) collect: [:each | each pszProviderName asUtf8String]]
			ensure: [self bCryptFreeBuffer: pList]
!

sha1Hash: aByteArray
	"Answer a 20-byte <ByteArray> containing the SHA1 hash of the <ByteArray> argument. Note that this is not suitable for cryptographic purposes."

	^self
		hash: aByteArray
		algorithm: BCRYPT_SHA1_ALG_HANDLE
		length: 20!

sha256Hash: aByteArray
	"Answer a 32-byte <ByteArray> containing the SHA256 hash of the <ByteArray> argument."

	^self
		hash: aByteArray
		algorithm: BCRYPT_SHA256_ALG_HANDLE
		length: ##(256 / 8)! !

!OS.BCryptLibrary categoriesForMethods!
algorithmHandles!accessing!private! !
availableHashAlgorithms!public!utilities! !
bCryptCloseAlgorithmProvider:dwFlags:!**auto generated**!public! !
bCryptCreateHash:phHash:pbHashObject:cbHashObject:pbSecret:cbSecret:dwFlags:!**auto generated**!public! !
bCryptDestroyHash:!**auto generated**!public! !
bCryptDuplicateHash:phNewHash:pbHashObject:cbHashObject:dwFlags:!**auto generated**!public! !
bCryptEnumAlgorithms:pAlgCount:ppAlgList:dwFlags:!**auto generated**!public! !
bCryptEnumProviders:pImplCount:ppImplList:dwFlags:!**auto generated**!public! !
bCryptFinishHash:pbOutput:cbOutput:dwFlags:!**auto generated**!public! !
bCryptFreeBuffer:!**auto generated**!public! !
bCryptGetProperty:pszProperty:pbOutput:cbOutput:pcbResult:dwFlags:!**auto generated**!public! !
bCryptHash:pbSecret:cbSecret:pbInput:cbInput:pbOutput:cbOutput:!**auto generated**!public! !
bCryptHashData:pbInput:cbInput:dwFlags:!**auto generated**!public! !
bCryptOpenAlgorithmProvider:pszAlgId:pszImplementation:dwFlags:!**auto generated**!public! !
bCryptSetProperty:pszProperty:pbInput:cbInput:dwFlags:!**auto generated**!public! !
close!public!realizing/unrealizing! !
closeAlgorithms!private!realizing/unrealizing! !
createHash:!helpers!private! !
createNamedHash:!helpers!private! !
getProviderHandle:!helpers!private! !
hash:algorithm:!public!utilities! !
hash:algorithm:length:!private!utilities! !
hash:algorithmName:!public!utilities! !
md5Hash:!public!utilities! !
providersOfAlgorithm:!public!utilities! !
sha1Hash:!public!utilities! !
sha256Hash:!public!utilities! !
!

!OS.BCryptLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'bcrypt'
!

initialize
	"Note that not all algorithms are necessarily available in all installations. You can probably assume the basic MD5, SHA1, SHA256 will be though. SHA-3 isn't available in my up to date Windows 11 in December 2024 in the UK.

		self initialize
	"
	self addClassConstant: 'AlgorithmPseudoHandles'
		value: (LookupTable withAll: {
						BCRYPT_MD2_ALGORITHM -> BCRYPT_MD2_ALG_HANDLE.
						BCRYPT_MD4_ALGORITHM -> BCRYPT_MD4_ALG_HANDLE.
						BCRYPT_MD5_ALGORITHM -> BCRYPT_MD5_ALG_HANDLE.
						BCRYPT_SHA1_ALGORITHM -> BCRYPT_SHA1_ALG_HANDLE.
						BCRYPT_SHA256_ALGORITHM -> BCRYPT_SHA256_ALG_HANDLE.
						BCRYPT_SHA384_ALGORITHM -> BCRYPT_SHA384_ALG_HANDLE.
						BCRYPT_SHA512_ALGORITHM -> BCRYPT_SHA512_ALG_HANDLE.
						BCRYPT_RC4_ALGORITHM -> BCRYPT_RC4_ALG_HANDLE.
						BCRYPT_RNG_ALGORITHM -> BCRYPT_RNG_ALG_HANDLE.
						BCRYPT_RSA_ALGORITHM -> BCRYPT_RSA_ALG_HANDLE.
						BCRYPT_ECDSA_ALGORITHM -> BCRYPT_ECDSA_ALG_HANDLE.
						BCRYPT_AES_CMAC_ALGORITHM -> BCRYPT_AES_CMAC_ALG_HANDLE.
						BCRYPT_AES_GMAC_ALGORITHM -> BCRYPT_AES_GMAC_ALG_HANDLE.
						BCRYPT_DH_ALGORITHM -> BCRYPT_DH_ALG_HANDLE.
						BCRYPT_ECDH_ALGORITHM -> BCRYPT_ECDH_ALG_HANDLE.
						BCRYPT_ECDH_P256_ALGORITHM -> BCRYPT_ECDH_P256_ALG_HANDLE.
						BCRYPT_ECDH_P384_ALGORITHM -> BCRYPT_ECDH_P384_ALG_HANDLE.
						BCRYPT_ECDH_P521_ALGORITHM -> BCRYPT_ECDH_P521_ALG_HANDLE.
						BCRYPT_DSA_ALGORITHM -> BCRYPT_DSA_ALG_HANDLE.
						BCRYPT_ECDSA_P256_ALGORITHM -> BCRYPT_ECDSA_P256_ALG_HANDLE.
						BCRYPT_ECDSA_P384_ALGORITHM -> BCRYPT_ECDSA_P384_ALG_HANDLE.
						BCRYPT_ECDSA_P521_ALGORITHM -> BCRYPT_ECDSA_P521_ALG_HANDLE.
						BCRYPT_RSA_SIGN_ALGORITHM -> BCRYPT_RSA_SIGN_ALG_HANDLE.
						BCRYPT_CAPI_KDF_ALGORITHM -> BCRYPT_CAPI_KDF_ALG_HANDLE.
						BCRYPT_PBKDF2_ALGORITHM -> BCRYPT_PBKDF2_ALG_HANDLE.
						BCRYPT_SP800108_CTR_HMAC_ALGORITHM -> BCRYPT_SP800108_CTR_HMAC_ALG_HANDLE.
						BCRYPT_SP80056A_CONCAT_ALGORITHM -> BCRYPT_SP80056A_CONCAT_ALG_HANDLE.
						BCRYPT_TLS1_1_KDF_ALGORITHM -> BCRYPT_TLS1_1_KDF_ALG_HANDLE.
						BCRYPT_TLS1_2_KDF_ALGORITHM -> BCRYPT_TLS1_2_KDF_ALG_HANDLE.
						BCRYPT_XTS_AES_ALGORITHM -> BCRYPT_XTS_AES_ALG_HANDLE.
						BCRYPT_HKDF_ALGORITHM -> BCRYPT_HKDF_ALG_HANDLE.
						BCRYPT_CHACHA20_POLY1305_ALGORITHM -> BCRYPT_CHACHA20_POLY1305_ALG_HANDLE.
						BCRYPT_SHA3_256_ALGORITHM -> BCRYPT_SHA3_256_ALG_HANDLE.
						BCRYPT_SHA3_384_ALGORITHM -> BCRYPT_SHA3_384_ALG_HANDLE.
						BCRYPT_SHA3_512_ALGORITHM -> BCRYPT_SHA3_512_ALG_HANDLE.
						BCRYPT_CSHAKE128_ALGORITHM -> BCRYPT_CSHAKE128_ALG_HANDLE.
						BCRYPT_CSHAKE256_ALGORITHM -> BCRYPT_CSHAKE256_ALG_HANDLE.
						BCRYPT_KMAC128_ALGORITHM -> BCRYPT_KMAC128_ALG_HANDLE.
						BCRYPT_KMAC256_ALGORITHM -> BCRYPT_KMAC256_ALG_HANDLE
					})!

sharedVariableName
	^#{BCrypt}! !

!OS.BCryptLibrary class categoriesForMethods!
fileName!**auto generated**!constants!public! !
initialize!class initialization!public! !
sharedVariableName!constants!private! !
!

