"Filed out from Dolphin Smalltalk X6.2"!

ProtectedProductSerialNumber subclass: #DolphinSerialNumber
	instanceVariableNames: ''
	classVariableNames: 'CompromisedSerialNumbersTrusted UpgradeLevelsMap UpgradeLevelsNamesMap VariationMasksMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSerialNumber guid: (GUID fromString: '{D5924714-DFD8-4B93-93CA-35A0A4318528}')!
DolphinSerialNumber comment: 'Serial Numbers for installation

"New full serial numbers for 2 month expiry"
(DolphinSerialNumber for: DolphinValueEdition new expiry: 2) displayString.
(DolphinSerialNumber for: DolphinStandardEdition new expiry: 2) displayString.
(DolphinSerialNumber for: DolphinProfessional new expiry: 2) displayString.

"Upgrading different product sets with 2 month expiry"
combo2 := DolphinSerialNumber combo2Mask.
(DolphinSerialNumber for: DolphinProfessional new upgradeLevel: combo2 expiry: 2) displayString.

adk := DolphinSerialNumber adkMask.
(DolphinSerialNumber for: DolphinProfessional new upgradeLevel: adk expiry: 2) displayString.

adkSockets := adk | DolphinSerialNumber socketsMask.
(DolphinSerialNumber for: DolphinProfessional new upgradeLevel: adkSockets expiry: 2) displayString.

(DolphinSerialNumber for: DolphinProfessional new upgradeLevel: self baseMask expiry: 2) displayString.
'!
!DolphinSerialNumber categoriesForClass!Development! !
!DolphinSerialNumber methodsFor!

canUnlock: product
	"Answer true if the receiver is capable of unlocking <DolphinProduct> product."

	| snProduct |
	snProduct := self product.
	^snProduct majorVersion=product majorVersion
	
	!

expiry
	"Answer the expiry of the receiver in months (from 1st Oct 2000)."

	^self split at: 4!

expiryDate
	"Answer the expiry <Date> of the receiver"

	^self class expiryBase addMonths: self expiry!

flags
	"Answer the flags for the receiver (a byte value)."

	^self split at: 3!

imageLevel
	"Answer the image level of the receiver"

	^self split at: 2!

isCompromised
	"Answer true if the receiver is one of a number of  compromised serial numbers"

	^[self class compromisedSerialNumbersTrusted includes: self displayString] on: TrustedDataError
		do: [:x | true]!

isExpired
	"Answer true if the receiver has an expiry date and it is past"

	self expiry=0 ifTrue: [^false].
	^(self class expiryBase addMonths: self expiry) <= Date today

!

isValid
	"Answer true if the receiver is valid. We do this by comparing the SHA hash of the decodingKey
	with the value that we expect"

	^super isValid and: [self isCompromised not]!

isValidForUpgrade
	"Answer true if the receiver is valid for upgrading purposes. This means it must be a valid serial number and
	not be for a trial version with an predefined expiry date."

	^self isValid and: [self expiry=0]
!

lockedMethodDecodingKey
	"Answer the puported key that will be used (if it satisfied the validity check) for decoding
	the locked methods in a deployed application."

	^self split at: 5!

machineId
	"Answer the machine id of the receiver (if fixed licence)"

	^self productId!

product
	"Answer the DolphinProduct held by the receiver"

	^DolphinProduct ofSerialNumber: self

!

split
	"Private - Answer an Array representing a decoding of the receiver's elements
	1 Product id # <32-bit integer>
	2 Image level <16 bit integer>
	3 Flags <byte>
	4 Expiry months <byte>
	5 Locked method decodingKey (LargeInteger of indeterminate size)"

	| number split |
	number := self value.
	split := Array new: 5.

	"product id"
	split at: 1 put: number & 16rFFFFFFFF.
	number := number >> 32.

	"image level"
	split at: 2 put: number & 16rFFFF.
	number := number >> 16.

	"flags"
	split at: 3 put: number & 16rFF.
	number := number >> 8.

	"expiry"
	split at: 4 put: number & 16rFF.
	number := number >> 8.

	"and whatever's left over is the unlock key"
	split at: 5 put: number.
	^split! !
