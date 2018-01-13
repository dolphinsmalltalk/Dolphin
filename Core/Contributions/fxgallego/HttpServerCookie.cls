"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerCookie
	instanceVariableNames: 'name value domain path expires maxAge secure httpOnly'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerCookie guid: (GUID fromString: '{eeb1f591-82ef-4f5f-920b-8f3fca6a1d76}')!
HttpServerCookie comment: 'This cookie object conforms to the RFC 6265, section 4.1: Set-Cookie "HTTP State Management Mechanism".
The specification has PROPOSED STANDARD status (JAN-2018)'!
!HttpServerCookie categoriesForClass!Unclassified! !
!HttpServerCookie methodsFor!

asString
	^self printString!

domain
	^domain!

domain: anObject
	domain := anObject!

expires
	^expires!

expires: anObject
	expires := anObject!

expiresLocalTime: aTimeStamp
	"TimeStamp doesn't handles TZ info and the receiver uses GMT
	so this helps correctly set the expire data."

	| bias |
	"GMT = local time + bias. bias are minutes"
	bias := Locale default timeZoneInformation last bias * 60.
	self expires: (TimeStamp fromSeconds: aTimeStamp asSeconds + bias)!

httpOnly
	^httpOnly!

httpOnly: anObject
	httpOnly := anObject!

initialize
	super initialize.
	httpOnly := secure := false
	!

maxAge
	^maxAge!

maxAge: anObject
	maxAge := anObject!

name
	^name!

name: anObject
	name := anObject!

path
	^path!

path: anObject
	path := anObject!

printOn: target
	target
		nextPutAll: self name;
		nextPut: $=;
		nextPutAll: self value.
	self expires
		ifNotNil: 
			[target nextPutAll: '; Expires='.
			self printRFC1123: self expires asTimeStamp on: target].
	self maxAge
		ifNotNil: 
			[target
				nextPutAll: '; Max-Age=';
				nextPutAll: self maxAge displayString].
	self domain
		ifNotNil: 
			[target
				nextPutAll: '; Domain=';
				nextPutAll: self domain displayString].
	self path
		ifNotNil: 
			[target
				nextPutAll: '; Path=';
				nextPutAll: self path displayString].
	self secure ifTrue: [target nextPutAll: '; Secure'].
	self httpOnly ifTrue: [target nextPutAll: '; HttpOnly']!

printRFC1123: aTimeStamp on: aStream
	| lcEnglishUS |
	lcEnglishUS := Locale lcid: 1033.
	aStream
		nextPutAll: (lcEnglishUS nameOfDay: aTimeStamp date weekdayIndex abbrev: true);
		nextPutAll: ', '.
	aTimeStamp date
		printOn: aStream
		locale: lcEnglishUS
		format: 'dd MMM yyyy'.
	aStream space.
	aTimeStamp time printOn: aStream format: 'HH:mm:ss'.
	aStream nextPutAll: ' GMT'!

secure
	^secure!

secure: anObject
	secure := anObject!

value
	^value!

value: anObject
	value := anObject! !
!HttpServerCookie categoriesFor: #asString!public! !
!HttpServerCookie categoriesFor: #domain!accessing!public! !
!HttpServerCookie categoriesFor: #domain:!accessing!public! !
!HttpServerCookie categoriesFor: #expires!accessing!public! !
!HttpServerCookie categoriesFor: #expires:!accessing!public! !
!HttpServerCookie categoriesFor: #expiresLocalTime:!public! !
!HttpServerCookie categoriesFor: #httpOnly!accessing!public! !
!HttpServerCookie categoriesFor: #httpOnly:!accessing!public! !
!HttpServerCookie categoriesFor: #initialize!private! !
!HttpServerCookie categoriesFor: #maxAge!accessing!public! !
!HttpServerCookie categoriesFor: #maxAge:!accessing!public! !
!HttpServerCookie categoriesFor: #name!accessing!public! !
!HttpServerCookie categoriesFor: #name:!accessing!public! !
!HttpServerCookie categoriesFor: #path!accessing!public! !
!HttpServerCookie categoriesFor: #path:!accessing!public! !
!HttpServerCookie categoriesFor: #printOn:!accessing!public! !
!HttpServerCookie categoriesFor: #printRFC1123:on:!accessing!private! !
!HttpServerCookie categoriesFor: #secure!accessing!public! !
!HttpServerCookie categoriesFor: #secure:!accessing!public! !
!HttpServerCookie categoriesFor: #value!accessing!public! !
!HttpServerCookie categoriesFor: #value:!accessing!public! !

!HttpServerCookie class methodsFor!

name: nameString value: valueString
	^self basicNew initialize
		name: nameString;
		value: valueString;
		yourself!

new
	self shouldNotImplement! !
!HttpServerCookie class categoriesFor: #name:value:!public! !
!HttpServerCookie class categoriesFor: #new!private! !

