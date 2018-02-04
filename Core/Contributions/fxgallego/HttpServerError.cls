"Filed out from Dolphin Smalltalk 7"!

Error subclass: #HttpServerError
	instanceVariableNames: 'statusCode reason'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerError guid: (GUID fromString: '{455bf88b-cbba-451e-b8c1-8363d270b6c8}')!
HttpServerError comment: ''!
!HttpServerError categoriesForClass!Kernel-Exception Handling! !
!HttpServerError methodsFor!

html
	"Return a message formated in HTML"

	^self htmlTemplate formatWith: self statusCode displayString with: self reason with: self messageText!

htmlTemplate
	^'<h1>Dolphin Smalltalk HTTP Server Error</h1>',
	'<h2>%1 - %2</h2>',
	'<p>%3</p>'!

reason
	^reason!

reason: anObject
	reason := anObject!

statusCode
	^statusCode!

statusCode: anObject
	statusCode := anObject! !
!HttpServerError categoriesFor: #html!public! !
!HttpServerError categoriesFor: #htmlTemplate!private! !
!HttpServerError categoriesFor: #reason!accessing!private! !
!HttpServerError categoriesFor: #reason:!accessing!private! !
!HttpServerError categoriesFor: #statusCode!accessing!private! !
!HttpServerError categoriesFor: #statusCode:!accessing!private! !

!HttpServerError class methodsFor!

payloadTooLarge
	^self new
		statusCode: 413;
		reason: 'Payload too large';
		yourself! !
!HttpServerError class categoriesFor: #payloadTooLarge!public! !

