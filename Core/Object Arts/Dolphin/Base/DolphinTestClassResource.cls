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

createClass: className superclass: superClass instVars: instanceVariables 
	| class |
	class := superClass 
				subclass: className
				instanceVariableNames: instanceVariables
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	package addClass: class.
	^class!

createClasses
	^self subclassResponsibility!

createPackage
	package := self createPackage: self packageName!

destroyPackage
	package notNil 
		ifTrue: 
			[Package manager removePackage: package.
			package := nil]!

packageName
	^'Object Arts\Dolphin\Tests\' , self class name!

setUp
	super setUp.
	self createPackage.
	self createClasses!

tearDown
	super tearDown.
	self destroyPackage! !
!DolphinTestClassResource categoriesFor: #compileAccessorsFor:!Init / Release!public! !
!DolphinTestClassResource categoriesFor: #createClass:superclass:instVars:!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #createClasses!private!unit tests! !
!DolphinTestClassResource categoriesFor: #createPackage!Init / Release!private! !
!DolphinTestClassResource categoriesFor: #destroyPackage!private!Running! !
!DolphinTestClassResource categoriesFor: #packageName!private!unit tests! !
!DolphinTestClassResource categoriesFor: #setUp!Init / Release!public! !
!DolphinTestClassResource categoriesFor: #tearDown!public!Running! !

!DolphinTestClassResource class methodsFor!

isAbstract
	^self == ##(self)! !
!DolphinTestClassResource class categoriesFor: #isAbstract!public!Testing! !

