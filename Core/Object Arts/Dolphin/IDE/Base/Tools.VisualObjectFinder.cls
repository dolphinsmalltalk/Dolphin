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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #face3d nil 21 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 256 nil nil nil 5 nil nil nil 256 1798 #{UI.BorderLayout} 1 1 18 #{UI.ListView} 50 45 nil 256 50 2 8 1140936781 1 352 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 352 nil nil 518 #{Core.Message} #printString 8 #() 514 #iconImageIndex 544 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 450 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 615 #left 514 #printString 8 #() 514 #<= 8 #() nil nil 352 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 850 615 81 352 802 #text: 50 1 8 'Column 1' 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 8 #() 850 193 193 nil 35 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 256 50 2 8 1140850688 131073 1024 nil nil nil 5 nil nil nil 1024 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 754 50 1 802 #createAt:extent: 50 2 850 1 81 850 615 391 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 8 #() 1008 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 352 8 'heading' 1024 8 'workspace' nil 754 50 1 802 #createAt:extent: 50 2 850 327 21 850 615 471 256 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 50 2 352 1024 1008 nil 27 5 false 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 850 21 21 850 21 21 754 50 1 802 #createAt:extent: 50 2 850 6143 21 850 961 511 32 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 223 13 0 0 9 1 0 0] 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1728 nil nil nil 5 nil nil nil 1728 262 #{UI.FramingLayout} 1266 #{Core.LookupTable} 50 4 18 #{UI.StaticText} 50 16 nil 1728 50 2 8 1140850944 1 1856 nil nil nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 850 193 193 nil 1856 nil nil 518 #{UI.NullConverter} nil nil nil 754 50 2 802 #createAt:extent: 50 2 850 11 1 850 281 141 1856 802 #text: 50 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 1856 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 8 #() 1008 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 2274 #fixedParentRight -15 2274 #fixedParentTop 1 2274 #fixedViewTop 141 18 #{UI.StaticIcon} 50 17 nil 1728 50 2 8 1140855043 1 2352 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 514 #= 8 #() 514 #hash 8 #() nil nil nil 5 nil nil nil 2352 nil nil 2018 nil nil nil nil 754 50 1 802 #createAt:extent: 50 2 850 123 189 850 65 65 2352 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 8 #() 1008 nil 27 2242 2274 #relativeParentWidth 8 0.4 2274 #fixedViewLeft 65 2274 #relativeParentHeight 8 0.4 2336 65 1266 1488 50 2 2352 8 'finderIcon' nil 754 50 1 802 #createAt:extent: 50 2 850 21 21 850 307 471 1728 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 50 2 1856 2352 1008 nil 27 256 1008 nil 27)!

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

