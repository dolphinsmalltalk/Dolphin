"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PackageClosureTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageClosureTests guid: (GUID fromString: '{d6f6b8a7-9e40-4fa0-a52c-d92bcafeeebf}')!
PackageClosureTests comment: ''!
!PackageClosureTests categoriesForClass!Unclassified! !
!PackageClosureTests methodsFor!

consoleAppUnimplemented
	"Private - Expected missing selectors in a console app with the image stripper. The image stripper is responsible for all of these:
		- instVars, viewClass - Sent to STBViewProxy instances built when reading view resources, but only when deploying GUI apps (which will contain STBViewProxy)
		- recompileDefinition - only sent before the development package which defines it is unloaded
		- setWindowULong:&c - sent to subclass the application deployment progress dialog, before any packages are unloaded"

	^#(#instVars #recompileDefinition #setWindowULong:nIndex:dwNewLong: #viewClass)!

environmentForPackageClosure: aCollectionOfPackages
	| closure |
	closure := IdentitySet new.
	aCollectionOfPackages do: 
			[:each |
			closure add: each.
			closure addAll: each allPrerequisites].
	^BrowserEnvironment new forPackages: closure!

simpleGuiAppUnimplementedMessages
	"Private - Answer the collection of selectors of methods expected to be missing in a simple GUI app with the image stripper:
		- createThumbnailExtent:mask: - send by View>>addToImageList:extent: when GDI+ is loaded, but only if understood.
		- recompileDefinition - sent from ExternalStructure, but only before the development package which defines it is unloaded
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded"

	^#(#createThumbnailExtent:mask: #recompileDefinition #ttmRelayEvent:)!

testCommandLineHelloWorld
	"Tests predicted unimplemented messages of a minimal console application. Note that the actual set will be less and can be determined by deploying the application with deployment logging enabled, and looking at the UnimplementedMesages element in the resulting log. In the case of 'Hello World' the unimplemented message set should actually be empty when deploying."

	self verifyPackageClosure: {CommandLineHelloWorld owningPackage. ImageStripper owningPackage}
		missing: self consoleAppUnimplemented!

testHelloWorld
	"Tests predicted unimplemented messages of a minimal GUI application.

	Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods.In addition to the base package missing methods, the following methods are missing:
		- #createThumbnailExtent:mask: - sent only when GDI+ is loaded (guarded by a respondsTo: check)
		- defaultSessionManagerClass - required at development time only, when creating a new ImageStripper instance
		- recompileDefinition - sent from base package, but before the development package which defines it is unloaded
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded"

	self verifyPackageClosure: {ImageStripper owningPackage. HelloWorld owningPackage}
		missing: self simpleGuiAppUnimplementedMessages!

testNotepad
	"Ideally the set of missing selectors would be empty and reasonable effort has been made to reduce this to a small set. Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods."

	self verifyPackageClosure: {Notepad owningPackage. ImageStripper owningPackage}
		missing: self simpleGuiAppUnimplementedMessages!

testSystemPackage
	| aPackage |
	aPackage := Object owningPackage.
	"The base package should have no prerequisites"
	self assert: aPackage prerequisiteNames asArray equals: #().
	"There should be no undefined messages in the base package"
	self verifyPackageClosure: {aPackage} missing: #()!

verifyPackageClosure: aCollectionOfPackages missing: aCollectionOfSymbols
	| missing env |
	env := self environmentForPackageClosure: aCollectionOfPackages.
	missing := Smalltalk developmentSystem unimplementedSelectorsIn: env.
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: aCollectionOfSymbols) asArray sort equals: #()! !
!PackageClosureTests categoriesFor: #consoleAppUnimplemented!constants!private! !
!PackageClosureTests categoriesFor: #environmentForPackageClosure:!helpers!private! !
!PackageClosureTests categoriesFor: #simpleGuiAppUnimplementedMessages!constants!private! !
!PackageClosureTests categoriesFor: #testCommandLineHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testNotepad!public!unit tests! !
!PackageClosureTests categoriesFor: #testSystemPackage!public!unit tests! !
!PackageClosureTests categoriesFor: #verifyPackageClosure:missing:!helpers!private! !

