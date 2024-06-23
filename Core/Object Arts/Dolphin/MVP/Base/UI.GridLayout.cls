"Filed out from Dolphin Smalltalk"!

UI.LayoutManager
	subclass: #'UI.GridLayout'
	instanceVariableNames: 'rows columns horizontalGap verticalGap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.GridLayout guid: (Core.GUID fromString: '{87b4c64a-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.GridLayout comment: 'GridLayout implements a general purpose <layoutManager> to layout <view> objects within a <compositeView>. The managed views are arranged in a rectangular grid with either the number of rows or the number of columns specified by positive <integer> values of the #rows and #columns aspects, as follows:
	
	(rows,columns)	
	(0,0)			Invalid
	(>0,0)			The number of columns displayed is that required to show the sub-views in the specified number of rows.
	(>0,>0)			As above (i.e. the number of columns specified is ignored)
	(0,>0)			The number of rows displayed is that required to show the sub-views in the specified number of columns.

The views are resized to be identical in size and to fill as much of the available area within the container as possible. Any invisible views are ignored, and are not allocated a cell in the layout. Interstitial spacing can be specified with the #horizontalGap and #verticalGap aspects. 

Note that a GridLayout takes no notice of the #arrangement aspects of the views that it manages.

Instance Variables:
	rows			<integer>
	columns			<integer>
	horizontalGap	<integer>
	verticalGap		<integer>
'!

!UI.GridLayout categoriesForClass!MVP-Layout Managers-General! !

!UI.GridLayout methodsFor!

columns
	"Answers the number of columns for the receiver, or zero if unspecified."

	^columns!

columns: anInteger
	"Set the number of columns for the receiver to be the <integer> argument. Zero implies any
	number of columns. Note that if rows is non-zero, then this setting is ignored; the number
	of columns displayed will be the number required to display the visible sub-views in the
	configured number of rows."

	columns := anInteger!

horizontalGap
	"Answer the horizontal gap between items laid out by the receiver."

	^horizontalGap!

horizontalGap: anInteger 
	"Set the horizontal gap between items laid out by the receiver to be the <integer>
	argument."

	horizontalGap := anInteger!

initialize
	"Private - Initialize the receiver"

	super initialize.

	"Set up for a horizontal arrangement in one row."
	rows := 1.
	columns := 0.
	horizontalGap := 0.
	verticalGap := 0!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of the
	specified container view, laying out those sub-views into an appropriately sized grid."

	| subviews count nrows ncols cellWidth cellHeight y clientArea insets ox oy |
	subviews := self visibleSubViewsOf: aCompositeView context: aLayoutContext.
	count := subviews size.
	count > 0 ifFalse: [^self].
	nrows := self rows.
	ncols := self columns.
	nrows > 0 
		ifTrue: [ncols := (count + nrows - 1) // nrows]
		ifFalse: [nrows := (count + ncols - 1) // ncols].
	insets := aCompositeView actualInsets: aLayoutContext.
	clientArea := ((aLayoutContext clientRectangleOf: aCompositeView) insetBy: insets) extent.
	"#1645: Distribute excess area evenly among the cells"
	cellWidth := (clientArea x - ((ncols - 1) * self horizontalGap)) / ncols.
	cellHeight := (clientArea y - ((nrows - 1) * self verticalGap)) / nrows.
	y := 0.
	oy := insets top.
	1 to: nrows
		do: 
			[:i | 
			| h x k |
			x := 0.
			ox := insets left.
			h := (cellHeight * i - y) rounded.
			k := (i - 1) * ncols.
			1 to: ncols
				do: 
					[:j | 
					| w |
					k + j > count ifTrue: [^self].
					w := (cellWidth * j - x) rounded.
					aLayoutContext setView: (subviews at: k + j) rectangle: ((x + ox) @ (y + oy) extent: w @ h).
					x := x + w.
					ox := ox + self horizontalGap].
			y := y + h.
			oy := oy + self verticalGap]!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	| subviews count nrows ncols insets extent |
	subviews := self visibleSubViewsOf: aCompositeView context: aLayoutContext.
	count := subviews size.
	nrows := self rows.
	ncols := self columns.
	nrows > 0 
		ifTrue: [ncols := (count + nrows - 1) // nrows]
		ifFalse: [nrows := (count + ncols - 1) // ncols].
	"We need to know the maximum subview extent in order to calculate the grid size"
	extent := subviews inject: 0 @ 0 into: [:max :each | max max: (each layoutExtent: aLayoutContext)].
	insets := aCompositeView actualInsets: aLayoutContext.
	^(insets left + insets right + (ncols * extent x) + ((ncols - 1) * self horizontalGap)) 
		@ (insets top + insets bottom + (nrows * extent y) + ((nrows - 1) * self verticalGap))!

resolutionScaledBy: scale 
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale."

	horizontalGap := (horizontalGap * scale x) truncated.
	verticalGap := (verticalGap * scale y) truncated!

rows
	"Answers the number of rows for the receiver, or zero if unspecified."

	^rows!

rows: anInteger
	"Set the number of rows for the receiver to the positive <integer> argument. Zero implies
	any number of rows, in which case #columns must be non-zero. A non-zero setting overrides
	the #columns setting."

	rows := anInteger!

verticalGap
	"Answer the vertical gap between items laid out by the receiver."

	^verticalGap!

verticalGap: anInteger 
	"Set the vertical gap between items laid out by the receiver to be the <integer> argument."

	verticalGap := anInteger! !

!UI.GridLayout categoriesForMethods!
columns!accessing!public! !
columns:!accessing!public! !
horizontalGap!accessing!public! !
horizontalGap:!accessing!public! !
initialize!initializing!private! !
layoutContainer:context:!geometry!private! !
preferredLayoutExtentOf:context:!enquiries!public! !
resolutionScaledBy:!geometry!private! !
rows!accessing!public! !
rows:!accessing!public! !
verticalGap!accessing!public! !
verticalGap:!accessing!public! !
!

