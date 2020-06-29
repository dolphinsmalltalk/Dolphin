"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ProductProtector
	instanceVariableNames: 'key'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProductProtector guid: (GUID fromString: '{14be1a34-57d2-46ce-b645-a0756bf2fe54}')!
ProductProtector isAbstract: true!
ProductProtector comment: 'One of these handles the actual encryption/decryption for a (subclass of) ProtectedProductSessionManager.  The idea of factoring this code out is partly to make it easier to replace the encryptin strategy used by Protected Product but also, and perhaps more importantly, to make it easier for other SessionManager subclasses to use Protected Product without duplicating too much code.

Note that instances only look after the encryption/decryption of methods, they are not responsible for the encyption/validation used by ProtectedProductSerialNumbers (which have different cryptographic requirements), see SerialNumberProtector for that.'!
!ProductProtector categoriesForClass!Unclassified! !
!ProductProtector methodsFor!

decryptClasses: aCollection 
	"Decrypt the given classes using the key we have been configured to use."

	^self subclassResponsibility!

encryptClasses: aCollection 
	"Encrypt the given classes using the key we have been configured to use."

	^self subclassResponsibility!

key
	"Private -- answer the object (often a LargeInteger) that we use as our en/decryption key."

	^key!

key: aKeyObject 
	"Private -- set the object (often a LargeInteger) that we use as our en/decryption key."

	key := aKeyObject!

lockClasses: aCollectionOfClasses 
	"Lock the given classes using the key we have been configured to use."

	self encryptClasses: aCollectionOfClasses!

unlockClasses: aCollectionOfClasses 
	"Unlock the given classes using the key we have been configured to use."

	self decryptClasses: aCollectionOfClasses! !
!ProductProtector categoriesFor: #decryptClasses:!operations!public! !
!ProductProtector categoriesFor: #encryptClasses:!operations!public! !
!ProductProtector categoriesFor: #key!initializing!public! !
!ProductProtector categoriesFor: #key:!initializing!private! !
!ProductProtector categoriesFor: #lockClasses:!operations!public! !
!ProductProtector categoriesFor: #unlockClasses:!operations!public! !

ProductProtector methodProtocol: #ProductProtector attributes: #() selectors: #(#lockClasses: #unlockClasses:)!

!ProductProtector class methodsFor!

isSafeToEncryptWithProductProtection
	"Answer whether it is save to encrypt the receiver's methods as part of the
	the deployment of a Protected Product application."

	^false!

withKey: aKeyObject 
	"Answer a new instance that is configured to en/decrypt classers uses the given key
	(exactly what sort of object depends on the subclass, often it will be a LargeInteger)."

	^(self new)
		key: aKeyObject;
		yourself! !
!ProductProtector class categoriesFor: #isSafeToEncryptWithProductProtection!constants!public!testing! !
!ProductProtector class categoriesFor: #withKey:!instance creation!public! !

