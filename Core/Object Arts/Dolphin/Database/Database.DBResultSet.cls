"Filed out from Dolphin Smalltalk 7"!

Core.SequenceableCollection subclass: #'Database.DBResultSet'
	instanceVariableNames: 'statement buffer columns'
	classVariableNames: ''
	imports: #(#{OS.ODBCRetCodes} #{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBResultSet guid: (Core.GUID fromString: '{87b4c512-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBResultSet comment: 'A DBResultSet represents the results of a <DBStatement>. This provides access to a number of rows which are instances of <DBRow> or one of its subclasses. You can navigate around the rows using #first, #next, #last and #prev. You can also access rows by their integer index in the set using #at:.

Instance Variables:
	statement		<DBStatement>. The statement which generated the result set.
	buffer		<DBRow>. Buffer holding the current row.
	cols		<Array> of <DBColAttr>. Metadata for each column.

'!
!Database.DBResultSet categoriesForClass!ODBC Interface! !
!Database.DBResultSet methodsFor!

, operand
	"Answer a new <sequencedReadableCollection> containing the elements
	of the receiver in their original order with those of the <sequencedReadableCollection>, 
	operand, appended in their original order.
	Implementation Note: Override to avoid the use of slow #size."

	^self asOrderedCollection, operand!

add: newElement
	"DBResultSets are not extensible."

	^self shouldNotImplement!

allocBuffer: anArrayOfColNums
	"Private - Allocate a buffer in the receiver to hold
	the specified column numbers in the receiver's
	result set. Answer the buffer."

	^buffer := self bufferClass new columns: (self describeCols: anArrayOfColNums)!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	Answer the receiver.
	Implementation note: Override back to Collection implementation to avoid
	slow #size."

	self do: [:element | puttableStream nextPut: element]!

approxSize
	"Private - Answer the approximate size of the receiver."

	"Implementation Note: It is very important that this be a quick calculation (indeed that 
	is the whole point of the #approxSize message). Calculating the size of a result set can 
	be slow, indeed it can involve enumerating the entire result set in the worst case, 
	and so we must override for acceptable performance."

	| rowCount |
	rowCount := self numRows.
	^rowCount < 0 ifTrue: [50] ifFalse: [rowCount]!

asArray
	"Answer an <Array> of <DBRow>s containing all the rows from the receiver.
	Implementation Note: Avoid using potentially slow #size."

	| stream |
	stream := Array writeStream: self approxSize.
	self do: [:each | stream nextPut: each].
	^stream contents!

at: anInteger
	"Answer the row at index anInteger in the receiver's result set"

	^(self moveTo: anInteger) isNil ifFalse: [buffer asObject]!

at: anInteger ifAbsent: aBlock
	"Answer the row in the result set at index anInteger, or if there is no such row,
	the result of evaluating aBlock"

	| answer |
	^(answer := self at: anInteger) isNil
		ifTrue:  [aBlock value]
		ifFalse: [answer]!

at: index put: newElement
	"DBResultSets are not updatable."

	^self shouldNotImplement!

atIndex: anInteger
  	"Answer the row at index anInteger.
	Using this method means that same code can operator on a DBResultSet or a DBDictionary."

	^self at: anInteger ifAbsent: []!

bind
	"Private - Create and 'bind' (an unbound buffer will not
	actually do any SQLBindCols, though a bound buffer will)
	a buffer to hold the all the columns in the result set"

	self bind: #()!

bind: anArrayOfColNums 
	"Private - Create and bind a buffer to hold the
	specified columns (or #() for all columns)
	as they are fetched from the result set"

	(self allocBuffer: anArrayOfColNums) bind: statement!

buffer: aDBObjBuf
	"Private - Set the receiver's buffer. Mainly used to
	pre-setup an object buffer, rather than have the
	DBResultSet dynamically allocate a buffer"

	buffer := aDBObjBuf.!

bufferClass
	"Private - Answer the buffer class to use for DBResultSets (e.g. DBBoundRow for bound buffers 
	where memory is allocated and bound using SQLBindCol, or DBUnboundRow for unbound buffers 
	which are retrieved individually)."

	^DBBoundBuffer!

close
	"Close the statement which generated the receiver."

	statement close!

