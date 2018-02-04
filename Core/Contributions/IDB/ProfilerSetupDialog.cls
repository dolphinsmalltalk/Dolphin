"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ProfilerSetupDialog
	instanceVariableNames: ''
	classVariableNames: 'IsCollect IsOn ProfiledBlock ProfiledText ProfilingInterval SampleSetName SamplingInterval'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSetupDialog guid: (GUID fromString: '{5bc9a7a0-5833-490b-b342-c0086dcf2ac1}')!
ProfilerSetupDialog comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSetupDialog categoriesForClass!IDB Goodies!MVP-Presenters! !
!ProfilerSetupDialog methodsFor!

apply
	"The dialog has been closed with OK and the responses are acceptable
	so copy the results into the class variables"

	IsCollect := (self presenterNamed: 'collect') value.
	IsOn := (self presenterNamed: 'profilingOn') value.
	SampleSetName := (self presenterNamed: 'set') view text.
	ProfilingInterval := (self presenterNamed: 'interval') value.
	ProfiledText := (self presenterNamed: 'source') text.
	super apply!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self
		add: BooleanPresenter new name: 'collect';
		add: BooleanPresenter new name: 'profilingOn';
		add: ListPresenter new name: 'set';
		add: NumberPresenter new name: 'interval';
		add: SmalltalkWorkspace new name: 'source'!

isAcceptable
	"Check all the response fields to make sure thay are acceptable. This also involves 
	compiling and checking the source code.
	Answer true if the dialog is acceptable"

	| sourcePresenter text |
	(self presenterNamed: 'set') view text isEmpty | (self presenterNamed: 'interval') value isNil 
		ifTrue: 
			[MessageBox warning: 'Both the Set and Interval must be given'.
			^false].
	(self presenterNamed: 'interval') value >= 1 
		ifFalse: 
			[MessageBox warning: 'The Interval must be greater than, or equal to, 1mS'.
			^false].
	(sourcePresenter := self presenterNamed: 'source') selection isEmpty 
		ifTrue: [sourcePresenter view selectAll].
	text := sourcePresenter selection trimBlanks.
	(text isEmpty or: [text first ~= $[ | (text last ~= $])]) 
		ifTrue: [sourcePresenter replaceSelection: '[' , text , ']'].
	(ProfiledBlock := sourcePresenter evaluateItIfFail: []) isNil 
		ifTrue: 
			[MessageBox warning: 'The evaluation block failed to compile'.
			^false].
	^true!

ok
	"Only continue if the responses are acceptable. A bad response will have already
	given an error message so we can just abandon"

	self isAcceptable ifFalse: [^self].
	super ok!

onViewOpened
	"When the view has been opened we need to initialize the fields from the class vars.
	If they haven't been used before, are not initialized (IsCollect == nil) then just do a reset"

	super onViewOpened.
	IsCollect isNil ifTrue: [self reset] ifFalse: [self setFields]!

reset
	"Reset all the class inst vars to their defaul values"

	IsCollect := false.
	IsOn := true.
	SampleSetName := ProfilerSampleSetManager defaultSetName.
	ProfilingInterval := 1.
	ProfiledText := '["Enter the code to profile"
        ]' asRichText.
	self setFields!

setFields
	"Set the field with the appropriate values, either from the class inst vars oe external singletons"

	| sampleSetNames |
	sampleSetNames := ProfilerSampleSetManager default sampleSetNames.
	(sampleSetNames includes: ProfilerSampleSetManager defaultSetName) 
		ifFalse: [sampleSetNames add: ProfilerSampleSetManager defaultSetName].
	(self presenterNamed: 'collect') value: IsCollect.
	(self presenterNamed: 'profilingOn') value: IsOn.
	(self presenterNamed: 'set') list: sampleSetNames.
	(self presenterNamed: 'interval') value: ProfilingInterval.
	(self presenterNamed: 'source') text: ProfiledText.
	(self presenterNamed: 'set') view text: SampleSetName! !
