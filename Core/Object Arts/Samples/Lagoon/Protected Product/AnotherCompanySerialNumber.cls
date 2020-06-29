"Filed out from Dolphin Smalltalk 7"!

ProtectedProductSerialNumber subclass: #AnotherCompanySerialNumber
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AnotherCompanySerialNumber guid: (GUID fromString: '{3f32f382-d7d3-4b5c-b2ba-bfd3621d28c9}')!
AnotherCompanySerialNumber comment: 'This class is an example of overriding the default encryption used for protecting the unlock key.  In this case we override the class side method #serialNumberProtectorClass to select a different en/decryption algorithm.  Also, although we override the class side #instanceDecodingKey and #instanceEncodingKey methods, we do not answer a simple Integer as we would if we used default encryption, but instead answer a private/public key pair.  See the method comment for #instanceEncodingKey for more information and some guidance.'!
!AnotherCompanySerialNumber categoriesForClass!Unclassified! !
!AnotherCompanySerialNumber class methodsFor!

instanceDecodingKey
	"Private - Answer the key for decrypting instances from 'public'encrypted  serial number strings.
	See the comment on #instanceEncodingKey"

	^#(883344629932276261835226230258028672857560563998095606889833098489179383509120923743587746414072149871189772399804317572540726010114997608512037505823299065675229568162285260108149265519201004612020406788883438069318241977095660919 1395050678300788375767316771414556503921646178781 188329864692747944704857310024277209285839106444981888671993119484323746226249692054626603366991075936225124309201768423662063412675250352346789488740417887613824672185442638571044872218858252739539518876740794668525000108233192755 830489186575612513519754329803884892991392227198)!

instanceEncodingKey
	"Private - Answer the key for encrypting instances before converting them into
	'public' serial number strings.

	Since we want to use public/private qrypto we override #serialNumberProtectorClass to ask for
	public/private protection, and then naturally we have to overide this method to answer the private
	key and #instanceDecodingKey to answer the public one.

	To create a key pair, do the following:

	keys := DigitalSignatureAlgorithm generateFullKeySet.
	public := keys first.
	private := keys second.

	That will create a key-pair using the default PRNG, which isn't too secure, but it's
	better than nothing.  If you have a better source of good quality DSA key-paint then use it
	(But DON'T EVER use a pair that you use for anything else !!).

	Then override this methoid to answer the public key (it's an array of 4 LargeIntegers)
		TODO: make this more convenient
	and similarly override the decoding method to answer the private key.

	NOTE: this uses the Elgamal crypto built on top of DSA, which requires that it generate a new
	crypto-quality random number each time a key pair is used to encrypt a message.  Since that
	happens for each serial number we generate, that will obviously use up the available randomness
	very fast unless there is a lot of system activity in between generations."

	^#(883344629932276261835226230258028672857560563998095606889833098489179383509120923743587746414072149871189772399804317572540726010114997608512037505823299065675229568162285260108149265519201004612020406788883438069318241977095660919 1395050678300788375767316771414556503921646178781 188329864692747944704857310024277209285839106444981888671993119484323746226249692054626603366991075936225124309201768423662063412675250352346789488740417887613824672185442638571044872218858252739539518876740794668525000108233192755 514028039065538566559633444433003587396759207965376157218818730911413181343777037482455214857221718366184850393907616309355743886407920979554998035277211777870149282543333228936879626914626484755939740899574375167836434333843506147)!

lockedMethodDecodingKey
	"See the superclass comment.

		LargeInteger fromBytes: (PC1Cipher withStrength: 56) key.

	THIS METHOD SHOULD BE REMOVED BEFORE DEPLOYMENT"

	^71274657141378478!

lockedMethodDecodingKeyHash
	"See the superclass comment.

		SecureHashAlgorithm new hashInteger: self lockedMethodDecodingKey.
	"

	^650551781743887850780994095257281210535314485441!

serialNumberProtectorClass
	"overriden to request asymetric"

	^ElgamalSerialNumberProtector! !
!AnotherCompanySerialNumber class categoriesFor: #instanceDecodingKey!constants!private! !
!AnotherCompanySerialNumber class categoriesFor: #instanceEncodingKey!constants!private! !
!AnotherCompanySerialNumber class categoriesFor: #lockedMethodDecodingKey!constants!private! !
!AnotherCompanySerialNumber class categoriesFor: #lockedMethodDecodingKeyHash!constants!private! !
!AnotherCompanySerialNumber class categoriesFor: #serialNumberProtectorClass!constants!public! !

