"Filed out from Dolphin Smalltalk X6.2"!

InspectorAbstract subclass: #VisualObjectFinder
	instanceVariableNames: 'mouseTracker finderIcon heading workspace foundView'
	classVariableNames: 'FindNonDolphinWindows'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VisualObjectFinder guid: (GUID fromString: '{B76A24F7-5FF3-41AC-9AA9-77EBF7B94816}')!
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
	
	[child := UserLibrary default 
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
!VisualObjectFinder categoriesFor: #browseObject!accessing!private! !
!VisualObjectFinder categoriesFor: #cancelTrackingAt:!private!tracking! !
!VisualObjectFinder categoriesFor: #continueTrackingAt:from:!private!tracking! !
!VisualObjectFinder categoriesFor: #createComponents!initializing!private! !
!VisualObjectFinder categoriesFor: #createSchematicWiring!initializing!private! !
!VisualObjectFinder categoriesFor: #displayOn:!displaying!public! !
!VisualObjectFinder categoriesFor: #endTrackingAt:!private!tracking! !
!VisualObjectFinder categoriesFor: #findObject!commands!public! !
!VisualObjectFinder categoriesFor: #foundView!public! !
!VisualObjectFinder categoriesFor: #inspecteeSelection!accessing!private! !
!VisualObjectFinder categoriesFor: #model:!accessing!public! !
!VisualObjectFinder categoriesFor: #onDragOver:!event handling!public! !
!VisualObjectFinder categoriesFor: #onDropOver:!event handling!public! !
!VisualObjectFinder categoriesFor: #onValueChanged!accessing!private! !
!VisualObjectFinder categoriesFor: #onViewOpened!event handling!private! !
!VisualObjectFinder categoriesFor: #startTrackingAt:!private!tracking! !
!VisualObjectFinder categoriesFor: #viewFromPoint:!helpers!private! !
!VisualObjectFinder categoriesFor: #visualObjectAt:!helpers!private! !

VisualObjectFinder methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!VisualObjectFinder class methodsFor!

findNonDolphinWindows
	^FindNonDolphinWindows!

findNonDolphinWindows: aBoolean
	FindNonDolphinWindows := aBoolean!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 21 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 592 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 592 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ListView)  98 30 0 592 98 2 8 1140936781 1 736 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  498 31 0 5 0 0 0 736 0 8 4294903801 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | x printString]' 8 #[30 105 17 158 106] 8 #printString 960 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Column 1' 615 8 #left 946 0 0 978 2 1 1008 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 17 158 106] 1072 1232 7 257 0 8 ##(Smalltalk.SortedCollection)  0 0 736 0 3 0 0 8 #report 864 0 131169 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1474 615 81 736 1410 8 #text: 98 1 8 'Column 1' 736 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 98 0 1474 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 592 98 2 8 1140850688 131073 1664 0 0 0 5 0 0 0 1664 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 1346 202 208 98 1 1410 1440 98 2 1474 1 81 1474 615 391 1664 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 864 1648 0 27 234 256 98 4 736 8 'heading' 1664 8 'workspace' 0 1346 202 208 98 1 1410 1440 98 2 1474 327 21 1474 615 471 592 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 98 2 736 1664 1648 0 27 5 32 234 256 864 590342 ##(Smalltalk.Rectangle)  1474 21 21 1474 21 21 1346 202 208 98 1 1410 1440 98 2 1474 2799 21 1474 961 511 416 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 87 7 0 0 9 1 0 0] 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 2416 0 498 31 0 5 0 0 0 2416 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 2416 98 2 8 1140850944 1 2560 0 0 0 5 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 1474 193 193 0 2560 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 0 1346 202 208 98 2 1410 1440 98 2 1474 11 1 1474 281 141 2560 1410 1536 98 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 2560 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 98 0 1648 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 11 3026 8 #fixedParentRight -15 3026 8 #fixedParentTop 1 3026 8 #fixedViewTop 141 410 8 ##(Smalltalk.StaticIcon)  98 17 0 2416 98 2 8 1140855043 1 3168 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 3314 8 #hash 98 0 0 0 0 5 0 0 0 3168 0 8 4294903625 2754 0 0 0 0 1346 202 208 98 1 1410 1440 98 2 1474 123 189 1474 65 65 3168 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 98 0 1648 0 27 2994 3026 8 #relativeParentWidth 327734 ##(Smalltalk.Float)  8 154 153 153 153 153 153 217 63 3026 8 #fixedViewLeft 65 3026 8 #relativeParentHeight 3666 8 154 153 153 153 153 153 217 63 3136 65 234 256 98 2 3168 8 'finderIcon' 0 1346 202 208 98 1 1410 1440 98 2 1474 21 21 1474 307 471 2416 1586 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 98 2 2560 3168 1648 0 27 592 1648 0 27 )!

uninitialize
	Smalltalk developmentSystem unregisterTool: self!

unregisterAsToolWith: aSmalltalkSystem
! !
!VisualObjectFinder class categoriesFor: #findNonDolphinWindows!accessing!public! !
!VisualObjectFinder class categoriesFor: #findNonDolphinWindows:!accessing!public! !
!VisualObjectFinder class categoriesFor: #initialize!initializing!private! !
!VisualObjectFinder class categoriesFor: #publishedAspects!constants!development!public! !
!VisualObjectFinder class categoriesFor: #registerAsToolWith:!operations!public! !
!VisualObjectFinder class categoriesFor: #resource_Default_view!public!resources-views! !
!VisualObjectFinder class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!VisualObjectFinder class categoriesFor: #unregisterAsToolWith:!operations!public! !

VisualObjectFinder class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