!DolphinSerialNumber categoriesFor: #canUnlock:!public!testing! !
!DolphinSerialNumber categoriesFor: #expiry!accessing!public! !
!DolphinSerialNumber categoriesFor: #expiryDate!accessing!public! !
!DolphinSerialNumber categoriesFor: #flags!accessing!public! !
!DolphinSerialNumber categoriesFor: #imageLevel!accessing!public! !
!DolphinSerialNumber categoriesFor: #isCompromised!public!testing! !
!DolphinSerialNumber categoriesFor: #isExpired!public!testing! !
!DolphinSerialNumber categoriesFor: #isValid!public!testing! !
!DolphinSerialNumber categoriesFor: #isValidForUpgrade!public!testing! !
!DolphinSerialNumber categoriesFor: #lockedMethodDecodingKey!accessing!public! !
!DolphinSerialNumber categoriesFor: #machineId!accessing!public! !
!DolphinSerialNumber categoriesFor: #product!accessing!public! !
!DolphinSerialNumber categoriesFor: #split!accessing!private! !

!DolphinSerialNumber class methodsFor!

compromisedSerialNumbersTrusted
	"Private - Answers a collection of serial numbers that are known to have been compromised.
	Signals a TrustedDataError if the collection has been tampered with."

	"Implementation note: This is lazily evaluated to avoid unwanted dependencies at boot time"

	| certificateClass |
	certificateClass := Smalltalk at: #ObjectArtsInstallerCertificate.
	CompromisedSerialNumbersTrusted isNil 
		ifTrue: 
			[CompromisedSerialNumbersTrusted := DolphinSureTrustedData 
						data: self compromisedSerialNumbers binaryStoreBytes
						description: 'Compromised Dolphin Serial Numbers'
						publisherCertificate: certificateClass new
						privateKey: certificateClass privateKey].
	^Object fromBinaryStoreBytes: (CompromisedSerialNumbersTrusted 
				validDataPublishedBy: certificateClass new)!

decodingKeyHash
	"Private - Answer the hash of the PC1 image decoding key.

	SecureHashAlgorithm new hashInteger: self decodingKey.
	"

	^232361792179738766724787781767611761786626327069
	!

expiryBase
	"Answer the base date from which expiration is measured"

	^Date newDay: 1 monthIndex: 10 year: 2000!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

instanceDecodingKey
	"See the superclass comment.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.
	"

	^21737549975299221!

lockedMethodDecodingKey
	"See the superclass comment.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.
	"

	^26417302019812953!

lockedMethodDecodingKeyHash
	"See the superclass comment.

		SecureHashAlgorithm new hashInteger: self lockedMethodDecodingKey.
	"

	^765510056309340104864034808411215266605260909085!

new
	^self for: DolphinProfessional new!

productProtectorClass
	"Answer the class of <ProductProtectorr> to use for locking/unlocking encrypted classes."

	^Smalltalk at: #DolphinProductProtector!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	CompromisedSerialNumbersTrusted := nil!

upgradeNameFromMask: mask
	"Private - Answers a <readaableString> containing the product name identified by the <Integer> mask"

	^UpgradeLevelsNamesMap at: mask!

wdkHash
	"Private - Answer the SHA hash for the Dolphin WDK key.

	SecureHashAlgorithm new hashMessage: 'nnnnn'
"

	^799607890547955506895512107634358478975919016426! !
!DolphinSerialNumber class categoriesFor: #compromisedSerialNumbersTrusted!constants!private! !
!DolphinSerialNumber class categoriesFor: #decodingKeyHash!constants!private! !
!DolphinSerialNumber class categoriesFor: #expiryBase!constants!public! !
!DolphinSerialNumber class categoriesFor: #icon!constants!development!public! !
!DolphinSerialNumber class categoriesFor: #instanceDecodingKey!constants!private! !
!DolphinSerialNumber class categoriesFor: #lockedMethodDecodingKey!constants!private! !
!DolphinSerialNumber class categoriesFor: #lockedMethodDecodingKeyHash!constants!private! !
!DolphinSerialNumber class categoriesFor: #new!instance creation!public! !
!DolphinSerialNumber class categoriesFor: #productProtectorClass!constants!public! !
!DolphinSerialNumber class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!DolphinSerialNumber class categoriesFor: #upgradeNameFromMask:!constants!private! !
!DolphinSerialNumber class categoriesFor: #wdkHash!constants!private! !

