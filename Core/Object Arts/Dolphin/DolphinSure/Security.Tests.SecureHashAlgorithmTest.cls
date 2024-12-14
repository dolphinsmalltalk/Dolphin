"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Security.Tests.SecureHashAlgorithmTest'
	instanceVariableNames: 'hash'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Security.Tests.SecureHashAlgorithmTest guid: (Core.GUID fromString: '{d984b5ab-adae-4262-97fa-504683e01cc6}')!

Security.Tests.SecureHashAlgorithmTest comment: 'This is the unit test for the class SecureHashAlgorithm. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!

!Security.Tests.SecureHashAlgorithmTest categoriesForClass!Tests-System-Digital Signatures! !

!Security.Tests.SecureHashAlgorithmTest methodsFor!

testEmpty
	"See https://www.di-mgt.com.au/sha_testvectors.html"

	hash := SecureHashAlgorithm new hashMessage: ''.
	self assert: hash equals: 16rDA39A3EE5E6B4B0D3255BFEF95601890AFD80709!

testExample1
	"This is the first example from the specification document (FIPS PUB 180-1). 24-bit input."

	hash := SecureHashAlgorithm new hashMessage: 'abc'.
	self assert: hash equals: 16rA9993E364706816ABA3E25717850C26C9CD0D89D!

testExample2
	"This is the second example from the specification document (FIPS PUB 180-1). 448 bit input"

	hash := SecureHashAlgorithm new
				hashMessage: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'.
	self assert: hash equals: 16r84983E441C3BD26EBAAE4AA1F95129E5E54670F1!

testExample3
	"This is the third example from the specification document (FIPS PUB 180-1). 
	This example may take several minutes."

	hash := SecureHashAlgorithm new hashMessage: (String new: 1000000 withAll: $a).
	self assert: hash equals: 16r34AA973CD4C4DAA4F61EEB2BDBAD27316534016F!

testExample896
	"896 bit example from https://www.di-mgt.com.au/sha_testvectors.html"

	hash := SecureHashAlgorithm new
				hashMessage: 'abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu'.
	self assert: hash equals: 16rA49B2446A02C645BF419F995B67091253A04A259! !

!Security.Tests.SecureHashAlgorithmTest categoriesForMethods!
testEmpty!public!testing / examples! !
testExample1!public!testing / examples! !
testExample2!public!testing / examples! !
testExample3!public!testing / examples! !
testExample896!public!testing / examples! !
!

