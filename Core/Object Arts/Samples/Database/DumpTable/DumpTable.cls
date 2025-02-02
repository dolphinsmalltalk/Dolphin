"Filed out from Dolphin Smalltalk"!

ConsoleSessionManager subclass: #DumpTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DumpTable guid: (GUID fromString: '{da1a24df-82b3-42ad-b41f-c27e026fb8a3}')!

DumpTable comment: ''!

!DumpTable categoriesForClass!Unclassified! !

!DumpTable methodsFor!

debugTraceStream
	"Private - We want to dump any ODBC driver warnings to debug output, not stderr, so answer a DebugTraceStream. We need to ensure there is a live reference to the class, to prevent it being removed on deployment."

	^DebugTraceStream current!

dumpTable: tableNameString of: dsnString on: aStream
	| connection sql query columnNames |
	connection := DBConnection new.
	connection dsn: dsnString.
	connection open.
	aStream
		nextPutAll: 'Tables in ';
		print: connection dataSourceName;
		cr;
		cr.
	connection tables do: 
			[:each |
			aStream
				tab;
				nextPutAll: each;
				cr].
	tableNameString isNil ifTrue: [^self].
	(tableNameString includes: $") ifTrue: [self usage: -2].
	sql := 'select * from "<1s>"' << tableNameString.
	query := connection query: sql.
	aStream
		cr;
		nextPutAll: tableNameString;
		nextPutAll: ' contains ';
		flush;
		print: query size;
		nextPutAll: ' rows:';
		cr;
		cr.
	columnNames := String streamContents: 
					[:strm |
					query columns do: [:each | strm nextPutAll: each name] separatedBy: [strm nextPutAll: ' | ']].
	aStream
		nextPutAll: columnNames;
		cr.
	columnNames size timesRepeat: [aStream nextPut: $=].
	aStream cr.
	query do: 
			[:eachRow |
			eachRow contents do: [:each | aStream print: each] separatedBy: [aStream nextPutAll: ' | '].
			aStream cr].
	query free.
	connection close!

main
	self argc < 2 ifTrue: [self usage: -1].
	DBWarning traceStream: self debugTraceStream.
	self
		dumpTable: (self argc > 2 ifTrue: [self argv third])
		of: self argv second
		on: self stdout!

usage: anInteger
	self stderr
		nextPutAll: 'Dolphin Smalltalk Dump Table Sample';
		cr;
		nextPutAll: 'Copyright © Object Arts Ltd, 2025.';
		crtab: 1;
		nextPutAll: 'Usage: ';
		display: self argv first;
		nextPutAll: ' <ODBC DSN> [<Table name>]';
		cr.
	self primQuit: anInteger! !

!DumpTable categoriesForMethods!
debugTraceStream!operations-startup!private! !
dumpTable:of:on:!operations-startup!public! !
main!operations-startup!public! !
usage:!operations-startup!public! !
!

