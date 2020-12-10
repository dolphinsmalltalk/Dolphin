"Filed out from Dolphin Smalltalk 7"!

DolphinTestResource subclass: #DolphinTestPackages
	instanceVariableNames: 'a b c'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
	{a. b. c} do: 
			[:each |
			each notNil
				ifTrue: 
					[{each packageFileName. each fileOutName}
						do: [:filename | (File exists: filename) ifTrue: [File delete: filename]].
					Package manager removePackage: each]].
	a := b := c := nil.
	super tearDown! !
!DolphinTestPackages categoriesFor: #a!accessing!public! !
!DolphinTestPackages categoriesFor: #b!accessing!public! !
!DolphinTestPackages categoriesFor: #c!accessing!public! !
!DolphinTestPackages categoriesFor: #isAvailable!public!Testing! !
!DolphinTestPackages categoriesFor: #isUnavailable!public!Testing! !
!DolphinTestPackages categoriesFor: #setUp!Init / Release!public! !
!DolphinTestPackages categoriesFor: #tearDown!public!Running! !

