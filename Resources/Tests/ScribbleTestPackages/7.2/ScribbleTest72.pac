﻿| package |
package := Package name: 'ScribbleTest72'.
package paxVersion: 2;
	basicComment: ''.


package setClassNames: #(
	#{ScribbleTest}
).

package setMethodNames: #(
	#(#{Scribble} #looseA)
	#(#{Scribble} #looseC)
	#(#{Scribble class} #resource_Scribble_test)
).

package setVariableNames: #(
	#{AliasToScribbleTest}
	#{ScribbleTestBinaryGlobal}
	#{ScribbleTestSourceGlobal}
).

package setBinaryVariableNames: #(
	#{ScribbleTestBinaryGlobal}
).

package setAliasVariableNames: #(
	#{AliasToScribbleTest}
).

package setPrerequisites: #(
	'..\..\..\..\Core\Object Arts\Dolphin\Base\Dolphin'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Base\Dolphin Basic Geometry'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Models\List\Dolphin List Models'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'
	'..\..\..\..\Core\Object Arts\Samples\MVP\Scribble\Scribble'
).

package!

"Class Definitions"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

"Variable Aliases"!

AliasToScribbleTest := ScribbleTest!


"Loose Methods"!

!Scribble methodsFor!

looseA
	^#A!

looseC
	^'C'! !
!Scribble categoriesFor: #looseA!public! !
!Scribble categoriesFor: #looseC!public! !

!Scribble class methodsFor!

resource_Scribble_test
	"Answer the literal data from which the 'Scribble test' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self name name: 'Scribble test')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ContainerView)  98 15 0 0 98 2 8 1140850688 131073 416 0 196934 1 ##(RGB)  8454655 0 7 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(ScribbleView)  98 12 0 416 98 2 8 1140850688 1 560 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 498 16908287 0 7 0 0 0 560 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  41 41 914 681 471 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 104 1 0 0 255 0 0 0] 98 0 914 193 193 0 27 234 256 98 2 560 8 'scribble' 590342 ##(Rectangle)  914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 20001 20001 914 761 551 416 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 140 40 0 0 35 40 0 0] 98 2 560 410 432 98 15 0 416 98 2 8 1140850688 131073 1312 0 498 8454655 0 7 0 0 0 1312 530 1 1 0 0 0 0 410 576 98 12 0 1312 98 2 8 1140850688 1 1408 642 202 208 688 0 720 498 16908287 0 7 0 0 0 1408 786 202 208 98 1 850 880 98 2 914 41 41 914 621 421 1408 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 74 1 0 0 230 0 0 0] 98 0 1024 0 27 234 256 98 2 1408 8 'scribble' 1090 914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 21 23 914 701 501 1312 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 104 1 0 0 5 1 0 0] 98 1 1408 1024 0 27 1024 0 27 )! !
!Scribble class categoriesFor: #resource_Scribble_test!public!resources-views! !

"End of package definition"!

"Source Variables"!

#{ScribbleTestSourceGlobal} declare: (PoolConstantsDictionary named: #ScribbleTestSourceGlobal)!
ScribbleTestSourceGlobal shrink!

"Classes"!

ScribbleTest guid: (GUID fromString: '{fb773b56-8ed4-480a-820b-c1a43f6013ea}')!
ScribbleTest comment: ''!
!ScribbleTest categoriesForClass!No category! !
!ScribbleTest methodsFor!

a
	^'A'!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents. 
	scribblePresenter := self add: Scribble new name: 'scribble'.
!

model: aListModel
	"Connects the receiver to aListModel. Since the receiver has the same model as the
	sketch pad (Scribble) component that it holds we pass this down to it."

	super model: aListModel.
	scribblePresenter model: aListModel.! !
!ScribbleTest categoriesFor: #a!public! !
!ScribbleTest categoriesFor: #createComponents!initializing!public! !
!ScribbleTest categoriesFor: #model:!accessing!public! !

!ScribbleTest class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel with: OrderedCollection new!

defaultView
	^'Default scribble test view'!

resource_Default_scribble_test_view
	"Answer the literal data from which the 'Default scribble test view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self name name: 'Default scribble test view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ContainerView)  98 15 0 0 98 2 8 1140850688 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 0 0 7 0 0 0 576 1638918 ##(ResourceIdentifier)  8 ##(Scribble)  8 #resource_Scribble_test 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  1 1 850 881 681 576 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 184 1 0 0 84 1 0 0] 98 0 850 193 193 0 27 234 256 944 0 722 202 208 98 1 786 816 98 2 850 20001 20001 850 881 681 416 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 200 40 0 0 100 40 0 0] 98 1 576 960 0 27 )! !
!ScribbleTest class categoriesFor: #defaultModel!models!public! !
!ScribbleTest class categoriesFor: #defaultView!public! !
!ScribbleTest class categoriesFor: #resource_Default_scribble_test_view!public!resources-views! !

"Binary Variables"!

ScribbleTestBinaryGlobal := Object fromBinaryStoreBytes: 
(ByteArray fromBase64String: 'IVNUQiA0IGIAAAABAAAAUgAAAAgAAABTY3JpYmJsZQ==')!

