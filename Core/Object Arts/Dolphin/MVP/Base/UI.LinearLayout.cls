"Filed out from Dolphin Smalltalk"!

UI.LayoutManager
	subclass: #'UI.LinearLayout'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.LinearLayout guid: (Core.GUID fromString: '{f3556fda-7d0c-4e04-9193-43add8df9ffa}')!
UI.LinearLayout isNonInstantiable: true!
UI.LinearLayout comment: ''!
!UI.LinearLayout categoriesForClass!MVP-Layout Managers-Abstract! !
!UI.LinearLayout methodsFor!

beHorizontal
	"Orientate the views which the receiver lays out so they are stacked
	horizontally."

	self isVertical: false!

beVertical
	"Orientate the views which the receiver lays out so they are stacked vertically."

	self isVertical: true.!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self beHorizontal.!

isHorizontal
	"Answer whether the receiver's components are positioned horizontally."

	^self isVertical not!

isVertical
	"Answer whether the receiver's components are positioned vertically."

	^self subclassResponsibility.!

isVertical: aBoolean 
	"Set whether the receiver lays out managed views horizontally or vertically."

	self subclassResponsibility!

majorDimensionOf: aPoint
	"Private - Answer the dimension of aPoint which coincides
	with direction which views are layout out in by the receiver."

	^self isVertical
		ifTrue: [aPoint y]
		ifFalse: [aPoint x]!

pointWithMajor: major minor: minor
	"Private - Answer a new Point."

	^self isVertical
		ifTrue: [minor @ major]
		ifFalse: [major @ minor]!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	| insets accumulate box |
	box := 0 @ 0.
	accumulate := self isVertical 
				ifTrue: 
					[
					[:extent | 
					box x: (box x max: extent x).
					box y: box y + extent y]]
				ifFalse: 
					[
					[:extent | 
					box x: box x + extent x.
					box y: (box y max: extent y)]].
	(self visibleSubViewsOf: aCompositeView context: aLayoutContext) 
		do: [:each | accumulate value: (each layoutExtent: aLayoutContext)].
	insets := aCompositeView actualInsets: aLayoutContext.
	^box + insets topLeft + insets bottomRight! !
!UI.LinearLayout categoriesForMethods!
beHorizontal!modes!public! !
beVertical!modes!public! !
initialize!initializing!private! !
isHorizontal!public!testing! !
isVertical!public!testing! !
isVertical:!accessing!public! !
majorDimensionOf:!geometry!private! !
pointWithMajor:minor:!helpers!private! !
preferredLayoutExtentOf:context:!enquiries!public! !
!

