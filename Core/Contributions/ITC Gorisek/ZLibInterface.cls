"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ZLibInterface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ZLibInterface guid: (GUID fromString: '{00000000-0000-0000-0000-000000000000}')!
ZLibInterface comment: ''!
!ZLibInterface categoriesForClass!Unclassified! !
!ZLibInterface class methodsFor!

compress: inData len: inLen out: outData len: outLen level: level

	^ZLibLibrary default compress2: outData outLen: outLen inData: inData inLen: inLen level: level!

compressForWeb: aStringOrByteArray 
	| outLen outData inLen |
	inLen := aStringOrByteArray size.
	outLen := ByteArray new: 4.
	outLen dwordAtOffset: 0 put: inLen + 20.
	outData := aStringOrByteArray class new: inLen + 20.
	^(self 
		compress: aStringOrByteArray
		len: inLen
		out: outData
		len: outLen
		level: -1) = 0 
		ifTrue: [outData copyFrom: 1 to: (outLen dwordAtOffset: 0)]!

decompress: inData
	| outData inLen result outLen |
	inLen := inData size.
	outLen := ByteArray new: 4.
	outData := inData class new: inLen * 4.
	
	[outLen dwordAtOffset: 0 put: outData size.
	result := self 
				uncompressData: inData
				inlen: inLen
				outdata: outData
				outlen: outLen.
	result = 0] 
			whileFalse: 
				[result = 16rFFFFFFFB ifFalse: [self error: 'Error ', result printString, ' decompressing data'].
				outData size > 16777216 ifTrue: [self error: 'Decompressed size too big'].
				outData := outData class new: outData size + (outData size min: 4194304)].
	^outData copyFrom: 1 to: (outLen dwordAtOffset: 0)!

decompress: inData resultCollectionClass: resultCollectionClass 
	| outData inLen result outLen |
	inLen := inData size.
	outLen := ByteArray new: 4.
	outData := resultCollectionClass new: inLen * 4.
	
	[outLen dwordAtOffset: 0 put: outData size.
	result := self 
				uncompressData: inData
				inlen: inLen
				outdata: outData
				outlen: outLen.
	result = 0] 
			whileFalse: 
				[result = 16rFFFFFFFB 
					ifFalse: [self error: 'Error ' , result printString , ' decompressing data'].
				outData size > 16777216 ifTrue: [self error: 'Decompressed size too big'].
				outData := outData class new: outData size + (outData size min: 4194304)].
	^outData copyFrom: 1 to: (outLen dwordAtOffset: 0)!

gzipHeader

	^#[ 31 139 8 0 0 0 0 0 0 0 ]!

uncompressData: inData inlen: inLen outdata: outData outlen: outLen

	^ZLibLibrary default uncompress: outData outLen: outLen inData: inData inLen: inLen!

Z_best_compression

	^9!

Z_best_speed

	^1!

Z_default_compression

	^-1!

Z_no_compression

	^0! !
!ZLibInterface class categoriesFor: #compress:len:out:len:level:!private! !
!ZLibInterface class categoriesFor: #compressForWeb:!public! !
!ZLibInterface class categoriesFor: #decompress:!public! !
!ZLibInterface class categoriesFor: #decompress:resultCollectionClass:!public! !
!ZLibInterface class categoriesFor: #gzipHeader!public! !
!ZLibInterface class categoriesFor: #uncompressData:inlen:outdata:outlen:!private! !
!ZLibInterface class categoriesFor: #Z_best_compression!public! !
!ZLibInterface class categoriesFor: #Z_best_speed!public! !
!ZLibInterface class categoriesFor: #Z_default_compression!public! !
!ZLibInterface class categoriesFor: #Z_no_compression!public! !

