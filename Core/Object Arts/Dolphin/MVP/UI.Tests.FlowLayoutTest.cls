"Filed out from Dolphin Smalltalk 7"!

UI.Tests.LayoutManagerTest subclass: #'UI.Tests.FlowLayoutTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.FlowLayoutTest guid: (Core.GUID fromString: '{b71be04a-a575-4722-a8b1-c57127768758}')!
UI.Tests.FlowLayoutTest comment: ''!
!UI.Tests.FlowLayoutTest categoriesForClass!Unclassified! !
!UI.Tests.FlowLayoutTest methodsFor!

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
	self assert: static position y equals: edit position y + ((edit extent y - static extent y) // 2)!

testWrap
	| layout children cx hGap cy vGap |
	layout := shell layoutManager.
	shell backcolor: Color white.
	cx := 200.
	cy := 200.
	hGap := 10.
	vGap := 5.
	"#1646"
	layout
		horizontalGap: 10;
		verticalGap: 5.
	children := #(#red #green #blue #yellow) collect: 
					[:each |
					| child |
					child := shell addSubView: ColorView new.
					child extent: cx @ cy.
					child model value: (Color perform: each).
					child].
	shell
		extent: (shell
				calcRectangleFromClientRectangle: (0 @ 0 extent: (cx * 4 + (hGap * 3)) @ (cy * 2 + (vGap * 3))))
					extent.
	shell update.
	1 to: 4 do: [:i | self assert: (children at: i) position equals: ((i - 1) * (cx + hGap)) @ 0].
	"Shrink down by one pel will be enough to force last color onto new line, But shrinking to
	just enough space to 3 should make no difference)"
	{1. cx + hGap - 1} do: 
			[:each |
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 3 do: [:i | self assert: (children at: i) position equals: ((i - 1) * (cx + hGap)) @ 0].
			self assert: (children at: 4) position equals: 0 @ (cy + vGap)].
	"Repeat for 2 blocks"
	{1. cx + hGap - 1} do: 
			[:each |
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 2 do: [:i | self assert: (children at: i) position equals: ((i - 1) * (cx + hGap)) @ 0].
			3 to: 4
				do: [:i | self assert: (children at: i) position equals: ((i - 3) * (cx + hGap)) @ (cy + vGap)]].
	"And 1 block"
	{1. cx + hGap} do: 
			[:each |
			shell extent: shell extent - (each @ 0).
			shell update.
			1 to: 4 do: [:i | self assert: (children at: i) position equals: 0 @ ((i - 1) * (cy + vGap))]]! !
!UI.Tests.FlowLayoutTest categoriesFor: #layoutManagerClass!private!unit tests! !
!UI.Tests.FlowLayoutTest categoriesFor: #testVerticalCentreing!public!unit tests! !
!UI.Tests.FlowLayoutTest categoriesFor: #testWrap!public!unit tests! !

