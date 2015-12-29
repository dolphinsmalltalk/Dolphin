"Filed out from Dolphin Smalltalk X6"!

Presenter subclass: #ProfilerSamplesPresenter
	instanceVariableNames: 'selectorFilter filterTarget index frame'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSamplesPresenter guid: (GUID fromString: '{425D0EB4-542E-11D3-998B-D5CA2C3C1D61}')!
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
	(self presenterNamed: 'frames') 
		when: #selectionChanged
		send: #onFrameSelectionChanged
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

initialize
	"Initialize the reciver"

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

	| selection text selectionRange |
	selection := (self presenterNamed: 'frames') selectionOrNil.
	selection isNil 
		ifTrue: 
			[text := String new.
			selectionRange := 0 to: 0]
		ifFalse: 
			[text := selection coloredSource.
			selectionRange := selection selectionRange].
	(self presenterNamed: 'workspace')
		text: text;
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
	self setSampleRange!

parseContext
	^self selectedMethod ifNotNil: [:method | method methodClass]!

sampleIndicator: anInteger 
	"Answer a String describing the position of the current sample in its world"

	^(String writeStream)
		nextPutAll: 'Sample ';
		print: anInteger;
		nextPutAll: ' out of ';
		print: self model samplesSize;
		contents!

selectedMethod
	^(self presenterNamed: 'frames') selectionOrNil ifNotNil: [:f | f compiledCode]!

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
			[(self presenterNamed: 'frames') list: OrderedCollection new.
			self onFrameSelectionChanged]
		ifFalse: 
			[| frames |
			frames := (self model sampleAt: index) frames.
			frame isNil ifTrue: [frame := frames first].
			(self presenterNamed: 'frames')
				list: frames;
				selection: frame	"reverse"].
	(self presenterNamed: 'frames') view layout.
	frame := nil! !
!ProfilerSamplesPresenter categoriesFor: #createComponents!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #filterNext!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterPrevious!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterSelector:!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterStopped!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #initialize!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #model:!accessing!public! !
!ProfilerSamplesPresenter categoriesFor: #onFrameSelectionChanged!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #onSampleIndexChanged!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #onViewOpened!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #parseContext!public! !
!ProfilerSamplesPresenter categoriesFor: #sampleIndicator:!private helpers!public! !
!ProfilerSamplesPresenter categoriesFor: #selectedMethod!public! !
!ProfilerSamplesPresenter categoriesFor: #setSampleRange!private helpers!public! !
!ProfilerSamplesPresenter categoriesFor: #showSample!private helpers!public! !

!ProfilerSamplesPresenter class methodsFor!

