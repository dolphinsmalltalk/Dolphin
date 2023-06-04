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

	self filterNavigate: (1 to: self samplesSize)!

filterLast
	"Find the last sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self filterNavigate: (self samplesSize to: 1 by: -1)!

filterNavigate: anInterval
	index value: (self nextMatchIn: anInterval)!

filterNext
	"Find the next sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self filterNavigate: (self index + 1 to: self samplesSize)!

filterPrevious
	"Find the previous sample that answers true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

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

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver into the <CommandQuery>."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #filterFirst
		ifTrue: 
			[| first |
			first := self nextMatchIn: (1 to: self samplesSize).
			aCommandQuery isEnabled: (first ~~ 0 and: [first ~~ self index]).
			^true].
	cmd == #filterPrevious
		ifTrue: 
			[aCommandQuery isEnabled: (self nextMatchIn: (self index - 1 to: 1 by: -1)) ~~ 0.
			^true].
	cmd == #filterNext
		ifTrue: 
			[aCommandQuery isEnabled: (self nextMatchIn: (self index + 1 to: self samplesSize)) ~~ 0.
			^true].
	cmd == #filterLast
		ifTrue: 
			[| last |
			last := self nextMatchIn: (self samplesSize to: 1 by: -1).
			aCommandQuery isEnabled: (last ~~ 0 and: [last ~~ self index]).
			^true].
	^false!

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
connectView!operations!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterFirst!commands!public! !
filterLast!commands!public! !
filterNavigate:!helpers!private! !
filterNext!filtering!public! !
filterPrevious!filtering!public! !
filterSelector:!filtering!public! !
framesPresenter!accessing!private! !
index!accessing!public! !
initialize!initializing!public! !
nextMatchIn:!helpers!private! !
onFrameSelectionChanged!event handling!public! !
onSampleIndexChanged!event handling!public! !
onViewOpened!event handling!public! !
parseContext!accessing!public! !
queryCommand:!commands!public! !
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

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Smalltalk.Color) #face3d nil 5 nil nil nil 416 984838 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409288972 131073 544 nil 482 #default nil 517 nil nil nil 544 608 8 1807012928 170 192 34 4 410 ##(Smalltalk.Slider) 34 18 nil 544 34 2 8 1140850960 1 672 918598 2 ##(Smalltalk.ValueHolder) nil false 1769478 ##(Smalltalk.EqualitySearchPolicy) 1 608 nil 5 nil nil nil 672 nil 8 1806558272 1049094 ##(Smalltalk.NullConverter) nil nil 3 nil nil 1310982 ##(Smalltalk.MessageSequence) 34 4 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 393 1 946 431 45 672 898 #ticks: 34 1 8 #() 672 898 #pageSize: 8 #(0) 672 898 #range: 34 1 852742 ##(Smalltalk.Interval) 1 201 3 672 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 0 0 0 0 155 1 0 0 22 0 0 0] 8 #() 946 193 193 nil 27 8 'sampleSelector' 410 ##(Smalltalk.StaticText) 34 16 nil 544 34 2 8 1140850945 1 1232 nil nil nil 5 nil nil nil 1232 nil 8 1807113392 818 nil nil nil 850 34 1 898 #createAt:extent: 34 2 946 1 1 946 301 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 150 0 0 0 25 0 0 0] 8 #() 1200 nil 27 8 'sampleIndicator' nil nil nil 170 192 1024 138 144 1024 nil nil 1 nil nil nil nil 852806 1 ##(Smalltalk.FlowLayout) 1 1 1 850 34 1 898 #createAt:extent: 34 2 946 1 1 946 1021 51 544 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 25 0 0 0] 34 4 1232 410 ##(Smalltalk.Toolbar) 34 28 nil 544 34 2 8 1409289036 131073 1696 nil 496 nil 517 nil nil nil 1696 608 8 1807012928 170 192 1024 nil nil nil 170 192 34 4 55383 1311814 1 ##(Smalltalk.ToolbarIconButton) 1696 1 1377606 4 ##(Smalltalk.CommandDescription) #filterPrevious 8 'Previous Match' 1 1 1378630 2 ##(Smalltalk.TextTileIcon) $⏪ 8 'Georgia' nil 482 #highlight nil nil 1 nil nil 55383 55381 1826 1696 1 1858 #filterFirst 8 'First Match' 1 1 1906 $⏮ 8 'Georgia' nil 1952 nil nil 1 nil nil 55381 34 2 1968 1840 nil nil 1 nil nil nil nil nil 850 34 1 898 #createAt:extent: 34 2 946 301 1 946 93 51 1696 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 0 0 0 0 0 0 0 196 0 0 0 25 0 0 0] 8 #() 1200 nil 29 672 410 ##(Smalltalk.Toolbar) 34 28 nil 544 34 2 8 1409289036 131073 2208 nil 496 nil 517 nil nil nil 2208 608 8 1807012928 170 192 1024 nil nil nil 170 192 34 4 55385 1826 2208 1 1858 #filterNext 8 'Next Match' 1 1 1906 $⏩ 8 'Georgia' nil 1952 nil nil 1 nil nil 55385 55387 1826 2208 1 1858 #filterLast 8 'Last Match' 1 1 1906 $⏭ 8 'Georgia' nil 1952 nil nil 1 nil nil 55387 34 2 2336 2416 nil nil 1 nil nil nil nil nil 850 34 1 898 #createAt:extent: 34 2 946 823 1 946 93 51 2208 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 1 0 0 0 0 0 0 201 1 0 0 25 0 0 0] 8 #() 1200 nil 29 1200 nil 29 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2656 nil 608 nil 5 nil nil nil 2656 1376774 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2656 34 2 8 1140850688 1 2784 nil 608 nil 5 nil nil nil 1707078 1 ##(Smalltalk.DraggableViewInteractor) 2784 nil 1 #left nil nil nil 946 1 1 946 9 9 nil 2880 nil 850 34 1 898 #createAt:extent: 34 2 946 1 287 946 1021 7 2784 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 8 #() 1200 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2656 34 2 8 1140953165 1025 3088 787270 2 ##(Smalltalk.ListModel) 138 144 1024 nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 608 nil 5 461638 4 ##(Smalltalk.Menu) nil true 34 1 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1858 #browseIt 8 'Bro&wse It' 1 1 852806 4 ##(Smalltalk.Icon) nil true 2819078 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'ClassBrowserShell.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3088 nil 8 1806969104 ##(Smalltalk.BasicListAbstract) 786950 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Frame' 1013 #left ##(Smalltalk.BasicListAbstract) 3506 #<= 8 #() 3506 #yourself 8 #() nil 3088 3616 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 850 34 2 898 #createAt:extent: 34 2 946 1 1 946 1021 287 3088 898 #text: 34 1 8 'Frame' 3088 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 8 #() 1200 nil 35 8 'frames' 410 ##(Smalltalk.ReferenceView) 34 14 nil 2656 34 2 8 1140850688 131073 3952 nil 482 #window nil 5 nil nil nil 3952 1376838 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 850 34 1 898 #createAt:extent: 34 2 946 1 293 946 1021 289 3952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 1024 1200 nil 27 8 'workspace' nil 850 34 1 898 #createAt:extent: 34 2 946 1 51 946 1021 581 2656 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 34 3 3088 2784 3952 1200 nil 27 170 192 1024 1180166 ##(Smalltalk.Rectangle) 946 1 1 946 1 1 850 34 1 898 #createAt:extent: 34 2 946 6143 21 946 1021 631 416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 253 13 0 0 69 1 0 0] 34 2 544 2656 1200 nil 27 )! !
!ProfilerSamplesPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

