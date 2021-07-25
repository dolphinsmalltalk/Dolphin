"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableTreeItemsTest subclass: #'UI.Tests.MoenTreeViewTest2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MoenTreeViewTest2 guid: (Core.GUID fromString: '{fe4b1b34-22de-4a95-8ba2-05b2f076c51e}')!
UI.Tests.MoenTreeViewTest2 comment: 'SUnitBrowser openOnTestCase: self'!
!UI.Tests.MoenTreeViewTest2 categoriesForClass!Unclassified! !
!UI.Tests.MoenTreeViewTest2 methodsFor!

classToTest
	^MoenTreeView!

mouseDownEventOn: anObject buttons: anArray
	| position |
	position := (presenter nodeForObject: anObject ifAbsent: [])
				ifNil: [presenter clientRectangle corner - 1]
				ifNotNil: [:node | node rectangle origin + 1].
	^self mouseDownEventAt: position buttons: anArray! !
!UI.Tests.MoenTreeViewTest2 categoriesForMethods!
classToTest!helpers!private! !
mouseDownEventOn:buttons:!helpers!private! !
!

