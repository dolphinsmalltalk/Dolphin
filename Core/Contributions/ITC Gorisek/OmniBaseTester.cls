"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #OmniBaseTester
	instanceVariableNames: 'testDb testDir'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OmniBaseTester guid: (GUID fromString: '{2CFEC1EF-B746-4249-93C4-E54EF5D7A2D0}')!
OmniBaseTester comment: ''!
!OmniBaseTester categoriesForClass!Unclassified! !
!OmniBaseTester class methodsFor!

benchmarkCommitNewObjects
	| db trn dict time timeArray maxIndex maxTime stream |
	stream := WriteStream on: String new.
	db := OmniBase openOn: self testDir.
	timeArray := Array new: 6.
	maxTime := 0.
	1 to: timeArray size
		do: 
			[:count | 
			trn := db newTransaction.
			dict := OmniBase newPersistentDictionary.
			trn store: dict.
			1 to: 100
				do: 
					[:i | 
					dict at: i
						put: (Array 
								with: 'Test array'
								with: i
								with: i printString
								with: (Association key: 'Bla' value: 'Blala'))].
			time := Time millisecondsToRun: [trn commit].
			trn abort.
			stream
				nextPutAll: ' Commit time: ' , (time / 1000) asFloat printString , ' sec';
				cr.
			timeArray at: count put: time.
			time > maxTime 
				ifTrue: 
					[maxTime := time.
					maxIndex := count]].
	time := 0.
	1 to: timeArray size do: [:i | i = maxIndex ifFalse: [time := time + (timeArray at: i)]].
	time := time / (timeArray size - 1).
	stream
		nextPutAll: '------------------------';
		cr.
	stream
		nextPutAll: 'Average time: ' , (time / 1000) asFloat printString , ' sec';
		cr.
	db close.
	Transcript show: stream contents!

test1
	| db |
	[db := OmniBase createOn: self testDir] ensure: [db isNil ifFalse: [db close]]!

test10
	"Test basic B-Tree dictionary functionality."

	| db t dict |
	db := OmniBase openOn: self testDir.
	
	[t := db newTransaction.
	dict := db newBTreeDictionary: 20.
	dict
		at: 1 put: self testCollection;
		at: 2 put: 'Dva';
		at: 3 put: nil;
		at: Date today put: 'danes';
		at: 'Test' put: 'test';
		at: 'temp' put: 'temp';
		removeKey: 'temp'.
	(dict at: 2) = 'Dva' ifFalse: [self halt].
	(dict at: 3) = nil ifFalse: [self halt].
	(dict at: Date today) = 'danes' ifFalse: [self halt].
	(dict at: 'Test') = 'test' ifFalse: [self halt].
	(dict includesKey: 'Test') ifFalse: [self halt].
	(dict includesKey: 'none') ifTrue: [self halt].
	(dict includesKey: 3) ifFalse: [self halt].
	(dict includesKey: 'temp') ifTrue: [self halt].
	dict size = 5 ifFalse: [self halt].
	t makePersistent: dict.
	(dict at: 2) = 'Dva' ifFalse: [self halt].
	(dict at: 3) = nil ifFalse: [self halt].
	(dict at: Date today) = 'danes' ifFalse: [self halt].
	(dict at: 'Test') = 'test' ifFalse: [self halt].
	(dict includesKey: 'Test') ifFalse: [self halt].
	(dict includesKey: 'none') ifTrue: [self halt].
	(dict includesKey: 3) ifFalse: [self halt].
	dict size = 5 ifFalse: [self halt].
	t checkpoint.
	(dict at: 2) = 'Dva' ifFalse: [self halt].
	(dict at: 3) = nil ifFalse: [self halt].
	(dict at: Date today) = 'danes' ifFalse: [self halt].
	(dict at: 'Test') = 'test' ifFalse: [self halt].
	(dict includesKey: 'Test') ifFalse: [self halt].
	(dict includesKey: 'none') ifTrue: [self halt].
	(dict includesKey: 3) ifFalse: [self halt].
	dict size = 5 ifFalse: [self halt].
	t root at: 'b-tree' put: dict.
	t commit.
	t := db newTransaction.
	dict := t root at: 'b-tree'.
	(dict at: 2) = 'Dva' ifFalse: [self halt].
	(dict at: 3) = nil ifFalse: [self halt].
	(dict at: Date today) = 'danes' ifFalse: [self halt].
	(dict at: 'Test') = 'test' ifFalse: [self halt].
	(dict includesKey: 'Test') ifFalse: [self halt].
	(dict includesKey: 'none') ifTrue: [self halt].
	(dict includesKey: 3) ifFalse: [self halt].
	dict size = 5 ifFalse: [self halt].
	dict removeKey: 2.
	(dict includesKey: 2) ifTrue: [self halt].
	dict size = 4 ifFalse: [self halt].
	(dict at: 2) isNil ifFalse: [self halt].
	t checkpoint.
	dict at: 2 put: 'blabla'.
	dict size = 5 ifFalse: [self halt].
	t commit.
	t := db newTransaction.
	dict := t root at: 'b-tree'.
	(dict at: 2) = 'blabla' ifFalse: [self halt]] 
			ensure: [db isNil ifFalse: [db close]]!