!ProfilerSetupDialog categoriesFor: #apply!commands!public! !
!ProfilerSetupDialog categoriesFor: #createComponents!initializing!public! !
!ProfilerSetupDialog categoriesFor: #isAcceptable!public!testing! !
!ProfilerSetupDialog categoriesFor: #ok!commands!public! !
!ProfilerSetupDialog categoriesFor: #onViewOpened!event handling!public! !
!ProfilerSetupDialog categoriesFor: #reset!commands!public! !
!ProfilerSetupDialog categoriesFor: #setFields!initializing!public! !

!ProfilerSetupDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized.
	We use true to obtain a useful return value when the dialog is closed"

	^true!

interval
	"Accessor for the Interval class variable"

	^ProfilingInterval!

isCollect
	"Accessor for the IsCollect class variable"

	^IsCollect!

isOn
	"Accessor for the IsOn class variable"

	^IsOn!

profiledBlock
	"Accessor for the ProfiledBlock class variable"

	^ProfiledBlock!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 801 801 679 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 7 nil nil nil 576 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1141055488 1 704 nil nil nil 7 nil nil nil 704 nil 8 4294908691 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 'OK' 1 1 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 409 25 514 151 47 704 898 #isEnabled: 8 #(false) 704 898 #text: 34 1 8 'OK' 704 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 12 0 0 0 23 1 0 0 35 0 0 0] 8 #() 514 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -149 1170 #fixedParentRight -169 1170 #fixedViewBottom -45 1170 #fixedParentBottom 1 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1140924416 1 1248 nil nil nil 7 nil nil nil 1248 nil 8 4294908691 786 #reset 8 'Reset' 1 1 nil nil false nil nil nil 834 138 144 34 3 898 #createAt:extent: 34 2 514 21 23 514 141 51 1248 898 #isEnabled: 8 #(false) 1248 898 #text: 34 1 8 'Reset' 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 80 0 0 0 36 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedParentLeft 11 1170 #fixedViewLeft 141 1170 #fixedParentTop 13 1170 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1140924416 1 1680 nil nil nil 7 nil nil nil 1680 nil 8 4294908691 786 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 514 579 25 514 151 47 1680 898 #text: 34 1 8 'Cancel' 1680 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 12 0 0 0 108 1 0 0 35 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedPreviousRight 21 1632 151 1216 -45 1232 1 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 514 11 11 514 1 1 834 138 144 34 1 898 #createAt:extent: 34 2 514 21 633 514 729 71 576 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 118 1 0 0 95 1 0 0] 34 3 704 1680 1248 1120 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2288 nil nil nil 7 nil nil nil 2288 642 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 nil 2288 34 2 8 1176571972 1025 2400 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 8 4278190080 nil 7 nil nil nil 2400 nil 8 4294907129 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2642 77 786694 ##(Smalltalk.IndexedColor) 33554457 2690 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 2656 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 2400 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2048 nil 170 176 2048 nil nil nil nil nil 2690 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 2608 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 2400 33423361 5 nil nil nil nil nil nil nil nil 8 'indicator0' 2994 1 2400 65025 3 nil nil nil nil nil nil nil nil 8 'indicator2' 2994 5 2400 511 1 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2642 1027 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 2642 1029 3138 60239 3138 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2642 1031 3138 335 3138 31317503 1 nil nil nil nil #Error nil nil nil nil 834 138 144 34 7 898 #createAt:extent: 34 2 514 1 201 514 729 413 2400 898 #modificationEventMask: 8 #(3912191) 2400 898 #caretPeriod: 8 #(530) 2400 898 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 2400 1 3 nil nil nil nil 3490 3 2400 1 nil 3 67108863 nil nil 3490 5 2400 1 nil 3 -67108863 nil nil 2400 898 #tabWidth: 8 #(4) 2400 898 #maxCompletionListHeight: 8 #(9) 2400 898 #sciSetCodePage: 8 #(65001) 2400 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 0 0 0 108 1 0 0 50 1 0 0] 8 #() 1120 nil 29 1138 1616 1 1200 1 1170 #fixedPreviousBottom 1 1232 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2288 34 2 8 1140850688 131073 3728 nil nil nil 7 nil nil nil 3728 642 170 176 34 12 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1409363203 1 3840 2466 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 3840 nil 8 4294908691 2578 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 514 17 17 514 227 43 3840 898 #text: 34 1 8 'Collect' 3840 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 121 0 0 0 29 0 0 0] 8 #() 1120 nil 27 1138 1616 17 1632 227 1648 17 1664 43 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850945 1 4208 nil nil nil 7 nil nil nil 4208 nil 8 4294902487 2578 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 514 243 95 514 241 39 4208 898 #text: 34 1 8 'Interval (mS)' 4208 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 47 0 0 0 241 0 0 0 66 0 0 0] 8 #() 1120 nil 27 1138 1170 #fixedPreviousLeft 1 1632 241 3712 41 1664 39 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1409363203 1 4544 2466 nil nil 3936 false nil nil 7 nil nil nil 4544 nil 8 4294908691 2578 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 514 17 91 514 227 43 4544 898 #text: 34 1 8 'Profiling On' 4544 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 45 0 0 0 121 0 0 0 66 0 0 0] 8 #() 1120 nil 27 1138 4528 1 1632 227 3712 33 1664 43 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850945 1 4880 nil nil nil 7 nil nil nil 4880 nil 8 4294902487 2578 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 514 243 17 514 241 39 4880 898 #text: 34 1 8 'Sampling Set' 4880 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 8 0 0 0 241 0 0 0 27 0 0 0] 8 #() 1120 nil 27 1138 2016 1 1632 241 1648 17 1664 39 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140924416 1025 5200 nil 466 8 4278190080 nil 7 nil nil nil 5200 nil 8 4294905095 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 834 138 144 34 1 898 #createAt:extent: 34 2 514 483 93 514 231 39 5200 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 46 0 0 0 100 1 0 0 65 0 0 0] 8 #() 1120 nil 27 1138 4528 1 1632 231 3712 37 1664 39 410 ##(Smalltalk.ComboBox) 34 17 nil 3728 34 2 8 1144063490 1025 5536 590662 2 ##(Smalltalk.ListModel) 138 144 2048 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 nil 7 nil nil nil 5536 nil 8 4294905617 459270 ##(Smalltalk.Message) #displayString 8 #() 2048 401 834 138 144 34 1 898 #createAt:extent: 34 2 514 483 9 514 251 53 5536 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 4 0 0 0 110 1 0 0 30 0 0 0] 8 #() 1120 nil 27 1138 2016 1 1632 251 1648 9 1664 49 170 192 34 8 3840 8 'collect' 4544 8 'profilingOn' 5536 8 'set' 5200 8 'interval' nil 834 138 144 34 1 898 #createAt:extent: 34 2 514 1 1 514 729 201 3728 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 108 1 0 0 100 0 0 0] 34 6 3840 4544 4880 4208 5536 5200 1120 nil 27 1138 1616 1 1200 1 1648 1 1664 201 170 192 34 2 2400 8 'source' nil 834 138 144 34 1 898 #createAt:extent: 34 2 514 21 21 514 729 613 2288 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 118 1 0 0 60 1 0 0] 34 2 3728 2400 1120 nil 27 170 192 2048 2066 514 21 21 514 21 21 nil nil nil nil 22765 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2008584928 834 138 144 34 2 898 #createAt:extent: 34 2 514 3839 21 514 801 801 416 898 #updateMenuBar 2048 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 15 9 0 0 154 1 0 0] 34 2 2288 576 1120 nil 27 )!

sampleSetName
	"Accessor for the SampleSetName class variable"

	^SampleSetName! !
!ProfilerSetupDialog class categoriesFor: #defaultModel!models!public! !
!ProfilerSetupDialog class categoriesFor: #interval!accessing!public! !
!ProfilerSetupDialog class categoriesFor: #isCollect!accessing!public! !
!ProfilerSetupDialog class categoriesFor: #isOn!accessing!public! !
!ProfilerSetupDialog class categoriesFor: #profiledBlock!accessing!public! !
!ProfilerSetupDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!ProfilerSetupDialog class categoriesFor: #sampleSetName!accessing!public! !

