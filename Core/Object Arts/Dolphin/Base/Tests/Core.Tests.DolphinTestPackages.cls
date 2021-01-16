"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestResource subclass: #'Core.Tests.DolphinTestPackages'
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DolphinTestPackages guid: (Core.GUID fromString: '{b3de54cd-bdd2-4043-9a29-0b80a02adcc1}')!
Core.Tests.DolphinTestPackages comment: ''!
!Core.Tests.DolphinTestPackages categoriesForClass!Unclassified! !
!Core.Tests.DolphinTestPackages methodsFor!

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
	{a. b. c} do: 
			[:each |
			each notNil
				ifTrue: 
					[{each packageFileName. each fileOutName}
						do: [:filename | (File exists: filename) ifTrue: [File delete: filename]].
					Package manager removePackage: each]].
	a := b := c := nil.
	super tearDown! !
!Core.Tests.DolphinTestPackages categoriesFor: #a!accessing!public! !
!Core.Tests.DolphinTestPackages categoriesFor: #b!accessing!public! !
!Core.Tests.DolphinTestPackages categoriesFor: #c!accessing!public! !
!Core.Tests.DolphinTestPackages categoriesFor: #isAvailable!public!Testing! !
!Core.Tests.DolphinTestPackages categoriesFor: #isUnavailable!public!Testing! !
!Core.Tests.DolphinTestPackages categoriesFor: #setUp!Init / Release!public! !
!Core.Tests.DolphinTestPackages categoriesFor: #tearDown!public!Running! !

