"Filed out from Dolphin Smalltalk 7"!

TestResource subclass: #TestTypelib
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
TestTypelib guid: (GUID fromString: '{BDA93D8C-DF4B-4461-8950-9DB6E8797384}')!
TestTypelib comment: ''!
!TestTypelib categoriesForClass!Unclassified! !
!TestTypelib methodsFor!

analyzer
	^analyzer!

isAvailable
	"override to provide information on the readiness of the resource"

	^analyzer notNil
!

libid
	^GUID fromString: '{39EA4CC5-6518-4C4B-BD48-0FC1B44A08C8}'!

setUp
	super setUp.
	analyzer := AXTypeLibraryAnalyzer 
				load: self libid
				major: 1
				minor: 0
				locale: LOCALE_USER_DEFAULT!

tearDown
	analyzer notNil 
		ifTrue: 
			[analyzer package uninstall.
			analyzer free.
			analyzer := nil].
	super tearDown! !
!TestTypelib categoriesFor: #analyzer!private!unit tests! !
!TestTypelib categoriesFor: #isAvailable!public!Testing! !
!TestTypelib categoriesFor: #libid!Init / Release!public! !
!TestTypelib categoriesFor: #setUp!Init / Release!public! !
!TestTypelib categoriesFor: #tearDown!public!Running! !

