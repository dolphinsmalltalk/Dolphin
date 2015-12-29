"Filed out from Dolphin Smalltalk X6"!

ProtectedProductSerialNumber subclass: #MyCompanySerialNumber
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MyCompanySerialNumber guid: (GUID fromString: '{C1ED7586-AFE1-4EE9-997A-01C157674E7D}')!
MyCompanySerialNumber comment: 'This class is a serial number factory for products of "MyCompany". Any <ProtectedProductSessionManager> that wishes to make use of these serial numbers should override it''s #serialNumberClass to answer this class. New serial numbers can be generated for MyCompany''s products by evaluating:

MyCompanySerialNumber new displayString "Display it"'!
!MyCompanySerialNumber categoriesForClass!Unclassified! !
!MyCompanySerialNumber methodsFor!

encodingKey
	"Private - Answer the PC1 serial # decoding key. This must be unique for each different
	type of serial number (e.g. for each company). It can be generated using the expression 
	below and entered into the method. 

	(PC1Cipher withStrength: 56) key
"
	^#[2 28 204 79 147 114 14]! !
!MyCompanySerialNumber categoriesFor: #encodingKey!constants!private! !

!MyCompanySerialNumber class methodsFor!

decodingKey
	"Private - Answer the PC1 image decoding key. This must be unique for each different
	type of serial number (e.g. for each company). It can be generated using the expression 
	below and entered into the method. 

	(PC1Cipher withStrength: 56) key

	THIS METHOD SHOULD BE REMOVED BEFORE DEPLOYMENT"

	^LargeInteger fromBytes: #[183 117 179 218 231 236 103]

	!

decodingKeyHash
	"Private - Answer the hash of the PC1 image decoding key.

	SecureHashAlgorithm new hashInteger: self decodingKey.
	"

	^397045249279370258961311944610797942007747714795
	! !
!MyCompanySerialNumber class categoriesFor: #decodingKey!constants!private! !
!MyCompanySerialNumber class categoriesFor: #decodingKeyHash!constants!private! !

