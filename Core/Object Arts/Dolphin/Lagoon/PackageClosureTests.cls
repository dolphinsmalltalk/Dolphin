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

basePackageUnimplemented
	"Private - Ideally the set of missing selectors would be empty, but due to some mispackaging and less than ideal code structuring in some cases, there are some selectors sent on code paths that should not be executed:
		- convertBlockToClosure:, initializeLegacyResources, loadLegacyPAC: - sent by the legacy package loader code
		- desktop, parentView - sent by InputState topLevelWindows, but only if there any Views, which there will not be if the MVP base package is not present (which defines these methods)
		- ensureVisible - sent by MessageBox, but only if there is an owner View (so MVP base must be loaded)
		- identifier, instanceHandle - also sent by MessageBox, but only if an Icon is set (so MVP base must be loaded)
	
	To explore the dependencies in detail, open a package browser on the Dolphin package, then run the Browse/Unimplemented Messages command."

	^#(#base64StoreOn: #convertBlockToClosure: #desktop #ensureVisible #identifier #initializeLegacyResources #instanceHandle #loadLegacyPAC: #parentView)!

environmentForPackageClosure: aCollectionOfPackages
	| closure |
	closure := IdentitySet new.
	aCollectionOfPackages do: 
			[:each |
			closure add: each.
			closure addAll: each allPrerequisites].
	^BrowserEnvironment new forPackages: closure!

imageStripperUnimplemented
	"Private - Expected missing selectors caused by the image stripper package alone
		- defaultSessionManagerClass - required at development time only, when creating a new ImageStripper instance
		- instVars, viewClass - Sent to STBViewProxy instances built when reading view resources, but only when deploying GUI apps (which will prevent STBViewProxy being removed)
		- recompileDefinition - sent before the development package which defines it is unloaded
		- setWindowULong:&c - sent to subclass the application deployment progress dialog, before any packages are unloaded"

	^#(#defaultSessionManagerClass #instVars #recompileDefinition #setWindowULong:nIndex:dwNewLong: #viewClass)!

testCommandLineHelloWorld
	"Tests predicted unimplemented messages of a minimal console application. Note that the actual set will be less and can be determined by deploying the application with deployment logging enabled, and looking at the UnimplementedMesages element in the resulting log."

	self verifyPackageClosure: {CommandLineHelloWorld owningPackage. ImageStripper owningPackage}
		missing: self basePackageUnimplemented , self imageStripperUnimplemented!

testHelloWorld
	"Tests predicted unimplemented messages of a minimal GUI application.

	Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods.In addition to the base package missing methods, the following methods are missing:
		- #createThumbnailExtent:mask:
		- defaultSessionManagerClass - required at development time only, when creating a new ImageStripper instance
		- recompileDefinition - sent from base package, but before the development package which defines it is unloaded
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded"

	self verifyPackageClosure: {ImageStripper owningPackage. HelloWorld owningPackage}
		missing: #(#base64StoreOn: #convertBlockToClosure: #createThumbnailExtent:mask: #defaultSessionManagerClass #initializeLegacyResources #loadLegacyPAC: #recompileDefinition #ttmRelayEvent:)!

testNotepad
	"Ideally the set of missing selectors would be empty and reasonable effort has been made to reduce this to a small set. Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods. In addition to the majority of the base package missing methods, the following additional methods are missing:
		- createThumbnailExtent:mask: - send by View>>addToImageList:extent:, but only if understood.
		- defaultSessionManagerClass - required at development time only, when creating a new ImageStripper instance
		- recompileDefinition - sent from base package before the development package which defines it is unloaded
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded"

	self verifyPackageClosure: {Notepad owningPackage. ImageStripper owningPackage}
		missing: #(#base64StoreOn: #convertBlockToClosure: #createThumbnailExtent:mask: #defaultSessionManagerClass #initializeLegacyResources #loadLegacyPAC: #recompileDefinition #ttmRelayEvent:)!

testSystemPackage
	| aPackage |
	aPackage := Object owningPackage.
	self assert: aPackage prerequisiteNames asArray equals: #().
	self verifyPackageClosure: {aPackage} missing: self basePackageUnimplemented!

verifyPackageClosure: aCollectionOfPackages missing: aCollectionOfSymbols
	| missing env |
	env := self environmentForPackageClosure: aCollectionOfPackages.
	missing := Smalltalk developmentSystem unimplementedSelectorsIn: env.
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: aCollectionOfSymbols) asArray sort equals: #()! !
!PackageClosureTests categoriesFor: #basePackageUnimplemented!constants!private! !
!PackageClosureTests categoriesFor: #environmentForPackageClosure:!helpers!private! !
!PackageClosureTests categoriesFor: #imageStripperUnimplemented!constants!private! !
!PackageClosureTests categoriesFor: #testCommandLineHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testNotepad!public!unit tests! !
!PackageClosureTests categoriesFor: #testSystemPackage!public!unit tests! !
!PackageClosureTests categoriesFor: #verifyPackageClosure:missing:!helpers!private! !