collect: transformer
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer a new collection like the receiver containing the values returned by 
	transformer on each evaluation.
	Implementation Note: Override back to Collection implementation because 
	superclass implementation needs exact #size, which can be slow against 
	DBResultSets requiring that we enumerate the entire result set twice in the
	worst case."

	| answer |
	answer := self copyLike.
	self do: [:each | answer addLast: (transformer value: each)].
	^answer!

copyEmpty: anInteger
	"Private - Answer an empty copy of the receiver, with sufficient capacity for anInteger
	number of elements.
	Implementation Note: We cannot copy result sets, so answer an <OrderedCollection>."

	^self copyingClass new: anInteger!

copyFrom: start
	"Answer a copy of a subset of the receiver which starts with its element at Integer 
	index start.
	Implementation Note: Override to avoid potentially slow #size."

	| answer |
	answer := self copyLike.
	self from: start do: [:e | answer addLast: e].
	^answer!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Although the receiver is not extensible, when copying it helps to create an extensible collection to avoid the necessity of pre-calculating the size, and therefore we choose OrderedCollection."

	^OrderedCollection!

copyLike
	^self copyingClass new: self approxSize!

copySize
	"Private - Answer the size of empty copy to create when performing various
	copying/collecting transformations against the receiver.
	Implementation Note: Override because #size is slow, and we copy into
	a dynamically extensible collection."

	^self approxSize!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement concatenated to its end.
	Implementation Note: Override to avoid slow #size."

	^self asOrderedCollection addLast: newElement; yourself!

countElements
	"Private - Count, and answer, the number of elements in the receiver."

	| tally |
	tally := 0.
	self rawDo: [tally := tally + 1].
	^tally!

describeCol: anInteger
	"Answer a DBColAttr object which describes the column
	numbered anInteger in the receiver's result set"

	^statement describeCol: anInteger!

describeCols
	"Answer the list of column attributes for all of
	the columns in the receiver's result set"

	^self describeCols: #()!

describeCols: anArray 
	"Answer a list of column attributes for the columns in
	the receiver's result set specified by the column numbers
	in anArray"

	columns isNil 
		ifTrue: 
			[| num columnNumbers |
			(num := anArray size) == 0 
				ifTrue: 
					[num := self numColumns.
					columnNumbers := Interval from: 1 to: num]
				ifFalse: [columnNumbers := anArray].
			columns := statement describeCols: columnNumbers].
	^columns!

fetchScroll: orientationInteger offset: offsetInteger 
	"Private - Fetch the specified row from the receiver's
	result set. Answers true if a row was successfully
	fetched, false for end of result set, and throws an
	DBError exception if an error occurs"

	| ret |
	ret := OS.ODBCLibrary default 
				sqlFetchScroll: self statementHandle
				fetchOrientation: orientationInteger
				fetchOffset: offsetInteger.
	ret = SQL_NO_DATA ifTrue: [^nil].
	statement dbCheckException: ret.

	"Unbound buffers must now retrieve all columns, bound
	 buffers must retrieve long unbound columns"
	buffer getData: statement.
	^buffer status!

findLast: discriminator 
	"Answer the <integer> index of the last element of the receiver for which the 
	<monadicValuable> argument, discriminator, evaluates to true. If there are 
	If there are no such elements, answer 0."

	^self numRows < 0 
		ifTrue: 
			[| last |
			last := 0.
			self keysAndValuesDo: [:i :row | (discriminator value: row) ifTrue: [last := i]].
			last]
		ifFalse: [super findLast: discriminator]!

first
	"Answer the first row of the receiver"

	^self moveFirst isNil ifFalse: [buffer asObject]!

free
	"Free the statement which generated the receiver and any other
	resources associated with the receiver itself."

	statement free.
	buffer := nil!

from: start keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	from the element with <integer> index, start, inclusive. A BoundsError will be
	raised if either start or stop is out of bounds."

	| i status |
	status := self moveTo: start.
	i := start.
	[status isNil] whileFalse: 
			[operation value: i value: buffer asObject.
			status := self moveNext.
			i := i + 1]!

from: start to: stop keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments. A BoundsError will be
	raised if either start or stop is out of bounds."

	| status i |
	status := self moveTo: start.
	i := start.
	[status isNil or: [i > stop]] whileFalse: 
			[operation value: i value: buffer asObject.
			status := self moveNext.
			i := i + 1]!

