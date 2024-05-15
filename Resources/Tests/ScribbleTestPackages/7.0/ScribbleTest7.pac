| package |
package := Package name: 'ScribbleTest7'.
package paxVersion: 1;
	basicComment: ''.


package classNames
	add: #ScribbleTest;
	yourself.

package methodNames
	add: #Object -> #scribble;
	add: #Scribble -> #looseA;
	add: #Scribble -> #looseC;
	add: 'Scribble class' -> #resource_Scribble_test;
	yourself.

package globalNames
	add: #AliasToScribbleTest;
	add: #ScribbleTestBinaryGlobal;
	add: #ScribbleTestSourceGlobal;
	yourself.

package binaryGlobalNames: (Set new
	add: #ScribbleTestBinaryGlobal;
	yourself).

package globalAliases: (Set new
	add: #AliasToScribbleTest;
	yourself).

package setPrerequisites: #(
	'..\..\..\..\Core\Object Arts\Dolphin\Base\Dolphin'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Base\Dolphin Basic Geometry'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Models\List\Dolphin List Models'
	'..\..\..\..\Core\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base'
	'..\..\..\..\Core\Object Arts\Samples\MVP\Scribble\Scribble').

package!

"Class Definitions"!

Presenter subclass: #ScribbleTest
	instanceVariableNames: 'scribblePresenter'
	classVariableNames: ''
	poolDictionaries: 'ScribbleTestSourceGlobal'
	classInstanceVariableNames: ''!

"Global Aliases"!

AliasToScribbleTest := ScribbleTest!


"Loose Methods"!

!Object methodsFor!

scribble
	^Scribble! !
!Object categoriesForMethods!
scribble!public! !
!

!Scribble methodsFor!

looseA
	^#A!

looseC
	^'C'! !
!Scribble categoriesForMethods!
looseA!public! !
looseC!public! !
!

!Scribble class methodsFor!

resource_Scribble_test
	"Answer the literal data from which the 'Scribble test' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scribble_test)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 196934 1 ##(Smalltalk.RGB) 8454655 nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ScribbleView) 34 12 nil 416 34 2 8 1140850688 1 544 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 16908287 nil 7 nil nil nil 544 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 41 41 834 681 471 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 104 1 0 0 255 0 0 0] 8 #() 834 193 193 nil 27 170 192 34 2 544 8 'scribble' 590342 ##(Smalltalk.Rectangle) 834 41 41 834 41 41 722 138 144 34 1 786 #createAt:extent: 34 2 834 6143 21 834 761 551 416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 29 1 0 0] 34 2 544 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1232 nil 482 8454655 nil 7 nil nil nil 1232 514 1 1 nil nil nil nil 410 ##(Smalltalk.ScribbleView) 34 12 nil 1232 34 2 8 1140850688 1 1328 610 138 144 656 nil 688 482 16908287 nil 7 nil nil nil 1328 722 138 144 34 1 786 #createAt:extent: 34 2 834 41 41 834 621 421 1328 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 74 1 0 0 230 0 0 0] 8 #() 944 nil 27 170 192 34 2 1328 8 'scribble' 1010 834 41 41 834 41 41 722 138 144 34 1 786 #createAt:extent: 34 2 834 21 23 834 701 501 1232 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 104 1 0 0 5 1 0 0] 34 1 1328 944 nil 27 944 nil 27 )! !
!Scribble class categoriesForMethods!
resource_Scribble_test!public!resources-views! !
!

"End of package definition"!

"Source Globals"!

Smalltalk at: #ScribbleTestSourceGlobal put: (PoolConstantsDictionary named: #ScribbleTestSourceGlobal)!
ScribbleTestSourceGlobal at: 'Constant1' put: 16r1!
ScribbleTestSourceGlobal at: 'ConstantString' put: 'abc'!
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
	scribblePresenter model: aListModel.!

one
	^Constant1!

string
	^ConstantString! !
!ScribbleTest categoriesForMethods!
a!public! !
createComponents!initializing!public! !
model:!accessing!public! !
one!public! !
string!public! !
!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_scribble_test_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 544 nil nil nil 7 nil nil nil 544 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Scribble) #resource_Scribble_test nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 754 881 681 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 184 1 0 0 84 1 0 0] 8 #() 754 193 193 nil 27 170 192 848 nil 642 138 144 34 1 706 #createAt:extent: 34 2 754 6143 21 754 881 681 416 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 183 13 0 0 94 1 0 0] 34 1 544 864 nil 27 )! !
!ScribbleTest class categoriesForMethods!
defaultModel!models!public! !
defaultView!public! !
resource_Default_scribble_test_view!public!resources-views! !
!

"Binary Globals"!

ScribbleTestBinaryGlobal := Object fromBinaryStoreBytes: 
(ByteArray fromBase64String: 'IVNUQiA0IGIAAAABAAAAUgAAAAgAAABTY3JpYmJsZQ==')!