test10a
	"Test B-Tree identity dictionary functionality."

	| db t dict1 dict2 obj1 obj2 obj3 |
	db := OmniBase openOn: self testDir.
	
	[t := db newTransaction.
	dict1 := db newBTreeIdentityDictionary.
	dict2 := db newBTreeIdentityDictionary.
	obj1 := Array with: 'Array with String as obj1'.
	obj2 := Array with: obj1 with: 'Array with String and obj1 as obj2'.
	obj3 := Array with: Date today.
	t root at: 'obj2' put: obj2.
	dict1 at: obj1 put: obj2.
	(dict1 at: obj1) == obj2 ifFalse: [self halt].
	dict2 at: obj1 put: t root.
	dict2 at: t root put: obj1.
	dict1 at: t root put: obj1.
	dict2 at: t root put: dict1.
	dict2 at: dict2 put: obj1.
	(dict2 at: obj1) == t root ifFalse: [self halt].
	dict1 size = 2 ifFalse: [self halt].
	dict2 size = 3 ifFalse: [self halt].
	dict1 at: obj3 put: Date today.
	t makePersistent: dict2.
	dict2 at: obj3 put: Date today.
	dict1 removeKey: obj3.
	dict2 removeKey: obj3.
	t makePersistent: dict1.
	dict1 size = 2 ifFalse: [self halt].
	dict2 size = 3 ifFalse: [self halt].
	t checkpoint.
	(dict1 at: obj1) == obj2 ifFalse: [self halt].
	t root at: 'identity-dict1' put: dict1.
	dict1 at: t root put: dict2.
	t commit.
	t := db newTransaction.
	dict1 := t root at: 'identity-dict1'.
	dict2 := dict1 at: t root.
	obj1 := dict2 at: dict2.
	obj2 := dict1 at: obj1.
	((dict2 at: obj1) isIdenticalTo: t root) ifFalse: [self halt].
	((dict2 at: t root) isIdenticalTo: dict1) ifFalse: [self halt].
	t checkpoint.
	t commit.
	t := db newTransaction] 
			ensure: [db isNil ifFalse: [db close]]!

test11
	"Test b-tree iterator by inserting large number of associations into b-tree dictionary."

	| db dict |
	db := OmniBase openOn: self testDir.
	
	[
	[dict := OmniBase newBTreeDictionary: 5.
	OmniBase root at: 'big-dict' put: dict.
	0 to: 300
		by: 2
		do: [:i | dict at: i put: i printString].
	299 to: 1
		by: -2
		do: [:i | dict at: i put: i printString]] 
			evaluateAndCommitIn: db newTransaction.
	
	[dict := OmniBase root at: 'big-dict'.
	299 to: 1
		by: -2
		do: [:i | (dict at: i) = i printString ifFalse: [self halt]].
	0 to: 300
		by: 2
		do: [:i | (dict at: i) = i printString ifFalse: [self halt]]] 
			evaluateIn: db newTransaction] 
			ensure: [db isNil ifFalse: [db close]]!

