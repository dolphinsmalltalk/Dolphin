"Filed out from Dolphin Smalltalk 7"!

ProtectedProductSerialNumber subclass: #MyCompanySerialNumber
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MyCompanySerialNumber guid: (GUID fromString: '{c1ed7586-afe1-4ee9-997a-01c157674e7d}')!
MyCompanySerialNumber comment: 'This class is a serial number factory for products of "MyCompany". Any <ProtectedProductSessionManager> that wishes to make use of these serial numbers should override it''s #serialNumberClass to answer this class. New serial numbers can be generated for MyCompany''s products by evaluating:

MyCompanySerialNumber new displayString "Display it"'!
!MyCompanySerialNumber categoriesForClass!Unclassified! !
!MyCompanySerialNumber class methodsFor!

instanceDecodingKey
	"See the superclass comment.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.
	"

	^ 23374057917146004.!

lockedMethodDecodingKey
	"See the superclass comment.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.
	"

	^ 39618219785755552.

	!

lockedMethodDecodingKeyHash
	"See the superclass comment.

		SecureHashAlgorithm new hashInteger: self lockedMethodDecodingKey.
	"

	^ 1149340459812121771490846453905007528758311757049.
	! !
!MyCompanySerialNumber class categoriesFor: #instanceDecodingKey!constants!private! !
!MyCompanySerialNumber class categoriesFor: #lockedMethodDecodingKey!constants!private! !
!MyCompanySerialNumber class categoriesFor: #lockedMethodDecodingKeyHash!constants!private! !

