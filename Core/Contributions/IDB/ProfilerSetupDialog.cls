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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 801 801 679 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 672 34 2 8 1141055488 1 800 nil nil nil 7 nil nil nil 800 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 'OK' 1 1 nil nil true nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 409 25 514 151 47 800 994 #isEnabled: 8 #(false) 800 994 #text: 34 1 8 'OK' 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 12 0 0 0 23 1 0 0 35 0 0 0] 8 #() 514 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -149 1266 #fixedParentRight -169 1266 #fixedViewBottom -45 1266 #fixedParentBottom 1 410 ##(Smalltalk.PushButton) 34 20 nil 672 34 2 8 1140924416 1 1344 nil nil nil 7 nil nil nil 1344 nil 8 1906824432 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 514 579 25 514 151 47 1344 994 #text: 34 1 8 'Cancel' 1344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 12 0 0 0 108 1 0 0 35 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedPreviousRight 21 1266 #fixedViewLeft 151 1312 -45 1328 1 410 ##(Smalltalk.PushButton) 34 20 nil 672 34 2 8 1140924416 1 1712 nil nil nil 7 nil nil nil 1712 nil 8 1906824432 882 #reset 8 'Reset' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 514 21 23 514 141 51 1712 994 #isEnabled: 8 #(false) 1712 994 #text: 34 1 8 'Reset' 1712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 80 0 0 0 36 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedParentLeft 11 1696 141 1266 #fixedParentTop 13 1266 #fixedViewTop 51 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 514 11 11 514 1 1 930 138 144 34 1 994 #createAt:extent: 34 2 514 21 633 514 729 71 672 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 118 1 0 0 95 1 0 0] 34 3 800 1344 1712 1216 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2384 nil nil nil 7 nil nil nil 2384 738 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 nil 2384 34 2 8 1176571972 1025 2496 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 8 4278190080 nil 7 nil nil nil 2496 nil 8 1462095465 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2738 77 786694 ##(Smalltalk.IndexedColor) 33554457 2786 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 2752 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 2496 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2144 nil 170 176 2144 nil nil nil nil nil 2786 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 2704 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 2496 33423361 5 nil nil nil nil nil nil nil nil 8 'indicator0' 3090 1 2496 65025 3 nil nil nil nil nil nil nil nil 8 'indicator2' 3090 5 2496 511 1 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2738 1029 196934 1 ##(Smalltalk.RGB) 60239 3234 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2738 1031 3234 335 3234 31317503 1 nil nil nil nil #Error nil nil nil #Notification 2738 1027 nil 3234 31185883 1 nil nil nil nil #Notification nil nil nil nil 930 138 144 34 7 994 #createAt:extent: 34 2 514 1 201 514 729 413 2496 994 #textLimit: 8 #(1073741823) 2496 994 #modificationEventMask: 8 #(3912191) 2496 994 #caretPeriod: 8 #(530) 2496 994 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 2496 1 3 nil nil nil nil 3618 3 2496 1 nil 3 67108863 nil nil 3618 5 2496 1 nil 3 -67108863 nil nil 2496 994 #tabWidth: 8 #(4) 2496 994 #maxCompletionListHeight: 8 #(9) 2496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 0 0 0 108 1 0 0 50 1 0 0] 8 #() 1216 nil 29 1234 2080 1 1296 1 1266 #fixedPreviousBottom 1 1328 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2384 34 2 8 1140850688 131073 3824 nil nil nil 7 nil nil nil 3824 738 170 176 34 12 410 ##(Smalltalk.TextEdit) 34 16 nil 3824 34 2 8 1140924416 1025 3936 nil 466 8 4278190080 nil 7 nil nil nil 3936 nil 8 1906818384 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 514 483 93 514 231 39 3936 994 #setMarginWidths: 34 1 8 #(3 3) 3936 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 46 0 0 0 100 1 0 0 65 0 0 0] 8 #() 1216 nil 27 1234 1266 #fixedPreviousLeft 1 1696 231 3808 37 2112 39 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850945 1 4336 nil nil nil 7 nil nil nil 4336 nil 8 1906774720 2674 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 514 243 95 514 241 39 4336 994 #text: 34 1 8 'Interval (mS)' 4336 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 47 0 0 0 241 0 0 0 66 0 0 0] 8 #() 1216 nil 27 1234 4320 1 1696 241 3808 41 2112 39 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850945 1 4656 nil nil nil 7 nil nil nil 4656 nil 8 1906774720 2674 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 514 243 17 514 241 39 4656 994 #text: 34 1 8 'Sampling Set' 4656 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 121 0 0 0 8 0 0 0 241 0 0 0 27 0 0 0] 8 #() 1216 nil 27 1234 1680 1 1696 241 2096 17 2112 39 410 ##(Smalltalk.CheckBox) 34 16 nil 3824 34 2 8 1409363203 1 4976 2562 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 4976 nil 8 1906824432 2674 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 514 17 17 514 227 43 4976 994 #text: 34 1 8 'Collect' 4976 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 121 0 0 0 29 0 0 0] 8 #() 1216 nil 27 1234 2080 17 1696 227 2096 17 2112 43 410 ##(Smalltalk.CheckBox) 34 16 nil 3824 34 2 8 1409363203 1 5344 2562 nil nil 5072 false nil nil 7 nil nil nil 5344 nil 8 1906824432 2674 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 514 17 91 514 227 43 5344 994 #text: 34 1 8 'Profiling On' 5344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 45 0 0 0 121 0 0 0 66 0 0 0] 8 #() 1216 nil 27 1234 4320 1 1696 227 3808 33 2112 43 410 ##(Smalltalk.ComboBox) 34 17 nil 3824 34 2 8 1144063490 1025 5680 590662 2 ##(Smalltalk.ListModel) 138 144 2144 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 nil 7 nil nil nil 5680 nil 8 1906654144 459270 ##(Smalltalk.Message) #displayString 8 #() 2144 401 930 138 144 34 1 994 #createAt:extent: 34 2 514 483 9 514 251 47 5680 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 241 0 0 0 4 0 0 0 110 1 0 0 27 0 0 0] 8 #() 1216 nil 27 1234 1680 1 1696 251 2096 9 2112 49 170 192 34 8 3936 8 'interval' 5344 8 'profilingOn' 5680 8 'set' 4976 8 'collect' nil 930 138 144 34 1 994 #createAt:extent: 34 2 514 1 1 514 729 201 3824 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 108 1 0 0 100 0 0 0] 34 6 4976 5344 4656 4336 5680 3936 1216 nil 27 1234 2080 1 1296 1 2096 1 2112 201 170 192 34 2 2496 8 'source' nil 930 138 144 34 1 994 #createAt:extent: 34 2 514 21 21 514 729 613 2384 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 118 1 0 0 60 1 0 0] 34 2 3824 2496 1216 nil 27 170 192 2144 2162 514 21 21 514 21 21 nil nil nil nil 26607 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 930 138 144 34 2 994 #createAt:extent: 34 2 514 3839 21 514 801 801 416 994 #updateMenuBar 2144 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 15 9 0 0 154 1 0 0] 34 2 2384 672 1216 nil 27 )!

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

