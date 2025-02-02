"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.PackageClosureTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.PackageClosureTests guid: (Core.GUID fromString: '{d6f6b8a7-9e40-4fa0-a52c-d92bcafeeebf}')!

Tools.Tests.PackageClosureTests comment: ''!

!Tools.Tests.PackageClosureTests methodsFor!

consoleAppUnimplemented
	"Private - Expected missing selectors in a console app:
		- defineTemplate - sent by ExternalStructure class>>ensureDefined, but this caller is replaced by an empty stub on actual deployment"

	^#(#defineTemplate)!

consoleDbAppUnimplemented
	"Private - Expected missing selectors in a console app using the Database Connection package:
		- defaultIcon - referenced from RegKeyAbstract and subclasses class icon methods. Icon is referenced from ResourceIdentifier which is part of the base Dolphin package, but which will be removed by actual deployment of a non-GUI app.
		- defineTemplate - sent by ExternalStructure class>>ensureDefined, but this caller is replaced by an empty stub on actual deployment
		- version - referenced from DBAbstractStatement class>>stbConvertFrom:. In practice this will be removed if the app does not use STB.
	In practice the only unimplemented message in a simple console DB sample after deployment is #rollback. This is implemented by DBTransaction, which is removed in simple apps that are not using transactions."

	^#(#defaultIcon #defineTemplate #version)!

simpleGuiAppUnimplementedMessages
	"Private - Answer the collection of selectors of methods expected to be missing in a simple GUI app with the image stripper:
		- defineTemplate- sent from ExternalStructure>>ensureDefined, which is replaced with a no-op stub in deployed apps. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- ttmRelayEvent: - only sent (from MVP base) if the Dolphin ToolTips package is loaded. This may show up in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- #isStable, #override:with: #removeOverrideFor: #saveObject: #saveObject:as: #saveSingleton: #saveSingleton:class:name: #saveSingleton:name: - STBOutFiler methods sent by stbSaveOn:'s, which will be removed on deployment if the STB/STLOutFilers are not part of the app. However as STBOutFiler is no longer part of the base Dolphin package, it will be missing in any application that does not use STB, causing these methods to have no implementation in the dummy deployment environment. An app such as Etch-A-Sketch does use STB to save documents, so it won't be missing these in the deployment environment, but most of the test apps will as they don't use STB for writing, only STL for reading view resources."

	^#(#ttmRelayEvent: #defineTemplate #isStable #override:with: #removeOverrideFor: #saveObject: #saveObject:as: #saveSingleton: #saveSingleton:class:name: #saveVariableBinding:)!

testCommandLineHelloWorld
	"Tests predicted unimplemented messages of a minimal console application. Note that the actual set will be less and can be determined by deploying the application with deployment logging enabled, and looking at the UnimplementedMesages element in the resulting log. In the case of 'Hello World' the unimplemented message set should actually be empty when deploying."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {Smalltalk.CommandLineHelloWorld owningPackage})
		missing: self consoleAppUnimplemented!

testDumpTable
	"Tests predicted unimplemented messages of a fairly minimal console application using Database Connection."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {Smalltalk.DumpTable owningPackage})
		missing: self consoleDbAppUnimplemented!

testEtchASketch
	"Etch-a-sketch uses STB."

	| env |
	env := BrowserEnvironment new forPackagesDeployment: { UI.Examples.EtchASketch owningPackage }.
	self verifyPackageClosure: env missing: #(#ttmRelayEvent: #defineTemplate).
	"This isn't necessarily sufficient for InternalIcon, etc, to survive into the deployed app, but is necessary for that to be so.
		EnvironmentBrowserShell onEnvironment: envEnvironment Browser.
	"
	"Etch-a-sketch (actually the Scribble app on which it is based) uses STB to serialize data"
	self assert: (env includesClass: STBOutFiler).
	self assert: (env includesSelector: #owningPackage in: ClassDescription).
	self deny: (env includesSelector: #owningPackage in: Class).
	#todo. "Caused by Clipboard. To be removed."
	self assert: (env includesClass: STBOutFiler).
!

testHelloWorld
	"Tests predicted unimplemented messages of a minimal GUI application."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: {UI.Examples.HelloWorld owningPackage})
		missing: self simpleGuiAppUnimplementedMessages!

testNotepad
	"Notepad has an Integer Prompter, and Prompter now depends on Tooltips, so ttmRelayEvent: will be present in the deployed app."

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: { UI.Examples.Notepad owningPackage })
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
	self verifyPackageClosure: env missing: self simpleGuiAppUnimplementedMessages!

testSystemPackage
	| aPackage |
	aPackage := Object owningPackage.
	"The base package should have no prerequisites"
	self assert: aPackage prerequisiteNames asArray equals: #().
	"There should be no undefined messages in the base package"
	self verifyPackageClosure: (BrowserEnvironment new forPackagesClosure: {aPackage}) missing: #()!

testXmlPad
	"XmlPad is an example GUI application making quite extensive use of COM (uses MS XML DOM) and Scintilla. It uses many common controls directly (toolbar and statusbar), or indirectly via the rich Scintilla text styles dialog, although it does not currently contain a TreeView.
	- Contains the Tooltip package (pre-req of Prompter package that is a Scintilla pre-req for styles editor) so not missing #ttmRelayEvent:
	- COM compiled function tables evaluated only for initialization send #defineFunction:*, but these will be removed in an actual deployed app"

	self verifyPackageClosure: (BrowserEnvironment new
				forPackagesDeployment: { UI.Examples.XmlPad owningPackage })
		missing: (self simpleGuiAppUnimplementedMessages asSet
				remove: #ttmRelayEvent:;
				addAll: #(#defineFunction: #defineFunction:argumentTypes:);
				yourself)!

verifyPackageClosure: aBrowserEnvironment missing: aCollectionOfSymbols
	| missing |
	missing := aBrowserEnvironment unimplementedSelectors.
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: aCollectionOfSymbols) asSortedArray equals: #()

	"To debug this, open an env browser on the deployment scope as follows:
		EnvironmentBrowserShell onEnvironment: aBrowserEnvironment.
	The call graph to unimplemented messages can then be investigated starting with the Method/Browse other/All unimplemented command"! !

!Tools.Tests.PackageClosureTests categoriesForMethods!
consoleAppUnimplemented!constants!private! !
consoleDbAppUnimplemented!constants!private! !
simpleGuiAppUnimplementedMessages!constants!private! !
testCommandLineHelloWorld!public!unit tests! !
testDumpTable!public!unit tests! !
testEtchASketch!public!unit tests! !
testHelloWorld!public!unit tests! !
testNotepad!public!unit tests! !
testRegEdit!public!unit tests! !
testSimpleWebBrowser!public!unit tests! !
testSystemPackage!public!unit tests! !
testXmlPad!public!unit tests! !
verifyPackageClosure:missing:!helpers!private! !
!

