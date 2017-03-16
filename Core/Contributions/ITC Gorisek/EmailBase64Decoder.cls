"Filed out from Dolphin Smalltalk 7"!

EmailMIMEDecoder subclass: #EmailBase64Decoder
	instanceVariableNames: 'codes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'singelton'!
EmailBase64Decoder guid: (GUID fromString: '{dfed11ea-3d6f-4f50-b050-9d34a2a63ee9}')!
EmailBase64Decoder comment: ''!
!EmailBase64Decoder categoriesForClass!Unclassified! !
!EmailBase64Decoder methodsFor!

alphabet
	^'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=' asByteArray!

codes
	codes isNil ifFalse: [^codes].
	codes := ByteArray new: 256.
	1 to: 256 do: [:each | codes at: each put: 255].
	$A asInteger to: $Z asInteger do: [:each | codes at: each put: each - $A asInteger].
	$a asInteger to: $z asInteger do: [:each | codes at: each put: 26 + each - $a asInteger].
	$0 asInteger to: $9 asInteger do: [:each | codes at: each put: 52 + each - $0 asInteger].
	codes at: $+ asInteger put: 62.
	codes at: $/ asInteger put: 63.
	^codes!

decodeFrom: aCollection 
	| arraySize newLength outArray shift accum index aByteArray |
	aByteArray := aCollection asByteArray.
	arraySize := aByteArray size.
	aByteArray 
		do: [:each | (self codes byteAt: each) = 255 ifTrue: [arraySize := arraySize - 1]].
	newLength := (arraySize / 4 * 3) truncated.
	newLength \\ 4 = 3 ifTrue: [newLength := newLength + 2].
	newLength \\ 4 = 2 ifTrue: [newLength := newLength + 1].
	outArray := ByteArray new: newLength.
	accum := 0.
	shift := 0.
	index := 1.
	aByteArray doWithIndex: 
			[:each :index1 | 
			| value |
			value := self codes at: each.
			value < 255 
				ifTrue: 
					[accum := (accum bitShift: 6) asInt16.
					shift := shift + 6.
					accum := accum | value.
					shift >= 8 
						ifTrue: 
							[shift := shift - 8.
							outArray at: index put: (accum bitShift: shift negated) & 255.
							index := index + 1]]].
	^outArray asString! !
!EmailBase64Decoder categoriesFor: #alphabet!public! !
!EmailBase64Decoder categoriesFor: #codes!public! !
!EmailBase64Decoder categoriesFor: #decodeFrom:!public! !

!EmailBase64Decoder class methodsFor!

decodeFrom: aString

	^self default decodeFrom: aString!

default

	singelton isNil ifTrue: [
		singelton := self new.
		singelton codes ].
	^singelton!

reset

	singelton := nil! !
!EmailBase64Decoder class categoriesFor: #decodeFrom:!public! !
!EmailBase64Decoder class categoriesFor: #default!public! !
!EmailBase64Decoder class categoriesFor: #reset!public! !

