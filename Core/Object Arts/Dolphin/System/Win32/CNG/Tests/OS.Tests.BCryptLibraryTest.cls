"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.BCryptLibraryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.BCryptLibrary})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.BCryptLibraryTest guid: (Core.GUID fromString: '{e37f9c86-9a68-49b1-b6b6-3ad14b1821c4}')!

OS.Tests.BCryptLibraryTest comment: ''!

!OS.Tests.BCryptLibraryTest methodsFor!

testAvailableHashAlgorithms
	self
		assert: ({
				BCRYPT_MD2_ALGORITHM.
				BCRYPT_MD4_ALGORITHM.
				BCRYPT_MD5_ALGORITHM.
				BCRYPT_SHA1_ALGORITHM.
				BCRYPT_SHA256_ALGORITHM.
				BCRYPT_SHA384_ALGORITHM.
				BCRYPT_SHA512_ALGORITHM
			} difference: BCrypt availableHashAlgorithms)
		equals: #()!

testGetProviderHandle
	self assert: (BCrypt getProviderHandle: BCRYPT_SHA1_ALGORITHM) equals: BCRYPT_SHA1_ALG_HANDLE!

testMd5Hash
	"So-called 'test suite' from RFC1321:

		   The MD5 test suite (driver option '-x') should print the following results:

		MD5 test suite:
		MD5 ('') = d41d8cd98f00b204e9800998ecf8427e
		MD5 ('a') = 0cc175b9c0f1b6a831c399e269772661
		MD5 ('abc') = 900150983cd24fb0d6963f7d28e17f72
		MD5 ('message digest') = f96b697d7cb7938d525a2f31aaf161d0
		MD5 ('abcdefghijklmnopqrstuvwxyz') = c3fcd3d76192e4007dfb496cca67e13b
		MD5 ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') = d174ab98d277d9f5a5611c2c9f419d9f
		MD5 ('12345678901234567890123456789012345678901234567890123456789012345678901234567890') = 57edf4a22be3c955ac49da2e2107b67a'
	"

	self assert: (BCrypt md5Hash: '') asHexString equals: 'd41d8cd98f00b204e9800998ecf8427e'.
	self assert: (BCrypt md5Hash: 'a') asHexString equals: '0cc175b9c0f1b6a831c399e269772661'.
	self assert: (BCrypt md5Hash: 'abc') asHexString equals: '900150983cd24fb0d6963f7d28e17f72'.
	self assert: (BCrypt md5Hash: 'message digest') asHexString
		equals: 'f96b697d7cb7938d525a2f31aaf161d0'.
	self assert: (BCrypt md5Hash: 'abcdefghijklmnopqrstuvwxyz') asHexString
		equals: 'c3fcd3d76192e4007dfb496cca67e13b'.
	self assert: (BCrypt md5Hash: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
				asHexString
		equals: 'd174ab98d277d9f5a5611c2c9f419d9f'.
	self
		assert: (BCrypt
				md5Hash: '12345678901234567890123456789012345678901234567890123456789012345678901234567890')
					asHexString
		equals: '57edf4a22be3c955ac49da2e2107b67a'.

	"Wikipedia examples"
	self assert: (BCrypt md5Hash: 'The quick brown fox jumps over the lazy dog') asHexString
		equals: '9e107d9d372bb6826bd81d3542a419d6'.
	self assert: (BCrypt md5Hash: 'The quick brown fox jumps over the lazy dog.') asHexString
		equals: 'e4d909c290d0fb1ca068ffaddf22cbd0'!

testMd5HashCollisionExample
	"MD5 should only be used for purposes where security is not a consideration."

	#(#(#('d131dd02c5e6eec4 693d9a0698aff95c 2fcab58712467eab 4004583eb8fb7f89
55ad340609f4b302 83e488832571415a 085125e8f7cdc99f d91dbdf280373c5b
d8823e3156348f5b ae6dacd436c919c6 dd53e2b487da03fd 02396306d248cda0
e99f33420f577ee8 ce54b67080a80d1e c69821bcb6a88393 96f9652b6ff72a70' 'd131dd02c5e6eec4 693d9a0698aff95c 2fcab50712467eab 4004583eb8fb7f89
55ad340609f4b302 83e4888325f1415a 085125e8f7cdc99f d91dbd7280373c5b
d8823e3156348f5b ae6dacd436c919c6 dd53e23487da03fd 02396306d248cda0
e99f33420f577ee8 ce54b67080280d1e c69821bcb6a88393 96f965ab6ff72a70') '79054025255fb1a26e4bc422aef54eb4') #(#('4d c9 68 ff 0e e3 5c 20 95 72 d4 77 7b 72 15 87
 d3 6f a7 b2 1b dc 56 b7 4a 3d c0 78 3e 7b 95 18
 af bf a2 00 a8 28 4b f3 6e 8e 4b 55 b3 5f 42 75
 93 d8 49 67 6d a0 d1 55 5d 83 60 fb 5f 07 fe a2' '4d c9 68 ff 0e e3 5c 20 95 72 d4 77 7b 72 15 87
 d3 6f a7 b2 1b dc 56 b7 4a 3d c0 78 3e 7b 95 18
 af bf a2 02 a8 28 4b f3 6e 8e 4b 55 b3 5f 42 75
 93 d8 49 67 6d a0 d1 d5 5d 83 60 fb 5f 07 fe a2') '008ee33a9d58b51cfeb425b0959121c9'))
		do: 
			[:eachCollision |
			eachCollision first do: 
					[:each |
					self assert: (BCrypt md5Hash: (ByteArray fromHexString: each)) asHexString
						equals: eachCollision last]]!

testProvidersOfAlgorithm
	self assert: ((BCrypt providersOfAlgorithm: BCRYPT_SHA256_ALGORITHM) includes: MS_PRIMITIVE_PROVIDER)!

testSha1Hash
	self assert: (BCrypt sha1Hash: '')
		equals: (ByteArray fromHexString: 'da39a3ee 5e6b4b0d 3255bfef 95601890 afd80709').
	self assert: (BCrypt sha1Hash: 'abc')
		equals: (ByteArray fromHexString: 'a9993e36 4706816a ba3e2571 7850c26c 9cd0d89d').
	self assert: (BCrypt sha1Hash: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')
		equals: (ByteArray fromHexString: '84983e44 1c3bd26e baae4aa1 f95129e5 e54670f1').
	self assert: (BCrypt
				sha1Hash: 'abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu')
		equals: (ByteArray fromHexString: 'a49b2446 a02c645b f419f995 b6709125 3a04a259').

	"Wikipedia examples"
	self assert: (BCrypt sha1Hash: 'The quick brown fox jumps over the lazy dog') asHexString
		equals: '2fd4e1c67a2d28fced849ee1bb76e7391b93eb12'.
	self assert: (BCrypt sha1Hash: 'The quick brown fox jumps over the lazy cog') asHexString
		equals: 'de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3'!

testSha256GenesisBlock
	| genesisBlockHeader |
	genesisBlockHeader := ByteArray
				fromHexString: '01000000 0000000000000000000000000000000000000000000000000000000000000000 3BA3EDFD7A7B12B27AC72C3E67768F617FC81BC3888A51323A9FB8AA4B1E5E4A 29AB5F49 FFFF001D 1DAC2B7C'.
	self assert: (BCrypt sha256Hash: (BCrypt sha256Hash: genesisBlockHeader)) reversed asHexString
		equals: '000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f'!

testSha256Hash
	self assert: (BCrypt sha256Hash: '')
		equals: (ByteArray
				fromHexString: 'e3b0c442 98fc1c14 9afbf4c8 996fb924 27ae41e4 649b934c a495991b 7852b855').
	self assert: (BCrypt sha256Hash: 'abc')
		equals: (ByteArray
				fromHexString: 'ba7816bf 8f01cfea 414140de 5dae2223 b00361a3 96177a9c b410ff61 f20015ad').
	self assert: (BCrypt sha256Hash: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')
		equals: (ByteArray
				fromHexString: '248d6a61 d20638b8 e5c02693 0c3e6039 a33ce459 64ff2167 f6ecedd4 19db06c1').
	self assert: (BCrypt
				sha256Hash: 'abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu')
		equals: (ByteArray
				fromHexString: 'cf5b16a7 78af8380 036ce59e 7b049237 0b249b11 e8f07a51 afac4503 7afee9d1')! !

!OS.Tests.BCryptLibraryTest categoriesForMethods!
testAvailableHashAlgorithms!public! !
testGetProviderHandle!public! !
testMd5Hash!public! !
testMd5HashCollisionExample!public! !
testProvidersOfAlgorithm!public! !
testSha1Hash!public! !
testSha256GenesisBlock!public! !
testSha256Hash!public! !
!

