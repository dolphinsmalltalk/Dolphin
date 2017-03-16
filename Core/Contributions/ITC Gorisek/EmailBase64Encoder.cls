"Filed out from Dolphin Smalltalk 7"!

EmailMIMEEncoder subclass: #EmailBase64Encoder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailBase64Encoder guid: (GUID fromString: '{dd7f8624-acb5-4450-a77d-4671de755dfe}')!
EmailBase64Encoder comment: ''!
!EmailBase64Encoder categoriesForClass!Unclassified! !
!EmailBase64Encoder methodsFor!

base64ToChar: anInteger 
	^'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' at: anInteger + 1!

encodeBase64: aStream maxLineLength: maxLineLength 
	| lineSize encoded c1 c2 c3 |
	lineSize := 0.
	encoded := WriteStream on: String new.
	aStream reset.
	[aStream atEnd] whileFalse: 
			[c1 := aStream next.
			aStream atEnd ifTrue: [c2 := nil] ifFalse: [c2 := aStream next].
			aStream atEnd ifTrue: [c3 := nil] ifFalse: [c3 := aStream next].
			encoded nextPutAll: (self 
						encodeTripletWith: c1
						with: c2
						with: c3).
			lineSize := lineSize + 4.
			(maxLineLength notNil and: [lineSize >= maxLineLength]) 
				ifTrue: 
					[encoded cr.
					lineSize := 0]].
	^encoded!

encodeFrom: aString 
	^(self encodeBase64: (ReadStream on: aString) maxLineLength: 76) contents!

encodeString: aString 
	^(self encodeBase64: (ReadStream on: aString) maxLineLength: nil) contents!

encodeTripletWith: t1 with: t2 with: t3 
	| inputAsInteger str i1 i2 i3 i4 |
	inputAsInteger := t1 asInteger << 16.
	inputAsInteger := ((t2 isNil ifTrue: [0] ifFalse: [t2 asInteger]) << 8) + inputAsInteger.
	inputAsInteger := (t3 isNil ifTrue: [0] ifFalse: [t3 asInteger]) + inputAsInteger.
	str := String new: 4.
	i1 := (inputAsInteger bitAnd: 2r111111000000000000000000) >> 18.
	i2 := (inputAsInteger bitAnd: 2r000000111111000000000000) >> 12.
	i3 := (inputAsInteger bitAnd: 2r000000000000111111000000) >> 6.
	i4 := inputAsInteger bitAnd: 2r000000000000000000111111.
	str at: 1 put: (self base64ToChar: i1).
	str at: 2 put: (self base64ToChar: i2).
	t2 isNil ifTrue: [str at: 3 put: $=] ifFalse: [str at: 3 put: (self base64ToChar: i3)].
	t3 isNil ifTrue: [str at: 4 put: $=] ifFalse: [str at: 4 put: (self base64ToChar: i4)].
	^str! !
!EmailBase64Encoder categoriesFor: #base64ToChar:!public! !
!EmailBase64Encoder categoriesFor: #encodeBase64:maxLineLength:!public! !
!EmailBase64Encoder categoriesFor: #encodeFrom:!public! !
!EmailBase64Encoder categoriesFor: #encodeString:!public! !
!EmailBase64Encoder categoriesFor: #encodeTripletWith:with:with:!public! !

!EmailBase64Encoder class methodsFor!

encodeFrom: aString 
	^self new encodeFrom: aString! !
!EmailBase64Encoder class categoriesFor: #encodeFrom:!public! !

