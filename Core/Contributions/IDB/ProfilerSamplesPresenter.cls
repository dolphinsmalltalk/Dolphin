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

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: TextPresenter new name: 'sampleIndicator'.
	self add: NumberPresenter new name: 'sampleSelector'.
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
	(self presenterNamed: 'sampleSelector')
		when: #valueChanged
		send: #onSampleIndexChanged
		to: self!

filterNext
	"Find the next sample that answer true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self model samplesSize ~= 0 
		ifTrue: 
			[index := (index + 1 to: self model samplesSize) 
						detect: [:each | selectorFilter value: (self model sampleAt: each)]
						ifNone: 
							[Sound beep.
							index]].
	self filterStopped!

filterPrevious
	"Find the previous sample that answer true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self model samplesSize ~= 0 
		ifTrue: 
			[index := (index - 1 to: 1 by: -1) 
						detect: [:each | selectorFilter value: (self model sampleAt: each)]
						ifNone: 
							[Sound beep.
							index]].
	self filterStopped!

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
	index := 0.
	self filterNext!

filterStopped
	"The filter has selected sample index as the one to display. If either the filterTarget was 
	nil (filter turned off) or the target cannot be found in the frame then set frame to  nil which
	means the active frame will be selected, otherwise select the first frame that matches"

	frame := filterTarget isNil 
				ifFalse: 
					[(self model sampleAt: index) frames detect: [:each | each doClassAndSelectorMatch: filterTarget]
						ifNone: []].
	self showSample!

framesPresenter
	^self presenterNamed: 'frames'!

initialize
	"Initialize the receiver"

	super initialize.
	selectorFilter := [:o | true].
	index := 0.
	^self!

