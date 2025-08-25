"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.FramingCalculation'
	instanceVariableNames: 'name framingBlock offsetBlock flags'
	classVariableNames: 'Calculations'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'IndependentMask' -> 16r4. 'ProportionalMask' -> 16r2. 'VerticalMask' -> 16r1 }!

UI.FramingCalculation guid: (Core.GUID fromString: '{d8059738-a2e8-4291-8e24-e31cf4bee13a}')!

UI.FramingCalculation comment: '`FramingCalculation` instances are used to represent the individual edge constraints in a `FramingConstraint`s instance. See that class'' comment for further details.

You can add a new framing calculation by extending the class with new instance creation methods annotated with `<framingCalc>`, providing edge and offset calculation blocks implementing the new framing calculations.

## Instance Variables:
  `name`			`Symbol` name of the calculation
  `framingBlock`	`<dyadicValuable>` edge calculation block
  `offsetBlock`		`<dyadicValuable>` offset calculation block
  `flags`			`<integer>` flags

## Class Variables:
  `Calculations`		`IdentityDictionary` mapping from symbolic names to the corresponding `FramingCalculation`

'!

!UI.FramingCalculation categoriesForClass!MVP-Layout Managers-Support! !

!UI.FramingCalculation methodsFor!

= anObject
	^self == anObject or: [
		anObject species == FramingCalculation and: [name == anObject name]]!

calculateEdge: anInteger context: aFramingContext 
	^(framingBlock value: anInteger value: aFramingContext) truncated!

calculateOffset: anInteger context: aFramingContext 
	^offsetBlock value: anInteger value: aFramingContext!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream!

hash
	^name hash!

isIndependent
	"Answer whether this framing calculation can be successfuly performed without relying on another pre-computed edge of the same view (i.e. must be parent or previous sibling constrained, rather than an offset from another edge)."

	^flags allMask: IndependentMask!

isProportional
	^flags allMask: ProportionalMask!

isVertical
	^flags allMask: VerticalMask!

name
	"Answer the symbolic name of this framing calculation."

	^name!

name: aSymbol framingBlock: framingBlockClosure offsetBlock: offsetBlockClosure flags: anInteger 
	"Private - Initialize a new instance of the receiver."

	name := aSymbol.
	framingBlock := framingBlockClosure.
	offsetBlock := offsetBlockClosure.
	flags := anInteger!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are the same as those which would result from sending a #printString message to the receiver."

	aPuttableStream
		print: self class;
		space;
		display: self name!

stbSaveOn: anSTBOutFiler
	"Private - There should be only one instance of the receiver for each of the standard framing calculations (though only to reduce memory usage), so arrange for the binary filer to recognise this."

	anSTBOutFiler
		saveSingleton: self
		class: self basicClass
		name: self name! !

!UI.FramingCalculation categoriesForMethods!
=!comparing!public! !
calculateEdge:context:!calculations!public! !
calculateOffset:context:!calculations!public! !
displayOn:!displaying!public! !
hash!comparing!public! !
isIndependent!public!testing! !
isProportional!public!testing! !
isVertical!public!testing! !
name!accessing!public! !
name:framingBlock:offsetBlock:flags:!initializing!private! !
printOn:!public! !
stbSaveOn:!binary filing!private! !
!

!UI.FramingCalculation class methodsFor!

allCalculations
	"Answer an <IdentityDictionary> keyed by symbolic name of all available framing calculations. The collection is built from all class methods with a <framingCalc> annotation, allowing for user-extensibility by extending this class with further similarly annotated methods."

	^Calculations ifNil: [Calculations := self findCalculations]!

annotatedMethodRemoved: aCompiledMethod
	"Private - Annotations are being removed as a consequence of the removal of an annotated method. This is an opportunity to update any metadata that might be based on method annotations."

	Calculations := nil!

annotationsUpdated: aCompilationResult 
	"Private - Annotations may have been added or removed in the receiver's methods. This is an opportunity to update any metadata that might be based on method annotations."
	
	Calculations := nil!

centerRelativeParentHeight
	<framingCalc>
	^self
		newName: #centerRelativeParentHeight
		framingBlock: 
			[:proportion :ctx |
			| space gapSize fract |
			fract := proportion asFraction.
			space := (fract denominator - 1) * ctx height.
			gapSize := (ctx parentExtent y - space) / fract denominator.
			gapSize + ((fract numerator - 1) * (ctx height + gapSize))]
		offsetBlock: [:offset :ctx | offset / ctx parentHeight]
		flags: ##(IndependentMask | VerticalMask | ProportionalMask)!

