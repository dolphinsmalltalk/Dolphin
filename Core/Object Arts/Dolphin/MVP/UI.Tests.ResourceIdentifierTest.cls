"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ResourceIdentifierTest
	instanceVariableNames: 'tempViewResource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ResourceIdentifierTest guid: (GUID fromString: '{1e647bf5-1b62-4e30-af83-80b9bfbe65ad}')!
ResourceIdentifierTest comment: ''!
!ResourceIdentifierTest categoriesForClass!Unclassified! !
!ResourceIdentifierTest methodsFor!

createResourceNamed: aString for: aView on: aPresenterClass
	| filer rid resource |

	filer := STLOutFiler on: Array writeStream.
	filer nextPut: aView.
	aView destroy.
	resource := filer stream contents.
	rid := ResourceIdentifier class: aPresenterClass name: aString.
	rid assign: resource.
	^rid
!

setUp
	| shellView filer |
	super setUp.
	shellView := ShellView show.
	shellView model: {$a. 'abc'. 1. 16rFFFFFFFF. #($a #abc true nil 1.2)}.
	filer := STLOutFiler on: Array writeStream.
	filer nextPut: shellView.
	shellView destroy.
	tempViewResource := filer stream contents!

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
				[self class class removeSelector: #resource_Test_view ifAbsent: [].
				self assert: (self class respondsTo: #resource_Test_view) not]!

testDeserializeAll
	"Test's that all view resources are deserializable. The most common cause of breakage would
	be changing the layout of a class with serialized instances in resources without adding an
	appropriate STB conversion."

	"This will throw an  error if #stbVersion has not been incremented on a class with changed inst vars appearing in a resource."

	ResourceIdentifier allResourceIdentifiers do: [:each | each hiddenObjects]!

testReferenceViewRemoved
	| childRid parentRid paretView anonPresenterClass anonMetaclass |

	anonPresenterClass :=  AnonymousClassBuilder new createNewClass.
	anonPresenterClass superclass: Presenter.
	anonMetaclass := anonPresenterClass class.
	childRid := self createResourceNamed: 'Test view issue990' for: ContainerView new create on: anonPresenterClass.

	paretView := ShellView new create.
	paretView addSubView: (ReferenceView resourceIdentifier: childRid).
	parentRid := self createResourceNamed: 'Parent Test view issue990' for: paretView on: anonPresenterClass.

	anonMetaclass removeSelector: #resource_Test_view_issue990 ifAbsent: [].
	self assert: (anonMetaclass respondsTo: #resource_Test_view_issue990) not.

	self should: [childRid hiddenObjects] raise: Error matching: [:err | err description = 'Resource [a subclass of Presenter>>resource_Test_view_issue990] does not exist'].

	anonMetaclass removeSelector: #resource_Parent_Test_view_issue990 ifAbsent: [].

	self assert: (anonMetaclass respondsTo: #resource_Parent_Test_view_issue990) not.
	!

testResourceSelector
	| rid selector |
	rid := ResourceIdentifier class: self class name: 'Default view'.
	selector := rid class selectorFromName: rid name.
	self assert: selector identicalTo: #resource_Default_view.
	self assert: (rid class nameFromSelector: selector) equals: rid name.
	rid := ResourceIdentifier class: self class name: '1Default:view'.
	self assert: (rid class selectorFromName: rid name) identicalTo: #resource_1Defaultview! !
!ResourceIdentifierTest categoriesFor: #createResourceNamed:for:on:!private!unit tests! !
!ResourceIdentifierTest categoriesFor: #setUp!private!unit tests! !
!ResourceIdentifierTest categoriesFor: #tempViewResource!private!unit tests! !
!ResourceIdentifierTest categoriesFor: #testAssignResource!public!unit tests! !
!ResourceIdentifierTest categoriesFor: #testDeserializeAll!public!unit tests! !
!ResourceIdentifierTest categoriesFor: #testReferenceViewRemoved!public!unit tests! !
!ResourceIdentifierTest categoriesFor: #testResourceSelector!public!unit tests! !

