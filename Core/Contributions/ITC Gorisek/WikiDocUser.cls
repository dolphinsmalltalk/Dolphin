"Filed out from Dolphin Smalltalk X6.1"!

WikiDocObject subclass: #WikiDocUser
	instanceVariableNames: 'username fullName password eMail homepage roles inactive lastSession'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocUser guid: (GUID fromString: '{04A3AC98-C603-4C3E-AB98-BD5EECCF337E}')!
WikiDocUser comment: ''!
!WikiDocUser categoriesForClass!Unclassified! !
!WikiDocUser methodsFor!

addRole: aSymbol 
	(self roles includes: aSymbol) 
		ifFalse: 
			[self roles add: aSymbol.
			self markDirty]!

canDo: aSymbol 
	^roles isNil ifTrue: [false] ifFalse: [roles includes: aSymbol]!

eMail
	^eMail!

eMail: anObject
	eMail := anObject!

fullName
	^fullName!

fullName: anObject
	fullName := anObject!

homepage
	^homepage!

homepage: anObject
	homepage := anObject!

inactive
	^inactive!

inactive: anObject
	inactive := anObject!

lastSession
	^lastSession!

lastSession: anObject
	lastSession := anObject!

password
	^password!

password: anObject
	password := anObject!

removeRole: aSymbol 
	(self roles includes: aSymbol) 
		ifTrue: 
			[self roles remove: aSymbol.
			self markDirty]!

roles
	roles isNil 
		ifTrue: 
			[roles := Set new.
			self markDirty].
	^roles!

username
	^username!

username: anObject
	username := anObject!

usernameInfo
	^username add: fullName withDelimiter: ', '! !
!WikiDocUser categoriesFor: #addRole:!accessing!public! !
!WikiDocUser categoriesFor: #canDo:!accessing!public! !
!WikiDocUser categoriesFor: #eMail!accessing!private! !
!WikiDocUser categoriesFor: #eMail:!accessing!private! !
!WikiDocUser categoriesFor: #fullName!accessing!private! !
!WikiDocUser categoriesFor: #fullName:!accessing!private! !
!WikiDocUser categoriesFor: #homepage!accessing!private! !
!WikiDocUser categoriesFor: #homepage:!accessing!private! !
!WikiDocUser categoriesFor: #inactive!accessing!private! !
!WikiDocUser categoriesFor: #inactive:!accessing!private! !
!WikiDocUser categoriesFor: #lastSession!accessing!private! !
!WikiDocUser categoriesFor: #lastSession:!accessing!private! !
!WikiDocUser categoriesFor: #password!accessing!private! !
!WikiDocUser categoriesFor: #password:!accessing!private! !
!WikiDocUser categoriesFor: #removeRole:!accessing!public! !
!WikiDocUser categoriesFor: #roles!accessing!public! !
!WikiDocUser categoriesFor: #username!accessing!private! !
!WikiDocUser categoriesFor: #username:!accessing!private! !
!WikiDocUser categoriesFor: #usernameInfo!accessing!public! !

