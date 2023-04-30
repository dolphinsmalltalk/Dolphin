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
	tempViewResource := Compiler evaluate: (STLPrinter print: filer stream contents)!

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
testDeserializeAll!public!unit tests! !
testReferenceToNonExistentView!public!unit tests! !
testResourceSelector!public!unit tests! !
testStoreOn!public!unit tests! !
!

