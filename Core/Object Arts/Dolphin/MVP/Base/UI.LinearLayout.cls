"Filed out from Dolphin Smalltalk 7"!

LayoutManager subclass: #LinearLayout
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LinearLayout guid: (GUID fromString: '{f3556fda-7d0c-4e04-9193-43add8df9ffa}')!
LinearLayout isAbstract: true!
LinearLayout comment: ''!
!LinearLayout categoriesForClass!MVP-Layout Managers-Abstract! !
!LinearLayout methodsFor!

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
	"Answer whether the receivers components are positioned horizontally."

	^self isVertical not!

isVertical
	"Answer whether the receivers components are positioned vertically."

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
!LinearLayout categoriesFor: #beHorizontal!modes!public! !
!LinearLayout categoriesFor: #beVertical!modes!public! !
!LinearLayout categoriesFor: #initialize!initializing!private! !
!LinearLayout categoriesFor: #isHorizontal!public!testing! !
!LinearLayout categoriesFor: #isVertical!public!testing! !
!LinearLayout categoriesFor: #isVertical:!accessing!public! !
!LinearLayout categoriesFor: #majorDimensionOf:!geometry!private! !
!LinearLayout categoriesFor: #pointWithMajor:minor:!helpers!private! !
!LinearLayout categoriesFor: #preferredLayoutExtentOf:context:!enquiries!public! !

