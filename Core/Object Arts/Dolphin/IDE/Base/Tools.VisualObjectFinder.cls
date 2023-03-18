"Filed out from Dolphin Smalltalk"!

Tools.InspectorAbstract
	subclass: #'Tools.VisualObjectFinder'
	instanceVariableNames: 'mouseTracker finderIcon heading workspace foundView'
	classVariableNames: 'FindNonDolphinWindows'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.VisualObjectFinder guid: (Core.GUID fromString: '{b76a24f7-5ff3-41ac-9aa9-77ebf7b94816}')!
Tools.VisualObjectFinder comment: ''!
!Tools.VisualObjectFinder categoriesForClass!MVP-Presenters! !
!Tools.VisualObjectFinder methodsFor!

browseObject
	"Private - Answer the object from the receiver that should be browsed"

	^self value!

cancelTrackingAt: arg1
	"Private - This is an auto-generated target implementation for the protocol <mouseTrackerTarget>
	and remains to be correctly implemented."

!

continueTrackingAt: aPoint from: aPreviousPoint
	| foundObject |
	foundObject := self visualObjectAt: aPoint.
	foundObject notNil ifTrue: [heading list: {foundObject}] ifFalse: [heading clear]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	workspace := self add: ValueWorkspace new name: 'workspace'.
	heading := self add: ListPresenter new name: 'heading'.
	finderIcon := (self add: ImagePresenter new name: 'finderIcon') value: self icon!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	finderIcon 
		when: #leftButtonPressed:
		send: #findObject
		to: self.
	self
		when: #drop:
			send: #onDropOver:
			to: self;
		when: #dragEnter:
			send: #onDragOver:
			to: self;
		when: #dragOver:
			send: #onDragOver:
			to: self.
	self model 
		when: #valueChanged
		send: #onValueChanged
		to: self!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	This will be used as the label for the tab when the receiver is being displayed within the Flipper Inspector"

	aPuttableStream nextPutAll: 'Visual Object Finder'!

endTrackingAt: aPoint
	| foundObject |

	foundObject := self visualObjectAt: aPoint.
	self value: foundObject.
!

findObject
	"Start a mouse tracker to find objects beneath the mouse cursor"

	mouseTracker := MouseTracker forPresenter: self startingAt: 0@0.
	Cursor help showWhile: [mouseTracker startTracking: self]!

foundView
	^foundView!

inspecteeSelection
	"Private - Answer the value associated with the currently selected object"

	^self value.!

model: aValueModel
	"Connects the receiver to aValueModel"

	super model: aValueModel.
	workspace model: aValueModel.!

onDragOver: anInternalDragDropSession 
	anInternalDragDropSession
		operation: #copy;
		supportedOperations: #(#copy)!

