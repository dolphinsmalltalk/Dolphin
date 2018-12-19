"Filed out from Dolphin Smalltalk 7"!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 21 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ListView) 34 30 nil 576 34 2 8 1140936781 1 672 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 5 nil nil nil 672 nil 8 1915211424 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 17 158 106] #printString 864 7 257 nil ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 615 #left 459270 ##(Smalltalk.Message) #printString 784 1074 #<= 8 #() nil nil 672 nil 3 nil nil #report 784 nil 131169 nil 34 4 nil nil 328198 ##(Smalltalk.Point) 1 1 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 1154 1 1 1154 615 81 672 1250 #text: 34 1 8 'Column 1' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 51 1 0 0 40 0 0 0] 8 #() 1154 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 576 34 2 8 1140850688 131073 1456 nil nil nil 5 nil nil nil 1456 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 1186 138 144 34 1 1250 #createAt:extent: 34 2 1154 1 81 1154 615 391 1456 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 40 0 0 0 51 1 0 0 235 0 0 0] 784 1440 nil 27 170 192 34 4 672 8 'heading' 1456 8 'workspace' nil 1186 138 144 34 1 1250 #createAt:extent: 34 2 1154 327 21 1154 615 471 576 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 10 0 0 0 214 1 0 0 245 0 0 0] 34 2 672 1456 1440 nil 27 5 false 170 192 784 590342 ##(Smalltalk.Rectangle) 1154 21 21 1154 21 21 1186 138 144 34 1 1250 #createAt:extent: 34 2 1154 3839 21 1154 961 511 416 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 95 9 0 0 9 1 0 0] 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2160 nil nil nil 5 nil nil nil 2160 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 2160 34 2 8 1140850944 1 2288 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1154 193 193 nil 2288 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 1186 138 144 34 2 1250 #createAt:extent: 34 2 1154 11 1 1154 281 141 2288 1250 #text: 34 1 8 'Drag the visual finder icon below and drop over the Dolphin visual object you want to locate.' 2288 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 0 0 0 0 145 0 0 0 70 0 0 0] 8 #() 1440 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 2738 #fixedParentRight -15 2738 #fixedParentTop 1 2738 #fixedViewTop 141 410 ##(Smalltalk.StaticIcon) 34 17 nil 2160 34 2 8 1140855043 1 2816 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 1074 #= 8 #() 1074 #hash 8 #() nil nil nil 5 nil nil nil 2816 nil 8 1915124368 2466 nil nil nil nil 1186 138 144 34 1 1250 #createAt:extent: 34 2 1154 123 189 1154 65 65 2816 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 94 0 0 0 93 0 0 0 126 0 0 0] 8 #() 1440 nil 27 2706 2738 #relativeParentWidth 327734 ##(Smalltalk.Float) 8 154 153 153 153 153 153 217 63 2738 #fixedViewLeft 65 2738 #relativeParentHeight 3234 8 154 153 153 153 153 153 217 63 2800 65 170 192 34 2 2816 8 'finderIcon' nil 1186 138 144 34 1 1250 #createAt:extent: 34 2 1154 21 21 1154 307 471 2160 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 163 0 0 0 245 0 0 0] 34 2 2288 2816 1440 nil 27 576 1440 nil 27 )!

unregisterAsToolWith: aSmalltalkSystem
! !
!VisualObjectFinder class categoriesFor: #findNonDolphinWindows!accessing!public! !
!VisualObjectFinder class categoriesFor: #findNonDolphinWindows:!accessing!public! !
!VisualObjectFinder class categoriesFor: #icon!constants!public! !
!VisualObjectFinder class categoriesFor: #initialize!initializing!private! !
!VisualObjectFinder class categoriesFor: #publishedAspects!constants!public! !
!VisualObjectFinder class categoriesFor: #registerAsToolWith:!operations!public! !
!VisualObjectFinder class categoriesFor: #resource_Default_view!public!resources-views! !
!VisualObjectFinder class categoriesFor: #unregisterAsToolWith:!operations!public! !

VisualObjectFinder class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