hash
	"Answer the <integer> hash value for the receiver.
	Implementation Note: Override to avoid potentially slow #size."

	^columns hash!

identityIndexOf: anElement
	"Answer the index of the first occurrence of the object which is the argument 
	anElement, within the receiver. If the receiver does not contain anElement, 
	answer 0. This method is the same as #indexOf:, but uses #== for comparison."

	^self findFirst: [:e | anElement == e]!

indexOf: target
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0.
	Implementation Note: Override to avoid #size."

	^self findFirst: [:e | target = e]!

isEmpty
	"Answer true if the receiver collection contains no elements, else answer false."

	"Implementation Note: In many cases the ODBC driver cannot report the size 
	of a result set, depending on the database in question and the operation. For 
	example MS SQL Server can report the result set size for many SELECTs, but
	Access cannot. The ODBC spec. says that where the driver/DB cannot provide
	the size, SQLRowCount() should return -1. However we know of at least one driver 
	(for SQL Anywhere) that returns a negative number as an 'estimate', so we test for < 0,"

	| rowCount |
	rowCount := self numRows.
	^rowCount == 0 or: [rowCount < 0 and: [self first isNil	"Have to retrieve first row"]]!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	"Implementation Note: Subclasses should override #from:to:keysAndValuesDo: rather 
	than this method, unless they have a slow implementation of #size, or one that 
	relies on #countElements (since that uses #do: to calculate the size and may
	therefore go infinitely recursive)."

	self from: 1 keysAndValuesDo: operation!

last
	"Answer the last row of the receiver's result set"

	^self moveLast isNil ifFalse: [buffer asObject]!

lastIndexOf: target
	"Answer the <integer> index of the last element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0."

	^self findLast: [:e | target = e]!

lookup: keyInteger
	^self at: keyInteger!

moveFirst
	"Private - Scroll to the first row of the receiver's result set.
	Answer the <integer> row status value."

	^self fetchScroll: SQL_FETCH_FIRST offset: 0!

moveLast
	"Private - Scroll to the last row of the receiver's result set.
	Answer the <integer> row status value."

	^self fetchScroll: SQL_FETCH_LAST offset: 0!

moveNext
	"Private - Scroll to the next row of the receiver's result set.
	Answer the <integer> row status value."

	^self fetchScroll: SQL_FETCH_NEXT offset: 0!

movePrevious
	"Private - Scroll to the previous row of the receiver's result set.
	Answer the <integer> row status value."

	^self fetchScroll: SQL_FETCH_PREV offset: 0!

moveTo: anInteger
	"Private - Position the cursor at the specified
	row (requires extended fetch capability),
	and answer the status."

	^anInteger == 1 
		ifTrue: [self moveFirst]
		ifFalse: [self scrollTo: anInteger]!

next
	"Answer the next row of the receiver's result set, skipping any deleted rows."

	^self moveNext isNil ifFalse: [buffer asObject]!

numColumns
	"Answer the number of columns in the result set associated with the receiver's statement."

	^statement numColumns!

numRows
	"Answer the number of rows in the result set associated with the receiver's statement."

	^statement numRows!

onStartup
	"Private - The system is starting. Clear down any invalid external
	resources so that they are lazily reallocated on demand."

	buffer := nil!

previous
	"Answer the previous row of the receiver's result set"

	^self movePrevious isNil ifFalse: [buffer asObject]!

printOn: aStream
	"Print a string representation of self onto aStream"

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self describeCols;
		nextPut: $).!

rawCollect: aZeroArgBlock 
	"Private - Answer an OrderedCollection containing the
	results of evaluating aBlock with the current row
	accessible from the buffer. This method is faster
	than #collect: because the buffer is not converted to
	an object and passed to the block."

	| answer |
	answer := OrderedCollection new.
	self rawDo: [answer add: aZeroArgBlock value].
	^answer!

rawDo: aZeroArgBlock 
	"Private - Answer the receiver.  For each row in the
	receiver's result set evaluates aZeroArgBlock with
	the current row accessible from the buffer.
	Faster than #do: because the rows are not
	converted to objects."

	| status |
	status := self moveFirst.
	[status isNil] whileFalse: 
			[aZeroArgBlock value.
			status := self moveNext]!