defaultModel
	^ProfilerSampleSet name: 'None'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 721158 ##(SystemColor) 31 0 5 0 0 0 416 852230 ##(FramingLayout) 234 240 98 4 410 432 98 15 0 416 98 2 8 1140850688 131073 592 0 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 592 1180166 ##(ProportionalLayout) 234 240 98 2 410 8 ##(Splitter) 98 12 0 592 98 2 8 1140850688 1 768 0 658 688 0 5 0 0 0 768 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 1 287 994 1021 7 768 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 98 0 994 193 193 0 27 1 16 234 256 98 4 410 8 ##(ReferenceView) 98 14 0 592 98 2 8 1140850688 131073 1152 0 0 0 5 0 0 0 1152 1180166 ##(ResourceIdentifier) 8 ##(SmalltalkWorkspace) 8 #resource_Default_view 0 866 202 208 98 1 930 960 98 2 994 1 293 994 1021 289 1152 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 98 0 1104 0 27 8 'workspace' 410 8 ##(ListView) 98 30 0 592 98 2 8 1140953165 1025 1472 590662 2 ##(ListModel) 202 208 1440 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 658 688 0 5 0 0 0 1472 0 8 4294904214 8 ##(BasicListAbstract) 459270 ##(Message) 8 #profilerIconIndex 98 0 1610 8 ##(IconImageManager) 8 #current 0 0 0 0 0 0 202 208 98 1 920646 5 ##(ListViewColumn) 8 'Frame' 1013 8 #left 1696 8 ##(SortedCollection) 1714 8 #yourself 98 0 0 1472 1856 3 0 0 8 #report 1440 0 131169 0 0 866 202 208 98 2 930 960 98 2 994 1 1 994 1021 287 1472 930 8 #text: 98 1 8 'Frame' 1472 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 98 0 1104 0 27 8 'frames' 0 866 202 208 98 1 930 960 98 2 994 1 51 994 1021 581 592 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 98 3 1472 768 1152 1104 0 27 1181766 2 ##(FramingConstraints) 1610 8 ##(FramingCalculation) 8 #fixedParentLeft 1 1610 2448 8 #fixedParentRight 1 1610 2448 8 #fixedParentTop 51 1610 2448 8 #fixedParentBottom 1 410 432 98 15 0 416 98 2 8 1140850688 131073 2576 0 498 31 0 5 0 0 0 2576 0 234 256 98 4 410 8 ##(StaticText) 98 16 0 2576 98 2 8 1140850945 1 2688 0 0 0 5 0 0 0 2688 0 8 4294904244 852486 ##(NullConverter) 0 0 0 866 202 208 98 1 930 960 98 2 994 1 9 994 351 47 2688 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 4 0 0 0 175 0 0 0 27 0 0 0] 98 0 1104 0 27 8 'sampleIndicator' 410 8 ##(ScrollBar) 98 16 0 2576 98 2 8 1140916224 1 2992 721990 2 ##(ValueHolder) 0 32 1376774 ##(PluggableSearchPolicy) 1714 8 #= 98 0 1714 8 #hash 98 0 1 658 688 0 5 0 0 0 2992 0 8 4294905134 2786 0 0 16 866 202 208 98 3 930 960 98 2 994 471 3 994 431 47 2992 930 8 #range: 98 1 525062 ##(Interval) 1 201 3 2992 930 8 #pageSize: 98 1 1 2992 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 1 0 0 0 194 1 0 0 24 0 0 0] 98 0 1104 0 27 8 'sampleSelector' 0 866 202 208 98 1 930 960 98 2 994 1 1 994 1021 49 2576 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 24 0 0 0] 98 4 2688 410 8 ##(PushButton) 98 17 0 2576 98 2 8 1140924416 1 3744 0 658 688 994 81 47 5 0 0 0 3744 0 8 4294904762 1180998 4 ##(CommandDescription) 8 #filterPrevious 8 '<<?' 1 1 0 0 32 866 202 208 98 3 930 960 98 2 994 381 3 994 81 47 3744 930 8 #isEnabled: 98 1 32 3744 930 2128 98 1 8 '<<?' 3744 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 1 0 0 0 230 0 0 0 24 0 0 0] 98 0 1104 0 27 2992 410 3760 98 17 0 2576 98 2 8 1140924416 1 4192 0 658 688 994 81 47 5 0 0 0 4192 0 8 4294904762 3874 8 #filterNext 8 '?>>' 1 1 0 0 32 866 202 208 98 3 930 960 98 2 994 911 3 994 81 47 4192 930 4064 98 1 32 4192 930 2128 98 1 8 '?>>' 4192 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 199 1 0 0 1 0 0 0 239 1 0 0 24 0 0 0] 98 0 1104 0 27 1104 0 27 2402 2432 1 2480 1 2512 1 2512 49 234 256 1440 590342 ##(Rectangle) 994 1 1 994 1 1 866 202 208 98 1 930 960 98 2 994 20001 20001 994 1021 631 416 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 14 41 0 0 75 40 0 0] 98 2 2576 592 1104 0 27)! !
!ProfilerSamplesPresenter class categoriesFor: #defaultModel!models!public! !
!ProfilerSamplesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

