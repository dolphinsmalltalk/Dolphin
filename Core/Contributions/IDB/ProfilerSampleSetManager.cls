"Filed out from Dolphin Smalltalk"!

Object subclass: #ProfilerSampleSetManager
	instanceVariableNames: 'sampleSets'
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSampleSetManager guid: (GUID fromString: '{425d0eb2-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerSampleSetManager comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSampleSetManager categoriesForClass!IDB Goodies! !
!ProfilerSampleSetManager methodsFor!

addSampleSetNamed: aString 
	"Add a new sample set named aString. Remove, without warning, any existing sample set
	with the same name.
	Answer the new sample set"

	| sampleSet |
	(sampleSet := self sampleSetNamed: aString) notNil ifTrue: [sampleSets remove: sampleSet].
	sampleSet := ProfilerSampleSet name: aString.
	sampleSet 
		when: #sampleSetUpdated:
		send: #onSampleSetUpdated:
		to: self.
	^sampleSets add: sampleSet!

initialize
	"Initialize the receiver"

	super initialize.
	sampleSets := ListModel on: OrderedCollection new.
	^self!

onSampleSetUpdated: aProfilerSampleSet 
	"aProfilerSampleSet has been updated, some new samples have been added, so
	tell the ListModel to refresh it. This will also be passed on to the ProfilerBrowser"

	sampleSets refreshAtIndex: (sampleSets indexOf: aProfilerSampleSet)!

removeAll
	"Remove all the sample sets"

	self sampleSetNames do: [:each | self removeSampleSetNamed: each]!

removeSampleSetNamed: aString 
	"Remove the sample set named aString. Raise an exception if it does not exist.(trys to remove nil)
	Answer the removed sample set"

	^sampleSets remove: (self sampleSetNamed: aString)!

sampleSetNamed: aString 
	"Answer the sample set named aString. Answer nil if no such sample set exists"

	^sampleSets list detect: [:each | each name = aString] ifNone: []!

sampleSetNames
	"Answer a collection containg the names of all the current sample sets"

	^sampleSets list collect: [:each | each name]!

sampleSets
	"Answer the value of the receiver's instance variable sampleSets.
	This method was automatically generated, but may be modified."

	^sampleSets! !
!ProfilerSampleSetManager categoriesForMethods!
addSampleSetNamed:!operations!public! !
initialize!initializing!public! !
onSampleSetUpdated:!event handling!public! !
removeAll!operations!public! !
removeSampleSetNamed:!operations!public! !
sampleSetNamed:!operations!public! !
sampleSetNames!accessing!public! !
sampleSets!accessing!public! !
!

!ProfilerSampleSetManager class methodsFor!

default
	"Answer the singleton instance"

	Default isNil ifTrue: [Default := super new initialize].
	^Default!

defaultSetName
	"Answer a String giving the name of the default sample set"

	^'Default'!

icon
	"Answers an Icon that can be used to represent this class"

	^Profiler icon!

new
	"Private - Use default to get the Singleton instance"

	^self shouldNotImplement!

reset
	"Clear the singleton instance of this class"

	Default := nil! !
!ProfilerSampleSetManager class categoriesForMethods!
default!instance creation!public! !
defaultSetName!constants!public! !
icon!constants!public! !
new!instance creation!protocols-instantiator!protocols-Object class!public! !
reset!operations!public! !
!

