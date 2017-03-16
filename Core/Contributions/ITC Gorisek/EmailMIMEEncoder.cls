"Filed out from Dolphin Smalltalk 7"!

Object subclass: #EmailMIMEEncoder
	instanceVariableNames: 'encodeType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmailMIMEEncoder guid: (GUID fromString: '{a1a06f24-2729-467d-ae0c-006c274a1c19}')!
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

