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
	self value: (self visualObjectAt: aPoint)!

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
	#highDpiToDo.	"ChildWindowFromPointEx does not appear to work correctly with mixed DPI"
	
	[child := OS.User32 realChildWindowFromPoint: under asParameter
				ptParentClientCoords: clientPoint asParameter.
	child isNil or: [child = under asParameter]]
			whileFalse: 
				[clientPoint := desktop mapPoint: aPoint to: child.
				under := View fromHandle: child.
				(SessionManager inputState isDolphinWindow: child) ifTrue: [lastDolphin := under]].
	^(under isDolphinWindow or: [self class findNonDolphinWindows])
		ifTrue: [under]
		ifFalse: [lastDolphin]!

visualObjectAt: aPoint
	"Private - Answer the visual object found under aPoint (in desktop coordinates) or nil if none"

	^(foundView := self viewFromPoint: aPoint) 
		ifNotNil: 
			[:viewUnderCursor | 
			| localPoint |
			localPoint := viewUnderCursor mapScreenToClient: aPoint.
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #face3d nil 21 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 1 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 256 nil nil nil 5 nil nil nil 256 1798 #{UI.BorderLayout} 1 1 18 #{UI.ListView} 50 45 nil 256 50 2 8 1140936781 1 352 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 352 nil nil 518 #{Core.Message} #printString 8 #() 514 #iconImageIndex 544 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 450 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 615 #left 514 #printString 8 #() 514 #<= 8 #() nil nil 352 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 352 nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 193 384 8 'Column 1' 352 3 8 #() 518 #{Graphics.Point} 193 193 nil 35 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 256 50 2 8 1140850688 131073 1024 nil nil nil 5 nil nil nil 1024 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 786 50 1 834 #createWindow: 50 1 882 914 8 #[0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 193 1056 8 '' 1024 3 8 #() 994 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 352 8 'heading' 1024 8 'workspace' nil 786 50 1 834 #createWindow: 50 1 882 914 8 #[163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 193 288 8 '' 256 3 50 2 352 1024 994 193 193 nil 27 5 false 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 994 21 21 994 21 21 786 50 1 834 #createWindow: 50 1 882 914 8 #[255 14 0 0 10 0 0 0 223 16 0 0 9 1 0 0] 193 80 8 '' 32 1 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1760 nil nil nil 5 nil nil nil 1760 262 #{UI.FramingLayout} 1282 #{Core.LookupTable} 50 4 18 #{UI.StaticText} 50 16 nil 1760 50 2 8 1140850944 1 1888 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1888 nil nil 518 #{UI.NullConverter} nil nil nil 786 50 2 834 #createWindow: 50 1 882 914 8 #[5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 193 1920 nil 1888 834 #text: 50 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 1888 3 8 #() 994 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 2290 #fixedParentRight -15 2290 #fixedParentTop 1 2290 #fixedViewTop 141 18 #{UI.StaticIcon} 50 17 nil 1760 50 2 8 1140855043 1 2368 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 514 #= 8 #() 514 #hash 8 #() nil nil nil 5 nil nil nil 2368 nil nil 2034 nil nil nil nil 786 50 1 834 #createWindow: 50 1 882 914 8 #[61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 193 2400 nil 2368 3 8 #() 994 193 193 nil 27 2258 2290 #relativeParentWidth 8 0.4 2290 #fixedViewLeft 65 2290 #relativeParentHeight 8 0.4 2352 65 1282 1520 50 2 2368 8 'finderIcon' nil 786 50 1 834 #createWindow: 50 1 882 914 8 #[10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 193 1792 8 '' 1760 3 50 2 1888 2368 994 193 193 nil 27 256 994 193 193 nil 27)!

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

