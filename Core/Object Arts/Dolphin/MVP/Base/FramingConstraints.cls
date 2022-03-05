"Filed out from Dolphin Smalltalk"!

Object subclass: #FramingConstraints
	instanceVariableNames: 'leftFraming leftOffset rightFraming rightOffset topFraming topOffset bottomFraming bottomOffset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FramingConstraints guid: (GUID fromString: '{87b4c48b-026e-11d3-9fd7-00a0cc3e4a32}')!
FramingConstraints comment: 'FramingConstraints are used to describe the constraints to be placed on the various edges of a <view> that is to be laid out under the jurisdiction of a <FramingLayout> manager. When a view is under the control of a FramingLayout it is given an arrangement aspect that consists of a FramingConstraints instance. It is this that describes the relationships for computing the locations of the various edges of the view and the offsets to be applied from these locations. 

For each of the edges of the view, a FramingConstraints holds a framing relationship and an offset for the edge position relative to the computed location of this. The framing parameters can be set for each edge using the following pairs of aspects.

#bottomFraming,	#bottomOffset 
#leftFraming,	#leftOffset
#rightFraming,	#rightOffset
#topFraming,	#topOffset

The #xxxFraming aspects may be set to any of the following symbols:

#fixedParentBottom 
#fixedParentLeft 
#fixedParentRight 
#fixedParentTop 

Using the above relationships, the appropriate view edge will be positioned a fixed number of pixels from the specified edge of its parent. The distance is determined by the corresponding offset aspect, which must be an <integer> value.

#fixedViewBottom 
#fixedViewLeft 
#fixedViewRight 
#fixedViewTop 

Here, the view edge will be positioned a fixed number of pixels from the specified edge of itself. The distance is determined by the corresponding offset aspect, which must be an <integer> value.

#fixedPreviousBottom 
#fixedPreviousLeft 
#fixedPreviousRight 
#fixedPreviousTop 

Here, the view edge will be positioned a fixed number of pixels from the specified edge of the previous view in the z-order sequence. Once again, the distance is determined by the corresponding offset aspect, an <integer> value.

#relativeParentHeight
#relativeParentWidth

With these relationships, the edge is positioned within the view''s parent at a distance computed relative to the parent''s height or width. In these cases the offset must be set to a <number> in the range 0..1.

#centerRelativeParentHeight
#centerRelativeParentWidth

With these relationships, the centre of each view is positioned within the view''s parent at a distance computed relative to the parent''s height or width. Thanks to Ian Bartholomew for supplying the code for these particular constraints. He says: "This works best if all the subviews are the same size. It does still work if this isn''t true but the gaps between subviews are not then identical, although the position of the centre of the button still corresponds to the buttons offset." Also, "The #offset fields need to be structured in a fixed way. If you have three buttons then the offsets, left to right, need to be specified as 1/4, 2/4 (or 1/2) and 3/4 (Floats will not work)."

Note that in all cases a positive offset implies a position down or to the right of the computed location. Negative offsets can be used if the postion is required to be up or to the left.

For example: Position a view so that it''s left edge is 5 pixels in from the left of it''s parent; it''s width is 200 pixels; it''s bottom is at 50% of the parent height and it''s top is 10 pixels below the bottom of the previous view. Use the following FramingConstraints:

FramingConstraints new
	leftFraming: #fixedParentLeft; leftOffset: 5;
	rightFraming: #fixedViewLeft; rightOffset: 200;
	bottomFraming: #relativeParentHeight; bottomOffset: 0.5;
	topFraming: #fixedPreviousBottom; topOffset: 10.

Instance Variables:
	leftFraming		<FramingCalculation> describing the relationship for the left edge of the view.
	leftOffset		<number> offset of the left edge from the described location.
	rightFraming		<FramingCalculation> describing the relationship for the right edge of the view
	rightOffset		<number> offset of the right edge from the described location
	topFraming		<FramingCalculation> describing the relationship for the top edge of the view
	topOffset		<number> offset of the top edge from the described location
	bottomFraming	<FramingCalculation> describing the relationship for the bottom edge of the view
	bottomOffset	<number> offset of the bottom edge from the described location


'!
!FramingConstraints categoriesForClass!MVP-Layout Managers-Support! !
!FramingConstraints methodsFor!

bottomFraming
	"Answer the <Symbol> name of the framing calculation used to calculate the receiver's bottom edge."

	^bottomFraming name!

bottomFraming: aSymbol 
	aSymbol == #fixedViewBottom ifTrue: [^self errorCantFixEdgeToItself].
	bottomFraming := self class calculationClass perform: aSymbol!

bottomOffset
	"Answer the framing offset for the receivers bottom edge.
	In the case of a parent relative framing constraint, this
	should be a <number> between 0 and 1, and in all other cases
	it should be an <integer>."

	^bottomOffset !

bottomOffset: aNumber 
	bottomOffset := aNumber!

errorCantFixEdgeToItself
	self error: 'Edges cannot be positioned relative to themselves'!

errorNoIndepentEdge
	self 
		error: 'At least one edge in each dimension must be positioned independently of the other edge'!

