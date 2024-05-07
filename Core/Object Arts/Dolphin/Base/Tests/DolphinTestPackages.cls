"Filed out from Dolphin Smalltalk"!

DolphinTestResource subclass: #DolphinTestPackages
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinTestPackages guid: (GUID fromString: '{b3de54cd-bdd2-4043-9a29-0b80a02adcc1}')!

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
	(Array
		with: a
		with: b
		with: c) do: 
				[:each |
				each notNil
					ifTrue: 
						[(Array with: each packageFileName with: each fileOutName)
							do: [:filename | (File exists: filename) ifTrue: [File delete: filename]].
						Package manager removePackage: each]].
	a := b := c := nil.
	super tearDown! !

!DolphinTestPackages categoriesForMethods!
a!accessing!public! !
b!accessing!public! !
c!accessing!public! !
isAvailable!public!Testing! !
isUnavailable!public!Testing! !
setUp!Init / Release!public! !
tearDown!public!Running! !
!

