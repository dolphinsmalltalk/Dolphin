"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocNewsletterUser
	instanceVariableNames: 'email ime ip prijavaTS status kategorije'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocNewsletterUser guid: (GUID fromString: '{BAA9C626-B0F9-409B-9276-475A2FDBE379}')!
WikiDocNewsletterUser comment: ''!
!WikiDocNewsletterUser categoriesForClass!Unclassified! !
!WikiDocNewsletterUser methodsFor!

addKategorija: aSymbol 
	(self kategorije includes: aSymbol) ifFalse: [self kategorije add: aSymbol]!

email
	^email!

email: emailAddress 
	email := emailAddress!

ime
	^ime!

ime: aString 
	ime := aString!

ip
	^ip!

ip: ipAddress 
	ip := ipAddress!

kategorije
	kategorije isNil ifTrue: [kategorije := Set new].
	^kategorije!

odstraniKategorijo: aSymbol 
	(self kategorije includes: aSymbol) ifTrue: [self kategorije remove: aSymbol]!

prijavaTS
	^prijavaTS!

prijavaTS: timeStamp 
	prijavaTS := timeStamp!

prijavljenNaKategorijo: aSymbol 
	^kategorije isNil ifTrue: [false] ifFalse: [kategorije includes: aSymbol]!

status
	^status!

status: anInteger 
	status := anInteger! !
!WikiDocNewsletterUser categoriesFor: #addKategorija:!public! !
!WikiDocNewsletterUser categoriesFor: #email!public! !
!WikiDocNewsletterUser categoriesFor: #email:!public! !
!WikiDocNewsletterUser categoriesFor: #ime!public! !
!WikiDocNewsletterUser categoriesFor: #ime:!public! !
!WikiDocNewsletterUser categoriesFor: #ip!public! !
!WikiDocNewsletterUser categoriesFor: #ip:!public! !
!WikiDocNewsletterUser categoriesFor: #kategorije!public! !
!WikiDocNewsletterUser categoriesFor: #odstraniKategorijo:!public! !
!WikiDocNewsletterUser categoriesFor: #prijavaTS!public! !
!WikiDocNewsletterUser categoriesFor: #prijavaTS:!public! !
!WikiDocNewsletterUser categoriesFor: #prijavljenNaKategorijo:!public! !
!WikiDocNewsletterUser categoriesFor: #status!public! !
!WikiDocNewsletterUser categoriesFor: #status:!public! !