onDropOver: anInternalDragDropSession 
	| objects |
	objects := anInternalDragDropSession dragObjects collect: 
					[:each | 
					(each isFormatAvailable: #Object) 
						ifTrue: [each format: #Object]
						ifFalse: [each format: each availableFormats asArray first]].
	objects size = 1 ifTrue: [self value: objects first] ifFalse: [self value: objects]!

onValueChanged
	"Private - The receiver's value has changed; refresh our heading"

	heading list: {self value}!

onViewOpened
	super onViewOpened.
	self onValueChanged!

startTrackingAt: arg1
!

viewFromPoint: aPoint
	| under child clientPoint desktop lastDolphin |
	clientPoint := aPoint.
	under := desktop := View desktop.
	
	[child := OS.User32
				childWindowFromPointEx: under asParameter
				pt: clientPoint asParameter
				uFlags: CWP_SKIPINVISIBLE.	"| CWP_SKIPTRANSPARENT"
	child isNil or: [child = under asParameter]]
			whileFalse: 
				[clientPoint := desktop mapPoint: aPoint to: child.
				under := View fromHandle: child.
				(SessionManager inputState isDolphinWindow: under asParameter) ifTrue: [lastDolphin := under]].
	^(under isDolphinWindow or: [self class findNonDolphinWindows])
		ifTrue: [under]
		ifFalse: [lastDolphin]!

visualObjectAt: aPoint
	"Private - Answer the visual object found under aPoint (in desktop coordinates) or nil if none"

	^(foundView := self viewFromPoint: aPoint) 
		ifNotNil: 
			[:viewUnderCursor | 
			| localPoint |
			localPoint := View desktop mapPoint: aPoint to: viewUnderCursor.
			viewUnderCursor visualObjectAtPoint: localPoint]! !
!Tools.VisualObjectFinder categoriesForMethods!
browseObject!accessing!private! !
cancelTrackingAt:!private!tracking! !
continueTrackingAt:from:!private!tracking! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
displayOn:!displaying!public! !
endTrackingAt:!private!tracking! !
findObject!commands!public! !
foundView!public! !
inspecteeSelection!accessing!private! !
model:!accessing!public! !
onDragOver:!event handling!public! !
onDropOver:!event handling!public! !
onValueChanged!accessing!private! !
onViewOpened!event handling!private! !
startTrackingAt:!private!tracking! !
viewFromPoint:!helpers!private! !
visualObjectAt:!helpers!private! !
!

Tools.VisualObjectFinder methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!Tools.VisualObjectFinder class methodsFor!

findNonDolphinWindows
	^FindNonDolphinWindows!

findNonDolphinWindows: aBoolean
	FindNonDolphinWindows := aBoolean!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	FindNonDolphinWindows := false.
	SmalltalkSystem current registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #findNonDolphinWindows).
	^aspects!

registerAsToolWith: aSmalltalkSystem!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 #{Graphics.Color} #face3d nil 21 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 2 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 984838 #{UI.BorderLayout} 1 1 410 #{UI.ListView} 34 45 nil 576 34 2 8 1140936781 1 672 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 672 nil 8 1815049392 786950 #{Core.Message} #printString 784 850 #iconImageIndex 784 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 615 #left 850 #printString 8 #() 850 #<= 8 #() nil nil 672 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 1186 615 81 672 1138 #text: 34 1 8 'Column 1' 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 8 #() 1186 193 193 nil 35 nil nil nil 410 #{UI.ReferenceView} 34 14 nil 576 34 2 8 1140850688 131073 1360 nil nil nil 5 nil nil nil 1360 1376838 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 1090 34 1 1138 #createAt:extent: 34 2 1186 1 81 1186 615 391 1360 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 784 1344 nil 27 170 192 34 4 672 8 'heading' 1360 8 'workspace' nil 1090 34 1 1138 #createAt:extent: 34 2 1186 327 21 1186 615 471 576 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 34 2 672 1360 1344 nil 27 5 false 170 192 784 1180166 #{Graphics.Rectangle} 1186 21 21 1186 21 21 1090 34 1 1138 #createAt:extent: 34 2 1186 12287 21 1186 961 511 416 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 223 25 0 0 9 1 0 0] 34 2 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2016 nil nil nil 5 nil nil nil 2016 1048838 #{UI.FramingLayout} 170 176 34 4 410 #{UI.StaticText} 34 16 nil 2016 34 2 8 1140850944 1 2144 nil nil nil 5 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1186 193 193 nil 2144 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1090 34 2 1138 #createAt:extent: 34 2 1186 11 1 1186 281 141 2144 1138 #text: 34 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 2144 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 8 #() 1344 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 11 2578 #fixedParentRight -15 2578 #fixedParentTop 1 2578 #fixedViewTop 141 410 #{UI.StaticIcon} 34 17 nil 2016 34 2 8 1140855043 1 2656 918598 2 #{UI.ValueHolder} nil false 1835526 #{Kernel.PluggableSearchPolicy} 850 #= 8 #() 850 #hash 8 #() nil nil nil 5 nil nil nil 2656 nil 8 1815137184 2322 nil nil nil nil 1090 34 1 1138 #createAt:extent: 34 2 1186 123 189 1186 65 65 2656 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 8 #() 1344 nil 27 2546 2578 #relativeParentWidth 8 0.4 2578 #fixedViewLeft 65 2578 #relativeParentHeight 8 0.4 2640 65 170 192 34 2 2656 8 'finderIcon' nil 1090 34 1 1138 #createAt:extent: 34 2 1186 21 21 1186 307 471 2016 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 34 2 2144 2656 1344 nil 27 576 1344 nil 27)!

unregisterAsToolWith: aSmalltalkSystem
! !
!Tools.VisualObjectFinder class categoriesForMethods!
findNonDolphinWindows!accessing!public! !
findNonDolphinWindows:!accessing!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!constants!public! !
registerAsToolWith:!operations!public! !
resource_Default_view!public!resources-views! !
unregisterAsToolWith:!operations!public! !
!

Tools.VisualObjectFinder class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

