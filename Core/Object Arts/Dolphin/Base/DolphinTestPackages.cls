"Filed out from Dolphin Smalltalk 7"!

DolphinTestResource subclass: #DolphinTestPackages
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTestPackages guid: (GUID fromString: '{B3DE54CD-BDD2-4043-9A29-0B80A02ADCC1}')!
DolphinTestPackages comment: ''!
!DolphinTestPackages categoriesForClass!Unclassified! !
!DolphinTestPackages methodsFor!

a
	^a!

b
	^b!

c
	^c!

isAvailable
	"override to provide information on the readiness of the resource"

	^a notNil
!

isUnavailable
	"override to provide information on the readiness of the resource"

	^a isNil!

setUp
	super setUp.
	a :=self createPackage: 'Resources\Tests\PackageTests\A'.
	b :=self createPackage: 'Resources\Tests\PackageTests\X\B'.
	c :=self createPackage: 'Resources\Tests\PackageTests\X\C'.

!

tearDown
	a notNil 
		ifTrue: 
			[Package manager removePackage: a.
			a := nil].
	b notNil 
		ifTrue: 
			[Package manager removePackage: b.
			b := nil].
	c notNil 
		ifTrue: 
			[Package manager removePackage: c.
			c := nil].
	super tearDown! !
!DolphinTestPackages categoriesFor: #a!accessing!public! !
!DolphinTestPackages categoriesFor: #b!accessing!public! !
!DolphinTestPackages categoriesFor: #c!accessing!public! !
!DolphinTestPackages categoriesFor: #isAvailable!public!Testing! !
!DolphinTestPackages categoriesFor: #isUnavailable!public!Testing! !
!DolphinTestPackages categoriesFor: #setUp!Init / Release!public! !
!DolphinTestPackages categoriesFor: #tearDown!public!Running! !

