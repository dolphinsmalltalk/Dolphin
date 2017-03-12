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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 0 0 8 #(13107200 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 801 801 647 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 576 0 0 0 7 0 0 0 576 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 0 576 34 2 8 1140924416 1 704 0 0 0 7 0 0 0 704 0 8 4294903891 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'Cancel' 1 1 0 0 false 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 579 25 514 151 47 704 898 #text: 34 1 8 'Cancel' 704 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 12 0 0 0 108 1 0 0 35 0 0 0] 8 #() 514 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1138 #fixedViewLeft 151 1138 #fixedViewBottom -45 1138 #fixedParentBottom 1 410 ##(Smalltalk.PushButton) 34 20 0 576 34 2 8 1141055488 1 1216 0 0 0 7 0 0 0 1216 0 8 4294903891 786 #ok 8 'OK' 1 1 0 0 true 0 0 0 834 138 144 34 3 898 #createAt:extent: 34 2 514 409 25 514 151 47 1216 898 #isEnabled: 8 #(false) 1216 898 #text: 34 1 8 'OK' 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 12 0 0 0 23 1 0 0 35 0 0 0] 8 #() 1088 0 29 1106 1138 #fixedViewRight -149 1138 #fixedParentRight -169 1184 -45 1200 1 410 ##(Smalltalk.PushButton) 34 20 0 576 34 2 8 1140924416 1 1616 0 0 0 7 0 0 0 1616 0 8 4294903891 786 #reset 8 'Reset' 1 1 0 0 false 0 0 0 834 138 144 34 3 898 #createAt:extent: 34 2 514 21 23 514 141 51 1616 898 #isEnabled: 8 #(false) 1616 898 #text: 34 1 8 'Reset' 1616 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 80 0 0 0 36 0 0 0] 8 #() 1088 0 29 1106 1138 #fixedParentLeft 11 1168 141 1138 #fixedParentTop 13 1138 #fixedViewTop 51 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 514 11 11 514 1 1 834 138 144 34 1 898 #createAt:extent: 34 2 514 21 633 514 729 71 576 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 118 1 0 0 95 1 0 0] 34 3 1216 704 1616 1088 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 2288 0 0 0 7 0 0 0 2288 642 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 0 2288 34 2 8 1176571972 1025 2400 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 466 8 4278190080 0 7 0 0 0 2400 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 2642 77 786694 ##(Smalltalk.IndexedColor) 33554457 2690 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 2656 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 2400 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 2048 0 170 176 2048 0 0 0 0 0 2690 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 2608 0 0 0 0 1 0 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 2400 65025 3 0 0 0 0 0 0 0 0 8 'indicator2' 2994 5 2400 511 1 0 0 0 0 0 0 0 0 8 'indicator1' 2994 3 2400 33423361 5 0 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 2642 1027 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 2642 1029 3138 60239 3138 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 2642 1031 3138 335 3138 31317503 1 0 0 0 0 #Error 0 0 0 0 834 138 144 34 5 898 #createAt:extent: 34 2 514 1 201 514 729 413 2400 898 #modificationEventMask: 8 #(3912191) 2400 898 #caretPeriod: 8 #(530) 2400 898 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 2400 1 3 0 0 0 0 3490 3 2400 1 0 3 67108863 0 0 3490 5 2400 1 0 3 -67108863 0 0 2400 898 #tabWidth: 8 #(4) 2400 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 0 0 0 108 1 0 0 50 1 0 0] 8 #() 1088 0 29 1106 1984 1 1600 1 1138 #fixedPreviousBottom 1 1200 1 410 ##(Smalltalk.ContainerView) 34 15 0 2288 34 2 8 1140850688 131073 3664 0 0 0 7 0 0 0 3664 642 170 176 34 12 410 ##(Smalltalk.CheckBox) 34 16 0 3664 34 2 8 1409363203 1 3776 2466 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) false 0 0 7 0 0 0 3776 0 8 4294903891 2578 0 0 0 834 138 144 34 2 898 #createAt:extent: 34 2 514 17 91 514 227 43 3776 898 #text: 34 1 8 'Profiling On' 3776 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 45 0 0 0 121 0 0 0 66 0 0 0] 8 #() 1088 0 27 1106 1138 #fixedPreviousLeft 1 1168 227 3648 33 2016 43 410 ##(Smalltalk.TextEdit) 34 16 0 3664 34 2 8 1140924416 1025 4160 0 466 8 4278190080 0 7 0 0 0 4160 0 8 4294903825 852742 ##(Smalltalk.IntegerToText) 0 8 '' 0 1 834 138 144 34 1 898 #createAt:extent: 34 2 514 483 93 514 231 39 4160 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 46 0 0 0 100 1 0 0 65 0 0 0] 8 #() 1088 0 27 1106 4144 1 1168 231 3648 37 2016 39 410 ##(Smalltalk.StaticText) 34 16 0 3664 34 2 8 1140850945 1 4496 0 0 0 7 0 0 0 4496 0 8 4294903859 2578 0 0 0 834 138 144 34 2 898 #createAt:extent: 34 2 514 243 95 514 241 39 4496 898 #text: 34 1 8 'Interval (mS)' 4496 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 47 0 0 0 241 0 0 0 66 0 0 0] 8 #() 1088 0 27 1106 4144 1 1168 241 3648 41 2016 39 410 ##(Smalltalk.ComboBox) 34 17 0 3664 34 2 8 1144063490 1025 4816 590662 2 ##(Smalltalk.ListModel) 138 144 2048 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 0 7 0 0 0 4816 0 8 4294903831 459270 ##(Smalltalk.Message) #displayString 8 #() 2048 401 834 138 144 34 1 898 #createAt:extent: 34 2 514 483 9 514 251 53 4816 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 4 0 0 0 110 1 0 0 30 0 0 0] 8 #() 1088 0 27 1106 1152 1 1168 251 2000 9 2016 49 410 ##(Smalltalk.StaticText) 34 16 0 3664 34 2 8 1140850945 1 5232 0 0 0 7 0 0 0 5232 0 8 4294903859 2578 0 0 0 834 138 144 34 2 898 #createAt:extent: 34 2 514 243 17 514 241 39 5232 898 #text: 34 1 8 'Sampling Set' 5232 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 8 0 0 0 241 0 0 0 27 0 0 0] 8 #() 1088 0 27 1106 1152 1 1168 241 2000 17 2016 39 410 ##(Smalltalk.CheckBox) 34 16 0 3664 34 2 8 1409363203 1 5552 2466 0 0 3872 false 0 0 7 0 0 0 5552 0 8 4294903891 2578 0 0 0 834 138 144 34 2 898 #createAt:extent: 34 2 514 17 17 514 227 43 5552 898 #text: 34 1 8 'Collect' 5552 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 121 0 0 0 29 0 0 0] 8 #() 1088 0 27 1106 1984 17 1168 227 2000 17 2016 43 170 192 34 8 4160 8 'interval' 3776 8 'profilingOn' 4816 8 'set' 5552 8 'collect' 0 834 138 144 34 1 898 #createAt:extent: 34 2 514 1 1 514 729 201 3664 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 108 1 0 0 100 0 0 0] 34 6 5552 3776 5232 4496 4816 4160 1088 0 27 1106 1984 1 1600 1 2000 1 2016 201 170 192 34 2 2400 8 'source' 0 834 138 144 34 1 898 #createAt:extent: 34 2 514 21 21 514 729 613 2288 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 118 1 0 0 60 1 0 0] 34 2 3664 2400 1088 0 27 170 192 2048 2066 514 21 21 514 21 21 0 0 0 0 19799 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore) 0 0 1 0 8 1997218624 834 138 144 34 2 898 #createAt:extent: 34 2 514 3839 21 514 801 801 416 898 #updateMenuBar 2048 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 15 9 0 0 154 1 0 0] 34 2 2288 576 1088 0 27 )!

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

