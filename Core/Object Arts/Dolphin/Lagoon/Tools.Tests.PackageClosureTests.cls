"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.PackageClosureTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackageClosureTests guid: (Core.GUID fromString: '{d6f6b8a7-9e40-4fa0-a52c-d92bcafeeebf}')!
Tools.Tests.PackageClosureTests comment: ''!
!Tools.Tests.PackageClosureTests categoriesForClass!Unclassified! !
!Tools.Tests.PackageClosureTests methodsFor!

consoleAppUnimplemented
	"Private - Expected missing selectors in a console app:
		- defineTemplate - sent by ExternalStructure class>>ensureDefined, but this caller is replaced by an empty stub on actual deployment"

	^#(#defineTemplate)!

simpleGuiAppUnimplementedMessages
	"Private - Answer the collection of selectors of methods expected to be missing in a simple GUI app with the image stripper:
		- createThumbnailExtent:mask: - send by View>>addToImageList:extent: when GDI+ is loaded, but only if understood. This will show up in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- defineTemplate- sent from ExternalStructure>>ensureDefined, which is replaced with a no-op stub in deployed apps. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded. This will show up in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- evaluate: Compiler deliberately removed from the scope of the test to reduce noise. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps."

	^#(#createThumbnailExtent:mask: #ttmRelayEvent: #defineTemplate #evaluate:)!

testCommandLineHelloWorld
	"Tests predicted unimplemented messages of a minimal console application. Note that the actual set will be less and can be determined by deploying the application with deployment logging enabled, and looking at the UnimplementedMesages element in the resulting log. In the case of 'Hello World' the unimplemented message set should actually be empty when deploying."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {Smalltalk.CommandLineHelloWorld owningPackage})
		missing: self consoleAppUnimplemented!

testEtchASketch
	"Etch-a-sketch uses an InternalIcon, and STB."

	| env |
	env := BrowserEnvironment new forPackagesDeployment: {UI.Examples.EtchASketch owningPackage}.
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

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {UI.Examples.HelloWorld owningPackage})
		missing: self simpleGuiAppUnimplementedMessages!

testNotepad
	"Notepad has an Integer Prompter, and Prompter now depens on Tooltips, so ttmRelayEvent: will be present."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {UI.Examples.Notepad owningPackage})
		missing: (self simpleGuiAppUnimplementedMessages copyWithout: #ttmRelayEvent:)!

testRegEdit
	"Regedit uses List and Tree views"

	| env |
	env := BrowserEnvironment new forPackagesDeployment: {UI.Examples.RegEdit owningPackage}.
	self verifyPackageClosure: env missing: self simpleGuiAppUnimplementedMessages!

testSimpleWebBrowser
	"Uses WebView2 (and therefore COM)"

	| env |
	env := BrowserEnvironment new forPackagesDeployment: {OS.COM.Examples.WebBrowserShell owningPackage}.
	self verifyPackageClosure: env missing: #(#ttmRelayEvent: #defineTemplate #evaluate:)!

testSystemPackage
	| aPackage |
	aPackage := Object owningPackage.
	"The base package should have no prerequisites"
	self assert: aPackage prerequisiteNames asArray equals: #().
	"There should be no undefined messages in the base package"
	self verifyPackageClosure: (BrowserEnvironment new forPackagesClosure: {aPackage}) missing: #()!

verifyPackageClosure: aBrowserEnvironment missing: aCollectionOfSymbols
	| missing |
	missing := SmalltalkSystem current unimplementedSelectorsIn: aBrowserEnvironment.
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: aCollectionOfSymbols) asSortedArray equals: #()

	"To debug this, open an env browser on the deployment scope as follows:
		EnvironmentBrowserShell onEnvironment: aBrowserEnvironment.
	The call graph to unimplemented messages can then be investigated starting with the Method/Browse other/All unimplemented command"! !
!Tools.Tests.PackageClosureTests categoriesForMethods!
consoleAppUnimplemented!constants!private! !
simpleGuiAppUnimplementedMessages!constants!private! !
testCommandLineHelloWorld!public!unit tests! !
testEtchASketch!public!unit tests! !
testHelloWorld!public!unit tests! !
testNotepad!public!unit tests! !
testRegEdit!public!unit tests! !
testSimpleWebBrowser!public!unit tests! !
testSystemPackage!public!unit tests! !
verifyPackageClosure:missing:!helpers!private! !
!

