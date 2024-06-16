"Filed out from Dolphin Smalltalk"!

InspectorAbstract subclass: #VisualObjectFinder
	instanceVariableNames: 'mouseTracker finderIcon heading workspace foundView'
	classVariableNames: 'FindNonDolphinWindows'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

VisualObjectFinder guid: (GUID fromString: '{b76a24f7-5ff3-41ac-9aa9-77ebf7b94816}')!

VisualObjectFinder comment: ''!

!VisualObjectFinder categoriesForClass!MVP-Presenters! !

!VisualObjectFinder methodsFor!

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
	foundObject notNil 
		ifTrue: [heading list: (Array with: foundObject)]
		ifFalse: [heading clear]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	workspace := self add: ValueWorkspace new name: 'workspace'.
	heading := self add: ListPresenter new name: 'heading'.
	finderIcon := (self add: ImagePresenter new name: 'finderIcon') value: self icon.
 	
!

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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	within the Flipper Inspector"

	aStream nextPutAll: 'Visual Object Finder'!

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

	heading list: (Array with: self value)!

onViewOpened
	super onViewOpened.
	self onValueChanged!

startTrackingAt: arg1
!

viewFromPoint: aPoint
	| under child clientPoint desktop lastDolphin |
	clientPoint := aPoint.
	under := desktop := View desktop.
	
	[child := UserLibrary default realChildWindowFromPoint: under asParameter
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

!VisualObjectFinder categoriesForMethods!
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

VisualObjectFinder methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!VisualObjectFinder class methodsFor!

findNonDolphinWindows
	^FindNonDolphinWindows!

findNonDolphinWindows: aBoolean
	FindNonDolphinWindows := aBoolean!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	FindNonDolphinWindows := false.
	Smalltalk developmentSystem registerTool: self!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #face3d nil 21 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ListView) 34 45 nil 576 34 2 8 1140936781 1 672 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 5 nil nil nil 672 nil 8 1759068368 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 17 158 106] #printString 864 7 257 nil ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 615 #left 459270 ##(Smalltalk.Message) #printString 8 #() 1074 #<= 8 #() nil nil 672 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 193 704 8 'Column 1' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 35 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 576 34 2 8 1140850688 131073 1424 nil nil nil 5 nil nil nil 1424 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 1170 138 144 34 1 1234 #createWindow: 34 1 1282 1314 8 #[0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 193 1456 8 '' 1424 3 784 1394 193 193 nil 27 170 192 34 4 1424 8 'workspace' 672 8 'heading' nil 1170 138 144 34 1 1234 #createWindow: 34 1 1282 1314 8 #[163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 193 608 8 '' 576 3 34 2 672 1424 1394 193 193 nil 27 5 false 170 192 784 590342 ##(Smalltalk.Rectangle) 1394 21 21 1394 21 21 1170 138 144 34 1 1234 #createWindow: 34 1 1282 1314 8 #[191 13 0 0 10 0 0 0 159 15 0 0 9 1 0 0] 193 448 8 '' 416 1 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil nil nil 5 nil nil nil 2160 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 2160 34 2 8 1140850944 1 2288 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2288 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 1170 138 144 34 2 1234 #createWindow: 34 1 1282 1314 8 #[5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 193 2320 nil 2288 1234 #text: 34 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 2288 3 8 #() 1394 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 2722 #fixedParentRight -15 2722 #fixedParentTop 1 2722 #fixedViewTop 141 410 ##(Smalltalk.StaticIcon) 34 17 nil 2160 34 2 8 1140855043 1 2800 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 1074 #= 8 #() 1074 #hash 8 #() nil nil nil 5 nil nil nil 2800 nil 8 1759212608 2450 nil nil nil nil 1170 138 144 34 2 1234 #createWindow: 34 1 1282 1314 8 #[61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 193 2832 nil 2800 1234 #text: 34 1 8 '' 2800 3 8 #() 1394 193 193 nil 27 2690 2722 #relativeParentWidth 327734 ##(Smalltalk.Float) 8 154 153 153 153 153 153 217 63 2722 #fixedViewLeft 65 2722 #relativeParentHeight 3266 8 154 153 153 153 153 153 217 63 2784 65 170 192 34 2 2800 8 'finderIcon' nil 1170 138 144 34 1 1234 #createWindow: 34 1 1282 1314 8 #[10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 193 2192 8 '' 2160 3 34 2 2288 2800 1394 193 193 nil 27 576 1394 193 193 nil 27 )!

unregisterAsToolWith: aSmalltalkSystem
! !

!VisualObjectFinder class categoriesForMethods!
findNonDolphinWindows!accessing!public! !
findNonDolphinWindows:!accessing!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!constants!public! !
registerAsToolWith:!operations!public! !
resource_Default_view!public!resources-views! !
unregisterAsToolWith:!operations!public! !
!

VisualObjectFinder class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