model: aProfilerSampleSet 
	"Set the model for the receiver. The test is needed to ensure that the sub views are all
	updated when the model is changed but prevent a walkback the first time the model is set, as
	part of the window creation procedure. The walkback occurs because the scroll bar subview
	is not ready, at that stage, to have its range set (also see #onViewOpened)"

	super model: aProfilerSampleSet.
	((self presenterNamed: 'sampleSelector') view isKindOf: DeafObject) ifFalse: [self setSampleRange]!

onFrameSelectionChanged
	"The frame selection has changed so update the source view accordingly"

	| selection text selectionRange styler |
	selection := self selectionOrNil.
	selection isNil
		ifTrue: 
			[text := String new.
			selectionRange := 0 to: 0.
			styler := NullScintillaStyler]
		ifFalse: 
			[text := selection coloredSource.
			styler := selection compiledCode stylerClass.
			selectionRange := selection selectionRange].
	(self presenterNamed: 'workspace')
		text: text;
		stylerClass: styler;
		selectionRange: selectionRange!

onSampleIndexChanged
	"The sample index has changed, the slider has been moved. Set the sample index and 
	show the sample"

	index := (self presenterNamed: 'sampleSelector') value.
	self showSample!

onViewOpened
	"When the view has been opened, and the sub views created, we can set the selection range. On
	subsequent model changes (therefore range changes) we have to use the #model: method as this
	method is never used again"

	super onViewOpened.
	self setSampleRange.
	(self presenterNamed: 'workspace') view isReadOnly: true!

parseContext
	^self selectedMethod!

sampleIndicator: anInteger 
	"Answer a String describing the position of the current sample in its world"

	^(String writeStream)
		nextPutAll: 'Sample ';
		print: anInteger;
		nextPutAll: ' out of ';
		print: self model samplesSize;
		contents!

selectedMethod
	^self selectionOrNil ifNotNil: [:f | f compiledCode]!

selectionOrNil
	^self framesPresenter selectionOrNil!

setSampleRange
	"Set the range and initial index of the sampleSelector, the values reflecting the model"

	index := self model samplesSize = 0 ifTrue: [0] ifFalse: [1].
	((self presenterNamed: 'sampleSelector') view)
		range: (index to: self model samplesSize);
		pageSize: self model samplesSize // 10.
	self showSample!

showSample
	"The sample selected has changed. If index is 0 it means thare are no
	samples available (no sample set selected or an empty set) so just clear all
	the sub views. If it is a valid sample index the find and display the frames for
	the sample. Select either the frame set in frame "

	(self presenterNamed: 'sampleIndicator') value: (self sampleIndicator: index).
	(self presenterNamed: 'sampleSelector') view scrollPosition: index.
	index = 0
		ifTrue: 
			[self framesPresenter list: OrderedCollection new.
			self onFrameSelectionChanged]
		ifFalse: 
			[| frames |
			frames := (self model sampleAt: index) frames.
			frame isNil ifTrue: [frame := frames first].
			self framesPresenter
				list: frames;
				selection: frame	"reverse"].
	self framesPresenter view layout.
	frame := nil! !
!ProfilerSamplesPresenter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterNext!filtering!public! !
filterPrevious!filtering!public! !
filterSelector:!filtering!public! !
filterStopped!filtering!public! !
framesPresenter!accessing!private! !
initialize!initializing!public! !
model:!accessing!public! !
onFrameSelectionChanged!event handling!public! !
onSampleIndexChanged!event handling!public! !
onViewOpened!event handling!public! !
parseContext!public! !
sampleIndicator:!helpers!private! !
selectedMethod!public! !
selectionOrNil!public!selection! !
setSampleRange!helpers!private! !
showSample!helpers!private! !
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

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Smalltalk.Color) #face3d nil 5 nil nil nil 416 1048838 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil 496 nil 5 nil nil nil 576 nil 170 192 34 4 410 ##(Smalltalk.ScrollBar) 34 16 nil 576 34 2 8 1140916224 1 672 918598 2 ##(Smalltalk.ValueHolder) nil false 1835526 ##(Smalltalk.PluggableSearchPolicy) 786950 ##(Smalltalk.Message) #= 8 #() 802 #hash 8 #() 1 482 #default nil 5 nil nil nil 672 nil 8 1840641056 1049094 ##(Smalltalk.NullConverter) nil nil true 1310982 ##(Smalltalk.MessageSequence) 34 3 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 471 3 1042 431 47 672 994 #range: 34 1 852742 ##(Smalltalk.Interval) 1 201 3 672 994 #pageSize: 8 #(0) 672 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 1 0 0 0 194 1 0 0 24 0 0 0] 8 #() 1042 193 193 nil 27 8 'sampleSelector' 410 ##(Smalltalk.StaticText) 34 16 nil 576 34 2 8 1140850945 1 1280 nil nil nil 5 nil nil nil 1280 nil 8 1840630688 914 nil nil nil 946 34 1 994 #createAt:extent: 34 2 1042 1 9 1042 351 47 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 4 0 0 0 175 0 0 0 27 0 0 0] 8 #() 1248 nil 27 8 'sampleIndicator' nil 946 34 1 994 #createAt:extent: 34 2 1042 1 1 1042 1021 49 576 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 24 0 0 0] 34 4 1280 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1140924416 1 1680 nil 880 1042 81 47 5 nil nil nil 1680 nil 8 1840590976 1377606 4 ##(Smalltalk.CommandDescription) #filterPrevious 8 '<<?' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 1042 381 3 1042 81 47 1680 994 #isEnabled: 8 #(false) 1680 994 #text: 34 1 8 '<<?' 1680 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 1 0 0 0 230 0 0 0 24 0 0 0] 8 #() 1248 nil 29 672 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1140924416 1 2048 nil 880 1042 81 47 5 nil nil nil 2048 nil 8 1840590976 1778 #filterNext 8 '?>>' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 1042 911 3 1042 81 47 2048 994 #isEnabled: 8 #(false) 2048 994 #text: 34 1 8 '?>>' 2048 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 199 1 0 0 1 0 0 0 239 1 0 0 24 0 0 0] 8 #() 1248 nil 29 1248 nil 27 1378374 2 ##(Smalltalk.FramingConstraints) 1377286 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2434 #fixedParentRight 1 2434 #fixedParentTop 1 2480 49 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2496 nil 880 nil 5 nil nil nil 2496 1376774 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2496 34 2 8 1140850688 1 2624 nil 880 nil 5 nil nil nil 1707078 1 ##(Smalltalk.DraggableViewInteractor) 2624 nil 1 #left nil nil nil 1042 1 1 1042 9 9 nil 2720 nil 946 34 1 994 #createAt:extent: 34 2 1042 1 287 1042 1021 7 2624 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 8 #() 1248 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2496 34 2 8 1140953165 1025 2928 787270 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 880 nil 5 461638 4 ##(Smalltalk.Menu) nil true 34 1 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1778 #browseIt 8 'Bro&wse It' 1 1 852806 4 ##(Smalltalk.Icon) nil true 2819078 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'ClassBrowserShell.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2928 nil 8 1840542896 ##(Smalltalk.BasicListAbstract) 802 #profilerIconIndex 8 #() 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Frame' 1013 #left ##(Smalltalk.BasicListAbstract) 802 #<= 8 #() 802 #yourself 8 #() nil 2928 3456 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 34 3 994 #createAt:extent: 34 2 1042 1 1 1042 1021 287 2928 994 #contextMenu: 34 1 3104 2928 994 #text: 34 1 8 'Frame' 2928 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 8 #() 1248 nil 35 8 'frames' 410 ##(Smalltalk.ReferenceView) 34 14 nil 2496 34 2 8 1140850688 131073 3824 nil 482 #window nil 5 nil nil nil 3824 1376838 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 946 34 1 994 #createAt:extent: 34 2 1042 1 293 1042 1021 289 3824 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 3040 1248 nil 27 8 'workspace' nil 946 34 1 994 #createAt:extent: 34 2 1042 1 51 1042 1021 581 2496 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 34 3 2928 2624 3824 1248 nil 27 2402 2448 1 2464 1 2480 51 2434 #fixedParentBottom 1 170 192 3040 1180166 ##(Smalltalk.Rectangle) 1042 1 1 1042 1 1 946 34 1 994 #createAt:extent: 34 2 1042 12287 21 1042 1021 631 416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 253 25 0 0 69 1 0 0] 34 2 576 2496 1248 nil 27 )! !
!ProfilerSamplesPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

