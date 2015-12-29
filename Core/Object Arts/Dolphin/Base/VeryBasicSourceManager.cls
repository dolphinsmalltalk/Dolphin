"Filed out from Dolphin Smalltalk X6"!

SourceManager subclass: #VeryBasicSourceManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
VeryBasicSourceManager guid: (GUID fromString: '{87B4C6E3-026E-11D3-9FD7-00A0CC3E4A32}')!
VeryBasicSourceManager comment: 'VeryBasicSourceManager provides the simplest possible external source code control aid for single developer systems. Files that are seen to be checked in are mde write protected; checked out files are write enabled.'!
!VeryBasicSourceManager categoriesForClass!Development! !
!VeryBasicSourceManager methodsFor!

checkIn: aStringFilename withComment: aStringComment
	"Check in aStringFilename using the receiver to set the file mode
	to read only. Signals an error if unsuccessful"

	(File isWriteable: aStringFilename set: false) ifFalse: [self error: 'check in failed' ].
!

checkOut: aStringFilename
	"Check out aStringFilename using the receiver to set the file mode
	to writeable. Signals an error if unsuccessful"

	(File isWriteable: aStringFilename set: true) ifFalse: [self error: 'check out failed' ].
!

get: aStringFilename
	"Get the latest version of aStringFilename from the receiver. 
	Since this is the file currently on disk do nothing"

! !
!VeryBasicSourceManager categoriesFor: #checkIn:withComment:!public!source code control! !
!VeryBasicSourceManager categoriesFor: #checkOut:!public!source code control! !
!VeryBasicSourceManager categoriesFor: #get:!public!source code control! !

!VeryBasicSourceManager class methodsFor!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DefaultInstance class == self ifTrue: [self reset]! !
!VeryBasicSourceManager class categoriesFor: #uninitialize!class hierarchy!class hierarchy-removing!private! !

