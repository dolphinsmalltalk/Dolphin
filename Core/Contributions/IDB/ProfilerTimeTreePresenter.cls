"Filed out from Dolphin Smalltalk 7"!

ProfilerTreesPresenter subclass: #ProfilerTimeTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProfilerTimeTreePresenter guid: (GUID fromString: '{425d0eba-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerTimeTreePresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerTimeTreePresenter categoriesForClass!IDB Goodies! !
!ProfilerTimeTreePresenter methodsFor!

total
	"Answer the total number of items for this type of tree"

	^self model samplesElapsedTime!

treeValueFor: aProfilerTreeNode 
	"Answers the value of the field for the receivers type of tree"

	^aProfilerTreeNode time! !
!ProfilerTimeTreePresenter categoriesFor: #total!accessing!public! !
!ProfilerTimeTreePresenter categoriesFor: #treeValueFor:!accessing!public! !

