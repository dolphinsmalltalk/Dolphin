"Filed out from Dolphin Smalltalk"!

UI.Tests.ImageViewAbstractTest
	subclass: #'Tools.Tests.ImageListViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.ImageListViewTest guid: (Core.GUID fromString: '{9e3fdff9-1f55-4b2e-8b02-1c766aa4b56b}')!

Tools.Tests.ImageListViewTest comment: ''!

!Tools.Tests.ImageListViewTest methodsFor!

classToTest
	^ImageListView!

image
	^IconImageManager current imageListWithExtent: 16@16! !

!Tools.Tests.ImageListViewTest categoriesForMethods!
classToTest!helpers!private! !
image!private!Running! !
!

!Tools.Tests.ImageListViewTest class methodsFor!

resource_ImageList_view_D7
	"Answer the literal data from which the 'ImageList view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_ImageList_view)
	"

	"This method is slightly modified from the actual D7 resource - the Smalltalk qualification has been removed from ImageListView reference as we don't have an old name for the class, since it is a Tool  and not intended for use in applications."

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(ImageListView) 34 21 nil nil 34 2 8 1140850944 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil nil #normal 1 nil #none 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 722 225 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 239 7 0 0 110 0 0 0] 8 #() 722 193 193 nil 27)! !

!Tools.Tests.ImageListViewTest class categoriesForMethods!
resource_ImageList_view_D7!public! !
!

