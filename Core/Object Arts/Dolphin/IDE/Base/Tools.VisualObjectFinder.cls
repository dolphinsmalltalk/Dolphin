"Filed out from Dolphin Smalltalk 7"!

Tools.InspectorAbstract subclass: #'Tools.VisualObjectFinder'
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
	
	[child := OS.UserLibrary default 
				childWindowFromPointEx: under asParameter
				pt: clientPoint asParameter
				uFlags: CWP_SKIPINVISIBLE "| CWP_SKIPTRANSPARENT".
	child isNil or: [child = under asParameter]] 
			whileFalse: 
				[clientPoint := desktop mapPoint: aPoint to: child.
				under := View fromHandle: child.
				(SessionManager inputState isDolphinWindow: under asParameter) 
					ifTrue: [lastDolphin := under]].
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
!Tools.VisualObjectFinder categoriesFor: #browseObject!accessing!private! !
!Tools.VisualObjectFinder categoriesFor: #cancelTrackingAt:!private!tracking! !
!Tools.VisualObjectFinder categoriesFor: #continueTrackingAt:from:!private!tracking! !
!Tools.VisualObjectFinder categoriesFor: #createComponents!initializing!private! !
!Tools.VisualObjectFinder categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.VisualObjectFinder categoriesFor: #displayOn:!displaying!public! !
!Tools.VisualObjectFinder categoriesFor: #endTrackingAt:!private!tracking! !
!Tools.VisualObjectFinder categoriesFor: #findObject!commands!public! !
!Tools.VisualObjectFinder categoriesFor: #foundView!public! !
!Tools.VisualObjectFinder categoriesFor: #inspecteeSelection!accessing!private! !
!Tools.VisualObjectFinder categoriesFor: #model:!accessing!public! !
!Tools.VisualObjectFinder categoriesFor: #onDragOver:!event handling!public! !
!Tools.VisualObjectFinder categoriesFor: #onDropOver:!event handling!public! !
!Tools.VisualObjectFinder categoriesFor: #onValueChanged!accessing!private! !
!Tools.VisualObjectFinder categoriesFor: #onViewOpened!event handling!private! !
!Tools.VisualObjectFinder categoriesFor: #startTrackingAt:!private!tracking! !
!Tools.VisualObjectFinder categoriesFor: #viewFromPoint:!helpers!private! !
!Tools.VisualObjectFinder categoriesFor: #visualObjectAt:!helpers!private! !

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Graphics.Color) #face3d nil 21 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 2 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ListView) 34 45 nil 576 34 2 8 1140936781 1 672 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 5 nil nil nil 672 nil 8 1801282304 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 17 158 106] #printString 864 7 257 nil ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Column 1' 615 #left 786950 ##(Core.Message) #printString 8 #() 1074 #<= 8 #() nil nil 672 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 1282 615 81 672 1234 #text: 34 1 8 'Column 1' 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 8 #() 1282 193 193 nil 35 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 576 34 2 8 1140850688 131073 1456 nil nil nil 5 nil nil nil 1456 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 1170 138 144 34 1 1234 #createAt:extent: 34 2 1282 1 81 1282 615 391 1456 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 784 1440 nil 27 170 192 34 4 1456 8 'workspace' 672 8 'heading' nil 1170 138 144 34 1 1234 #createAt:extent: 34 2 1282 327 21 1282 615 471 576 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 34 2 672 1456 1440 nil 27 5 false 170 192 784 1180166 ##(Graphics.Rectangle) 1282 21 21 1282 21 21 1170 138 144 34 1 1234 #createAt:extent: 34 2 1282 6143 21 1282 961 511 416 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 223 13 0 0 9 1 0 0] 34 2 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil nil nil 5 nil nil nil 2160 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.StaticIcon) 34 17 nil 2160 34 2 8 1140855043 1 2288 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 1074 #= 8 #() 1074 #hash 8 #() nil nil nil 5 nil nil nil 2288 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil nil 1170 138 144 34 1 1234 #createAt:extent: 34 2 1282 123 189 1282 65 65 2288 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 8 #() 1440 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #relativeParentWidth 655414 ##(Core.Float) 8 154 153 153 153 153 153 217 63 2722 #fixedViewLeft 65 2722 #relativeParentHeight 2754 8 154 153 153 153 153 153 217 63 2722 #fixedViewTop 65 410 ##(UI.StaticText) 34 16 nil 2160 34 2 8 1140850944 1 2848 nil nil nil 5 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1282 193 193 nil 2848 nil 8 1801195232 2498 nil nil nil 1170 138 144 34 2 1234 #createAt:extent: 34 2 1282 11 1 1282 281 141 2848 1234 #text: 34 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 2848 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 8 #() 1440 nil 27 2690 2722 #fixedParentLeft 11 2722 #fixedParentRight -15 2722 #fixedParentTop 1 2832 141 170 192 34 2 2288 8 'finderIcon' nil 1170 138 144 34 1 1234 #createAt:extent: 34 2 1282 21 21 1282 307 471 2160 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 34 2 2848 2288 1440 nil 27 576 1440 nil 27 )!

unregisterAsToolWith: aSmalltalkSystem
! !
!Tools.VisualObjectFinder class categoriesFor: #findNonDolphinWindows!accessing!public! !
!Tools.VisualObjectFinder class categoriesFor: #findNonDolphinWindows:!accessing!public! !
!Tools.VisualObjectFinder class categoriesFor: #icon!constants!public! !
!Tools.VisualObjectFinder class categoriesFor: #initialize!initializing!private! !
!Tools.VisualObjectFinder class categoriesFor: #publishedAspects!constants!public! !
!Tools.VisualObjectFinder class categoriesFor: #registerAsToolWith:!operations!public! !
!Tools.VisualObjectFinder class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.VisualObjectFinder class categoriesFor: #unregisterAsToolWith:!operations!public! !

Tools.VisualObjectFinder class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

