"Filed out from Dolphin Smalltalk"!

Presenter subclass: #ProfilerPresenter
	instanceVariableNames: 'percentageFilter dolphinFilter selectorFilter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerPresenter guid: (GUID fromString: '{425d0eb3-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerPresenter categoriesForClass!IDB Goodies! !

!ProfilerPresenter methodsFor!

filter: anObject 
	"Answer true if all the filters agree that anObject should be displayed"

	^(percentageFilter value: anObject) 
		and: [(dolphinFilter value: anObject) and: [selectorFilter value: anObject]]!

filterChanged
	"One of the filters has changed so update the models"

	self update!

filterDolphin: aBoolean 
	"Answers true if the item is not in the Dolphin package (so it should be displayed)"

	self subclassResponsibility!

filterPercentage: aFloat 
	"Set the filterBlock to answer true if any of the fileds ar > aFloat%"

	self subclassResponsibility!

filterSelector: aCompiledCodeOrNil 
	"Answer true if this node shold be displayed for the selector filter"

	self subclassResponsibility!

initialize
	"Initialize the receiver"

	super initialize.
	percentageFilter := [:o | true].
	dolphinFilter := [:o | true].
	selectorFilter := [:o | true].
	^self!

model: aProfilerSampleSet 
	"Set the model for the receiver"

	super model: aProfilerSampleSet.
	self filterChanged!

parseContext
	^self selectedMethod
		ifNotNil: [:method | method parseContext]
		ifNil: [self systemModel defaultParseContext]!

selectedMethod
	^nil!

selectionOrNil
	^self subclassResponsibility! !

!ProfilerPresenter categoriesForMethods!
filter:!filtering!public! !
filterChanged!filtering!public! !
filterDolphin:!filtering!public! !
filterPercentage:!filtering!public! !
filterSelector:!filtering!public! !
initialize!initializing!public! !
model:!accessing!public! !
parseContext!public! !
selectedMethod!public!selection! !
selectionOrNil!accessing!public! !
!

!ProfilerPresenter class methodsFor!

defaultModel
	"Answer a default model to be used when the presenter is initialized"

	^ProfilerSampleSet name: 'None'! !

!ProfilerPresenter class categoriesForMethods!
defaultModel!models!public! !
!

