"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ProfilerSampleSet
	instanceVariableNames: 'name root isActive samples samplingCount samplingTimeStamp samplesElapsedTime samplesClasses samplesSelectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProfilerSampleSet guid: (GUID fromString: '{425d0eb1-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerSampleSet comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSampleSet categoriesForClass!IDB Goodies! !
!ProfilerSampleSet methodsFor!

addItem: anAssociation to: aLookupTable elapsedTime: anInteger 
	"Add all the items in the Collection referenced by anAssociation's key to aLookupTable.
	If the item doesn't exist then add a new instance of ProfilerListItem to accomodate it.
	anAssociation's value is the identity of the active node in the sample.
	Increment the value for both the all and active counts"

	anAssociation key do: 
			[:eachItem | 
			| entry |
			entry := aLookupTable at: eachItem ifAbsentPut: [ProfilerListItem for: eachItem].
			entry
				incrementTallyAll;
				incrementTimeAllBy: anInteger].
	(aLookupTable at: anAssociation value)
		incrementTallyActive;
		incrementTimeActiveBy: anInteger!

addSample: aCollection elapsedTime: anInteger
	"Add the frames from aCollection to the tree starting at root. For each frame
	the node finds a child of the current node corresponding to the frame (creating one if 
	necessary), updates its values and answers the new node. We can also check here for 
	the ip of the active (top) frame being 1. If it is we need to remove it as it causes confusion 
	as the sample really represents the state at the end of the previous frame"

	| leaf |
	leaf := root.
	aCollection size to: (aCollection first ip = 1 ifTrue: [2] ifFalse: [1])
		by: -1
		do: [:i | leaf := leaf addFrame: (aCollection at: i) elapsedTime: anInteger].
	samples addLast: (ProfilerSample
				root: root
				leaf: leaf
				elapsedTime: anInteger)!

clearCaches
	"Clear the receiver of any cached values held in instVars or in the tree nodes. We must not
	clear the samples collection or the tree itself as we may be profiling in collect mode"

	root clearCache.
	samplesElapsedTime := nil.
	samplesClasses := nil.
	samplesSelectors := nil!

duration
	^self samplesElapsedTime microseconds!

initialize
	"Initialize a new instance of the receiver"

	super initialize.
	samples := OrderedCollection new: 256.
	samplingCount := 0.
	isActive := false.
	root := ProfilerTreeNode for: nil.
	^self!

isActive
	"Answer the value of the receiver's instance variable isActive.
	This method was automatically generated, but may be modified."

	^isActive!

isActive: anObject 
	"Set the value of the receiver's instance variable isActive to anObject.
	This method was automatically generated, but may be modified."

	isActive := anObject!

name
	"Answer the name of this sample set"

	^name!

profilerIconIndex
	"Answer the index of the icon to use for the sample set
		green (Presenter) if the data has been analysed.
		red (Model) if not"

	^samplesClasses isNil ifTrue: [Delay icon imageIndex] ifFalse: [-1]!

reportTo: aStream 
	"Put the preamble for the report into aStream"

	aStream
		nextPutAll: 'Profiler Report';
		cr;
		cr;
		nextPutAll: 'Set: ';
		nextPutAll: self name;
		cr;
		nextPutAll: 'Samples: ';
		print: self samplesSize;
		cr;
		nextPutAll: 'Elapsed Time: ';
		print: self duration;
		cr;
		nextPutAll: 'Samplings: ';
		print: self samplingCount;
		cr;
		nextPutAll: 'Last Sampling: ';
		print: self samplingTimeStamp;
		cr!

rootNodes
	"Answer a collection of nodes that will form the root nodes of the tree"

	^root children!

sampleAt: anInteger 
	"Answer the sample at index anInteger"

	^samples at: anInteger!

samplesClasses
	"Answer the classes used by this set. They are cached so check first"

	samplesClasses isNil ifTrue: [self scanSamples].
	^samplesClasses!

samplesElapsedTime
	"Answer (and cache) the total time taken by the samples held by this sample set"

	samplesElapsedTime isNil 
		ifTrue: [samplesElapsedTime := samples inject: 0 into: [:total :each | total + each elapsedTime]].
	^samplesElapsedTime!

samplesElapsedTimeString
	^self duration humanReadablePrintString!

samplesSelectors
	"Answer the methods used by this set. They are cached so check first"

	samplesSelectors isNil ifTrue: [self scanSamples].
	^samplesSelectors!

samplesSize
	"Answer the number of samples held by this sample set"

	^samples size!

samplingCount
	"Answer the value of the receiver's instance variable samplingCount.
	This method was automatically generated, but may be modified."

	^samplingCount!

samplingInterval
	"Answer the average sampling interval achieved."

	| count |
	count := self samplesSize.
	^(count == 0 ifTrue: [0] ifFalse: [self samplesElapsedTime // count]) microseconds!

samplingIntervalString
	^self samplingInterval humanReadablePrintString!

samplingTimeStamp
	"Answer the value of the receiver's instance variable samplingTimeStamp.
	This method was automatically generated, but may be modified."

	^samplingTimeStamp!

scanSamples
	"Scan all the samples for this sample set to collect lists of all the classes and methods
	represented by the receiver. Initially use a LookupTable, to enable rapid location
	of a previous occurrence of an item, but save OrderedCollections in the instVars
	as this format will be needed to display the lists. Convert the raw counts to percentages
	once we know the final totals. Trigger an event every so often to allow a progress indicator 
	to be maintained in the main shell"

	| classes selectors updateIndicatorAt |
	classes := LookupTable new.
	selectors := LookupTable new.
	updateIndicatorAt := (self samplesSize * 0.05) truncated max: 1.
	samples keysAndValuesDo: 
			[:index :eachSample | 
			index \\ updateIndicatorAt = 0 
				ifTrue: 
					[self 
						trigger: #updateIndicator:of:
						with: index
						with: self samplesSize].
			self 
				addItem: eachSample classInformation
				to: classes
				elapsedTime: eachSample elapsedTime.
			self 
				addItem: eachSample selectorInformation
				to: selectors
				elapsedTime: eachSample elapsedTime].
	samplesClasses := classes asArray.
	samplesClasses do: [:each | each convertTally: self samplesSize time: self samplesElapsedTime].
	samplesSelectors := selectors asArray.
	samplesSelectors do: [:each | each convertTally: self samplesSize time: self samplesElapsedTime]!

setName: aString 
	"Set the name of this sample set"

	name := aString.
	^self!

update
	"Update the count of the number of times a set of samples has been added
	to this sample set and also the time of the last sampling"

	samplingCount := samplingCount + 1.
	samplingTimeStamp := DateAndTime now.
	samplesElapsedTime := nil.
	self trigger: #sampleSetUpdated: with: self! !
!ProfilerSampleSet categoriesFor: #addItem:to:elapsedTime:!helpers!private! !
!ProfilerSampleSet categoriesFor: #addSample:elapsedTime:!profiling!public! !
!ProfilerSampleSet categoriesFor: #clearCaches!operations!public! !
!ProfilerSampleSet categoriesFor: #duration!accessing!public! !
!ProfilerSampleSet categoriesFor: #initialize!initializing!public! !
!ProfilerSampleSet categoriesFor: #isActive!accessing!public! !
!ProfilerSampleSet categoriesFor: #isActive:!accessing!public! !
!ProfilerSampleSet categoriesFor: #name!accessing!public! !
!ProfilerSampleSet categoriesFor: #profilerIconIndex!accessing!public! !
!ProfilerSampleSet categoriesFor: #reportTo:!public!reporting! !
!ProfilerSampleSet categoriesFor: #rootNodes!accessing!public! !
!ProfilerSampleSet categoriesFor: #sampleAt:!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplesClasses!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplesElapsedTime!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplesElapsedTimeString!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplesSelectors!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplesSize!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplingCount!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplingInterval!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplingIntervalString!accessing!public! !
!ProfilerSampleSet categoriesFor: #samplingTimeStamp!accessing!public! !
!ProfilerSampleSet categoriesFor: #scanSamples!operations!public! !
!ProfilerSampleSet categoriesFor: #setName:!initializing!public! !
!ProfilerSampleSet categoriesFor: #update!public!updating! !

!ProfilerSampleSet class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Profiler icon!

name: aString 
	"Answer a new initialized instance of the receiver named aString"

	^super new initialize setName: aString!

new
	"Should only create a new instance using #name:"

	^self shouldNotImplement! !
!ProfilerSampleSet class categoriesFor: #icon!constants!public! !
!ProfilerSampleSet class categoriesFor: #name:!instance creation!public! !
!ProfilerSampleSet class categoriesFor: #new!instance creation!protocols-instantiator!protocols-Object class!public! !

