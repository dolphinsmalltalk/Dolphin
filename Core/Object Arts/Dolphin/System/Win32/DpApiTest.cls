"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DpApiTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DpApiTest guid: (GUID fromString: '{9165806D-C1A3-45E6-BF08-54EA3A21B04C}')!
DpApiTest comment: ''!
!DpApiTest categoriesForClass!Unclassified! !
!DpApiTest methodsFor!

testProtectUnprotectData
	#('' 'a' 'abc' #[] #[0] #[128 255 1]) do: [:each | self verifyRoundTrip: each]!

verifyRoundTrip: aByteObject
	| entropy decrypted encryptedExtra encrypted |
	entropy := #[1 2 3 4].
	encrypted := Crypt32Library protectData: aByteObject.
	encryptedExtra := Crypt32Library protectData: aByteObject additionalEntropy: entropy.
	decrypted := Crypt32Library unprotectData: encrypted.
	self assert: aByteObject equals: decrypted.
	"Unprotect with entropy not used on protect should fail."
	self
		should: [Crypt32Library unprotectData: encryptedExtra]
		raise: Win32Error
		matching: [:ex | ex tag statusCode = Win32Errors.ERROR_INVALID_DATA].
	decrypted := Crypt32Library unprotectData: encryptedExtra additionalEntropy: entropy.
	self assert: aByteObject equals: decrypted.
	"Unprotect without entropy used on protect should fail."
	self
		should: [Crypt32Library unprotectData: encryptedExtra]
		raise: Win32Error
		matching: [:ex | ex tag statusCode = Win32Errors.ERROR_INVALID_DATA].
	self
		should: [Crypt32Library unprotectData: encryptedExtra additionalEntropy: #[4 5 6]]
		raise: Win32Error
		matching: [:ex | ex tag statusCode = Win32Errors.ERROR_INVALID_DATA]! !
!DpApiTest categoriesFor: #testProtectUnprotectData!public!unit tests! !
!DpApiTest categoriesFor: #verifyRoundTrip:!helpers!private! !

