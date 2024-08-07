"Filed out from Dolphin Smalltalk"!

Presenter subclass: #ProfilerSamplesPresenter
	instanceVariableNames: 'selectorFilter filterTarget index frame'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerSamplesPresenter guid: (GUID fromString: '{425d0eb4-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerSamplesPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerSamplesPresenter categoriesForClass!IDB Goodies! !

!ProfilerSamplesPresenter methodsFor!

canNavigateFirst
	| first |
	first := self nextMatchIn: (1 to: self samplesSize).
	^first ~~ 0 and: [first ~~ self index]!

canNavigateLast
	| last |
	last := self nextMatchIn: (self samplesSize to: 1 by: -1).
	^last ~~ 0 and: [last ~~ self index]!

canNavigateNext
	^(self nextMatchIn: (self index + 1 to: self samplesSize)) ~~ 0!

canNavigatePrevious
	^(self nextMatchIn: (self index - 1 to: 1 by: -1)) ~~ 0!

connectView
	super connectView.
	self setSampleRange!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	index := 0 asValue.
	self add: (TextPresenter on: index) name: 'sampleIndicator'.
	self add: (NumberPresenter on: index) name: 'sampleSelector'.
	self add: ListPresenter new name: 'frames'.
	self add: MethodWorkspace new name: 'workspace'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self framesPresenter
		when: #selectionChanged
			send: #onFrameSelectionChanged
			to: self;
		when: #actionPerformed
			send: #onActionPerformed
			to: self.
	index
		when: #valueChanged
		send: #onSampleIndexChanged
		to: self!

filterFirst
	"Find the first sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	<commandQuery: #canNavigateFirst>
	self filterNavigate: (1 to: self samplesSize)!

filterLast
	"Find the last sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	<commandQuery: #canNavigateLast>
	self filterNavigate: (self samplesSize to: 1 by: -1)!

filterNavigate: anInterval
	index value: (self nextMatchIn: anInterval)!

filterNext
	"Find the next sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	<commandQuery: #canNavigateNext>
	self filterNavigate: (self index + 1 to: self samplesSize)!

filterPrevious
	"Find the previous sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	<commandQuery: #canNavigatePrevious>
	self filterNavigate: (self index - 1 to: 1 by: -1)!

filterSelector: aCompiledCodeOrNil
	"Set the filterSelector up to look for any sample that contains a frame that matches
	the class/selector of aCompiledMethod. Move to the start and find the first match.
	If the argument is nil then the filter just steps one sample at a time"

	selectorFilter := aCompiledCodeOrNil isNil
				ifTrue: [[:o | true]]
				ifFalse: 
					[(aCompiledCodeOrNil isKindOf: CompiledMethod)
						ifTrue: [[:o | o isChildOfFrameFor: aCompiledCodeOrNil]]
						ifFalse: [[:o | false]]].
	filterTarget := aCompiledCodeOrNil.
	index setValue: -1.
	self filterFirst!

framesPresenter
	^self presenterNamed: 'frames'!

index
	^index value!

initialize
	"Initialize the receiver"

	super initialize.
	selectorFilter := [:o | true].
	^self!

nextMatchIn: anInterval
	^anInterval detect: [:each | selectorFilter value: (self model sampleAt: each)] ifNone: 0!

onFrameSelectionChanged
	"The frame selection has changed so update the source view accordingly"

	| text selectionRange styler |
	self selectionOrNil
		ifNil: 
			[text := ''.
			styler := NullScintillaStyler.
			selectionRange := 0 to: 0]
		ifNotNil: 
			[:selection |
			text := selection coloredSource.
			styler := selection compiledCode stylerClass.
			selectionRange := selection selectionRange].
	self workspace
		text: text;
		stylerClass: styler;
		selectionRange: selectionRange!

onSampleIndexChanged
	"The sample index has changed, e.g. the slider has been moved. Show the sample corresponding to the index."

	self showSample!

onViewOpened
	"When the view has been opened, and the sub views created, we can set the selection range. On
	subsequent model changes (therefore range changes) we have to use the #model: method as this
	method is never used again"

	super onViewOpened.
	self sampleIndicator view typeconverter: (UI.PluggableTypeConverter
				leftToRight: [:i | 'Sample <1d> of <2d>' << { i. self samplesSize }]).
	"Normally done when the model is set, but first time through the view is not connected."
	self setSampleRange.
	self workspace view isReadOnly: true!

parseContext
	^self selectedMethod
		ifNotNil: [:method | method parseContext]
		ifNil: [self systemModel defaultParseContext]!

sampleIndicator
	^self presenterNamed: 'sampleIndicator'!

sampleSelector
	^self presenterNamed: 'sampleSelector'!

samplesSize
	^self model samplesSize!

selectedMethod
	^self selectionOrNil ifNotNil: [:f | f compiledCode]!

selectionOrNil
	^self framesPresenter selectionOrNil!

setSampleRange
	"Set the range and initial index of the sampleSelector, the values reflecting the model"

	| first |
	first := self samplesSize min: 1.
	self sampleSelector view
		range: (first to: self samplesSize);
		pageSize: (self samplesSize // 50 max: 10).
	"Ensure the index model triggers a change notification"
	index
		setValue: -1;
		value: first!

showSample
	"The sample selected has changed. If index is 0 it means thare are no
	samples available (no sample set selected or an empty set) so just clear all
	the sub views. If it is a valid sample index the find and display the frames for
	the sample. Select either the frame set in frame "

	self index = 0
		ifTrue: 
			[self framesPresenter list: OrderedCollection new.
			self onFrameSelectionChanged]
		ifFalse: 
			[| frames |
			frames := (self model sampleAt: self index) frames.
			frame := filterTarget
						ifNil: [frames first]
						ifNotNil: [frames detect: [:each | each doClassAndSelectorMatch: filterTarget] ifNone: [frames first]].
			self framesPresenter
				list: frames;
				selection: frame].
	frame := nil!

workspace
	^self presenterNamed: 'workspace'! !

!ProfilerSamplesPresenter categoriesForMethods!
canNavigateFirst!commands-queries!private! !
canNavigateLast!commands-queries!private! !
canNavigateNext!commands-queries!private! !
canNavigatePrevious!commands-queries!private! !
connectView!operations!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterFirst!commands-actions!public! !
filterLast!commands-actions!public! !
filterNavigate:!helpers!private! !
filterNext!commands-actions!filtering!public! !
filterPrevious!commands-actions!filtering!public! !
filterSelector:!filtering!public! !
framesPresenter!accessing!private! !
index!accessing!public! !
initialize!initializing!public! !
nextMatchIn:!helpers!private! !
onFrameSelectionChanged!event handling!public! !
onSampleIndexChanged!event handling!public! !
onViewOpened!event handling!public! !
parseContext!accessing!public! !
sampleIndicator!accessing!private! !
sampleSelector!accessing!private! !
samplesSize!accessing!public! !
selectedMethod!accessing!public! !
selectionOrNil!public!selection! !
setSampleRange!helpers!private! !
showSample!helpers!private! !
workspace!accessing!public! !
!

!ProfilerSamplesPresenter class methodsFor!

defaultModel
	^ProfilerSampleSet name: 'None'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #face3d nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409288972 131073 544 nil 482 #default nil 517 nil nil nil 544 608 nil 170 192 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 544 34 2 8 1140850945 1 656 nil nil nil 5 nil nil nil 656 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 150 0 0 0 25 0 0 0] 193 688 nil 656 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'sampleIndicator' 410 ##(Smalltalk.Slider) 34 18 nil 544 34 2 8 1140850960 1 992 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 1 608 nil 5 nil nil nil 992 nil nil 722 nil nil 3 nil nil 754 34 4 802 #createWindow: 34 1 850 882 8 #[196 0 0 0 0 0 0 0 155 1 0 0 22 0 0 0] 193 1024 8 '' 992 802 #ticks: 34 1 8 #() 992 802 #pageSize: 8 #(0) 992 802 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 992 3 8 #() 946 193 193 nil 27 8 'sampleSelector' nil nil nil nil 138 144 1296 nil nil 9 915 nil nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 754 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 0 0 0 0 254 1 0 0 25 0 0 0] 193 576 8 '' 544 3 34 4 656 410 ##(Smalltalk.Toolbar) 34 28 nil 544 34 2 8 1409289036 131073 1648 nil 496 nil 517 nil nil nil 1648 608 nil 170 192 1296 nil nil nil nil 34 2 1115206 1 ##(Smalltalk.ToolbarIconButton) 1648 1 1180998 4 ##(Smalltalk.CommandDescription) #filterFirst 8 'First Match' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $\x23EE 8 'Georgia' nil 482 #highlight nil nil 1 nil nil nil 1746 1648 1 1778 #filterPrevious 8 'Previous Match' 1 1 1826 $\x23EA 8 'Georgia' nil 1872 nil nil 1 nil nil nil nil nil 9 1 nil nil nil nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[150 0 0 0 0 0 0 0 196 0 0 0 25 0 0 0] 193 1680 8 '' 1648 3 8 #() 946 193 193 nil 31 992 410 ##(Smalltalk.Toolbar) 34 28 nil 544 34 2 8 1409289036 131073 2128 nil 496 nil 517 nil nil nil 2128 608 nil 170 192 1296 nil nil nil nil 34 2 1746 2128 1 1778 #filterNext 8 'Next Match' 1 1 1826 $\x23E9 8 'Georgia' nil 1872 nil nil 1 nil nil nil 1746 2128 1 1778 #filterLast 8 'Last Match' 1 1 1826 $\x23ED 8 'Georgia' nil 1872 nil nil 1 nil nil nil nil nil 9 1 nil nil nil nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[155 1 0 0 0 0 0 0 201 1 0 0 25 0 0 0] 193 2160 8 '' 2128 3 8 #() 946 193 193 nil 31 946 193 193 nil 31 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2560 nil 608 nil 5 nil nil nil 2560 1180166 ##(Smalltalk.ProportionalLayout) 138 176 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2560 34 2 8 1140850688 1 2720 nil 608 nil 5 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2720 nil 1 #left nil nil nil 946 1 1 946 9 9 nil 2816 nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 193 2752 8 '' 2720 3 8 #() 946 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2560 34 2 8 1140953165 1025 3040 590662 2 ##(Smalltalk.ListModel) 138 144 1296 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 1 984134 2 ##(Smalltalk.CommandMenuItem) 1 1778 #browseIt 8 'Bro&wse <d:It>' 1 17 262982 4 ##(Smalltalk.Icon) nil true 2229254 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'ClassBrowserShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3040 nil nil ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Frame' 1013 #left ##(Smalltalk.BasicListAbstract) 3442 #<= 8 #() 3442 #yourself 8 #() nil 3040 3552 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 1638662 ##(Smalltalk.ListViewVirtualUpdateMode) 3040 nil nil nil nil nil nil nil nil nil 754 34 2 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 193 3072 8 'Frame' 3040 802 #contextMenu: 34 1 3200 3040 3 8 #() 946 193 193 nil 35 8 'frames' 410 ##(Smalltalk.ReferenceView) 34 14 nil 2560 34 2 8 1140850688 131073 3920 nil 482 #window nil 5 nil nil nil 3920 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 193 3952 8 '' 3920 3 1296 946 193 193 nil 27 8 'workspace' nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 193 2592 8 '' 2560 3 34 3 3040 2720 3920 946 193 193 nil 27 170 192 1296 nil 754 34 1 802 #createWindow: 34 1 850 882 8 #[255 14 0 0 10 0 0 0 253 16 0 0 69 1 0 0] 193 448 8 '' 416 1 34 2 544 2560 946 193 193 nil 27 )! !

!ProfilerSamplesPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

