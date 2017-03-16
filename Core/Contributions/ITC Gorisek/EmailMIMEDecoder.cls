"Filed out from Dolphin Smalltalk 7"!

Object subclass: #EmailMIMEDecoder
	instanceVariableNames: 'encodeType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailMIMEDecoder guid: (GUID fromString: '{13899656-351b-4a5d-8c7a-a1ff98ad12a1}')!
EmailMIMEDecoder comment: ''!
!EmailMIMEDecoder categoriesForClass!Unclassified! !
!EmailMIMEDecoder methodsFor!

decodeFrom: aString 
	self subclassResponsibility! !
!EmailMIMEDecoder categoriesFor: #decodeFrom:!public! !

!EmailMIMEDecoder class methodsFor!

decodeFrom: aString

	^self new decodeFrom: aString!

decodeFrom: aString withEncoding: anEncodingType 
	(anEncodingType equals: 'base64') ifTrue: [^EmailBase64Decoder decodeFrom: aString].
	(anEncodingType equals: 'quoted-printable') 
		ifTrue: [^EmailQuotedPrintableDecoder decodeFrom: aString].
	^aString! !
!EmailMIMEDecoder class categoriesFor: #decodeFrom:!public! !
!EmailMIMEDecoder class categoriesFor: #decodeFrom:withEncoding:!public! !

