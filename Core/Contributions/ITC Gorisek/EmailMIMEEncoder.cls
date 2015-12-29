"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #EmailMIMEEncoder
	instanceVariableNames: 'encodeType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailMIMEEncoder guid: (GUID fromString: '{A1A06F24-2729-467D-AE0C-006C274A1C19}')!
EmailMIMEEncoder comment: ''!
!EmailMIMEEncoder categoriesForClass!Unclassified! !
!EmailMIMEEncoder methodsFor!

encodeFrom: aString

	self subclassResponsibility! !
!EmailMIMEEncoder categoriesFor: #encodeFrom:!public! !

!EmailMIMEEncoder class methodsFor!

encodeFrom: aString

	^self new encodeFrom: aString!

encodeFrom: aString withEncoding: anEncodingType 
	(anEncodingType equals: 'base64') ifTrue: [^EmailBase64Encoder encodeFrom: aString].
	^aString! !
!EmailMIMEEncoder class categoriesFor: #encodeFrom:!public! !
!EmailMIMEEncoder class categoriesFor: #encodeFrom:withEncoding:!public! !

