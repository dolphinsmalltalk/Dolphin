"Filed out from Dolphin Smalltalk"!

View subclass: #MoenTreeView
	instanceVariableNames: 'anchorNode getTextBlock getImageBlock mtvFlags leading imageManager calculatedExtent parentSpacing selection linePen iconExtent maxTextExtent dtFlags margin textInset _mtvReserved0 _mtvReserved1 _mtvReserved2'
	classVariableNames: 'AutoExpandingMask HasButtonsMask MultilineMask SingleLineMask ViewModes'
	poolDictionaries: 'ThemeConstants'
	classInstanceVariableNames: ''!

MoenTreeView guid: (GUID fromString: '{68f4ac03-2f95-11d3-93ba-00a024ca708a}')!

MoenTreeView addClassConstant: 'AutoExpandingMask' value: 16r8000000!
MoenTreeView addClassConstant: 'HasButtonsMask' value: 16r1!
MoenTreeView addClassConstant: 'MultilineMask' value: 16rA010!
MoenTreeView addClassConstant: 'SingleLineMask' value: 16r8024!

MoenTreeView comment: 'MoenTreeView is a <treeView> for displaying a <treeModel> in a graphic layout. It support the single <selectableItems> protocol for handling item selection. MoenTreeViews can be used to display any type of object with the exception of the ''nil'' object which is used to distinguish the root.

For more information on the underlying algorithms see:
	''Drawing Dynamic Trees''
	Sven Moen
	IEEE Software, July 1990
The methods derived from the article''s functions are within the ''tree layout'' category.

A MoenTreeView can be used as a substitute for the standard <TreeView> in the majority of applications.

Note: MoenTreeViews do not implement their own scrolling and must be embedded inside a ScrollingDecorator container (e.g. use the ''CompositePresenter.Scrolling container'' view resource).

Instance Variables:
	anchorNode		<MoenTreeNode> the true, invisible, root of the tree which is the parent of the visible ''roots''.
	getTextBlock 	<monadicValuable> extracts <String> text from element for node label
	getImageBlock 	<monadicValuable> extracts <integer> image index from element for node label 
	reserved1		Unused, but reserved for future use.
	leading 			<integer> external text leading cached from metrics of current font.
	imageManager 	<ImageManager> holding images to use for display.
	calculatedExtent 	<Point> cached preferred extent.
	parentSpacing 	<integer> distance between a node and the ends of its parents label (i.e. horizontal line length)
	selection 		<MoenTreeNode> which is the selected node, or nil if no selection.
	linePen 			<Pen> used to draw lines connecting nodes.
	iconExtent 		<Point> size of iconic images (common across all nodes and not related to font used).
	maxTextExtent	<Point> maximum extent of the text part of the label. Text is truncated with ellipses if exceeded.
	dtFlags			<integer> flags for the DrawText() API call used to paint the node labels.
	margin			<Point>
	textInset		<Point>
	theme			<ExternalHandle>. Theme data for TreeView, if running on XP with themes enabled.

Class Variables:
	MultilineMask		<integer>. DrawText() flags combination for multiline text node labels.
	SingleLineMask		<integer>. DrawText() flags combination for singleline text node labels.
'!

!MoenTreeView categoriesForClass!MVP-Views! !

!MoenTreeView methodsFor!

addTreeFor: anObject parentNode: aMoenTreeNode
	"Private - Add a new node for anObject and for each of its children if auto-expanding,, under the 
	<MoenTreeNode>, parentNode, and to the left of the <MoenTreeNode>, sibling. Answer the new 
	<MoenTreeNode>. Note that the original parent (i.e. parentNode at the start of the recursion) will 
	not be wired up to point to the new child on return from this message."

	| node |
	node := MoenTreeNode object: anObject parent: aMoenTreeNode.
	self autoExpandNode: node.
	^node!

anchorNode
	^anchorNode!

applyFont
	"Private - The receiver's font has been changed. We need to regenerate
	our contours as it is likely that the text extents will have changed."

	self invalidateGeometry!

attachParent: aMoenTreeNode height: anInteger
	"Private - Extend the branch contour to enclose the <MoenTreeNode>, tNode."

	| y1 y2 nodeExtent nodeWidth nodeHeight contour |
	nodeExtent := aMoenTreeNode extent.
	nodeWidth := nodeExtent x.
	nodeHeight := nodeExtent y.
	y2 := anInteger - nodeHeight bitShift: -1.
	y1 := y2 + nodeHeight - anInteger.
	aMoenTreeNode child offset: (parentSpacing + nodeWidth) @ y1.
	contour := aMoenTreeNode contour.
	contour
		upperHead: (MoenLink 
					x: nodeWidth
					y: 0
					nextLink: (MoenLink 
							x: parentSpacing
							y: y1
							nextLink: contour upperHead));
		lowerHead: (MoenLink 
					x: nodeWidth
					y: 0
					nextLink: (MoenLink 
							x: parentSpacing
							y: y2
							nextLink: contour lowerHead))!

autoExpandNode: aMoenTreeNode 
	"Private - Expand the specified node, but only if in 'autoexpand' mode.
	Implementation Note: To avoid an infinite recursion we avoid auto-expanding objects
	that already appear in the parent chain."

	| parent discriminator object |
	self isAutoExpanding ifFalse: [^self].
	parent := aMoenTreeNode parent.
	object := aMoenTreeNode object.
	discriminator := self model searchPolicy.
	[parent == anchorNode] whileFalse: 
			[(discriminator compare: object with: parent object) ifTrue: [^self].
			parent := parent parent].
	self populateNode: aMoenTreeNode.
	aMoenTreeNode isExpanded: true!

basicExpandNode: aMoenTreeNode
	| topMost node |
	aMoenTreeNode hasExpanded ifFalse: [self populateNode: aMoenTreeNode].
	node := aMoenTreeNode.
	
	[node isExpanded 
		ifFalse: 
			[topMost := node.
			node isExpanded: true].
	(node := node parent) isNil] 
			whileFalse.
	^topMost!

