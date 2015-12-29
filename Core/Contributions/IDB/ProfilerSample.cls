"Filed out from Dolphin Smalltalk X6"!

Object subclass: #ProfilerSample
	instanceVariableNames: 'root leaf elapsedTime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSample guid: (GUID fromString: '{425D0EB0-542E-11D3-998B-D5CA2C3C1D61}')!
ProfilerSample comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSample categoriesForClass!IDB Goodies! !
!ProfilerSample methodsFor!

classInformation
	"Answer an Association with the key being a Set containing all the classes
	representerd in this sample and the value the class of the leaf (active) node.
	This information (key) is cached in the tree"

	^leaf allClasses -> leaf object methodClass!

elapsedTime
	"Answer the value of the receiver's instance variable elapsedTime.
	This method was automatically generated, but may be modified."

	^elapsedTime!

frames
	"Answers a collection of all the ProfilerFrames associated with this sample. This is obtained
	by walking the tree, starting from leaf back up to root, collecting the object at each node"

	^leaf allParentFrames!

isChildOfFrameFor: aCompiledCode 
	"Answer true if any of the frames above this one in the tree have the same class 
	and method as aCompiledCode"

	^leaf isChildOfFrameFor: aCompiledCode!

selectorInformation
	"Answer an Association with the key being a Set containing all the methods (in the
	form of an Association giving the method class and selector) representerd in this 
	sample and the value the method (description) of the leaf (active) node.
	This  information (key) is cached in the tree"

	^leaf allSelectors -> leaf object selectorDescription!

setRoot: rootNode leaf: leafNode elapsedTime: anInteger 
	"Initialze the receiver"

	super initialize.
	root := rootNode.
	leaf := leafNode.
	elapsedTime := anInteger.
	^self! !
!ProfilerSample categoriesFor: #classInformation!accessing!public! !
!ProfilerSample categoriesFor: #elapsedTime!accessing!public! !
!ProfilerSample categoriesFor: #frames!accessing!public! !
!ProfilerSample categoriesFor: #isChildOfFrameFor:!public!testing! !
!ProfilerSample categoriesFor: #selectorInformation!accessing!public! !
!ProfilerSample categoriesFor: #setRoot:leaf:elapsedTime:!initializing!public! !

!ProfilerSample class methodsFor!

root: rootNode leaf: leafNode elapsedTime: anInteger 
	"Answer a new, initialized, instance of the receiver"

	^super new 
		setRoot: rootNode
		leaf: leafNode
		elapsedTime: anInteger! !
!ProfilerSample class categoriesFor: #root:leaf:elapsedTime:!instance creation!public! !

