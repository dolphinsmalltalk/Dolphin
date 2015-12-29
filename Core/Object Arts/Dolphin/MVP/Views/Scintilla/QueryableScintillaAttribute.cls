"Filed out from Dolphin Smalltalk X6"!

ScintillaAttribute subclass: #QueryableScintillaAttribute
	instanceVariableNames: 'view'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'getMessages'!
QueryableScintillaAttribute guid: (GUID fromString: '{DD653349-5F8C-41B5-A302-FCC645247163}')!
QueryableScintillaAttribute comment: 'QueryableScintillaAttribute is the abstract class of <ScintillaAtttribute>s that can be retrieved from the underlying control. It provides the basic mechanism for populating the attribute from the view settings.

Instance Variables:
	view		<ScintillaView> with which this attribute is associated.

Class Instance Variables:
	getMessages	<IdentityDictionary>'!
!QueryableScintillaAttribute categoriesForClass!MVP-Views-Support! !
!QueryableScintillaAttribute methodsFor!

populateFromView: aScintillaView at: anInteger 
	id := anInteger.
	view := nil.
	self class getMessages 
		ifNotNil: 
			[:map | 
			map keysAndValuesDo: 
					[:eachSetter :eachGetMessage | 
					self perform: eachSetter with: (aScintillaView sendMessage: eachGetMessage wParam: id)]].
	view := aScintillaView!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !
!QueryableScintillaAttribute categoriesFor: #populateFromView:at:!initializing!private! !
!QueryableScintillaAttribute categoriesFor: #view!accessing!private! !
!QueryableScintillaAttribute categoriesFor: #view:!accessing!private! !

!QueryableScintillaAttribute class methodsFor!

getMessages
	^getMessages!

view: aScintillaView index: anInteger 
	^(self new)
		populateFromView: aScintillaView at: anInteger;
		yourself! !
!QueryableScintillaAttribute class categoriesFor: #getMessages!constants!private! !
!QueryableScintillaAttribute class categoriesFor: #view:index:!instance creation!public! !

