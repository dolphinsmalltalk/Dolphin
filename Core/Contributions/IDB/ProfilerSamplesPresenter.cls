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

	| selection text selectionRange styler |
	selection := (self presenterNamed: 'frames') selectionOrNil.
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

!ProfilerSamplesPresenter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filterNext!filtering!public! !
filterPrevious!filtering!public! !
filterSelector:!filtering!public! !
filterStopped!filtering!public! !
initialize!initializing!public! !
model:!accessing!public! !
onFrameSelectionChanged!event handling!public! !
onSampleIndexChanged!event handling!public! !
onViewOpened!event handling!public! !
parseContext!public! !
sampleIndicator:!helpers!private! !
selectedMethod!public! !
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #face3d nil 7 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil 482 #default nil 7 nil nil nil 576 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 576 34 2 8 1140850688 1 720 nil 640 nil 7 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 720 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 818 9 9 nil 832 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 193 752 8 '' 720 3 8 #() 818 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ListView) 34 45 nil 576 34 2 8 1140953165 1025 1136 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 640 nil 7 nil nil nil 1136 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Frame' 1013 #left ##(Smalltalk.BasicListAbstract) 1314 #<= 8 #() 1314 #yourself 8 #() nil 1136 1424 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 193 1168 8 'Frame' 1136 3 8 #() 818 193 193 nil 35 8 'frames' 410 ##(Smalltalk.ReferenceView) 34 14 nil 576 34 2 8 1140850688 131073 1744 nil 482 #window nil 7 nil nil nil 1744 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 193 1776 8 '' 1744 3 1248 818 193 193 nil 27 8 'workspace' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 193 608 8 '' 576 3 34 3 1136 720 1744 818 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2242 #fixedParentRight 1 2242 #fixedParentTop 51 2242 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2320 nil 496 nil 7 nil nil nil 2320 nil 170 192 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 2320 34 2 8 1140850945 1 2416 nil nil nil 7 nil nil nil 2416 nil 8 1795912768 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 4 0 0 0 175 0 0 0 27 0 0 0] 193 2448 nil 2416 930 #text: 34 1 8 '' 2416 3 8 #() 818 193 193 nil 27 8 'sampleIndicator' 410 ##(Smalltalk.ScrollBar) 34 16 nil 2320 34 2 8 1140916224 1 2752 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 1314 #= 8 #() 1314 #hash 8 #() 1 640 nil 7 nil nil nil 2752 nil 8 1795896368 2498 nil nil true 866 138 144 34 3 930 #createWindow: 34 1 978 1010 8 #[235 0 0 0 1 0 0 0 194 1 0 0 24 0 0 0] 193 2784 8 '' 2752 930 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 2752 930 #pageSize: 8 #(0) 2752 3 8 #() 818 193 193 nil 27 8 'sampleSelector' nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 254 1 0 0 24 0 0 0] 193 2352 8 '' 2320 3 34 4 2416 410 ##(Smalltalk.PushButton) 34 20 nil 2320 34 2 8 1140924416 1 3424 nil 640 818 81 47 7 nil nil nil 3424 nil 8 1795707744 1180998 4 ##(Smalltalk.CommandDescription) #filterPrevious 8 '<<?' 1 1 nil nil false nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[190 0 0 0 1 0 0 0 230 0 0 0 24 0 0 0] 193 3456 8 '<<?' 3424 930 #isEnabled: 8 #(false) 3424 3 8 #() 818 193 193 nil 29 2752 410 ##(Smalltalk.PushButton) 34 20 nil 2320 34 2 8 1140924416 1 3776 nil 640 818 81 47 7 nil nil nil 3776 nil 8 1795707744 3522 #filterNext 8 '?>>' 1 1 nil nil false nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[199 1 0 0 1 0 0 0 239 1 0 0 24 0 0 0] 193 3808 8 '?>>' 3776 930 #isEnabled: 8 #(false) 3776 3 8 #() 818 193 193 nil 29 818 193 193 nil 27 2210 2256 1 2272 1 2288 1 2288 49 170 192 1248 nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[255 14 0 0 10 0 0 0 253 16 0 0 69 1 0 0] 193 448 8 '' 416 1 34 2 2320 576 818 193 193 nil 27 )! !

!ProfilerSamplesPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

