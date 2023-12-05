"Filed out from Dolphin Smalltalk"!

Object subclass: #ProfilerFrame
	instanceVariableNames: 'compiledCode receiverClass ip isBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerFrame guid: (GUID fromString: '{425d0eae-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerFrame comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerFrame categoriesForClass!IDB Goodies! !
!ProfilerFrame methodsFor!

browse
	self compiledCode browse!

browseableObject
	^self compiledCode!

coloredSource
	"Answer a RichText containing the colored source for the receiver's compiledCode"

	^compiledCode getSource!

compiledCode
	^compiledCode!

disassemblySelectionLine
	"Answer the selectionLine for the ip in the receiver's *disassembled* source"

	^compiledCode byteCodeDispatcherClass indexOfIP: (compiledCode byteCodeDispatcher prevIP: ip)
		in: compiledCode!

disassemblySource
	"Answer the disassembled source code for the receiver. We need more information than 
	the straight disassembly, such as statement numbers and source code"

	| inStream outStream textMap text |
	textMap := compiledCode textMap.
	inStream := compiledCode disassembly readStream.
	outStream := String writeStream.
	[inStream atEnd] whileFalse: 
			[| line thisIP |
			line := inStream nextLine trimBlanks.
			"D5 fix - ignore extra data in disassembly"
			(thisIP := Integer readFrom: line readStream) = 0 
				ifFalse: 
					[| index |
					index := 1.
					[index <= textMap size and: [(textMap at: index) key < thisIP]] whileTrue: [index := index + 1].
					outStream
						nextPut: $(;
						print: index;
						nextPut: $);
						space;
						nextPutAll: line;
						cr]].
	outStream cr.
	text := compiledCode getSource.
	textMap keysAndValuesDo: 
			[:index :each | 
			outStream
				nextPut: $(;
				print: index;
				nextPut: $);
				space;
				nextPutAll: (text copyFrom: each value start to: each value stop);
				cr].
	^outStream contents!

doClassAndSelectorMatch: aCompiledMethod 
	"Answers true if the class and selector of the receiver match aCompiledMethod.
	Done this way as it it a lot quicker than comparing compiledMethods"

	^self isCompiledExpression not 
		and: [aCompiledMethod methodClass == compiledCode methodClass and: [aCompiledMethod selector == compiledCode selector]]!

icon
	"Answer the icon for the frame's object"

	^receiverClass instanceClass icon!

ip
	"Answer the value of the receiver's instance variable ip.
	This method was automatically generated, but may be modified."

	^ip!

isCompiledExpression
	"Answers true if the compiledCode for this frame is part of a CompiledExpression"

	^compiledCode isKindOf: CompiledExpression!

isInSystemPackage
	"Answers true if the compiledCode for the receiver is not part of the system (Dolphin) package.
	Check for instances of CompiledExpression first as we want those. Used by the
	Dolphin filter in the browser"

	^self isCompiledExpression not 
		and: [compiledCode owningPackage notNil and: [compiledCode owningPackage isSystemPackage]]!

isSameFrameAs: aStackFrame 
	"Answers true if the receiver represents the same evaluation point as anIProfilerSampleFrame.
	Note that we no longer match methods by some equivalency, rather by identity. This does mean
	that if samples are collected around method modifications, that the frames won't be matched
	in the way they use to be, but then the results of collected profiles with different code are not
	really valid anyway. The reason for the change is to try and reduce the sampling overhead
	as much as possible."

	^compiledCode == aStackFrame method and: [ip == aStackFrame ip]!

methodClass
	"Answer the value of the receiver's instance variable methodClass.
	This method was automatically generated, but may be modified."

	^compiledCode methodClass!

printOn: aStream 
	"Add a description of the receiver onto aStream"

	isBlock ifTrue: [aStream nextPutAll: '[] in '].
	aStream print: receiverClass.
	receiverClass == self methodClass 
		ifFalse: 
			[aStream
				space;
				nextPut: $(;
				print: self methodClass;
				nextPut: $)].
	aStream
		space;
		nextPutAll: self selector!

profilerIconIndex
	"Answer the icon index for the frame's object"

	^self icon imageIndex!

selectionRange
	"Answer the selectionRange for the ip in the receiver's source"

	| previousIP textMap index |
	previousIP := compiledCode byteCodeDispatcher prevIP: ip.
	textMap := compiledCode textMap.
	index := 1.
	[index <= textMap size and: [(textMap at: index) key < previousIP]] whileTrue: [index := index + 1].
	^(textMap at: index ifAbsent: [^0 to: 0]) value!

selector
	"Answer the value of the receiver's instance variable selector.
	This method was automatically generated, but may be modified."

	^compiledCode selector!

selectorDescription
	"Answer a description of the compiled code. We use this as the comparison operator
	for compiledCode is quite slow and it is quicker (when building Sets for example) to use
	this description and then collect the actual compiled code later"

	^self methodClass -> self selector!

setFrame: aStackFrame 
	"Initialize the receiver from aStackFrame"

	compiledCode := aStackFrame method.
	receiverClass := aStackFrame receiver class.
	ip := aStackFrame ip.
	isBlock := aStackFrame isBlockFrame.
	^self! !
!ProfilerFrame categoriesForMethods!
browse!commands-actions!public! !
browseableObject!accessing!public! !
coloredSource!displaying!public! !
compiledCode!accessing!public! !
disassemblySelectionLine!displaying!public! !
disassemblySource!displaying!public! !
doClassAndSelectorMatch:!public!testing! !
icon!accessing!public! !
ip!accessing!public! !
isCompiledExpression!public!testing! !
isInSystemPackage!public!testing! !
isSameFrameAs:!public!testing! !
methodClass!accessing!public! !
printOn:!ANSI protocols-Object!protocols-Object!public! !
profilerIconIndex!accessing!public! !
selectionRange!displaying!public! !
selector!accessing!public! !
selectorDescription!accessing!public! !
setFrame:!initializing!public! !
!

!ProfilerFrame class methodsFor!

frame: aStackFrame 
	"Answer an instance of the receiver initialized from aStackFrame, which may be a StackFrame
	instance or an instance of one of its subclasses"

	^super new setFrame: aStackFrame!

icon
	"Answers an Icon that can be used to represent this class"

	^Profiler icon!

new
	"Should only create a new instance using #frame:"

	^self shouldNotImplement! !
!ProfilerFrame class categoriesForMethods!
frame:!instance creation!public! !
icon!constants!public! !
new!instance creation!protocols-instantiator!protocols-Object class!public! !
!

