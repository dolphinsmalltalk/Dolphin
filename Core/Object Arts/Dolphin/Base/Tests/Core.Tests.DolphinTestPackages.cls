"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTestResource
	subclass: #'Core.Tests.DolphinTestPackages'
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DolphinTestPackages guid: (Core.GUID fromString: '{b3de54cd-bdd2-4043-9a29-0b80a02adcc1}')!
Core.Tests.DolphinTestPackages comment: ''!
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
	| toRemove |
	toRemove := {a. b. c} select: [:each | each notNil].
	toRemove do: 
			[:each |
			{each packageFileName. each fileOutName}
				do: [:filename | (File exists: filename) ifTrue: [File delete: filename]]].
	Package manager removePackages: toRemove.
	a := b := c := nil.
	super tearDown! !
!Core.Tests.DolphinTestPackages categoriesForMethods!
a!accessing!public! !
b!accessing!public! !
c!accessing!public! !
isAvailable!public!Testing! !
isUnavailable!public!Testing! !
setUp!Init / Release!public! !
tearDown!public!Running! !
!

