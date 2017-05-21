"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BinaryPackageTest
	instanceVariableNames: 'privateKey cert'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BinaryPackageTest guid: (GUID fromString: '{c4ad2c1a-1c62-49c7-abfe-083a2bd1ae1d}')!
BinaryPackageTest comment: ''!
!BinaryPackageTest categoriesForClass!Unclassified! !
!BinaryPackageTest methodsFor!

createCertificate
	| keys info details |
	keys := DolphinSureCertificate signatureAlgorithm 
				generateKeySetForGroup: DolphinSureCertificate keyGroup.
	info := DolphinSureCertificateInfo 
				serial: 'OATEST0001'
				owner: 'Object Arts Ltd'
				publicKey: keys second.
	info details: ''.
	privateKey := keys first.
	^DolphinSureCertificate info: info!

createClass: className superclass: superClass classVars: classVariables inPackage: package 
	| class |
	class := superClass 
				subclass: className
				instanceVariableNames: ''
				classVariableNames: classVariables
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	package addClass: class.
	^class!

createClass: className superclass: superClass instVars: instanceVariables inPackage: package 
	| class |
	class := superClass 
				subclass: className
				instanceVariableNames: instanceVariables
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	package addClass: class.
	^class!

createFactoryPiPackage
	"This package contains a base (factory) class that can answer an instance of itself (TestPi) with the message #fractionalPi
	and an instance of a subclass (TestPiFloat) with the message #floatingPi. The purpose of this is to test forward class references
	in BinaryPackage loading. Superclasses are normally loaded in their entirety before subclasses. In this case, however, the superclass
	methos dictionary contains a direct reference to a subclass."

	| classPiAbs classPiFloat factoryPiPackage |
	factoryPiPackage := self createPackage: self packageRoot , 'FactoryPi'.
	classPiAbs := self 
				createClass: 'TestPiAbs'
				superclass: Object
				instVars: ''
				inPackage: factoryPiPackage.
	classPiAbs compile: 'pi ^22/7'.
	classPiFloat := self 
				createClass: 'TestPiFloat'
				superclass: classPiAbs
				instVars: ''
				inPackage: factoryPiPackage.
	classPiFloat compile: 'pi ^super pi asFloat'.

	"Now addin the factory methods"
	classPiAbs class compile: 'fractionalPi ^TestPiAbs'.
	classPiAbs class compile: 'floatingPi ^TestPiFloat'.
	(BinaryPackage for: factoryPiPackage) fileOutSignedWith: cert privateKey: privateKey.
	self destroyPackage: factoryPiPackage!

createLibraryPiPackage
	"This package contains a base class that holds instances of its subclasses in its class
	cpool. The purpose of this is to test forward class pool references in BinaryPackage
	loading. "

	| classPiAbs classPiFloat libraryPiPackage |
	libraryPiPackage := self createPackage: self packageRoot , 'LibraryPi'.
	classPiAbs := self 
				createClass: 'TestPiRoot'
				superclass: Object
				classVars: 'Pis'
				inPackage: libraryPiPackage.
	classPiAbs class compile: 'initialize Pis := OrderedCollection new'.
	classPiAbs class compile: 'pis ^Pis'.
	classPiAbs compile: 'pi ^22/7'.
	classPiFloat := self 
				createClass: 'TestPiFloating'
				superclass: classPiAbs
				instVars: ''
				inPackage: libraryPiPackage.
	classPiFloat compile: 'pi ^super pi asFloat'.
	classPiFloat class compile: 'superpis ^super pis'.
	classPiAbs initialize.
	(classPiAbs pis)
		add: classPiFloat new;
		add: classPiAbs new.
	(BinaryPackage for: libraryPiPackage) fileOutSignedWith: cert privateKey: privateKey.
	self destroyPackage: libraryPiPackage!

createPackage: name
	| package |
	package := Package name: name.
	Package manager addPackage: package.
	^package!

createSimplePiPackageNoSource
	| classPi simplePiPackage |
	simplePiPackage := self createPackage: self packageRoot , 'SimplePi'.
	classPi := self 
				createClass: 'TestPi'
				superclass: Object
				instVars: ''
				inPackage: simplePiPackage.
	classPi compile: 'pi ^ (22*10)/(7*10)'.
	(BinaryPackage for: simplePiPackage)
		fileOutSignedWith: cert privateKey: privateKey.
	self destroyPackage: simplePiPackage!

createSimplePiPackageWithSource
	| classPi simplePiPackage |
	simplePiPackage := self createPackage: self packageRoot , 'SimplePiWithSource'.
	classPi := self 
				createClass: 'TestPiWithSource'
				superclass: Object
				instVars: ''
				inPackage: simplePiPackage.
	classPi compile: 'pi ^ (22*10)/(7*10)'.
	(BinaryPackage for: simplePiPackage)
		keepSource: true;
		fileOutSignedWith: cert privateKey: privateKey.
	self destroyPackage: simplePiPackage!

destroyPackage: package 
	Package manager uninstall: package!

packageRoot
	^FileLocator imageRelative localFileSpecFor: 'Object Arts\Dolphin\Tests\Temporary Test Files\'!

setUp
	| binaryPackage simplePiPackage |
	super setUp.
	cert := self createCertificate.
	self createSimplePiPackageNoSource.
	self createSimplePiPackageWithSource.
	self createFactoryPiPackage.
	self createLibraryPiPackage.
	BinaryPackage unloadAll!