framings
	"Answer a <sequencedReadableCollection> containing the names of the framing calculations
	configured in the receiver in the order {top, left, bottom, right}."

	^{self topFraming. self leftFraming. self bottomFraming. self rightFraming}!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self leftFraming: #fixedParentLeft.
	self rightFraming: #fixedViewLeft.
	self topFraming: #fixedParentTop.
	self bottomFraming: #fixedViewTop.
	leftOffset := rightOffset := topOffset := bottomOffset := 0!

leftFraming
	"Answer the <Symbol> name of the framing calculation used to calculate the receiver's left edge."

	^leftFraming name!

leftFraming: aSymbol 
	aSymbol == #fixedViewLeft ifTrue: [^self errorCantFixEdgeToItself].
	leftFraming := self class calculationClass perform: aSymbol!

leftOffset
	"Answer the framing offset for the receivers left edge.
	In the case of a parent relative framing constraint, this
	should be a <number> between 0 and 1, and in all other cases
	it should be an <integer>."

	^leftOffset!

leftOffset: aNumber 
	leftOffset := aNumber!

messages
	| messages |
	messages := {leftFraming name. rightFraming name. topFraming name. bottomFraming name}.
	^messages!

offsets
	"Answer a <Rectangle> whose co-ordinates arethe offsets/proportions of the corresponding
	edges configured in the receiver."

	^Rectangle origin: self topOffset @ self leftOffset corner: self bottomOffset @ self rightOffset!

rectangleFor: aView within: aRectangle context: aLayoutContext 
	"Private - Answer a new <Rectangle> generated from the receiver's framings applied to the
	specified parent extent."

	| rectangle context |
	context := FramingContext 
				layoutContext: aLayoutContext
				view: aView
				parentRectangle: aRectangle.
	rectangle := context rectangle.
	"frame the left and right edges"
	(leftFraming isIndependent or: [rightFraming isIndependent]) 
		ifTrue: 
			[leftFraming isIndependent 
				ifTrue: 
					[rectangle left: (leftFraming calculateEdge: leftOffset context: context).
					rectangle right: (rightFraming calculateEdge: rightOffset context: context)]
				ifFalse: 
					[rectangle right: (rightFraming calculateEdge: rightOffset context: context).
					rectangle left: (leftFraming calculateEdge: leftOffset context: context)]].

	"frame the top and bottom edges"
	(topFraming isIndependent or: [bottomFraming isIndependent]) 
		ifTrue: 
			[topFraming isIndependent 
				ifTrue: 
					[rectangle top: (topFraming calculateEdge: topOffset context: context).
					rectangle bottom: (bottomFraming calculateEdge: bottomOffset context: context)]
				ifFalse: 
					[rectangle bottom: (bottomFraming calculateEdge: bottomOffset context: context).
					rectangle top: (topFraming calculateEdge: topOffset context: context)]].
	^rectangle!

resolutionScaledBy: aPoint 
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by the 
	<Point> argument, which contains scaling ratios for x and y extents."

	leftFraming isProportional ifFalse: [leftOffset := (leftOffset * aPoint x) truncated].
	rightFraming isProportional ifFalse: [rightOffset := (rightOffset * aPoint x) truncated].
	topFraming isProportional ifFalse: [topOffset := (topOffset * aPoint y) truncated].
	bottomFraming isProportional 
		ifFalse: [bottomOffset := (bottomOffset * aPoint y) truncated]!

rightFraming
	"Answer the <Symbol> name of the framing calculation used to calculate the receiver's right edge."

	^rightFraming name!

rightFraming: aSymbol 
	aSymbol == #fixedViewRight ifTrue: [^self errorCantFixEdgeToItself].
	rightFraming := self class calculationClass perform: aSymbol!

rightOffset
	"Answer the framing offset for the receivers right edge.
	In the case of a parent relative framing constraint, this
	should be a <number> between 0 and 1, and in all other cases
	it should be an <integer>."

	^rightOffset!

rightOffset: aNumber 
	rightOffset := aNumber!

topFraming
	"Answer the <Symbol> name of the framing calculation used to calculate the receiver's top edge."

	^topFraming name!

topFraming: aSymbol 
	aSymbol == #fixedViewTop ifTrue: [^self errorCantFixEdgeToItself].
	topFraming := self class calculationClass perform: aSymbol!

topOffset
	"Answer the framing offset for the receivers top edge.
	In the case of a parent relative framing constraint, this
	should be a <number> between 0 and 1, and in all other cases
	it should be an <integer>."

	^topOffset!

topOffset: aNumber 
	topOffset := aNumber!

