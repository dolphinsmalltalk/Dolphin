"Filed out from Dolphin Smalltalk 7"!

Security.ProtectedProductSerialNumber subclass: #'Security.Examples.MyCompanySerialNumber'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Security.Examples.MyCompanySerialNumber guid: (Core.GUID fromString: '{c1ed7586-afe1-4ee9-997a-01c157674e7d}')!
Security.Examples.MyCompanySerialNumber comment: 'This class is a serial number factory for products of "MyCompany". Any <ProtectedProductSessionManager> that wishes to make use of these serial numbers should override it''s #serialNumberClass to answer this class. New serial numbers can be generated for MyCompany''s products by evaluating:

MyCompanySerialNumber new displayString "Display it"'!
!Security.Examples.MyCompanySerialNumber categoriesForClass!Unclassified! !
!Security.Examples.MyCompanySerialNumber class methodsFor!

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
!Security.Examples.MyCompanySerialNumber class categoriesFor: #instanceDecodingKey!constants!private! !
!Security.Examples.MyCompanySerialNumber class categoriesFor: #lockedMethodDecodingKey!constants!private! !
!Security.Examples.MyCompanySerialNumber class categoriesFor: #lockedMethodDecodingKeyHash!constants!private! !

