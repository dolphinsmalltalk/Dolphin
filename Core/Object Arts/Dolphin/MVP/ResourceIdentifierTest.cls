"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ResourceIdentifierTest
	instanceVariableNames: 'tempViewResource'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ResourceIdentifierTest guid: (GUID fromString: '{1e647bf5-1b62-4e30-af83-80b9bfbe65ad}')!
ResourceIdentifierTest comment: ''!
!ResourceIdentifierTest categoriesForClass!Unclassified! !
!ResourceIdentifierTest methodsFor!

setUp
	| shellView filer |
	super setUp.
	shellView := ShellView show.
	shellView model: (Array
				with: $a
				with: 'abc'
				with: 1
				with: 16rFFFFFFFF
				with: #($a #abc true nil 1.2)).
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
	self assert: readBack = self tempViewResource] 
			ensure: 
				[self class class removeSelector: #resource_Test_view ifAbsent: [].
				self assert: (self class respondsTo: #resource_Test_view) not]!

testResourceSelector
	| rid selector |
	rid := ResourceIdentifier class: self class name: 'Default view'.
	selector := rid class selectorFromName: rid name.
	self assert: selector == #resource_Default_view.
	self assert: (rid class nameFromSelector: selector) = rid name.
	rid := ResourceIdentifier class: self class name: '1Default:view'.
	self assert: (rid class selectorFromName: rid name) == #resource_1Defaultview! !
!ResourceIdentifierTest categoriesFor: #setUp!private!unit tests! !
!ResourceIdentifierTest categoriesFor: #tempViewResource!private!unit tests! !
!ResourceIdentifierTest categoriesFor: #testAssignResource!public!unit tests! !
!ResourceIdentifierTest categoriesFor: #testResourceSelector!public!unit tests! !