updateFor: aView context: aFramingContext 
	"Private - Update the receivers offsets from a new <Rectangle> within the parent extent,
	aPoint. This is used when repositioning or resizing the receiver, not to accomodate layout
	changes caused by resizing of the parent - i.e. this is mainly intended for design time
	support. The offset calculations have to work out what value offset is needed for that
	calculation to position the view so that it has the specified view rectangle, so in some
	sense the offset calculations are the inverse of the framing calculations. Note that the 
	rectangle has already been adjusted to allow for any insets specified for the container."

	"Calculate left and right offsets"

	leftFraming isIndependent 
		ifTrue: 
			[leftOffset := leftFraming calculateOffset: aFramingContext left context: aFramingContext.
			rightOffset := rightFraming calculateOffset: aFramingContext right context: aFramingContext]
		ifFalse: 
			[rightFraming isIndependent ifFalse: [self errorNoIndepentEdge].
			rightOffset := rightFraming calculateOffset: aFramingContext right context: aFramingContext.
			leftOffset := leftFraming calculateOffset: aFramingContext left context: aFramingContext].

	"Calculate top and bottom offsets"
	topFraming isIndependent 
		ifTrue: 
			[topOffset := topFraming calculateOffset: aFramingContext top context: aFramingContext.
			bottomOffset := bottomFraming calculateOffset: aFramingContext bottom context: aFramingContext]
		ifFalse: 
			[bottomFraming isIndependent ifFalse: [self errorNoIndepentEdge].
			bottomOffset := bottomFraming calculateOffset: aFramingContext bottom context: aFramingContext.
			topOffset := topFraming calculateOffset: aFramingContext top context: aFramingContext]!

updateFor: aView rectangle: aRectangle layoutContext: aLayoutContext 
	"Private - Update the framing constraints to a new rectangle."

	| parentView context parentRect |
	parentView := aView parentView.
	parentRect := (aLayoutContext clientRectangleOf: parentView) 
				insetBy: (parentView actualInsets: aLayoutContext).
	context := FramingContext 
				layoutContext: aLayoutContext
				view: aView
				parentRectangle: parentRect.
	context rectangle: aRectangle.
	self updateFor: aView context: context! !
!FramingConstraints categoriesForMethods!
bottomFraming!accessing!public! !
bottomFraming:!accessing!public! !
bottomOffset!accessing!public! !
bottomOffset:!accessing!public! !
errorCantFixEdgeToItself!exceptions!private! !
errorNoIndepentEdge!exceptions!private! !
framings!accessing!public! !
initialize!initializing!private! !
leftFraming!accessing!public! !
leftFraming:!accessing!public! !
leftOffset!accessing!public! !
leftOffset:!accessing!public! !
messages!accessing!public! !
offsets!accessing!public! !
rectangleFor:within:context:!operations!private! !
resolutionScaledBy:!geometry!private! !
rightFraming!accessing!public! !
rightFraming:!accessing!public! !
rightOffset!accessing!public! !
rightOffset:!accessing!public! !
topFraming!accessing!public! !
topFraming:!accessing!public! !
topOffset!accessing!public! !
topOffset:!accessing!public! !
updateFor:context:!geometry!private! !
updateFor:rectangle:layoutContext:!geometry!private! !
!

FramingConstraints methodProtocol: #messageSender attributes: #(#readOnly) selectors: #(#messages)!

!FramingConstraints class methodsFor!

calculationClass
	^FramingCalculation!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize!

stbConvert: anArray fromVersion: anInteger 
	"Private - Convert from earlier version view by updating and answering the array of instance
	variables, instVarArray. "

	| instVars |
	instVars := anArray.
	anInteger < 1 ifTrue: [instVars := self stbConvertFromVersion0: instVars].
	anInteger < 2 ifTrue: [instVars := self stbConvertFromVersion1: instVars].
	^instVars!

stbConvertFrom: anSTBClassFormat 
	"Convert from previous version resource. 
	Version Changes:
		1) removes deprecated framing symbols.
		2) framing inst. vars hold FramingCalculation objects rather than symbolic names of calculations."

	^
	[:data | 
	| answer instVars |
	instVars := self stbConvert: data fromVersion: anSTBClassFormat version.
	answer := self basicNew.
	1 to: instVars size do: [:i | answer instVarAt: i put: (instVars at: i)].
	answer]!

stbConvertFromVersion0: anArray 
	"Private - Convert from previous version resource. 
	Version 1 removes deprecated framing symbols."

	| conversionMap |
	conversionMap := ##((IdentityDictionary new)
				at: #relativeParentBottom put: #relativeParentHeight;
				at: #relativeParentTop put: #relativeParentHeight;
				at: #relativeParentLeft put: #relativeParentWidth;
				at: #relativeParentRight put: #relativeParentWidth;
				at: #relativeViewBottom put: #relativeParentHeight;
				at: #relativeViewTop put: #relativeParentHeight;
				at: #relativeViewLeft put: #relativeParentWidth;
				at: #relativeViewRight put: #relativeParentWidth;
				yourself).
	^anArray collect: [:each | conversionMap at: each ifAbsent: [each]]!

stbConvertFromVersion1: anArray 
	"Private - Migrate from previous schema. 
	Version 2 uses objects for framing calc's rather than holding symbolic names and looking
	up methods indirectly."

	^anArray 
		collect: [:each | (each isKindOf: Symbol) ifTrue: [FramingCalculation perform: each] ifFalse: [each]]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^2! !
!FramingConstraints class categoriesForMethods!
calculationClass!constants!private! !
new!instance creation!public! !
stbConvert:fromVersion:!binary filing!private! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbVersion!binary filing!public! !
!

