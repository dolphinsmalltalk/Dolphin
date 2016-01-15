"Filed out from Dolphin Smalltalk 7"!

LayoutManagerTest subclass: #FlowLayoutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FlowLayoutTest guid: (GUID fromString: '{B71BE04A-A575-4722-A8B1-C57127768758}')!
FlowLayoutTest comment: ''!
!FlowLayoutTest categoriesForClass!Unclassified! !
!FlowLayoutTest methodsFor!

layoutManagerClass
	^FlowLayout!

testVerticalCentreing
	| layout static edit |
	layout := shell layoutManager.
	shell insets: (20 @ 10 corner: 20 @ 10).
	layout
		horizontalGap: 10;
		verticalGap: 5.
	layout alignment: #leftCenter.
	static := shell addSubView: StaticText new.
	static
		alignment: #leftNoWrap;
		text: 'Wibble';
		extent: static calculateExtent.
	edit := shell addSubView: TextEdit new.
	edit
		text: 'Wobble';
		extent: edit calculateExtent.
	shell update.
	self assert: static position y = (edit position y + ((edit extent y - static extent y) // 2))!

testWrap
	| layout children |
	layout := shell layoutManager.
	shell backcolor: Color white.
	"#1646"
	layout
		horizontalGap: 10;
		verticalGap: 5.
	children := #(#red #green #blue #yellow) collect: 
					[:each | 
					| child |
					child := shell addSubView: ColorView new.
					child model value: (Color perform: each).
					child].
	shell extent: (shell calcRectangleFromClientRectangle: (0 @ 0 extent: 430 @ 415)) extent.
	shell update.
	1 to: 4 do: [:i | self assert: (children at: i) position = (((i - 1) * 110) @ 0)].
	"Shrink down by one pel will be enough to force last color onto new line, But shrinking to
	just enough space to 3 should make no difference)"
	#(1 109) do: 
			[:each | 
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 3 do: [:i | self assert: (children at: i) position = (((i - 1) * 110) @ 0)].
			self assert: (children at: 4) position = (0 @ 105)].
	"Repeat for 2 blocks"
	#(1 109) do: 
			[:each | 
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 2 do: [:i | self assert: (children at: i) position = (((i - 1) * 110) @ 0)].
			3 to: 4 do: [:i | self assert: (children at: i) position = (((i - 3) * 110) @ 105)]].
	"And 1 block"
	#(1 109) do: 
			[:each | 
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 4 do: [:i | self assert: (children at: i) position = (0 @ ((i - 1) * 105))]]! !
!FlowLayoutTest categoriesFor: #layoutManagerClass!private!unit tests! !
!FlowLayoutTest categoriesFor: #testVerticalCentreing!public!unit tests! !
!FlowLayoutTest categoriesFor: #testWrap!public!unit tests! !

