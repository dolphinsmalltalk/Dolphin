"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #ContinuationTest
	instanceVariableNames: 'tmp tmp2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ContinuationTest guid: (GUID fromString: '{5f9fdcb7-fd2f-4ec2-a1dd-68f43f8a41a6}')!
ContinuationTest comment: ''!
!ContinuationTest categoriesForClass!Seaside-Continuations! !
!ContinuationTest methodsFor!

runCase
	"Bodge to prevent problem of the continuation processes running on and executing further tests"

	| sem |
	sem := Semaphore new.
	[[super runCase] ensure: [sem signal]] fork.
	sem wait!

testBlockTemps
	| y |
	#(1 2 3) do: 
			[:i |
			| x |
			x := i.
			tmp ifNil: [tmp2 := 
							[:cc |
							tmp := cc.
							[:q | ]] callCC].
			tmp2 value: x.
			x := 17].
	y := 
			[:cc |
			tmp value: cc.
			42] callCC.
	self assert: y equals: 1.
	tmp := tmp2 := nil!

testBlockVars
	| continuation |
	tmp := 0.
	tmp := 
			[:cc |
			continuation := cc.
			0] callCC + tmp.
	tmp2
		ifNotNil: [:x | tmp2 value]
		ifNil: [#(1 2 3) do: [:i | 
					[:cc |
					tmp2 := cc.
					continuation value: i] callCC]].
	self assert: tmp equals: 6.
	tmp := 0.
	tmp2 := nil!

testMethodTemps
	| i continuation |
	i := 0.
	i := i + 
					[:cc |
					continuation := cc.
					1] callCC.
	self deny: i equals: 3.
	i = 2 ifFalse: [continuation value: 2]!

testSimpleCallCC
	| x continuation |
	x := 
			[:cc | 
			continuation := cc.
			false] callCC.
	x ifFalse: [continuation value: true]!

testSimplestCallCC
	| x |
	x := [:cc | cc value: true] callCC.
	self assert: x!

testVMVersion
	self assert: VMLibrary default versionString asNumber > 5.01! !
!ContinuationTest categoriesFor: #runCase!public!Running! !
!ContinuationTest categoriesFor: #testBlockTemps!public!unit tests! !
!ContinuationTest categoriesFor: #testBlockVars!public!unit tests! !
!ContinuationTest categoriesFor: #testMethodTemps!public!unit tests! !
!ContinuationTest categoriesFor: #testSimpleCallCC!public!unit tests! !
!ContinuationTest categoriesFor: #testSimplestCallCC!public!unit tests! !
!ContinuationTest categoriesFor: #testVMVersion!public!unit tests! !

