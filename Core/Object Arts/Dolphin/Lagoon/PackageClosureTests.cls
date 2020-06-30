"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PackageClosureTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PackageClosureTests guid: (GUID fromString: '{d6f6b8a7-9e40-4fa0-a52c-d92bcafeeebf}')!
PackageClosureTests comment: ''!
!PackageClosureTests categoriesForClass!Unclassified! !
!PackageClosureTests methodsFor!

consoleAppUnimplemented
	"Private - Expected missing selectors in a console app:
		- defineTemplate - sent by ExternalStructure class>>ensureDefined, but this caller is replaced by an empty stub on actual deployment"

	^#(#defineTemplate)!

environmentForAppDeployment: aCollectionOfPackages
	| env names devMethods removedClasses |
	"The in-scope world is drawn from the slice of the classes & methods that are in the requested packages and their pre-reqs"
	env := self environmentForPackageClosure: aCollectionOfPackages.
	"Classes categorised as 'Development' are excluded"
	env := env & (BrowserEnvironment new forCategories: #('Development' 'System-Compiler')) not.
	"Assume configured to remove ClassBuilder and Compiler"
	removedClasses := Set new.
	{ClassBuilder. MethodProtocol. Category} do: 
			[:each |
			removedClasses
				addAll: each withAllSubclasses;
				addAll: each class withAllSubclasses].
	env := env & (BrowserEnvironment new forClasses: removedClasses) not.
	"Finally, certain categories of method and specific methods are forcibly removed, or we assume (for the purposes of the test) that these will be removed as unused"
	devMethods := BrowserEnvironment new
				forMethodCategories: ImageStripper developmentMethodCategoryNames
						, ImageStripper classBuildingMethodCategoryNames , ImageStripper classRemovingMethodCategoryNames
						, #('class initialization' 'template definition' 'source filing' 'source filing-methods' 'compiling' 'categories-accessing' 'categories-removing' 'categories-adding' 'categories-testing' 'source filing-class definition').
	"We can speed things up a bit by taking a snapshot of the devMethods environment."
	devMethods := BrowserEnvironment new forMethodsIn: devMethods.
	env := env & devMethods not.
	"As before, reify the environment to speed things up as we will enumerate it more than once."
	env := BrowserEnvironment new forMethodsIn: env.
	self
		assert: (devMethods & (BrowserEnvironment new forMethodCategories: #('must not strip'))) isEmpty.
	names := (aCollectionOfPackages collect: [:each | each name]) asArray sort.
	env
		label: 'App deployed from ' , (names size = 1 ifTrue: [names first] ifFalse: [names]) printString.
	^env!

environmentForPackageClosure: aCollectionOfPackages
	| closure |
	closure := IdentitySet new.
	aCollectionOfPackages do: 
			[:each |
			closure add: each.
			each addAllPrerequisitesTo: closure].
	^BrowserEnvironment new forPackages: closure!

simpleGuiAppUnimplementedMessages
	"Private - Answer the collection of selectors of methods expected to be missing in a simple GUI app with the image stripper:
		- createThumbnailExtent:mask: - send by View>>addToImageList:extent: when GDI+ is loaded, but only if understood. This will show up in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- defineTemplate- sent from ExternalStructure>>ensureDefined, which is replaced with a no-op stub in deployed apps. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded. This will show up in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- evaluate: Compiler deliberately removed from the scope of the test to reduce noise. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps."

	^#(#createThumbnailExtent:mask: #ttmRelayEvent: #defineTemplate #evaluate:)!

testCommandLineHelloWorld
	"Tests predicted unimplemented messages of a minimal console application. Note that the actual set will be less and can be determined by deploying the application with deployment logging enabled, and looking at the UnimplementedMesages element in the resulting log. In the case of 'Hello World' the unimplemented message set should actually be empty when deploying."

	self verifyPackageClosure: (self environmentForAppDeployment: {CommandLineHelloWorld owningPackage})
		missing: self consoleAppUnimplemented!

testEtchASketch
	"Etch-a-sketch uses an InternalIcon, and STB."

	| env |
	env := self environmentForAppDeployment: {EtchASketch owningPackage}.
	self verifyPackageClosure: env missing: #(#ttmRelayEvent: #defineTemplate #evaluate:).
	"This isn't necessarily sufficient for InternalIcon, etc, to survive into the deployed app, but is necessary for that to be so."
	self assert: (env includesClass: InternalIcon).
	self assert: (env includesClass: STBOutFiler).
	self assert: (env includesSelector: #owningPackage in: ClassDescription).
	self deny: (env includesSelector: #owningPackage in: Class)!

testHelloWorld
	"Tests predicted unimplemented messages of a minimal GUI application.

	Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods.In addition to the base package missing methods, the following methods are missing:
		- #createThumbnailExtent:mask: - sent only when GDI+ is loaded (guarded by a respondsTo: check)
		- defaultSessionManagerClass - required at development time only, when creating a new ImageStripper instance
		- recompileDefinition - sent from base package, but before the development package which defines it is unloaded
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded"

	self verifyPackageClosure: (self environmentForAppDeployment: {HelloWorld owningPackage})
		missing: self simpleGuiAppUnimplementedMessages!

testNotepad
	"Ideally the set of missing selectors would be empty and reasonable effort has been made to reduce this to a small set. Some of the missing methods contributed by the base package will still be missing, but others are present because Hello World is a GUI app and pulls in the base MVP packages that define those methods."

	self verifyPackageClosure: (self environmentForAppDeployment: {Notepad owningPackage})
		missing: self simpleGuiAppUnimplementedMessages!

testRegEdit
	"Regedit uses List and Tree views"

	| env |
	env := self environmentForAppDeployment: {RegEdit owningPackage}.
	self verifyPackageClosure: env missing: self simpleGuiAppUnimplementedMessages!

testSystemPackage
	| aPackage |
	aPackage := Object owningPackage.
	"The base package should have no prerequisites"
	self assert: aPackage prerequisiteNames asArray equals: #().
	"There should be no undefined messages in the base package"
	self verifyPackageClosure: (self environmentForPackageClosure: {aPackage}) missing: #()!

verifyPackageClosure: aBrowserEnvironment missing: aCollectionOfSymbols
	| missing |
	missing := Smalltalk developmentSystem unimplementedSelectorsIn: aBrowserEnvironment.
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: aCollectionOfSymbols) asArray sort equals: #().

	"To debug this, open an env browser on the deployment scope as follows:
		aBrowserEnvironment openEditor.
	The call graph to unimplemented messages can then be investigated starting with the Method/Browse other/All unimplemented command"! !
!PackageClosureTests categoriesFor: #consoleAppUnimplemented!constants!private! !
!PackageClosureTests categoriesFor: #environmentForAppDeployment:!helpers!private! !
!PackageClosureTests categoriesFor: #environmentForPackageClosure:!helpers!private! !
!PackageClosureTests categoriesFor: #simpleGuiAppUnimplementedMessages!constants!private! !
!PackageClosureTests categoriesFor: #testCommandLineHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testEtchASketch!public!unit tests! !
!PackageClosureTests categoriesFor: #testHelloWorld!public!unit tests! !
!PackageClosureTests categoriesFor: #testNotepad!public!unit tests! !
!PackageClosureTests categoriesFor: #testRegEdit!public!unit tests! !
!PackageClosureTests categoriesFor: #testSystemPackage!public!unit tests! !
!PackageClosureTests categoriesFor: #verifyPackageClosure:missing:!helpers!private! !

