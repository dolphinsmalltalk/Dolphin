"Filed out from Dolphin Smalltalk"!

DolphinTestResource subclass: #DolphinTestClassResource
	instanceVariableNames: 'package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinTestClassResource guid: (GUID fromString: '{e358c277-08b0-4ffe-9f5a-c41be358f898}')!

DolphinTestClassResource isAbstract: true!

DolphinTestClassResource comment: ''!

!DolphinTestClassResource categoriesForClass!Unclassified! !

!DolphinTestClassResource methodsFor!

compileAccessorsFor: aClass 
	aClass instVarNames do: 
			[:each | 
			aClass compile: each , ' ^' , each.
			aClass compile: each , ': x ' , each , ' := x']!

compileMethods
	"To be implemented by subclasses as required"!

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
	package
		ifNil: [(Package manager packageNamed: self class name ifNone: []) ifNotNil: [:p | p uninstall]]
		ifNotNil: [package uninstall].
	package := nil!

package
	^package!

packageName
	^'Core\Object Arts\Dolphin\Tests\' , self class name!

setUp
	super setUp.
	self createPackage.
	self createPools.
	self createClasses.
	self compileMethods!

tearDown
	super tearDown.
	self destroyPackage! !

!DolphinTestClassResource categoriesForMethods!
compileAccessorsFor:!Init / Release!private! !
compileMethods!accessing!public! !
createClass:superclass:instVars:pools:!Init / Release!private! !
createClasses!Init / Release!private! !
createPackage!Init / Release!private! !
createPool:!Init / Release!private! !
createPools!Init / Release!private! !
destroyPackage!Init / Release!private! !
package!public! !
packageName!private!unit tests! !
setUp!Init / Release!public! !
tearDown!public!Running! !
!