test12
	"Test local B-Tree key locking"

	| db1 db2 t1 t2 dict dict2 |
	db1 := OmniBase openOn: self testDir.
	db2 := OmniBase openOn: self testDir.
	
	[t1 := db1 newTransaction.
	dict := db1 newBTreeDictionary: 5.
	t1 root at: 'concurrent-btree' put: dict.
	t1 checkpoint.
	t2 := db2 newTransaction.

	"inserting keys in one transaction"
	1 to: 100 do: [:i | dict at: i put: 'test'].
	t1 checkpoint.
	dict2 := t2 root at: 'concurrent-btree'.
	"inserting keys in another transaction"
	101 to: 200 do: [:i | dict2 at: i put: 'test'].
	t2 checkpoint.

	"every transaction sees only its own associations since t1 and t2 overlap
		(t2 was started before the t1 checkpointed its state)"
	dict size = 100 ifFalse: [self halt].
	dict2 size = 100 ifFalse: [self halt].
	t1 commit.
	t2 commit.
	t1 := db1 newTransaction.
	t2 := db2 newTransaction.
	dict := t1 root at: 'concurrent-btree'.
	dict2 := t2 root at: 'concurrent-btree'.
	(dict lockKey: 10) ifFalse: [self halt].
	(dict2 lockKey: 10) ifTrue: [self halt].
	dict unlockKey: 10.
	(dict2 lockKey: 10) ifFalse: [self halt].
	dict2 at: 10 put: 'changed'.
	t2 commit.
	(dict lockKey: 10) ifTrue: [self halt].
	"wait for half a second to ensure that version descriptor will be reloaded"
	(Delay forMilliseconds: 501) wait.
	t1 := db1 newTransaction.
	t2 := db2 newTransaction.
	dict := t1 root at: 'concurrent-btree'.
	dict at: 10 put: 'changed-again'.
	t1 commit.
	dict2 := t2 root at: 'concurrent-btree'.
	"in t2 the value should stay as it was since the t2 was started before t1 committed"
	(dict2 at: 10) = 'changed' ifFalse: [self halt].
	(dict2 lockKey: 10) ifTrue: [self halt]] 
			ensure: 
				[db1 close.
				db2 close]!

test13
	"Test garbage collection"

	| db |
	db := OmniBase openOn: self testDir.
	[db garbageCollect] ensure: [db isNil ifFalse: [db close]]!

test14
	"Test database reorganization (garbage collection with b-tree index reorganization)."

	| db |
	db := OmniBase openOn: self testDir.
	[db garbageCollect] ensure: [db isNil ifFalse: [db close]]!

test15
	"Test database backup."

	| db t obj backupDir |
	backupDir := self testDir , '_BackupTest' 
				, ('_' , Date today printString , '_' , Time now printString 
						select: [:each | each = $_ or: [each isDigit]]).
	db := OmniBase openOn: self testDir.
	
	[t := db newTransaction.
	obj := Array with: 'to je test'.
	t makePersistent: obj.
	t root at: 'backup1' put: obj.
	obj := OmniBase newBTreeDictionary: 20.
	t makePersistent: obj.
	obj at: 'test' put: 'test'.
	t root at: 'backup2' put: obj.
	t commit.
	db createBackupOn: backupDir.
	db close.
	db := OmniBase openOn: backupDir.
	t := db newTransaction.
	(t root at: 'backup1') = (Array with: 'to je test') ifFalse: [self halt].
	((t root at: 'backup2') at: 'test') = 'test' ifFalse: [self halt]] 
			ensure: [db isNil ifFalse: [db close]]!

test16
	"Test single container compaction - file reorganization."

	| db t obj |
	db := OmniBase openOn: self testDir.
	
	[t := db newTransaction.
	obj := Array with: 'to je test'.
	t makePersistent: obj.
	t root at: 'backup1' put: obj.
	obj := OmniBase newBTreeDictionary: 20.
	t makePersistent: obj.
	obj at: 'test' put: 'test'.
	t root at: 'backup2' put: obj.
	t commit.
	db compactContainerNamed: 'Default'.
	self test5.
	db compactContainerNamed: 'Default'.
	self test5.
	db compactContainerNamed: 'Default'] 
			ensure: [db isNil ifFalse: [db close]]!

test2
	| db |
	
	[db := OmniBase openOn: self testDir.
	db numberOfClients] ensure: [db isNil ifFalse: [db close]]!

test3

	| db |
	[
		db := OmniBase openOn: self testDir.
		[ OrderedCollection newPersistent
			add: 'string object';
			add: 1;
			add: Date today ] evaluateAndCommitIn: db newTransaction.
	] ensure: [db close]!