realize
	"Private - Recreate the result set."

	self bind
!

resize: anInteger
	"DBResultSets are not extensible."

	^self shouldNotImplement!

reverse
	"Answer a new <sequencedReadableCollection> which contains the same elements
	as the receiver, but in reverse order."

	| answer |
	answer := self copyEmpty.
	self reverseDo: [:row | answer addLast: row].
	^answer!

reverseDo: operation 
	"Evaluate the <monadicValuable> argument, operation, against each 
	element of the receiver in reverse order, from end to start."

	| object |
	object := self last.
	[object isNil] whileFalse: 
			[operation value: object.
			object := self previous]!

scrollTo: anInteger
	^self fetchScroll: SQL_FETCH_ABSOLUTE offset: anInteger!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new Collection like the receiver containing only those elements for which 
	the discriminator evaluates to true.
	Implementation Note: We must override the superclass because our species is OrderedCollection
	and the Collection implementation does not work for OrderedCollections."

	| newCollection |
	newCollection := self newSelection.
	self do: [:each | (discriminator value: each) ifTrue: [newCollection add: each]].
	^newCollection!

size
	"Answer the size of the receiver's result set."

	"Implemementation Note: ODBC drivers cannot always report the number of rows for a 
	SELECT statement in which case they return -1 (SQL Anywhere's driver has a bug and 
	may return another negative number hence we test for < 0), so we must then enumerate 
	the entire result set to count the elements. This behaviour makes it necessary to override 
	a number of superclass messages to avoid the use of #size, as otherwise performance will 
	be poor."

	| rowCount |
	rowCount := self numRows.
	^rowCount < 0 ifTrue: [self countElements] ifFalse: [rowCount]!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^OrderedCollection!

statement
	"Private - Answer the statement instance variable"

	^statement
!

statement: aDBStatement
	"Private - Set the statement instance variable to aDBStatement."

	statement := aDBStatement.
	"It is assumed that the statement has already been executed."
	self bind!

statementHandle
	"Private - Answer the handle of the associated statement."

	| hStmt |
	hStmt := statement executedHandle.
	buffer isNil ifTrue: [self realize].
	^hStmt
!

with: otherCollection do: operation 
	"Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	"Implementation Note: Override because calculating the receiver's size may involve 
	enumerating the entire record set. This implementation is more efficient, but does
	mean that we won't detect any size mismatch until we have enumerated elements
	up to the size of the smaller of the two collection."

	| i |
	i := 1.
	self rawDo: 
			[operation value: buffer asObject value: (otherCollection at: i).
			i := i + 1].
	i > otherCollection size ifFalse: [^self error: 'collections are of different sizes']! !
