"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.ResourceIdentifierTest'
	instanceVariableNames: 'tempViewResource'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ResourceIdentifierTest guid: (Core.GUID fromString: '{1e647bf5-1b62-4e30-af83-80b9bfbe65ad}')!

UI.Tests.ResourceIdentifierTest comment: ''!

!UI.Tests.ResourceIdentifierTest methodsFor!

createResourceNamed: aString for: aView on: aPresenterClass
	| filer rid resource |

	filer := STLOutFiler on: Array writeStream.
	filer nextPut: aView.
	aView destroy.
	resource := filer stream contents.
	rid := ResourceIdentifier class: aPresenterClass name: aString.
	rid assign: resource.
	^rid!

setUp
	| shellView filer |
	super setUp.
	shellView := ShellView show.
	shellView model: {$a. 'abc'. 1. 16rFFFFFFFF. #($a #abc true nil 1.2)}.
	filer := STLOutFiler on: Array writeStream.
	filer nextPut: shellView.
	shellView destroy.
	tempViewResource := Compiler evaluate: (STLPrinter printLiteralStoreArray: filer stream contents)!

tempViewResource
	^tempViewResource!

testAssignResource
	| rid readBack |
	self assert: (self class respondsTo: #resource_Test_view) not.
	
	[rid := ResourceIdentifier class: self class name: 'Test view'.
	rid assign: self tempViewResource.
	self assert: (self class respondsTo: #resource_Test_view).
	readBack := rid resource.
	self assert: readBack equals: self tempViewResource]
			ensure: 
				[self class class removeSelector: #resource_Test_view ifAbsent: nil.
				self assert: (self class respondsTo: #resource_Test_view) not]!

testCopy
	| subject copy |
	subject := ResourceIdentifier class: Shell name: Shell defaultView.
	copy := subject copy.
	self assert: copy equals: subject.
	self deny: copy identicalTo: subject.
	self assert: copy owningClass identicalTo: subject owningClass.
	self assert: copy selector identicalTo: subject selector.
	subject name: nil.
	self assertIsNil: subject selector.
	self assert: subject printString equals: 'Shell.untitled'.
	copy := subject copy.
	self assert: copy equals: subject.
	self deny: copy identicalTo: subject.
	self assert: copy owningClass identicalTo: subject owningClass.
	self assert: copy selector identicalTo: subject selector!

testDeserializeAll
	"Test's that all view resources are deserializable. The most common cause of breakage would
	be changing the layout of a class with serialized instances in resources without adding an
	appropriate STB conversion."

	"This will throw an  error if #stbVersion has not been incremented on a class with changed inst vars appearing in a resource."

	ResourceIdentifier allResourceIdentifiers do: [:each | each hiddenObjects]!

testReferenceToNonExistentView
	| childRid parentView anonPresenterClass anonMetaclass |
	anonPresenterClass := Presenter newAnonymousSubclass.
	anonPresenterClass setName: #TestPresenter environment: UI.Tests.
	anonMetaclass := anonPresenterClass class.
	childRid := self
				createResourceNamed: 'Test view issue990'
				for: ContainerView new create
				on: anonPresenterClass.
	parentView := ShellView new create.
	parentView addSubView: (ReferenceView resourceIdentifier: childRid).
	self
		createResourceNamed: 'Parent Test view issue990'
		for: parentView
		on: anonPresenterClass.
	anonMetaclass removeSelector: #resource_Test_view_issue990 ifAbsent: nil.
	self assert: (anonMetaclass respondsTo: #resource_Test_view_issue990) not.
	self
		should: [childRid hiddenObjects]
		raise: Error
		matching: 
			[:err |
			err description
				= 'Resource [UI.Tests.TestPresenter>>#resource_Test_view_issue990] does not exist'].
	anonMetaclass removeSelector: #resource_Parent_Test_view_issue990 ifAbsent: nil.
	self assert: (anonMetaclass respondsTo: #resource_Parent_Test_view_issue990) not!

testResourceSelector
	| rid selector |
	rid := ResourceIdentifier class: self class name: 'Default view'.
	selector := rid class selectorFromName: rid name.
	self assert: selector identicalTo: #resource_Default_view.
	self assert: (rid class nameFromSelector: selector) equals: rid name.
	rid := ResourceIdentifier class: self class name: '1Default:view'.
	self assert: (rid class selectorFromName: rid name) identicalTo: #resource_1Defaultview!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 2 18 0 82 101 115 111 117 114 99 101 73 100 101 110 116 105 102 105 101 114 0 0 0 0 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 146 0 0 0 7 0 0 0 84 111 111 108 98 97 114 146 0 0 0 11 0 0 0 73 109 97 103 101 32 116 111 111 108 115].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ResourceIdentifier.
	self assert: subject owningClass identicalTo: Toolbar.
	self assert: subject selector identicalTo: #resource_Image_tools!

testStoreOn
	| rid restored storeString |
	rid := ResourceIdentifier class: self class name: 'Default view'.
	storeString := rid storeString.
	self assert: storeString
		equals: '(UI.ResourceIdentifier class: ' , self class fullName , ' name: ''Default view'')'.
	restored := Compiler evaluate: storeString.
	self assert: restored equals: rid! !

!UI.Tests.ResourceIdentifierTest categoriesForMethods!
createResourceNamed:for:on:!helpers!private! !
setUp!private!unit tests! !
tempViewResource!private!unit tests! !
testAssignResource!public!unit tests! !
testCopy!public!unit tests! !
testDeserializeAll!public!unit tests! !
testReferenceToNonExistentView!public!unit tests! !
testResourceSelector!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
testStoreOn!public!unit tests! !
!