test4

	| db txn |
	[
		db := OmniBase openOn: self testDir.
		txn := db newTransaction.
		txn makePersistent: self testCollection.
		txn commit.
	] ensure: [db close]!

test5

	| db coll |
	[
		db := OmniBase openOn: self testDir.
		[ OmniBase root
			at: 'test'
			put: self testCollection ] evaluateAndCommitIn: db newTransaction.
		coll := db newTransaction root at: 'test'.
		#( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ) do: [:i |
			(coll at: i) = (self testCollection at: i)
				ifFalse: [ self error: 'Contents does not match' ]].
	] ensure: [db close]!

test6

	| db |
	[
		db := OmniBase openOn: self testDir.
		[| coll1 coll2 str |
		coll1 := OrderedCollection new.
		coll2 := OrderedCollection new.
		str := 'This is a string'.
		coll1 add: str.
		coll2 add: str.
		OmniBase root at: 'one' put: coll1.
		OmniBase root at: 'two' put: coll2. ]
			evaluateAndCommitIn: db newTransaction.
		[| coll1 coll2 |
		coll1 := OmniBase root at: 'one'.
		coll2 := OmniBase root at: 'two'.
		(coll1 first isIdenticalTo: coll2 first)
			ifTrue: [self error: 'Objects should not be identical' ].
		]
			evaluateIn: db newTransaction.
	] ensure: [db close]!

test7

	| db |
	[
		db := OmniBase openOn: self testDir.
		[ | coll1 coll2 str |
		coll1 := OrderedCollection new.
		coll2 := OrderedCollection new.
		str := 'This is a string'.
		str makePersistent.
		coll1 add: str.
		coll2 add: str.
		OmniBase root at: 'one' put: coll1.
		OmniBase root at: 'two' put: coll2. ]
			evaluateAndCommitIn: db newTransaction.
		[ | coll1 coll2 |
		coll1 := OmniBase root at: 'one'.
		coll2 := OmniBase root at: 'two'.
		(coll1 first isIdenticalTo: coll2 first)
			ifFalse: [ self error: 'Objects should be identical' ].
		] evaluateIn: db newTransaction.
	] ensure: [db close]!

test8
	"Test if local object locking works with transactions running within one database connection."

	| db t1 t2 coll collCopy |
	
	[db := OmniBase openOn: self testDir.
	"prepare"
	
	[coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll] 
			evaluateAndCommitIn: db newTransaction.
	"test"
	t1 := db newTransaction.
	t2 := db newTransaction.
	coll := t1 root at: 'lockTest'.
	(t1 lock: coll) ifFalse: [self error: 'Object locking failed'].
	collCopy := t2 root at: 'lockTest'.
	(t2 lock: collCopy) ifTrue: [self error: 'Object locking should fail'].
	t1 abort.
	(t2 lock: collCopy) ifFalse: [self error: 'Object locking failed'].
	t1 := db newTransaction.
	coll := t1 root at: 'lockTest'.
	coll first.
	(t1 lock: coll) ifTrue: [self error: 'Object locking should fail'].
	t2 unlock: collCopy.
	t2 := db newTransaction.
	(t1 lock: coll) ifFalse: [self error: 'Object locking failed'].
	coll at: 1 put: 'Changed collection'.
	t1
		markDirty: coll;
		commit.
	collCopy := t2 root at: 'lockTest'.
	collCopy first = 'This collection will be locked' 
		ifFalse: [self error: 'Object should not change'].
	(t2 lock: collCopy) 
		ifTrue: [self error: 'Lock should fail as it is already changed in t1'].
	t2 := db newTransaction.
	coll := t2 root at: 'lockTest'.
	coll first = 'Changed collection' ifFalse: [self error: 'Object should be changed']] 
			ensure: [db close]!

