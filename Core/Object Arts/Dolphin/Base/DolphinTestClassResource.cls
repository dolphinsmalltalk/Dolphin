"Filed out from Dolphin Smalltalk 7"!

DolphinTestResource subclass: #DolphinTestClassResource
	instanceVariableNames: 'package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTestClassResource guid: (GUID fromString: '{E358C277-08B0-4FFE-9F5A-C41BE358F898}')!
DolphinTestClassResource comment: ''!
!DolphinTestClassResource categoriesForClass!Unclassified! !
!DolphinTestClassResource methodsFor!

compileAccessorsFor: aClass 
	aClass instVarNames do: 
			[:each | 
			aClass compile: each , ' ^' , each.
			aClass compile: each , ': x ' , each , ' := x']!

createClass: className superclass: superClass instVars: instanceVariables pools: aString
	| class |
	class := superClass
				subclass: className
				instanceVariableNames: instanceVariables
				classVariableNames: ''
				poolDictionaries: aString
				classInstanceVariableNames: ''.
	package addClass: class.
	^class!

createClasses
	^self subclassResponsibility!

createPackage
	package := self createPackage: self packageName!

createPool: aSymbol
	| pool |
	pool := Smalltalk at: aSymbol put: PoolConstantsDictionary new.
	pool owningPackage: package.
	^pool!

createPools
	"Private - Not required by default"

	!

destroyPackage
	package notNil 
		ifTrue: 
			[package uninstall.
			package := nil]!

packageName
	^'Core\Object Arts\Dolphin\Tests\' , self class name!

setUp
	super setUp.
	self createPackage.
	self createPools.
	self createClasses!

tearDown
	super tearDown.
	self destroyPackage! !
!DolphinTestClassResource categoriesFor: #compileAccessorsFor:!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createClass:superclass:instVars:pools:!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createClasses!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createPackage!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createPool:!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createPools!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #destroyPackage!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #packageName!private!unit tests! !
!DolphinTestClassResource categoriesFor: #setUp!Init / Release!public! !
!DolphinTestClassResource categoriesFor: #tearDown!public!Running! !

!DolphinTestClassResource class methodsFor!

isAbstract
	^self == ##(self)! !
!DolphinTestClassResource class categoriesFor: #isAbstract!public!Testing! !