centerRelativeParentWidth
	<framingCalc>
	^self
		newName: #centerRelativeParentWidth
		framingBlock: 
			[:proportion :ctx |
			| space gapSize fract |
			fract := proportion asFraction.
			space := (fract denominator - 1) * ctx width.
			gapSize := (ctx parentExtent x - space) / fract denominator.
			gapSize + ((fract numerator - 1) * (ctx width + gapSize))]
		offsetBlock: [:offset :ctx | offset / ctx parentWidth]
		flags: ##(IndependentMask | ProportionalMask)!

findCalculations
	| calcs |
	calcs := IdentityDictionary new.
	self class methodsDo: 
			[:each |
			(each hasAnnotation: #framingCalc)
				ifTrue: [calcs at: each selector put: (each value: self withArguments: #())]].
Notification signal: 'Rebuilting FramingCalculations: ', calcs printString.
	^calcs!

fixedParentBottom
	"Answer a <FramingCalculation> that calculates the position of a view's top or bottom edge as a fixed offset from its parent's bottom edge. The offset will normally be negative."

	<framingCalc>
	^self
		newName: #fixedParentBottom
		framingBlock: [:offset :ctx | ctx parentBottom + offset]
		offsetBlock: [:offset :ctx | offset - ctx parentBottom]
		flags: ##(IndependentMask | VerticalMask)!

fixedParentLeft
	"Answer a <FramingCalculation> that calculates the position of a view's left or right edge as a fixed offset from its parent's left edge. The offset will normally be positive. "

	<framingCalc>
	^self
		newName: #fixedParentLeft
		framingBlock: [:offset :ctx | ctx parentLeft + offset]
		offsetBlock: [:offset :ctx | offset - ctx parentLeft]
		flags: IndependentMask!

fixedParentRight
	"Answer a <FramingCalculation> that calculates the position of a view's left or right edge as a fixed offset from its parent's right edge. The offset will normally be negative. "

	<framingCalc>
	^self
		newName: #fixedParentRight
		framingBlock: [:offset :ctx | ctx parentRight + offset]
		offsetBlock: [:offset :ctx | offset - ctx parentRight]
		flags: IndependentMask!

fixedParentTop
	"Answer a <FramingCalculation> that calculates the position of a view's top or bottom edge as a fixed offset from its parent's top edge. The offset will normally be positive. "

	<framingCalc>
	^self
		newName: #fixedParentTop
		framingBlock: [:offset :ctx | ctx parentTop + offset]
		offsetBlock: [:offset :ctx | offset - ctx parentTop]
		flags: ##(IndependentMask | VerticalMask)!

fixedPreviousBottom
	"Answer a <FramingCalculation> that calculates the position of a view's top or bottom edge as a fixed offset from its previous siblings bottom edge. The offset could be positive or negative, depending on whether the view is to be positioned above or below the siblings bottom edge."

	<framingCalc>
	^self
		newName: #fixedPreviousBottom
		framingBlock: [:offset :ctx | ctx previousBottom + offset]
		offsetBlock: [:offset :ctx | offset - ctx previousBottom]
		flags: ##(IndependentMask | VerticalMask)!

fixedPreviousLeft
	"Answer a <FramingCalculation> that calculates the position of a view's left or right edge as a fixed offset from its previous siblings left edge. The offset could be positive or negative, depending on whether the view is to be positioned to the left or right of the siblings left edge."

	<framingCalc>
	^self
		newName: #fixedPreviousLeft
		framingBlock: [:offset :ctx | ctx previousLeft + offset]
		offsetBlock: [:offset :ctx | offset - ctx previousLeft]
		flags: IndependentMask!

fixedPreviousRight
	"Answer a <FramingCalculation> that calculates the position of a view's left or right edge as a fixed offset from its previous siblings right edge. The offset could be positive or negative, depending on whether the view is to be positioned to the left or right of the siblings right edge."

	<framingCalc>
	^self
		newName: #fixedPreviousRight
		framingBlock: [:offset :ctx | ctx previousRight + offset]
		offsetBlock: [:offset :ctx | offset - ctx previousRight]
		flags: IndependentMask!

fixedPreviousTop
	"Answer a <FramingCalculation> that calculates the position of a view's top or bottom edge as a fixed offset from its previous siblings top edge. The offset could be positive or negative, depending on whether the view is to be positioned above or below the siblings top edge."

	<framingCalc>
	^self
		newName: #fixedPreviousTop
		framingBlock: [:offset :ctx | ctx previousTop + offset]
		offsetBlock: [:offset :ctx | offset - ctx previousTop]
		flags: ##(IndependentMask | VerticalMask)!

fixedViewBottom
	"Answer a <FramingCalculation> that calculates the position of a view's top edge as a fixed offset from its bottom edge. This is useful for fixed height controls. The offset must be negative if the view is to be visible."

	<framingCalc>
	^self
		newName: #fixedViewBottom
		framingBlock: [:offset :ctx | ctx bottom + offset]
		offsetBlock: [:offset :ctx | offset - ctx bottom]
		flags: VerticalMask!

fixedViewLeft
	"Answer a <FramingCalculation> that calculates the position of a view's right edge as a fixed offset from its left edge. This is useful for fixed width controls. The offset must be positive if the view is to be visible."

	<framingCalc>
	^self
		newName: #fixedViewLeft
		framingBlock: [:offset :ctx | ctx left + offset]
		offsetBlock: [:offset :ctx | offset - ctx left]
		flags: 0!

fixedViewRight
	"Answer a <FramingCalculation> that calculates the position of a view's left edge as a fixed offset from its right edge. This is useful for fixed width controls. The offset must be negative if the view is to be visible."

	<framingCalc>
	^self
		newName: #fixedViewRight
		framingBlock: [:offset :ctx | ctx right + offset]
		offsetBlock: [:offset :ctx | offset - ctx right]
		flags: 0!

fixedViewTop
	"Answer a <FramingCalculation> that calculates the position of a view's bottom edge as a fixed offset from its top edge. This is useful for fixed height controls. The offset must be positive if the view is to be visible."

	<framingCalc>
	^self
		newName: #fixedViewTop
		framingBlock: [:offset :ctx | ctx top + offset]
		offsetBlock: [:offset :ctx | offset - ctx top]
		flags: VerticalMask!

named: aSymbol
	^self allCalculations at: aSymbol!

newName: aSymbol framingBlock: framingBlockClosure offsetBlock: offsetBlockClosure flags: anInteger 
	^(self basicNew)
		name: aSymbol
			framingBlock: framingBlockClosure
			offsetBlock: offsetBlockClosure
			flags: anInteger;
		yourself!

relativeParentHeight
	"Answer a <FramingCalculation> that calculates the position of a view's top or bottom edge as a proportion of the parent's height. The offset should normally be between 0 and 1."

	<framingCalc>
	^self
		newName: #relativeParentHeight
		framingBlock: [:proportion :ctx | ctx parentTop + (proportion * ctx parentHeight)]
		offsetBlock: [:offset :ctx | (offset - ctx parentTop) / ctx parentHeight]
		flags: ##(IndependentMask | VerticalMask | ProportionalMask)!

relativeParentWidth
	"Answer a <FramingCalculation> that calculates the position of a view's left or right edge as a proportion of the parent's width. The offset should normally be between 0 and 1."

	<framingCalc>
	^self
		newName: #relativeParentWidth
		framingBlock: [:proportion :ctx | ctx parentLeft + (proportion * ctx parentWidth)]
		offsetBlock: [:offset :ctx | (offset - ctx parentLeft) / ctx parentWidth]
		flags: ##(IndependentMask | ProportionalMask)!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| answer ref |
	ref := anSTBInFiler register: nil.
	answer := self named: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer! !

!UI.FramingCalculation class categoriesForMethods!
allCalculations!accessing!public! !
annotatedMethodRemoved:!event handling!private! !
annotationsUpdated:!event handling!private! !
centerRelativeParentHeight!instance creation!public! !
centerRelativeParentWidth!instance creation!public! !
findCalculations!initializing!private! !
fixedParentBottom!instance creation!public! !
fixedParentLeft!instance creation!public! !
fixedParentRight!instance creation!public! !
fixedParentTop!instance creation!public! !
fixedPreviousBottom!instance creation!public! !
fixedPreviousLeft!instance creation!public! !
fixedPreviousRight!instance creation!public! !
fixedPreviousTop!instance creation!public! !
fixedViewBottom!instance creation!public! !
fixedViewLeft!instance creation!public! !
fixedViewRight!instance creation!public! !
fixedViewTop!instance creation!public! !
named:!instance creation!public! !
newName:framingBlock:offsetBlock:flags:!instance creation!private! !
relativeParentHeight!instance creation!public! !
relativeParentWidth!instance creation!public! !
stbReadFrom:format:size:!binary filing!public! !
!