tearDown
	File delete: self packageRoot , 'SimplePi.pak'.
	File delete: self packageRoot , 'SimplePiWithSource.pak'.
	File delete: self packageRoot , 'FactoryPi.pak'.
	File delete: self packageRoot , 'LibraryPi.pak'.
	BinaryPackage unloadAll.
	super tearDown!

testAgentObjectsLoad
	"We must ensure the AgentObjects package is not loaded for the test to be valid"
	| agentLocator agentClass agent |
	self assert: (Smalltalk at: #IAgentCtlEx ifAbsent: []) isNil.
	agentLocator := ClassLocator 
				codeBase: (FileLocator imageRelative 
						localFileSpecFor: 'object arts\dolphin\activex\components\agentobjects\')
				packageName: 'agentobjects'
				key: 'IAgentCtlEx'.
	agentClass := agentLocator locateClass.
	agent := agentClass new.
	self assert: agent connected not.
	agent connected: true.
	self assert: agent connected.
	agent characters load: 'Merlin'.
	self assert: agent characters contents notEmpty!

testForwardClassPoolReference
	"Test the ability to file out and restore BinaryPackages where the class pool
	contains forward references, #2223"

	| piClassLocator piClassAbs |
	piClassLocator := ClassLocator 
				codeBase: self packageRoot
				packageName: 'LibraryPi'
				key: 'TestPiRoot'.
	piClassAbs := piClassLocator locateClass.
	self assert: piClassAbs classPool size = 1.
	self assert: piClassAbs pis isEmpty!

testForwardSubclassReference
	"Test the ability to file out and restore BinaryPackages that contain forward references to classes, #2223"

	| piClassLocator piClassAbs |
	piClassLocator := ClassLocator 
				codeBase: self packageRoot
				packageName: 'FactoryPi'
				key: 'TestPiAbs'.
	piClassAbs := piClassLocator locateClass.
	self assert: (piClassAbs floatingPi new pi isKindOf: Float)!

testSingleClass
	| piClassLocator piClass piMethod |
	piClassLocator := ClassLocator 
				codeBase: self packageRoot
				packageName: 'SimplePi'
				key: 'TestPi'.
	piClass := piClassLocator locateClass.

	"Test methods restored and work"
	self assert: piClass new pi = (22 / 7).

	"Test method source has been lost"
	piMethod := piClass compiledMethodAt: #pi.
	self assert: piMethod sourceDescriptor isNil.
	self assert: piMethod getSource = '"Source currently unavailable"'!

testSingleClassWithSavedSource
	| piClassLocator piClass piMethod |
	piClassLocator := ClassLocator 
				codeBase: self packageRoot
				packageName: 'SimplePiWithSource'
				key: 'TestPiWithSource'.
	piClass := piClassLocator locateClass.

	"Test methods restored and work"
	self assert: piClass new pi = (22 / 7).

	"Test method source has been lost"
	piMethod := piClass compiledMethodAt: #pi.
	self assert: (piMethod sourceDescriptor isKindOf: String).
	self assert: piMethod getSource = 'pi ^ (22*10)/(7*10)'.
!

testSuperMethodOnClassSide
	"Test the ability to file out and restore super calls to methods on the class side"

	| piClassLocator piClassFloating |
	piClassLocator := ClassLocator 
				codeBase: self packageRoot
				packageName: 'LibraryPi'
				key: 'TestPiFloating'.
	piClassFloating := piClassLocator locateClass.
	self assert: piClassFloating superpis size = 0!

testTChartLoad
	"We must ensure that the TeeChart package is not loaded forv the test to be valid"

	| tchartLocator tchartClass tchart |
	self assert: (Smalltalk at: #TeeChart ifAbsent: []) isNil.
	tchartLocator := ClassLocator 
				codeBase: 'c:\object arts\dev\dolphin6\object arts\dolphin\activex\components\teechart\'
				packageName: 'TeeChart'
				key: 'TeeChart'.
	tchartClass := tchartLocator locateClass.
	tchart := tchartClass show.
	tchart view controlDispatch header.
	tchart topShell exit! !
!BinaryPackageTest categoriesFor: #createCertificate!private! !
!BinaryPackageTest categoriesFor: #createClass:superclass:classVars:inPackage:!private! !
!BinaryPackageTest categoriesFor: #createClass:superclass:instVars:inPackage:!private! !
!BinaryPackageTest categoriesFor: #createFactoryPiPackage!private! !
!BinaryPackageTest categoriesFor: #createLibraryPiPackage!private! !
!BinaryPackageTest categoriesFor: #createPackage:!private! !
!BinaryPackageTest categoriesFor: #createSimplePiPackageNoSource!private! !
!BinaryPackageTest categoriesFor: #createSimplePiPackageWithSource!private! !
!BinaryPackageTest categoriesFor: #destroyPackage:!private! !
!BinaryPackageTest categoriesFor: #packageRoot!private! !
!BinaryPackageTest categoriesFor: #setUp!private! !
!BinaryPackageTest categoriesFor: #tearDown!private! !
!BinaryPackageTest categoriesFor: #testAgentObjectsLoad!public! !
!BinaryPackageTest categoriesFor: #testForwardClassPoolReference!public! !
!BinaryPackageTest categoriesFor: #testForwardSubclassReference!public! !
!BinaryPackageTest categoriesFor: #testSingleClass!public! !
!BinaryPackageTest categoriesFor: #testSingleClassWithSavedSource!public! !
!BinaryPackageTest categoriesFor: #testSuperMethodOnClassSide!public! !
!BinaryPackageTest categoriesFor: #testTChartLoad!public! !

