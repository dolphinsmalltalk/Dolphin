"Filed out from Dolphin Smalltalk"!

Object subclass: #ProfilerListItem
	instanceVariableNames: 'object tallyAll tallyActive timeAll timeActive'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerListItem guid: (GUID fromString: '{425d0eaf-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerListItem comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerListItem categoriesForClass!IDB Goodies! !
!ProfilerListItem methodsFor!

convertTally: tallyInteger time: timeInteger 
	"Now we know the final totals for each of the fields we can convert then to a percentage"

	tallyAll := tallyAll asPercentageOf: tallyInteger.
	tallyActive := tallyActive asPercentageOf: tallyInteger.
	timeAll := timeAll asPercentageOf: timeInteger.
	timeActive := timeActive asPercentageOf: timeInteger!

incrementTallyActive
	"Add one to the tallyActive count"

	tallyActive := tallyActive + 1!

incrementTallyAll
	"Add one to the tallyAll count"

	tallyAll := tallyAll + 1!

incrementTimeActiveBy: anInteger 
	"Add anInteger to the timeActive count"

	timeActive := timeActive + anInteger!

incrementTimeAllBy: anInteger 
	"Add anInteger to the timeAll count"

	timeAll := timeAll + anInteger!

isAbove: aFloat 
	"Answers true if any of the fields isAbove aFloat (a percentage)"

	^tallyAll > aFloat or: [tallyActive > aFloat or: [timeAll > aFloat or: [timeActive > aFloat]]]!

object
	"Answer the value of the receiver's instance variable object.
	This method was automatically generated, but may be modified."

	^object!

object: anObject 
	"Set the value of the receiver's instance variable object to anObject.
	This method was automatically generated, but may be modified."

	object := anObject!

profilerIconIndex
	"Answer the icon index for the list items object"

	^object profilerIconIndex!

reportOn: aStream 
	"Add the four fields to aStream which will be used for the report"

	aStream
		nextPutAll: ('%6s' sprintfWith: tallyAll printString);
		nextPutAll: '    ';
		nextPutAll: ('%6s' sprintfWith: tallyActive printString);
		nextPutAll: '    ';
		nextPutAll: ('%6s' sprintfWith: timeAll printString);
		nextPutAll: '    ';
		nextPutAll: ('%6s' sprintfWith: timeActive printString);
		nextPutAll: '    ';
		cr!

setObject: anObject 
	"Initialize the new instance of the receiver"

	object := anObject.
	tallyAll := 0.
	tallyActive := 0.
	timeAll := 0.
	timeActive := 0.
	^self!

tallyActive
	"Answer the value of the receiver's instance variable tallyActive.
	This method was automatically generated, but may be modified."

	^tallyActive!

tallyAll
	"Answer the value of the receiver's instance variable tallyAll.
	This method was automatically generated, but may be modified."

	^tallyAll!

timeActive
	"Answer the value of the receiver's instance variable timeActive.
	This method was automatically generated, but may be modified."

	^timeActive!

timeAll
	"Answer the value of the receiver's instance variable timeAll.
	This method was automatically generated, but may be modified."

	^timeAll! !
!ProfilerListItem categoriesForMethods!
convertTally:time:!converting!public! !
incrementTallyActive!operations!public! !
incrementTallyAll!operations!public! !
incrementTimeActiveBy:!operations!public! !
incrementTimeAllBy:!operations!public! !
isAbove:!public!testing! !
object!accessing!public! !
object:!accessing!public! !
profilerIconIndex!accessing!public! !
reportOn:!public!reporting! !
setObject:!initializing!public! !
tallyActive!accessing!public! !
tallyAll!accessing!public! !
timeActive!accessing!public! !
timeAll!accessing!public! !
!

!ProfilerListItem class methodsFor!

for: anObject 
	"Answer a new instance of the receiver for anObject"

	^super new setObject: anObject!

icon
	"Answers an Icon that can be used to represent this class"

	^Profiler icon! !
!ProfilerListItem class categoriesForMethods!
for:!instance creation!public! !
icon!constants!public! !
!