basicSelection: aMoenTreeNode cause: aSymbol 
	"Private - Set the selection to the <MoenTreeNode> argument 
	and update the view. Answer the new selection."

	selection == aMoenTreeNode 
		ifFalse: 
			[(aSymbol == #unknown or: [self onSelChanging: aMoenTreeNode cause: aSymbol]) 
				ifTrue: 
					[| oldSelection |
					oldSelection := self selectedNode.
					oldSelection notNil ifTrue: [self invalidateRect: oldSelection rectangle erase: true].
					selection := aMoenTreeNode == anchorNode ifFalse: [aMoenTreeNode].

					"ensure new selection is visible - might need to expand the tree"
					selection notNil 
						ifTrue: 
							[self expandNode: selection parent.
							self invalidateRect: selection rectangle erase: false.
							self ensureRectangleVisible: selection rectangle].
					self onSelChanged]].
	^selection!

bridge: line1 and: x1 and: y1 and: line2 and: x2 and: y2 
	"Private - "

	| dy dx r x y |
	x := line2 x.
	dx := x2 + x - x1.
	y := line2 y.
	x == 0 
		ifTrue: [dy := y]
		ifFalse: 
			[| s |
			s := dx * y.
			dy := s // x].
	r := MoenLink 
				x: dx
				y: dy
				nextLink: line2 nextLink.
	line1 nextLink: (MoenLink 
				x: 0
				y: y2 + y - dy - y1
				nextLink: r).
	^r!

buttonSize
	"Answer the width and height of the expand/collapse buttons as an <integer> number of pels."

	^9!

calculateClientExtent
	"Private - Generate the receiver's calculateExtent value and also the final positions of each
	tree."

	| rootPosition |
	rootPosition := 0.
	calculatedExtent := margin.
	anchorNode childrenDo: 
			[:rootNode | 
			| top bottom width |
			self generatePosition: rootNode absolute: margin.
			top := bottom := width := 0.
			rootNode visiblePreOrderDo: 
					[:node | 
					| extent pos |
					pos := node position.
					extent := node extent.
					width := width max: pos x + extent x.
					top := top min: pos y - extent y.
					bottom := bottom max: pos y + extent y].
			rootPosition := rootPosition + top abs.
			calculatedExtent := (calculatedExtent x max: width) 
						@ (calculatedExtent y max: rootPosition + bottom).
			rootNode visiblePreOrderDo: 
					[:node | 
					| pos |
					pos := node position.
					node position: pos x @ (pos y + rootPosition)].
			rootPosition := rootPosition + bottom]!

calculateExtent: aLayoutContext 
	"Private - Answer the required size of the receiver based on the current contents."

	calculatedExtent isNil ifTrue: [self updateGeometry].
	^self calcExtentFromClientExtent: calculatedExtent!

calculateNodeExtents
	"Private - Generate the cached extent of each node in the tree."

	leading := nil.	"Cause leading to be recalculated"
	self calculateNodeExtents: anchorNode!

calculateNodeExtents: aMoenTreeNode
	"Private - Generate the cached extent of each node in the tree below
	the <MoenTreeNode>, node, inclusive."

	| canvas |
	canvas := self canvas.
	canvas font: self actualFont.
	self calculateNodeExtents: aMoenTreeNode forCanvas: canvas.
	canvas free!

calculateNodeExtents: aMoenTreeNode forCanvas: aCanvas 
	"Private - Generate the cached extent of each node in the tree including and below the
	<MoenTreeNode> argument using the <Canvas> argument as the hypothetical display medium."

	| getImage dtf rect lead2 getText hasIcons |
	getText := self getTextBlock.
	getImage := self getImageBlock ?? [:each | nil].
	rect := RECT new.
	dtf := (dtFlags maskSet: DT_CALCRECT) maskClear: DT_VCENTER.
	lead2 := (self leadingForCanvas: aCanvas) * 2.
	hasIcons := self hasIcons.
	aMoenTreeNode visiblePreOrderDo: 
			[:each | 
			each extent: (each object 
						ifNil: [0 @ 0]
						ifNotNil: 
							[:elem | 
							| txt nodeExtent |
							rect
								right: maxTextExtent x;
								bottom: 0.
							txt := (getText value: elem) displayString.
							aCanvas 
								formatText: (txt isEmpty ifTrue: ['.'] ifFalse: [txt])
								in: rect
								flags: dtf.
							nodeExtent := (rect right + lead2 x) @ (rect bottom + lead2 y + 1) min: maxTextExtent.
							(hasIcons and: [(getImage value: elem) notNil]) 
								ifTrue: [(textInset x + nodeExtent x) @ (iconExtent y max: nodeExtent y)]
								ifFalse: [nodeExtent]])]!

collapse
	"Collapse the selected node, hiding any children and displaying a '+' button
	if there are any."

	Cursor wait showWhile: [self collapseNode: self selectedNode cause: #keyboard]!

collapse: anObject
	"Collapse the displayed hierarchy below anObject."

	self collapseNode: (self nodeForObject: anObject) cause: #unknown!

collapseAll
	Cursor wait showWhile: [self collapseAll: self selectionOrNil]!

collapseAll: anObject
	"Expand the complete hierarchy below anObject (i.e. expand the node and, recursively, 
	all its sub-nodes). If anObject is nil then expand the entire tree. May also need to expand
	the parent tree to the object."

	anObject isNil 
		ifTrue: 
			["collapseSubtree: on the anchorNode would make roots disappear, not what we want"

			anchorNode childrenDo: [:each | self collapseSubtree: each]]
		ifFalse: [self collapseSubtree: (self nodeForObject: anObject)]!

collapseNode: aMoenTreeNode cause: aSymbol 
	"Private - Collapse the specified <MoenTreeNode> to hide its children. 
	If the selected node is a direct or indirect child of the node which is collapsed
	then selection must be moved to the nearest visible parent."

	| selectionIsChild |
	aMoenTreeNode isExpanded ifFalse: [^self].
	selectionIsChild := selection notNil and: [aMoenTreeNode isChild: selection].
	aMoenTreeNode isExpanded: false.
	self updateNode: aMoenTreeNode.
	selectionIsChild 
		ifTrue: 
			["Collapsing the node has made the previously visible selection disappear
					 so attempt to select another, note though that the user may be able
					 to refuse the selection change, in which case it will become invisible"
			self basicSelection: aMoenTreeNode cause: aSymbol].
	self ensureNodeVisible: aMoenTreeNode!

collapseSubtree: aMoenTreeNode
	"Private - Collapse the specified <MoenTreeNode> and, recursively, all
	its children. If the selected node is a direct or indirect child of the node 
	which is collapsed then selection must be moved to the nearest visible parent."

	aMoenTreeNode isExpanded 
		ifTrue: 
			[aMoenTreeNode 
				childrenDo: [:eachChild | eachChild endOrderDo: [:eachSubchild | eachSubchild isExpanded: false]].
			self collapseNode: aMoenTreeNode cause: #unknown]!

connectModel
	"Connect the receiver to its model, wiring events, etc."

	self model 
		when: #treeChanged: send: #onTreeChanged: to: self;
		when: #item:addedInParent: send: #onItem:addedInParent: to: self;
		when: #item:removedFromParent: send: #onItem:removedFromParent: to: self;
		when: #item:movedToParent: send: #onItem:movedToParent: to: self;
		when: #itemUpdated: send: #onItemUpdated: to: self!

defaultDrawTextFlags
	"Private - Answer the default set of DT_xxx flags passed to DrawTextEx() when painting
	the labels of the receiver's nodes (text labels which are too large will be truncated 
	with ellipsis, only a single line of centred text is drawn)."

	^SingleLineMask!

defaultGetImageBlock
	"Private - Answer a default block to use to find out the image index of an object 
	that will be placed in the receiver. By default we assume icons can be used
	for images."

	^self class!

defaultGetTextBlock
	"Private - Answer a default block to use to find out the children of an object
	that will be placed in the receiver."

	^[:item | item displayString]!

dragLeave: session 
	"The drag operation described by the <DragDropSession> session has moved 
	to a new position outside the receiver's window. Remove any drop highlighting
	etc."

	session hideCursorWhile: [self hideDropHighlight]!

dragOver: session 
	"The drag operation described by the <DragDropSession>. session,
	has moved to a new position over the receiver's window.
	Implementation Note: Override in order to provide drop target highlighting
	and to suggest a reasonable drop target for most cases (the item under the
	cursor)."

	| node |
	node := self nodeAtPosition: (session dragPointInView: self) ifNone: [].
	session suggestedTarget: (node isNil ifFalse: [node object]).
	super dragOver: session.
	node = self dropHighlight 
		ifFalse: 
			[session hideCursorWhile: 
					[self hideDropHighlight.
					node isNil ifFalse: [self showDropHighlight: node]]]!

drop: session 
	"The drag operation described by the <DragDropSession>, session, has 
	culminated in a drop over the receiver. Answer whether the drop was successfull
	so that the Session knows whether to cut the item from the 	drag source in the case 
	of a #move operation.
	Implementation Note: We must remove the drop highlight."

	session hideCursorWhile: [self hideDropHighlight].
	^super drop: session!

dropHighlight
	"Private - Answers the current drop highlight for within the receiver or
	nil if there is none."

	^self propertyAt: #dropHighlight ifAbsent: [].!

editSelectionLabel
	"Initiate an in-place edit of the currently selected label."

	| newName oldName selNode selObj |
	(selNode := self selectedNode) isNil ifTrue: [^self errorNoSelection].
	selObj := selNode object.
	(self presenter onAboutToEditLabel: selObj) ifTrue: [^self].
	oldName := (self getTextBlock value: selObj) displayString.
	#todo.	"Use an edit control to perform an in-place edit"
	newName := Prompter prompt: 'New name:' caption: 'Rename ' , oldName.
	(newName isNil or: [newName = oldName]) ifTrue: [^self].
	self presenter onLabelOf: selObj editedTo: newName!

ensureNodeVisible: aMoenTreeNode 
	self ensureRectangleVisible: aMoenTreeNode rectangle!

ensureSelectionVisible
	"Ensure the selection is within the visible part of the window, scrolling as necessary."

	self selectedNode ifNotNil: [:selNode | self ensureNodeVisible: selNode]!

errorNoSelection
	"Private - Raise an error to the effect that there is no selection."

	^self error: 'No object selected'!

expand
	"Expand the selected node, hiding any children and displaying a '-' button.
	Implementation Note: This may take a while, so display the wait cursor."

	Cursor wait showWhile: [self expandNode: self selectedNode]!

expand: anObject
	"Expand anObject to show its children. Also expands the parent chain
	if necessary."

	anObject isNil ifFalse: [self expandNode: (self nodeForObject: anObject)]!

expandAll
	"Expand the entire tree below the current selection."

	Cursor wait showWhile: [self expandAll: self selectionOrNil]!

expandAll: anObject
	"Expand the complete hierarchy below anObject (i.e. expand the node and, recursively, 
	all its sub-nodes). If anObject is nil then expand the entire tree. May also need to expand
	the parent tree to the object.
	Implementation Note: #nodeForObject: will locate the anchorNode when searching for
	nil and hence expand the whole tree."

	self expandSubtree: (self nodeForObject: anObject)!

expandNode: aMoenTreeNode
	"Private - Expand the specified <MoenTreeNode> to show its children, expanding any
	parent nodes which are not currently expanded."

	| topMost |
	topMost := self basicExpandNode: aMoenTreeNode.
	topMost isNil 
		ifFalse: 
			[self updateNode: topMost.
			self ensureNodeVisible: aMoenTreeNode]!

expandSubtree: aMoenTreeNode 
	"Private - Expand the <MoenTreeNode> argument and all its sub-nodes."

	aMoenTreeNode preOrderDo: [:each | self basicExpandNode: each].
	self updateNode: aMoenTreeNode.
	self ensureNodeVisible: aMoenTreeNode!

findNodeForObject: anObject
	"Private - Answer the first node in the receiver located using a pre-order traversal from the roots,
	for which the receiver's model's search policy evaluates to true for the <Object> argument..
	If there is no matching node then answer nil. Note that no check is made to verify that the object 
	is actually part of the model."

	"We shouldn't have to special case nil since the anchorNode is associated with that in the tree, but
	 since the search policy might be user supplied it might not consider nil as comparing equal to nil"

	^anObject isNil 
		ifTrue: [anchorNode]
		ifFalse: 
			[self model 
				keyOfNode: anObject
				in: anchorNode
				ifAbsent: []]!

generateAbsolutes
	"Private - Generate the absolute positions of each tree and the preferred view extent.
	Also cache clip rectangles which enclose a node and all its sub-nodes."

	self calculateClientExtent.
	self generateNodeClipRects!

generateNodeClipRects
	"Private - Generate a clip rectangle for each sub-tree, which is the boundary of the sub-trees
	contour, and contains the clip rectangles of all its children. This information is subsequently
	used to work out which trees overlap an area of the screen or contain a <Point>, e.g. when
	repainting."

	anchorNode calculateClipRect!

generatePosition: aMoenTreeNode absolute: aPoint 
	"Private - Recursively set the position of the <MoenTreeNode> argument, and all its 
	visible children rooted at the <Point> argument."

	| pos |
	pos := aPoint.
	aMoenTreeNode position: pos.
	aMoenTreeNode visibleChildrenDo: 
			[:each | 
			pos := pos + each offset.
			self generatePosition: each absolute: pos]!

getImageBlock
	"Answer the <monadicValuable> used to get the <integer> index of the image
	in the receiver's image list that should be displayed for an element in the tree."

	^getImageBlock
!

getImageBlock: aMonadicValuable
	"Set the block to use to find out the image index of an object that will
	be placed in the receiver"

	getImageBlock := aMonadicValuable!

getTextBlock
	"Answer the <monadicValuable> used to get the text to display for an 
	element in the tree."

	^getTextBlock

!

getTextBlock: aMonadicValuable
	"Set the block to use to find out the text to display for an object that will
	be placed in the receiver"

	getTextBlock := aMonadicValuable
!

hasButtons
	"Answer whether the receiver has expand/contract buttons associated
	with its nodes that the user can single click over to expand/contract the
	node's children."

	^mtvFlags anyMask: HasButtonsMask!

hasButtons: aBoolean
	"Set whether the receiver has expand/contract buttons associated
	with its nodes that the user can single click over to expand/contract the
	node's children. Can be changed dynamically."

	mtvFlags := mtvFlags mask: HasButtonsMask set: aBoolean.
	self isOpen ifTrue: [self invalidate]!

hasChildren: aMoenTreeNode
	"Private - Answer whether the <MoenTreeNode> argument has (or could have) any child nodes."

	^aMoenTreeNode hasExpanded 
		ifTrue: [aMoenTreeNode child notNil]
		ifFalse: [self model hasChildren: aMoenTreeNode object]!

hasIcons
	^iconExtent > 0 and: [getImageBlock notNil]!

hasSelection
	"Answer true if the receiver has a selection."

	^self selectedNode notNil!

hasWordWrap
	"Private - Answer whether the receiver will wrap the text of nodes which is too large to fit within
	the maximum permissible text width (see also #maxTextExtent)."

	^dtFlags noMask: DT_SINGLELINE
!

hasWordWrap: aBoolean
	"Private - Set whether the receiver will wrap overflowing text, or not.
	If the text overflows in non-word wrap mode, the text will be truncated with
	ellipses appended to signify that there is some text missing."

	dtFlags := aBoolean 
				ifTrue: [(dtFlags maskClear: SingleLineMask) maskSet: MultilineMask]
				ifFalse: [(dtFlags maskClear: MultilineMask) maskSet: SingleLineMask]!

hideDropHighlight
	"Private - Hides any drop highlight within the receiver."

	| node |
	node := self dropHighlight.
	node notNil 
		ifTrue: 
			[| canvas |
			canvas := self canvas.
			canvas invertRectangle: node rectangle.
			canvas free].
	self removePropertyAt: #dropHighlight ifAbsent: []!

hitTest: position
	"Private - Search for the node in the receiver that coincides with aPoint. Answer nil if 
	no node coincides, or an association the key of which is the symbolic hit type, and the 
	value of which is the node which was hit."

	"Note that rather than a simple test against each the keys of trees we use
	a recursive method which uses the pre-computed clip rectangle of a node
	and all its nodes. This makes for a very fast search, even in massive trees,
	because we can immediately exclude branches of the tree which do not
	contain the point."

	^self hitTest: position search: anchorNode!

hitTest: aPoint search: node 
	"Private - Search for the node in the receiver that coincides with aPoint, restricting
	search to the <MoenTreeNode>, node, and all its children. Answer nil if no node coincides,
	or an association the key of which is the symbolic hit type, and the value of which is the
	node which was hit."

	(node clip containsPoint: aPoint) ifFalse: [^nil].
	(node rectangle containsPoint: aPoint) 
		ifTrue: [^#item -> node]
		ifFalse: 
			[(self hasButtons and: [node buttonRectangle containsPoint: aPoint]) 
				ifTrue: [^#button -> node]
				ifFalse: 
					[node 
						visibleChildrenDo: [:child | (self hitTest: aPoint search: child) ifNotNil: [:hit | ^hit]]]].
	^nil!

iconExtent: aPoint
	"Private - Set the extent of the iconic images used when painting the node labels.
	Also take this opportunity to cache the inset of the text that is therefore necessary."

	iconExtent := aPoint.
	textInset := (iconExtent x + 1) @ 0.
	self invalidateGeometry!

imageManager
	"Answer the <ImageManager> which holds the receiver's images."

	^imageManager!

imageManager: anImageManager
	"Set the <ImageManager> which holds the receiver's images."

	imageManager := anImageManager!

imagePositionIn: aRectangle 
	^aRectangle left @ (aRectangle top + ((aRectangle height - iconExtent y + 1) // 2))!

includesItem: anObject 
	"Answer whether the argument is displayed in this tree."

	^(self nodeForObject: anObject ifAbsent: []) notNil!

initialize
	"Private - Initialize the receiver"

	super initialize.
	getTextBlock := self defaultGetTextBlock.
	getImageBlock := self defaultGetImageBlock.
	imageManager := IconImageManager current.
	self linePen: (Pen 
				withStyle: PS_SOLID
				width: 1
				color: Color face3d).
	anchorNode := MoenTreeNode object: nil parent: nil.
	anchorNode
		hasExpanded: true;
		isExpanded: true.
	parentSpacing := 20.
	self viewMode: #smallIcons.
	self usePreferredExtent: true.
	maxTextExtent := 9999 @ 9999.
	dtFlags := self defaultDrawTextFlags.
	margin := 10 @ 10.
	mtvFlags := AutoExpandingMask!

invalidateGeometry
	"Private - The receiver has been modified in a manner which affects the tree
	geometry (e.g. the font has been changed, or a node inserted). We need to regenerate
	our contours as the likelihood is that the text extents will have changed, but defer
	this to avoid excessive geometry recalculations."

	calculatedExtent := nil.

	self invalidateLayout; invalidate!

invalidateItem: element
	"Redraw the receiver's <Object> item, element.
	If the element is not currently visible in the tree, then does nothing."

	self
		invalidateItem: element
		andChildren: false
		imagesOnly: false!

invalidateItem: element andChildren: andChildren imagesOnly: aBoolean 
	"Redraw the receiver's <Object> item, element, optionally including all sub-nodes depending
	on the <Boolean>, andChildren. If the element is not in the tree, do nothing."

	(self findNodeForObject: element) 
		ifNotNil: 
			[:node | 
			andChildren 
				ifTrue: [self invalidateTree: node imagesOnly: aBoolean]
				ifFalse: [self invalidateNode: node imagesOnly: aBoolean]]!

invalidateNode: aMoenTreeNode imagesOnly: aBoolean
	"Private - Invalidate the <MoenTreeNode>, node, which is a node in the receiver.
	If the <Boolean>, imagesOnly, is true then only the images are invalidated."

	| rect |
	rect := aMoenTreeNode rectangle.
	self invalidateRect: (aBoolean 
				ifTrue: [(self imagePositionIn: rect) extent: iconExtent]
				ifFalse: [rect])!

invalidateTree: rootNode imagesOnly: imagesOnly
	"Private - Invalidate the labels of the tree starting at the <MoenTreeNode>, rootNode.
	If the <Boolean>, imagesOnly, is true then only the images are invalidated."

	| childNode |
	self invalidateNode: rootNode imagesOnly: imagesOnly.
	childNode := rootNode child.
	[childNode notNil] whileTrue: [
		self invalidateTree: childNode imagesOnly: imagesOnly.
		childNode := childNode sibling]!

isAutoExpanding
	"Answer whether the receiver fully expands every sub-tree added to it."

	^mtvFlags anyMask: AutoExpandingMask
!

isAutoExpanding: aBoolean
	mtvFlags := mtvFlags mask: AutoExpandingMask set: aBoolean!

itemFromPoint: aPoint 
	"Private - Answer the node of the receiver under the <Point> argument or nil if none."

	^(self hitTest: aPoint) ifNotNil: [:assoc | assoc value]!

join: aMoenTreeNode
	"Private - Join the contours of all the children of the <MoenTreeNode> argument,
	forming a single minimal contour from them. Answer the height of the contour."

	| totalHeight height childNode |
	childNode := aMoenTreeNode child.
	aMoenTreeNode contour: childNode contour copy.
	totalHeight := height := childNode extent y.
	childNode := childNode sibling.
	[childNode notNil] whileTrue: 
			[| d |
			d := self merge: aMoenTreeNode contour with: childNode contour.
			childNode offset: 0 @ (d + height).
			height := childNode extent y.
			totalHeight := totalHeight + d + height.
			childNode := childNode sibling].
	^totalHeight!

layoutLeaf: aMoenTreeNode
	"Private - Generate a contour for the <MoenTreeNode> argument, 
	that surrounds all but the west face."

	| extent width height contour |
	extent := aMoenTreeNode extent.
	width := extent x.
	height := extent y.
	(contour := aMoenTreeNode contour)
		upperTail: (MoenLink 
					x: width
					y: 0
					nextLink: nil);
		upperHead: contour upperTail;
		lowerTail: (MoenLink 
					x: 0
					y: height negated
					nextLink: nil);
		lowerHead: (MoenLink 
					x: width
					y: 0
					nextLink: contour lowerTail)!

leadingForCanvas: aCanvas
	leading isNil 
		ifTrue: 
			[leading := aCanvas textMetrics tmExternalLeading.
			leading := (leading + 1) @ leading].
	^leading!

linePen
	"Private - Answer the <Pen> used to draw the connecting lines between parent
	and child nodes."

	^linePen!

linePen: aPen
	linePen := aPen!

linkChild: aMoenTreeNode toParent: parentMoenTreeNode
	"Private - The first <MoenTreeNode> argument has been added (or perhaps moved) into this 
	Moen tree beneath the second <MoenTreeNode> argument. The node is inserted into the 
	children of the parent in the same position that it occuppies in the model. The contours are 
	adjusted to accomodate the new node if the parent is currently expanded."

	| siblingNode previousSibling |
	siblingNode := parentMoenTreeNode child.
	siblingNode isNil 
		ifFalse: 
			[| index siblings |
			siblings := self model childrenOf: parentMoenTreeNode object.
			index := self model 
						keyOfNode: aMoenTreeNode object
						in: siblings
						ifAbsent: [^siblings errorNotFound: aMoenTreeNode object].
			index - 1 timesRepeat: 
					[previousSibling := siblingNode.
					siblingNode := siblingNode sibling]].
	self 
		linkChild: aMoenTreeNode
		toParent: parentMoenTreeNode
		after: previousSibling!

linkChild: aMoenTreeNode toParent: parentMoenTreeNode after: siblingMoenTreeNode 
	"Private - The first <MoenTreeNode> argument has been added (or perhaps moved) into this 
	Moen tree beneath the second <MoenTreeNode> argument. The contours are adjusted to 
	accomodate the new node if the parent is currently expanded."

	| visible |
	self assert: [parentMoenTreeNode hasExpanded].
	(visible := parentMoenTreeNode isExpanded) ifTrue: [self unzip: parentMoenTreeNode].
	siblingMoenTreeNode isNil 
		ifTrue: 
			[aMoenTreeNode sibling: parentMoenTreeNode child.
			parentMoenTreeNode child: aMoenTreeNode]
		ifFalse: 
			[aMoenTreeNode sibling: siblingMoenTreeNode sibling.
			siblingMoenTreeNode sibling: aMoenTreeNode].
	aMoenTreeNode parent: parentMoenTreeNode.
	visible 
		ifTrue: 
			[self treeLayout: aMoenTreeNode.
			self zip: parentMoenTreeNode]!

margin
	"Answer a <Point> which specifies the width and height of the empty margin	
	around the Moen tree in its client area."

	^margin!

margin: aPoint
	"Set the <Point> which specifies the width and height of the empty margin	
	around the Moen tree in its client area."

	margin := aPoint!

maxTextExtent
	"Private - Answer a <Point> which is the maximum extent of the text labels displayed in the receiver."

	^maxTextExtent!

maxTextExtent: aPoint
	"Private - Set the maximum extent of any text displayed as the label of a node
	in the receiver. When the text exceeds the width of the extent it may either
	be wrapped or truncated depending on the value of the #hasWordWrap aspect.
	Truncation may also occur when the number of whole lines required to display
	the text exceeds the vertical extent."

	maxTextExtent := aPoint.
	self invalidateGeometry!

merge: contour1 with: contour2 
	"Private - Form the union of two contours"

	| x y total upper lower |
	x := y := total := 0.
	upper := contour1 lowerHead.
	lower := contour2 upperHead.
	"compute offset total"
	[lower notNil and: [upper notNil]] whileTrue: 
			[| d |
			d := self 
						offset: x
						and: y
						and: lower x
						and: lower y
						and: upper x
						and: upper y.
			y := y + d.
			total := total + d.
			x + lower x <= upper x 
				ifTrue: 
					[y := y + lower y.
					x := x + lower x.
					lower := lower nextLink]
				ifFalse: 
					[y := y - upper y.
					x := x - upper x.
					upper := upper nextLink]].
	"store result in c1"
	lower notNil 
		ifTrue: 
			[| bridge |
			bridge := self 
						bridge: contour1 upperTail
						and: 0
						and: 0
						and: lower
						and: x
						and: y.
			contour1 
				upperTail: (bridge nextLink notNil ifTrue: [contour2 upperTail] ifFalse: [bridge]).
			contour1 lowerTail: contour2 lowerTail]
		ifFalse: 
			[| bridge |
			bridge := self 
						bridge: contour2 lowerTail
						and: x
						and: y
						and: upper
						and: 0
						and: 0.
			bridge nextLink isNil ifTrue: [contour1 lowerTail: bridge]].
	contour1 lowerHead: contour2 lowerHead.
	^total!

minimumHorizontalSpacing
	"Private - Answer the <integer> minimum number of pixels between levels in the tree."

	^15!

moveSelectionDown
	"Private - Move the selection down. Assumes there is a selection.
	The algorithm is simply to move to the nearest sibling, or, if none, find the nearest parent 
	with a sibling, and move to its sibling. This is to reproduce the behaviour of the Windows
	TreeView common control."

	| siblingNode parentNode |
	parentNode := self selectedNode.
	
	[| node |
	node := parentNode.
	(siblingNode := node sibling) isNil and: [(parentNode := node parent) notNil]] 
			whileTrue.
	siblingNode isNil ifFalse: [self basicSelection: siblingNode cause: #keyboard]!

moveSelectionLeft
	"Private - Move the selection to the left."

	| parentNode |
	(parentNode := self selectedNode parent) == anchorNode 
		ifFalse: [self basicSelection: parentNode cause: #keyboard]!

moveSelectionRight
	"Private - Move the selection to the right.
	We simulate the behaviour of the Windows TreeView control by selecting the first child,
	if any."

	| child node |
	node := self selectedNode.
	node hasExpanded ifFalse: [self populateNode: node].
	(child := node child) notNil ifTrue: [self basicSelection: child cause: #keyboard]!

moveSelectionUp
	"Private - Move the selection to the previous sibling, i.e. the selection moves 'up' visually in the tree"

	(self previousSibling: self selectedNode) 
		ifNotNil: [:node | self basicSelection: node cause: #keyboard]!

nearestNodeTo: aMoenTreeNode 
	"Private - Answer the 'nearest' node to the <MoenTreeNode> argument in the receiver in the 
	following order of priority.
	1) The node's next sibling
	2) The node's parent.
	The answer may be the anchor node if the argument is a root with no sibling."

	^aMoenTreeNode sibling notNil 
		ifTrue: [aMoenTreeNode sibling]
		ifFalse: 
			["If there is no subsequent sibling, move to the previous one, and failing that up to the parent"
			(self previousSibling: aMoenTreeNode) 
				ifNil: [aMoenTreeNode parent == anchorNode ifFalse: [aMoenTreeNode parent]]]!

nodeAtPosition: position ifNone: exceptionHandler 
	"Private - Answer the <MoenTreeNode> whose item rectangle contains the 
	<Point>, position, or the result of evaluating the <niladicValuable> exception 
	handler if no item actually coincides with that position."

	| hit |
	hit := self hitTest: position.
	^(hit isNil or: [hit key ~~ #item])
		ifTrue: [exceptionHandler value]
		ifFalse: [hit value]!

nodeAtPosition: aPoint search: node
	"Private - Answer the object which coincides with aPoint. Only search the
	<MoenTreeNode>, node, and all its children. Answer nil if no node coincides."

	(node clip containsPoint: aPoint) ifTrue: [
		(node rectangle containsPoint: aPoint)
			ifTrue: [^node]
			ifFalse: [ | cNode |
				cNode := node child.
				[cNode notNil] whileTrue: [ | found |
					(found := self nodeAtPosition: aPoint search: cNode) notNil ifTrue: [^found].
					cNode := cNode sibling]]].
	^nil!

nodeForObject: comperand
	"Private - Answer the first node of the receiver which holds the <Object>, comperand,
	using the comparison block to discriminate. Should no suitable node be found then
	raise a NotFoundError."

	^self nodeForObject: comperand
		ifAbsent: [self errorNotFound: comperand]!

nodeForObject: anObject ifAbsent: exceptionHandler
	"Private - Answer the first node in the receiver located using a pre-order traversal from the roots,
	for which the receiver's model's search policy evaluates to true for the <Object>, comperand.
	If there is no matching node, then expand the parent chain and try again."

	| node |
	node := self findNodeForObject: anObject.
	node isNil 
		ifTrue: 
			["Not currently in the tree, but if it exists in the model we expand its parent so that it is added."

			(self model includes: anObject) ifFalse: [^exceptionHandler value].
			self expand: (self model parentOf: anObject).
			node := self findNodeForObject: anObject.
			self assert: [node notNil	"#expand: failed?"]].
	^node!

nodesForObject: comperand
	"Private - Answer a <sequencedReadableCollection> of <MoenTreeNode> from 
	the receiver's tree which hold the <Object>, comperand, using the configured 
	comparison block to discriminate. The collection will be empty if no nodes match."

	| discriminator answer |
	discriminator := self model searchPolicy.
	answer := OrderedCollection new.
	"Avoid comparing against the object in the anchorNode, just in case the user wants to store 'nil' in the tree"
	anchorNode childrenDo: 
			[:eachRoot | 
			eachRoot preOrderDo: 
					[:eachNode | 
					(discriminator compare: comperand with: eachNode object) 
						ifTrue: [answer addLast: eachNode]]].
	^answer!

offset: p1 and: p2 and: a1 and: a2 and: b1 and: b2 
	"Private - Answer the vertical offset between two contours."

	| d t |
	(b1 <= p1 or: [p1 + a1 <= 0]) ifTrue: [^0].
	t := b1 * a2 - (a1 * b2).
	t > 0 
		ifTrue: 
			[p1 < 0 
				ifTrue: 
					[| s |
					s := p1 * a2.
					d := s // a1 - p2]
				ifFalse: 
					[p1 > 0 
						ifTrue: 
							[| s |
							s := p1 * b2.
							d := s // b1 - p2]
						ifFalse: [d := p2 negated]]]
		ifFalse: 
			[b1 < (p1 + a1) 
				ifTrue: 
					[| s |
					s := (b1 - p1) * a2.
					d := b2 - (p2 + (s // a1))]
				ifFalse: 
					[b1 > (p1 + a1) 
						ifTrue: 
							[| s |
							s := (a1 + p1) * b2.
							d := s // b1 - (p2 + a2)]
						ifFalse: [d := b2 - (p2 + a2)]]].
	^0 max: d!

onAboutToEditLabel: anObject
	"The receiver's element, anObject, is about to have its label edited in the receiver.
	Answer whether label editing should NOT proceed."

	| accept |
	accept := true asValue.
	self presenter trigger: #aboutToEditLabel:accept: with: anObject with: accept.
	^accept value not!

onButtonDown: aMouseEvent
	"Private - Handle a mouse click from left or right mouse buttons."

	self setFocus.
	(self hitTest: aMouseEvent position) 
		ifNil: [aMouseEvent isRButtonDown ifTrue: [self basicSelection: nil cause: #mouse]]
		ifNotNil: 
			[:hit | 
			| node |
			node := hit value.
			hit key == #button 
				ifTrue: [self toggleExpanded: node cause: #mouse]
				ifFalse: 
					[node == self selectedNode 
						ifFalse: 
							[self basicSelection: node cause: #mouse.
							"The selection change may have been refused."
							self selectedNode == node ifFalse: [^self]].
					self isDragSource ifTrue: [self onBegin: aMouseEvent button drag: node object]]]!

onInputMaskRequired: anEvent
	"Handler for a WM_GETDLGCODE request from Windows. Answer a combination
	of DLGC_xxxx flags which specify the set of keyboard inputs desired."
	
	^Keyboard default isCtrlDown
		ifTrue: [0]
		ifFalse: [
			"Arrow keys move selection if the Ctrl key is not down"
			DLGC_WANTARROWS]!

onItem: anObject addedInParent: parentObject
	"The <Object>, element, has been added as a child of the <Object>, parent,
	in the receiver's model. Add the new element into the node tree in the same
	position with respect to its siblings that it occuppies in the model. The parent 
	may be nil if the new element is to be a root."

	| parentNode newNode |
	parentNode := self findNodeForObject: parentObject.
	parentNode isNil 
		ifTrue: 
			["Parent isn't even in tree (its parent not expanded)"

			^self].
	parentNode hasExpanded 
		ifFalse: 
			["Parent not expanded so new child not visible, but need to redraw the expansion button (if any)"

			self hasButtons ifTrue: [self invalidateRect: parentNode buttonRectangle].
			^self].
	newNode := self addTreeFor: anObject parentNode: parentNode.
	self calculateNodeExtents: newNode.
	self linkChild: newNode toParent: parentNode.
	self rectanglesChanged!

onItem: anObject movedToParent: parentObject
	"Private - Event received when anObject has been moved in the receiver's
	model's hierarchy to be a child of aParentObject.
	Implementation Note: There are quite a lot of cases we need to consider.
	If the node is not currently in the tree (though it may be in the model)
	then the move is the same as an add as far as the tree is concerned, 
	otherwise we need to consider all combinations of moving to a root,
	or unpopulated sub-node, or populated sub-node, from a root, unpopulated 
	sub-node or populated sub-node."

	| node newParent wasVisible |
	node := self findNodeForObject: anObject.
	node isNil ifTrue: [^self onItem: anObject addedInParent: parentObject].
	newParent := self findNodeForObject: parentObject.
	(newParent notNil and: [node parent == newParent]) ifTrue: [^self].
	(wasVisible := node isVisible) 
		ifTrue: [self removeTree: node]
		ifFalse: [self unlink: node].
	(newParent notNil and: [newParent hasExpanded]) 
		ifTrue: [self linkChild: node toParent: newParent].
	(wasVisible or: [node isVisible]) ifTrue: [self rectanglesChanged]!

onItem: anObject removedFromParent: parentObject
	"Event received when the <Object>, object, has been removed from the receiver's
	model from the parent <Object>, parent. The parent may be nil if a root item is being
	removed. Note that the object (and indeed parent) may appear more than once in the	
	tree if the underlying model is not really a true tree but a directed graph."

	| nodes visibleChange |
	nodes := self nodesForObject: anObject.
	nodes := parentObject isNil 
				ifTrue: [nodes select: [:node | node parent == anchorNode]]
				ifFalse: 
					[| discriminator |
					discriminator := self model searchPolicy.
					nodes select: 
							[:node | 
							| parent |
							(parent := node parent) notNil 
								and: [discriminator compare: parentObject with: parent object]]].
	visibleChange := false.
	nodes do: 
			[:node | 
			selection == node 
				ifTrue: 
					["Try and move selection to the previous sibling, or failing that the parent.
					If its a root move the selection to the previous root, failing that the next root."

					self basicSelection: (self nearestNodeTo: node) cause: #unknown].
			node isVisible 
				ifTrue: 
					[visibleChange := true.
					self removeTree: node]
				ifFalse: [self unlink: node]].
	visibleChange ifTrue: [self rectanglesChanged]!

onItemUpdated: anObject 
	"Event received when anObject has changed. This may force its appearance
	to change so we have to update the contours to reflect its new state."

	self updateItem: anObject!

onKeyPressed: aKeyEvent 
	"Handler for a WM_KEYDOWN by moving selection with arrow keys."

	self selectedNode notNil 
		ifTrue: 
			[| keyCode |
			keyCode := aKeyEvent code.
			keyCode == VK_RETURN ifTrue: [self presenter performAction].
			keyCode == VK_LEFT ifTrue: [self moveSelectionLeft].
			keyCode == VK_RIGHT ifTrue: [self moveSelectionRight].
			keyCode == VK_DOWN ifTrue: [self moveSelectionDown].
			keyCode == VK_UP ifTrue: [self moveSelectionUp].
			keyCode == VK_MULTIPLY ifTrue: [self expandAll].
			keyCode == VK_ADD ifTrue: [self expand].
			keyCode == VK_SUBTRACT ifTrue: [self collapse]].
	^super onKeyPressed: aKeyEvent!

onLabelOf: anObject editedTo: text
	"The receiver's element, anObject, has had its label edited in the receiver to the 
	specified text. Answer whether to accept the edited text.
	Implementation Note: We fire off an event to let the observers determine whether to
	accept the label edit. If the label edit is accepted, we let rename proceed, and then 
	subsequently notify the observers again that the label has been changed."

	| accept accepted |
	accept := false asValue.
	self presenter trigger: #labelOf:editedTo:accept: withArguments: {anObject. text. accept}.
	accepted := accept value.
	accepted
		ifTrue: 
			[self presenter
				trigger: #labelOf:changedTo:
				with: anObject
				with: text].
	^accepted!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event."

	| answer |
	answer := super onLeftButtonDoubleClicked: aMouseEvent.
	self hasSelection ifTrue: [self presenter performAction].
	^answer!

onLeftButtonPressed: aMouseEvent
	"Change the selection on left mouse button. This may also start a drag operation."

	self onButtonDown: aMouseEvent.
	^super onLeftButtonPressed: aMouseEvent!

onModelChanged
	"The model held by the associated presenter has been replaced (i.e. the complete
	contents have changed) so refresh the receiver here."

	self refreshContents!

onPaintRequired: aPaintEvent 
	"Private - Paint the receiver's view."

	| canvas |
	canvas := aPaintEvent canvas.
	self setDefaultCanvasColors: canvas.
	canvas
		font: self actualFont;
		pen: self linePen.
	anchorNode childrenDo: 
			[:each | 
			self 
				paint: each
				on: canvas
				fromPoint: nil]!

onRightButtonPressed: aMouseEvent
	"Change the selection on right mouse button and pop the context menu.
	This may also start a right drag operation."

	self onButtonDown: aMouseEvent.
	^super onRightButtonPressed: aMouseEvent!

onSelChanged
	"Private - Handle a selection change event"

	self isStateRestoring ifFalse: [
		"We must prevent selection notifications being propagated during
		state restoral"
		self presenter onSelectionChanged ]!

onSelChanging: aMoenTreeNode cause: aSymbol
	"Private - Selection is changing in the receiver to the specified <MoenTreeNode> as a
	direct result of user input. The user input type is #keyboard or #mouse, as determined 
	by the <Symbol> argument. A #selectionChanging: event is triggered to enquire as to 
	whether the selection change is permissible. If it is not then any observer that wishes to 
	veto the change must set the the value of the <SelectionChangingEvent> to false. Note 
	that selection notifications are not propagated during state restoral."

	^self isStateRestoring or: 
			[| event |
			event := SelectionChangingEvent forSource: self.
			event cause: aSymbol.
			aMoenTreeNode notNil ifTrue: [event newSelection: aMoenTreeNode object].
			selection notNil ifTrue: [event oldSelection: selection object].
			self presenter onSelectionChanging: event.
			event value]!

onSelectionChanged
	"Sent by #onSelChange when the receiver.
	The default is to trigger an #selectionChanged event of the presenter"

	self presenter trigger: #selectionChanged.
	self invalidateUserInterface.!

onSelectionChanging: aSelectionChangingEvent
	"Handler to indicate that the receiver's selection is about to change.
	To prevent the proposed change under cdertain circumstances a handler
	can set the value of aValueHolder to false.
	The default is to trigger an #selectionChanging: event off the presenter"

	self presenter trigger: #selectionChanging: with: aSelectionChangingEvent!

onTreeChanged: anObjectOrNil
	"The tree structure below anObjectOrNil has been changed.
	If nil this indicates that the entire tree from the root down may have changed.
	Refresh the receiver appropriately."

	anObjectOrNil isNil ifTrue: [ ^self refreshContents].
	self onItemUpdated: anObjectOrNil; collapse: anObjectOrNil !

paint: aMoenTreeNode on: aCanvas fromPoint: aPoint 
	"Private - Paint the tree object onto the canvas together with all its children."

	| rectangle buttonRect tailPoint drawButton |
	rectangle := aMoenTreeNode rectangle.
	aPoint notNil ifTrue: [aCanvas lineFrom: aPoint to: rectangle leftCenter].
	(aCanvas isRectangleVisible: aMoenTreeNode clip) ifFalse: [^self].
	self paintNode: aMoenTreeNode on: aCanvas.
	(drawButton := (self hasChildren: aMoenTreeNode) and: [self hasButtons]) 
		ifTrue: 
			[buttonRect := aMoenTreeNode buttonRectangle.
			tailPoint := buttonRect center]
		ifFalse: [tailPoint := rectangle rightCenter].
	aMoenTreeNode visibleChildrenDo: 
			[:each | 
			self 
				paint: each
				on: aCanvas
				fromPoint: tailPoint].
	drawButton 
		ifTrue: 
			[self 
				paintButton: buttonRect
				on: aCanvas
				isExpanded: aMoenTreeNode isExpanded]!

paintButton: aRectangle on: aCanvas isExpanded: aBoolean 
	self isThemed 
		ifTrue: 
			[self 
				paintThemeButton: aRectangle
				on: aCanvas
				isExpanded: aBoolean]
		ifFalse: 
			[self 
				paintClassicButton: aRectangle
				on: aCanvas
				isExpanded: aBoolean]!

paintClassicButton: aRectangle on: aCanvas isExpanded: aBoolean 
	| pen |
	aCanvas rectangle: aRectangle.
	pen := aCanvas pen: Pen black.
	aCanvas lineFrom: aRectangle leftCenter + (2 @ 0) to: aRectangle rightCenter - (2 @ 0).
	aBoolean 
		ifFalse: [aCanvas lineFrom: aRectangle topCenter + (0 @ 2) to: aRectangle bottomCenter - (0 @ 2)].
	aCanvas pen: pen!

paintNode: aMoenTreeNode on: aCanvas
	"Private - Paint the label (icon + text) of the <MoenTreeNode> argument on the specified
	<Canvas> within its precalculate rectangle."

	| text elem rect drawFocus isSel |
	elem := aMoenTreeNode object.
	text := (self getTextBlock value: elem) displayString.
	rect := aMoenTreeNode rectangle.
	self hasIcons
		ifTrue: 
			[(getImageBlock value: elem)
				ifNotNil: 
					[:image |
					(self imageManager imageListWithExtent: iconExtent)
						draw: image
						on: aCanvas
						at: (self imagePositionIn: rect)
						flags: 0.
					rect := rect insetOriginBy: textInset]].
	drawFocus := false.
	(isSel := self selectedNode == aMoenTreeNode)
		ifTrue: 
			[| bkColour |
			aCanvas save.
			(drawFocus := self hasFocus)
				ifTrue: 
					[bkColour := Color highlight.
					aCanvas forecolor: Color highlightText]
				ifFalse: [bkColour := Color face3d].
			aCanvas
				backcolor: bkColour;
				fillRectangle: rect color: bkColour].
	aCanvas
		formatText: text
		in: (rect insetBy: (self leadingForCanvas: aCanvas))
		flags: dtFlags.
	drawFocus ifTrue: [self drawFocusRect: rect].
	isSel ifTrue: [aCanvas restore]!

paintThemeButton: aRectangle on: aCanvas isExpanded: aBoolean 
	ThemeLibrary default 
		drawThemeBackground: self theme
		hdc: aCanvas asParameter
		iPartId: TVP_GLYPH
		iStateId: (aBoolean ifTrue: [GLPS_OPENED] ifFalse: [GLPS_CLOSED])
		pRect: aRectangle asParameter
		pClipRect: nil!

parentSpacing
	"Answer the horizontal distance in pels between each level of tree nodes."

	^parentSpacing - self buttonSize!

parentSpacing: anInteger 
	"Set the horizontal distance between each level of tree nodes."

	parentSpacing := (anInteger + self buttonSize) max: self minimumHorizontalSpacing!

populateNode: aMoenTreeNode
	| child |
	self assert: [aMoenTreeNode hasExpanded not].
	(self model childrenOf: aMoenTreeNode object) reverseDo: 
			[:each | 
			child := (self addTreeFor: each parentNode: aMoenTreeNode)
						sibling: child;
						yourself].
	aMoenTreeNode
		child: child;
		hasExpanded: true!

previousSibling: aMoenTreeNode
	"Private - Answer the first sibling before (visually above) the <MoenTreeNode> argument
	or nil if it's the first child of its parent."

	| childNode |
	self assert: [aMoenTreeNode ~~ anchorNode].
	childNode := aMoenTreeNode parent child.
	^childNode ~~ aMoenTreeNode 
		ifTrue: 
			[| siblingNode |
			siblingNode := childNode sibling.
			[siblingNode ~~ aMoenTreeNode] whileTrue: 
					[childNode := siblingNode.
					siblingNode := siblingNode sibling].
			childNode]!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	#expand == command 
		ifTrue: 
			[aCommandQuery isEnabled: (selection notNil 
						and: [selection isExpanded not and: [self hasChildren: selection]]).
			^true].
	#collapse == command 
		ifTrue: 
			[aCommandQuery isEnabled: (selection notNil 
						and: [selection isExpanded and: [self hasChildren: selection]]).
			^true].
	#collapseAll == command 
		ifTrue: 
			[aCommandQuery isEnabled: (selection isNil 
						or: [selection isExpanded and: [self hasChildren: selection]]).
			^true].
	#expandAll == command 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (selection isNil or: [self hasChildren: selection]).
			^true].
	^super queryCommand: aCommandQuery!

rectanglesChanged
	self
		generateAbsolutes;
		invalidateLayout;
		invalidate!

refreshContents
	"The model held by the receiver has been changed so refresh 
	all the trees."

	anchorNode child: nil.
	selection := nil.
	self model notEmpty 
		ifTrue: 
			[self model roots reverseDo: 
					[:each | 
					| root |
					root := self addTreeFor: each parentNode: anchorNode.
					root sibling: anchorNode child.
					anchorNode child: root]].
	self isOpen 
		ifTrue: 
			[self
				invalidateGeometry;
				calculateExtent]!

removeNode: node 
	| wasVisible |
	(wasVisible := node isVisible) 
		ifTrue: [self removeTree: node]
		ifFalse: [self unlink: node].
	^wasVisible!

removeTree: aMoenTreeNode 
	"Private - Remove the sub-tree rooted at the <MoenTreeNode>, node, below the <MoenTreeNode>
	parent node, pNode."

	| parent |
	self assert: [aMoenTreeNode isVisible].
	parent := aMoenTreeNode parent.
	self unzip: parent.
	self unlink: aMoenTreeNode.
	self zip: parent!

requestDragObjects: session 
	"This is where the receiver specifies which object(s) the <DragDropSession>, session,
	is to drag. The objects are added to the session using DragDropSession>>addDragObject: 
	or DragDropSession>>dragObjects:.
	Implementation Note: Override to make a reasonable suggestion (the current selection)."

	self hasSelection ifTrue: [session addDragee: self selection].
	"But let any observers override with their own suggestion"
	super requestDragObjects: session!

resetSelection
	"Set the receiver to have no selection."

	self basicSelection: nil cause: #unknown!

selectedNode
	"Private - Answer the selected node or nil if no selection.
	Implementation Note: Manipulating selection often requires valid node rectangles, so we must
	ensure these have been calculated."

	self isLayoutValid ifFalse: [self topView validateLayout].
	^selection
!

selection
	"Answer a single selected object. 
	Raise an error if no objects are selected."

	^self selectionIfNone: [self errorNoSelection]
!

selection: newSelection
	"Select the first occurence of the <Object>, newSelection, in the receiver. 
	If not present then signal a NotFoundError.
	Answer anObject"

	^self selection: newSelection ifAbsent: [self errorNotFound: newSelection]!

selection: anObject ifAbsent: exceptionHandler
	"Select the first occurence of anObject in the receiver
	and answer anObject, or if there are no occurrences, the 
	result of evaluating the <niladicValuable>, exceptionHandler."

	| node |
	anObject isNil ifTrue: [^self resetSelection].
	node := self nodeForObject: anObject ifAbsent: [^exceptionHandler value].
	self basicSelection: node cause: #unknown.
	^anObject!

selectionIfNone: aBlock
	"Answer the selected object or the result of evaluating aBlock
	if there is no selection."

	| selNode |
	^(selNode := self selectedNode) isNil
		ifTrue: [aBlock value]
		ifFalse: [selNode object]!

selectionOrNil
	"Return the selected object or nil if no selection."

	^self selectionIfNone: []!

selectionOrNil: newSelection 
	"Select the first occurence of the <Object> argument, in the receiver. If anObject
	is nil, then simply remove the existing selection. If the new selection is not present then
	signal a <NotFoundError>. Answer the new selection."

	newSelection isNil ifTrue: [self resetSelection] ifFalse: [self selection: newSelection].
	^newSelection!

setDefaultCanvasColors: canvas 
	"Private - "

	canvas
		backcolor: self actualBackcolor;
		forecolor: self forecolor!

showDropHighlight: node
	"Private - Shows a drop highlight for the specified node within the receiver."

	| canvas |
	canvas := self canvas.
	canvas invertRectangle: node rectangle.
	canvas free.
	self propertyAt: #dropHighlight put: node.
!

toggleExpanded: aMoenTreeNode cause: aSymbol
	Cursor wait showWhile: 
			[aMoenTreeNode isExpanded 
				ifTrue: [self collapseNode: aMoenTreeNode cause: aSymbol]
				ifFalse: [self expandNode: aMoenTreeNode]]!

treeLayout
	"Private - Commence laying out the receivers trees, each root in turn."

	self treeLayout: anchorNode.
"	anchorNode childrenDo: [:each | self treeLayout: each]"!

treeLayout: aMoenTreeNode 
	"Private - Layout the <MoenTreeNode> argument and its subtree, note that this
	does not update the parent chain."

	aMoenTreeNode hasVisibleChildren 
		ifTrue: 
			[| child |
			child := aMoenTreeNode child.
			
			[self treeLayout: child.
			(child := child sibling) notNil] whileTrue.
			self attachParent: aMoenTreeNode height: (self join: aMoenTreeNode)]
		ifFalse: [self layoutLeaf: aMoenTreeNode]!

unlink: aMoenTreeNode
	| childNode siblingNode parentNode |
	parentNode := aMoenTreeNode parent.
	childNode := parentNode child.
	siblingNode := aMoenTreeNode sibling.
	childNode == aMoenTreeNode 
		ifTrue: [parentNode child: siblingNode]
		ifFalse: 
			["Find the previous sibling and update its sibling pointer to the unlinked node's next sibling"

			| node |
			node := childNode sibling.
			[node ~~ aMoenTreeNode] whileTrue: 
					[childNode := node.
					node := node sibling].
			childNode sibling: siblingNode].
	"The node is unlinked from its parents and siblings, but still points to its children (if it has any and has been expanded)"
	aMoenTreeNode
		parent: nil;
		sibling: nil!

unzip: aMoenTreeNode 
	"Private - Disassemble all subtree contours of the <MoenTreeNode> argument 
	and its parents in preparation for modifying its subtree."

	aMoenTreeNode isNil ifTrue: [^self].
	self unzip: aMoenTreeNode parent.
	aMoenTreeNode child notNil 
		ifTrue: 
			[| contour |
			(contour := aMoenTreeNode contour)
				upperHead: contour upperHead nextLink nextLink;
				lowerHead: contour lowerHead nextLink nextLink]!

updateAll
	"Refresh all items in the receiver.
	Note that this only invalidates the labels (including images) rather than the whole view 
	to minimize unpleasant flashing."

	self invalidateTree: anchorNode imagesOnly: false!

updateGeometry
	"Private - The receiver has been changed in a global way which affects its geometry,
	so regenerate our contours to match, and invalidate for a repaint. May also
	cause the receiver's parent to re-layout."

	self isOpen ifFalse: [^self].
	self
		calculateNodeExtents;
		treeLayout;
		generateAbsolutes!

updateItem: anObject 
	"Update the specified item in the tree. In a Moen Tree this may involve reshaping the tree
	if, for example, the length of the text has changed."

	(self findNodeForObject: anObject) 
		ifNotNil: [:node | node isVisible ifTrue: [self updateNode: node]]!

updateNode: aMoenTreeNode 
	| parent |
	parent := aMoenTreeNode parent.
	self unzip: parent.
	self calculateNodeExtents: aMoenTreeNode.
	self treeLayout: aMoenTreeNode.
	self zip: parent.
	self rectanglesChanged!

updateSelection
	"Private - Ensure the view displays the current selection."

	self selectedNode 
		ifNotNil: [:selNode | self invalidateRect: selNode rectangle erase: false]!

updateTree: element imagesOnly: aBoolean 
	"Redraw the receiver's <Object> item, element, including all child items, and
	their children, and so on. If the tree rooted at the element is not currently in the
	tree then ignore the request."

	self 
		invalidateItem: element
		andChildren: true
		imagesOnly: aBoolean!

value: anObject
	"Private - Implement this message from the monadic valuable to support the default
	'get image' functionality for an iconic list.  By default we assume icons can be used
	for images."

	"Implementation Note: This can often remove the need to store a block down into a 
	view resource, and can thus save a considerable amount of space. It is also more 
	efficient to perform a normal message send than a block evaluation."

	^anObject iconImageIndex!

viewMode
	"Answer the <Symbol>ic name of the receiver's view mode, e.g. #smallIcons. This controls
	whether or not icons are displayed, and their size if they are."

	^ViewModes keyAtEqualValue: iconExtent ifAbsent: [#custom]!

viewMode: aSymbol
	(ViewModes lookup: aSymbol) ifNotNil: [:point | self iconExtent: point]!

wmKillFocus: message wParam: wParam lParam: lParam
	"Private - This window is losing focus. Update the colouring of the selection."

	self updateSelection.
	^super wmKillFocus: message wParam: wParam lParam: lParam
!

wmNcCalcSize: message wParam: wParam lParam: lParam 
	"Private - Handler for a WM_NCCALCSIZE message."

	"Ensure the receiver's geometry is calculated - something that might not otherwise happen until
	 a layout manager (if the receiver's parent has one) requests the receiver's extent."

	self calculateExtent.
	^nil!

wmSetFocus: message wParam: wParam lParam: lParam
	"Private - This window is getting focus. Update the colouring of the selection."

	self updateSelection.
	^super wmSetFocus: message wParam: wParam lParam: lParam
!

zip: aMoenTreeNode 
	"Private - Reassemble the contours of the <MoenTreeNode> argument 
	and its parent chain to accomodate a change in the argument's subtree."

	aMoenTreeNode isNil ifTrue: [^self].
	aMoenTreeNode hasVisibleChildren 
		ifTrue: [self attachParent: aMoenTreeNode height: (self join: aMoenTreeNode)]
		ifFalse: [self layoutLeaf: aMoenTreeNode].
	self zip: aMoenTreeNode parent! !

!MoenTreeView categoriesForMethods!
addTreeFor:parentNode:!adding!private! !
anchorNode!accessing!private! !
applyFont!font!private!updating! !
attachParent:height:!private!tree layout! !
autoExpandNode:!adding!private! !
basicExpandNode:!operations!private! !
basicSelection:cause:!private!selection! !
bridge:and:and:and:and:and:!private!tree layout! !
buttonSize!constants!private! !
calculateClientExtent!geometry!private! !
calculateExtent:!accessing!private! !
calculateNodeExtents!geometry!private! !
calculateNodeExtents:!geometry!private! !
calculateNodeExtents:forCanvas:!geometry!private! !
collapse!commands!public! !
collapse:!operations!public! !
collapseAll!commands!public! !
collapseAll:!expanding/collapsing!public! !
collapseNode:cause:!operations!private! !
collapseSubtree:!operations!private! !
connectModel!models!public! !
defaultDrawTextFlags!adapters!constants!private! !
defaultGetImageBlock!adapters!constants!private! !
defaultGetTextBlock!adapters!constants!private! !
dragLeave:!drag & drop!public! !
dragOver:!drag & drop!public! !
drop:!drag & drop!public! !
dropHighlight!drag & drop!private! !
editSelectionLabel!operations!public! !
ensureNodeVisible:!operations!private! !
ensureSelectionVisible!helpers!public! !
errorNoSelection!exceptions!private! !
expand!commands!public! !
expand:!operations!public! !
expandAll!commands!public! !
expandAll:!expanding/collapsing!public! !
expandNode:!operations!private! !
expandSubtree:!operations!private! !
findNodeForObject:!private!searching! !
generateAbsolutes!geometry!private! !
generateNodeClipRects!private!tree layout! !
generatePosition:absolute:!geometry!private! !
getImageBlock!adapters!public! !
getImageBlock:!adapters!public! !
getTextBlock!adapters!public! !
getTextBlock:!adapters!public! !
hasButtons!accessing-styles!public!testing! !
hasButtons:!accessing-styles!public! !
hasChildren:!private!searching! !
hasIcons!geometry!private! !
hasSelection!public!testing! !
hasWordWrap!private!testing! !
hasWordWrap:!private!testing! !
hideDropHighlight!drag & drop!private! !
hitTest:!helpers!private! !
hitTest:search:!helpers!private! !
iconExtent:!accessing!private! !
imageManager!accessing!public! !
imageManager:!accessing!public! !
imagePositionIn:!painting!private! !
includesItem:!enquiries!public! !
initialize!initializing!private! !
invalidateGeometry!private!updating! !
invalidateItem:!painting!public! !
invalidateItem:andChildren:imagesOnly:!painting!public! !
invalidateNode:imagesOnly:!painting!private! !
invalidateTree:imagesOnly:!painting!private! !
isAutoExpanding!accessing-styles!public!testing! !
isAutoExpanding:!accessing!public! !
itemFromPoint:!helpers!private! !
join:!private!tree layout! !
layoutLeaf:!private!tree layout! !
leadingForCanvas:!geometry!private! !
linePen!accessing!private! !
linePen:!accessing!private! !
linkChild:toParent:!adding!private! !
linkChild:toParent:after:!adding!private! !
margin!accessing!public! !
margin:!accessing!public! !
maxTextExtent!accessing!private! !
maxTextExtent:!accessing!private! !
merge:with:!private!tree layout! !
minimumHorizontalSpacing!constants!private! !
moveSelectionDown!private!selection! !
moveSelectionLeft!private!selection! !
moveSelectionRight!private!selection! !
moveSelectionUp!private!selection! !
nearestNodeTo:!helpers!private! !
nodeAtPosition:ifNone:!helpers!private! !
nodeAtPosition:search:!helpers!private! !
nodeForObject:!private!searching! !
nodeForObject:ifAbsent:!private!searching! !
nodesForObject:!private!searching! !
offset:and:and:and:and:and:!private!tree layout! !
onAboutToEditLabel:!event handling!public! !
onButtonDown:!event handling!private! !
onInputMaskRequired:!event handling!public! !
onItem:addedInParent:!event handling!private! !
onItem:movedToParent:!event handling!private! !
onItem:removedFromParent:!event handling!private! !
onItemUpdated:!event handling!public! !
onKeyPressed:!event handling!public! !
onLabelOf:editedTo:!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onModelChanged!event handling!public! !
onPaintRequired:!event handling!painting!private! !
onRightButtonPressed:!event handling!public! !
onSelChanged!event handling!private! !
onSelChanging:cause:!event handling!private! !
onSelectionChanged!event handling!public! !
onSelectionChanging:!event handling!public! !
onTreeChanged:!event handling!public! !
paint:on:fromPoint:!painting!private! !
paintButton:on:isExpanded:!painting!private! !
paintClassicButton:on:isExpanded:!painting!private! !
paintNode:on:!painting!private! !
paintThemeButton:on:isExpanded:!painting!private! !
parentSpacing!accessing!public! !
parentSpacing:!accessing!public! !
populateNode:!operations!private! !
previousSibling:!accessing!private! !
queryCommand:!commands!private! !
rectanglesChanged!event handling!public! !
refreshContents!public!updating! !
removeNode:!event handling!public! !
removeTree:!private!removing! !
requestDragObjects:!drag & drop!public! !
resetSelection!public!selection! !
selectedNode!private!selection! !
selection!public!selection! !
selection:!public!selection! !
selection:ifAbsent:!public!selection! !
selectionIfNone:!public!selection! !
selectionOrNil!public!selection! !
selectionOrNil:!public!selection! !
setDefaultCanvasColors:!helpers!private! !
showDropHighlight:!drag & drop!private! !
toggleExpanded:cause:!operations!private! !
treeLayout!accessing!private! !
treeLayout:!operations!private! !
unlink:!private!removing! !
unzip:!private!tree layout! !
updateAll!painting!public! !
updateGeometry!private!updating! !
updateItem:!event handling!public! !
updateNode:!helpers!private! !
updateSelection!private!selection! !
updateTree:imagesOnly:!painting!public! !
value:!evaluating!private! !
viewMode!public! !
viewMode:!public! !
wmKillFocus:wParam:lParam:!event handling-win32!private! !
wmNcCalcSize:wParam:lParam:!event handling-win32!private! !
wmSetFocus:wParam:lParam:!event handling-win32!private! !
zip:!private!tree layout! !
!

MoenTreeView methodProtocol: #selectableItems attributes: #(#readOnly) selectors: #(#hasSelection #onSelectionChanged #onSelectionChanging: #resetSelection #selection #selection: #selection:ifAbsent: #selectionIfNone: #selectionOrNil #selectionOrNil:)!
MoenTreeView methodProtocol: #treeView attributes: #(#readOnly) selectors: #(#collapse: #expand: #expandAll: #includesItem: #onItem:addedInParent: #onItem:movedToParent: #onItem:removedFromParent: #onItemUpdated: #onTreeChanged: #updateItem: #viewMode #viewMode:)!

!MoenTreeView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^TreeModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		MoenTreeView initialize

	N.B. DT_WORD_ELLIPSIS seems to imply DT_SINGLELINE, and therefore conflicts with
		DT_EDITCONTROL and DT_WORDBREAK. The text can only be centred in the single
		line case too.
	"

	self addClassConstant: 'SingleLineMask' value: DT_SINGLELINE | DT_VCENTER | DT_END_ELLIPSIS.
	self addClassConstant: 'MultilineMask' value: DT_WORDBREAK | DT_EDITCONTROL | DT_END_ELLIPSIS.
	self addClassConstant: 'HasButtonsMask' value: 16r1.
	self addClassConstant: 'AutoExpandingMask' value: 16r8000000.
	self addClassConstant: 'ViewModes'
		value: (IdentityDictionary new
				at: #noIcons put: -1 @ 0;
				at: #smallIcons put: 16 @ 16;
				at: #mediumIcons put: 24 @ 24;
				at: #largeIcons put: 32 @ 32;
				at: #tileIcons put: 48 @ 48;
				at: #custom put: nil;
				shrink;
				isImmutable: true;
				yourself)!

stbConvertFromVersion10: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) <View> to version 10,
	i.e. use #reserved1 inst. var. for flags."

	| anchorNode roots lastRoot array |
	array := super stbConvertFromVersion10: anArray.
	anchorNode := MoenTreeNode object: nil parent: nil.
	roots := array at: 13.
	lastRoot := nil.
	roots reverseDo: 
			[:each | 
			each sibling: lastRoot.
			lastRoot := each].
	anchorNode child: lastRoot.
	anchorNode
		hasExpanded: true;
		isExpanded: true.
	array at: 13 put: anchorNode.
	^array!

stbConvertFromVersion11: anArray 
	"Private - Perform an STB conversion from a version 11 <View> to version 12."

	"Version 12 MoenTreeView adds 3 new instance variables (one for the theme handle, and 2 spares)"

	^(super stbConvertFromVersion11: anArray), #(nil nil nil)!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) <View> to version 10,
	i.e. use #reserved1 inst. var. for flags."

	^(super stbConvertFromVersion9: anArray)
		at: 16 put: AutoExpandingMask;
		yourself!

themePartName
	^#TreeView!

value: anObject
	"Private - Implement this message from the monadic valuable to support the default
	'get image' functionality for an iconic list.  By default we assume icons can be used
	for images."

	"Implementation Note: This can often remove the need to store a block down into a 
	view resource, and can thus save a considerable amount of space. It is also more 
	efficient to perform a normal message send than a block evaluation."

	^anObject iconImageIndex!

viewModes
	^ViewModes! !

!MoenTreeView class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!development!initializing!private! !
stbConvertFromVersion10:!binary filing!private! !
stbConvertFromVersion11:!binary filing!private! !
stbConvertFromVersion9:!binary filing!private! !
themePartName!constants!public!theming! !
value:!evaluating!private! !
viewModes!constants!public! !
!

