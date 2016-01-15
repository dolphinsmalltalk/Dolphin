"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ZLibTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ZLibTest guid: (GUID fromString: '{8878EA0A-69D4-4931-99A8-82FB02846105}')!
ZLibTest comment: ''!
!ZLibTest categoriesForClass!Unclassified! !
!ZLibTest methodsFor!

testCompressUncompress
	| string compressed compressedLen uncompressed uncompressedLen |
	string := Object comment.
	compressed := ByteArray new: string size.
	compressedLen := DWORD fromInteger: compressed size.
	ZLibLibrary default 
		compress2: compressed
		outLen: compressedLen
		inData: string
		inLen: string size
		level: 9.
	uncompressed := String new: string size.
	uncompressedLen := DWORD fromInteger: uncompressed size.
	ZLibLibrary default 
		uncompress: uncompressed
		outLen: uncompressedLen
		inData: compressed
		inLen: compressed size.
	self assert: uncompressed = string! !
!ZLibTest categoriesFor: #testCompressUncompress!public!unit tests! !

