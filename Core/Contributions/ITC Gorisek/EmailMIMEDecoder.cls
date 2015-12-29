"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #EmailMIMEDecoder
	instanceVariableNames: 'encodeType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailMIMEDecoder guid: (GUID fromString: '{13899656-351B-4A5D-8C7A-A1FF98AD12A1}')!
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

