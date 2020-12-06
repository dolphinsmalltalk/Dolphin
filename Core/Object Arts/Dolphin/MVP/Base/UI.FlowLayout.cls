"Filed out from Dolphin Smalltalk 7"!

UI.LayoutManager subclass: #'UI.FlowLayout'
	instanceVariableNames: 'horizontalGap verticalGap flags'
	classVariableNames: 'AlignmentMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AlignBottom' -> 16r8.
		'AlignHCenter' -> 16r1.
		'AlignLeft' -> 16r0.
		'AlignmentMask' -> 16rF.
		'AlignRight' -> 16r2.
		'AlignTop' -> 16r0.
		'AlignVCenter' -> 16r4
	}!
UI.FlowLayout guid: (Core.GUID fromString: '{87b4c648-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.FlowLayout comment: 'FlowLayout implements a general purpose <layoutManager> to layout <view> objects within a <compositeView>. The views are arranged in a similar manner to words on a page; from left to right and top to bottom. The FlowLayout fits as many visible views as possible into a single row before moving onto the next row. Any invisible views are ignored, and are allocated no space in the layout. You can specify the overall alignment of the rows to be #left, #centre or #right. The separation between adjacent components can be specified with the #horizontalGap and #verticalGap aspects. 

Note that a FlowLayout takes no notice of the #arrangement aspects of the views that it manages.

A typical use of a FlowLayout is in a parent Toolbar to manage a series of child bars. This allows the child bars to overflow onto subsequent lines as the parent is re-sized. You can see this effect in action in any of the development tool windows.

Instance Variables:
	horizontalGap	<integer> horizontal gap between adjacent views
	verticalGap 		<integer> vertical gap between adjacent views
	alignment		<Symbol> either #left, #center or #right
'!
!UI.FlowLayout categoriesForClass!MVP-Layout Managers-General! !
!UI.FlowLayout methodsFor!

alignment
	"Answers the alignment of the receiver. This will be either #left, #center or #right."

	^AlignmentMap keyAtValue: (flags bitAnd: AlignmentMask) ifAbsent: [#topLeft]!

alignment: aSymbol 
	"Sets the alignment of the receiver to aSymbol."

	flags := (flags maskClear: AlignmentMask) maskSet: (AlignmentMap at: aSymbol ifAbsent: [0])!

flowSplit: aCompositeView context: aLayoutContext
	"Private - Split the visible managed views in aContainerView into a sequenced collection of
	lines. Each line is represented by an <Association>, the key of which is a <Point>
	specifying the extent of the line i.e. its x-coordinate is the sum of the widths of the
	items on that line including any horizontal gap between items, and its y-coordinate is the
	height of the tallest item on that line. Note that the extent includes horizontal spacing
	between items, but not any vertical spacing between lines."

	| lines items maxWidth subviews lineWidth lineHeight |
	subviews := self visibleSubViewsOf: aCompositeView context: aLayoutContext.
	subviews isEmpty ifTrue: [^#()].
	lines := OrderedCollection new.
	maxWidth := ((aLayoutContext clientRectangleOf: aCompositeView)
				insetBy: (aCompositeView actualInsets: aLayoutContext)) width.
	lineWidth := 0 - horizontalGap.
	lineHeight := 0.
	items := OrderedCollection new.
	subviews do: 
			[:each |
			| itemExtent |
			itemExtent := each layoutExtent: aLayoutContext.
			(items notEmpty and: [lineWidth + horizontalGap + itemExtent x > maxWidth])
				ifTrue: 
					["Break onto new line"
					lines addLast: {lineWidth @ lineHeight. items}.
					items := OrderedCollection new.
					lineWidth := 0 - horizontalGap.
					lineHeight := 0].
			items addLast: each.
			lineWidth := lineWidth + horizontalGap + itemExtent x.
			lineHeight := lineHeight max: itemExtent y].
	items notEmpty ifTrue: [lines addLast: {lineWidth @ lineHeight. items}].
	^lines!

horizontalAlignment
	^flags bitAnd: ##(AlignLeft | AlignHCenter | AlignRight)!

horizontalGap
	"Answer the horizontal gap between items laid out by the receiver."

	^horizontalGap!

horizontalGap: anInteger 
	"Set the horizontal gap between items laid out by the receiver to be the <integer>
	argument."

	horizontalGap := anInteger!

initialize
	super initialize.
	horizontalGap := verticalGap := flags := 0!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of its the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	| halign insets clientRect calcX valign calcYOffset |
	insets := aCompositeView actualInsets: aLayoutContext.
	halign := self horizontalAlignment.
	clientRect := (aLayoutContext clientRectangleOf: aCompositeView) insetBy: insets.
	calcX := halign == AlignHCenter 
				ifTrue: [[:width | (clientRect width - width) // 2 + clientRect left]]
				ifFalse: 
					[halign == AlignRight 
						ifTrue: [[:width | clientRect right - width]]
						ifFalse: [[:width | clientRect left]]].
	valign := self verticalAlignment.
	calcYOffset := valign == AlignVCenter 
				ifTrue: [[:lineHeight :itemHeight | (lineHeight - itemHeight) // 2]]
				ifFalse: 
					[valign == AlignBottom 
						ifTrue: [[:lineHeight :itemHeight | lineHeight - itemHeight]]
						ifFalse: [[:lineHeight :itemHeight | 0]]].
	(self flowSplit: aCompositeView context: aLayoutContext) inject: clientRect top
		into: 
			[:y :eachLine | 
			| lineExtent lineHeight |
			lineExtent := eachLine at: 1.
			lineHeight := lineExtent y.
			(eachLine at: 2) inject: (calcX value: lineExtent x)
				into: 
					[:x :eachView | 
					| extent |
					extent := eachView layoutExtent: aLayoutContext.
					aLayoutContext setView: eachView
						rectangle: (x @ ((calcYOffset value: lineHeight value: extent y) + y) extent: extent).
					x + extent x + horizontalGap].
			y + lineHeight+ verticalGap]!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	| lines insets totalExtent |
	lines := self flowSplit: aCompositeView context: aLayoutContext.

	"If there are no lines in the receiver then use the existing extent of aContainerView"
	lines isEmpty ifTrue: [^aLayoutContext extentOf: aCompositeView].

	"Otherwise calculate the maximum extent of all the lines - i.e. the sum of all the line
	heights, allowing for any gap between them, and the maximum of the line widths"
	totalExtent := 0 @ 0.
	lines do: 
			[:each | 
			| lineExtent |
			lineExtent := each at: 1.
			totalExtent y: totalExtent y + lineExtent y + verticalGap.
			totalExtent x: (totalExtent x max: lineExtent x)].
	insets := aCompositeView actualInsets: aLayoutContext.
	^totalExtent + insets origin + insets corner!

resize: aSizedView to: aRectangle 
	"Resize the <view>, aView, to occupy the specified <Rectangle> in the container
	view who's layout is managed by the receiver."

	aSizedView rectangle: aRectangle.
	super resize: aSizedView to: aRectangle!

resolutionScaledBy: scale 
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by
	<Point> scale."

	horizontalGap := (horizontalGap * scale x) truncated.
	verticalGap := (verticalGap * scale y) truncated!

verticalAlignment
	^flags bitAnd: ##(AlignTop | AlignVCenter | AlignBottom)!

verticalGap
	"Answer the vertical gap between items laid out by the receiver."

	^verticalGap!

verticalGap: anInteger 
	"Set the vertical gap between items laid out by the receiver to be the <integer> argument."

	verticalGap := anInteger! !
!UI.FlowLayout categoriesFor: #alignment!accessing!public! !
!UI.FlowLayout categoriesFor: #alignment:!accessing!public! !
!UI.FlowLayout categoriesFor: #flowSplit:context:!helpers!private! !
!UI.FlowLayout categoriesFor: #horizontalAlignment!accessing!private! !
!UI.FlowLayout categoriesFor: #horizontalGap!accessing!public! !
!UI.FlowLayout categoriesFor: #horizontalGap:!accessing!public! !
!UI.FlowLayout categoriesFor: #initialize!initializing!private! !
!UI.FlowLayout categoriesFor: #layoutContainer:context:!geometry!private! !
!UI.FlowLayout categoriesFor: #preferredLayoutExtentOf:context:!enquiries!public! !
!UI.FlowLayout categoriesFor: #resize:to:!geometry!public! !
!UI.FlowLayout categoriesFor: #resolutionScaledBy:!geometry!private! !
!UI.FlowLayout categoriesFor: #verticalAlignment!accessing!private! !
!UI.FlowLayout categoriesFor: #verticalGap!accessing!public! !
!UI.FlowLayout categoriesFor: #verticalGap:!accessing!public! !

!UI.FlowLayout class methodsFor!

initialize
	"
		self initialize
	"

	AlignmentMap := IdentityDictionary new
				at: #leftCenter put: AlignLeft | AlignVCenter;
				at: #rightCenter put: AlignRight | AlignVCenter;
				at: #topCenter put: AlignHCenter | AlignTop;
				at: #bottomCenter put: AlignHCenter | AlignBottom;
				at: #center put: AlignHCenter | AlignVCenter;
				at: #topLeft put: AlignLeft | AlignTop;
				at: #topRight put: AlignRight | AlignTop;
				at: #bottomLeft put: AlignLeft | AlignBottom;
				at: #bottomRight put: AlignRight | AlignBottom;
				shrink!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier schema.
	1) Former 'alignment' instance variable becomes 'flags', in which alignment is encoded."

	^
	[:data |
	| newInstance |
	newInstance := self new.
	newInstance
		horizontalGap: data first;
		verticalGap: data second;
		alignment: (##(IdentityDictionary new
					at: #left put: #leftTop;
					at: #center put: #topCenter;
					at: #right put: #topRight;
					yourself) at: data third).
	newInstance]!

stbVersion
	^1! !
!UI.FlowLayout class categoriesFor: #initialize!development!helpers!public! !
!UI.FlowLayout class categoriesFor: #stbConvertFrom:!binary filing!public! !
!UI.FlowLayout class categoriesFor: #stbVersion!constants!public! !