test9
	"Test if object locking works with transactions running in two database connections."

	| db1 db2 t1 t2 coll collCopy |
	
	[db1 := OmniBase openOn: self testDir.
	db2 := OmniBase openOn: self testDir.
	"prepare"
	
	[coll := OrderedCollection with: 'This collection will be locked'.
	OmniBase root at: 'lockTest' put: coll] 
			evaluateAndCommitIn: db1 newTransaction.
	"test"
	t1 := db1 newTransaction.
	t2 := db2 newTransaction.
	coll := t1 root at: 'lockTest'.
	(t1 lock: coll) ifFalse: [self error: 'Object locking failed'].
	collCopy := t2 root at: 'lockTest'.
	(t2 lock: collCopy) ifTrue: [self error: 'Object locking should fail'].
	t1 abort.
	(t2 lock: collCopy) ifFalse: [self error: 'Object locking failed'].
	t1 := db1 newTransaction.
	coll := t1 root at: 'lockTest'.
	coll first.
	(t1 lock: coll) ifTrue: [self error: 'Object locking should fail'].
	t2 unlock: collCopy.
	t2 := db2 newTransaction.
	(t1 lock: coll) ifFalse: [self error: 'Object locking failed'].
	coll at: 1 put: 'Changed collection'.
	t1
		markDirty: coll;
		commit.
	collCopy := t2 root at: 'lockTest'.
	collCopy first = 'This collection will be locked' 
		ifFalse: [self error: 'Object should not change'].
	(t2 lock: collCopy) 
		ifTrue: [self error: 'Lock should fail as it is already changed in t1'].
	"wait here a little since changes are updated every half a second (500 ms)"
	(Delay forMilliseconds: 501) wait.
	t2 := db2 newTransaction.
	coll := t2 root at: 'lockTest'.
	coll first = 'Changed collection' ifFalse: [self error: 'Object should be changed']] 
			ensure: 
				[db1 close.
				db2 close]!

testAll
	self
		test1;
		test2;
		test3;
		test4;
		test5;
		test6;
		test7;
		test8;
		test9;
		test10;
		test10a;
		test11;
		test12;
		test13;
		test14;
		test15;
		test16!

testAllAgain
	self
		test2;
		test3;
		test4;
		test5;
		test6;
		test7;
		test8;
		test9;
		test10;
		test10a;
		test11;
		test12;
		test13;
		test14;
		test15;
		test16!

testCollection

	| coll |
	coll := OrderedCollection new.
	coll
		add: 1;
		add: -1;
		add: true;
		add: false;
		add: nil;
		add: 1000;
		add: -1000;
		add: 0.0;
		add: 1.0;
		add: -123.43;
		add: 13 factorial;
		add: 215345245.3425;
		add: 2 / 3;
		add: Date today;
		add: (Time fromSeconds: 20000);
		add: $a;
		add: #symbol;
		add: '';
		add: 'Hello world';
		add: self;
		add: Smalltalk;
		add: (Dictionary new at: 'key' put: 'value'; yourself);
		add: IdentityDictionary new;
		add: (Array with: 'a' with: 'b');
		add: coll.
	^coll!

testDir

	^'c:\temp\OmniBaseDolphin6'! !
!OmniBaseTester class categoriesFor: #benchmarkCommitNewObjects!public!test! !
!OmniBaseTester class categoriesFor: #test1!public!testing! !
!OmniBaseTester class categoriesFor: #test10!public!testing! !
!OmniBaseTester class categoriesFor: #test10a!public!testing! !
!OmniBaseTester class categoriesFor: #test11!public!testing! !
!OmniBaseTester class categoriesFor: #test12!public!test! !
!OmniBaseTester class categoriesFor: #test13!public!test! !
!OmniBaseTester class categoriesFor: #test14!public!test! !
!OmniBaseTester class categoriesFor: #test15!public!test! !
!OmniBaseTester class categoriesFor: #test16!public!test! !
!OmniBaseTester class categoriesFor: #test2!public!testing! !
!OmniBaseTester class categoriesFor: #test3!public!testing! !
!OmniBaseTester class categoriesFor: #test4!public!testing! !
!OmniBaseTester class categoriesFor: #test5!public!testing! !
!OmniBaseTester class categoriesFor: #test6!public!testing! !
!OmniBaseTester class categoriesFor: #test7!public!testing! !
!OmniBaseTester class categoriesFor: #test8!public!testing! !
!OmniBaseTester class categoriesFor: #test9!public!testing! !
!OmniBaseTester class categoriesFor: #testAll!public!test! !
!OmniBaseTester class categoriesFor: #testAllAgain!public!test! !
!OmniBaseTester class categoriesFor: #testCollection!public!testing! !
!OmniBaseTester class categoriesFor: #testDir!public!testing! !