!Database.DBResultSet categoriesFor: #,!copying!public! !
!Database.DBResultSet categoriesFor: #add:!adding!public! !
!Database.DBResultSet categoriesFor: #allocBuffer:!allocating!private! !
!Database.DBResultSet categoriesFor: #appendToStream:!double dispatch!private! !
!Database.DBResultSet categoriesFor: #approxSize!accessing!private! !
!Database.DBResultSet categoriesFor: #asArray!converting!public! !
!Database.DBResultSet categoriesFor: #at:!accessing!public! !
!Database.DBResultSet categoriesFor: #at:ifAbsent:!accessing!public! !
!Database.DBResultSet categoriesFor: #at:put:!accessing!public! !
!Database.DBResultSet categoriesFor: #atIndex:!accessing!public! !
!Database.DBResultSet categoriesFor: #bind!binding!private! !
!Database.DBResultSet categoriesFor: #bind:!binding!private! !
!Database.DBResultSet categoriesFor: #buffer:!accessing!private! !
!Database.DBResultSet categoriesFor: #bufferClass!constants!private! !
!Database.DBResultSet categoriesFor: #close!public!realizing/unrealizing! !
!Database.DBResultSet categoriesFor: #collect:!enumerating!public! !
!Database.DBResultSet categoriesFor: #copyEmpty:!copying!private! !
!Database.DBResultSet categoriesFor: #copyFrom:!copying!public! !
!Database.DBResultSet categoriesFor: #copyingClass!copying!private! !
!Database.DBResultSet categoriesFor: #copyLike!copying!private! !
!Database.DBResultSet categoriesFor: #copySize!copying!private! !
!Database.DBResultSet categoriesFor: #copyWith:!copying!public! !
!Database.DBResultSet categoriesFor: #countElements!accessing!private! !
!Database.DBResultSet categoriesFor: #describeCol:!operations!public! !
!Database.DBResultSet categoriesFor: #describeCols!accessing!public! !
!Database.DBResultSet categoriesFor: #describeCols:!accessing!public! !
!Database.DBResultSet categoriesFor: #fetchScroll:offset:!positioning!private! !
!Database.DBResultSet categoriesFor: #findLast:!public!searching! !
!Database.DBResultSet categoriesFor: #first!accessing!public! !
!Database.DBResultSet categoriesFor: #free!public!realizing/unrealizing! !
!Database.DBResultSet categoriesFor: #from:keysAndValuesDo:!enumerating!public! !
!Database.DBResultSet categoriesFor: #from:to:keysAndValuesDo:!enumerating!public! !
!Database.DBResultSet categoriesFor: #hash!comparing!public! !
!Database.DBResultSet categoriesFor: #identityIndexOf:!public!searching! !
!Database.DBResultSet categoriesFor: #indexOf:!public!searching! !
!Database.DBResultSet categoriesFor: #isEmpty!public!testing! !
!Database.DBResultSet categoriesFor: #keysAndValuesDo:!enumerating!public! !
!Database.DBResultSet categoriesFor: #last!accessing!public! !
!Database.DBResultSet categoriesFor: #lastIndexOf:!public!searching! !
!Database.DBResultSet categoriesFor: #lookup:!accessing!public! !
!Database.DBResultSet categoriesFor: #moveFirst!positioning!private! !
!Database.DBResultSet categoriesFor: #moveLast!positioning!private! !
!Database.DBResultSet categoriesFor: #moveNext!positioning!private! !
!Database.DBResultSet categoriesFor: #movePrevious!positioning!private! !
!Database.DBResultSet categoriesFor: #moveTo:!positioning!private! !
!Database.DBResultSet categoriesFor: #next!accessing!public! !
!Database.DBResultSet categoriesFor: #numColumns!accessing!public! !
!Database.DBResultSet categoriesFor: #numRows!accessing!public! !
!Database.DBResultSet categoriesFor: #onStartup!event handling!private! !
!Database.DBResultSet categoriesFor: #previous!accessing!public! !
!Database.DBResultSet categoriesFor: #printOn:!printing!public! !
!Database.DBResultSet categoriesFor: #rawCollect:!enumerating!private! !
!Database.DBResultSet categoriesFor: #rawDo:!enumerating!private! !
!Database.DBResultSet categoriesFor: #realize!binding!private! !
!Database.DBResultSet categoriesFor: #resize:!mutating!private! !
!Database.DBResultSet categoriesFor: #reverse!copying!public! !
!Database.DBResultSet categoriesFor: #reverseDo:!enumerating!public! !
!Database.DBResultSet categoriesFor: #scrollTo:!accessing!private! !
!Database.DBResultSet categoriesFor: #select:!enumerating!public! !
!Database.DBResultSet categoriesFor: #size!accessing!public! !
!Database.DBResultSet categoriesFor: #species!accessing!public! !
!Database.DBResultSet categoriesFor: #statement!accessing!private! !
!Database.DBResultSet categoriesFor: #statement:!accessing!private! !
!Database.DBResultSet categoriesFor: #statementHandle!accessing!private! !
!Database.DBResultSet categoriesFor: #with:do:!enumerating!public! !

!Database.DBResultSet class methodsFor!

new
	"Answer a new, empty, instance of the receiver"

	^self basicNew!

onStartup
	"Ensure all the receiver's subinstances are in their 'invalidated' state on startup
	so that they rebuild their external resource when required rather than attempting
	to use an old handle hanging around from the sesssion when the image was saved."

	self primAllSubinstances do: [:i | i onStartup]!

statement: aDBStatement
	"Answer a new instance of DBResultSet for aDBStatement."

	^self new
		statement: aDBStatement;
		yourself! !
!Database.DBResultSet class categoriesFor: #new!instance creation!public! !
!Database.DBResultSet class categoriesFor: #onStartup!event handling!public! !
!Database.DBResultSet class categoriesFor: #statement:!instance creation!public! !

