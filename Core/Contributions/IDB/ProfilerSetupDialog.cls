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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(DialogView) 98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef) 8 4278190080 328198 ##(Point) 801 801 679 0 0 0 416 788230 ##(BorderLayout) 1 1 0 410 8 ##(ContainerView) 98 15 0 416 98 2 8 1140850688 131073 592 0 0 0 7 0 0 0 592 852230 ##(FramingLayout) 234 240 98 6 410 8 ##(PushButton) 98 17 0 592 98 2 8 1140924416 1 736 0 0 0 7 0 0 0 736 0 8 4294904534 1180998 4 ##(CommandDescription) 8 #reset 8 'Reset' 1 1 0 0 32 983302 ##(MessageSequence) 202 208 98 3 721670 ##(MessageSend) 8 #createAt:extent: 98 2 530 21 23 530 141 51 736 962 8 #isEnabled: 98 1 32 736 962 8 #text: 98 1 8 'Reset' 736 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 80 0 0 0 36 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(FramingConstraints) 1114638 ##(STBSingletonProxy) 8 ##(FramingCalculation) 8 #fixedParentLeft 11 1290 1312 8 #fixedViewLeft 141 1290 1312 8 #fixedParentTop 13 1290 1312 8 #fixedViewTop 51 410 752 98 17 0 592 98 2 8 1140924416 1 1440 0 0 0 7 0 0 0 1440 0 8 4294904534 834 8 #cancel 8 'Cancel' 1 1 0 0 32 898 202 208 98 2 962 992 98 2 530 599 25 530 151 47 1440 962 1120 98 1 8 'Cancel' 1440 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 43 1 0 0 12 0 0 0 118 1 0 0 35 0 0 0] 98 0 1232 0 27 1250 1290 1312 8 #fixedPreviousRight 21 1344 151 1290 1312 8 #fixedViewBottom -45 1290 1312 8 #fixedParentBottom 1 410 752 98 17 0 592 98 2 8 1141055488 1 1888 0 0 0 7 0 0 0 1888 0 8 4294904534 834 8 #ok 8 'OK' 1 1 0 0 16 898 202 208 98 3 962 992 98 2 530 429 25 530 151 47 1888 962 1072 98 1 32 1888 962 1120 98 1 8 'OK' 1888 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 214 0 0 0 12 0 0 0 33 1 0 0 35 0 0 0] 98 0 1232 0 27 1250 1290 1312 8 #fixedViewRight -149 1290 1312 8 #fixedParentRight -169 1824 -45 1856 1 234 256 98 0 590342 ##(Rectangle) 530 11 11 530 1 1 898 202 208 98 1 962 992 98 2 530 21 647 530 749 71 592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 67 1 0 0 128 1 0 0 102 1 0 0] 98 3 1888 1440 736 1232 0 27 0 0 410 608 98 15 0 416 98 2 8 1140850688 131073 2592 0 0 0 7 0 0 0 2592 674 234 240 98 4 410 8 ##(ScintillaView) 98 46 0 2592 98 2 8 1176571972 1025 2704 721990 2 ##(ValueHolder) 0 32 1290 8 ##(SearchPolicy) 8 #equality 0 482 8 4278190080 0 7 0 0 0 2704 0 34032407 852486 ##(NullConverter) 0 0 9 0 234 256 98 2 8 #normal 1182726 ##(ScintillaTextStyle) 1 0 0 1 0 0 0 0 2960 0 0 0 98 40 2992 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(NullScintillaStyler) 2960 234 256 98 2 8 #default 1639942 ##(ScintillaMarkerDefinition) 1 1 786694 ##(IndexedColor) 33554433 3138 33554471 2704 8 #circle 202 208 2352 0 63 0 0 0 0 0 3138 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 2928 0 0 0 0 1 0 0 898 202 208 98 8 962 992 98 2 530 1 201 530 749 427 2704 962 8 #selectionRange: 98 1 525062 ##(Interval) 3 1 3 2704 962 8 #isTextModified: 98 1 32 2704 962 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(ScintillaIndicatorStyle) 1 2704 65025 3 3602 3 2704 33423361 5 3602 5 2704 511 1 2704 962 8 #margins: 98 1 98 3 984582 ##(ScintillaMargin) 1 2704 1 3 32 1 3730 3 2704 1 1 16 67108863 3730 5 2704 1 1 16 -67108863 2704 962 8 #markers: 98 1 3200 2704 962 8 #tabIndents: 98 1 16 2704 962 8 #tabWidth: 98 1 9 2704 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 0 0 0 118 1 0 0 57 1 0 0] 98 0 1232 0 27 1250 1296 1 2304 1 1290 1312 8 #fixedPreviousBottom 1 1856 1 410 608 98 15 0 2592 98 2 8 1140850688 131073 4032 0 0 0 7 0 0 0 4032 674 234 240 98 12 410 8 ##(StaticText) 98 16 0 4032 98 2 8 1140850945 1 4144 0 0 0 7 0 0 0 4144 0 8 4294904578 2898 0 0 0 898 202 208 98 2 962 992 98 2 530 243 95 530 241 39 4144 962 1120 98 1 8 'Interval (mS)' 4144 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 47 0 0 0 241 0 0 0 66 0 0 0] 98 0 1232 0 27 1250 1290 1312 8 #fixedPreviousLeft 1 1344 241 4000 41 1408 39 410 8 ##(CheckBox) 98 16 0 4032 98 2 8 1409363203 1 4512 2786 0 0 1290 2832 8 #never 32 0 0 7 0 0 0 4512 0 8 4294904534 2898 0 0 0 898 202 208 98 2 962 992 98 2 530 17 91 530 227 43 4512 962 1120 98 1 8 'Profiling On' 4512 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 45 0 0 0 121 0 0 0 66 0 0 0] 98 0 1232 0 27 1250 4480 1 1344 227 4000 33 1408 43 410 4528 98 16 0 4032 98 2 8 1409363203 1 4896 2786 0 0 4608 32 0 0 7 0 0 0 4896 0 8 4294904534 2898 0 0 0 898 202 208 98 2 962 992 98 2 530 17 17 530 227 43 4896 962 1120 98 1 8 'Collect' 4896 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 121 0 0 0 29 0 0 0] 98 0 1232 0 27 1250 1296 17 1344 227 1376 17 1408 43 410 8 ##(ComboBox) 98 17 0 4032 98 2 8 1144063490 1025 5232 590662 2 ##(ListModel) 202 208 2352 0 1290 2832 8 #identity 482 8 4278190080 0 7 0 0 0 5232 0 8 4294904514 459270 ##(Message) 8 #displayString 98 0 2352 401 898 202 208 98 1 962 992 98 2 530 483 9 530 251 47 5232 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 4 0 0 0 110 1 0 0 27 0 0 0] 98 0 1232 0 27 1250 1792 1 1344 251 1376 9 1408 49 410 8 ##(TextEdit) 98 16 0 4032 98 2 8 1140924416 1025 5680 0 482 8 4278190080 0 7 0 0 0 5680 0 8 4294904904 852742 ##(IntegerToText) 0 8 '' 0 1 898 202 208 98 3 962 992 98 2 530 483 93 530 231 39 5680 962 3424 98 1 3458 3 1 3 5680 962 3504 98 1 32 5680 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 46 0 0 0 100 1 0 0 65 0 0 0] 98 0 1232 0 27 1250 4480 1 1344 231 4000 37 1408 39 410 4160 98 16 0 4032 98 2 8 1140850945 1 6112 0 0 0 7 0 0 0 6112 0 8 4294904578 2898 0 0 0 898 202 208 98 2 962 992 98 2 530 243 17 530 241 39 6112 962 1120 98 1 8 'Sampling Set' 6112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 8 0 0 0 241 0 0 0 27 0 0 0] 98 0 1232 0 27 1250 1792 1 1344 241 1376 17 1408 39 234 256 98 8 5232 8 'set' 4896 8 'collect' 5680 8 'interval' 4512 8 'profilingOn' 0 898 202 208 98 1 962 992 98 2 530 1 1 530 749 201 4032 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 100 0 0 0] 98 6 4896 4512 6112 4144 5232 5680 1232 0 27 1250 1296 1 2304 1 1376 1 1408 201 234 256 98 2 2704 8 'source' 0 898 202 208 98 1 962 992 98 2 530 21 21 530 749 627 2592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 128 1 0 0 67 1 0 0] 98 2 4032 2704 1232 0 27 234 256 2352 2370 530 21 21 530 21 21 0 0 0 0 8883 0 0 0 0 1 0 0 590598 ##(Semaphore) 0 0 1 0 8 2010572111 898 202 208 98 2 962 992 98 2 530 20001 20001 530 801 801 416 962 8 #menuBar: 98 1 0 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 160 40 0 0 160 40 0 0] 98 2 2592 592 1232 0 27)!

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

