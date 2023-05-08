"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTestResource
	subclass: #'Core.Tests.DolphinTestClassResource'
	instanceVariableNames: 'package'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DolphinTestClassResource guid: (Core.GUID fromString: '{e358c277-08b0-4ffe-9f5a-c41be358f898}')!
Core.Tests.DolphinTestClassResource isNonInstantiable: true!
Core.Tests.DolphinTestClassResource comment: ''!
!Core.Tests.DolphinTestClassResource methodsFor!

compileAccessorsFor: aClass
	aClass instanceVariableNames do: 
			[:each |
			aClass compiledMethodAt: each asSymbol ifAbsent: [aClass compile: each , ' ^' , each].
			aClass compiledMethodAt: (each , ':') asSymbol
				ifAbsent: [aClass compile: each , ': x ' , each , ' := x']]!

compileMethods
	"To be implemented by subclasses as required"!

createClass: className superclass: superClass instVars: instanceVariables imports: anArray classVars: classVariablesString classConsts: constsArray
	| subclass |
	subclass := (superClass
				newClassBuilder: className
				instanceVariableNames: instanceVariables
				classVariableNames: classVariablesString
				imports: anArray)
				classConstants: constsArray;
				beQuiet;
				modifyOrCreate.
	package addClass: subclass.
	^subclass!

createClasses
	^self subclassResponsibility!

createClassesAndMethods
	self createClasses.
	self compileMethods!

createPackage
	package := self createPackage: self packageName!

createPool: aSymbol
	| pool |
	pool := SharedPool subclass: aSymbol.
	pool owningPackage: package.
	^pool!

createPools
	"Private - Not required by default"

	!

destroyPackage
	package
		ifNil: [(Package manager packageNamed: self class name ifNone: nil) ifNotNil: [:p | p uninstall]]
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
	self createClassesAndMethods!

tearDown
	super tearDown.
	self destroyPackage! !
!Core.Tests.DolphinTestClassResource categoriesForMethods!
compileAccessorsFor:!Init / Release!private! !
compileMethods!accessing!public! !
createClass:superclass:instVars:imports:classVars:classConsts:!Init / Release!private! !
createClasses!Init / Release!private! !
createClassesAndMethods!Init / Release!public! !
createPackage!Init / Release!private! !
createPool:!Init / Release!private! !
createPools!Init / Release!private! !
destroyPackage!Init / Release!private! !
package!public! !
packageName!private!unit tests! !
setUp!Init / Release!public! !
tearDown!public!Running! !
!

